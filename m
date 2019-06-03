Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04D9D33B06
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfFCWSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:18:09 -0400
Received: from mail-qt1-f181.google.com ([209.85.160.181]:46264 "EHLO
        mail-qt1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbfFCWSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:18:07 -0400
Received: by mail-qt1-f181.google.com with SMTP id z19so11407342qtz.13
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 15:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=92fW+QfKjKqGC/dpOjwcfw9cwas5vdSx+8jcXUotsaw=;
        b=WCo3qAtUGTM1DcwEkve7PQK0nngOZpfpwuD+IcyBt2KIZ0Zsfiaya5Pd6G+1gc6830
         KIUadOnb77iV9XTED9kkzhSWx8tanTkGaLoLCA9d0iuo/5Lte6q51AvPJeYqSyWCdSE9
         /OXuVLI3Jd1fFN28fC3TPFHwUhotJW1hwq6Q4lcWbSEfXYDf3KPu7IPHYYojw2ZJvPkz
         IBvtGY5ffIwPt43S8jZjA+pbWZv2LAKeEhnLc3w431iRIa2FTG5WPYpNUBVzTK6ITYMk
         0MKJBOwDeqEuko//bzYYY0e1yEijB/rHXP1c08rqOpqLeRC6mg0H+MfCmyxwWk1vmqGY
         PwXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=92fW+QfKjKqGC/dpOjwcfw9cwas5vdSx+8jcXUotsaw=;
        b=SNIoq7fWjJkuX3dClqD4KREVjshp6qsebIsDjUs4q6UruENxDotc6daCrVGxvhXFX+
         TEqxrE+Jjt+iMTmGbrtcWxzuTuxz6kjZXrU8UFVXnwBntrU6kQg5NjNH5i1KOwOGDVwE
         NiE2PfyTO9b8UgFnL2rbqGe2VDcitmbppU2ERjiRS6vaebbgufOBKWH4hHhcGhGM2hdZ
         aXXx5Y2Ofj487iqv5m7EWAWpmx1V/6+9i/xNAihooKioET7/e0QxJQiYCrC19wdXCu4r
         l3Tc4V17v/7/es9X8VN+sdy2uZSdYWLxlf8cEybSYC1W3oNLyaDhBLtCyTfGbgpyQQZ3
         V/hA==
X-Gm-Message-State: APjAAAVWhfFYZGA0YIikWDzYsIjvWm4I3khFmsQgXMkp5TWlSXDwXlOY
        EPSYRvSjAltj/OPz9HBgFRD55w==
X-Google-Smtp-Source: APXvYqxqDjT/MNvC5MvYgHuHio9CRhcKO1nezOEldyp32Y6TWhIAnnS45M7JaEtWvf+yvIclBKZ7bg==
X-Received: by 2002:ac8:2d08:: with SMTP id n8mr5229445qta.383.1559600286312;
        Mon, 03 Jun 2019 15:18:06 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m4sm4332391qka.70.2019.06.03.15.18.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 15:18:05 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 7/8] net/tls: reorganize struct tls_context
Date:   Mon,  3 Jun 2019 15:17:04 -0700
Message-Id: <20190603221705.12602-8-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603221705.12602-1-jakub.kicinski@netronome.com>
References: <20190603221705.12602-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct tls_context is slightly badly laid out.  If we reorder things
right we can save 16 bytes (320 -> 304) but also make all fast path
data fit into two cache lines (one read only and one read/write,
down from four cache lines).

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 include/net/tls.h | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 39ea62f0c1f6..a463a6074e5d 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -236,34 +236,32 @@ struct tls_prot_info {
 };
 
 struct tls_context {
+	/* read-only cache line */
 	struct tls_prot_info prot_info;
 
-	union tls_crypto_context crypto_send;
-	union tls_crypto_context crypto_recv;
+	u8 tx_conf:3;
+	u8 rx_conf:3;
 
-	struct list_head list;
-	struct net_device *netdev;
-	refcount_t refcount;
+	int (*push_pending_record)(struct sock *sk, int flags);
+	void (*sk_write_space)(struct sock *sk);
 
 	void *priv_ctx_tx;
 	void *priv_ctx_rx;
 
-	u8 tx_conf:3;
-	u8 rx_conf:3;
+	struct net_device *netdev;
 
+	/* rw cache line */
 	struct cipher_context tx;
 	struct cipher_context rx;
 
 	struct scatterlist *partially_sent_record;
 	u16 partially_sent_offset;
 
-	unsigned long flags;
 	bool in_tcp_sendpages;
 	bool pending_open_record_frags;
+	unsigned long flags;
 
-	int (*push_pending_record)(struct sock *sk, int flags);
-
-	void (*sk_write_space)(struct sock *sk);
+	/* cache cold stuff */
 	void (*sk_destruct)(struct sock *sk);
 	void (*sk_proto_close)(struct sock *sk, long timeout);
 
@@ -275,6 +273,12 @@ struct tls_context {
 			   int __user *optlen);
 	int  (*hash)(struct sock *sk);
 	void (*unhash)(struct sock *sk);
+
+	union tls_crypto_context crypto_send;
+	union tls_crypto_context crypto_recv;
+
+	struct list_head list;
+	refcount_t refcount;
 };
 
 enum tls_offload_ctx_dir {
-- 
2.21.0

