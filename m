Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5DA205421
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 16:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732757AbgFWOHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 10:07:46 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:49684 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732698AbgFWOHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 10:07:45 -0400
X-Greylist: delayed 1351 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jun 2020 10:07:45 EDT
Received: from pps.filterd (m0122333.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NDbK4H011866;
        Tue, 23 Jun 2020 14:43:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=jan2016.eng;
 bh=VAlZ9T7k1ajEt0jZVlyc2Uc0FxRs9kP3mpORv6qIfbk=;
 b=Ncz6GPbXzeMEkE7nwAQ8WuzgERexiBK4CTD/DUy2NRDmyu4q+bvjFayhuTs+6pwuhisl
 xfO1zBP8+BmA2VfbyB0IazCaplBq1QdzuAb4DIenNvup97u80ffsdxzneWW9VFVSF5cx
 FaWKXdoxcE7aG68AFQCL2U2OXSjTtSoAxrYCPchv1lHLI9eY7/zlvUIjvbc0gjzMEY4M
 snhIeXliwuwQ6QIA6QZ06VR+PDoHePndcDoUDZZc+A/omjNzDzO7oQ3BOTCZTmfWbTKZ
 H0sg2dugPNYSa5OpEUWc/MX+P+WG8jFuEKP6uYYgWHBxzS4bisXKkBvcy5ijs/uyJi0V BQ== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 31s9qg6bb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 14:43:08 +0100
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 05NDZEE1032373;
        Tue, 23 Jun 2020 09:43:07 -0400
Received: from email.msg.corp.akamai.com ([172.27.123.31])
        by prod-mail-ppoint6.akamai.com with ESMTP id 31sdswuxbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 09:43:06 -0400
Received: from USMA1EX-CAS1.msg.corp.akamai.com (172.27.123.30) by
 usma1ex-dag3mb4.msg.corp.akamai.com (172.27.123.56) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Tue, 23 Jun 2020 09:43:05 -0400
Received: from bos-lpii8.145bw.corp.akamai.com (172.28.3.11) by
 USMA1EX-CAS1.msg.corp.akamai.com (172.27.123.30) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Tue, 23 Jun 2020 09:43:05 -0400
Received: by bos-lpii8.145bw.corp.akamai.com (Postfix, from userid 42339)
        id A0A8E17F650; Tue, 23 Jun 2020 09:43:05 -0400 (EDT)
From:   Michael Zhivich <mzhivich@akamai.com>
To:     <jonas.bonn@netrounds.com>
CC:     <davem@davemloft.net>, <john.fastabend@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <johunt@akamai.com>, <mzhivich@akamai.com>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc 
Date:   Tue, 23 Jun 2020 09:42:59 -0400
Message-ID: <20200623134259.8197-1-mzhivich@akamai.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_06:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 suspectscore=3 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006230108
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_06:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 suspectscore=3
 phishscore=0 lowpriorityscore=0 clxscore=1011 adultscore=0
 cotscore=-2147483648 priorityscore=1501 mlxscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006230108
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jonas Bonn <jonas.bonn@netrounds.com>
> To: Paolo Abeni <pabeni@redhat.com>,
> 	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
> 	LKML <linux-kernel@vger.kernel.org>,
> 	"David S . Miller" <davem@davemloft.net>,
> 	John Fastabend <john.fastabend@gmail.com>
> Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
> Date: Fri, 11 Oct 2019 02:39:48 +0200
> Message-ID: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com> (raw)
> In-Reply-To: <95c5a697932e19ebd6577b5dac4d7052fe8c4255.camel@redhat.com>
> 
> Hi Paolo,
> 
> On 09/10/2019 21:14, Paolo Abeni wrote:
> > Something alike the following code - completely untested - can possibly
> > address the issue, but it's a bit rough and I would prefer not adding
> > additonal complexity to the lockless qdiscs, can you please have a spin
> > a it?
> 
> We've tested a couple of variants of this patch today, but unfortunately 
> it doesn't fix the problem of packets getting stuck in the queue.
> 
> A couple of comments:
> 
> i) On 5.4, there is the BYPASS path that also needs the same treatment 
> as it's essentially replicating the behavour of qdisc_run, just without 
> the queue/dequeue steps
> 
> ii)  We are working a lot with the 4.19 kernel so I backported to the 
> patch to this version and tested there.  Here the solution would seem to 
> be more robust as the BYPASS path does not exist.
> 
> Unfortunately, in both cases we continue to see the issue of the "last 
> packet" getting stuck in the queue.
> 
> /Jonas

Hello Jonas, Paolo,

