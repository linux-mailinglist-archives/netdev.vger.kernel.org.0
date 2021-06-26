Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0293B4C04
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 04:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhFZCnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 22:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhFZCnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 22:43:23 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0A0C061574;
        Fri, 25 Jun 2021 19:41:00 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id j1so12702411wrn.9;
        Fri, 25 Jun 2021 19:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iax7V+cUkox0wCx4k1np3PJhyC2u9ogpcAk3Z9ZACb4=;
        b=iJRfcDQiN86jkHJ9TXpR0lbQH7VR7KVitBHdgwkbauN9jTa5eFLM1cVOkeUmJoh7ss
         lmLY2aeS287VeSVkmXJNdyKGv3xgVjpLp8H4G6h7NcLez+dcPo2gYZkTtCtU5JFBCDAc
         GhvKHmBaL6gLc8K+58vNksgfOuNgoeVD21MfCtpiBU05qoWE0/mHjdMiVTnyb2z+vRdl
         U7H+AKwHo3XbnF07U4x4pjLCMpeJoFf6RzQbAMdwEHBDiN2TwFOoulDDCyL2lHhrBElw
         Gvuz23j0UCGkrsSwSAz0RUclWyRkHCCzTbL6J5m9fG/BZUKzW9BQCL4/OyOCahy40VaE
         qcXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iax7V+cUkox0wCx4k1np3PJhyC2u9ogpcAk3Z9ZACb4=;
        b=Grtft41J19r16vIMo1v7oPngKT3t/uS2cbVEiGLrcE3B6odDW2F3eithSGcAiX/MlA
         KCE9nep+fJgpLOreIA0oUpgGDisyL9C0DooZl7AZ9hH7sEB0Q39+HzZWIeLA55k94u4E
         o+fFldaILauissU8iIdT98ZNPOfaOvkOTfS9SfNPNJE/+c2A9Q8i6GwKgPmd1ETpMWkf
         JvR9qMrgCqhcm75MJ3PHbQjLsuFSPOKOO6s8jlVHWW9sVVXawmH35cg9W6n45I3kChoG
         3IhDa1HOC9qbMWgI7d9zfZpvCymgtz9RCD3dwBc5oNmM/vLUOrn/LaUJa5tW24cEYx3y
         F2sA==
X-Gm-Message-State: AOAM533hkHjGXZ4mab2aCITBXqEMDT41ZnpU3+4RlboP2PZIMBlaIIlb
        SvE91iwycuSM0FgCDQJS04MWBBYU1bQqjA==
X-Google-Smtp-Source: ABdhPJy9NhSr5OzAjyXRde2J7y7VSZ/rqTRRUlwQghcSXWLmUo0ACJsfQVMFky2AzfiejLDdrABzYA==
X-Received: by 2002:adf:ee4e:: with SMTP id w14mr14808367wro.108.1624675259330;
        Fri, 25 Jun 2021 19:40:59 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id n16sm7414732wrx.85.2021.06.25.19.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 19:40:59 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Cc:     David Laight <david.laight@aculab.com>
Subject: [PATCHv2 net-next 1/2] sctp: do black hole detection in search complete state
Date:   Fri, 25 Jun 2021 22:40:54 -0400
Message-Id: <1d298cde5971e080b56fb7aad24805b6812eb2f0.1624675179.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1624675179.git.lucien.xin@gmail.com>
References: <cover.1624675179.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the PLPMUTD probe will stop for a long period (interval * 30)
after it enters search complete state. If there's a pmtu change on the
route path, it takes a long time to be aware if the ICMP TooBig packet
is lost or filtered.

As it says in rfc8899#section-4.3:

  "A DPLPMTUD method MUST NOT rely solely on this method."
  (ICMP PTB message).

This patch is to enable the other method for search complete state:

  "A PL can use the DPLPMTUD probing mechanism to periodically
   generate probe packets of the size of the current PLPMTU."

With this patch, the probe will continue with the current pmtu every
'interval' until the PMTU_RAISE_TIMER 'timeout', which we implement
by adding raise_count to raise the probe size when it counts to 30
and removing the SCTP_PL_COMPLETE check for PMTU_RAISE_TIMER.

v1->v2:
  - do t->pl.raise_count++ and t->pl.raise_count check separately, as
    Marcelo suggested.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h |  3 ++-
 net/sctp/transport.c       | 16 ++++++++--------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 9eaa701cda23..c4a4c1754be8 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -987,7 +987,8 @@ struct sctp_transport {
 		__u16 pmtu;
 		__u16 probe_size;
 		__u16 probe_high;
-		__u8 probe_count;
+		__u8 probe_count:3;
+		__u8 raise_count:5;
 		__u8 state;
 	} pl; /* plpmtud related */
 
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index f27b856ea8ce..397a6244dd97 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -213,15 +213,10 @@ void sctp_transport_reset_reconf_timer(struct sctp_transport *transport)
 
 void sctp_transport_reset_probe_timer(struct sctp_transport *transport)
 {
-	int scale = 1;
-
 	if (timer_pending(&transport->probe_timer))
 		return;
-	if (transport->pl.state == SCTP_PL_COMPLETE &&
-	    transport->pl.probe_count == 1)
-		scale = 30; /* works as PMTU_RAISE_TIMER */
 	if (!mod_timer(&transport->probe_timer,
-		       jiffies + transport->probe_interval * scale))
+		       jiffies + transport->probe_interval))
 		sctp_transport_hold(transport);
 }
 
@@ -333,6 +328,7 @@ void sctp_transport_pl_recv(struct sctp_transport *t)
 		t->pl.probe_size += SCTP_PL_MIN_STEP;
 		if (t->pl.probe_size >= t->pl.probe_high) {
 			t->pl.probe_high = 0;
+			t->pl.raise_count = 0;
 			t->pl.state = SCTP_PL_COMPLETE; /* Search -> Search Complete */
 
 			t->pl.probe_size = t->pl.pmtu;
@@ -340,8 +336,12 @@ void sctp_transport_pl_recv(struct sctp_transport *t)
 			sctp_assoc_sync_pmtu(t->asoc);
 		}
 	} else if (t->pl.state == SCTP_PL_COMPLETE) {
-		t->pl.state = SCTP_PL_SEARCH; /* Search Complete -> Search */
-		t->pl.probe_size += SCTP_PL_MIN_STEP;
+		t->pl.raise_count++;
+		if (t->pl.raise_count == 30) {
+			/* Raise probe_size again after 30 * interval in Search Complete */
+			t->pl.state = SCTP_PL_SEARCH; /* Search Complete -> Search */
+			t->pl.probe_size += SCTP_PL_MIN_STEP;
+		}
 	}
 }
 
-- 
2.27.0

