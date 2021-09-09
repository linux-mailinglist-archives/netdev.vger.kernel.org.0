Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D931405095
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353100AbhIIM2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:28:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346005AbhIIMYO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:24:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACDF361371;
        Thu,  9 Sep 2021 11:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188276;
        bh=nMfTGbcyNEWLGDa5SeipsmZJGiZsvo5JM3wuNC1ZhG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p/z/zrKC7Sh7FEOjyLtuE2REWgeqzpc1psx+D4lMM0SfB/Lpk6DR+HTghPx1KFAWm
         FTA9REUSecl3tfNr0Ol+9D+rBlA35jsGaCMxUTradaNU5b6xgUhdMqoWr47UMlQQhv
         fmFr9Fx/lFYQlw5UA93Ono+kygAaQ5HoZUAaF5gwU3O8abueP5tNwLnWNr6JEP3kAe
         mZzFPWxS8iUcner1M12fXaxor7z4cYY8hLBVQbELLgc3buLvXpHOjr5TmhtDYMuw25
         nvPobgd54rFKYAfNxzTS+AGJPMuiWEuqZbOSIrKR+UeZLcHja7nN85AdfNwH9mTsNj
         cjY10opI61aYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guojia Liao <liaoguojia@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 219/219] net: hns3: clean up a type mismatch warning
Date:   Thu,  9 Sep 2021 07:46:35 -0400
Message-Id: <20210909114635.143983-219-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

[ Upstream commit e79c0e324b011b0288cd411a5b53870a7730f163 ]

abs() returns signed long, which could not convert the type
as unsigned, and it may cause a mismatch type warning from
static tools. To fix it, this patch uses an variable to save
the abs()'s result and does a explicit conversion.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 38b601031db4..95343f6d15e1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -10,7 +10,14 @@
 
 static u16 hclge_errno_to_resp(int errno)
 {
-	return abs(errno);
+	int resp = abs(errno);
+
+	/* The status for pf to vf msg cmd is u16, constrainted by HW.
+	 * We need to keep the same type with it.
+	 * The intput errno is the stander error code, it's safely to
+	 * use a u16 to store the abs(errno).
+	 */
+	return (u16)resp;
 }
 
 /* hclge_gen_resp_to_vf: used to generate a synchronous response to VF when PF
-- 
2.30.2

