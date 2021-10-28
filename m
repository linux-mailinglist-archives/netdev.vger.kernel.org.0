Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A6543DDE3
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 11:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhJ1JjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 05:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbhJ1JjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 05:39:16 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F91C061745;
        Thu, 28 Oct 2021 02:36:49 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 5so21662727edw.7;
        Thu, 28 Oct 2021 02:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=heVQdx8kuIp03Ln79hY3i096v+do8vPuzLCHTVsedUA=;
        b=Vjhw42kql2G9KSW8o3SWp6WhEjqv4/7eh3I35kFSAxpODJIgRbkAG8wuapLDC1m03U
         hZeOfzNEeSkwlwjDvHpztCrvqGcHENaOIme1U+yG0guaOdRlMO1ptzrFnlX0IpsjKPCp
         YAgJPoMHK4sVQWlSz2tyO6wVYJleT2JYxH0oYsAsKQJPjxtFqFvjRX4z2vp8Aw1Wmq14
         /6ZFXwH/o1JE1aX5IGIR7XwvefWZHqxSn63zQwvjt0Bw8N77Eeh37Mt8j261Pj0mRjfO
         S1JrdokYMv9a++JkUwzWZIHc3bqkPguG+mBRT5MlEW4PNeF3iWwFoCLnfcWVuj7rMBZq
         y6RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=heVQdx8kuIp03Ln79hY3i096v+do8vPuzLCHTVsedUA=;
        b=AiX18GDtimPMIojSYL1Pd/KRPKkH9v6qV/phpdC6FcEsW8m6G/Cp4jPbx0E5AbsPhm
         WA5VeXIqFc1IgQWYQKotZNJfjUBPPR06duQ83xWboC9FM62Q/JW9x//JChkzE0G0pOyd
         nTrN8F7XEpmnVNRJtkuEGK84nBuwRET85nFqXFv4auRDCkwq8aBFsqGDoYZPCWU24xB+
         d0QRExg1FR2jCcCMo5XcCzHn4LYXmeDNghIXap7EDrR9SvFaiNHi/z2bGL+Y4jrmpiG6
         4Iydtx0IInTkvaC/rJynyu0208G/XT3cEQuFGZb/kKvf02RkhJdnTynBLrbs4IeX7eJa
         O7zw==
X-Gm-Message-State: AOAM533uJB8MZKlCP7uRz9Wp9i6EjjKWNhzej7kJr63Sx79f+o7aWdyn
        7jcm9S8XCGLNVb5PjqHJnpgQnRd3wd1cQA==
X-Google-Smtp-Source: ABdhPJxEnhf7Mf7vP9PFD0gqTYsNcP08ImZfC/2eOztLDDUWTZ0cr4rhSyUvgXcV+IfI2AsuXJ8G6w==
X-Received: by 2002:aa7:cb8a:: with SMTP id r10mr4685187edt.237.1635413808252;
        Thu, 28 Oct 2021 02:36:48 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id s12sm1379865edc.48.2021.10.28.02.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 02:36:47 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net 4/4] sctp: return true only for pathmtu update in sctp_transport_pl_toobig
Date:   Thu, 28 Oct 2021 05:36:04 -0400
Message-Id: <81d365e3186a0ad69dadf5c316637696b64c7f1d.1635413715.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1635413715.git.lucien.xin@gmail.com>
References: <cover.1635413715.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sctp_transport_pl_toobig() supposes to return true only if there's
pathmtu update, so that in sctp_icmp_frag_needed() it would call
sctp_assoc_sync_pmtu() and sctp_retransmit(). This patch is to fix
these return places in sctp_transport_pl_toobig().

Fixes: 836964083177 ("sctp: do state transition when receiving an icmp TOOBIG packet")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/transport.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 1f2dfad768d5..133f1719bf1b 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -368,6 +368,7 @@ static bool sctp_transport_pl_toobig(struct sctp_transport *t, u32 pmtu)
 
 			t->pl.pmtu = SCTP_BASE_PLPMTU;
 			t->pathmtu = t->pl.pmtu + sctp_transport_pl_hlen(t);
+			return true;
 		}
 	} else if (t->pl.state == SCTP_PL_SEARCH) {
 		if (pmtu >= SCTP_BASE_PLPMTU && pmtu < t->pl.pmtu) {
@@ -378,11 +379,10 @@ static bool sctp_transport_pl_toobig(struct sctp_transport *t, u32 pmtu)
 			t->pl.probe_high = 0;
 			t->pl.pmtu = SCTP_BASE_PLPMTU;
 			t->pathmtu = t->pl.pmtu + sctp_transport_pl_hlen(t);
+			return true;
 		} else if (pmtu > t->pl.pmtu && pmtu < t->pl.probe_size) {
 			t->pl.probe_size = pmtu;
 			t->pl.probe_count = 0;
-
-			return false;
 		}
 	} else if (t->pl.state == SCTP_PL_COMPLETE) {
 		if (pmtu >= SCTP_BASE_PLPMTU && pmtu < t->pl.pmtu) {
@@ -393,10 +393,11 @@ static bool sctp_transport_pl_toobig(struct sctp_transport *t, u32 pmtu)
 			t->pl.probe_high = 0;
 			t->pl.pmtu = SCTP_BASE_PLPMTU;
 			t->pathmtu = t->pl.pmtu + sctp_transport_pl_hlen(t);
+			return true;
 		}
 	}
 
-	return true;
+	return false;
 }
 
 bool sctp_transport_update_pmtu(struct sctp_transport *t, u32 pmtu)
-- 
2.27.0

