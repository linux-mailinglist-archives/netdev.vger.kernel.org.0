Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE1E3B0C88
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 20:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbhFVSLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 14:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbhFVSK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 14:10:58 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FCAC07E5E4;
        Tue, 22 Jun 2021 11:05:10 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id w21so28016067qkb.9;
        Tue, 22 Jun 2021 11:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=HAJl2U2KB9jMXWYPmwwsV20mWVXNeL7lfpIHYJx5aAE=;
        b=blUjXMNs0dHfJ0P/CYbWy8X1WC4Vt9u68bvuPVSNm0LoOi+LNxtFgRxWTyTwXWqU8I
         NUcXSSViclr5g9Pg7DIRnX+84jzduadxtThxXRja23xnqU6rfm25uFyiX10ViOct7WIe
         LgGMy8r00eynmEuGh5JnAtOdvX4XshNe0VwtQNNncB8FEPQjqHYTW8ISqlQsKyM4cpJr
         C3TucnJ4aQOihzXWayim8ogqNq9s0mf3Qw+2zlS10rEbGg6tlilrlLpr7Aih/2CP6eOi
         Fg36Z6gD+SJ+NGBe8DrdKkjhYOLsYLkMVByOlVgsMXxLfSJgi7SPnSY3PEEZuCwFF1nj
         vEHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HAJl2U2KB9jMXWYPmwwsV20mWVXNeL7lfpIHYJx5aAE=;
        b=RuGzwlqM4nwCpb4GBgu1ASx0KjGtZoo+bPn2vRFtmiW8dz2aZ1i1qXuLixNyiHtiSA
         4yIyexv0CcYOOg9UeJ6u2hcTH5kkTpIiKe7UFE5MVcSKQq+qmGR0OETcUoRuMaUaHuWK
         2AFhgDqiE0/1n9KtoOpsHF9Dkk31tUmlN3GpjvVPxNitY7ESJXm5tBaHIKsY1ZnLfxHr
         F1Eq+ASsK5M0JQeFRHlDTefFxvny0zygqMaRXo/lXL4s3tMxSPk34BlhGuQYnN5tYG5d
         HKOVnzjihd9kWn9yyZMNCDuh163VOg7M0LKl78YgfMz5aX0DTJnAs3anowKlCn+aYuAh
         iCnQ==
X-Gm-Message-State: AOAM531fXWSIZ58latjOXaeml3BIEDV8lxw5Y1c6qy6plxMYtAEp8XVy
        UxM+okhQiuH7Q64iAzL8MBOZDNYtHiBbgw==
X-Google-Smtp-Source: ABdhPJzfLREeJDzmceIH3HpAGojPJOZ7Pddf5siEUHQu3EHucWkG3LG6jiUkWd/O56qrg6c8KiRpWQ==
X-Received: by 2002:a37:a20f:: with SMTP id l15mr5678243qke.44.1624385109008;
        Tue, 22 Jun 2021 11:05:09 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id a134sm13373780qkg.114.2021.06.22.11.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 11:05:08 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: [PATCHv2 net-next 07/14] sctp: do state transition when PROBE_COUNT == MAX_PROBES on HB send path
Date:   Tue, 22 Jun 2021 14:04:53 -0400
Message-Id: <00250f2f2602a635e6c58ff50e9c04c76213d861.1624384990.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1624384990.git.lucien.xin@gmail.com>
References: <cover.1624384990.git.lucien.xin@gmail.com>
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
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
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

