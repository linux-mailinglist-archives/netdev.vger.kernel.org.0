Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B92344A5E
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbhCVQFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:05:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231228AbhCVQEy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 12:04:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1F12619AA;
        Mon, 22 Mar 2021 16:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616429094;
        bh=xAtyylaIqASvvaS85ZKuu0hXHauLkQxCojv0RLX/Mb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qF3TQ/qAB99dHQJQ17LkEWSGHzxXaa6ah0V394Zl3kvv8RzfyZLGR5LrTvWyC7H1A
         Y/FGboTYdhxs+1JdIoA84vXMKDdcAhTrEkBBb0UQUQKweCwvIzhlEQaLj3V5+EtINN
         TkIcf5XVjUiGPrExh51GxNaO8HstdwbBZt6yPypCRTLZ7dgkDLCsQKmQNcTUMokkXV
         S8QQatAQDJMuuHsGK0sG76w09rCi8u76J/NCDygW1XdPiFPESnsqpJ4LRffqASyFiK
         CjWew/HiP9HZ5pWACV/kafDp0YkSlO5krvl5NtQtLs6m/hkRHKNSKqc2U8LuhcidQu
         4FzJ0OAQMgZGg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     linux-kernel@vger.kernel.org, Martin Sebor <msebor@gcc.gnu.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
        Ning Sun <ning.sun@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Simon Kelley <simon@thekelleys.org.uk>,
        James Smart <james.smart@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Anders Larsen <al@alarsen.net>, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge@hallyn.com>,
        Imre Deak <imre.deak@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        tboot-devel@lists.sourceforge.net, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, cgroups@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH 07/11] ARM: sharpsl_param: work around -Wstringop-overread warning
Date:   Mon, 22 Mar 2021 17:02:45 +0100
Message-Id: <20210322160253.4032422-8-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210322160253.4032422-1-arnd@kernel.org>
References: <20210322160253.4032422-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

gcc warns that accessing a pointer based on a numeric constant may
be an offset into a NULL pointer, and would therefore has zero
accessible bytes:

arch/arm/common/sharpsl_param.c: In function ‘sharpsl_save_param’:
arch/arm/common/sharpsl_param.c:43:9: error: ‘memcpy’ reading 64 bytes from a region of size 0 [-Werror=stringop-overread]
   43 |         memcpy(&sharpsl_param, param_start(PARAM_BASE), sizeof(struct sharpsl_param_info));
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In this particular case, the warning is bogus since this is the actual
pointer, not an offset on a NULL pointer. Add a local variable to shut
up the warning and hope it doesn't come back.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99578
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/common/sharpsl_param.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/common/sharpsl_param.c b/arch/arm/common/sharpsl_param.c
index efeb5724d9e9..6237ede2f0c7 100644
--- a/arch/arm/common/sharpsl_param.c
+++ b/arch/arm/common/sharpsl_param.c
@@ -40,7 +40,9 @@ EXPORT_SYMBOL(sharpsl_param);
 
 void sharpsl_save_param(void)
 {
-	memcpy(&sharpsl_param, param_start(PARAM_BASE), sizeof(struct sharpsl_param_info));
+	struct sharpsl_param_info *params = param_start(PARAM_BASE);
+
+	memcpy(&sharpsl_param, params, sizeof(*params));
 
 	if (sharpsl_param.comadj_keyword != COMADJ_MAGIC)
 		sharpsl_param.comadj=-1;
-- 
2.29.2

