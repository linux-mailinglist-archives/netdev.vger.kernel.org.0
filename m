Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E13A44F5A5
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 23:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbhKMWjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Nov 2021 17:39:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhKMWjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Nov 2021 17:39:36 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 308FFC061766;
        Sat, 13 Nov 2021 14:36:43 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id i63so26298652lji.3;
        Sat, 13 Nov 2021 14:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l7dkRItAesBmWLI3EQJRqqulRK8Cdr7rXiEqK0CwOuo=;
        b=jpUBBYlqIW1tcMwkGsJTvZo3OaUsAultFqvSZCetrm1YWz+A6KOEwcYeOEM3kOk3w8
         6aCGMg5o3aaMkUfy3cuVfdIv6NDB+/TikES02Hfzd6HwAJ3dn4Pzy/0QJNu1Tzmlt3r+
         pQzGgBHfsVniSYeJoqb1Keo9ZX5vY7TYgDXMclaxJUzZ9igcgtr1qJ5557roPaSzvGCQ
         UEwjZ+FucZZ8SfW9kctFzC8juaU4yFe1J9aKWS2IhRHiXFureR4JMcDQ91l6Y7r5AuBC
         jpKEUHp8eZYyCVJEky1GBqhyMeux0fVFkSGRqujGweWC9l+kSVIEwCG1TW3eeraFcwOJ
         GlnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l7dkRItAesBmWLI3EQJRqqulRK8Cdr7rXiEqK0CwOuo=;
        b=GaVT1SHS+gV1O8N17tcduaXLXN8Icz5MX37+HekZInaV2UgHPGQYFppPEbvgjxqC93
         R71+Aqrt/pVfL6BGxv366Ai7RtY7rjE17hnrZdKphH3PPxeFDzgmZhZ/r7WxycBw3cWt
         jaFuHN0KNzxXW9CE3PLBYtohaDmrsmiz9HR7KGuaIeGNWQqUONhB/SpzCTR6VB2T8QD3
         PzzrkllYQsCVqqApBzirpTlWGmQfBl6n0z0BlAZjMG4gs3lZ+gACKZVMWaqiTn8yA6bB
         CxDDP2veHFyYxEfj70TYTLJ30fe6cjz6bxsAmHceETW1mpfOamF7JzmGnJFK8na+0l7o
         SmFg==
X-Gm-Message-State: AOAM531HarlY+iVrC9xeogNwXVt5IbGxJOqNT7ACskxMOJRlv/fDzHDP
        NVJ0Z1vQXe6XeokNSc3OM7U=
X-Google-Smtp-Source: ABdhPJzhxIEFtRicWymc3DNRN+JR4afa87kLP22vvdLW5R+ssmXdAnjM/KdPoc0Hs2dsjQ05CVrSPw==
X-Received: by 2002:a2e:9a5a:: with SMTP id k26mr25746254ljj.9.1636843001413;
        Sat, 13 Nov 2021 14:36:41 -0800 (PST)
Received: from localhost.localdomain ([94.103.224.112])
        by smtp.gmail.com with ESMTPSA id s13sm457958lfg.126.2021.11.13.14.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Nov 2021 14:36:41 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     aelior@marvell.com, skalluru@marvell.com,
        GR-everest-linux-l2@marvell.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH] net: bnx2x: fix variable dereferenced before check
Date:   Sun, 14 Nov 2021 01:36:36 +0300
Message-Id: <20211113223636.11446-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Smatch says:
	bnx2x_init_ops.h:640 bnx2x_ilt_client_mem_op()
	warn: variable dereferenced before check 'ilt' (see line 638)

Move ilt_cli variable initialization _after_ ilt validation, because
it's unsafe to deref the pointer before validation check.

Fixes: 523224a3b3cd ("bnx2x, cnic, bnx2i: use new FW/HSI")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h
index 1835d2e451c0..fc7fce642666 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h
@@ -635,11 +635,13 @@ static int bnx2x_ilt_client_mem_op(struct bnx2x *bp, int cli_num,
 {
 	int i, rc;
 	struct bnx2x_ilt *ilt = BP_ILT(bp);
-	struct ilt_client_info *ilt_cli = &ilt->clients[cli_num];
+	struct ilt_client_info *ilt_cli;
 
 	if (!ilt || !ilt->lines)
 		return -1;
 
+	ilt_cli = &ilt->clients[cli_num];
+
 	if (ilt_cli->flags & (ILT_CLIENT_SKIP_INIT | ILT_CLIENT_SKIP_MEM))
 		return 0;
 
-- 
2.33.1

