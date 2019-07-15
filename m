Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0FA069698
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 17:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388161AbfGOOFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:05:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733242AbfGOOFg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:05:36 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A136B21842;
        Mon, 15 Jul 2019 14:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199535;
        bh=j+BQ01EWDQFk4EWnsQA580I1Cevoo20aZTWTabtNWH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K5cIFSwoSYYj10fWaBG+ZqQAVm2sh8EK2FPrZER41XXQu0lKpgiZZ1rbrnQ/ttSIq
         DfXm7szwfdSW6slYqoCJarzop72puS8mKb0+5xFDVi6RjRjlZ9O8ov1WYGf2pzNikH
         6EH71xe192u+8nO6Bol4bsnhGLRUpdO4WqXdjQQE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anirudh Gupta <anirudhrudr@gmail.com>,
        Anirudh Gupta <anirudh.gupta@sophos.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 036/219] xfrm: Fix xfrm sel prefix length validation
Date:   Mon, 15 Jul 2019 10:00:37 -0400
Message-Id: <20190715140341.6443-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Gupta <anirudhrudr@gmail.com>

[ Upstream commit b38ff4075a80b4da5cb2202d7965332ca0efb213 ]

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
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 6916931b1de1..ee91f939903e 100644
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
2.20.1

