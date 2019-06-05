Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2068636686
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 23:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfFEVMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 17:12:16 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38780 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbfFEVMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 17:12:14 -0400
Received: by mail-qt1-f195.google.com with SMTP id l3so244413qtj.5
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 14:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J9lmQKmPdFxMzdJBm6YW25KEhsucLsyzLcjjFpWRcY0=;
        b=v9o5+kN7bqSGo6UfbIlCWgPQ5hQtG4hz7ETANt0XHs59OSp389ZweCn/zGF/tbBSa8
         Gf4isjtiN8IiQaqa26VCgHnLJQ406CneuXap2CzZNo7fR27XzSbYWhjAq3MvS+swrJQM
         Q2r9OeRiF3zjRz64k0WZI80LcRRiyjVRYXVle149bswOABQ2qp5gpbyNQPHGFyUg1wxs
         8y0mxUFDYjMhNrG/m8KU74WJUlQERrSaAUV+CeVSkg+8mctHCQ2WSDvruO1woITi7sqp
         yjsMyqgjNHAgKzzrP4lGXC7impCAm9z/Fid04dfQ/zpZkyOuBxdZdwURObc2X0uzHBeH
         n30w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J9lmQKmPdFxMzdJBm6YW25KEhsucLsyzLcjjFpWRcY0=;
        b=qWGGIp0xoW85i7CXGbRDu20DvNFTBmZ+v+HsKom5sOy+qvT5dRL8p8OlG/Y41CO2w9
         MfRBTOrPjB/+XNNN83AaPyWkyKHhTaL8802hO7cuY0Wd4tB0dqQRH8Wj05aSnp7w4mnR
         O+gSLLxZ2QH75b1UopSsv3mpvDFMH4QdnxPKhR7kXfa9FzshE+KUQRAy3D+MCRardvIe
         EXSgsGreFDjNFOkx5o/LlX/u3ycVDZdk02rUu16jcALF6PyPFJaiFMLcF03Rg5LfRoqw
         QLvgsWRlbi2y97u3PzkLjmWBuOdD0AMhOLlMpp41qHQm+d5MkhtsOooYtHbdxIECAp+d
         7Fiw==
X-Gm-Message-State: APjAAAVfSTrL/MXAOv+hfv9/T2l5y9KSRJCZQKYQrJaOos+4x50SpsdG
        fxKxBdsC5/FqIcmDfUF8bQlNxA==
X-Google-Smtp-Source: APXvYqyL7VzZ49NxKj5fxOE0PZJGX7l4Q2KO6cLHzRaTtPX5xjnCqCSrGFvUcUFd8EGTOnI5AuuEGg==
X-Received: by 2002:ac8:94f:: with SMTP id z15mr3016928qth.265.1559769134074;
        Wed, 05 Jun 2019 14:12:14 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t20sm2933807qtr.7.2019.06.05.14.12.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 14:12:13 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 08/13] net/tls: split the TLS_DRIVER_STATE_SIZE and bump TX to 16 bytes
Date:   Wed,  5 Jun 2019 14:11:38 -0700
Message-Id: <20190605211143.29689-9-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605211143.29689-1-jakub.kicinski@netronome.com>
References: <20190605211143.29689-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

8 bytes of driver state has been enough so far, but for drivers
which have to store 8 byte handle it's no longer practical to
store the state directly in the context.

Drivers generally don't need much extra state on RX side, while
TX side has to be tracking TCP sequence numbers.  Split the
lengths of max driver state size on RX and TX.

The struct tls_offload_context_tx currently stands at 616 bytes and
struct tls_offload_context_rx stands at 368 bytes.  Upcoming work
will consume extra 8 bytes in both for kernel-driven resync.
This means that we can bump TX side to 16 bytes and still fit
into the same number of cache lines but on RX side we would be 8
bytes over.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 include/net/tls.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 0a0072636009..3094db5398a9 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -202,12 +202,12 @@ struct tls_offload_context_tx {
 	 * Currently the belief is that there is not enough
 	 * driver specific state to justify another layer of indirection
 	 */
-#define TLS_DRIVER_STATE_SIZE (max_t(size_t, 8, sizeof(void *)))
+#define TLS_DRIVER_STATE_SIZE_TX	16
 };
 
 #define TLS_OFFLOAD_CONTEXT_SIZE_TX                                            \
 	(ALIGN(sizeof(struct tls_offload_context_tx), sizeof(void *)) +        \
-	 TLS_DRIVER_STATE_SIZE)
+	 TLS_DRIVER_STATE_SIZE_TX)
 
 struct cipher_context {
 	char *iv;
@@ -307,11 +307,12 @@ struct tls_offload_context_rx {
 	 * Currently the belief is that there is not enough
 	 * driver specific state to justify another layer of indirection
 	 */
+#define TLS_DRIVER_STATE_SIZE_RX	8
 };
 
 #define TLS_OFFLOAD_CONTEXT_SIZE_RX					\
 	(ALIGN(sizeof(struct tls_offload_context_rx), sizeof(void *)) + \
-	 TLS_DRIVER_STATE_SIZE)
+	 TLS_DRIVER_STATE_SIZE_RX)
 
 int wait_on_pending_writer(struct sock *sk, long *timeo);
 int tls_sk_query(struct sock *sk, int optname, char __user *optval,
-- 
2.21.0

