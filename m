Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC15215DF9
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 20:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbgGFSII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 14:08:08 -0400
Received: from out0-141.mail.aliyun.com ([140.205.0.141]:49322 "EHLO
        out0-141.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729769AbgGFSIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 14:08:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1594058883; h=From:Subject:To:Message-ID:Date:MIME-Version:Content-Type;
        bh=OfC4LYHq/HdmT1GRTSNcAjtaqnv5WtYJ1GWpOOmTidQ=;
        b=mBmDUyEHV+THf6bIMJ3f5k295J7aqIhmbtO4qPts+/0uMD05hGZwVQ1WoZsbpgpBP8SAYeZ14p9Q3MQc2nnKb3rl24+LSY1HCAAEdVIEDtUmiQ9wzAndkrmHkClCTHLrO8kEFLNg4PXXH59P4Yo6pC27cXYXyyyNP7hPNId5H4I=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e02c03268;MF=xiangning.yu@alibaba-inc.com;NM=1;PH=DS;RN=1;SR=0;TI=SMTPD_---.Hz2LrlX_1594058882;
Received: from US-118000MP.local(mailfrom:xiangning.yu@alibaba-inc.com fp:SMTPD_---.Hz2LrlX_1594058882)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 07 Jul 2020 02:08:02 +0800
From:   "=?UTF-8?B?WVUsIFhpYW5nbmluZw==?=" <xiangning.yu@alibaba-inc.com>
Subject: [PATCH net-next 0/2] Lockless Token Bucket (LTB) Qdisc
To:     netdev@vger.kernel.org
Message-ID: <51ce528c-6bdc-737d-807e-f1c250361e67@alibaba-inc.com>
Date:   Tue, 07 Jul 2020 02:08:01 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello netdev,

Lockless Token Bucket(LTB) is a high performance traffic control (TC) qdisc
kernel module. The idea is to scale bandwidth sharing in data center
networks.  Such that online latency sensitive applications could be
deployed together with big data applications.

Many thanks to the lockless qdisc patch, we achieve this design goal by
eliminating all locks from the critical data path. Briefly, We decouple
rate limiting and bandwidth sharing, while still maintaining the rate and
ceiling semantics introduced by HTB qdisc.

The maximum rate limiting is implemented with a three-stages pipeline
running at a high frequency. In a more detail, we use socket priority to
classify skbs to different ltb classes, then we aggregate skbs from all
CPUS into a single queue called the drain queue. We apply token bucket
algorithm on the drain queue to perform rate limiting. After that, we fan
out the skbs back to the per-CPU fan out queues to continue transmission. 

The bandwidth sharing is offloaded to a kernel thread, which is outside of
the critical data path. It adjusts each TC class’s maximum rate at a much
lower frequency. The algorithm we use to do bandwidth sharing is inspired
by the idea presented in [1].

Here’s some quick results we get with pktgen over a 10Gbps link.

./samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh –i eth0 -t $NUM

We ran it four times and calculated the sum of the results. We did this for
5, 10, 20, and 30 threads with both HTB and LTB. We have seen significant
performance gain. And we believe there are still rooms for further
improvement.

HTB:
5:  1365793 1367419 1367896 1365359
10: 1130063 1131307 1130035 1130385
20: 629792  629517  629219  629234
30: 582358  582537  582707  582716

LTB:
5:  3738416 3745033 3743431 3744847
10: 8327665 8327129 8320331 8322122
20: 6972309 6976670 6975789 6967784
30: 7742397 7742951 7738911 7742812

The real workloads also demonstrate that LTB outperforms HTB significantly
especially under heavy traffic, and it scales well to 2 * 25 Gbps networks.

Hence, we would like to share this work with the Linux community, and
sincerely welcome any feedback and comments. Thank you!

[1] To, Khoa and Firestone, Daniel and Varghese, George and Padhye,
Jitendra, Measurement Based Fair Queuing for Allocating Bandwidth to
Virtual Machines.  https://dl.acm.org/doi/abs/10.1145/2940147.2940153

-- 
Xiangning Yu (2):
	irq_work: Export symbol "irq_work_queue_on"
	net: sched: Lockless Token Bucket (LTB) qdisc

 include/uapi/linux/pkt_sched.h |   35 ++
 kernel/irq_work.c              |    2 +-
 net/sched/Kconfig              |   12 +
 net/sched/Makefile             |    1 +
 net/sched/sch_ltb.c            | 1280 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 1329 insertions(+), 1 deletion(-)
