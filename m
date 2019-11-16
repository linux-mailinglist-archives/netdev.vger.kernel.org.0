Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3F80FED6B
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 16:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728887AbfKPPnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 10:43:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:48182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727857AbfKPPnw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:43:52 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B506620815;
        Sat, 16 Nov 2019 15:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919031;
        bh=HsPWwmDEIMEtsZTabfg0H5Vjz9voDV9fpRM5MsHpzpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SJsNLAOK8oEzNN8ww8BGKl/RiEUr3Np96FZFyR/TEnBg1lvIaUyZPEe5+qZmMYi4N
         3SSdBioC2M6mnficfExdfzUEv7A5L7Nr8MCzyHZe1K0qzv3wNngldT5/FL7n9gby3n
         UyTDYbiRmJrFfXtAXVKcgmAyUInagOM/C1KbAhj0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, sparclinux@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 127/237] sparc64: Rework xchg() definition to avoid warnings.
Date:   Sat, 16 Nov 2019 10:39:22 -0500
Message-Id: <20191116154113.7417-127-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 6c2fc9cddc1ffdef8ada1dc8404e5affae849953 ]

Such as:

fs/ocfs2/file.c: In function ‘ocfs2_file_write_iter’:
./arch/sparc/include/asm/cmpxchg_64.h:55:22: warning: value computed is not used [-Wunused-value]
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))

and

drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c: In function ‘ixgbevf_xdp_setup’:
./arch/sparc/include/asm/cmpxchg_64.h:55:22: warning: value computed is not used [-Wunused-value]
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/include/asm/cmpxchg_64.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/sparc/include/asm/cmpxchg_64.h b/arch/sparc/include/asm/cmpxchg_64.h
index f71ef3729888f..316faa0130bab 100644
--- a/arch/sparc/include/asm/cmpxchg_64.h
+++ b/arch/sparc/include/asm/cmpxchg_64.h
@@ -52,7 +52,12 @@ static inline unsigned long xchg64(__volatile__ unsigned long *m, unsigned long
 	return val;
 }
 
-#define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
+#define xchg(ptr,x)							\
+({	__typeof__(*(ptr)) __ret;					\
+	__ret = (__typeof__(*(ptr)))					\
+		__xchg((unsigned long)(x), (ptr), sizeof(*(ptr)));	\
+	__ret;								\
+})
 
 void __xchg_called_with_bad_pointer(void);
 
-- 
2.20.1

