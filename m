Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50493AE169
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 03:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhFUBlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 21:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbhFUBlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 21:41:13 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5012C061756;
        Sun, 20 Jun 2021 18:38:59 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id g4so25181060qkl.1;
        Sun, 20 Jun 2021 18:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=G574e8ILa6xDXMfZzeRV0/nPa2tJRv+8w1sMNLXqKGQ=;
        b=eRoId3MM9KD6uI7o6H5uY9PxUCWDB7diws5eE2oeM/UEpOWg5QIvmCjG76JxpHKj4G
         VEsK85JrU1AKwYZTaVA7hh79GVO4yFnjTqW4yIpq3qxlECI19mVcVbzSd79hd0NuLf5W
         P+hV6FZ/PnZIY5xTEJkOotvRGUE7vCvr8bQkkSJNu+djaAkodFIN3KVT3ghAZppTBAQD
         JzVLQxochoVoA6b/4Zx/7hwCLov1BPHDdRTRE3gyPcqVgfHdeJh27RZnDbQ3dwXxw8Bq
         CiIF4aVrayza6YcuUte5CV/xGxkJ/xQnBi3XNev/wCstNvKKCok3a90nucIsNmFNuE+O
         r0dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G574e8ILa6xDXMfZzeRV0/nPa2tJRv+8w1sMNLXqKGQ=;
        b=pbL3oItGyW21Br2BiRNQMsWLMF2Ft3EveRaaoXvYWpvQ0LGFX6Z++M2LPRRmTs5zrQ
         qxL9U5O9cM5yTk6IpBoBUwMgNOdeiBLOFXdCUT8xsBmyRsSfJTMR0ohbZaQTADsdqyXm
         b6SOx0qH1NWMLRTrrVVy8Mq/oo33AE/tWv/oqlO0dJWFMgwOLWIYHUH+hjqucjW+shLq
         KpPMlhB1Z3SSJ7Ic7WXOvi5l2nVxM4FyUdnbodUnINyhApTNrquc/zLvYuWqeCOyS6eG
         CCivqGIfX52fV96m/MNl1OVFXHgi6TQIfFfKT3ihLl/uMZRQU3XcIzc4WAGUZ2Aw2Kk9
         SBpQ==
X-Gm-Message-State: AOAM531DQEsoe0qNueYxOvlbCjMhMKaOxP4516gT+YcRiidT1dBQaqQs
        JLaoQ/s2eP+2/W8EFxH4M1E8CxIzvy/7LQ==
X-Google-Smtp-Source: ABdhPJxzo5Bs2+32N9l3U0S9rbWgH+AMx3rNolT5GsGEPZ//ozp9YWaOrHNDTRhkuCXGIyaeZOSvdw==
X-Received: by 2002:a37:ad14:: with SMTP id f20mr20816204qkm.145.1624239538689;
        Sun, 20 Jun 2021 18:38:58 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id x12sm4387940qtr.22.2021.06.20.18.38.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jun 2021 18:38:58 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: [PATCH net-next 07/14] sctp: do state transition when PROBE_COUNT == MAX_PROBES on HB send path
Date:   Sun, 20 Jun 2021 21:38:42 -0400
Message-Id: <4195d17261dd4967de4ae4a19e442a11ead84cdf.1624239422.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1624239422.git.lucien.xin@gmail.com>
References: <cover.1624239422.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The state transition is described in rfc8899#section-5.2,
PROBE_COUNT == MAX_PROBES means the probe fails for MAX times, and the
state transition includes:

  - Base -> Error, occurs when BASE_PLPMTU Confirmation Fails,
    pl.pmtu is set to SCTP_MIN_PLPMTU,
    probe_size is still SCTP_BASE_PLPMTU;

  - Search -> Base, occurs when Black Hole Detected,
    pl.pmtu is set to SCTP_BASE_PLPMTU,
    probe_size is set back to SCTP_BASE_PLPMTU;

  - Search Complete -> Base, occurs when Black Hole Detected
    pl.pmtu is set to SCTP_BASE_PLPMTU,
    probe_size is set back to SCTP_BASE_PLPMTU;

