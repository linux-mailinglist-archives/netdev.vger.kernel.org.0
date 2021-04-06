Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9B8355378
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343879AbhDFMSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:18:05 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3516 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232866AbhDFMSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 08:18:04 -0400
Received: from DGGEML401-HUB.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FF61k46rPzRZGC;
        Tue,  6 Apr 2021 20:15:54 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 DGGEML401-HUB.china.huawei.com (10.3.17.32) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 6 Apr 2021 20:17:53 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Tue, 6 Apr 2021
 20:17:54 +0800
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
To:     Juergen Gross <jgross@suse.com>, Michal Kubecek <mkubecek@suse.cz>
CC:     Jiri Kosina <jikos@kernel.org>, Hillf Danton <hdanton@sina.com>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kehuan Feng <kehuan.feng@gmail.com>,
        "Jike Song" <albcamus@gmail.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        "Michael Zhivich" <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Josh Hunt <johunt@akamai.com>
References: <20200827125747.5816-1-hdanton@sina.com>
 <CACS=qq+a0H=e8yLFu95aE7Hr0bQ9ytCBBn2rFx82oJnPpkBpvg@mail.gmail.com>
 <CAM_iQpV-JMURzFApp-Zhxs3QN9j=Zdf6yqwOP=E42ERDHxe6Hw@mail.gmail.com>
 <dd73f551d1fc89e457ffabd106cbf0bf401b747b.camel@redhat.com>
 <CAM_iQpXZMeAGkq_=rG6KEabFNykszpRU_Hnv65Qk7yesvbRDrw@mail.gmail.com>
 <5f51cbad3cc2_3eceb208fc@john-XPS-13-9370.notmuch>
 <nycvar.YFH.7.76.2104022120050.12405@cbobk.fhfr.pm>
 <20210403003537.2032-1-hdanton@sina.com>
 <nycvar.YFH.7.76.2104031420470.12405@cbobk.fhfr.pm>
 <eaff25bc-9b64-037e-b9bc-c06fc4a5a9fb@huawei.com>
 <20210406070659.t6csfgkskbmmxtx5@lion.mk-sys.cz>
 <2ddff17a-8af5-0b73-4a48-859726f26df3@suse.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <9325638d-7fc3-9650-cabe-b42dc5ab5790@huawei.com>
Date:   Tue, 6 Apr 2021 20:17:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <2ddff17a-8af5-0b73-4a48-859726f26df3@suse.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme710-chm.china.huawei.com (10.1.199.106) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/4/6 18:13, Juergen Gross wrote:
> On 06.04.21 09:06, Michal Kubecek wrote:
>> On Tue, Apr 06, 2021 at 08:55:41AM +0800, Yunsheng Lin wrote:
>>>
>>> Hi, Jiri
>>> Do you have a reproducer that can be shared here?
>>> With reproducer, I can debug and test it myself too.
>>
>> I'm afraid we are not aware of a simple reproducer. As mentioned in the
>> original discussion, the race window is extremely small and the other
>> thread has to do quite a lot in the meantime which is probably why, as
>> far as I know, this was never observed on real hardware, only in
>> virtualization environments. NFS may also be important as, IIUC, it can
>> often issue an RPC request from a different CPU right after a data
>> transfer. Perhaps you could cheat a bit and insert a random delay
>> between the empty queue check and releasing q->seqlock to make it more
>> likely to happen.
>>
>> Other than that, it's rather just "run this complex software in a xen VM
>> and wait".
> 
> Being the one who has managed to reproduce the issue I can share my
> setup, maybe you can setup something similar (we have seen the issue
> with this kind of setup on two different machines).
> 
> I'm using a physical machine with 72 cpus and 48 GB of memory. It is
> running Xen as virtualization platform.
> 
> Xen dom0 is limited to 40 vcpus and 32 GB of memory, the dom0 vcpus are
> limited to run on the first 40 physical cpus (no idea whether that
> matters, though).
> 
> In a guest with 16 vcpu and 8GB of memory I'm running 8 parallel
> sysbench instances in a loop, those instances are prepared via
> 
> sysbench --file-test-mode=rndrd --test=fileio prepare
> 
> and then started in a do while loop via:
> 
> sysbench --test=fileio --file-test-mode=rndrw --rand-seed=0 --max-time=300 --max-requests=0 run
> 
> Each instance is using a dedicated NFS mount to run on. The NFS
> server for the 8 mounts is running in dom0 of the same server, the
> data of the NFS shares is located in a RAM disk (size is a little bit
> above 16GB). The shares are mounted in the guest with:
> 
> mount -t nfs -o rw,proto=tcp,nolock,nfsvers=3,rsize=65536,wsize=65536,nosharetransport dom0:/ramdisk/share[1-8] /mnt[1-8]
> 
> The guests vcpus are limited to run on physical cpus 40-55, on the same
> physical cpus I have 16 small guests running eating up cpu time, each of
> those guests is pinned to one of the physical cpus 40-55.
> 
> That's basically it. All you need to do is to watch out for sysbench
> reporting maximum latencies above one second or so (in my setup there
> are latencies of several minutes at least once each hour of testing).
> 
> In case you'd like to have some more details about the setup don't
> hesitate to contact me directly. I can provide you with some scripts
> and config runes if you want.

