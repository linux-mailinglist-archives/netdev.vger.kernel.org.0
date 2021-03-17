Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A79633E48F
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbhCQBAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:00:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232004AbhCQA6V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:58:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A6B864F9E;
        Wed, 17 Mar 2021 00:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942694;
        bh=Z5IE1ta42oWIMZ3rFCd+yaK9i+JloaJtApauh/WGyhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jL5mCIYWlAagods0p7jYnTqTo5KOZR65hJkl2k8/BqV7DI+WJob0zCTpLastUGTbU
         GgVq3cCeLm7i+1Raf/DtUWcvCroLOWbuFtPROGVi3oKyy5dlNEubGxo0xTipwGeD5J
         WMJt3D131JUBCz6ELv1y7xXE5rpamp+O8UhzNel0hbSQrD/dLtZFs+ZTSRRdGgLdIP
         DWgCcSzYgn/cm1HgMJU9mOEu3bY6JconkHpUWFqUV2RsyQFSA0p2jre0X7Butivmwf
         US8RGKHM4YG07K8tuZdY1VoNCXSTtfeqVocIh083t1Ba4PuryCBb4O5ypyK7sDPHiY
         ynPRBx6EyTzwA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/37] net: intel: iavf: fix error return code of iavf_init_get_resources()
Date:   Tue, 16 Mar 2021 20:57:34 -0400
Message-Id: <20210317005802.725825-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005802.725825-1-sashal@kernel.org>
References: <20210317005802.725825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 6650d31f21b8a0043613ae0a4a2e42e49dc20b2d ]

When iavf_process_config() fails, no error return code of
iavf_init_get_resources() is assigned.
To fix this bug, err is assigned with the return value of
iavf_process_config(), and then err is checked.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 56e6bec9af79..cffc8c1044f2 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1786,7 +1786,8 @@ static int iavf_init_get_resources(struct iavf_adapter *adapter)
 		goto err_alloc;
 	}
 
-	if (iavf_process_config(adapter))
+	err = iavf_process_config(adapter);
+	if (err)
 		goto err_alloc;
 	adapter->current_op = VIRTCHNL_OP_UNKNOWN;
 
-- 
2.30.1

