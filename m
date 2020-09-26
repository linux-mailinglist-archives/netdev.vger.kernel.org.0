Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EC72798BA
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 13:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbgIZLuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 07:50:20 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:63135 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgIZLuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 07:50:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1601121019; x=1632657019;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=v5AneH4/bSvtOhqkbIOMHS6SIlIZqYFh+fCf0+11W4s=;
  b=s2fe/X/C1rRrxxbYVaivdLByuDhP7Czff7mi2jBVwjDQNczvQdEePhSq
   uz0GsaxKy0idWH8kA9b0/9TYiJLG0laaR/8BGYEJ0fNlMHoXofmzMfTxb
   DCzFmEp47rdkInncNA2+lg0h2lTaw5lV92ydebQPaI1Te9CNqqS10OUwR
   ZMIis+HuyoNRWU1IyUoiPo9BQB8o85UKTqAPE1KRLg5cr3oP2mMB0IAZz
   Gonn07JUuvH0AMnzFZwxUNO3H40Se+K/LjpPD0bI2lMPR2k+ZQGB+gW08
   QYJpx/TDR0lMKsQ3D1Z3YS3c+2qwMdcOoGaGY/8OdOl7rgJFIcFOPW+qk
   w==;
IronPort-SDR: PA9HH5WU9+iVa5Sf03NY2iSU7mSSMsvVFSeUQG+Xz8DcA3BgAoahJdQf4SgHzLWESaUXfN5tGB
 5YxLfnZ4Km8rVxBYLMp333fTnqfaCYMOID691TBWNdJQDJf316XWSxZwctnG1MJZNmfWXtoP8y
 rXLU9gFf6GjW2WOcu65HCDBiiy2V7NBgrWMVPuOwCYr1Jw0KgqAaiFvyhlnSspuzGyapxunksA
 SsZlrglBBW7pigihdQ5onI3qtmLorr7SSWorOLuCg/T34RMDzojxXxv/smk6YPwf1u6/dcdi7Q
 /7I=
X-IronPort-AV: E=Sophos;i="5.77,305,1596524400"; 
   d="scan'208";a="88238027"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Sep 2020 04:50:18 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 26 Sep 2020 04:49:38 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Sat, 26 Sep 2020 04:50:18 -0700
Date:   Sat, 26 Sep 2020 13:50:17 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     <davem@davemloft.net>, <alexandre.belloni@bootlin.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <joergen.andreasen@microchip.com>,
        <allan.nielsen@microchip.com>, <alexandru.marginean@nxp.com>,
        <claudiu.manoil@nxp.com>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC PATCH net-next 03/14] net: mscc: ocelot: offload multiple
 tc-flower actions in same rule
Message-ID: <20200926115017.s34t76xptsa5wdlq@soft-dev3.localdomain>
References: <20200925121855.370863-1-vladimir.oltean@nxp.com>
 <20200925121855.370863-4-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20200925121855.370863-4-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 09/25/2020 15:18, Vladimir Oltean wrote:

Hi Vladimir,

