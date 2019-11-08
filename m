Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91B93F4A8F
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732901AbfKHLiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:38:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:51828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732867AbfKHLit (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:38:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1130621D7E;
        Fri,  8 Nov 2019 11:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213128;
        bh=XASaPVNLquPRF1SYPNjsfMRkaqtaJWywVTdfYYyc8zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j8BD64A4bTegWqGl8q9g/FSp3jf59+JusxiOG3EmBAp2PdleN6zHs4a1QPtnWLcJU
         5LfVt966tt/Mj+0JogPJ807KEpTycsp8AljvCGFZbNKuScch1S6WrqUYpLeFIiMLrg
         bXUWvw3pdZAxdBU68cm+uBBF4rQ1ADlKnHeRGj9A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mitch Williams <mitch.a.williams@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 047/205] i40e: use correct length for strncpy
Date:   Fri,  8 Nov 2019 06:35:14 -0500
Message-Id: <20191108113752.12502-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mitch Williams <mitch.a.williams@intel.com>

[ Upstream commit 7eb74ff891b4e94b8bac48f648a21e4b94ddee64 ]

Caught by GCC 8. When we provide a length for strncpy, we should not
include the terminating null. So we must tell it one less than the size
of the destination buffer.

Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_ptp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ptp.c b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
index 35f2866b38c6b..1199f0502d6d5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ptp.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
@@ -694,7 +694,8 @@ static long i40e_ptp_create_clock(struct i40e_pf *pf)
 	if (!IS_ERR_OR_NULL(pf->ptp_clock))
 		return 0;
 
-	strncpy(pf->ptp_caps.name, i40e_driver_name, sizeof(pf->ptp_caps.name));
+	strncpy(pf->ptp_caps.name, i40e_driver_name,
+		sizeof(pf->ptp_caps.name) - 1);
 	pf->ptp_caps.owner = THIS_MODULE;
 	pf->ptp_caps.max_adj = 999999999;
 	pf->ptp_caps.n_ext_ts = 0;
-- 
2.20.1

