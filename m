Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7AD664443E
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 14:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbiLFNMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 08:12:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiLFNMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 08:12:34 -0500
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A41028B
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 05:12:28 -0800 (PST)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-3cbdd6c00adso150952317b3.11
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 05:12:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oevO7JyhyKimedWouEO3Q5ROMWH7Biq6JzX+MMX5R2U=;
        b=qrcFrylKvNL3cLiDJyZKvYJ7ic6qwT5uG9urcFVSv237ZeUPjYR+vHp8w8jVu2SyaK
         FrNb+eh5E8s3up1QnoqzcciMGY1vG2XZwzQgmAipaLXVRAozIbSLAN6MuoExQaJHMKTq
         Em+VFI+IocppAJRBa+ZbhsFAVHvm09i2fxeQooA51mDsoiScj4PJRt8fLkrZVk+mTOwX
         EQzc8z8mZfC/F/UWrHR2GJsMgX1DlJyhiSO5E4Jg3qBR5MDNy8okG55FWeG4FjKaAwTr
         qJkKIhZICBSXHa/IMml0Ukn7aXCArABkaSYhda4HC4LdnyIU2KD7rFadiYpYOVnIu37q
         RKAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oevO7JyhyKimedWouEO3Q5ROMWH7Biq6JzX+MMX5R2U=;
        b=ogVv7o4z45Jf/Ymi4oezryqR4rM2OB/mnyo6rqiGllTsBJu+KIFyB+crzsJS89aFrC
         ZgLVTmPP+JytEgEl0gtdkvaoYotebAT15xeUEg+K/MdSqwmwSMd0I2dOM8qrRiYj04Zn
         Apson7LGYRSVyZLQNKtowKSHOHxxttCycliA73h6zbqt3Ht7cc/rchDXRDFKS6GpUooF
         5UzKHZYKFB842uymbuRKFrKcO9dC3upv8o8W6oDC1Ph0krMqGyQgQ5eUBZ6Xh6w3gVFJ
         Qs8HgdyhZ2JtROhtYRp6VyvSmPnIoSqVhIb3kDM4/PdUIGZUN+0GakkJRXxPbmyW/qOW
         ZTYw==
X-Gm-Message-State: ANoB5pmWpwfaugnUz0ECNFbGdVFoJf7HJbtFb8ka4iRZmZuk7rPGcxh5
        8mPhq0fiMXjUH2oyoYLDJtJEdj6hn4DKaqTyfguFOw==
X-Google-Smtp-Source: AA0mqf7TXhFfSq/W8S7kPWOAXUIU3623FZnO1A4V/rd1ObeASPAGyP8CJtbcqWAjn5vEGV+TqoK5imJ+aNt7YVppoLA=
X-Received: by 2002:a81:1e44:0:b0:370:7a9a:564 with SMTP id
 e65-20020a811e44000000b003707a9a0564mr16531305ywe.278.1670332347156; Tue, 06
 Dec 2022 05:12:27 -0800 (PST)
MIME-Version: 1.0
References: <20221206125827.1832477-1-pctammela@mojatatu.com> <20221206125827.1832477-3-pctammela@mojatatu.com>
In-Reply-To: <20221206125827.1832477-3-pctammela@mojatatu.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 6 Dec 2022 14:12:15 +0100
Message-ID: <CANn89iJihepC5ez1TomOZJd-Vhq6=mYWf04vuOUt=CDDDj7W8A@mail.gmail.com>
Subject: Re: [PATCH net-next v5 2/4] net/sched: add retpoline wrapper for tc
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuniyu@amazon.com,
        Victor Nogueira <victor@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 6, 2022 at 1:58 PM Pedro Tammela <pctammela@mojatatu.com> wrote:
>
> On kernels using retpoline as a spectrev2 mitigation,
> optimize actions and filters that are compiled as built-ins into a direct call.
>
> On subsequent patches we expose the classifiers and actions functions
> and wire up the wrapper into tc.
>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Reviewed-by: Victor Nogueira <victor@mojatatu.com>
> ---
>  include/net/tc_wrapper.h | 250 +++++++++++++++++++++++++++++++++++++++
>  net/sched/act_api.c      |   2 +
>  net/sched/cls_api.c      |   2 +
>  3 files changed, 254 insertions(+)
>  create mode 100644 include/net/tc_wrapper.h
>
> diff --git a/include/net/tc_wrapper.h b/include/net/tc_wrapper.h
> new file mode 100644
> index 000000000000..429ebd7255b4
> --- /dev/null
> +++ b/include/net/tc_wrapper.h
> @@ -0,0 +1,250 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __NET_TC_WRAPPER_H
> +#define __NET_TC_WRAPPER_H
> +
> +#include <net/pkt_cls.h>
> +
> +#if IS_ENABLED(CONFIG_RETPOLINE)
> +
> +#include <asm/cpufeature.h>
> +
> +#include <linux/static_key.h>
> +#include <linux/indirect_call_wrapper.h>
> +
> +#define TC_INDIRECT_SCOPE
> +
> +static DEFINE_STATIC_KEY_FALSE(tc_skip_wrapper);

