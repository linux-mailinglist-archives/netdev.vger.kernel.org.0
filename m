Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7CBC2B8D5E
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 09:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgKSIb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 03:31:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbgKSIb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 03:31:58 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C81AC0613CF;
        Thu, 19 Nov 2020 00:31:58 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id r18so3569475pgu.6;
        Thu, 19 Nov 2020 00:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Jkyz9oA86nMEZfz7a15VcqRN3v2AQv1c0SdQ6R0sWHE=;
        b=WlrRxaJl4muoW1PCRTEsgUyJ6qJzN4ysisw+s+nc+tf4zg1Itm63uH8jc3JSu962Ko
         Hkxg2mfOSsxZPuEjkSGAmc5LyxoRJekpIHBNtsygxRNyqv7BLlx0541g2h4UjINwD3ig
         QUAocLY4OZBS6TwBvLyFyvi6tntk2JpSf5lhxbDXHo8zxMKU0wL0t4KukOdWMLIks3d+
         lK1LGRyG3rMHESEypCJAI1mysx8mtvKzNzBEICBdod+m8pOtD3s3TrKU30MBLu4k2GkJ
         8myPYNjAUT8NPVcyKvpT3NHyiUExzocvAs9H+67sDHhYgLIcm3hp3ZclqInOTbpwRjGz
         bIOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jkyz9oA86nMEZfz7a15VcqRN3v2AQv1c0SdQ6R0sWHE=;
        b=ediNmRuKMUs1/C6HWuOup9wWuArSjBvsPfVBuZRCJr8XcOHiLb6X1v3gmEfmqKE19a
         S+Ag5Ej/eyh2OaZS8MFEByksLuOY2Rnu6bgYYWmgYD42yuHpd1ZDdtaRDZwqaeLBAw6C
         C+ODNjx0GsCle3/jDXVgHdgcyI2dgLVNervDjmcNUhKsHEIwJg43kaNjlsq7o/vX0cHT
         7tT+BZ6jSvyYG1R/sa7IyzZaMvI0A+azAq6utKZXvhBGlVmila+oWeyaywz53KnNHLDz
         tHxttsYVJoAcAE/+Y+0wmRPBI927FdfPGCpKEb/BI72bKuSpRL1DwNvg/K8Rj5e/AmB8
         wmMA==
X-Gm-Message-State: AOAM5303Km+nQlkQMasU50HQeyv+rOGRWcZFMLrC11CpnCzlsoDxmAQq
        7M6t7KYBlFsdXi6aAYl3DlyZ1pBwc1ILirh5
X-Google-Smtp-Source: ABdhPJwA9eeaCmA8RxBTEK9yOpT+WYcvswxjEKLWlljsaxcH9Wn3RXRaIswpuanbsHsgLIqTKSYPHg==
X-Received: by 2002:a17:90a:7c03:: with SMTP id v3mr3371946pjf.28.1605774717036;
        Thu, 19 Nov 2020 00:31:57 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id r2sm5517713pji.55.2020.11.19.00.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 00:31:55 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: [PATCH bpf-next v3 10/10] samples/bpf: add option to set the busy-poll budget
Date:   Thu, 19 Nov 2020 09:30:24 +0100
Message-Id: <20201119083024.119566-11-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201119083024.119566-1-bjorn.topel@gmail.com>
References: <20201119083024.119566-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Support for the SO_BUSY_POLL_BUDGET setsockopt, via the batching
option ('b').

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 samples/bpf/xdpsock_user.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index cb1eaee8a32b..deba623e9003 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1479,6 +1479,11 @@ static void apply_setsockopt(struct xsk_socket_info *xsk)
 	if (setsockopt(xsk_socket__fd(xsk->xsk), SOL_SOCKET, SO_BUSY_POLL,
 		       (void *)&sock_opt, sizeof(sock_opt)) < 0)
 		exit_with_error(errno);
+
+	sock_opt = opt_batch_size;
+	if (setsockopt(xsk_socket__fd(xsk->xsk), SOL_SOCKET, SO_BUSY_POLL_BUDGET,
+		       (void *)&sock_opt, sizeof(sock_opt)) < 0)
+		exit_with_error(errno);
 }
 
 int main(int argc, char **argv)
-- 
2.27.0

