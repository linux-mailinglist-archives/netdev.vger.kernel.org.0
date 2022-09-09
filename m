Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFA65B30DC
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 09:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbiIIHvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 03:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiIIHvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 03:51:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBED1174BD;
        Fri,  9 Sep 2022 00:46:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A848961ED7;
        Fri,  9 Sep 2022 07:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED3B9C433D6;
        Fri,  9 Sep 2022 07:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662709223;
        bh=pHXy56aDF2az8BwZxI+XLJb3ggz5lGK8+mTB9ISoNnw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SJs2YwDP4JwI7jnFncUO72J4wilgAD96BVYO3qGd5YG0GzBepzAbh5FCVbW6/Rric
         hlJUleW6Krg09ATSAuQmb43t68LyAKuwujtgKaylLYDeQ/zlknSgQ1gJ/CFbPC3n+U
         T83zQw4eQPI1Zd4KsfZ0DpkBMHsXNnBt5GdIfMhqtKrw8ebOPFQBNzPhJz/kZWnPd6
         ESxOxMomFLt0fIMh/cj8dMpH6gEnzO4VXkBaiV49cGIrPd7n0+0AEUxGrNLTWrq7JZ
         GKaPi290LcSay7ruWbgjWiSYvK3DhArXwMBsDSXfphVOD2U2yrJWMNPNvPSgJhwhXz
         fhoyoGqtWN6EQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CBCEEC73FE9;
        Fri,  9 Sep 2022 07:40:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next,v3 00/22] refactor the walk and lookup hook functions
 in tc_action_ops
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166270922282.30497.2669983559309642268.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Sep 2022 07:40:22 +0000
References: <20220908041454.365070-1-shaozhengchao@huawei.com>
In-Reply-To: <20220908041454.365070-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, martin.lau@linux.dev,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        andrii@kernel.org, song@kernel.org, yhs@fb.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
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

On Thu, 8 Sep 2022 12:14:32 +0800 you wrote:
> The implementation logic of the walk/lookup hook function in each action
> module is the same. Therefore, the two functions can be reconstructed.
> When registering tc_action_ops of each action module, the corresponding
> net_id is saved to tc_action_ops. In this way, the net_id of the
> corresponding module can be directly obtained in act_api without executing
> the specific walk and lookup hook functions. Then, generic functions can
> be added to replace the walk and lookup hook functions of each action
> module. Last, modify each action module in alphabetical order.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,01/22] net: sched: act: move global static variable net_id to tc_action_ops
    https://git.kernel.org/netdev/net-next/c/acd0a7ab6334
  - [net-next,v3,02/22] net: sched: act_api: implement generic walker and search for tc action
    https://git.kernel.org/netdev/net-next/c/fae52d932338
  - [net-next,v3,03/22] net: sched: act_bpf: get rid of tcf_bpf_walker and tcf_bpf_search
    https://git.kernel.org/netdev/net-next/c/aa0a92f7458c
  - [net-next,v3,04/22] net: sched: act_connmark: get rid of tcf_connmark_walker and tcf_connmark_search
    https://git.kernel.org/netdev/net-next/c/c4d2497032ae
  - [net-next,v3,05/22] net: sched: act_csum: get rid of tcf_csum_walker and tcf_csum_search
    https://git.kernel.org/netdev/net-next/c/d2388df33b36
  - [net-next,v3,06/22] net: sched: act_ct: get rid of tcf_ct_walker and tcf_ct_search
    https://git.kernel.org/netdev/net-next/c/cb967ace0acc
  - [net-next,v3,07/22] net: sched: act_ctinfo: get rid of tcf_ctinfo_walker and tcf_ctinfo_search
    https://git.kernel.org/netdev/net-next/c/d51145dafd50
  - [net-next,v3,08/22] net: sched: act_gact: get rid of tcf_gact_walker and tcf_gact_search
    https://git.kernel.org/netdev/net-next/c/eeb3f43e05c0
  - [net-next,v3,09/22] net: sched: act_gate: get rid of tcf_gate_walker and tcf_gate_search
    https://git.kernel.org/netdev/net-next/c/ae3f9fc308d5
  - [net-next,v3,10/22] net: sched: act_ife: get rid of tcf_ife_walker and tcf_ife_search
    https://git.kernel.org/netdev/net-next/c/ad0cd0a85cd7
  - [net-next,v3,11/22] net: sched: act_ipt: get rid of tcf_ipt_walker/tcf_xt_walker and tcf_ipt_search/tcf_xt_search
    https://git.kernel.org/netdev/net-next/c/0a4c06f20d76
  - [net-next,v3,12/22] net: sched: act_mirred: get rid of tcf_mirred_walker and tcf_mirred_search
    https://git.kernel.org/netdev/net-next/c/d58efc6ecce8
  - [net-next,v3,13/22] net: sched: act_mpls: get rid of tcf_mpls_walker and tcf_mpls_search
    https://git.kernel.org/netdev/net-next/c/7fadae53aa86
  - [net-next,v3,14/22] net: sched: act_nat: get rid of tcf_nat_walker and tcf_nat_search
    https://git.kernel.org/netdev/net-next/c/586fab138659
  - [net-next,v3,15/22] net: sched: act_pedit: get rid of tcf_pedit_walker and tcf_pedit_search
    https://git.kernel.org/netdev/net-next/c/b915d86981fe
  - [net-next,v3,16/22] net: sched: act_police: get rid of tcf_police_walker and tcf_police_search
    https://git.kernel.org/netdev/net-next/c/0abf7f8f82bb
  - [net-next,v3,17/22] net: sched: act_sample: get rid of tcf_sample_walker and tcf_sample_search
    https://git.kernel.org/netdev/net-next/c/400d66332cd4
  - [net-next,v3,18/22] net: sched: act_simple: get rid of tcf_simp_walker and tcf_simp_search
    https://git.kernel.org/netdev/net-next/c/5d6e9cb5c916
  - [net-next,v3,19/22] net: sched: act_skbedit: get rid of tcf_skbedit_walker and tcf_skbedit_search
    https://git.kernel.org/netdev/net-next/c/038725f9eed6
  - [net-next,v3,20/22] net: sched: act_skbmod: get rid of tcf_skbmod_walker and tcf_skbmod_search
    https://git.kernel.org/netdev/net-next/c/8a35c5df28aa
  - [net-next,v3,21/22] net: sched: act_tunnel_key: get rid of tunnel_key_walker and tunnel_key_search
    https://git.kernel.org/netdev/net-next/c/f6ffa368f061
  - [net-next,v3,22/22] net: sched: act_vlan: get rid of tcf_vlan_walker and tcf_vlan_search
    https://git.kernel.org/netdev/net-next/c/6d13a65d2a67

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