The setup is rather complex, I just tried Michal' suggestion using
the below patch:

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 9fb0ad4..b691eda 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -207,6 +207,11 @@ static inline void qdisc_run_end(struct Qdisc *qdisc)
 {
        write_seqcount_end(&qdisc->running);
        if (qdisc->flags & TCQ_F_NOLOCK) {
+               udelay(10000);
+               udelay(10000);
+               udelay(10000);
+               udelay(10000);
+               udelay(10000);
                spin_unlock(&qdisc->seqlock);

                if (unlikely(test_bit(__QDISC_STATE_MISSED,
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 6d7f954..a83c520 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -630,6 +630,8 @@ static int pfifo_fast_enqueue(struct sk_buff *skb, struct Qdisc *qdisc,
                        return qdisc_drop_cpu(skb, qdisc, to_free);
                else
                        return qdisc_drop(skb, qdisc, to_free);
+       } else {
+               skb->enqueue_jiffies = jiffies;
        }

        qdisc_update_stats_at_enqueue(qdisc, pkt_len);
@@ -653,6 +655,13 @@ static struct sk_buff *pfifo_fast_dequeue(struct Qdisc *qdisc)
                skb = __skb_array_consume(q);
        }
        if (likely(skb)) {
+               unsigned int delay_ms;
+
+               delay_ms = jiffies_to_msecs(jiffies - skb->enqueue_jiffies);
linyunsheng@plinth:~/ci/kernel$ vi qdisc_reproducer.patch
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -920,7 +920,7 @@ struct sk_buff {
                                *data;
        unsigned int            truesize;
        refcount_t              users;
-
+       unsigned long           enqueue_jiffies;
 #ifdef CONFIG_SKB_EXTENSIONS
        /* only useable after checking ->active_extensions != 0 */
        struct skb_ext          *extensions;
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 639e465..ba39b86 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -176,8 +176,14 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 static inline void qdisc_run_end(struct Qdisc *qdisc)
 {
        write_seqcount_end(&qdisc->running);
-       if (qdisc->flags & TCQ_F_NOLOCK)
+       if (qdisc->flags & TCQ_F_NOLOCK) {
+               udelay(10000);
+               udelay(10000);
+               udelay(10000);
+               udelay(10000);
+               udelay(10000);
                spin_unlock(&qdisc->seqlock);
+       }
 }

 static inline bool qdisc_may_bulk(const struct Qdisc *qdisc)
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 49eae93..fcfae43 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -630,6 +630,8 @@ static int pfifo_fast_enqueue(struct sk_buff *skb, struct Qdisc *qdisc,
                        return qdisc_drop_cpu(skb, qdisc, to_free);
                else
                        return qdisc_drop(skb, qdisc, to_free);
+       } else {
+               skb->enqueue_jiffies = jiffies;
        }

        qdisc_update_stats_at_enqueue(qdisc, pkt_len);
@@ -651,6 +653,13 @@ static struct sk_buff *pfifo_fast_dequeue(struct Qdisc *qdisc)
                skb = __skb_array_consume(q);
        }
        if (likely(skb)) {
+               unsigned int delay_ms;
+
+               delay_ms = jiffies_to_msecs(jiffies - skb->enqueue_jiffies);
+
+               if (delay_ms > 100)
+                       netdev_err(qdisc_dev(qdisc), "delay: %u ms\n", delay_ms);
+
                qdisc_update_stats_at_dequeue(qdisc, skb);
        } else {
                WRITE_ONCE(qdisc->empty, true);


Using the below shell:

while((1))
do
taskset -c 0 mz dummy1 -d 10000 -c 100&
taskset -c 1 mz dummy1 -d 10000 -c 100&
taskset -c 2 mz dummy1 -d 10000 -c 100&
sleep 3
done

And got the below log:
[   80.881716] hns3 0000:bd:00.0 eth2: delay: 176 ms
[   82.036564] hns3 0000:bd:00.0 eth2: delay: 296 ms
[   87.065820] hns3 0000:bd:00.0 eth2: delay: 320 ms
[   94.134174] dummy1: delay: 1588 ms
[   94.137570] dummy1: delay: 1580 ms
[   94.140963] dummy1: delay: 1572 ms
[   94.144354] dummy1: delay: 1568 ms
[   94.147745] dummy1: delay: 1560 ms
[   99.065800] hns3 0000:bd:00.0 eth2: delay: 264 ms
[  100.106174] dummy1: delay: 1448 ms
[  102.169799] hns3 0000:bd:00.0 eth2: delay: 436 ms
[  103.166221] dummy1: delay: 1604 ms
[  103.169617] dummy1: delay: 1604 ms
[  104.985806] dummy1: delay: 316 ms
[  105.113797] hns3 0000:bd:00.0 eth2: delay: 308 ms
[  107.289805] hns3 0000:bd:00.0 eth2: delay: 556 ms
[  108.912922] hns3 0000:bd:00.0 eth2: delay: 188 ms
[  137.241801] dummy1: delay: 30624 ms
[  137.245283] dummy1: delay: 30620 ms
[  137.248760] dummy1: delay: 30616 ms
[  137.252237] dummy1: delay: 30616 ms


It seems the problem can be easily reproduced using Michal'
suggestion.

Will test and debug it using the above reproducer first.

> 
> 
> Juergen

