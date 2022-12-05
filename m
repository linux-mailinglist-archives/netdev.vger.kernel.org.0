Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D52AC642E93
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 18:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbiLERX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 12:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbiLERX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 12:23:26 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7948B63DC
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 09:23:25 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id d128so15326455ybf.10
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 09:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=u7DALn6YJ91hCJ6DhaegfrEN/nsHxi4kaqnBuBZM/6c=;
        b=ePAb41hu7bNeENouChJCOPV42gfUVe+ubAJGR4y4IrIcKx3AznFi18UyWdh3t9JCER
         rwC2zAlgAgt+afYkpwZDOq6w8J8Qu9NRZmZ7O5GSJHeepdTyIJxK2XPRfPgeiYR/Mb9R
         v9ltFDPYjtU5FNs+NfD7Juve4x7mxZrpOqcTniV8840rfm5qPs/wFtnPE3qqLReMsR9x
         drCSJT2MlDECLCQzkibTmD0fojhPYy+9n019rDuFeOaMI8AICw6QEusphU3UJxazeqlb
         Zv1ab9b7lg4RjsCeeeSldPeDo9bIJTO6VRIZCJpstdnyC6bI/I51ePvOT6vT0ueP9Es2
         RO0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u7DALn6YJ91hCJ6DhaegfrEN/nsHxi4kaqnBuBZM/6c=;
        b=ikVqcAaDPKkHMUbtZDQL9xyniWXmiUtuL+9+7RSiv7e8nIXmQe1+JQCU8Y6l0f67hQ
         qh7+g4AqhIBkTWotUULnbxvM+4NktnXYUOQToiixXPOpIV24g2BqhhUI6mtPXbHfWz4t
         fySUJnR5clpQwzCYB3kXELeavZ3K1OQYAAd9NDUTPs/jKnr/DZVrAiO1XyVs5ZOq4b50
         u8i3FKg0BNfPi4/30kr0Qg8cIy4mU9vb6sX5wfYBDYiHHQxBXVvxrToXfDvLepXfzIW3
         zqoQw5EzLr75bk2j6mLcgIXlsiG4SZ8BeJQvaXX2QGbeqT014GUIDwXPjKmcyg3tBgRT
         1CBw==
X-Gm-Message-State: ANoB5pkn2G3rq5sH+tDI5WZN/3JPdD4fAkuWNmctRrF3CopN8Vcfk0De
        YbUH2qwXcvsaSRNT0zrbfsVYjq6dIQDIqUoC+P0G6w==
X-Google-Smtp-Source: AA0mqf4TyLILdoz3IGEzu/oZZTJ1Ufqjjb5cOl7fiRCdudrU6I7UquCDEOzJMjcMGZ1N2u+qHtehmkrEjg6QX+GdVd0=
X-Received: by 2002:a25:24d:0:b0:6fd:2917:cf60 with SMTP id
 74-20020a25024d000000b006fd2917cf60mr13876617ybc.427.1670261003568; Mon, 05
 Dec 2022 09:23:23 -0800 (PST)
MIME-Version: 1.0
References: <20221205171520.1731689-1-pctammela@mojatatu.com> <20221205171520.1731689-3-pctammela@mojatatu.com>
In-Reply-To: <20221205171520.1731689-3-pctammela@mojatatu.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 5 Dec 2022 18:23:12 +0100
Message-ID: <CANn89iKdd74NMuJgzy+Hd22RNBuYVxyw9Tw4JOMY8nMVUhD8CA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/4] net/sched: add retpoline wrapper for tc
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

On Mon, Dec 5, 2022 at 6:16 PM Pedro Tammela <pctammela@mojatatu.com> wrote:
>
> On kernels compiled with CONFIG_RETPOLINE and CONFIG_NET_TC_INDIRECT_WRAPPER,
> optimize actions and filters that are compiled as built-ins into a direct call.
> The calls are ordered according to relevance. Testing data shows that
> the pps difference between first and last is between 0.5%-1.0%.
>
> On subsequent patches we expose the classifiers and actions functions
> and wire up the wrapper into tc.
>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Reviewed-by: Victor Nogueira <victor@mojatatu.com>
> ---
>  include/net/tc_wrapper.h | 226 +++++++++++++++++++++++++++++++++++++++
>  net/sched/Kconfig        |  13 +++
>  2 files changed, 239 insertions(+)
>  create mode 100644 include/net/tc_wrapper.h
>
> diff --git a/include/net/tc_wrapper.h b/include/net/tc_wrapper.h
> new file mode 100644
> index 000000000000..3bdebbfdf9d2
> --- /dev/null
> +++ b/include/net/tc_wrapper.h
> @@ -0,0 +1,226 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __NET_TC_WRAPPER_H
> +#define __NET_TC_WRAPPER_H
> +
> +#include <linux/indirect_call_wrapper.h>
> +#include <net/pkt_cls.h>
> +
> +#if IS_ENABLED(CONFIG_NET_TC_INDIRECT_WRAPPER)
> +
> +#define TC_INDIRECT_SCOPE
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

Perhaps you could add a static key to enable this retpoline avoidance only
on cpus without hardware support.  (IBRS enabled cpus would basically
use a jump to
directly go to the

return a->ops->act(skb, a, res);
