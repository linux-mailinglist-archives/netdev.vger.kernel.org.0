Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB69DE368
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 06:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfJUEv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 00:51:58 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:41996 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbfJUEv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 00:51:57 -0400
Received: by mail-ot1-f67.google.com with SMTP id c10so9852420otd.9
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 21:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XLM61E0dMGV7Qg1REJdgS72cJxWXlgxTfu5+3Ogglwg=;
        b=jDHZmNZEdRshZg2mRjUWUpkeMQx9YIAgPtu805ej3JJULD/nd3XunQOmK7z/pV05jQ
         E0ZjwZp53s70NcQznFbnyemOSqRHyAw2kaoUGMghqyadvHJzo0jdJli+Kznm6/o/FwI2
         f9rBzi+m9IAmfV/njRRDr9TbYonCA1uG6751aIK69YmM3mjoD+sDas8vK1UmxrzkSWC3
         0IRzI1FK2tJY7Dff9NGdedpJgXvK2lf9OK5PEWGKpYs7Sv/u82soNGztE60PzQholrMC
         gUhTruFExf0JCbbe5jAxcn1r7JmIVCMGuD87LXee5Oe+z/19Kawsr2+CfTuw5xar28vv
         R74g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XLM61E0dMGV7Qg1REJdgS72cJxWXlgxTfu5+3Ogglwg=;
        b=FXVFfzO/qvJgulAc+yBKFb4os316sceLCNM3PhBxQd7Zn+cp6ET9QvA57jjBHRnM3N
         6qVYyPfDFNM5E/fZGp6C7W1BKaZWyAwXE1Fy9JumMULzhPS7HR8AFTvuBkuOvwn7Q/r/
         BRaaJxSl/u1tvr7cZihhW8Dy10skFX59+MLxN5Wb1U+gjO9r78y8nKc/Q1QRxt1IAef0
         jY6ewoz3czsTymsEM+Uuv8u1ijIWLUZesf128j/bCFoGTKCKCuglL+LD2I/F4SUHydCm
         iVZUvDMlUqt+XGe27YTqrckYLw5tYFSwZRS52hceaV64iROl6MF9enaQiw5uCPWroEUq
         VZLA==
X-Gm-Message-State: APjAAAVG5u6kZvoxv6xgD3k+cU0USV4lX0hoi+0Ggfp0e3dWyVY87j+G
        R230KwUYq63huN0fK5WZKqDIOiSUG1tQwakCT/w=
X-Google-Smtp-Source: APXvYqx7CfrvGGRs7Xa/mm2JwHEIqhMvFFUfL8ddf28you1YqvlhVEN5pM2tq7xm0w1dBo6noY8Qe0YeyQkIses2D7M=
X-Received: by 2002:a05:6830:2105:: with SMTP id i5mr9317580otc.334.1571633515023;
 Sun, 20 Oct 2019 21:51:55 -0700 (PDT)
MIME-Version: 1.0
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1571135440-24313-6-git-send-email-xiangxia.m.yue@gmail.com> <CALDO+SaoGxs3ZShuXiT9TaC+e85ArBa85pUxQ6ApmDScrMtx8w@mail.gmail.com>
In-Reply-To: <CALDO+SaoGxs3ZShuXiT9TaC+e85ArBa85pUxQ6ApmDScrMtx8w@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 21 Oct 2019 12:51:18 +0800
Message-ID: <CAMDZJNVXwkTgFSC7XtANLdF4j_ygQSpVrvq8KaY23czP8FRbBw@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net-next v4 05/10] net: openvswitch: optimize
 flow-mask looking up
To:     William Tu <u9012063@gmail.com>
Cc:     Greg Rose <gvrose8192@gmail.com>, pravin shelar <pshelar@ovn.org>,
        "<dev@openvswitch.org>" <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 19, 2019 at 7:27 AM William Tu <u9012063@gmail.com> wrote:
>
> On Wed, Oct 16, 2019 at 5:54 AM <xiangxia.m.yue@gmail.com> wrote:
> >
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > The full looking up on flow table traverses all mask array.
> > If mask-array is too large, the number of invalid flow-mask
> > increase, performance will be drop.
> >
> > One bad case, for example: M means flow-mask is valid and NULL
> > of flow-mask means deleted.
> >
> > +-------------------------------------------+
> > | M | NULL | ...                  | NULL | M|
> > +-------------------------------------------+
> >
> > In that case, without this patch, openvswitch will traverses all
> > mask array, because there will be one flow-mask in the tail. This
> > patch changes the way of flow-mask inserting and deleting, and the
> > mask array will be keep as below: there is not a NULL hole. In the
> > fast path, we can "break" "for" (not "continue") in flow_lookup
> > when we get a NULL flow-mask.
> >
> >          "break"
> >             v
> > +-------------------------------------------+
> > | M | M |  NULL |...           | NULL | NULL|
> > +-------------------------------------------+
> >
> > This patch don't optimize slow or control path, still using ma->max
> > to traverse. Slow path:
> > * tbl_mask_array_realloc
> > * ovs_flow_tbl_lookup_exact
> > * flow_mask_find
>
>
> Hi Tonghao,
>
> Does this improve performance? After all, the original code simply
> check whether the mask is NULL, then goto next mask.
I tested the performance, but I disable the mask cache, and use the
dpdk-pktgen to generate packets:
The test ovs flow:
ovs-dpctl add-dp system@ovs-system
ovs-dpctl add-if system@ovs-system eth6
ovs-dpctl add-if system@ovs-system eth7

