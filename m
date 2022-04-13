Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 713814FF613
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 13:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbiDMLwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 07:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235276AbiDMLwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 07:52:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361552DA96
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 04:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C454CB822A9
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 11:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 94F84C385A4;
        Wed, 13 Apr 2022 11:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649850615;
        bh=o2vJ0DnRy5ZEVYNOXmZBmFPGP50Ud7tKWsUfjrA5p3w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MVw1jAzHWNcdlnsPsMSJteexdrXXnj1FBzUfPK7zP651Fup2wgQy0Y+kDok0ES6ll
         Aq21x16zWIQC+p5W9vr0mTDXXgIPBVwZoYD4ON8Bun69DobpLNMtHr9t5eUBR3ixNx
         XGtjpddEb4PmBgR5WmyKkvUTJyp0ssBewnQTIl/yyjv3jn/qyJGqBhdNP0ftEh5eqP
         uCAKPbT4LfwcvL3ZBUiC64JlBDpzzE9r165rmv+ojbXmcQRiCBl1ETe7yy4CccMzgY
         cEXgSqm8XG7ElVEX/Zv2mGuALgx4hyDRhT9PLr++ZR4MJ+XlJ8isTpgjcjHJn6Cn5c
         lTVA94GblVG7w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7F9B5E8DD5E;
        Wed, 13 Apr 2022 11:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 00/12] net: bridge: add flush filtering support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164985061551.24768.3237766842921971085.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Apr 2022 11:50:15 +0000
References: <20220413105202.2616106-1-razor@blackwall.org>
In-Reply-To: <20220413105202.2616106-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org, roopa@nvidia.com,
        idosch@idosch.org, kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 13 Apr 2022 13:51:50 +0300 you wrote:
> Hi,
> This patch-set adds support to specify filtering conditions for a bulk
> delete (flush) operation. This version uses a new nlmsghdr delete flag
> called NLM_F_BULK in combination with a new ndo_fdb_del_bulk op which is
> used to signal that the driver supports bulk deletes (that avoids
> pushing common mac address checks to ndo_fdb_del implementations and
> also has a different prototype and parsed attribute expectations, more
> info in patch 03). The new delete flag can be used for any RTM_DEL*
> type, implementations just need to be careful with older kernels which
> are doing non-strict attribute parses. A new rtnl flag
> (RTNL_FLAG_BULK_DEL_SUPPORTED) is used to show that the delete supports
> NLM_F_BULK. A proper error is returned if bulk delete is not supported.
> For old kernels I use the fact that mac address attribute (lladdr) is
> mandatory in the classic fdb del case, but it's not allowed if bulk
> deleting so older kernels will error out.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,01/12] net: rtnetlink: add msg kind names
    https://git.kernel.org/netdev/net-next/c/12dc5c2cb7b2
  - [net-next,v4,02/12] net: rtnetlink: add helper to extract msg type's kind
    https://git.kernel.org/netdev/net-next/c/2e9ea3e30f69
  - [net-next,v4,03/12] net: rtnetlink: use BIT for flag values
    https://git.kernel.org/netdev/net-next/c/0569e31f1bc2
  - [net-next,v4,04/12] net: netlink: add NLM_F_BULK delete request modifier
    https://git.kernel.org/netdev/net-next/c/545528d78855
  - [net-next,v4,05/12] net: rtnetlink: add bulk delete support flag
    https://git.kernel.org/netdev/net-next/c/a6cec0bcd342
  - [net-next,v4,06/12] net: add ndo_fdb_del_bulk
    https://git.kernel.org/netdev/net-next/c/1306d5362a59
  - [net-next,v4,07/12] net: rtnetlink: add NLM_F_BULK support to rtnl_fdb_del
    https://git.kernel.org/netdev/net-next/c/9e83425993f3
  - [net-next,v4,08/12] net: bridge: fdb: add ndo_fdb_del_bulk
    https://git.kernel.org/netdev/net-next/c/edaef1917224
  - [net-next,v4,09/12] net: bridge: fdb: add support for fine-grained flushing
    https://git.kernel.org/netdev/net-next/c/1f78ee14eeac
  - [net-next,v4,10/12] net: rtnetlink: add ndm flags and state mask attributes
    https://git.kernel.org/netdev/net-next/c/ea2c0f9e3fc2
  - [net-next,v4,11/12] net: bridge: fdb: add support for flush filtering based on ndm flags and state
    https://git.kernel.org/netdev/net-next/c/564445fb4f0f
  - [net-next,v4,12/12] net: bridge: fdb: add support for flush filtering based on ifindex and vlan
    https://git.kernel.org/netdev/net-next/c/0dbe886a4d8d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


