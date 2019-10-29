Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8BCE8F1F
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 19:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbfJ2SUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 14:20:08 -0400
Received: from mail-qt1-f175.google.com ([209.85.160.175]:34123 "EHLO
        mail-qt1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727257AbfJ2SUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 14:20:07 -0400
Received: by mail-qt1-f175.google.com with SMTP id e14so21661583qto.1
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 11:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=tTRniwbcPLKXRnpW/JCuGFS7vvY/A+yaJAcXp4V/lBc=;
        b=DByKVfdEI2VjddxXJFSVjgsbEH0GBXJlbClAt9sI63KLrAccRUQwZ0aLMeffdpPMYt
         Ald0ibfTLaa1/BYW29DobMFu3DjzDSVeAZ+Iq5YnXHanc3SpmM+U1g/uCmBksAN4jj+N
         YE8ED2t9ZI/WF8HO8FqkIuvZV/x5RlGPSoElk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=tTRniwbcPLKXRnpW/JCuGFS7vvY/A+yaJAcXp4V/lBc=;
        b=CZlB++eVvEi8lZkchE6AX/xsEP5XbVEQ1inrT7CsrgZN2+is2io6Auc302hW1kGH35
         DvAe/5py58JUCyj2FKMERcubujVTizp8hNyp5yoWddY9H2vfJ7HUtdeRIQpKhJwet7x1
         jkDknr84MU0pyTb59XsxIWZfa48l0YPxEWIM3/DhX0qdRWb/GpCCMtWkiX0VLGQyP1Z6
         atc2RGXR7HfH4LrkRceMsLv8NlYfmu/K0W3S+q/QgKozoMwdSU0q5t0wWVS5vnLuuEKX
         D65JOeOP8SwI18VqdXA/qsnC7d8JLj5bwz8HcS37PGRMsYn16YRBsvRHKPdLuM7x5dHf
         Omsw==
X-Gm-Message-State: APjAAAUOp3X8QxJCagRTdR1BXQuG7wPaBMAfUHrIg8z+1ygf5Gn5iVRU
        5aRm8qJTGsdXnvzrz5lnYawevXIp5+2Ij2tHxBKGR3ZxRZcGsA==
X-Google-Smtp-Source: APXvYqwtUEOSequwCxaKgnlmUoERRPlq452snDNy2d1x0gxPMSdvKHNdEhndxlBGCEgG7W68WjZx/bB4fxIoVIZCaFk=
X-Received: by 2002:ac8:53ca:: with SMTP id c10mr418385qtq.94.1572373204739;
 Tue, 29 Oct 2019 11:20:04 -0700 (PDT)
MIME-Version: 1.0
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Tue, 29 Oct 2019 11:19:53 -0700
Message-ID: <CABWYdi1QmrHxNZT_DK4A2WUoj=r1+wxSngzaaTuGCatHisaTRw@mail.gmail.com>
Subject: fq dropping packets between vlan and ethernet interfaces
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc:     kernel-team <kernel-team@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

We're trying to test Linux 5.4 early and hit an issue with FQ.

The relevant part of our network setup involves four interfaces:

* ext0 (ethernet, internet facing)
* vlan101@ext0 (vlan)
* int0 (ethernet, lan facing)
* vlan11@int0 (vlan)

Both int0 and ext0 have fq on them:

qdisc fq 1: dev ext0 root refcnt 65 limit 10000p flow_limit 100p
buckets 1024 orphan_mask 1023 quantum 3228 initial_quantum 16140
low_rate_threshold 550Kbit refill_delay 40.0ms
qdisc fq 8003: dev int0 root refcnt 65 limit 10000p flow_limit 100p
buckets 1024 orphan_mask 1023 quantum 3028 initial_quantum 15140
low_rate_threshold 550Kbit refill_delay 40.0ms

The issue itself is that after some time ext0 stops feeding off
vlan101, which is visible as tcpdump not seeing packets on ext0, while
they flow over vlan101.

I can see that fq_dequeue does not report any packets:

$ sudo perf record -e qdisc:qdisc_dequeue -aR sleep 1
hping3 40335 [006] 63920.881016: qdisc:qdisc_dequeue: dequeue
ifindex=4 qdisc handle=0x10000 parent=0xFFFFFFFF txq_state=0x0
packets=0 skbaddr=(nil)
hping3 40335 [006] 63920.881030: qdisc:qdisc_dequeue: dequeue
ifindex=4 qdisc handle=0x10000 parent=0xFFFFFFFF txq_state=0x0
packets=0 skbaddr=(nil)
hping3 40335 [006] 63920.881041: qdisc:qdisc_dequeue: dequeue
ifindex=4 qdisc handle=0x10000 parent=0xFFFFFFFF txq_state=0x0
packets=0 skbaddr=(nil)
hping3 40335 [006] 63920.881070: qdisc:qdisc_dequeue: dequeue
ifindex=4 qdisc handle=0x10000 parent=0xFFFFFFFF txq_state=0x0
packets=0 skbaddr=(nil)

Inside of fq_dequeue I'm able to see that we throw away packets in here:

* https://elixir.bootlin.com/linux/v5.4-rc2/source/net/sched/sch_fq.c#L510

The output of tc -s qdisc shows the following:

qdisc fq 1: dev ext0 root refcnt 65 limit 10000p flow_limit 100p
buckets 1024 orphan_mask 1023 quantum 3228 initial_quantum 16140
low_rate_threshold 550Kbit refill_delay 40.0ms
 Sent 4872143400 bytes 8448638 pkt (dropped 201276670, overlimits 0
requeues 103)
 backlog 779376b 10000p requeues 103
  2806 flows (2688 inactive, 118 throttled), next packet delay
1572240566653952889 ns
  354201 gc, 0 highprio, 804560 throttled, 3919 ns latency, 19492 flows_plimit
qdisc fq 8003: dev int0 root refcnt 65 limit 10000p flow_limit 100p
buckets 1024 orphan_mask 1023 quantum 3028 initial_quantum 15140
low_rate_threshold 550Kbit refill_delay 40.0ms
 Sent 15869093876 bytes 17387110 pkt (dropped 0, overlimits 0 requeues 2817)
 backlog 0b 0p requeues 2817
  2047 flows (2035 inactive, 0 throttled)
  225074 gc, 10 highprio, 102308 throttled, 7525 ns latency

The key part here is probably that next packet delay for ext0 is the
current unix timestamp in nanoseconds. Naturally, we see this code
path being executed:

* https://elixir.bootlin.com/linux/v5.4-rc2/source/net/sched/sch_fq.c#L462

Unfortunately, I don't have a reliable reproduction for this issue. It
appears naturally with some traffic and I can do limited tracing with
perf and bcc tools while running hping3 to generate packets.

The issue goes away if I replace fq with pfifo_fast on ext0.
