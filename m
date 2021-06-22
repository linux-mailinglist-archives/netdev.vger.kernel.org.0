Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA033B0C82
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 20:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbhFVSLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 14:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbhFVSK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 14:10:58 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D78C09B08F;
        Tue, 22 Jun 2021 11:05:11 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id bl4so5941442qkb.8;
        Tue, 22 Jun 2021 11:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7wIxn22oN/FMZTaBSwp0deqnxLgu+ZS2IES/oekvdNQ=;
        b=DNRwMGsxPlmZ2M88vkHfRlGgr7uclXkPUTnauP3w69Quc3J/QKgGVMOhQphlenCbE4
         bKrFPxJJ322YB1V5x4s4F3QOX1VFqWKkgb9CYX0yaLODBjlhlk9dIi/fN/Cfb3j5CuaY
         MR5CLCaxm2FrZfhDhn15pAhRFGOG+lB2eUeDoAJTjBGzpHaBJx5QWgh7v1cBI2MeHxsI
         lyKSQPo2y911Z8Q/Iqif4N6lw9dDGC8Bol91bK2knuEDc0/reFXxSphDdweVCnQKgz6g
         QUu2w/E/thYekdFQn//Tdai2RBxGsmHhbIzFEPlFMXxyNc0A2uCDhly3ksREHrk8c89N
         GU+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7wIxn22oN/FMZTaBSwp0deqnxLgu+ZS2IES/oekvdNQ=;
        b=mrfEm5DQOrE1QPgLM7gCy51fBoOtf1T5qCqWz7ENH1LX5Lw1dB3Nl13hvy9ZT9t3yS
         4FG0sPCufZhTUMudp9Fim1MxxwMbdw8/H1inpXGe7vwniE45Kat+r71mvjeTRm3g2g70
         AFOFU7+o8VBt45XjHmyM/GJJbI8Oh8wYf8pmUE3EGjuYXZkJNFqkCr+8nPj5at9+q/rQ
         EzYeQBr0Pe9p8uSYQAdoUrHXj+SywchPB+ouLeyFp11NMYHMUQpu8sBcpLmrt88h4diJ
         MNNRgPfwFnDejZXBbca7X7ZFRx2FB+gn0DDV0viV071TTh9blM468CYvhJgqzRjqhU64
         r8Bw==
X-Gm-Message-State: AOAM531WFtNHdQVRP1hi7/tS3z0XguPCagaWTmwh+4rJdV5rTsJsA7T8
        TBgWxe62PPGSesqBkEqZH10zHmwVxPKqjg==
X-Google-Smtp-Source: ABdhPJxODak0/DETEMXJTNeeJyceATKHRGD6kqSKp7UaDtD6Rhv6PWzbmqkl6WfNykjIlIQi100bVA==
X-Received: by 2002:a05:620a:2148:: with SMTP id m8mr5731959qkm.190.1624385110117;
        Tue, 22 Jun 2021 11:05:10 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 206sm13788133qke.67.2021.06.22.11.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 11:05:09 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: [PATCHv2 net-next 08/14] sctp: do state transition when a probe succeeds on HB ACK recv path
Date:   Tue, 22 Jun 2021 14:04:54 -0400
Message-Id: <0d1259e0d090c8f6cc24ade82c70ba48cc8e615a.1624384990.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1624384990.git.lucien.xin@gmail.com>
References: <cover.1624384990.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As described in rfc8899#section-5.2, when a probe succeeds, there might
be the following state transitions:

  - Base -> Search, occurs when probe succeeds with BASE_PLPMTU,
    pl.pmtu is not changing,
    pl.probe_size increases by SCTP_PL_BIG_STEP,

  - Error -> Search, occurs when probe succeeds with BASE_PLPMTU,
    pl.pmtu is changed from SCTP_MIN_PLPMTU to SCTP_BASE_PLPMTU,
    pl.probe_size increases by SCTP_PL_BIG_STEP.

  - Search -> Search Complete, occurs when probe succeeds with the probe
    size SCTP_MAX_PLPMTU less than pl.probe_high,
    pl.pmtu is not changing, but update *pathmtu* with it,
    pl.probe_size is set back to pl.pmtu to double check it.

  - Search Complete -> Search, occurs when probe succeeds with the probe
    size equal to pl.pmtu,
    pl.pmtu is not changing,
    pl.probe_size increases by SCTP_PL_MIN_STEP.

