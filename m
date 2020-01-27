Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC1E714AA2E
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 20:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgA0TC3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Jan 2020 14:02:29 -0500
Received: from mga05.intel.com ([192.55.52.43]:41690 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbgA0TC2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 14:02:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jan 2020 11:02:19 -0800
X-IronPort-AV: E=Sophos;i="5.70,370,1574150400"; 
   d="scan'208";a="401425509"
Received: from aguedesl-mac01.jf.intel.com (HELO localhost) ([10.24.12.123])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jan 2020 11:02:18 -0800
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200125005320.3353761-2-vinicius.gomes@intel.com>
References: <20200125005320.3353761-1-vinicius.gomes@intel.com> <20200125005320.3353761-2-vinicius.gomes@intel.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        vladimir.oltean@nxp.com, po.liu@nxp.com
Subject: Re: [PATCH net v1 1/3] taprio: Fix enabling offload with wrong number of traffic classes
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org
From:   Andre Guedes <andre.guedes@linux.intel.com>
Message-ID: <158015173854.43591.3142751689916523701@aguedesl-mac01.jf.intel.com>
User-Agent: alot/0.8.1
Date:   Mon, 27 Jan 2020 11:02:18 -0800
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

Quoting Vinicius Costa Gomes (2020-01-24 16:53:18)
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index c609373c8661..ad0dadcfcdba 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -1444,6 +1444,19 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>  
>         taprio_set_picos_per_byte(dev, q);
>  
> +       if (mqprio) {
> +               netdev_set_num_tc(dev, mqprio->num_tc);
> +               for (i = 0; i < mqprio->num_tc; i++)
> +                       netdev_set_tc_queue(dev, i,
> +                                           mqprio->count[i],
> +                                           mqprio->offset[i]);
> +
> +               /* Always use supplied priority mappings */
> +               for (i = 0; i <= TC_BITMASK; i++)
> +                       netdev_set_prio_tc_map(dev, i,
> +                                              mqprio->prio_tc_map[i]);
> +       }
> +
>         if (FULL_OFFLOAD_IS_ENABLED(taprio_flags))
>                 err = taprio_enable_offload(dev, mqprio, q, new_admin, extack);
>         else

If something goes wrong later within this function (e.g.
taprio_enable_offload() returns error), don't we want to roll back these
changes to the netdev object?

- Andre
