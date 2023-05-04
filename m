Return-Path: <netdev+bounces-420-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C84AA6F7697
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 22:09:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1C131C20FD4
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:09:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B8C417AC9;
	Thu,  4 May 2023 19:49:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AA817AAC
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3B8C433D2;
	Thu,  4 May 2023 19:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229758;
	bh=GzsQRfsE5Tf/T01QSfgecZr2g5ogs3DyiqBuvofo/1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nc1ENCnTU5Zr4TXl5ZGasc/RXGC22JyRtKyXmeZf9Jjb3JCp8wnRt7V75q+RIqW1V
	 YhUAAfys1VJKBGjZCFNEZiLkcXHuwvO/lSmRzIpwYq9mfrrQXZwfRffPLNj7DBe+1h
	 zKnS2wd0c2EYLBGi4UwNBe10ULL1tRbo6ixqPe0jDeQz1ui9IJou1CuuYTm2Kn6Fj5
	 I1dHJF7HQFQCJZCUiqWGPwqqe1DEJM2Q4lmFPA8SpVrioRoGuIglXOXhRSU6Wot7vr
	 dwrwODqEQDDgDyeWaLKXiV5uQKlP3gz1Tr7vbOKvltHtCbvGw2FSXh7oR/9CiniWLA
	 G0AIp26RgdlKg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Hyunwoo Kim <imv4bel@gmail.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	kvalo@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	avraham.stern@intel.com,
	emmanuel.grumbach@intel.com,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 22/30] wifi: iwlwifi: pcie: Fix integer overflow in iwl_write_to_user_buf
Date: Thu,  4 May 2023 15:48:15 -0400
Message-Id: <20230504194824.3808028-22-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504194824.3808028-1-sashal@kernel.org>
References: <20230504194824.3808028-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit 58d1b717879bfeabe09b35e41ad667c79933eb2e ]

An integer overflow occurs in the iwl_write_to_user_buf() function,
which is called by the iwl_dbgfs_monitor_data_read() function.

static bool iwl_write_to_user_buf(char __user *user_buf, ssize_t count,
				  void *buf, ssize_t *size,
				  ssize_t *bytes_copied)
{
	int buf_size_left = count - *bytes_copied;

	buf_size_left = buf_size_left - (buf_size_left % sizeof(u32));
	if (*size > buf_size_left)
		*size = buf_size_left;

If the user passes a SIZE_MAX value to the "ssize_t count" parameter,
the ssize_t count parameter is assigned to "int buf_size_left".
Then compare "*size" with "buf_size_left" . Here, "buf_size_left" is a
negative number, so "*size" is assigned "buf_size_left" and goes into
the third argument of the copy_to_user function, causing a heap overflow.

This is not a security vulnerability because iwl_dbgfs_monitor_data_read()
is a debugfs operation with 0400 privileges.

Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230414130637.2d80ace81532.Iecfba549e0e0be21bbb0324675392e42e75bd5ad@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 02da9cc8646cf..3a6b25997dfcc 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2777,7 +2777,7 @@ static bool iwl_write_to_user_buf(char __user *user_buf, ssize_t count,
 				  void *buf, ssize_t *size,
 				  ssize_t *bytes_copied)
 {
-	int buf_size_left = count - *bytes_copied;
+	ssize_t buf_size_left = count - *bytes_copied;
 
 	buf_size_left = buf_size_left - (buf_size_left % sizeof(u32));
 	if (*size > buf_size_left)
-- 
2.39.2