So search process can be described as:

 1. When it just enters 'Search' state, *pathmtu* is not updated with
    pl.pmtu, and probe_size increases by a big step (SCTP_PL_BIG_STEP)
    each round.

 2. Until pl.probe_high is set when a probe fails, and probe_size
    decreases back to pl.pmtu, as described in the last patch.

 3. When the probe with the new size succeeds, probe_size changes to
    increase by a small step (SCTP_PL_MIN_STEP) due to pl.probe_high
    is set.

 4. Until probe_size is next to pl.probe_high, the searching finishes and
    it goes to 'Complete' state and updates *pathmtu* with pl.pmtu, and
    then probe_size is set to pl.pmtu to confirm by once more probe.

 5. This probe occurs after "30 * probe_inteval", a much longer time than
    that in Search state. Once it is done it goes to 'Search' state again
    with probe_size increased by SCTP_PL_MIN_STEP.

As we can see above, during the searching, pl.pmtu changes while *pathmtu*
doesn't. *pathmtu* is only updated when the search finishes by which it
gets an optimal value for it. A big step is used at the beginning until
it gets close to the optimal value, then it changes to a small step until
it has this optimal value.

The small step is also used in 'Complete' until it goes to 'Search' state
again and the probe with 'pmtu + the small step' succeeds, which means a
higher size could be used. Then probe_size changes to increase by a big
step again until it gets close to the next optimal value.

Note that anytime when black hole is detected, it goes directly to 'Base'
state with pl.pmtu set to SCTP_BASE_PLPMTU, as described in the last patch.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 include/net/sctp/structs.h |  1 +
 net/sctp/sm_statefuns.c    |  2 +-
 net/sctp/transport.c       | 38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 31165720b28a..9eaa701cda23 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1024,6 +1024,7 @@ void sctp_transport_immediate_rtx(struct sctp_transport *);
 void sctp_transport_dst_release(struct sctp_transport *t);
 void sctp_transport_dst_confirm(struct sctp_transport *t);
 void sctp_transport_pl_send(struct sctp_transport *t);
+void sctp_transport_pl_recv(struct sctp_transport *t);
 
 
 /* This is the structure we use to queue packets as they come into
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 66c409e5b47c..d29b579da904 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1274,7 +1274,7 @@ enum sctp_disposition sctp_sf_backbeat_8_3(struct net *net,
 		    !sctp_transport_pl_enabled(link))
 			return SCTP_DISPOSITION_DISCARD;
 
-		/* The actual handling will be performed here in a later patch. */
+		sctp_transport_pl_recv(link);
 		return SCTP_DISPOSITION_CONSUME;
 	}
 
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 99620d86e317..79ff5ca6b472 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -305,6 +305,44 @@ void sctp_transport_pl_send(struct sctp_transport *t)
 	t->pl.probe_count = 1;
 }
 
+void sctp_transport_pl_recv(struct sctp_transport *t)
+{
+	pr_debug("%s: PLPMTUD: transport: %p, state: %d, pmtu: %d, size: %d, high: %d\n",
+		 __func__, t, t->pl.state, t->pl.pmtu, t->pl.probe_size, t->pl.probe_high);
+
+	t->pl.pmtu = t->pl.probe_size;
+	t->pl.probe_count = 0;
+	if (t->pl.state == SCTP_PL_BASE) {
+		t->pl.state = SCTP_PL_SEARCH; /* Base -> Search */
+		t->pl.probe_size += SCTP_PL_BIG_STEP;
+	} else if (t->pl.state == SCTP_PL_ERROR) {
+		t->pl.state = SCTP_PL_SEARCH; /* Error -> Search */
+
+		t->pl.pmtu = t->pl.probe_size;
+		t->pathmtu = t->pl.pmtu + sctp_transport_pl_hlen(t);
+		sctp_assoc_sync_pmtu(t->asoc);
+		t->pl.probe_size += SCTP_PL_BIG_STEP;
+	} else if (t->pl.state == SCTP_PL_SEARCH) {
+		if (!t->pl.probe_high) {
+			t->pl.probe_size = min(t->pl.probe_size + SCTP_PL_BIG_STEP,
+					       SCTP_MAX_PLPMTU);
+			return;
+		}
+		t->pl.probe_size += SCTP_PL_MIN_STEP;
+		if (t->pl.probe_size >= t->pl.probe_high) {
+			t->pl.probe_high = 0;
+			t->pl.state = SCTP_PL_COMPLETE; /* Search -> Search Complete */
+
+			t->pl.probe_size = t->pl.pmtu;
+			t->pathmtu = t->pl.pmtu + sctp_transport_pl_hlen(t);
+			sctp_assoc_sync_pmtu(t->asoc);
+		}
+	} else if (t->pl.state == SCTP_PL_COMPLETE) {
+		t->pl.state = SCTP_PL_SEARCH; /* Search Complete -> Search */
+		t->pl.probe_size += SCTP_PL_MIN_STEP;
+	}
+}
+
 bool sctp_transport_update_pmtu(struct sctp_transport *t, u32 pmtu)
 {
 	struct dst_entry *dst = sctp_transport_dst_check(t);
-- 
2.27.0

