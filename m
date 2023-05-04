Return-Path: <netdev+bounces-389-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 230A86F758E
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 21:58:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 436B31C21372
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:58:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D4A4C122;
	Thu,  4 May 2023 19:46:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2419427735
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87AC6C4339E;
	Thu,  4 May 2023 19:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229573;
	bh=TNm0yrIervS2LXwIJUly4WGmTV4UHIrQ3v4l9E2viOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lEi/gZDoqkIhRJO+MbPVRDKUQe1lLJ0RVYYWmVgMreYWTs7FQLpl0hW7g3TYBxSFn
	 2wFHtFZNOpK8v02lC/+On82D2c5fupmqYuj/h8El44ITvi1p+Fq7pxYqiHXjFwUen3
	 qxAuqzhcjBmA+Hgc/NNycrMpcw4uE/+Pl3gzApotjWc1vsnjN06cdW94zGjJ4AHAph
	 Nn+mYtJvKMC2PxJTfFDkxhqCr9RBli59bZnJpmuwYMEq9HYtaY5hR1qqrRmB7ciD6h
	 2moIW5sGkZntXPjhfM3C4r4WkR+HANHoHFunzN9uxqQR/rmJYTWC3nWd4RW9BC4Q8M
	 pQ8bzsDsDpVXQ==
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
Subject: [PATCH AUTOSEL 6.2 45/53] Bluetooth: Add new quirk for broken local ext features page 2
Date: Thu,  4 May 2023 15:44:05 -0400
Message-Id: <20230504194413.3806354-45-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504194413.3806354-1-sashal@kernel.org>
References: <20230504194413.3806354-1-sashal@kernel.org>
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
index 8d773b042c853..7127313140cf0 100644
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


