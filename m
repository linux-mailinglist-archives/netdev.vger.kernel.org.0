Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5437D5B8F96
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 22:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiINUMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 16:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiINUMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 16:12:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0F986728;
        Wed, 14 Sep 2022 13:12:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E82E7616F9;
        Wed, 14 Sep 2022 20:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DF1C433D6;
        Wed, 14 Sep 2022 20:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663186325;
        bh=2IVPGS4OQm5pgzozqCAv/jlmcO6bqifAOrhHxOZ4B/U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mSnujJ8Mymofyjqc5+9blBCnJLMpxbbkQU7Z2NB9vnXI3/EkNu3S6AdcWcGEE88tT
         zqB73PHxerH9RRt4u+/6R0GMeAXgcuCXGUMxxqID3M+eFnYVGqSWIpnzoTiBRd63s5
         PltLZnrTa5B3YdAyXmF76/P5qyqJEKgoGK1IMt+3nBtgWtRkzmnS6mtL2gFndYOpjQ
         4y3m5Hy1rcCouas0kdvFfGaHcOVPeM2ramM1JhFFD8Rc4LPPL46aPLeAgfppnPd99G
         4+QbxJTWUAm02unGGNEt8U1LB02hApcWHEjiMYtDp76UV9zFlJ81M0HtqUEGhWmMW6
         /SaZUVsL/slCA==
Received: by pali.im (Postfix)
        id 8E14C7B8; Wed, 14 Sep 2022 22:12:02 +0200 (CEST)
Date:   Wed, 14 Sep 2022 22:12:02 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: Regression: qca8k_sw_probe crashes (Was: Re: [net-next PATCH v5
 01/14] net: dsa: qca8k: cache match data to speed up access)
Message-ID: <20220914201202.pijocnpk6ng5cifz@pali>
References: <20220727113523.19742-1-ansuelsmth@gmail.com>
 <20220727113523.19742-2-ansuelsmth@gmail.com>
 <20220914200641.zvib2kpo2t26u6ai@pali>
 <20220914200857.fgkgflzm3nz5odwj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220914200857.fgkgflzm3nz5odwj@skbuf>
User-Agent: NeoMutt/20180716
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 14 September 2022 23:08:57 Vladimir Oltean wrote:
> On Wed, Sep 14, 2022 at 10:06:41PM +0200, Pali Rohár wrote:
> > Hello! This commit is causing kernel crash on powerpc P2020 based board
> > with QCA8337N-AL3C switch.
> > So function of_device_get_match_data() takes as its argument NULL
> > pointer as 'priv' structure is at this stage zeroed, and which cause
> > above kernel crash. priv->dev is filled lines below:
> 
> Thanks for the report, it was solved in 'net':
> https://patchwork.kernel.org/project/netdevbpf/patch/20220904215319.13070-1-ansuelsmth@gmail.com/

Ou, I did not know that there is already fix. Quick look did not found
anything for qca8k_sw_probe. So sorry for the noise.
