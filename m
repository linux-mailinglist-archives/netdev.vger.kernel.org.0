Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505523B32CE
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 17:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbhFXPue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 11:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhFXPud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 11:50:33 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C739C061574;
        Thu, 24 Jun 2021 08:48:14 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id e1so3644970qkm.3;
        Thu, 24 Jun 2021 08:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1A6cREIjspxX7ad+SljIeeKbqeAgevQspLlsQyDabSo=;
        b=WRnty9N7Uwax9oydIoAFHn1+DFeYiAeBxL9M81nQZqPGhwZa9ztsa2DuLeWhddfCBI
         Io2UZKK8uP9pU67OhC5cQkkr03du3MheWA2At7PJMrRo+O5FI149GPi2cKI7OLDPMU39
         pp69uoXgWVwqPdIc4VnMe74/oBe8fB1PvOEsc6+pGRnvngVDx3052mNVhD6laljIzhBr
         xWzqczcEU4jmOPcmHUgCssF6SoDwlY/zDhaAEfmBPBd9eHNFislZccNigb/g6/0olvn2
         jkETGQlIpLHjh5V2kuGoKOiKCDUSDYAa5Jx+VazLyR2AgsUxX8jEUK+wUiF96Wq+9WbL
         FgXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1A6cREIjspxX7ad+SljIeeKbqeAgevQspLlsQyDabSo=;
        b=IiRGy0SHFATxLosU6ypYSlEG6zE5DWONlS49EKVmPbtwNH4zgzHI482m7aB9dnL4T7
         gE2/tBwtZ82hJLkSQWCss4WgS+fYXBjdeAQDhBQTEHfN58J6rPWXBn7mGvygvvK0wCi3
         MQBNmFSRF0WHg21CNjaB620uEgVix8A+rMiN47dzCh7Z5vbepIroCztd6LjexBhXE83W
         uSEyPztGukn7Yl8p9nogfzH3cl7fpCx1GqSw67iRQrBInfRFroBwANWYlKXQbIWRwDUj
         LWTk03kDlKIU4SA3qaetqzDWoNW39e/IjckeP9XAeeFqQr2qtBHKO1VvKvxV/PIZA1P3
         Dpyg==
X-Gm-Message-State: AOAM531diERE2NZGPsU9GRmJcOWGrGPocaQw43GF1qsm6HspmTfMCx3W
        MIvjOJL/40Iu1AYEUWJQgMLM0wqq3oRmIw==
X-Google-Smtp-Source: ABdhPJxesQUpvn2G8hQ+Rlqe5uOlaViSuuqS/oG1VGWNl93AAKQuuf7salhQYPP70U/LDLSW9DYLxQ==
X-Received: by 2002:a37:9306:: with SMTP id v6mr6452926qkd.476.1624549693087;
        Thu, 24 Jun 2021 08:48:13 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id w22sm2070682qta.55.2021.06.24.08.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 08:48:12 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Cc:     David Laight <david.laight@aculab.com>
Subject: [PATCH net-next 1/2] sctp: do black hole detection in search complete state
Date:   Thu, 24 Jun 2021 11:48:08 -0400
Message-Id: <08344e5d9b0eb31c1b777f44cd1b95ecdde5a3d6.1624549642.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1624549642.git.lucien.xin@gmail.com>
References: <cover.1624549642.git.lucien.xin@gmail.com>
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

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h |  3 ++-
 net/sctp/transport.c       | 11 ++++-------
 2 files changed, 6 insertions(+), 8 deletions(-)

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
index f27b856ea8ce..5f23804f21c7 100644
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
 
@@ -333,13 +328,15 @@ void sctp_transport_pl_recv(struct sctp_transport *t)
 		t->pl.probe_size += SCTP_PL_MIN_STEP;
 		if (t->pl.probe_size >= t->pl.probe_high) {
 			t->pl.probe_high = 0;
+			t->pl.raise_count = 0;
 			t->pl.state = SCTP_PL_COMPLETE; /* Search -> Search Complete */
 
 			t->pl.probe_size = t->pl.pmtu;
 			t->pathmtu = t->pl.pmtu + sctp_transport_pl_hlen(t);
 			sctp_assoc_sync_pmtu(t->asoc);
 		}
-	} else if (t->pl.state == SCTP_PL_COMPLETE) {
+	} else if (t->pl.state == SCTP_PL_COMPLETE && ++t->pl.raise_count == 30) {
+		/* Raise probe_size again after 30 * interval in Search Complete */
 		t->pl.state = SCTP_PL_SEARCH; /* Search Complete -> Search */
 		t->pl.probe_size += SCTP_PL_MIN_STEP;
 	}
-- 
2.27.0

