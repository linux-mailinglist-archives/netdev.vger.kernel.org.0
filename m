Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B505E12A6C6
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 09:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfLYI2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 03:28:14 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46926 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfLYI2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 03:28:14 -0500
Received: by mail-pg1-f193.google.com with SMTP id z124so11398525pgb.13;
        Wed, 25 Dec 2019 00:28:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zLSzUO63CHc1kybIYEoH0WtkRo0w2hezIxwasjJaVhs=;
        b=VqCBsIUSIpy3KI5Ci5pd+7mWBRQ5vbAM5oviHTWPZQ9fFiPsPajav1U06wjD2TxEN0
         h7/b8PpNvWtNSsQsKlDLDkXeuhB9W7hKqoPDGFSxaLwzfedBH6zXGmA6u+ZNOczhwKH4
         KWxBkuD10ZQpsC7YuOGuShrbMN15plzVSr4XXP6iVGBqEWXm5FrWg5IV10BJWMmI3TTT
         vqi2kH2YqM8qYL/KMG6t2xR5LF0LKk22YPYG7vg/2CTP327JMaO+FOwWfr+nGm1tNt7T
         HSVDqGs5n19pw0YIRgLiwJqs7t5UxfX2CiGpZvsW132uZfsZWbWs7rtJH7jjcJCFTfPd
         BzpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zLSzUO63CHc1kybIYEoH0WtkRo0w2hezIxwasjJaVhs=;
        b=b7WMJ4cSn801UR+y2szPN/S6CrDWRaIFQ2zsKzYttcxtYaMgtIqwffzFN+KnNUhjTx
         Z+EOXLozYeSzarngHJuu9R1RdEQjhADukuMFPul4wXgIVombirKukuDhnTJ8547FDbrG
         vx/PegnzJCdq+kT8BTafjQfYVvwZOyNSyzzQPTvQqLVUp2i0uJmsgBos36GuDgCo+rt1
         NZ2DV4SkR1mn3iyeY2veePoKPq2Lve1sbaJfUxxusji+NrnhlNjHUJaMup5j20PTvAV6
         klhndHiLELfDIqNPJ9GmZ34GADX6zpBzAM8pn6NdVgKZxG74MtVwpKg7nvGG5SkGap65
         sKhw==
X-Gm-Message-State: APjAAAVzM+F+p3+abBnd2KI9O8sXJ9RM9Nu52Cj7qpbi7dxzl57n0gBr
        ZGhA8H6BN2IVJSA8D/312FVi+tYnXYyMug==
X-Google-Smtp-Source: APXvYqyk4C3LmCURVVPaZvd1Wr+T4nfvPc38hqBgzDiagHikbfIQ+kcZgQTodBv0tOVyQkh8KhSZkg==
X-Received: by 2002:a62:1a97:: with SMTP id a145mr43957623pfa.244.1577262493895;
        Wed, 25 Dec 2019 00:28:13 -0800 (PST)
Received: from CV0038107N9.nsn-intra.net ([2408:84e4:508:29a4:f854:7e63:8bdf:7b7])
        by smtp.gmail.com with ESMTPSA id k44sm5970965pjb.20.2019.12.25.00.27.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Dec 2019 00:28:13 -0800 (PST)
From:   Kevin Kou <qdkevin.kou@gmail.com>
To:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net,
        qdkevin.kou@gmail.com
Subject: [PATCHv3 net-next] sctp: do trace_sctp_probe after SACK validation and check
Date:   Wed, 25 Dec 2019 08:27:25 +0000
Message-Id: <20191225082725.1251-1-qdkevin.kou@gmail.com>
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
v2->v3:
 - regenerate the patch as v2 generated on top of v1, and add
   'net-next' tag to the new one as Marcelo's comments.

Signed-off-by: Kevin Kou <qdkevin.kou@gmail.com>
---
 net/sctp/sm_statefuns.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 42558fa..748e3b1 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3281,8 +3281,6 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
 	struct sctp_sackhdr *sackh;
 	__u32 ctsn;
 
-	trace_sctp_probe(ep, asoc, chunk);
-
 	if (!sctp_vtag_verify(chunk, asoc))
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
@@ -3299,6 +3297,15 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
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
@@ -3312,13 +3319,6 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
 		return SCTP_DISPOSITION_DISCARD;
 	}
 
-	/* If Cumulative TSN Ack beyond the max tsn currently
-	 * send, terminating the association and respond to the
-	 * sender with an ABORT.
-	 */
-	if (!TSN_lt(ctsn, asoc->next_tsn))
-		return sctp_sf_violation_ctsn(net, ep, asoc, type, arg, commands);
-
 	/* Return this SACK for further processing.  */
 	sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_SACK, SCTP_CHUNK(chunk));
 
-- 
1.8.3.1

