Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD5FB14AA54
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 20:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgA0TRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 14:17:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:41281 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbgA0TRg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 14:17:36 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jan 2020 11:17:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,370,1574150400"; 
   d="scan'208";a="429091229"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.26])
  by fmsmga006.fm.intel.com with ESMTP; 27 Jan 2020 11:17:35 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Andre Guedes <andre.guedes@linux.intel.com>, netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, vladimir.oltean@nxp.com, po.liu@nxp.com
Subject: Re: [PATCH net v1 1/3] taprio: Fix enabling offload with wrong number of traffic classes
In-Reply-To: <158015173854.43591.3142751689916523701@aguedesl-mac01.jf.intel.com>
References: <20200125005320.3353761-1-vinicius.gomes@intel.com> <20200125005320.3353761-2-vinicius.gomes@intel.com> <158015173854.43591.3142751689916523701@aguedesl-mac01.jf.intel.com>
Date:   Mon, 27 Jan 2020 11:18:51 -0800
Message-ID: <87h80giu78.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andre,

Andre Guedes <andre.guedes@linux.intel.com> writes:

> Hi Vinicius,
>
> Quoting Vinicius Costa Gomes (2020-01-24 16:53:18)
>> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
>> index c609373c8661..ad0dadcfcdba 100644
>> --- a/net/sched/sch_taprio.c
>> +++ b/net/sched/sch_taprio.c
>> @@ -1444,6 +1444,19 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>>  
>>         taprio_set_picos_per_byte(dev, q);
>>  
>> +       if (mqprio) {
>> +               netdev_set_num_tc(dev, mqprio->num_tc);
>> +               for (i = 0; i < mqprio->num_tc; i++)
>> +                       netdev_set_tc_queue(dev, i,
>> +                                           mqprio->count[i],
>> +                                           mqprio->offset[i]);
>> +
>> +               /* Always use supplied priority mappings */
>> +               for (i = 0; i <= TC_BITMASK; i++)
>> +                       netdev_set_prio_tc_map(dev, i,
>> +                                              mqprio->prio_tc_map[i]);
>> +       }
>> +
>>         if (FULL_OFFLOAD_IS_ENABLED(taprio_flags))
>>                 err = taprio_enable_offload(dev, mqprio, q, new_admin, extack);
>>         else
>
> If something goes wrong later within this function (e.g.
> taprio_enable_offload() returns error), don't we want to roll back these
> changes to the netdev object?

If something goes wrong, and change() returns an error, taprio_destroy()
is called, and the changes are undone.


Cheers,
--
Vinicius
