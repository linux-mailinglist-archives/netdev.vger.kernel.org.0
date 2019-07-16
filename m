Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8DF6A087
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 04:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388252AbfGPCUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 22:20:10 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39080 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388235AbfGPCUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 22:20:09 -0400
Received: by mail-pl1-f194.google.com with SMTP id b7so9268067pls.6;
        Mon, 15 Jul 2019 19:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=VUDuI4pL0Ekx2N2uEollbqzuyx08xmpBeQ/1wJ8aM7M=;
        b=AAoU6nnQFDoCdjNFvCT51oPpPU3tvRyghfvKLvPrC0RRjA5GA/joOKGMo0jwsKVIkA
         t2KurV3wAKMmPI87DyaAxtuGG5d9TPdCqoPLZewJD+JJUsqcUMzFvXFV3EZz7QMDe73Q
         uXKkRBlspKb8aw7jEc68AOA664+/tq2RiMfVFx68ll0Uly5wgLKLBOn2fKEl+IteNQUa
         aCCbXHUDkmanmoQVucYK1rvTszxEOyV17oMK9GX6RepEpbmgtaM0iJsh5bu+9n0N2TzF
         LkRJdRoAwBMpEOd8N4MJYwP245fkc9cD8HKW3y4De9d1E87iElvapvfmIcB0p8Ug9k78
         T80Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=VUDuI4pL0Ekx2N2uEollbqzuyx08xmpBeQ/1wJ8aM7M=;
        b=YXkqFjBZbr6xA//JMSA0KNAJ/LyggrJ4/y0bgQjmtc8XMfmKil/QphzXXAPng21UX5
         lhOKL0R0eLK1sJy9sT+074Xi+addLmQJtLiq+aooGRmEG1PPes3UlByC6LeRX71BIkUQ
         UosEUOWjImcg7jBJi88hyVqIAMkYiAWu7jU7bYOYmUo+4AHEHRcugyT1w31wPDHX0WQe
         AOsF2Ls8GCSESM52iRm9BaXKk6ixaEArP/XKHzWNXv9+A40fvF0iva/YsD2qbx9ASJni
         rW3GaNORUTLO+ZyTl77aDBZyhHrcThWAfn7QsWerVPTWnZuA6otMgm+uc0yZteCcJBfj
         sxSA==
X-Gm-Message-State: APjAAAWXk17SUd7GfHQmJ5XU5yv2foubUzW4GQ5MDcFJe+8GOWqKTEax
        Z9YkcelGhi9xJaoaYeM/nNP6Rsn8
X-Google-Smtp-Source: APXvYqyaj/PtxUYGQWhs/mghaR/zwZbR00DCBWCEmjHu0u/6iHSmC4HSbOWjQhenRG98f5R/luQaMg==
X-Received: by 2002:a17:902:ff11:: with SMTP id f17mr32632981plj.121.1563243609102;
        Mon, 15 Jul 2019 19:20:09 -0700 (PDT)
Received: from hari-Inspiron-1545 ([183.83.86.126])
        by smtp.gmail.com with ESMTPSA id q24sm16908669pjp.14.2019.07.15.19.20.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 19:20:08 -0700 (PDT)
Date:   Tue, 16 Jul 2019 07:50:02 +0530
From:   Hariprasad Kelam <hariprasad.kelam@gmail.com>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: sctp: fix warning "NULL check before some freeing
 functions is not needed"
Message-ID: <20190716022002.GA19592@hari-Inspiron-1545>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch removes NULL checks before calling kfree.

fixes below issues reported by coccicheck
net/sctp/sm_make_chunk.c:2586:3-8: WARNING: NULL check before some
freeing functions is not needed.
net/sctp/sm_make_chunk.c:2652:3-8: WARNING: NULL check before some
freeing functions is not needed.
net/sctp/sm_make_chunk.c:2667:3-8: WARNING: NULL check before some
freeing functions is not needed.
net/sctp/sm_make_chunk.c:2684:3-8: WARNING: NULL check before some
freeing functions is not needed.

Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
---
 net/sctp/sm_make_chunk.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index ed39396..36bd8a6e 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2582,8 +2582,7 @@ static int sctp_process_param(struct sctp_association *asoc,
 	case SCTP_PARAM_STATE_COOKIE:
 		asoc->peer.cookie_len =
 			ntohs(param.p->length) - sizeof(struct sctp_paramhdr);
-		if (asoc->peer.cookie)
-			kfree(asoc->peer.cookie);
+		kfree(asoc->peer.cookie);
 		asoc->peer.cookie = kmemdup(param.cookie->body, asoc->peer.cookie_len, gfp);
 		if (!asoc->peer.cookie)
 			retval = 0;
@@ -2648,8 +2647,7 @@ static int sctp_process_param(struct sctp_association *asoc,
 			goto fall_through;
 
 		/* Save peer's random parameter */
-		if (asoc->peer.peer_random)
-			kfree(asoc->peer.peer_random);
+		kfree(asoc->peer.peer_random);
 		asoc->peer.peer_random = kmemdup(param.p,
 					    ntohs(param.p->length), gfp);
 		if (!asoc->peer.peer_random) {
@@ -2663,8 +2661,7 @@ static int sctp_process_param(struct sctp_association *asoc,
 			goto fall_through;
 
 		/* Save peer's HMAC list */
-		if (asoc->peer.peer_hmacs)
-			kfree(asoc->peer.peer_hmacs);
+		kfree(asoc->peer.peer_hmacs);
 		asoc->peer.peer_hmacs = kmemdup(param.p,
 					    ntohs(param.p->length), gfp);
 		if (!asoc->peer.peer_hmacs) {
@@ -2680,8 +2677,7 @@ static int sctp_process_param(struct sctp_association *asoc,
 		if (!ep->auth_enable)
 			goto fall_through;
 
-		if (asoc->peer.peer_chunks)
-			kfree(asoc->peer.peer_chunks);
+		kfree(asoc->peer.peer_chunks);
 		asoc->peer.peer_chunks = kmemdup(param.p,
 					    ntohs(param.p->length), gfp);
 		if (!asoc->peer.peer_chunks)
-- 
2.7.4

