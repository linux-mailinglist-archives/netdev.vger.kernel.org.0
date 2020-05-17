Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAA61D68D7
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 18:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgEQQ0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 12:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728035AbgEQQ0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 12:26:45 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC6BC061A0C;
        Sun, 17 May 2020 09:26:45 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id y18so3685843pfl.9;
        Sun, 17 May 2020 09:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=toOqvUbCN7k/hG3JfrukVmhVyaeJAC9TE9an1UW3f1w=;
        b=YZDTup9sT48PKu+YMlGqQ1jWO8Bs8ez3oRhaX+XXTrcYN7loMY071r6nM5hpzU/HwB
         ljkjpKPB4w/JK0Adey6IDlFI026eX9dQBVmeFuOIj4AW0kEpRusatb8fJlz9JDedkWE8
         PPIjJrfK3KAjx6imA6GlndDW2PPPRPtVHAvYJVur5+gBiyUBbwG0qnMqLhKFBSqgOrHE
         NF7Cj0XIRTbZHRfxnLqotwWEczwHS9moyWQXXVOFi+Up+Xf+9Xq+qcnoKzXIg0aszhbC
         EC1vzUoZcHe6N+SITOcPGg/dpNWDwA0QEkVorEseU/Y72f/3zTaLuW/XtFg3fy99uLHh
         VdzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=toOqvUbCN7k/hG3JfrukVmhVyaeJAC9TE9an1UW3f1w=;
        b=NbTuHTqyHBcqVRoDRDYmjKwVFiaNyNHPT4SgzpBlwi9foUHRCZBdCD+BDknEMJlg2Q
         NEPD0gJr8rK7s0WnegrnMbSF1vj+96/mqu9M+xMVvE7dTMWNXkQNRuMwXXEfvmcjS7NB
         0yKCxwS9oSHtf6IHOOq9PwuKGZ2FuXsL3GGImMm+0Y/npes7ESuqRTMV0HqfAwlKdd6M
         4weKlyXoWuWSuSELOFDQGwFVGgqzpArG45w7dpkQZ0jvH1PYjnZwFEn90rVGH4le7NvO
         OHN6ZXO86mX8KnLunYSbVgaKPMbGocvc7FkDkAaDszFneZSbzh2/xCwQqQATcm+dOoQJ
         KmGg==
X-Gm-Message-State: AOAM531XfJMzLLIGPeaeVVR/EUB4x3j4i3FDScm3ufp2RjohUY78uS3S
        DAsRkjou04A7aX5JaEcx0DQ=
X-Google-Smtp-Source: ABdhPJy05fCRkBkeLZ1evHFbk5VrmPe1BMHIi42uxsLJ0wurt1UNVvK1xB1TcwcqdI8/Ss6Q2978mw==
X-Received: by 2002:a62:ddd6:: with SMTP id w205mr12981004pff.291.1589732805093;
        Sun, 17 May 2020 09:26:45 -0700 (PDT)
Received: from kvmhost.ch.hwng.net (kvmhost.ch.hwng.net. [69.16.191.151])
        by smtp.gmail.com with ESMTPSA id y5sm943517pff.150.2020.05.17.09.26.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 17 May 2020 09:26:44 -0700 (PDT)
From:   Pooja Trivedi <poojatrivedi@gmail.com>
X-Google-Original-From: Pooja Trivedi <pooja.trivedi@stackpath.com>
To:     borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net, kuba@kernel.org,
        davem@davemloft.net, vakul.garg@nxp.com, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        mallesham.jatharkonda@oneconvergence.com, josh.tway@stackpath.com,
        pooja.trivedi@stackpath.com
Subject: [PATCH net] net/tls(TLS_SW): Fix integrity issue with non-blocking sw KTLS request
Date:   Sun, 17 May 2020 16:26:36 +0000
Message-Id: <1589732796-22839-1-git-send-email-pooja.trivedi@stackpath.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In pure sw ktls(AES-NI), -EAGAIN from tcp layer (do_tcp_sendpages for
encrypted record) gets treated as error, subtracts the offset, and
returns to application. Because of this, application sends data from
subtracted offset, which leads to data integrity issue. Since record is
already encrypted, ktls module marks it as partially sent and pushes the
packet to tcp layer in the following iterations (either from bottom half
or when pushing next chunk). So returning success in case of EAGAIN
will fix the issue.

Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption")
Signed-off-by: Pooja Trivedi <pooja.trivedi@stackpath.com>
Reviewed-by: Mallesham Jatharkonda <mallesham.jatharkonda@oneconvergence.com>
Reviewed-by: Josh Tway <josh.tway@stackpath.com>
---
 net/tls/tls_sw.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index e23f94a..d8ebdfc 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -415,10 +415,12 @@ int tls_tx_records(struct sock *sk, int flags)
 	}
 
 tx_err:
-	if (rc < 0 && rc != -EAGAIN)
+	if (rc < 0 && rc != -EAGAIN) {
 		tls_err_abort(sk, EBADMSG);
+		return rc;
+	}
 
-	return rc;
+	return 0;
 }
 
 static void tls_encrypt_done(struct crypto_async_request *req, int err)
-- 
1.8.3.1