> 
> At this stage, the tc-flower offload of mscc_ocelot can only delegate
> rules to the VCAP IS2 security enforcement block. These rules have, in
> hardware, separate bits for policing and for overriding the destination
> port mask and/or copying to the CPU. So it makes sense that we attempt
> to expose some more of that low-level complexity instead of simply
> choosing between a single type of action.
> 
> Something similar happens with the VCAP IS1 block, where the same action
> can contain enable bits for VLAN classification and for QoS
> classification at the same time.
> 
> So model the action structure after the hardware description, and let
> the high-level ocelot_flower.c construct an action vector from multiple
> tc actions.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/mscc/ocelot_flower.c | 17 +++----
>  drivers/net/ethernet/mscc/ocelot_vcap.c   | 57 +++++++----------------
>  drivers/net/ethernet/mscc/ocelot_vcap.h   | 30 +++++++++---
>  3 files changed, 50 insertions(+), 54 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
> index ec1b6e2572ba..ffd66966b0b7 100644
> --- a/drivers/net/ethernet/mscc/ocelot_flower.c
> +++ b/drivers/net/ethernet/mscc/ocelot_flower.c
> @@ -15,9 +15,6 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
>         u64 rate;
>         int i;
> 
> -       if (!flow_offload_has_one_action(&f->rule->action))
> -               return -EOPNOTSUPP;
> -
>         if (!flow_action_basic_hw_stats_check(&f->rule->action,
>                                               f->common.extack))
>                 return -EOPNOTSUPP;
> @@ -25,16 +22,20 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
>         flow_action_for_each(i, a, &f->rule->action) {
>                 switch (a->id) {
>                 case FLOW_ACTION_DROP:
> -                       filter->action = OCELOT_VCAP_ACTION_DROP;
> +                       filter->action.mask_mode = OCELOT_MASK_MODE_PERMIT_DENY;
> +                       filter->action.port_mask = 0;
> +                       filter->action.police_ena = true;
> +                       filter->action.pol_ix = OCELOT_POLICER_DISCARD;
>                         break;
>                 case FLOW_ACTION_TRAP:
> -                       filter->action = OCELOT_VCAP_ACTION_TRAP;

You should set also:
filter->action.mask_mode = OCELOT_MASK_MODE_PERMIT_DENY;

> +                       filter->action.cpu_copy_ena = true;
> +                       filter->action.cpu_qu_num = 0;
>                         break;
>                 case FLOW_ACTION_POLICE:
> -                       filter->action = OCELOT_VCAP_ACTION_POLICE;
> +                       filter->action.police_ena = true;
>                         rate = a->police.rate_bytes_ps;
> -                       filter->pol.rate = div_u64(rate, 1000) * 8;
> -                       filter->pol.burst = a->police.burst;
> +                       filter->action.pol.rate = div_u64(rate, 1000) * 8;
> +                       filter->action.pol.burst = a->police.burst;
>                         break;
>                 default:
>                         return -EOPNOTSUPP;
> diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
> index 1755979e3f36..e9629a20971c 100644
> --- a/drivers/net/ethernet/mscc/ocelot_vcap.c
> +++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
> @@ -10,7 +10,6 @@
>  #include "ocelot_police.h"
>  #include "ocelot_vcap.h"
> 
> -#define OCELOT_POLICER_DISCARD 0x17f
>  #define ENTRY_WIDTH 32
> 
>  enum vcap_sel {
> @@ -315,35 +314,14 @@ static void is2_action_set(struct ocelot *ocelot, struct vcap_data *data,
>                            struct ocelot_vcap_filter *filter)
>  {
>         const struct vcap_props *vcap = &ocelot->vcap[VCAP_IS2];
> +       struct ocelot_vcap_action *a = &filter->action;
> 
> -       switch (filter->action) {
> -       case OCELOT_VCAP_ACTION_DROP:
> -               vcap_action_set(vcap, data, VCAP_IS2_ACT_PORT_MASK, 0);
> -               vcap_action_set(vcap, data, VCAP_IS2_ACT_MASK_MODE, 1);
> -               vcap_action_set(vcap, data, VCAP_IS2_ACT_POLICE_ENA, 1);
> -               vcap_action_set(vcap, data, VCAP_IS2_ACT_POLICE_IDX,
> -                               OCELOT_POLICER_DISCARD);
> -               vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_QU_NUM, 0);
> -               vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_COPY_ENA, 0);
> -               break;
> -       case OCELOT_VCAP_ACTION_TRAP:
> -               vcap_action_set(vcap, data, VCAP_IS2_ACT_PORT_MASK, 0);
> -               vcap_action_set(vcap, data, VCAP_IS2_ACT_MASK_MODE, 1);
> -               vcap_action_set(vcap, data, VCAP_IS2_ACT_POLICE_ENA, 0);
> -               vcap_action_set(vcap, data, VCAP_IS2_ACT_POLICE_IDX, 0);
> -               vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_QU_NUM, 0);
> -               vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_COPY_ENA, 1);
> -               break;
> -       case OCELOT_VCAP_ACTION_POLICE:
> -               vcap_action_set(vcap, data, VCAP_IS2_ACT_PORT_MASK, 0);
> -               vcap_action_set(vcap, data, VCAP_IS2_ACT_MASK_MODE, 0);
> -               vcap_action_set(vcap, data, VCAP_IS2_ACT_POLICE_ENA, 1);
> -               vcap_action_set(vcap, data, VCAP_IS2_ACT_POLICE_IDX,
> -                               filter->pol_ix);
> -               vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_QU_NUM, 0);
> -               vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_COPY_ENA, 0);
> -               break;
> -       }
> +       vcap_action_set(vcap, data, VCAP_IS2_ACT_MASK_MODE, a->mask_mode);
> +       vcap_action_set(vcap, data, VCAP_IS2_ACT_PORT_MASK, a->port_mask);
> +       vcap_action_set(vcap, data, VCAP_IS2_ACT_POLICE_ENA, a->police_ena);
> +       vcap_action_set(vcap, data, VCAP_IS2_ACT_POLICE_IDX, a->pol_ix);
> +       vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_QU_NUM, a->cpu_qu_num);
> +       vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_COPY_ENA, a->cpu_copy_ena);
>  }
> 
>  static void is2_entry_set(struct ocelot *ocelot, int ix,
> @@ -693,11 +671,11 @@ static void ocelot_vcap_policer_del(struct ocelot *ocelot,
> 
>         list_for_each_entry(filter, &block->rules, list) {
>                 index++;
> -               if (filter->action == OCELOT_VCAP_ACTION_POLICE &&
> -                   filter->pol_ix < pol_ix) {
> -                       filter->pol_ix += 1;
> -                       ocelot_vcap_policer_add(ocelot, filter->pol_ix,
> -                                               &filter->pol);
> +               if (filter->action.police_ena &&
> +                   filter->action.pol_ix < pol_ix) {
> +                       filter->action.pol_ix += 1;
> +                       ocelot_vcap_policer_add(ocelot, filter->action.pol_ix,
> +                                               &filter->action.pol);
>                         is2_entry_set(ocelot, index, filter);
>                 }
>         }
> @@ -715,10 +693,11 @@ static void ocelot_vcap_filter_add_to_block(struct ocelot *ocelot,
>         struct ocelot_vcap_filter *tmp;
>         struct list_head *pos, *n;
> 
> -       if (filter->action == OCELOT_VCAP_ACTION_POLICE) {
> +       if (filter->action.police_ena) {
>                 block->pol_lpr--;
> -               filter->pol_ix = block->pol_lpr;
> -               ocelot_vcap_policer_add(ocelot, filter->pol_ix, &filter->pol);
> +               filter->action.pol_ix = block->pol_lpr;
> +               ocelot_vcap_policer_add(ocelot, filter->action.pol_ix,
> +                                       &filter->action.pol);
>         }
> 
>         block->count++;
> @@ -918,9 +897,9 @@ static void ocelot_vcap_block_remove_filter(struct ocelot *ocelot,
>         list_for_each_safe(pos, q, &block->rules) {
>                 tmp = list_entry(pos, struct ocelot_vcap_filter, list);
>                 if (tmp->id == filter->id) {
> -                       if (tmp->action == OCELOT_VCAP_ACTION_POLICE)
> +                       if (tmp->action.police_ena)
>                                 ocelot_vcap_policer_del(ocelot, block,
> -                                                       tmp->pol_ix);
> +                                                       tmp->action.pol_ix);
> 
>                         list_del(pos);
>                         kfree(tmp);
> diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.h b/drivers/net/ethernet/mscc/ocelot_vcap.h
> index 0dfbfc011b2e..b1e77fd874b4 100644
> --- a/drivers/net/ethernet/mscc/ocelot_vcap.h
> +++ b/drivers/net/ethernet/mscc/ocelot_vcap.h
> @@ -11,6 +11,8 @@
>  #include <net/sch_generic.h>
>  #include <net/pkt_cls.h>
> 
> +#define OCELOT_POLICER_DISCARD 0x17f
> +
>  struct ocelot_ipv4 {
>         u8 addr[4];
>  };
> @@ -174,10 +176,26 @@ struct ocelot_vcap_key_ipv6 {
>         enum ocelot_vcap_bit seq_zero;       /* TCP sequence number is zero */
>  };
> 
> -enum ocelot_vcap_action {
> -       OCELOT_VCAP_ACTION_DROP,
> -       OCELOT_VCAP_ACTION_TRAP,
> -       OCELOT_VCAP_ACTION_POLICE,
> +enum ocelot_mask_mode {
> +       OCELOT_MASK_MODE_NONE,
> +       OCELOT_MASK_MODE_PERMIT_DENY,
> +       OCELOT_MASK_MODE_POLICY,
> +       OCELOT_MASK_MODE_REDIRECT,
> +};
> +
> +struct ocelot_vcap_action {
> +       union {
> +               /* VCAP IS2 */
> +               struct {
> +                       bool cpu_copy_ena;
> +                       u8 cpu_qu_num;
> +                       enum ocelot_mask_mode mask_mode;
> +                       unsigned long port_mask;
> +                       bool police_ena;
> +                       struct ocelot_policer pol;
> +                       u32 pol_ix;
> +               };
> +       };
>  };
> 
>  struct ocelot_vcap_stats {
> @@ -192,7 +210,7 @@ struct ocelot_vcap_filter {
>         u16 prio;
>         u32 id;
> 
> -       enum ocelot_vcap_action action;
> +       struct ocelot_vcap_action action;
>         struct ocelot_vcap_stats stats;
>         unsigned long ingress_port_mask;
> 
> @@ -210,8 +228,6 @@ struct ocelot_vcap_filter {
>                 struct ocelot_vcap_key_ipv4 ipv4;
>                 struct ocelot_vcap_key_ipv6 ipv6;
>         } key;
> -       struct ocelot_policer pol;
> -       u32 pol_ix;
>  };
> 
>  int ocelot_vcap_filter_add(struct ocelot *ocelot,
> --
> 2.25.1
> 

-- 
/Horatiu
