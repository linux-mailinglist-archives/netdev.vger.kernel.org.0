Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 730B4E5EB8
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 20:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfJZStC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 14:49:02 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:40397 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfJZStB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 14:49:01 -0400
Received: by mail-wm1-f48.google.com with SMTP id w9so5188305wmm.5
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 11:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GpjThdJvTg/hT90gxlIb7dIYQPCkvTYQ3DV36zfR49k=;
        b=P4+u5BTixASGOQKmPJLWol6eOnnUsewNJKv2Mr6i4qKQOQYIwyIEHwaNMDM/FeN/3E
         LKAvXQtUkPG7fStYufaJ+yAi3QNaT1ptAoVxWvoOReIdNB5hLa8cQE9RJTAEjR63SBQT
         ftTHqxOD2U6YGLHiG1UvdTftemGxJvwT6/B4Lb28xYiGekyvvxBI6y9KchOTI1Z2sgyM
         jU0rNnaYUb4L20V/BVcvxvbuTErmmkJNVLHxB3n7vUj8R73MlfWDv+cy1EDD7g+aLKvQ
         mC5nQnI/fEJv6d3CXhVNbqT0HtryTbpYy9P2R4x8V6OprMsqmTNbEoZXLcWfmDKtG+Ly
         bGVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GpjThdJvTg/hT90gxlIb7dIYQPCkvTYQ3DV36zfR49k=;
        b=LRzNCUHVPcOOvGB4KKXyjqa4k5ThKO8O62/I3GFsUpucUfNZ0+wDFTzkCkptdaqcvf
         MK5env/UCHMMDSYYuEK2jIkvfzjcYNkB0Px7F1t8eDw6P0ygIfG751gscKXRgXybV1Ur
         itLxdyONFs2u/LQbMn4ahIfre5slNyeq20cgDDs6WGb8hE5MI1x4j9EnPNGdjOxy7EVx
         t2nMeAgNKWXVqCBECVjdYw/qHkFmQm6vq3L6e5U/X+KVqFTQdF5DGQ782elYcbSZYc4V
         iAQLDgsfyQJs9Gs8Hhcf6CaEh/A5rW+mdgkwmYN1yll4Oe8hS0fXEt9MhVB83zwzgIiO
         U/mw==
X-Gm-Message-State: APjAAAU6ABGTvGJqpJ1rMqTWKC+Rdi+V9O+lO/As+iSq4fy4+rYI9IWN
        X5pqem/LTb4aYcw+lbEfd/9t/yLu
X-Google-Smtp-Source: APXvYqyA+8GeLxfvNMKOYVgPraEfEUPm2NxhS6GQyy/9Yk03jMkN8KAIpWZJ9VEKKQZ/P7vuvLkWEw==
X-Received: by 2002:a7b:c444:: with SMTP id l4mr8806545wmi.49.1572115739471;
        Sat, 26 Oct 2019 11:48:59 -0700 (PDT)
Received: from pif.criteois.lan ([91.199.242.236])
        by smtp.gmail.com with ESMTPSA id q25sm11170773wra.3.2019.10.26.11.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Oct 2019 11:48:58 -0700 (PDT)
From:   William Dauchy <wdauchy@gmail.com>
To:     netdev@vger.kernel.org
Cc:     William Dauchy <wdauchy@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2] tcp: add timestamp options fetcher
Date:   Sat, 26 Oct 2019 20:45:54 +0200
Message-Id: <20191026184554.32648-1-wdauchy@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002221017.2085-1-wdauchy@gmail.com>
References: <20191002221017.2085-1-wdauchy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tsval and tsecr are useful in some cases to diagnose TCP issues from the
sender point of view where unexplained RTT values are seen. Getting the
the timestamps from both ends will help understand those issues more
easily.
It can be mostly use in some specific cases, e.g a http server where
requests are tagged with such informations, which later helps to
diagnose some issues and create some useful metrics to give a general
signal.

Signed-off-by: William Dauchy <wdauchy@gmail.com>

---

Changes in v2:
- change from tcp_info to a new getsockopt() to avoid making tcp_info
  bigger for everyone
---
 include/uapi/linux/tcp.h |  6 ++++++
 net/ipv4/tcp.c           | 30 ++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 81e697978e8b..2a9685216aef 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -128,12 +128,18 @@ enum {
 #define TCP_CM_INQ		TCP_INQ
 
 #define TCP_TX_DELAY		37	/* delay outgoing packets by XX usec */
+#define TCP_TIMESTAMP_OPT	38	/* timestamps option with tsval and tsecr values */
 
 
 #define TCP_REPAIR_ON		1
 #define TCP_REPAIR_OFF		0
 #define TCP_REPAIR_OFF_NO_WP	-1	/* Turn off without window probes */
 
+struct tcp_timestamp_opt {
+	__u32	tcp_tsval;
+	__u32	tcp_tsecr;
+};
+
 struct tcp_repair_opt {
 	__u32	opt_code;
 	__u32	opt_val;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 42187a3b82f4..b9c34a5477dd 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3309,6 +3309,21 @@ void tcp_get_info(struct sock *sk, struct tcp_info *info)
 }
 EXPORT_SYMBOL_GPL(tcp_get_info);
 
+/* Return timestamps option of tcp endpoint. */
+static void tcp_get_tsopt(struct sock *sk, struct tcp_timestamp_opt *tsopt)
+{
+	const struct tcp_sock *tp = tcp_sk(sk);
+
+	memset(tsopt, 0, sizeof(*tsopt));
+	if (sk->sk_type != SOCK_STREAM)
+		return;
+
+	if (tp->rx_opt.tstamp_ok) {
+		tsopt->tcp_tsval = tp->rx_opt.rcv_tsval;
+		tsopt->tcp_tsecr = tp->rx_opt.rcv_tsecr;
+	}
+}
+
 static size_t tcp_opt_stats_get_size(void)
 {
 	return
@@ -3668,6 +3683,21 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 		return err;
 	}
 #endif
+	case TCP_TIMESTAMP_OPT: {
+		struct tcp_timestamp_opt tsopt;
+
+		if (get_user(len, optlen))
+			return -EFAULT;
+
+		tcp_get_tsopt(sk, &tsopt);
+
+		len = min_t(unsigned int, len, sizeof(tsopt));
+		if (put_user(len, optlen))
+			return -EFAULT;
+		if (copy_to_user(optval, &tsopt, len))
+			return -EFAULT;
+		return 0;
+	}
 	default:
 		return -ENOPROTOOPT;
 	}
-- 
2.23.0

