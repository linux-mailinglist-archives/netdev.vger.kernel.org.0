Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B809E12AC39
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 13:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfLZM3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 07:29:50 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:38176 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfLZM3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 07:29:50 -0500
Received: by mail-pj1-f67.google.com with SMTP id l35so3396142pje.3;
        Thu, 26 Dec 2019 04:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qeqFix4zYiO6HV8XwW63VNIqw5s6XEk+xSwaAOSSjsk=;
        b=i6HaZmm8o8NnbgEsvWrQT+jhgPDb7Plb1c0GoLahgJ4UVOKPVM6yGfOFr1JYU7Ic9M
         OJlOhAHRMY3rZEL09heBFBAPRhXFp93YeV/fgtPbNiqn8SUsek4w6LDKrTt5lEn+HhBh
         LnK/CPi/KqBLCrV5ZyriHj7fWiemfGC6t5RPs3hpP+8b8jXq7ky1WzBdcJByfBFkWqbb
         3skX7EBKIjOc/4bs4bEDEzzw1d/RxPPrFHtH6pyAzItagOam+E5MVSYEthxGVhAFzkp2
         oZn5x9zg/Rqc4ys93dJbSSKU9T1qTuttYdSq4J49m5Jp9akLSyDacjC1ka+mJhicQ47p
         AVEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qeqFix4zYiO6HV8XwW63VNIqw5s6XEk+xSwaAOSSjsk=;
        b=ujaqUe2RMDXGaz3Lgo+7rE+xHcTH3OJZ2/a/RdoniqPaXnFbDIoitN1fleZ9L2bFMx
         LBcuXhMeSKId/QSmJKqGXSVZ9Sbw2J23clDJmySSkBt1bmcOUcn6PPwgxDAP0/PWfB2n
         djoT0tJHLAUdhw5fl3tR6y3O5dKDhLQUZ78h3C//j+PIt+T3+alapXx5vFGENU6X6+mS
         jFKKIakHln2UZlz+pxc2GnIYaXgLOpj5mlXDNDXh6w9q0789X8U6eFGnUrGa5UHPoWRG
         6D26lHmhhBKkkc+sozhla76YHIWcGICORowEs7dB2AxoCNJ71Z6liJLbb3ERJvuqswId
         P6kA==
X-Gm-Message-State: APjAAAXgVXb5B5pT9z28nbSAxjiKmim9M/xARdjpMCGHUZJOy32YGjR7
        2Sp7h+PoMI8DHclCFQKrfUsljRmgLt9mcA==
X-Google-Smtp-Source: APXvYqzaZnIvPtUqP/YUAz/xQryzmYrb/WNVDL/kmNKJDxHjMnUN4+IM4fEg69kYyk9WZkDjrAuIgw==
X-Received: by 2002:a17:90a:21d1:: with SMTP id q75mr19918134pjc.0.1577363389037;
        Thu, 26 Dec 2019 04:29:49 -0800 (PST)
Received: from CV0038107N9.nsn-intra.net ([2408:84e4:486:51a3:f085:3f6e:8df2:1c96])
        by smtp.gmail.com with ESMTPSA id z19sm34344123pfn.49.2019.12.26.04.29.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Dec 2019 04:29:48 -0800 (PST)
From:   Kevin Kou <qdkevin.kou@gmail.com>
To:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Cc:     nhorman@tuxdriver.com, marcelo.leitner@gmail.com,
        davem@davemloft.net, qdkevin.kou@gmail.com
Subject: [PATCH net-next] sctp: move trace_sctp_probe_path into sctp_outq_sack
Date:   Thu, 26 Dec 2019 12:29:17 +0000
Message-Id: <20191226122917.431-1-qdkevin.kou@gmail.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The original patch bringed in the "SCTP ACK tracking trace event"
feature was committed at Dec.20, 2017, it replaced jprobe usage
with trace events, and bringed in two trace events, one is
TRACE_EVENT(sctp_probe), another one is TRACE_EVENT(sctp_probe_path).
The original patch intended to trigger the trace_sctp_probe_path in
TRACE_EVENT(sctp_probe) as below code,

