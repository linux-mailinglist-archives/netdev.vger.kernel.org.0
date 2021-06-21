Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B04D43AE16E
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 03:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbhFUBlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 21:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbhFUBlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 21:41:15 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E8DC06175F;
        Sun, 20 Jun 2021 18:39:00 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id w26so6987898qto.13;
        Sun, 20 Jun 2021 18:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=18+3yTOkr60iRWX8bN28HTMDWmteIC0kJFjtwu3ePKg=;
        b=evcYYwSir8KseSZaKBm46qYfxmJ0O4GkwyvmX7x9dSOf0Z/3e2Ass218OjhCHKivVT
         G3TCj43CpAJ/8qEB85dJ9n0EgD2SmJ+1a7MK894A080OasrRoGpnzXih6CUB0aWUMCqE
         iMpNM0RbZG2x7Oqy1HkxcmFS5p5PWvPLmjXE+ytM87aFhF/jiC7GNL0c26pGJ+pn5V1I
         B7Cp2FJhAMw4EQypJ4uZM6Xx/Uf4HL/qkbAerKdzLr34yK/Pr0QzfREzWN16IS78IcyK
         9pNU/4X4ryjdvEgtyQUiteN7CkNTgfR9tRZh8ZFRBbzT93JlyVz8rvk0QB6mHBxsVy4s
         ehow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=18+3yTOkr60iRWX8bN28HTMDWmteIC0kJFjtwu3ePKg=;
        b=cD2XIzWOPaBwmU5ZlakMA7cCWYkBpu7C1X7BqxxaoP6jhdgSqNga7pkQ5s4V0hH02j
         cfTZt4jf4ZV5f2arDJb0QhEm5TyhrH0DKk4sxalToR3+UeGrKA3QZRkihTWVAOiwl063
         v1PDLnjyEBGuriUsgepKzc5X8HsW5klteRBBl/n5p/g0B7c1eALWpRGltzGkr7L4eD57
         eHiiIPMtHOY3SDME7wxd/JMNHuRrgMk+c0yWOwTvmevl4A22qMQcuagGorIOoeLeqPXD
         6xs4UsZvb07l6bfaVG6kke0RRoliE/tDlmcKFYVyr8VDj82bBX3ssw5lSfXR2/0W5z6d
         muFQ==
X-Gm-Message-State: AOAM530N4mvdY86v6923XyXOrBemXFFDID++FHKEokiKaAbTKzZggPpn
        0EIemUuzVyvgk0SoaZ6w0EJ+pTkeggurXQ==
X-Google-Smtp-Source: ABdhPJz8+5op3CmXgc7G2XtgTvFpmb6yeSvSjz8KYQ8XMH2l9YBTJxAnUTv0mlaBAwafcznj0cXxyA==
X-Received: by 2002:ac8:7e8b:: with SMTP id w11mr21886067qtj.38.1624239539741;
        Sun, 20 Jun 2021 18:38:59 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id v7sm6601455qkg.37.2021.06.20.18.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jun 2021 18:38:59 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: [PATCH net-next 08/14] sctp: do state transition when a probe succeeds on HB ACK recv path
Date:   Sun, 20 Jun 2021 21:38:43 -0400
Message-Id: <27fc16c7dde5458be6bd805eac003805fa26addc.1624239422.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1624239422.git.lucien.xin@gmail.com>
References: <cover.1624239422.git.lucien.xin@gmail.com>
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

