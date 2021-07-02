Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78D23BA1F3
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 16:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbhGBOI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 10:08:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53773 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232606AbhGBOI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 10:08:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625234784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=WugI9bAUw80AJ8qQnTPNf+VMgnnHS/8KQnN29WJyVOA=;
        b=UfVV1qw6zC5IUlvyc/87iExeCuTAF7tkeUgL8/AMehPTPcYfVRYTZSiG3+g4cHibqHnJ85
        fo4VzmMYfV3FEa7iQgm4j2YBOir0X8paymKXzHQVawqs6mxS8/gtudu1Y8V9YJtUe3zJP5
        k3q/bvF+NlPUIgjsGR/m49pv0EUUZ3w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-YQAwctH3ORuLlhs42T-iIg-1; Fri, 02 Jul 2021 10:06:23 -0400
X-MC-Unique: YQAwctH3ORuLlhs42T-iIg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0F4F50751;
        Fri,  2 Jul 2021 14:06:21 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A86EE10016F8;
        Fri,  2 Jul 2021 14:06:17 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 7845A30000DDD;
        Fri,  2 Jul 2021 16:06:16 +0200 (CEST)
Subject: [PATCH bpf-next V1] samples/bpf: xdp_redirect_cpu_user: cpumap qsize
 set larger default
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 02 Jul 2021 16:06:16 +0200
Message-ID: <162523477604.786243.13372630844944530891.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Experience from production shows queue size of 192 is too small, as
this caused packet drops during cpumap-enqueue on RX-CPU.  This can be
diagnosed with xdp_monitor sample program.

This bpftrace program was used to diagnose the problem in more detail:

 bpftrace -e '
  tracepoint:xdp:xdp_cpumap_kthread { @deq_bulk = lhist(args->processed,0,10,1); @drop_net = lhist(args->drops,0,10,1) }
  tracepoint:xdp:xdp_cpumap_enqueue { @enq_bulk = lhist(args->processed,0,10,1); @enq_drops = lhist(args->drops,0,10,1); }'

Watch out for the @enq_drops counter. The @drop_net counter can happen
when netstack gets invalid packets, so don't despair it can be
natural, and that counter will likely disappear in newer kernels as it
was a source of confusion (look at netstat info for reason of the
netstack @drop_net counters).

The production system was configured with CPU power-saving C6 state.
Learn more in this blogpost[1].

And wakeup latency in usec for the states are:

 # grep -H . /sys/devices/system/cpu/cpu0/cpuidle/*/latency
 /sys/devices/system/cpu/cpu0/cpuidle/state0/latency:0
 /sys/devices/system/cpu/cpu0/cpuidle/state1/latency:2
 /sys/devices/system/cpu/cpu0/cpuidle/state2/latency:10
 /sys/devices/system/cpu/cpu0/cpuidle/state3/latency:133

Deepest state take 133 usec to wakeup from (133/10^6). The link speed
is 25Gbit/s ((25*10^9/8) in bytes/sec). How many bytes can arrive with
in 133 usec at this speed: (25*10^9/8)*(133/10^6) = 415625 bytes. With
MTU size packets this is 275 packets, and with minimum Ethernet (incl
intergap overhead) 84 bytes it is 4948 packets. Clearly default queue
size is too small.

Setting default cpumap queue to 2048 as worst-case (small packet) at
10Gbit/s is 1979 packets with 133 usec wakeup time, +64 packet before
kthread wakeup call (due to xdp_do_flush) worst-case 2043 packets.

Thus, if a packet burst on RX-CPU will enqueue packets to a remote
cpumap CPU that is in deep-sleep state it can overrun the cpumap queue.

The production system was also configured to avoid deep-sleep via:
 tuned-adm profile network-latency

[1] https://jeremyeder.com/2013/08/30/oh-did-you-expect-the-cpu/

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 samples/bpf/xdp_redirect_cpu_user.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index 576411612523..d3ecdc18b9c1 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -792,13 +792,23 @@ int main(int argc, char **argv)
 
 	n_cpus = get_nprocs_conf();
 
-	/* Notice: choosing he queue size is very important with the
-	 * ixgbe driver, because it's driver page recycling trick is
-	 * dependend on pages being returned quickly.  The number of
-	 * out-standing packets in the system must be less-than 2x
-	 * RX-ring size.
+	/* Notice: Choosing the queue size is very important when CPU is
+	 * configured with power-saving states.
+	 *
+	 * If deepest state take 133 usec to wakeup from (133/10^6). When link
+	 * speed is 10Gbit/s ((10*10^9/8) in bytes/sec). How many bytes can
+	 * arrive with in 133 usec at this speed: (10*10^9/8)*(133/10^6) =
+	 * 166250 bytes. With MTU size packets this is 110 packets, and with
+	 * minimum Ethernet (MAC-preamble + intergap) 84 bytes is 1979 packets.
+	 *
+	 * Setting default cpumap queue to 2048 as worst-case (small packet)
+	 * should be +64 packet due kthread wakeup call (due to xdp_do_flush)
+	 * worst-case is 2043 packets.
+	 *
+	 * Sysadm can configured system to avoid deep-sleep via:
+	 *   tuned-adm profile network-latency
 	 */
-	qsize = 128+64;
+	qsize = 2048;
 
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	prog_load_attr.file = filename;


