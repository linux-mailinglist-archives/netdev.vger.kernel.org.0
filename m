Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48502CC66E
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 01:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731633AbfJDXTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 19:19:55 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39620 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731593AbfJDXTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 19:19:53 -0400
Received: by mail-qt1-f196.google.com with SMTP id n7so10846010qtb.6
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 16:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kLO+1RVBPzfq69ohl1dd4R6zmwVoF+TZpJ7jLdc5g/I=;
        b=PAvaeytL50Z8HJxvh5cW5tYpZrUiGxjUg9qB4iGSyOgF9KF0UBUZUCvf/94U/zF5yu
         5co/FL0FTCZto/GSWEPMQ2f5Fr2qsIsBZ8vuyD1EWl3v7px674TitKdSo3ENLILyPSLo
         SztWt3eTV62wrfDexX4bUDxIcbRQN04R4dMW35IixubBsqaBjzusyv/o7kVJ8evqYllR
         tx/qQAfIUnZo53vQchgj62e/GyV5/3XlUnu5B08M/E6LjNW9m1OKUZn5SPNrEGH/t/2E
         iJeRTSMhMIrrihRCujUrgly3WOSIamEfbtTkSag6e9QoWY6VyH3iAAk1ipItoqekFGaf
         K1ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kLO+1RVBPzfq69ohl1dd4R6zmwVoF+TZpJ7jLdc5g/I=;
        b=SNc6XJoCofxUbVQdzCJVbesTG85MZ3NBY7GpdgaspbzTrbMakoLaEiyofSIcVs+Bzt
         t5wWmEOVLN0DBwNWLSFIPAHkAUnOT0dz94yjZUE6uERhg8MrYim3k4biSblMZPjkswZi
         8qJ7DDgf+wpyUI4cofRli7vDR0A3cI+pFDlJgidDtd2JPjFG/gMHUjNMcUKAv1oueGdt
         Ie/AUYcY6I2kjm3I8u4bKWR/QhgsDJxwlAxKdG8GgWdwjSQOKgQ3zo6Ihj4/GpKCvZtu
         jsxQ0WGRte3RHtrj3F3W+hXcn8IqVNBmbLpGo11BeL89W1Cpr7+iBL0kyrBoXDCgkZJp
         Ru9Q==
X-Gm-Message-State: APjAAAUV+3UnN3wNylUFcBhFoSmCC07SKRHz87ZoXVBV5o3HoM8eWNdU
        iWiFh8eSAp9u7s8jtJ0yxVqL/mE+wN4=
X-Google-Smtp-Source: APXvYqyDmtuNRl6FkRHNJTo86CWx6OQD4rX+2iSJMa0xEPW2ZdekTYvXHmR/Wzvyxj5ESsX1fUiy4g==
X-Received: by 2002:ac8:4641:: with SMTP id f1mr18658218qto.37.1570231192766;
        Fri, 04 Oct 2019 16:19:52 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z46sm4653398qth.62.2019.10.04.16.19.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Oct 2019 16:19:52 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, davejwatson@fb.com, borisp@mellanox.com,
        aviadye@mellanox.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 6/6] net/tls: add TlsDeviceRxResync statistic
Date:   Fri,  4 Oct 2019 16:19:27 -0700
Message-Id: <20191004231927.21134-7-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191004231927.21134-1-jakub.kicinski@netronome.com>
References: <20191004231927.21134-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a statistic for number of RX resyncs sent down to the NIC.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 Documentation/networking/tls.rst | 3 +++
 include/uapi/linux/snmp.h        | 1 +
 net/tls/tls_device.c             | 1 +
 net/tls/tls_proc.c               | 1 +
 4 files changed, 6 insertions(+)

diff --git a/Documentation/networking/tls.rst b/Documentation/networking/tls.rst
index ab82362dd819..8cb2cd4e2a80 100644
--- a/Documentation/networking/tls.rst
+++ b/Documentation/networking/tls.rst
@@ -236,3 +236,6 @@ TLS implementation exposes the following per-namespace statistics
 
 - ``TlsDecryptError`` -
   record decryption failed (e.g. due to incorrect authentication tag)
+
+- ``TlsDeviceRxResync`` -
+  number of RX resyncs sent to NICs handling cryptography
diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index c9e4963e26f0..7eee233e78d2 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -336,6 +336,7 @@ enum
 	LINUX_MIB_TLSTXDEVICE,			/* TlsTxDevice */
 	LINUX_MIB_TLSRXDEVICE,			/* TlsRxDevice */
 	LINUX_MIB_TLSDECRYPTERROR,		/* TlsDecryptError */
+	LINUX_MIB_TLSRXDEVICERESYNC,		/* TlsRxDeviceResync */
 	__LINUX_MIB_TLSMAX
 };
 
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 5a9a86bf0ee1..f306e4c7bf15 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -661,6 +661,7 @@ static void tls_device_resync_rx(struct tls_context *tls_ctx,
 		netdev->tlsdev_ops->tls_dev_resync(netdev, sk, seq, rcd_sn,
 						   TLS_OFFLOAD_CTX_DIR_RX);
 	clear_bit_unlock(TLS_RX_SYNC_RUNNING, &tls_ctx->flags);
+	TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSRXDEVICERESYNC);
 }
 
 void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq)
diff --git a/net/tls/tls_proc.c b/net/tls/tls_proc.c
index 2bea7ef4823c..83d9c80a684e 100644
--- a/net/tls/tls_proc.c
+++ b/net/tls/tls_proc.c
@@ -16,6 +16,7 @@ static const struct snmp_mib tls_mib_list[] = {
 	SNMP_MIB_ITEM("TlsTxDevice", LINUX_MIB_TLSTXDEVICE),
 	SNMP_MIB_ITEM("TlsRxDevice", LINUX_MIB_TLSRXDEVICE),
 	SNMP_MIB_ITEM("TlsDecryptError", LINUX_MIB_TLSDECRYPTERROR),
+	SNMP_MIB_ITEM("TlsRxDeviceResync", LINUX_MIB_TLSRXDEVICERESYNC),
 	SNMP_MIB_SENTINEL
 };
 
-- 
2.21.0

