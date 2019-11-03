Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAB51ED253
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 07:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbfKCGr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 01:47:28 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:36651 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfKCGr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 01:47:28 -0500
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
        (Authenticated sender: pshelar@ovn.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 29082200002
        for <netdev@vger.kernel.org>; Sun,  3 Nov 2019 06:47:25 +0000 (UTC)
Received: by mail-vs1-f42.google.com with SMTP id w25so9030416vso.4
        for <netdev@vger.kernel.org>; Sat, 02 Nov 2019 23:47:25 -0700 (PDT)
X-Gm-Message-State: APjAAAXCaJb8tnEWTnBOI9y/gSQNGUMku7sWgFgI1Ek+2+SgJGSuAOp1
        +6EwlEidcUiq0kl0cIvnUmoinKJIZPoeE97pI6A=
X-Google-Smtp-Source: APXvYqw8AoeD4ByJpCjPx6j4ttkN/760Uz2qn+WUwmPdZxXyd9X+YHVByaZ8cxvpBkRuwer5TrEEBKdiGP6e68v7oR8=
X-Received: by 2002:a67:eec7:: with SMTP id o7mr9434126vsp.58.1572763644816;
 Sat, 02 Nov 2019 23:47:24 -0700 (PDT)
MIME-Version: 1.0
References: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com> <1572618234-6904-4-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1572618234-6904-4-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sat, 2 Nov 2019 23:47:13 -0700
X-Gmail-Original-Message-ID: <CAOrHB_AJF9U8oiomav7sKV3CajrxBc5Yua_PWehB53PDzLjWtg@mail.gmail.com>
Message-ID: <CAOrHB_AJF9U8oiomav7sKV3CajrxBc5Yua_PWehB53PDzLjWtg@mail.gmail.com>
Subject: Re: [PATCH net-next v6 03/10] net: openvswitch: shrink the mask array
 if necessary
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Greg Rose <gvrose8192@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 1, 2019 at 7:24 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> When creating and inserting flow-mask, if there is no available
> flow-mask, we realloc the mask array. When removing flow-mask,
> if necessary, we shrink mask array.
>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Tested-by: Greg Rose <gvrose8192@gmail.com>
> Acked-by: William Tu <u9012063@gmail.com>
> ---
Acked-by: Pravin B Shelar <pshelar@ovn.org>


>  net/openvswitch/flow_table.c | 33 +++++++++++++++++++++++----------
>  1 file changed, 23 insertions(+), 10 deletions(-)
>
> diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
> index 92efa23..0c0fcd6 100644
> --- a/net/openvswitch/flow_table.c
> +++ b/net/openvswitch/flow_table.c
> @@ -694,6 +694,23 @@ static struct table_instance *table_instance_expand(struct table_instance *ti,
>         return table_instance_rehash(ti, ti->n_buckets * 2, ufid);
>  }
>
> +static void tbl_mask_array_delete_mask(struct mask_array *ma,
> +                                      struct sw_flow_mask *mask)
> +{
> +       int i;
> +
> +       /* Remove the deleted mask pointers from the array */
> +       for (i = 0; i < ma->max; i++) {
> +               if (mask == ovsl_dereference(ma->masks[i])) {
> +                       RCU_INIT_POINTER(ma->masks[i], NULL);
> +                       ma->count--;
> +                       kfree_rcu(mask, rcu);
> +                       return;
> +               }
> +       }
> +       BUG();
> +}
> +
>  /* Remove 'mask' from the mask list, if it is not needed any more. */
>  static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
>  {
> @@ -707,18 +724,14 @@ static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
>
>                 if (!mask->ref_count) {
>                         struct mask_array *ma;
> -                       int i;
>
>                         ma = ovsl_dereference(tbl->mask_array);
> -                       for (i = 0; i < ma->max; i++) {
> -                               if (mask == ovsl_dereference(ma->masks[i])) {
> -                                       RCU_INIT_POINTER(ma->masks[i], NULL);
> -                                       ma->count--;
> -                                       kfree_rcu(mask, rcu);
> -                                       return;
> -                               }
> -                       }
> -                       BUG();
> +                       tbl_mask_array_delete_mask(ma, mask);
> +
> +                       /* Shrink the mask array if necessary. */
> +                       if (ma->max >= (MASK_ARRAY_SIZE_MIN * 2) &&
> +                           ma->count <= (ma->max / 3))
> +                               tbl_mask_array_realloc(tbl, ma->max / 2);
>                 }
>         }
>  }
> --
> 1.8.3.1
>
