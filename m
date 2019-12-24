Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 675E612A028
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 11:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbfLXKk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 05:40:57 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35093 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfLXKk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 05:40:56 -0500
Received: by mail-pf1-f193.google.com with SMTP id i23so5163110pfo.2;
        Tue, 24 Dec 2019 02:40:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TU4drdSTzwEtqpNk30ibaUnRFo5iqmd4TY56ydNSREg=;
        b=NJ9g3Sv6VymGnQ4lztinlH+rVsKVjNCsfzQZT9fDEdVuIn4xWGDcCnLa11sm4KEm51
         BTjpjNP+7G79PzEPwwdOzduaGvsS3SD6/j9a/QDfB1gTsve1Y7c+gPRY0CFjvKGrjdVM
         irgaO6MASDrXKTgOszkgx2HdalSEuvduVn4zIU48daKW52EFHCGkCrpn3/NEJVc86Em9
         7qkQNKgEK1OaJHpyCUZaYrRX7J8biCH90Pe71L7psR9wf/JNHuLAvjYAKwLlrsriWfop
         0zR+/3rUwtWt3PCfHfejxTyK5uYP3Ev1s8oTjBO3zgwsYRyg116U8lZ1ngrFaLPmJZzi
         Kelw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TU4drdSTzwEtqpNk30ibaUnRFo5iqmd4TY56ydNSREg=;
        b=ah/sHEgRIE7n5+mHgHC86jzKaUDexdNd0Ll4axF432YZWkXUEKxQLTsofX9ueTK2gA
         Mt7klRWkd+L7QARTboewpK4la1Ob+EX8PdWtyiYLpeNZPvZerLfJj2J3yXOQbt2BhRDJ
         AJjFhY2iAPJ35QRtGv15gc0NDxSE1MYFldkFZzmw5QNvJCc52cqeifBq2GF/4gBQec04
         zqs1QHTNji8RV153Kb8EI2W0A2yrTlKvjpWwew2gsO70/IGXhNaoxWArPiAyWJdqJmTq
         7ESLjA6yNTXXup3EK6Eh9cqOemv7NYVmTxFGHF7en2noejOu219X0xozdOLeIBPLd4G5
         +7uA==
X-Gm-Message-State: APjAAAUBxth186IDuSm/CTGFKZXb4IsLccjYDw7VVJAk5zODIu5q8LCH
        idHsZTApRNAbZ8IaNhZKBI4V+TKxucI=
X-Google-Smtp-Source: APXvYqxQ2Lq2cbFCSQxiBOE7LV5HBUCTWIq8TfyYKx3iLJm6d2isI5Gdoivb1pkDjt1wXJOysbY5jw==
X-Received: by 2002:a62:18f:: with SMTP id 137mr36868231pfb.84.1577184056001;
        Tue, 24 Dec 2019 02:40:56 -0800 (PST)
Received: from CV0038107N9.nsn-intra.net ([2408:84e4:413:c13d:502d:de24:95d5:5943])
        by smtp.gmail.com with ESMTPSA id v4sm4473448pff.174.2019.12.24.02.40.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Dec 2019 02:40:55 -0800 (PST)
From:   Kevin Kou <qdkevin.kou@gmail.com>
To:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net,
        qdkevin.kou@gmail.com
Subject: [PATCH v2] sctp: do trace_sctp_probe after SACK validation and check
Date:   Tue, 24 Dec 2019 10:40:40 +0000
Message-Id: <20191224104040.511-1-qdkevin.kou@gmail.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function sctp_sf_eat_sack_6_2 now performs the Verification
Tag validation, Chunk length validation, Bogu check, and also
the detection of out-of-order SACK based on the RFC2960
Section 6.2 at the beginning, and finally performs the further
processing of SACK. The trace_sctp_probe now triggered before
the above necessary validation and check.

this patch is to do the trace_sctp_probe after the chunk sanity
tests, but keep doing trace if the SACK received is out of order,
for the out-of-order SACK is valuable to congestion control
debugging.

v1->v2:
 - keep doing SCTP trace if the SACK is out of order as Marcelo's
   suggestion.

Signed-off-by: Kevin Kou <qdkevin.kou@gmail.com>
---
 net/sctp/sm_statefuns.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index b4a54df..d302a78 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3298,6 +3298,15 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
 	chunk->subh.sack_hdr = sackh;
 	ctsn = ntohl(sackh->cum_tsn_ack);
 
+	/* If Cumulative TSN Ack beyond the max tsn currently
+	 * send, terminating the association and respond to the
+	 * sender with an ABORT.
+	 */
+	if (TSN_lte(asoc->next_tsn, ctsn))
+		return sctp_sf_violation_ctsn(net, ep, asoc, type, arg, commands);
+
+	trace_sctp_probe(ep, asoc, chunk);
+
 	/* i) If Cumulative TSN Ack is less than the Cumulative TSN
 	 *     Ack Point, then drop the SACK.  Since Cumulative TSN
 	 *     Ack is monotonically increasing, a SACK whose
@@ -3311,15 +3320,6 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
 		return SCTP_DISPOSITION_DISCARD;
 	}
 
-	/* If Cumulative TSN Ack beyond the max tsn currently
-	 * send, terminating the association and respond to the
-	 * sender with an ABORT.
-	 */
-	if (!TSN_lt(ctsn, asoc->next_tsn))
-		return sctp_sf_violation_ctsn(net, ep, asoc, type, arg, commands);
-
-	trace_sctp_probe(ep, asoc, chunk);
-
 	/* Return this SACK for further processing.  */
 	sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_SACK, SCTP_CHUNK(chunk));
 
-- 
1.8.3.1

