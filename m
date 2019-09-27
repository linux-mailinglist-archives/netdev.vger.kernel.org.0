Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 605F2C0313
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 12:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfI0KOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 06:14:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:56844 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726033AbfI0KOh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 06:14:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A8E92AE99;
        Fri, 27 Sep 2019 10:14:35 +0000 (UTC)
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/17] staging: qlge: Fix rx stall in case of allocation failures
Date:   Fri, 27 Sep 2019 19:11:54 +0900
Message-Id: <20190927101210.23856-1-bpoirier@suse.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qlge refills rx buffers from napi context. In case of allocation failure,
allocation will be retried the next time napi runs. If a receive queue runs
out of free buffers (possibly after subsequent allocation failures), it
drops all traffic, no longer raises interrupts and napi is no longer
scheduled; reception is stalled until manual admin intervention.

This patch series adds a fallback mechanism for rx buffer allocation. If an
rx buffer queue becomes empty, a workqueue is scheduled to refill it from
process context where allocation can block until mm has freed some pages
(hopefully). This approach was inspired by the virtio_net driver (commit
3161e453e496 "virtio: net refill on out-of-memory").

I've compared this with how some other devices with a similar allocation
scheme handle this situation:
mlx4 relies on a periodic watchdog, sfc uses a timer, e1000e and fm10k rely
on periodic hardware interrupts (IIUC). In all cases, they use this to
schedule napi periodically at a fixed interval (10-250ms) until allocations
succeed. This kind of approach simplifies allocations because only one
context may refill buffers, however it is inefficient because of the fixed
interval: either the interval was too short, the allocation fails again and
work was done without forward progress; or the interval was too long,
buffers could've been allocated earlier and rx restarted earlier, instead
traffic was dropped while the system was idle.

Note that the qlge driver (and device) uses two kinds of buffers for
received data, so-called "small buffers" and "large buffers". The two are
arranged in ring pairs, the sbq and lbq. Depending on frame size, protocol
content and header splitting, data can go in either type of buffers.
Because of buffer size, lbq allocations are more likely to fail and lead to
stall, however I've reproduced the problem with sbq as well. The problem
was originally found when running jumbo frames. In that case, qlge uses
order-1 allocations for the large buffers. Although the two kinds of
buffers are managed similarly, the qlge driver duplicates most data
structures and code for their handling. In fact, even a casual look at the
qlge driver shows it to be in a state of disrepair, to put it kindly...

Patches 1-14 are cleanups that remove, fix and deduplicate code related to
sbq and lbq handling. Regarding those cleanups, patches 2 ("Remove
irq_cnt") and 8 ("Deduplicate rx buffer queue management") are the most
important. Finally, patches 15-17 fix the actual problem of rx stalls in
case of allocation failures by implementing the fallback of allocations to
a workqueue.

I've tested these patches using two different approaches:
1) A sender uses pktgen to send udp traffic. The receiver has a large swap,
a large net.core.rmem_max, runs a program that dirties all free memory in a
loop and runs a program that opens as many udp sockets as possible but
doesn't read from them. Since received data is all queued in the sockets
rather than freed, qlge is allocating receive buffers as quickly as
possible and faces allocation failures if the swap is slower than the
network.
2) A sender uses super_netperf. Likewise, the receiver has a large swap, a
large net.core.rmem_max and runs a program that dirties all free memory in
a loop. After the netperf send test is started, `killall -s SIGSTOP
netserver` on the receiver leads to the same situation as above.

---
Changes
v1->v2
https://lore.kernel.org/netdev/20190617074858.32467-1-bpoirier@suse.com/
* simplified QLGE_FIT16 macro down to a simple cast
* added "qlge: Fix irq masking in INTx mode"
* fixed address in pci_unmap_page() calls in "qlge: Deduplicate rx buffer
  queue management", no effect on end result of series
* adjusted series following move of driver to staging


