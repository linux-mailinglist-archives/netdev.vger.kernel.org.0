Return-Path: <netdev+bounces-366-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E2626F747B
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 21:51:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A537B280ECA
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:51:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 888A3101F7;
	Thu,  4 May 2023 19:44:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AE5101EC
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808C3C433EF;
	Thu,  4 May 2023 19:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229439;
	bh=yV4+vynWzQOVNw3R54V9ZpxF+ZG2uLGNOL+2GW1z2t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t4skI6oGyNcnDiWqi+LLbwJBH90lhcMhM1I8y1zWoWKegpNNNFE8Vwt28BJ55Yeqs
	 2gNn8osIeTel4rOOM/pjtyfzKfzhOB97zt4Rtyxhx+5eeVtji2u90FGjH3p8vUM/qM
	 EU294+z/GqHk5sW+AOBP45+VUsaWPECU9yYMmq1SzBQjO5xV99MVV+AL/DHfZ8olQu
	 v73PTrA2GaK3Jms0yG2Hdn7Ps6RN4yh7ZIKwJT5P4GwTACHQ+29GYuDGU5togzDYoI
	 sTuP4ZWy2XS740o0Xbn49s3mdLzb8OWf046XBixGqpoOGUm0xHK3fL42l/GVMONdPW
	 +cq6GeIQslXhQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Vasily Khoruzhick <anarsoul@gmail.com>,
	Bastian Germann <bage@debian.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	johan.hedberg@gmail.com,
	luiz.dentz@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.3 51/59] Bluetooth: Add new quirk for broken local ext features page 2
Date: Thu,  4 May 2023 15:41:34 -0400
Message-Id: <20230504194142.3805425-51-sashal@kernel.org>
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

From: Vasily Khoruzhick <anarsoul@gmail.com>

[ Upstream commit 8194f1ef5a815aea815a91daf2c721eab2674f1f ]

Some adapters (e.g. RTL8723CS) advertise that they have more than
2 pages for local ext features, but they don't support any features
declared in these pages. RTL8723CS reports max_page = 2 and declares
support for sync train and secure connection, but it responds with
either garbage or with error in status on corresponding commands.

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Signed-off-by: Bastian Germann <bage@debian.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h | 7 +++++++
 net/bluetooth/hci_event.c   | 9 +++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 400f8a7d0c3fe..997107bfc0b12 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -294,6 +294,13 @@ enum {
 	 * during the hdev->setup vendor callback.
 	 */
 	HCI_QUIRK_BROKEN_MWS_TRANSPORT_CONFIG,
+
+	/* When this quirk is set, max_page for local extended features
+	 * is set to 1, even if controller reports higher number. Some
+	 * controllers (e.g. RTL8723CS) report more pages, but they
+	 * don't actually support features declared there.
+	 */
+	HCI_QUIRK_BROKEN_LOCAL_EXT_FEATURES_PAGE_2,
 };
 
 /* HCI device flags */
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index e87c928c9e17a..51f13518dba9b 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -886,8 +886,13 @@ static u8 hci_cc_read_local_ext_features(struct hci_dev *hdev, void *data,
 	if (rp->status)
 		return rp->status;
 
-	if (hdev->max_page < rp->max_page)
-		hdev->max_page = rp->max_page;
+	if (hdev->max_page < rp->max_page) {
+		if (test_bit(HCI_QUIRK_BROKEN_LOCAL_EXT_FEATURES_PAGE_2,
+			     &hdev->quirks))
+			bt_dev_warn(hdev, "broken local ext features page 2");
+		else
+			hdev->max_page = rp->max_page;
+	}
 
 	if (rp->page < HCI_MAX_PAGES)
 		memcpy(hdev->features[rp->page], rp->features, 8);
-- 
2.39.2


