Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DACA667A92C
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 04:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233585AbjAYDYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 22:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjAYDYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 22:24:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095E0521D9;
        Tue, 24 Jan 2023 19:24:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98A58B80E86;
        Wed, 25 Jan 2023 03:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93D0C433D2;
        Wed, 25 Jan 2023 03:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674617079;
        bh=+n3J9w9O2587dakBFNHT9EMbV+TmVacJsDTzzUdYS58=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IwJ680KedhOQcxVTzXwv6j2pQ2LJfdsECGKBfOsKHoY5PaOcTlrm4j5KgxqBCNhpf
         QiECopDHmi4YfnLuG8oAZ5nfu1JMn33Ji2zYrY7UOwgoTEKqIYSRkibitMXIownEyB
         m0IZwQdb0kdpidaEDwYnD/F0aF6GJ66aC5glmsQmiHtvs0kVL5yEG18BgOm7Ni3U/z
         MUubJ0VEzIOlD3nGE1CpYgEBlJovrQmXxqRaPnyYjnO9oCR3hI2G8Yda4udm19lG6T
         3ZjfSPlECn7xlw2DvLiV2cmiJ6Hb+vWxjkDYSXfodTymYyIfXvRxexs9R1fSUWkVVY
         e1ljWJoBBhahw==
Date:   Tue, 24 Jan 2023 19:24:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        pabeni@redhat.com, edumazet@google.com, a@unstable.cc,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] ip/ip6_gre: Fix changing addr gen mode not
 generating IPv6 link local address
Message-ID: <20230124192437.6d33cc06@kernel.org>
In-Reply-To: <20230124032105.79487-4-Thomas.Winter@alliedtelesis.co.nz>
References: <20230124032105.79487-1-Thomas.Winter@alliedtelesis.co.nz>
        <20230124032105.79487-4-Thomas.Winter@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Jan 2023 16:21:04 +1300 Thomas Winter wrote:
> Commit e5dd729460ca changed the code path so that GRE tunnels
> generate an IPv6 address based on the tunnel source address.
> It also changed the code path so GRE tunnels don't call addrconf_addr_gen
> in addrconf_dev_config which is called by addrconf_sysctl_addr_gen_mode
> when the IN6_ADDR_GEN_MODE is changed.
> 
> This patch aims to fix this issue by moving the code in addrconf_notify
> which calls the addr gen for GRE and SIT into a separate function
> and calling it in the places that expect the IPv6 address to be
> generated.
> 
> The previous addrconf_dev_config is renamed to addrconf_eth_config
> since it only expected eth type interfaces and follows the
> addrconf_gre/sit_config format.

The commit message reads like a description of the code changes, 
not the problem statement + extra context it should be.

Please start with a solid description of what the problem you're seeing
is, without referring to the implementation / code at all.

You should also mention why changing the code flow for LOOPBACK is safe
as it's not visible in the patch itself. And I think the subject should
be more broad than just GRE, since you also fix SIT.

Similar comments to a smaller extent for the second patch.

When you repost please make a fresh thread.
