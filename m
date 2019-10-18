Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B08E1DD550
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 01:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732179AbfJRX1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 19:27:07 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44528 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbfJRX1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 19:27:07 -0400
Received: by mail-qk1-f195.google.com with SMTP id u22so6863849qkk.11
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 16:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hfNjaMNfZGvbFsjisNiFi9iAMYzA7xoGPY1lC1bklbw=;
        b=OMxro03BEa4MomT/gLak9mjkqXB6i6HBNVCO/cMOfwqk3q3HgfKqHdHMxHc2tOffOY
         Lvym60GgdDtUuOjR1tCA7jcp6Y+8l9wpc3+XTflyVpGW8SVXS8SiYXp+EVTGycs80Bhu
         nG5W0pKzjIeSidAYhGUM2Lbbj+9cEWOy1exO981qK1yNvPlJ+5Vi0MKFKY8EFFnGlXI7
         cPXSodZVV6RXBDEjFCWONkbZxud0Jj3A4Odt25zJBc6SU5/lyfc39/UDa+wBp6pzQAtj
         ZiqQvZwmrcQhDAkssb3Nwb8bG9G+etY60iydcLu5SPcbi+87JAkZttPlfqfGBD3mkCrh
         Vnbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hfNjaMNfZGvbFsjisNiFi9iAMYzA7xoGPY1lC1bklbw=;
        b=JZG9sKRBX4c24aVy+KQxQ1NajSUKIlTixNPABcC72SNmsFBW9O5NJi08aOhICeRDi4
         K5Dv34HIztJ3Uu3DgPHz1FnwlDhtPFAYSdD/nWhQKblOhZQVNYE8J4RoiEvqLPTttb41
         fqIB16IF54HTUWebEhS8Tgy17JHilEWI3dDMoxzMKbltzVYWd+dgKfKksW6OWccXwqw6
         Byhdlwa5lwqlN69aljbOFRY5k0gBeJAD0f1cn6AMutDGYEdNBMCfnuQZr1QGLS9V1p8X
         yI6Nqk/AcHQJkIls05IyzN2VpifUAVKqLIwn2iH6JpYw0V6pQXC6HeXYLugfvCq3J62u
         CBpw==
X-Gm-Message-State: APjAAAUcSU9gXTsdd20pYEalWy8Nxu5OhSTY3HesRAMwM1sM5AxGm6l+
        CGBPsbaX7LIiNJgOA8kxy0v/UXz+rOqfMsiKpJw=
X-Google-Smtp-Source: APXvYqyClwJOfLI0vwZSX89XraaZbCUVGe8ZoGss14GYGB06bWtzvTnvOkO+4kYCbVc2NXPs/T4JK0ULeAAEl/fe0fM=
X-Received: by 2002:ae9:f012:: with SMTP id l18mr9518203qkg.291.1571441225625;
 Fri, 18 Oct 2019 16:27:05 -0700 (PDT)
MIME-Version: 1.0
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com> <1571135440-24313-6-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1571135440-24313-6-git-send-email-xiangxia.m.yue@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Fri, 18 Oct 2019 16:26:29 -0700
Message-ID: <CALDO+SaoGxs3ZShuXiT9TaC+e85ArBa85pUxQ6ApmDScrMtx8w@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net-next v4 05/10] net: openvswitch: optimize
 flow-mask looking up
To:     xiangxia.m.yue@gmail.com
Cc:     Greg Rose <gvrose8192@gmail.com>, pravin shelar <pshelar@ovn.org>,
        "<dev@openvswitch.org>" <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 5:54 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> The full looking up on flow table traverses all mask array.
> If mask-array is too large, the number of invalid flow-mask
> increase, performance will be drop.
>
> One bad case, for example: M means flow-mask is valid and NULL
> of flow-mask means deleted.
>
> +-------------------------------------------+
> | M | NULL | ...                  | NULL | M|
> +-------------------------------------------+
>
> In that case, without this patch, openvswitch will traverses all
> mask array, because there will be one flow-mask in the tail. This
> patch changes the way of flow-mask inserting and deleting, and the
> mask array will be keep as below: there is not a NULL hole. In the
> fast path, we can "break" "for" (not "continue") in flow_lookup
> when we get a NULL flow-mask.
>
>          "break"
>             v
> +-------------------------------------------+
> | M | M |  NULL |...           | NULL | NULL|
> +-------------------------------------------+
>
> This patch don't optimize slow or control path, still using ma->max
> to traverse. Slow path:
> * tbl_mask_array_realloc
> * ovs_flow_tbl_lookup_exact
> * flow_mask_find


Hi Tonghao,

Does this improve performance? After all, the original code simply
check whether the mask is NULL, then goto next mask.

However, with your patch,  isn't this invalidated the mask cache entry which
point to the "M" you swap to the front? See my commands inline.

>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Tested-by: Greg Rose <gvrose8192@gmail.com>
> ---
>  net/openvswitch/flow_table.c | 101 ++++++++++++++++++++++---------------------
>  1 file changed, 52 insertions(+), 49 deletions(-)
>
> diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
> index 8d4f50d..a10d421 100644
> --- a/net/openvswitch/flow_table.c
> +++ b/net/openvswitch/flow_table.c
> @@ -538,7 +538,7 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
>
>                 mask = rcu_dereference_ovsl(ma->masks[i]);
>                 if (!mask)
> -                       continue;
> +                       break;
>
>                 flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
>                 if (flow) { /* Found */
> @@ -695,7 +695,7 @@ struct sw_flow *ovs_flow_tbl_lookup_ufid(struct flow_table *tbl,
>  int ovs_flow_tbl_num_masks(const struct flow_table *table)
>  {
>         struct mask_array *ma = rcu_dereference_ovsl(table->mask_array);
> -       return ma->count;
> +       return READ_ONCE(ma->count);
>  }
>
>  static struct table_instance *table_instance_expand(struct table_instance *ti,
> @@ -704,21 +704,33 @@ static struct table_instance *table_instance_expand(struct table_instance *ti,
>         return table_instance_rehash(ti, ti->n_buckets * 2, ufid);
>  }
>
> -static void tbl_mask_array_delete_mask(struct mask_array *ma,
> -                                      struct sw_flow_mask *mask)
> +static void tbl_mask_array_del_mask(struct flow_table *tbl,
> +                                   struct sw_flow_mask *mask)
>  {
> -       int i;
> +       struct mask_array *ma = ovsl_dereference(tbl->mask_array);
> +       int i, ma_count = READ_ONCE(ma->count);
>
>         /* Remove the deleted mask pointers from the array */
> -       for (i = 0; i < ma->max; i++) {
> -               if (mask == ovsl_dereference(ma->masks[i])) {
> -                       RCU_INIT_POINTER(ma->masks[i], NULL);
> -                       ma->count--;
> -                       kfree_rcu(mask, rcu);
> -                       return;
> -               }
> +       for (i = 0; i < ma_count; i++) {
> +               if (mask == ovsl_dereference(ma->masks[i]))
> +                       goto found;
>         }
> +
>         BUG();
> +       return;
> +
> +found:
> +       WRITE_ONCE(ma->count, ma_count -1);
> +
> +       rcu_assign_pointer(ma->masks[i], ma->masks[ma_count -1]);
> +       RCU_INIT_POINTER(ma->masks[ma_count -1], NULL);

So when you swap the ma->masks[ma_count -1], the mask cache entry
who's 'mask_index == ma_count' become all invalid?

Regards,
William

<snip>
