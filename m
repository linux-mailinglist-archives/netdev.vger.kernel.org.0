Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2BB329D78F
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732623AbgJ1WZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:25:35 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:63492 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732935AbgJ1WZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:25:33 -0400
X-Greylist: delayed 2995 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Oct 2020 18:25:33 EDT
Received: from pps.filterd (m0122332.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09SHbWhl002635;
        Wed, 28 Oct 2020 17:46:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=6wX4+YUFFlN6GjX/L0NOGDRSt7BL+3KQlhqyt0N2YFE=;
 b=g0q3fSMca64I61CCk+QrR4Suhn8lFJ1pbMndtRFaWDFg8cDfqf+nzeD1ir3AVaj1T6Oy
 A5f57UyHE+G2ve1UX0qNJzsRelZFqxCxDaUtqRMomndIGveBqJF2qaWEmJ4f61G2tGe3
 fyA3hfcXJZeP80WDF7VFvsVObFulvP+0EFY6pl3DcqjdgBJhHNyKUAsuNJmwSjah0Xjk
 At9pxaUg7lWnNjYEIBQK2j92FvnhGbDHGv/W3R+qMWO2RxudcIqVGtVJ/gu9ab16uv2/
 3XJTO3rBiS4Vs/inlc904qCj5nwfxW59eheN5tgcLshuPZZHIkS2GWILbn5RfarOB2Yn dw== 
Received: from prod-mail-ppoint8 (a72-247-45-34.deploy.static.akamaitechnologies.com [72.247.45.34] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 34ccbhk52w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 17:46:13 +0000
Received: from pps.filterd (prod-mail-ppoint8.akamai.com [127.0.0.1])
        by prod-mail-ppoint8.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 09SHZ8Hc016636;
        Wed, 28 Oct 2020 13:46:12 -0400
Received: from prod-mail-relay19.dfw02.corp.akamai.com ([172.27.165.173])
        by prod-mail-ppoint8.akamai.com with ESMTP id 34f1pxdj6x-1;
        Wed, 28 Oct 2020 13:46:12 -0400
Received: from [0.0.0.0] (prod-ssh-gw01.bos01.corp.akamai.com [172.27.119.138])
        by prod-mail-relay19.dfw02.corp.akamai.com (Postfix) with ESMTP id 41E22604F7;
        Wed, 28 Oct 2020 17:46:11 +0000 (GMT)
Subject: Re: Re: [PATCH v2 net] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@huawei.com,
        John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Hunt, Joshua" <johunt@akamai.com>
References: <1599562954-87257-1-git-send-email-linyunsheng@huawei.com>
 <CAM_iQpX0_mz+McZdzZ7HFTjBihOKz5E6i4qJQSoFbZ=SZkVh=Q@mail.gmail.com>
 <830f85b5-ef29-c68e-c982-de20ac880bd9@huawei.com>
 <CAM_iQpU_tbRNO=Lznz_d6YjXmenYhowEfBoOiJgEmo9x8bEevw@mail.gmail.com>
From:   Vishwanath Pai <vpai@akamai.com>
Message-ID: <05ff05ff-884e-a3b9-2186-3ba0e3e88f28@akamai.com>
Date:   Wed, 28 Oct 2020 13:46:10 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpU_tbRNO=Lznz_d6YjXmenYhowEfBoOiJgEmo9x8bEevw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-28_08:2020-10-28,2020-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010280116
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-28_08:2020-10-28,2020-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=999 spamscore=0 adultscore=0 phishscore=0
 malwarescore=0 priorityscore=1501 bulkscore=0 mlxscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010280116
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 72.247.45.34)
 smtp.mailfrom=vpai@akamai.com smtp.helo=prod-mail-ppoint8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/20 3:26 PM, Cong Wang wrote:
 > On Fri, Sep 11, 2020 at 1:13 AM Yunsheng Lin <linyunsheng@huawei.com> 
wrote:
 >>
 >> On 2020/9/11 4:07, Cong Wang wrote:
 >>> On Tue, Sep 8, 2020 at 4:06 AM Yunsheng Lin 
<linyunsheng@huawei.com> wrote:
 >>>>
 >>>> Currently there is concurrent reset and enqueue operation for the
 >>>> same lockless qdisc when there is no lock to synchronize the
 >>>> q->enqueue() in __dev_xmit_skb() with the qdisc reset operation in
 >>>> qdisc_deactivate() called by dev_deactivate_queue(), which may cause
 >>>> out-of-bounds access for priv->ring[] in hns3 driver if user has
 >>>> requested a smaller queue num when __dev_xmit_skb() still enqueue a
 >>>> skb with a larger queue_mapping after the corresponding qdisc is
 >>>> reset, and call hns3_nic_net_xmit() with that skb later.
 >>>>
 >>>> Reused the existing synchronize_net() in dev_deactivate_many() to
 >>>> make sure skb with larger queue_mapping enqueued to old qdisc(which
 >>>> is saved in dev_queue->qdisc_sleeping) will always be reset when
 >>>> dev_reset_queue() is called.
 >>>>
 >>>> Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")
 >>>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
 >>>> ---
 >>>> ChangeLog V2:
 >>>>         Reuse existing synchronize_net().
 >>>> ---
 >>>>  net/sched/sch_generic.c | 48 
+++++++++++++++++++++++++++++++++---------------
 >>>>  1 file changed, 33 insertions(+), 15 deletions(-)
 >>>>
 >>>> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
 >>>> index 265a61d..54c4172 100644
 >>>> --- a/net/sched/sch_generic.c
 >>>> +++ b/net/sched/sch_generic.c
 >>>> @@ -1131,24 +1131,10 @@ EXPORT_SYMBOL(dev_activate);
 >>>>
 >>>>  static void qdisc_deactivate(struct Qdisc *qdisc)
 >>>>  {
 >>>> -       bool nolock = qdisc->flags & TCQ_F_NOLOCK;
 >>>> -
 >>>>         if (qdisc->flags & TCQ_F_BUILTIN)
 >>>>                 return;
 >>>> -       if (test_bit(__QDISC_STATE_DEACTIVATED, &qdisc->state))
 >>>> -               return;
 >>>> -
 >>>> -       if (nolock)
 >>>> - spin_lock_bh(&qdisc->seqlock);
 >>>> -       spin_lock_bh(qdisc_lock(qdisc));
 >>>>
 >>>>         set_bit(__QDISC_STATE_DEACTIVATED, &qdisc->state);
 >>>> -
 >>>> -       qdisc_reset(qdisc);
 >>>> -
 >>>> -       spin_unlock_bh(qdisc_lock(qdisc));
 >>>> -       if (nolock)
 >>>> - spin_unlock_bh(&qdisc->seqlock);
 >>>>  }
 >>>>
 >>>>  static void dev_deactivate_queue(struct net_device *dev,
 >>>> @@ -1165,6 +1151,30 @@ static void dev_deactivate_queue(struct 
net_device *dev,
 >>>>         }
 >>>>  }
 >>>>
 >>>> +static void dev_reset_queue(struct net_device *dev,
 >>>> +                           struct netdev_queue *dev_queue,
 >>>> +                           void *_unused)
 >>>> +{
 >>>> +       struct Qdisc *qdisc;
 >>>> +       bool nolock;
 >>>> +
 >>>> +       qdisc = dev_queue->qdisc_sleeping;
 >>>> +       if (!qdisc)
 >>>> +               return;
 >>>> +
 >>>> +       nolock = qdisc->flags & TCQ_F_NOLOCK;
 >>>> +
 >>>> +       if (nolock)
 >>>> + spin_lock_bh(&qdisc->seqlock);
 >>>> +       spin_lock_bh(qdisc_lock(qdisc));
 >>>
 >>>
 >>> I think you do not need this lock for lockless one.
 >>
 >> It seems so.
 >> Maybe another patch to remove qdisc_lock(qdisc) for lockless
 >> qdisc?
 >
 > Yeah, but not sure if we still want this lockless qdisc any more,
 > it brings more troubles than gains.
 >
 >>
 >>
 >>>
 >>>> +
 >>>> +       qdisc_reset(qdisc);
 >>>> +
 >>>> +       spin_unlock_bh(qdisc_lock(qdisc));
 >>>> +       if (nolock)
 >>>> + spin_unlock_bh(&qdisc->seqlock);
 >>>> +}
 >>>> +
 >>>>  static bool some_qdisc_is_busy(struct net_device *dev)
 >>>>  {
 >>>>         unsigned int i;
 >>>> @@ -1213,12 +1223,20 @@ void dev_deactivate_many(struct list_head 
*head)
 >>>>                 dev_watchdog_down(dev);
 >>>>         }
 >>>>
 >>>> -       /* Wait for outstanding qdisc-less dev_queue_xmit calls.
 >>>> +       /* Wait for outstanding qdisc-less dev_queue_xmit calls or
 >>>> +        * outstanding qdisc enqueuing calls.
 >>>>          * This is avoided if all devices are in dismantle phase :
 >>>>          * Caller will call synchronize_net() for us
 >>>>          */
 >>>>         synchronize_net();
 >>>>
 >>>> +       list_for_each_entry(dev, head, close_list) {
 >>>> +               netdev_for_each_tx_queue(dev, dev_reset_queue, NULL);
 >>>> +
 >>>> +               if (dev_ingress_queue(dev))
 >>>> +                       dev_reset_queue(dev, 
dev_ingress_queue(dev), NULL);
 >>>> +       }
 >>>> +
 >>>>         /* Wait for outstanding qdisc_run calls. */
 >>>>         list_for_each_entry(dev, head, close_list) {
 >>>>                 while (some_qdisc_is_busy(dev)) {
 >>>
 >>> Do you want to reset before waiting for TX action?
 >>>
 >>> I think it is safer to do it after, at least prior to commit 759ae57f1b
 >>> we did after.
 >>
 >> The reference to the txq->qdisc is always protected by RCU, so the 
synchronize_net()
 >> should be enought to ensure there is no skb enqueued to the old 
qdisc that is saved
 >> in the dev_queue->qdisc_sleeping, because __dev_queue_xmit can only 
see the new qdisc
 >> after synchronize_net(), which is noop_qdisc, and noop_qdisc will 
make sure any skb
 >> enqueued to it will be dropped and freed, right?
 >
 > Hmm? In net_tx_action(), we do not hold RCU read lock, and we do not
 > reference qdisc via txq->qdisc but via sd->output_queue.
 >
 >
 >>
 >> If we do any additional reset that is not related to qdisc in 
dev_reset_queue(), we
 >> can move it after some_qdisc_is_busy() checking.
 >
 > I am not suggesting to do an additional reset, I am suggesting to move
 > your reset after the busy waiting.
 >
 > Thanks.

Re-sending this, looks like my previous email did not get delivered
somehow.

We noticed some problems when testing the latest 5.4 LTS kernel and
traced it back to this commit using git bisect. When running our tests
the machine stops responding to all traffic and the only way to recover
is a reboot. I do not see a stack trace on the console.

This can be reproduced using the packetdrill test below, it should be
run a few times or in a loop. You should hit this issue within a few
tries but sometimes might take up to 15-20 tries.

*** TEST BEGIN ***

0 `echo 4 > /proc/sys/net/ipv4/tcp_min_tso_segs`

0.400 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
0.400 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0

// set maxseg to 1000 to work with both ipv4 and ipv6
0.500 setsockopt(3, SOL_TCP, TCP_MAXSEG, [1000], 4) = 0
0.500 bind(3, ..., ...) = 0
0.500 listen(3, 1) = 0

// Establish connection
0.600 < S 0:0(0) win 32792 <mss 1000,sackOK,nop,nop,nop,wscale 5>
0.600 > S. 0:0(0) ack 1 <...>

0.800 < . 1:1(0) ack 1 win 320
0.800 accept(3, ..., ...) = 4

// Send 4 data segments.
+0 write(4, ..., 4000) = 4000
+0 > P. 1:4001(4000) ack 1

// Receive a SACK
+.1 < . 1:1(0) ack 1 win 320 <sack 1001:2001,nop,nop>

+.3 %{ print "TCP CA state: ",tcpi_ca_state  }%

*** TEST END ***

I can reproduce the issue easily on v5.4.68, and after reverting this 
commit it
does not happen anymore.

Thanks,
Vishwanath

