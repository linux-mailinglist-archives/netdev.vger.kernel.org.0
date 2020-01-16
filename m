Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D15E413E725
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390817AbgAPRXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:23:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:57476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390663AbgAPRNK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:13:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C02D02469D;
        Thu, 16 Jan 2020 17:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194789;
        bh=2cau1KIjwdkpTD9nT1zF1o98NKiqC//O1dSTLO6FqFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TXC2rp+eNJRV8TVQxzeOpdjmEgwIy6xifPeTUKl1J5r8nLpOLEiDK9KOVbOA2bNzH
         pw3TkU8LCoep12yYC/8vxFVY0AetD4Vg1NhsajfgZS//s8yVo6nqejJD+yYM33wsif
         asVOD3EO9PCmfrlGGbLMlGI7N1FqhNBsJQLl13mI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 603/671] bpf, offload: Unlock on error in bpf_offload_dev_create()
Date:   Thu, 16 Jan 2020 12:04:01 -0500
Message-Id: <20200116170509.12787-340-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit d0fbb51dfaa612f960519b798387be436e8f83c5 ]

We need to drop the bpf_devs_lock on error before returning.

Fixes: 9fd7c5559165 ("bpf: offload: aggregate offloads per-device")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Link: https://lore.kernel.org/bpf/20191104091536.GB31509@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/offload.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index 177a52436394..86477f3894e5 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -645,8 +645,10 @@ struct bpf_offload_dev *bpf_offload_dev_create(void)
 	down_write(&bpf_devs_lock);
 	if (!offdevs_inited) {
 		err = rhashtable_init(&offdevs, &offdevs_params);
-		if (err)
+		if (err) {
+			up_write(&bpf_devs_lock);
 			return ERR_PTR(err);
+		}
 		offdevs_inited = true;
 	}
 	up_write(&bpf_devs_lock);
-- 
2.20.1