Note a black hole is encountered when a sender is unaware that packets
are not being delivered to the destination endpoint. So it includes the
probe failures with equal probe_size to pl.pmtu, and definitely not
include that with greater probe_size than pl.pmtu. The later one is the
normal probe failure where probe_size should decrease back to pl.pmtu
and pl.probe_high is set.  pl.probe_high would be used on HB ACK recv
path in the next patch.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h |  1 +
 net/sctp/sm_statefuns.c    |  2 ++
 net/sctp/transport.c       | 44 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 47 insertions(+)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index f7b056f5af37..31165720b28a 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1023,6 +1023,7 @@ bool sctp_transport_update_pmtu(struct sctp_transport *t, u32 pmtu);
 void sctp_transport_immediate_rtx(struct sctp_transport *);
 void sctp_transport_dst_release(struct sctp_transport *t);
 void sctp_transport_dst_confirm(struct sctp_transport *t);
+void sctp_transport_pl_send(struct sctp_transport *t);
 
 
 /* This is the structure we use to queue packets as they come into
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 8edb9186112a..66c409e5b47c 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1109,6 +1109,8 @@ enum sctp_disposition sctp_sf_send_probe(struct net *net,
 	if (!sctp_transport_pl_enabled(transport))
 		return SCTP_DISPOSITION_CONSUME;
 
+	sctp_transport_pl_send(transport);
+
 	reply = sctp_make_heartbeat(asoc, transport, transport->pl.probe_size);
 	if (!reply)
 		return SCTP_DISPOSITION_NOMEM;
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index ca3343c2c80e..99620d86e317 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -261,6 +261,50 @@ void sctp_transport_pmtu(struct sctp_transport *transport, struct sock *sk)
 		transport->pathmtu = SCTP_DEFAULT_MAXSEGMENT;
 }
 
+void sctp_transport_pl_send(struct sctp_transport *t)
+{
+	pr_debug("%s: PLPMTUD: transport: %p, state: %d, pmtu: %d, size: %d, high: %d\n",
+		 __func__, t, t->pl.state, t->pl.pmtu, t->pl.probe_size, t->pl.probe_high);
+
+	if (t->pl.probe_count < SCTP_MAX_PROBES) {
+		t->pl.probe_count++;
+		return;
+	}
+
+	if (t->pl.state == SCTP_PL_BASE) {
+		if (t->pl.probe_size == SCTP_BASE_PLPMTU) { /* BASE_PLPMTU Confirmation Failed */
+			t->pl.state = SCTP_PL_ERROR; /* Base -> Error */
+
+			t->pl.pmtu = SCTP_MIN_PLPMTU;
+			t->pathmtu = t->pl.pmtu + sctp_transport_pl_hlen(t);
+			sctp_assoc_sync_pmtu(t->asoc);
+		}
+	} else if (t->pl.state == SCTP_PL_SEARCH) {
+		if (t->pl.pmtu == t->pl.probe_size) { /* Black Hole Detected */
+			t->pl.state = SCTP_PL_BASE;  /* Search -> Base */
+			t->pl.probe_size = SCTP_BASE_PLPMTU;
+			t->pl.probe_high = 0;
+
+			t->pl.pmtu = SCTP_BASE_PLPMTU;
+			t->pathmtu = t->pl.pmtu + sctp_transport_pl_hlen(t);
+			sctp_assoc_sync_pmtu(t->asoc);
+		} else { /* Normal probe failure. */
+			t->pl.probe_high = t->pl.probe_size;
+			t->pl.probe_size = t->pl.pmtu;
+		}
+	} else if (t->pl.state == SCTP_PL_COMPLETE) {
+		if (t->pl.pmtu == t->pl.probe_size) { /* Black Hole Detected */
+			t->pl.state = SCTP_PL_BASE;  /* Search Complete -> Base */
+			t->pl.probe_size = SCTP_BASE_PLPMTU;
+
+			t->pl.pmtu = SCTP_BASE_PLPMTU;
+			t->pathmtu = t->pl.pmtu + sctp_transport_pl_hlen(t);
+			sctp_assoc_sync_pmtu(t->asoc);
+		}
+	}
+	t->pl.probe_count = 1;
+}
+
 bool sctp_transport_update_pmtu(struct sctp_transport *t, u32 pmtu)
 {
 	struct dst_entry *dst = sctp_transport_dst_check(t);
-- 
2.27.0

