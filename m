Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93AAB253EC
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 17:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728505AbfEUPay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 11:30:54 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40148 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728298AbfEUPay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 11:30:54 -0400
Received: by mail-pf1-f193.google.com with SMTP id u17so9255766pfn.7;
        Tue, 21 May 2019 08:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KWOHZODUUyunDgNs5B1B0Qzkf/SDTn0BMnr1ZqAsBvs=;
        b=c4qL9fxKUhzVGcf7gk/+Tr6l41IYLs4L+0yu4O0LYsMXgzld3/DyDvBEdZfFdHFY+k
         OfINvcBKVUzsHFL2i0oBVfHX7cwjY5QrbttT9gmZKW20FoTQwCmIOnQ+4JJHfohuKGgT
         ypWtvcIxZN+5gZrjtbpAxwF31iGqB8fF3mXxgst1m/J6Q1CrPGYYtvYkdYJ3fBP8HneD
         EsvC75dHreCPr3S/8tLO63oHYp9LHPk50eDwmDAwNNzmHpMZylIRfdIvPk5ahH3FUaYJ
         obDfXL97SpBtUsP/WUPmkHeeKKAtzmydI3HLF8RJOpoOTmErO4nSbrwYAwVk5ONuxFDk
         u+NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KWOHZODUUyunDgNs5B1B0Qzkf/SDTn0BMnr1ZqAsBvs=;
        b=f3npvPhpyPCYdKlKxvFPTd8ND2ff+M+KkA5u8DzakSjHHk0zikO/9DxYjPmqcIUxw8
         MWXlJPftZeAxYZCb7AqZBk4OBi8M94iPI7nz6D7lyDveONou1b6UvKNfRU8Xahuez0aW
         vIaftV7SArhsRf/vv10nxxPKh6XjnG8SgX/AV4cNT9gQZ+y+tej33tah4CA+rOSx48g6
         qJL8AdCE92anntKC/4AifEf7hu10oYMSkNg9J5MIx/Uv1al1+6AMrEWSjMrXhTnO1V2x
         XQxaSK5wgFHXZTSs1fI+vntDdGvGCA65I2T9pgxU7G1sEmnocPFxO017BvvciElwwSWc
         5afQ==
X-Gm-Message-State: APjAAAWjIDFf4Mbt4/YUmdSBOBhzNpGbJ6Ni3v765CykG9esoQRlsKbA
        CsKcEvpHpWViUAlq0glfZKiAqXrkodQ=
X-Google-Smtp-Source: APXvYqzz9y1jHan1nYFnx1sfA1DdFuL6DaMEy/Fwxaf1XY/fwEzvvd+hazrVeDyJfsAlLvm7mGlPXg==
X-Received: by 2002:a63:d150:: with SMTP id c16mr82709090pgj.439.1558452653182;
        Tue, 21 May 2019 08:30:53 -0700 (PDT)
Received: from localhost.localdomain ([27.61.167.91])
        by smtp.googlemail.com with ESMTPSA id e62sm25543035pfa.50.2019.05.21.08.30.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 08:30:52 -0700 (PDT)
From:   Anirudh Gupta <anirudhrudr@gmail.com>
X-Google-Original-From: Anirudh Gupta <anirudh.gupta@sophos.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Anirudh Gupta <anirudh.gupta@sophos.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] xfrm: Fix xfrm sel prefix length validation
Date:   Tue, 21 May 2019 20:59:47 +0530
Message-Id: <20190521152947.75014-1-anirudh.gupta@sophos.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Family of src/dst can be different from family of selector src/dst.
Use xfrm selector family to validate address prefix length,
while verifying new sa from userspace.

Validated patch with this command:
ip xfrm state add src 1.1.6.1 dst 1.1.6.2 proto esp spi 4260196 \
reqid 20004 mode tunnel aead "rfc4106(gcm(aes))" \
0x1111016400000000000000000000000044440001 128 \
sel src 1011:1:4::2/128 sel dst 1021:1:4::2/128 dev Port5

Fixes: 07bf7908950a ("xfrm: Validate address prefix lengths in the xfrm selector.")
Signed-off-by: Anirudh Gupta <anirudh.gupta@sophos.com>
---
 net/xfrm/xfrm_user.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index eb8d14389601..74a3d1e0ff63 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -150,6 +150,22 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 
 	err = -EINVAL;
 	switch (p->family) {
+	case AF_INET:
+		break;
+
+	case AF_INET6:
+#if IS_ENABLED(CONFIG_IPV6)
+		break;
+#else
+		err = -EAFNOSUPPORT;
+		goto out;
+#endif
+
+	default:
+		goto out;
+	}
+
+	switch (p->sel.family) {
 	case AF_INET:
 		if (p->sel.prefixlen_d > 32 || p->sel.prefixlen_s > 32)
 			goto out;
-- 
2.19.0

