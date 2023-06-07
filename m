Return-Path: <netdev+bounces-9020-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0273672696A
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 21:05:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBEED2809B0
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:05:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F222C33C9F;
	Wed,  7 Jun 2023 19:05:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A016118
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 19:05:05 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E211FE2
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 12:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686164703; x=1717700703;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=p75LfayADWclA0qS6C2oCJqoK4q4HSImos1Z6tCU08A=;
  b=HRXZnK/UzDsWReyGvn6d7GC9LGKbzPaqug4YhHEYYVvPzO4D7ABsI41w
   fkznZm/5WfSw54SshH2lJJt28mGNA3gEvLPmo/Owx5GPk1dIXc92096vF
   0dUOS8bD7F2UdyM/diyJG7LHbZRlXZLjwWDCD3g1gUQ9eVs1/DL9NH1Z/
   QzI4Anvw/viCe8cPbNtVR4ThcABWr6hrJSYfVM5/FupEES1PRSM/nQhqk
   3QzbPowIp79gQ2/Vbu0/PvkWdi4A61IGAlp9ZVBMuOkuksrXL7FWzoy9K
   xFO2htc+lCHHMqBhsI2fxShqaVVDtVPadbzFq5hAaQoQwwB9grnlwefVV
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="360411919"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="360411919"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 12:05:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="854028379"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="854028379"
Received: from adtotpal-mobl.amr.corp.intel.com (HELO vcostago-mobl3) ([10.209.21.176])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 12:05:01 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
To: shaozhengchao <shaozhengchao@huawei.com>, Pedro Tammela
 <pctammela@mojatatu.com>, netdev@vger.kernel.org, jhs@mojatatu.com,
 xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc: vladimir.oltean@nxp.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH net] net/sched: taprio: fix slab-out-of-bounds Read in
 taprio_dequeue_from_txq
In-Reply-To: <4cbeb947-5230-4343-1380-95b2d81153d3@huawei.com>
References: <20230606121009.1942606-1-shaozhengchao@huawei.com>
 <e1e8a050-f6da-beb3-c93e-e2568bf0df05@mojatatu.com>
 <4cbeb947-5230-4343-1380-95b2d81153d3@huawei.com>
Date: Wed, 07 Jun 2023 12:05:00 -0700
Message-ID: <87o7lrqejn.fsf@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

shaozhengchao <shaozhengchao@huawei.com> writes:

> On 2023/6/6 23:10, Pedro Tammela wrote:
>> On 06/06/2023 09:10, Zhengchao Shao wrote:
>>> As shown in [1], when qdisc of the taprio type is set, count and=20
>>> offset in
>>> tc_to_txq can be set to 0. In this case, the value of *txq in
>>> taprio_next_tc_txq() will increases continuously. When the number of
>>> accessed queues exceeds the number of queues on the device, out-of-boun=
ds
>>> access occurs. Now the restriction on the queue number is added.
>>>
>>> [1] https://groups.google.com/g/syzkaller-bugs/c/_lYOKgkBVMg
>>> Fixes: 2f530df76c8c ("net/sched: taprio: give higher priority to=20
>>> higher TCs in software dequeue mode")
>>> Reported-by: syzbot+04afcb3d2c840447559a@syzkaller.appspotmail.com
>>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>>> ---
>>> =C2=A0 net/sched/sch_taprio.c | 2 +-
>>> =C2=A0 1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
>>> index 3c4c2c334878..dccb64425852 100644
>>> --- a/net/sched/sch_taprio.c
>>> +++ b/net/sched/sch_taprio.c
>>> @@ -801,7 +801,7 @@ static struct sk_buff=20
>>> *taprio_dequeue_tc_priority(struct Qdisc *sch,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 if (skb)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return skb;
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } while (q->cur_txq[tc] !=
=3D first_txq);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } while (q->cur_txq[tc] !=
=3D first_txq && q->cur_txq[tc] <=20
>>> dev->num_tx_queues);
>>=20
> Hi Pedro:
> 	Thank you for youe reply.
>> I'm not sure this is the correct fix.
>> If q->cur_txg[tc] =3D=3D dev->num_tx_queues the next call to=20
>> taprio_dequeue_tc_priority() for the same tc index will have
>> first_txq set to dev->num_tx_queues (no wrap around to first_txq happens=
).
> yes, maybe the same problem will occur at the next dequeue skb. It can
> be changed to the following:
> 			taprio_next_tc_txq(dev, tc, &q->cur_txq[tc]);
>
> +                       if (q->cur_txq[tc] =3D=3D dev->num_tx_queues)
> +                               q->cur_txq[tc] =3D first_txq;
> +
>                          if (skb)
>                                  return skb;
>                  } while (q->cur_txq[tc] !=3D first_txq);
> However, I prefer to limit the value of count in taprio_change(), so=20
> that I don't add extra judgment to the data path.
>
> Hi Vinicius,
> 	Do you have any better suggestions?

From a very quick look at the syzkaller report, I couldn't come up with
a config to trigger the issue.

But reading your report, the problematic case is having a bunch of
'0@0' in the "queues" map in the config, right?

A '0@0' would mean, in my opinion, that the user wants that a specific
TC to not have any queues associated with it, i.e. that it should be
ignored. Either that, or a configuration error.

Am I missing something?

>> If count and offset are 0 it will increment q->cur_txg[tc] and then bail=
=20
>> on the while condition but still growing unbounded (just slower than=20
>> before).
>>=20
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> =C2=A0 taprio_dequeue_tc_priority
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return NULL;
>>=20
>>=20

--=20
Vinicius

