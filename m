Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48081CDADE
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 06:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbfJGEKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 00:10:07 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40574 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfJGEKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 00:10:07 -0400
Received: by mail-qt1-f196.google.com with SMTP id m61so6273142qte.7
        for <netdev@vger.kernel.org>; Sun, 06 Oct 2019 21:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7izjL3itxJO+dcJlVRiV8z2bxXx4ICf14SLxLdYSbuU=;
        b=nhQy0QOcGRIItU3MRNya8E4g+P+K0hoyq140iW0uXPLPGC2P7MSCS4xMa0IziWlCC4
         FuvL7mJ2/bW4pYU/P/HMlC6dujXiAeeNFftjeDOiF0Phrod0TSAqQWLgB2Ha/4N4NLk6
         6E5+z5NHbiQLP0GEEI4fu1+LTEUS4WX87+DcU2kYQtQmT8MAo0hW+DIOlzb8To1O2QDq
         Iq26Hl679GNHB79/p/RkmGFo7C0LCAAQWXqLi4Y4z7M4qfoHxRCVcyt6q8e5dOj7IRWt
         e+SS5tyDktkljufXqbJlsX9NU4Q0cEYR19wIy2b7fPhD9YCBOaglPURWCGri9+U5upjx
         ne1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7izjL3itxJO+dcJlVRiV8z2bxXx4ICf14SLxLdYSbuU=;
        b=nAXK3GiRd3sPlYnbY4VEZ7DV7V8G+LZJ0XhgVGcuHY4mtKUzlo3qwGvtUnO/1wkxvV
         e9EXjwI2IGg0zUMm/xzhxSiDzEOi8fir+Tyln/U04wu4l2DVtVfyICaePCSkv64WAt/6
         Gu/jP3YwAC59hh0fGTSS0C2Fd0XiApBtsk4+t22St8BwDIW8qBkcK2sulRIe+KQ7meLV
         6liAW8YR3z/vTsf1YZNESPNkASyj6jmN1H41WYre5Jsk2/zyZ37glr9IvV/diMx21hO1
         TQBtHDXWq6Kt/Rrcpy7xDCmRuXzTxCWnLFY/ZBNXEwaw/oEi7uWXXn64drFNrADv9Dh9
         Ptkw==
X-Gm-Message-State: APjAAAW1jfRgOESIU87TO1XhjIwLx+EkjgV1w0/sWDd0w768y4x/8Laa
        fBnhoLEf4ny0xmytxFQN3pAhDQ==
X-Google-Smtp-Source: APXvYqydrPguniuOyj5O/qs7gmRj6s7Je8b8hwrcUof0vibfOK+0TtGwES3MkCkE/1IQjskXUlyQrw==
X-Received: by 2002:ad4:4185:: with SMTP id e5mr2600470qvp.61.1570421406402;
        Sun, 06 Oct 2019 21:10:06 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y22sm3796058qka.59.2019.10.06.21.10.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2019 21:10:05 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 4/6] net/tls: pass context to tls_device_decrypted()
Date:   Sun,  6 Oct 2019 21:09:30 -0700
Message-Id: <20191007040932.26395-5-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191007040932.26395-1-jakub.kicinski@netronome.com>
References: <20191007040932.26395-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid unnecessary pointer chasing and calculations, callers already
have most of the state tls_device_decrypted() needs.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 include/net/tls.h    | 7 +++++--
 net/tls/tls_device.c | 5 ++---
 net/tls/tls_sw.c     | 2 +-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 24c37bffc961..b809f2362049 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -641,7 +641,8 @@ int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx);
 void tls_device_offload_cleanup_rx(struct sock *sk);
 void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq);
 void tls_offload_tx_resync_request(struct sock *sk, u32 got_seq, u32 exp_seq);
-int tls_device_decrypted(struct sock *sk, struct sk_buff *skb);
+int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
+			 struct sk_buff *skb, struct strp_msg *rxm);
 #else
 static inline void tls_device_init(void) {}
 static inline void tls_device_cleanup(void) {}
@@ -664,7 +665,9 @@ static inline void tls_device_offload_cleanup_rx(struct sock *sk) {}
 static inline void
 tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq) {}
 
-static inline int tls_device_decrypted(struct sock *sk, struct sk_buff *skb)
+static inline int
+tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
+		     struct sk_buff *skb, struct strp_msg *rxm)
 {
 	return 0;
 }
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 23c19b8ff04e..33b267b052c0 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -846,11 +846,10 @@ static int tls_device_reencrypt(struct sock *sk, struct sk_buff *skb)
 	return err;
 }
 
-int tls_device_decrypted(struct sock *sk, struct sk_buff *skb)
+int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
+			 struct sk_buff *skb, struct strp_msg *rxm)
 {
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_offload_context_rx *ctx = tls_offload_ctx_rx(tls_ctx);
-	struct strp_msg *rxm = strp_msg(skb);
 	int is_decrypted = skb->decrypted;
 	int is_encrypted = !is_decrypted;
 	struct sk_buff *skb_iter;
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 0b1e86f856eb..954f451dcc57 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1495,7 +1495,7 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 
 	if (!ctx->decrypted) {
 		if (tls_ctx->rx_conf == TLS_HW) {
-			err = tls_device_decrypted(sk, skb);
+			err = tls_device_decrypted(sk, tls_ctx, skb, rxm);
 			if (err < 0)
 				return err;
 		}
-- 
2.21.0

