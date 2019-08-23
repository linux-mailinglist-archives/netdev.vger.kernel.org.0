Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7582D9A7D2
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 08:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404303AbfHWGvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 02:51:55 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:34581 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732321AbfHWGvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 02:51:54 -0400
X-Originating-IP: 209.85.217.47
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
        (Authenticated sender: pshelar@ovn.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id D05FFC0007
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 06:51:52 +0000 (UTC)
Received: by mail-vs1-f47.google.com with SMTP id s5so5568433vsi.10
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 23:51:52 -0700 (PDT)
X-Gm-Message-State: APjAAAW/kWvhRS1vIllABG3F1TCrIVGMyAqUPUPnIA5e7+lXF1yhqd22
        XU1Ji67jgqHMZtlBFjQwUZmH+0BUGP7AmrvvNEI=
X-Google-Smtp-Source: APXvYqygnxg9VWZDwWCleX9aveS7af9hGgVlblbn8V3/7SX/Rcgjl7Wd1BjKk8ZJK0C8EuJ9H66Z4wzLu2RVtHmole0=
X-Received: by 2002:a67:6889:: with SMTP id d131mr1706996vsc.93.1566543111477;
 Thu, 22 Aug 2019 23:51:51 -0700 (PDT)
MIME-Version: 1.0
References: <1566505070-38748-1-git-send-email-yihung.wei@gmail.com>
In-Reply-To: <1566505070-38748-1-git-send-email-yihung.wei@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Thu, 22 Aug 2019 23:53:48 -0700
X-Gmail-Original-Message-ID: <CAOrHB_A6Hn9o=8uzHQTp=cttMQsf=dYpobvq7C7_W398sw8UJA@mail.gmail.com>
Message-ID: <CAOrHB_A6Hn9o=8uzHQTp=cttMQsf=dYpobvq7C7_W398sw8UJA@mail.gmail.com>
Subject: Re: [PATCH net v2] openvswitch: Fix conntrack cache with timeout
To:     Yi-Hung Wei <yihung.wei@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 1:28 PM Yi-Hung Wei <yihung.wei@gmail.com> wrote:
>
> This patch addresses a conntrack cache issue with timeout policy.
> Currently, we do not check if the timeout extension is set properly in the
> cached conntrack entry.  Thus, after packet recirculate from conntrack
> action, the timeout policy is not applied properly.  This patch fixes the
> aforementioned issue.
>
> Fixes: 06bd2bdf19d2 ("openvswitch: Add timeout support to ct action")
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>
> ---
> v1->v2: Fix rcu dereference issue reported by kbuild test robot.
> ---
>  net/openvswitch/conntrack.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> index 848c6eb55064..4d7896135e73 100644
> --- a/net/openvswitch/conntrack.c
> +++ b/net/openvswitch/conntrack.c
> @@ -67,6 +67,7 @@ struct ovs_conntrack_info {
>         struct md_mark mark;
>         struct md_labels labels;
>         char timeout[CTNL_TIMEOUT_NAME_MAX];
> +       struct nf_ct_timeout *nf_ct_timeout;
>  #if IS_ENABLED(CONFIG_NF_NAT)
>         struct nf_nat_range2 range;  /* Only present for SRC NAT and DST NAT. */
>  #endif
> @@ -697,6 +698,14 @@ static bool skb_nfct_cached(struct net *net,
>                 if (help && rcu_access_pointer(help->helper) != info->helper)
>                         return false;
>         }
> +       if (info->nf_ct_timeout) {
> +               struct nf_conn_timeout *timeout_ext;
> +
> +               timeout_ext = nf_ct_timeout_find(ct);
> +               if (!timeout_ext || info->nf_ct_timeout !=
> +                   rcu_dereference(timeout_ext->timeout))
> +                       return false;
> +       }
>         /* Force conntrack entry direction to the current packet? */
>         if (info->force && CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL) {
>                 /* Delete the conntrack entry if confirmed, else just release
> @@ -1657,6 +1666,10 @@ int ovs_ct_copy_action(struct net *net, const struct nlattr *attr,
>                                       ct_info.timeout))
>                         pr_info_ratelimited("Failed to associated timeout "
>                                             "policy `%s'\n", ct_info.timeout);
> +               else
> +                       ct_info.nf_ct_timeout = rcu_dereference(
> +                               nf_ct_timeout_find(ct_info.ct)->timeout);
Is this dereference safe from NULL pointer?
