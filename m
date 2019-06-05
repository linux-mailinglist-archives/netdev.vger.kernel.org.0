Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15F3636688
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 23:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfFEVMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 17:12:19 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40568 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfFEVMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 17:12:17 -0400
Received: by mail-qt1-f196.google.com with SMTP id a15so229963qtn.7
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 14:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uYj0Odmhf7Iq3xtIQQ+awAIvBYcndEa//r4cpU53KlM=;
        b=IHoCQFdFC83v8inutIGrt2G1jER1FLzcg4Sectz4ahwMxDScq1dTM7/ZygaJx+XKX3
         itPr+fw+wC1F/4d9zyncKZNvnXKSEVK7dtnuH5PeT6sBZNn2mO3TxFJbTDBgEj1nkJJg
         UxtfcDCy76EkoTKtbDo2mPP0+Ef4iePuoq4UkjllrakXPHJjHxgJaIFOn8Ubse+eqP8Z
         MwAhaUlQkIrd/cOsSgTxJ7KXSF359GseO+tELxnljx2BIHbTwhKkOly1FIm86ePhsWch
         +IYNeN8PRYdtvFMyJilQCIPhvObM33cRHj+rfWOzU+cmGeJeAeOuMSCw+dn+zGA3lSZb
         EpEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uYj0Odmhf7Iq3xtIQQ+awAIvBYcndEa//r4cpU53KlM=;
        b=Fi34McJpqgQbPkmLIeNhNeCxW6dhnwaLB8pVmZ1ojgbW9rSFXYQ9Ygcuvc3OhdyPMV
         d6eZ7MM2cN93eyC1M4DRTxERVCiaRbkwjfO+4FnRfUitPgr2DOWI9E2tD7mAnlonwW72
         evNl3rr0r7FONjSOI5h0FAMzwcBlj1vkjtm+AHKm9cAfCKuxQytChPWSm5QmPcrsbD7d
         NoNmjAaKyYz5YT8dZlGhz9FJ4oSidRCAvQkLThcfzMiPnVt48DcA6hZ1gBUWXAs+IMOw
         qT9OrlFq7k96uikDU38ZRXMFqjyErf+DOwszUE4Yt9kJNGRPhYmGP4Cks7+ZE47J7UEu
         phSQ==
X-Gm-Message-State: APjAAAW/4moSUL+E1lQFxSqtAeCd74rGoee6+ShYZ+Ao5vjTTUg9Sf7P
        8kwaSHanCgMi/E8FmxfYLIcDxA==
X-Google-Smtp-Source: APXvYqwt65QeEvGwEcD05OFla8lukROcHksMtsAVL+uge0gVRt2CQ6LxQDD6xlTJDgSjYh5XQDnS3Q==
X-Received: by 2002:ac8:25dd:: with SMTP id f29mr27442926qtf.144.1559769137021;
        Wed, 05 Jun 2019 14:12:17 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t20sm2933807qtr.7.2019.06.05.14.12.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 14:12:16 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 10/13] net/tls: export TLS per skb encryption
Date:   Wed,  5 Jun 2019 14:11:40 -0700
Message-Id: <20190605211143.29689-11-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605211143.29689-1-jakub.kicinski@netronome.com>
References: <20190605211143.29689-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

While offloading TLS connections, drivers need to handle the case where
out of order packets need to be transmitted.

Other drivers obtain the entire TLS record for the specific skb to
provide as context to hardware for encryption. However, other designs
may also want to keep the hardware state intact and perform the
out of order encryption entirely on the host.

To achieve this, export the already existing software encryption
fallback path so drivers could access this.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 include/net/tls.h             | 1 +
 net/tls/tls_device_fallback.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/net/tls.h b/include/net/tls.h
index 3da0d941e729..d1a4f365d6be 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -590,6 +590,7 @@ void tls_unregister_device(struct tls_device *device);
 int tls_device_decrypted(struct sock *sk, struct sk_buff *skb);
 int decrypt_skb(struct sock *sk, struct sk_buff *skb,
 		struct scatterlist *sgout);
+struct sk_buff *tls_encrypt_skb(struct sk_buff *skb);
 
 struct sk_buff *tls_validate_xmit_skb(struct sock *sk,
 				      struct net_device *dev,
diff --git a/net/tls/tls_device_fallback.c b/net/tls/tls_device_fallback.c
index 5a087e1981c3..1d2d804ac633 100644
--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -426,6 +426,12 @@ struct sk_buff *tls_validate_xmit_skb(struct sock *sk,
 }
 EXPORT_SYMBOL_GPL(tls_validate_xmit_skb);
 
+struct sk_buff *tls_encrypt_skb(struct sk_buff *skb)
+{
+	return tls_sw_fallback(skb->sk, skb);
+}
+EXPORT_SYMBOL_GPL(tls_encrypt_skb);
+
 int tls_sw_fallback_init(struct sock *sk,
 			 struct tls_offload_context_tx *offload_ctx,
 			 struct tls_crypto_info *crypto_info)
-- 
2.21.0

