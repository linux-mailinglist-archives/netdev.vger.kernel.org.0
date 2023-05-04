Return-Path: <netdev+bounces-351-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78C116F73AB
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 21:45:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C60901C213AC
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:45:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE2882772C;
	Thu,  4 May 2023 19:42:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF282771E
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:42:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF387C433A7;
	Thu,  4 May 2023 19:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229352;
	bh=bkD6hVU+8F90R1FdgY0SO//u+++2L4MdapcaIwB2BL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZnJ83nOSmWzoU9SGz7V4PJlMT0ELfP1zqYEyy57eCOxHHYEHg2zV/6Mv+X7p6QaK2
	 BtVIC6pXA7PY+6El3VrTJ3Gt9MmtEN5TZcS+56qAicXmbCWuUevaD/djCbQTLNmi6Y
	 wn0SaVpILLTrfmTPRlH0vRCDOyVk+CKqa3jlHquYqLuwModOU4RTNhWwuMZ3mJTE7e
	 LU3Od7YiL34ZFYDvEOQ2JAL7MZaQ01gBShR3J+djPnuWwCe7OevSwQx4ULfbau8x4r
	 B8AKFFAhlXMudA/W3YlllOC8GVwGF3KejDpWXsXm7O6DRVf8GYCgXJ7KcZaw+nueD9
	 MSKilzqag2Zwg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Rajat Soni <quic_rajson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>,
	kvalo@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.3 16/59] wifi: ath12k: fix memory leak in ath12k_qmi_driver_event_work()
Date: Thu,  4 May 2023 15:40:59 -0400
Message-Id: <20230504194142.3805425-16-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504194142.3805425-1-sashal@kernel.org>
References: <20230504194142.3805425-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Rajat Soni <quic_rajson@quicinc.com>

[ Upstream commit 960412bee0ea75f6b3c2dca4a3535795ee84c47a ]

Currently the buffer pointed by event is not freed in case
ATH12K_FLAG_UNREGISTERING bit is set, this causes memory leak.

Add a goto skip instead of return, to ensure event and all the
list entries are freed properly.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0.1-00029-QCAHKSWPL_SILICONZ-1

Signed-off-by: Rajat Soni <quic_rajson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230315090632.15065-1-quic_rajson@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/qmi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index 979a63f2e2ab8..03ba245fbee92 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -2991,7 +2991,7 @@ static void ath12k_qmi_driver_event_work(struct work_struct *work)
 		spin_unlock(&qmi->event_lock);
 
 		if (test_bit(ATH12K_FLAG_UNREGISTERING, &ab->dev_flags))
-			return;
+			goto skip;
 
 		switch (event->type) {
 		case ATH12K_QMI_EVENT_SERVER_ARRIVE:
@@ -3032,6 +3032,8 @@ static void ath12k_qmi_driver_event_work(struct work_struct *work)
 			ath12k_warn(ab, "invalid event type: %d", event->type);
 			break;
 		}
+
+skip:
 		kfree(event);
 		spin_lock(&qmi->event_lock);
 	}
-- 
2.39.2