for m in $(seq 1 100 | xargs printf '%.2x\n'); do
       ovs-dpctl add-flow ovs-system
"in_port(1),eth(dst=00:$m:00:00:00:00/ff:ff:ff:ff:ff:$m),eth_type(0x0800),ipv4(frag=no)"
2
done

ovs-dpctl add-flow ovs-system
"in_port(1),eth(dst=98:03:9b:6e:4a:f5/ff:ff:ff:ff:ff:ff),eth_type(0x0800),ipv4(frag=no)"
2
ovs-dpctl add-flow ovs-system
"in_port(2),eth(dst=98:03:9b:6e:4a:f4/ff:ff:ff:ff:ff:ff),eth_type(0x0800),ipv4(frag=no)"
1

for m in $(seq 101 160 | xargs printf '%.2x\n'); do
        ovs-dpctl add-flow ovs-system
"in_port(1),eth(dst=00:$m:00:00:00:00/ff:ff:ff:ff:ff:$m),eth_type(0x0800),ipv4(frag=no)"
2
done

for m in $(seq 1 100 | xargs printf '%.2x\n'); do
         ovs-dpctl del-flow ovs-system
"in_port(1),eth(dst=00:$m:00:00:00:00/ff:ff:ff:ff:ff:$m),eth_type(0x0800),ipv4(frag=no)"
done

Without this patch: 982481pps (64B)
With this patch: 1112495 pps (64B), about 13% improve

> However, with your patch,  isn't this invalidated the mask cache entry which
> point to the "M" you swap to the front? See my commands inline.
>
> >
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > Tested-by: Greg Rose <gvrose8192@gmail.com>
> > ---
> >  net/openvswitch/flow_table.c | 101 ++++++++++++++++++++++---------------------
> >  1 file changed, 52 insertions(+), 49 deletions(-)
> >
> > diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
> > index 8d4f50d..a10d421 100644
> > --- a/net/openvswitch/flow_table.c
> > +++ b/net/openvswitch/flow_table.c
> > @@ -538,7 +538,7 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
> >
> >                 mask = rcu_dereference_ovsl(ma->masks[i]);
> >                 if (!mask)
> > -                       continue;
> > +                       break;
> >
> >                 flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
> >                 if (flow) { /* Found */
> > @@ -695,7 +695,7 @@ struct sw_flow *ovs_flow_tbl_lookup_ufid(struct flow_table *tbl,
> >  int ovs_flow_tbl_num_masks(const struct flow_table *table)
> >  {
> >         struct mask_array *ma = rcu_dereference_ovsl(table->mask_array);
> > -       return ma->count;
> > +       return READ_ONCE(ma->count);
> >  }
> >
> >  static struct table_instance *table_instance_expand(struct table_instance *ti,
> > @@ -704,21 +704,33 @@ static struct table_instance *table_instance_expand(struct table_instance *ti,
> >         return table_instance_rehash(ti, ti->n_buckets * 2, ufid);
> >  }
> >
> > -static void tbl_mask_array_delete_mask(struct mask_array *ma,
> > -                                      struct sw_flow_mask *mask)
> > +static void tbl_mask_array_del_mask(struct flow_table *tbl,
> > +                                   struct sw_flow_mask *mask)
> >  {
> > -       int i;
> > +       struct mask_array *ma = ovsl_dereference(tbl->mask_array);
> > +       int i, ma_count = READ_ONCE(ma->count);
> >
> >         /* Remove the deleted mask pointers from the array */
> > -       for (i = 0; i < ma->max; i++) {
> > -               if (mask == ovsl_dereference(ma->masks[i])) {
> > -                       RCU_INIT_POINTER(ma->masks[i], NULL);
> > -                       ma->count--;
> > -                       kfree_rcu(mask, rcu);
> > -                       return;
> > -               }
> > +       for (i = 0; i < ma_count; i++) {
> > +               if (mask == ovsl_dereference(ma->masks[i]))
> > +                       goto found;
> >         }
> > +
> >         BUG();
> > +       return;
> > +
> > +found:
> > +       WRITE_ONCE(ma->count, ma_count -1);
> > +
> > +       rcu_assign_pointer(ma->masks[i], ma->masks[ma_count -1]);
> > +       RCU_INIT_POINTER(ma->masks[ma_count -1], NULL);
>
> So when you swap the ma->masks[ma_count -1], the mask cache entry
> who's 'mask_index == ma_count' become all invalid?
Yes, a little tricky.
> Regards,
> William
>
> <snip>
