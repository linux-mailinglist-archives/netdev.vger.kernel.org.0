Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E154E5FD2FD
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 03:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiJMBu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 21:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiJMBuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 21:50:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44CB288DEA
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 18:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E08ECB81CF0
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 01:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 887B7C4347C;
        Thu, 13 Oct 2022 01:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665625816;
        bh=hLjnv4mrVLh5HMxyot5Mx3Iq70N97EgA069cYJUiqJ4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ri9cscau/6UeuFc/hP7PMSALWfotmGZmdugUMjKvVdvW7HRxbP/TDTtFZXvXuF63r
         y5lwOxVZTo80527I/IRr32W2odq8rT6YNZDKjvCUSH6SNz0yh5B78zSarRwvB/uSXv
         ckN1go3PKcZTD8EEAn3PPC8JS93lDbOID01jsdqEgZEDkg0cUe5MowMkwyDDk1jBpb
         nEhkx0nzlmnELNIDcESEC1DHT/w1g9ATSBFwrhzleiThg3zSLIAwddBin9yIA9ZFbO
         IIXg0ZY1eRegMbH4auIB026GAcDELykO0XUl/eHkKB7nmtSC82cvVu7IqyyOaTtits
         CsHZcJPCL+XXg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6E8FCE29F35;
        Thu, 13 Oct 2022 01:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] openvswitch: add nf_ct_is_confirmed check before
 assigning the helper
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166562581644.26155.16251877521132982468.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Oct 2022 01:50:16 +0000
References: <c5c9092a22a2194650222bffaf786902613deb16.1665085502.git.lucien.xin@gmail.com>
In-Reply-To: <c5c9092a22a2194650222bffaf786902613deb16.1665085502.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        pshelar@ovn.org, fw@strlen.de, pablo@netfilter.org,
        i.maximets@ovn.org, echaudro@redhat.com, yihung.wei@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  6 Oct 2022 15:45:02 -0400 you wrote:
> A WARN_ON call trace would be triggered when 'ct(commit, alg=helper)'
> applies on a confirmed connection:
> 
>   WARNING: CPU: 0 PID: 1251 at net/netfilter/nf_conntrack_extend.c:98
>   RIP: 0010:nf_ct_ext_add+0x12d/0x150 [nf_conntrack]
>   Call Trace:
>    <TASK>
>    nf_ct_helper_ext_add+0x12/0x60 [nf_conntrack]
>    __nf_ct_try_assign_helper+0xc4/0x160 [nf_conntrack]
>    __ovs_ct_lookup+0x72e/0x780 [openvswitch]
>    ovs_ct_execute+0x1d8/0x920 [openvswitch]
>    do_execute_actions+0x4e6/0xb60 [openvswitch]
>    ovs_execute_actions+0x60/0x140 [openvswitch]
>    ovs_packet_cmd_execute+0x2ad/0x310 [openvswitch]
>    genl_family_rcv_msg_doit.isra.15+0x113/0x150
>    genl_rcv_msg+0xef/0x1f0
> 
> [...]

Here is the summary with links:
  - [net] openvswitch: add nf_ct_is_confirmed check before assigning the helper
    https://git.kernel.org/netdev/net/c/3c1860543fcc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