I guess this should not be static.
 A single key should be shared by all users.
In the include file, you probably should have:

extern struct static_key_false tc_skip_wrapper;

> +
> +/* TC Actions */
> +#ifdef CONFIG_NET_CLS_ACT
> +
> +#define TC_INDIRECT_ACTION_DECLARE(fname)                              \
> +       INDIRECT_CALLABLE_DECLARE(int fname(struct sk_buff *skb,       \
> +                                           const struct tc_action *a, \
> +                                           struct tcf_result *res))
> +
> +TC_INDIRECT_ACTION_DECLARE(tcf_bpf_act);
> +TC_INDIRECT_ACTION_DECLARE(tcf_connmark_act);
> +TC_INDIRECT_ACTION_DECLARE(tcf_csum_act);
> +TC_INDIRECT_ACTION_DECLARE(tcf_ct_act);
> +TC_INDIRECT_ACTION_DECLARE(tcf_ctinfo_act);
> +TC_INDIRECT_ACTION_DECLARE(tcf_gact_act);
> +TC_INDIRECT_ACTION_DECLARE(tcf_gate_act);
> +TC_INDIRECT_ACTION_DECLARE(tcf_ife_act);
> +TC_INDIRECT_ACTION_DECLARE(tcf_ipt_act);
> +TC_INDIRECT_ACTION_DECLARE(tcf_mirred_act);
> +TC_INDIRECT_ACTION_DECLARE(tcf_mpls_act);
> +TC_INDIRECT_ACTION_DECLARE(tcf_nat_act);
> +TC_INDIRECT_ACTION_DECLARE(tcf_pedit_act);
> +TC_INDIRECT_ACTION_DECLARE(tcf_police_act);
> +TC_INDIRECT_ACTION_DECLARE(tcf_sample_act);
> +TC_INDIRECT_ACTION_DECLARE(tcf_simp_act);
> +TC_INDIRECT_ACTION_DECLARE(tcf_skbedit_act);
> +TC_INDIRECT_ACTION_DECLARE(tcf_skbmod_act);
> +TC_INDIRECT_ACTION_DECLARE(tcf_vlan_act);
> +TC_INDIRECT_ACTION_DECLARE(tunnel_key_act);
> +
> +static inline int tc_act(struct sk_buff *skb, const struct tc_action *a,
> +                          struct tcf_result *res)
> +{
> +       if (static_branch_likely(&tc_skip_wrapper))
> +               goto skip;
> +
> +#if IS_BUILTIN(CONFIG_NET_ACT_GACT)
> +       if (a->ops->act == tcf_gact_act)
> +               return tcf_gact_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_MIRRED)
> +       if (a->ops->act == tcf_mirred_act)
> +               return tcf_mirred_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_PEDIT)
> +       if (a->ops->act == tcf_pedit_act)
> +               return tcf_pedit_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_SKBEDIT)
> +       if (a->ops->act == tcf_skbedit_act)
> +               return tcf_skbedit_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_SKBMOD)
> +       if (a->ops->act == tcf_skbmod_act)
> +               return tcf_skbmod_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_POLICE)
> +       if (a->ops->act == tcf_police_act)
> +               return tcf_police_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_BPF)
> +       if (a->ops->act == tcf_bpf_act)
> +               return tcf_bpf_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_CONNMARK)
> +       if (a->ops->act == tcf_connmark_act)
> +               return tcf_connmark_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_CSUM)
> +       if (a->ops->act == tcf_csum_act)
> +               return tcf_csum_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_CT)
> +       if (a->ops->act == tcf_ct_act)
> +               return tcf_ct_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_CTINFO)
> +       if (a->ops->act == tcf_ctinfo_act)
> +               return tcf_ctinfo_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_GATE)
> +       if (a->ops->act == tcf_gate_act)
> +               return tcf_gate_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_MPLS)
> +       if (a->ops->act == tcf_mpls_act)
> +               return tcf_mpls_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_NAT)
> +       if (a->ops->act == tcf_nat_act)
> +               return tcf_nat_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_TUNNEL_KEY)
> +       if (a->ops->act == tunnel_key_act)
> +               return tunnel_key_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_VLAN)
> +       if (a->ops->act == tcf_vlan_act)
> +               return tcf_vlan_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_IFE)
> +       if (a->ops->act == tcf_ife_act)
> +               return tcf_ife_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_IPT)
> +       if (a->ops->act == tcf_ipt_act)
> +               return tcf_ipt_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_SIMP)
> +       if (a->ops->act == tcf_simp_act)
> +               return tcf_simp_act(skb, a, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_ACT_SAMPLE)
> +       if (a->ops->act == tcf_sample_act)
> +               return tcf_sample_act(skb, a, res);
> +#endif
> +
> +skip:
> +       return a->ops->act(skb, a, res);
> +}
> +
> +#endif /* CONFIG_NET_CLS_ACT */
> +
> +/* TC Filters */
> +#ifdef CONFIG_NET_CLS
> +
> +#define TC_INDIRECT_FILTER_DECLARE(fname)                               \
> +       INDIRECT_CALLABLE_DECLARE(int fname(struct sk_buff *skb,        \
> +                                           const struct tcf_proto *tp, \
> +                                           struct tcf_result *res))
> +
> +TC_INDIRECT_FILTER_DECLARE(basic_classify);
> +TC_INDIRECT_FILTER_DECLARE(cls_bpf_classify);
> +TC_INDIRECT_FILTER_DECLARE(cls_cgroup_classify);
> +TC_INDIRECT_FILTER_DECLARE(fl_classify);
> +TC_INDIRECT_FILTER_DECLARE(flow_classify);
> +TC_INDIRECT_FILTER_DECLARE(fw_classify);
> +TC_INDIRECT_FILTER_DECLARE(mall_classify);
> +TC_INDIRECT_FILTER_DECLARE(route4_classify);
> +TC_INDIRECT_FILTER_DECLARE(rsvp_classify);
> +TC_INDIRECT_FILTER_DECLARE(rsvp6_classify);
> +TC_INDIRECT_FILTER_DECLARE(tcindex_classify);
> +TC_INDIRECT_FILTER_DECLARE(u32_classify);
> +
> +static inline int tc_classify(struct sk_buff *skb, const struct tcf_proto *tp,
> +                               struct tcf_result *res)
> +{
> +       if (static_branch_likely(&tc_skip_wrapper))
> +               goto skip;
> +
> +#if IS_BUILTIN(CONFIG_NET_CLS_BPF)
> +       if (tp->classify == cls_bpf_classify)
> +               return cls_bpf_classify(skb, tp, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_CLS_U32)
> +       if (tp->classify == u32_classify)
> +               return u32_classify(skb, tp, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_CLS_FLOWER)
> +       if (tp->classify == fl_classify)
> +               return fl_classify(skb, tp, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_CLS_FW)
> +       if (tp->classify == fw_classify)
> +               return fw_classify(skb, tp, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_CLS_MATCHALL)
> +       if (tp->classify == mall_classify)
> +               return mall_classify(skb, tp, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_CLS_BASIC)
> +       if (tp->classify == basic_classify)
> +               return basic_classify(skb, tp, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_CLS_CGROUP)
> +       if (tp->classify == cls_cgroup_classify)
> +               return cls_cgroup_classify(skb, tp, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_CLS_FLOW)
> +       if (tp->classify == flow_classify)
> +               return flow_classify(skb, tp, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_CLS_ROUTE4)
> +       if (tp->classify == route4_classify)
> +               return route4_classify(skb, tp, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_CLS_RSVP)
> +       if (tp->classify == rsvp_classify)
> +               return rsvp_classify(skb, tp, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_CLS_RSVP6)
> +       if (tp->classify == rsvp6_classify)
> +               return rsvp6_classify(skb, tp, res);
> +#endif
> +#if IS_BUILTIN(CONFIG_NET_CLS_TCINDEX)
> +       if (tp->classify == tcindex_classify)
> +               return tcindex_classify(skb, tp, res);
> +#endif
> +
> +skip:
> +       return tp->classify(skb, tp, res);
> +}
> +
> +static inline void tc_wrapper_init(void)
> +{
> +       if (!cpu_feature_enabled(X86_FEATURE_RETPOLINE))
> +               static_branch_enable(&tc_skip_wrapper);

This is CONFIG_X86 specific.

> +}
> +
> +#endif /* CONFIG_NET_CLS */
> +
> +#else
> +
> +#define TC_INDIRECT_SCOPE static
> +
> +static inline int tc_act(struct sk_buff *skb, const struct tc_action *a,
> +                          struct tcf_result *res)
> +{
> +       return a->ops->act(skb, a, res);
> +}
> +
> +static inline int tc_classify(struct sk_buff *skb, const struct tcf_proto *tp,
> +                               struct tcf_result *res)
> +{
> +       return tp->classify(skb, tp, res);
> +}
> +
> +static inline void tc_wrapper_init(void)
> +{
> +}
> +
> +#endif
> +
> +#endif /* __NET_TC_WRAPPER_H */
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index 9b31a10cc639..9f4c0f5f45c1 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -2178,6 +2178,8 @@ static int __init tc_action_init(void)
>         rtnl_register(PF_UNSPEC, RTM_GETACTION, tc_ctl_action, tc_dump_action,
>                       0);
>
> +       tc_wrapper_init();
> +
>         return 0;
>  }
>
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 23d1cfa4f58c..a2c276116244 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3764,6 +3764,8 @@ static int __init tc_filter_init(void)
>         rtnl_register(PF_UNSPEC, RTM_GETCHAIN, tc_ctl_chain,
>                       tc_dump_chain, 0);
>
> +       tc_wrapper_init();
> +
>         return 0;
>
>  err_register_pernet_subsys:
> --
> 2.34.1
>
