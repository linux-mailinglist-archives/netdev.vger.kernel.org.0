Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED2D56AF93
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 03:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235567AbiGHAoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 20:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiGHAoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 20:44:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16A670E44;
        Thu,  7 Jul 2022 17:44:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E2D8B824B5;
        Fri,  8 Jul 2022 00:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0EDC3411E;
        Fri,  8 Jul 2022 00:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657241048;
        bh=EC7a4jTfAaizoRSMF4FsVpM10jc1Vx60by0MKMOikKI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J7buxAjoy+adEYbK2ndgRVkdH/bRZQd1xQJ83dKqMYPLqzO7K8SohPXucoAmj7lJw
         lXlK98vnwsMtyUs6cqJvdncgZSM+u8iWNEd84GaJxGEb8JwmJznOQ8diA8yX3EE+9t
         AyBc2jtDAHiy/c9qalzH/C4zpxEfR44rctLToIM/H+o6DzxW+shjErAqPIZ51BH2Tj
         w3PhcIgxKUGzp6rfEjTCNkv8zm+iHrtWRB+8L8NEZ7Mv9xOAjzyEzGVOLdus18aNvi
         qFBhYl1bIalHBXubutm/9Fbfkaocgls6Zfa3BLkpbMVdpgT4B7+bPE8Q+LLXcKle9S
         rXNUZKZHDb9sw==
Date:   Thu, 7 Jul 2022 17:43:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hans Schultz <netdev@kapio-technology.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next 1/1] net: dsa: mv88e6xxx: allow reading FID
 when handling ATU violations
Message-ID: <20220707174358.3b1b804a@kernel.org>
In-Reply-To: <20220707102836.u7ig6rr2664mcrlf@skbuf>
References: <20220706122502.1521819-1-netdev@kapio-technology.com>
        <20220707102836.u7ig6rr2664mcrlf@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jul 2022 13:28:36 +0300 Vladimir Oltean wrote:
> Make no mistake, the existing code doesn't disallow reading back the FID
> during an ATU Get/Clear Violation operation, and your patch isn't
> "allowing" something that wasn't disallowed.
> 
> The documentation for the ATU FID register says that its contents is
> ignored before the operation starts, and it contains the returned ATU
> entry's FID after the operation completes.
> 
> So the change simply says: don't bother to write the ATU FID register
> with zero, it doesn't matter what this contains. This is probably true,
> but the patch needs to do what's written on the box.
> 
> Please note that this only even matters at all for switches with
> mv88e6xxx_num_databases(chip) > 256, where MV88E6352_G1_ATU_FID is a
> dedicated register which this patch avoids writing. For other switches,
> the FID is embedded within MV88E6XXX_G1_ATU_CTL or MV88E6XXX_G1_ATU_OP.
> So _practically_, for those switches, you are still emitting the
> GET_CLR_VIOLATION ATU op with a FID of 0 whether you like it or not, and
> this patch introduces a (most likely irrelevant) discrepancy between the
> access methods for various switches.
> 
> Please note that this observation is relevant for your future changes to
> read back the FID too. As I said here:
> https://patchwork.kernel.org/project/netdevbpf/patch/20220524152144.40527-4-schultz.hans+netdev@gmail.com/#24912482
> you can't just assume that the FID lies within the MV88E6352_G1_ATU_FID
> register, just look at the way it is packed within mv88e6xxx_g1_atu_op().
> You'll need to unpack it in the same way.

I reckon it'll be useful to render some of this info into the commit
message and adjust the subject so marking Changes Requested.
