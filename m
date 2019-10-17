Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3272ADB9CC
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 00:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503676AbfJQWir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 18:38:47 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:40581 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503635AbfJQWir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 18:38:47 -0400
X-Originating-IP: 209.85.217.43
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
        (Authenticated sender: pshelar@ovn.org)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 52451240004
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 22:38:45 +0000 (UTC)
Received: by mail-vs1-f43.google.com with SMTP id w195so2709853vsw.11
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 15:38:45 -0700 (PDT)
X-Gm-Message-State: APjAAAWxYA8B9kx8KWkCG3eTyFNybIQYivOJRpLxKeGKSzyruLsVMqYk
        gUco0ZsgU48MWD7fIpVEuqocUzRnc/vCy4kqiH8=
X-Google-Smtp-Source: APXvYqxuo/9+ovOqmgnm1h1uIQ66m7OLNK9OhSW6WT46Yr1IC/WkEG1mBzSz5L4r6edqB3WGRus/NfQgUICXK2YeyEg=
X-Received: by 2002:a67:ec8f:: with SMTP id h15mr3554779vsp.66.1571351923782;
 Thu, 17 Oct 2019 15:38:43 -0700 (PDT)
MIME-Version: 1.0
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com> <1571135440-24313-9-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1571135440-24313-9-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Thu, 17 Oct 2019 15:38:35 -0700
X-Gmail-Original-Message-ID: <CAOrHB_B5dLuvoTxGpmaMiX9deEk9KjQHacqNKEpzHA2m5YS7jw@mail.gmail.com>
Message-ID: <CAOrHB_B5dLuvoTxGpmaMiX9deEk9KjQHacqNKEpzHA2m5YS7jw@mail.gmail.com>
Subject: Re: [PATCH net-next v4 08/10] net: openvswitch: fix possible memleak
 on destroy flow-table
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Greg Rose <gvrose8192@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 5:50 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> When we destroy the flow tables which may contain the flow_mask,
> so release the flow mask struct.
>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Tested-by: Greg Rose <gvrose8192@gmail.com>
> ---
>  net/openvswitch/flow_table.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
> index 5df5182..d5d768e 100644
> --- a/net/openvswitch/flow_table.c
> +++ b/net/openvswitch/flow_table.c
> @@ -295,6 +295,18 @@ static void table_instance_destroy(struct table_instance *ti,
>         }
>  }
>
> +static void tbl_mask_array_destroy(struct flow_table *tbl)
> +{
> +       struct mask_array *ma = ovsl_dereference(tbl->mask_array);
> +       int i;
> +
> +       /* Free the flow-mask and kfree_rcu the NULL is allowed. */
> +       for (i = 0; i < ma->max; i++)
> +               kfree_rcu(rcu_dereference_raw(ma->masks[i]), rcu);
> +
> +       kfree_rcu(rcu_dereference_raw(tbl->mask_array), rcu);
> +}
> +
>  /* No need for locking this function is called from RCU callback or
>   * error path.
>   */
> @@ -304,7 +316,7 @@ void ovs_flow_tbl_destroy(struct flow_table *table)
>         struct table_instance *ufid_ti = rcu_dereference_raw(table->ufid_ti);
>
>         free_percpu(table->mask_cache);
> -       kfree_rcu(rcu_dereference_raw(table->mask_array), rcu);
> +       tbl_mask_array_destroy(table);
>         table_instance_destroy(ti, ufid_ti, false);
>  }

This should not be required. mask is linked to a flow and gets
released when flow is removed.
Does the memory leak occur when OVS module is abruptly unloaded and
userspace does not cleanup flow table?
In that case better fix could be calling ovs_flow_tbl_remove()
equivalent from table_instance_destroy when it is iterating flow
table.