We have observed the same problem with pfifo_fast qdisc when sending periodic small
packets on a TCP flow with multiple simultaneous connections on a 4.19.75
kernel.  We've been able to catch it in action using perf probes (see trace
below).  For qdisc = 0xffff900d7c247c00, skb = 0xffff900b72c334f0,
it takes 200270us to traverse the networking stack on a system that's not otherwise busy.
qdisc only resumes processing when another enqueued packet comes in,
so the packet could have been stuck indefinitely.

   proc-19902 19902 [032] 580644.045480: probe:pfifo_fast_dequeue_end: (ffffffff9b69d99d) qdisc=0xffff900d7c247c00 skb=0xffff900bfc294af0 band=2 atomic_qlen=0
   proc-19902 19902 [032] 580644.045480:     probe:pfifo_fast_dequeue: (ffffffff9b69d8c0) qdisc=0xffff900d7c247c00 skb=0xffffffff9b69d8c0 band=2
   proc-19927 19927 [014] 580644.045480:      probe:tcp_transmit_skb2: (ffffffff9b6dc4e5) skb=0xffff900b72c334f0 sk=0xffff900d62958040 source=0x4b4e dest=0x9abe
   proc-19902 19902 [032] 580644.045480: probe:pfifo_fast_dequeue_end: (ffffffff9b69d99d) qdisc=0xffff900d7c247c00 skb=0x0 band=3 atomic_qlen=0
   proc-19927 19927 [014] 580644.045481:      probe:ip_finish_output2: (ffffffff9b6bc650) net=0xffffffff9c107c80 sk=0xffff900d62958040 skb=0xffff900b72c334f0 __func__=0x0
   proc-19902 19902 [032] 580644.045481:        probe:sch_direct_xmit: (ffffffff9b69e570) skb=0xffff900bfc294af0 q=0xffff900d7c247c00 dev=0xffff900d6a140000 txq=0xffff900d6a181180 root_lock=0x0 validate=1 ret=-1 again=155
   proc-19927 19927 [014] 580644.045481:            net:net_dev_queue: dev=eth0 skbaddr=0xffff900b72c334f0 len=115
   proc-19902 19902 [032] 580644.045482:     probe:pfifo_fast_dequeue: (ffffffff9b69d8c0) qdisc=0xffff900d7c247c00 skb=0xffffffff9b69d8c0 band=1
   proc-19927 19927 [014] 580644.045483:     probe:pfifo_fast_enqueue: (ffffffff9b69d9f0) skb=0xffff900b72c334f0 qdisc=0xffff900d7c247c00 to_free=18446622925407304000
   proc-19902 19902 [032] 580644.045483: probe:pfifo_fast_dequeue_end: (ffffffff9b69d99d) qdisc=0xffff900d7c247c00 skb=0x0 band=3 atomic_qlen=0
   proc-19927 19927 [014] 580644.045483: probe:pfifo_fast_enqueue_end: (ffffffff9b69da9f) skb=0xffff900b72c334f0 qdisc=0xffff900d7c247c00 to_free=0xffff91d0f67ab940 atomic_qlen=1
   proc-19902 19902 [032] 580644.045484:          probe:__qdisc_run_2: (ffffffff9b69ea5a) q=0xffff900d7c247c00 packets=1
   proc-19927 19927 [014] 580644.245745:     probe:pfifo_fast_enqueue: (ffffffff9b69d9f0) skb=0xffff900d98fdf6f0 qdisc=0xffff900d7c247c00 to_free=18446622925407304000
   proc-19927 19927 [014] 580644.245745: probe:pfifo_fast_enqueue_end: (ffffffff9b69da9f) skb=0xffff900d98fdf6f0 qdisc=0xffff900d7c247c00 to_free=0xffff91d0f67ab940 atomic_qlen=2
   proc-19927 19927 [014] 580644.245746:     probe:pfifo_fast_dequeue: (ffffffff9b69d8c0) qdisc=0xffff900d7c247c00 skb=0xffffffff9b69d8c0 band=0
   proc-19927 19927 [014] 580644.245746: probe:pfifo_fast_dequeue_end: (ffffffff9b69d99d) qdisc=0xffff900d7c247c00 skb=0xffff900b72c334f0 band=2 atomic_qlen=1
   proc-19927 19927 [014] 580644.245747:     probe:pfifo_fast_dequeue: (ffffffff9b69d8c0) qdisc=0xffff900d7c247c00 skb=0xffffffff9b69d8c0 band=2
   proc-19927 19927 [014] 580644.245747: probe:pfifo_fast_dequeue_end: (ffffffff9b69d99d) qdisc=0xffff900d7c247c00 skb=0xffff900d98fdf6f0 band=2 atomic_qlen=0
   proc-19927 19927 [014] 580644.245748:     probe:pfifo_fast_dequeue: (ffffffff9b69d8c0) qdisc=0xffff900d7c247c00 skb=0xffffffff9b69d8c0 band=2
   proc-19927 19927 [014] 580644.245748: probe:pfifo_fast_dequeue_end: (ffffffff9b69d99d) qdisc=0xffff900d7c247c00 skb=0x0 band=3 atomic_qlen=0
   proc-19927 19927 [014] 580644.245749:          qdisc:qdisc_dequeue: dequeue ifindex=5 qdisc handle=0x0 parent=0xF txq_state=0x0 packets=2 skbaddr=0xffff900b72c334f0
   proc-19927 19927 [014] 580644.245749:        probe:sch_direct_xmit: (ffffffff9b69e570) skb=0xffff900b72c334f0 q=0xffff900d7c247c00 dev=0xffff900d6a140000 txq=0xffff900d6a181180 root_lock=0x0 validate=1 ret=-1 again=155
   proc-19927 19927 [014] 580644.245750:       net:net_dev_start_xmit: dev=eth0 queue_mapping=14 skbaddr=0xffff900b72c334f0 vlan_tagged=0 vlan_proto=0x0000 vlan_tci=0x0000 protocol=0x0800 ip_summed=3 len=115 data_len=0 network_offset=14 transport_offset_valid=1 transport_offset=34 tx_flags=0 gso_size=0 gso_segs=1 gso_type=0x1

I was wondering if you had any more luck in finding a solution or workaround for this problem
(that is, aside from switching to a different qdisc)?

Thanks,
~ Michael
