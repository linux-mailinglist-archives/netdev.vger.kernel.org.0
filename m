Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE08DCC66D
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 01:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731628AbfJDXTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 19:19:53 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43709 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731461AbfJDXTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 19:19:53 -0400
Received: by mail-qt1-f195.google.com with SMTP id c3so10820655qtv.10
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 16:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+0eqHGTyvAmjESpJMkU3b/crAwl9rLtoJF/dY89RqiA=;
        b=QsY8YstujIUBXQj3GXSOT8Rf84QZ4ybTvC63fpmNZ2b+c9AQcIQHzZrhiMXPbLM+W+
         berQVt4F75Tn+MTe5PLB5V+XT1Rm3HQSM2Br0Yl5AQaC0dUz347wsidt0dyYLg5qR+u2
         N+/B7ZBNW1c0FFXPail3bBklTBxHz6siujMRjG8rvcCJR3ITDyNx7jm3Z+LpnTrtfZO4
         BQb9IAK/LmVhniDJTt9xDjRYivzeFqnJZVgy5MiuoQz9GOkSY+zU0iHuuCr3otajxmaV
         HENe/ZaonE1PQ9s0iCOiqqdsy2OarmhKfF/dcVFl04JL81QBjm7TW9j+v9boXtiYecxX
         FbuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+0eqHGTyvAmjESpJMkU3b/crAwl9rLtoJF/dY89RqiA=;
        b=n9S0XYEpu1ejuzdS2u1XMLnUqbzbZhZTl2y1Do3lD6or+gWlBQe7GS6ADYierDjva1
         6NyTmLA0MTVo3UwS3T7YQ6mdxGP1G83Kh2bMsUdoUuWeFFZ9M+9LaH1h6cJy/jsKy7kF
         o0kqW9kL6r/typ61ju1pIE6jjMcMM/IE8Yd4/B2ep6ms0whLRRxdMZqfM5d2yWiphr0A
         Ty46yfeMm/AeCPUZ8ZWVoGNG2NQY75n8Afn1BhZixPcUHsh1+6fX38pLxNpaS2bb00Ub
         nuG4aEfzLlvGwPTywJUWu0tu4gkIFoRO1rJHXHipiNNM2x6SEqNb6O2Vn231KaJnAU10
         LsXw==
X-Gm-Message-State: APjAAAWXUac11geE7tjCmJ2B3P6ovABpwXegeHz7KncV2/cU3qhOWfho
        b5c+FtMiEUpLH5DntUy/75Y2Ig==
X-Google-Smtp-Source: APXvYqw/YWa5hSNIE2hgiQg6N4Mr3x/S0cWOnk5Fj5Y939qZhuu2upcLaK9dd02Jnd8LLpSLIWLxNA==
X-Received: by 2002:ac8:3195:: with SMTP id h21mr19534949qte.350.1570231191099;
        Fri, 04 Oct 2019 16:19:51 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z46sm4653398qth.62.2019.10.04.16.19.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Oct 2019 16:19:49 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, davejwatson@fb.com, borisp@mellanox.com,
        aviadye@mellanox.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 5/6] net/tls: add TlsDecryptError stat
Date:   Fri,  4 Oct 2019 16:19:26 -0700
Message-Id: <20191004231927.21134-6-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191004231927.21134-1-jakub.kicinski@netronome.com>
References: <20191004231927.21134-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a statistic for TLS record decryption errors.

Since devices are supposed to pass records as-is when they
encounter errors this statistic will count bad records in
both pure software and inline crypto configurations.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 Documentation/networking/tls.rst | 3 +++
 include/uapi/linux/snmp.h        | 1 +
 net/tls/tls_proc.c               | 1 +
 net/tls/tls_sw.c                 | 5 +++++
 4 files changed, 10 insertions(+)

diff --git a/Documentation/networking/tls.rst b/Documentation/networking/tls.rst
index cfba587af5c9..ab82362dd819 100644
--- a/Documentation/networking/tls.rst
+++ b/Documentation/networking/tls.rst
@@ -233,3 +233,6 @@ TLS implementation exposes the following per-namespace statistics
 
 - ``TlsTxDevice``, ``TlsRxDevice`` -
   number of TX and RX sessions opened with NIC cryptography
+
+- ``TlsDecryptError`` -
+  record decryption failed (e.g. due to incorrect authentication tag)
diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 1b4613b5af70..c9e4963e26f0 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -335,6 +335,7 @@ enum
 	LINUX_MIB_TLSRXSW,			/* TlsRxSw */
 	LINUX_MIB_TLSTXDEVICE,			/* TlsTxDevice */
 	LINUX_MIB_TLSRXDEVICE,			/* TlsRxDevice */
+	LINUX_MIB_TLSDECRYPTERROR,		/* TlsDecryptError */
 	__LINUX_MIB_TLSMAX
 };
 
diff --git a/net/tls/tls_proc.c b/net/tls/tls_proc.c
index 1b1f3783badc..2bea7ef4823c 100644
--- a/net/tls/tls_proc.c
+++ b/net/tls/tls_proc.c
@@ -15,6 +15,7 @@ static const struct snmp_mib tls_mib_list[] = {
 	SNMP_MIB_ITEM("TlsRxSw", LINUX_MIB_TLSRXSW),
 	SNMP_MIB_ITEM("TlsTxDevice", LINUX_MIB_TLSTXDEVICE),
 	SNMP_MIB_ITEM("TlsRxDevice", LINUX_MIB_TLSRXDEVICE),
+	SNMP_MIB_ITEM("TlsDecryptError", LINUX_MIB_TLSDECRYPTERROR),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index c2b5e0d2ba1a..0b1e86f856eb 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -168,6 +168,9 @@ static void tls_decrypt_done(struct crypto_async_request *req, int err)
 
 	/* Propagate if there was an err */
 	if (err) {
+		if (err == -EBADMSG)
+			TLS_INC_STATS(sock_net(skb->sk),
+				      LINUX_MIB_TLSDECRYPTERROR);
 		ctx->async_wait.err = err;
 		tls_err_abort(skb->sk, err);
 	} else {
@@ -253,6 +256,8 @@ static int tls_do_decryption(struct sock *sk,
 			return ret;
 
 		ret = crypto_wait_req(ret, &ctx->async_wait);
+	} else if (ret == -EBADMSG) {
+		TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSDECRYPTERROR);
 	}
 
 	if (async)
-- 
2.21.0