+TRACE_EVENT(sctp_probe,
+
+	TP_PROTO(const struct sctp_endpoint *ep,
+		 const struct sctp_association *asoc,
+		 struct sctp_chunk *chunk),
+
+	TP_ARGS(ep, asoc, chunk),
+
+	TP_STRUCT__entry(
+		__field(__u64, asoc)
+		__field(__u32, mark)
+		__field(__u16, bind_port)
+		__field(__u16, peer_port)
+		__field(__u32, pathmtu)
+		__field(__u32, rwnd)
+		__field(__u16, unack_data)
+	),
+
+	TP_fast_assign(
+		struct sk_buff *skb = chunk->skb;
+
+		__entry->asoc = (unsigned long)asoc;
+		__entry->mark = skb->mark;
+		__entry->bind_port = ep->base.bind_addr.port;
+		__entry->peer_port = asoc->peer.port;
+		__entry->pathmtu = asoc->pathmtu;
+		__entry->rwnd = asoc->peer.rwnd;
+		__entry->unack_data = asoc->unack_data;
+
+		if (trace_sctp_probe_path_enabled()) {
+			struct sctp_transport *sp;
+
+			list_for_each_entry(sp, &asoc->peer.transport_addr_list,
+					    transports) {
+				trace_sctp_probe_path(sp, asoc);
+			}
+		}
+	),

But I found it did not work when I did testing, and trace_sctp_probe_path
had no output, I finally found that there is trace buffer lock
operation(trace_event_buffer_reserve) in include/trace/trace_events.h:

static notrace void							\
trace_event_raw_event_##call(void *__data, proto)			\
{									\
	struct trace_event_file *trace_file = __data;			\
	struct trace_event_data_offsets_##call __maybe_unused __data_offsets;\
	struct trace_event_buffer fbuffer;				\
	struct trace_event_raw_##call *entry;				\
	int __data_size;						\
									\
	if (trace_trigger_soft_disabled(trace_file))			\
		return;							\
									\
	__data_size = trace_event_get_offsets_##call(&__data_offsets, args); \
									\
	entry = trace_event_buffer_reserve(&fbuffer, trace_file,	\
				 sizeof(*entry) + __data_size);		\
									\
	if (!entry)							\
		return;							\
									\
	tstruct								\
									\
	{ assign; }							\
									\
	trace_event_buffer_commit(&fbuffer);				\
}

The reason caused no output of trace_sctp_probe_path is that
trace_sctp_probe_path written in TP_fast_assign part of
TRACE_EVENT(sctp_probe), and it will be placed( { assign; } ) after the
trace_event_buffer_reserve() when compiler expands Macro,

        entry = trace_event_buffer_reserve(&fbuffer, trace_file,        \
                                 sizeof(*entry) + __data_size);         \
                                                                        \
        if (!entry)                                                     \
                return;                                                 \
                                                                        \
        tstruct                                                         \
                                                                        \
        { assign; }                                                     \

so trace_sctp_probe_path finally can not acquire trace_event_buffer
and return no output, that is to say the nest of tracepoint entry function
is not allowed. The function call flow is:

trace_sctp_probe()
-> trace_event_raw_event_sctp_probe()
 -> lock buffer
 -> trace_sctp_probe_path()
   -> trace_event_raw_event_sctp_probe_path()  --nested
   -> buffer has been locked and return no output.

This patch is to remove trace_sctp_probe_path from the TP_fast_assign
part of TRACE_EVENT(sctp_probe) to avoid the nest of entry function,
and trigger sctp_probe_path_trace in sctp_outq_sack.

After this patch, you can enable both events individually,
  # cd /sys/kernel/debug/tracing
  # echo 1 > events/sctp/sctp_probe/enable
  # echo 1 > events/sctp/sctp_probe_path/enable

Or, you can enable all the events under sctp.

  # echo 1 > events/sctp/enable

Signed-off-by: Kevin Kou <qdkevin.kou@gmail.com>
---
 include/trace/events/sctp.h | 9 ---------
 net/sctp/outqueue.c         | 6 ++++++
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/include/trace/events/sctp.h b/include/trace/events/sctp.h
index 7475c7b..d4aac34 100644
--- a/include/trace/events/sctp.h
+++ b/include/trace/events/sctp.h
@@ -75,15 +75,6 @@
 		__entry->pathmtu = asoc->pathmtu;
 		__entry->rwnd = asoc->peer.rwnd;
 		__entry->unack_data = asoc->unack_data;
-
-		if (trace_sctp_probe_path_enabled()) {
-			struct sctp_transport *sp;
-
-			list_for_each_entry(sp, &asoc->peer.transport_addr_list,
-					    transports) {
-				trace_sctp_probe_path(sp, asoc);
-			}
-		}
 	),
 
 	TP_printk("asoc=%#llx mark=%#x bind_port=%d peer_port=%d pathmtu=%d "
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index a031d11..6b0b3ba 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -36,6 +36,7 @@
 #include <net/sctp/sctp.h>
 #include <net/sctp/sm.h>
 #include <net/sctp/stream_sched.h>
+#include <trace/events/sctp.h>
 
 /* Declare internal functions here.  */
 static int sctp_acked(struct sctp_sackhdr *sack, __u32 tsn);
@@ -1238,6 +1239,11 @@ int sctp_outq_sack(struct sctp_outq *q, struct sctp_chunk *chunk)
 	/* Grab the association's destination address list. */
 	transport_list = &asoc->peer.transport_addr_list;
 
+	/* SCTP path tracepoint for congestion control debugging. */
+	list_for_each_entry(transport, transport_list, transports) {
+		trace_sctp_probe_path(transport, asoc);
+	}
+
 	sack_ctsn = ntohl(sack->cum_tsn_ack);
 	gap_ack_blocks = ntohs(sack->num_gap_ack_blocks);
 	asoc->stats.gapcnt += gap_ack_blocks;
-- 
1.8.3.1

