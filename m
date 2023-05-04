Return-Path: <netdev+bounces-357-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 932466F73FE
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 21:47:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0D0D1C213D8
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:47:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C6B8C15D;
	Thu,  4 May 2023 19:43:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E5CC143
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83467C433A0;
	Thu,  4 May 2023 19:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229404;
	bh=1O3F3/9pYsjTL7/GnQJz4fXY0qr6PpzLAgIvLnj7u/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DydjtWwYdmPH1iif7LVAmXwRJqvbnqHtaxgjOOqPLvaQm5xMdONOiSHa4zm1WnOr9
	 9HtDcETMzv9B0kXXVYGxtgRVSkL+cTBbPx9jYazOA9166mr+GXSUF/bxgCYrEgm2iK
	 74sfYQ/gkQkC8spg7tZWoHCvuRjWzklTRMj4Mw8q7htiMchuzs2exDxLAmd90zCaZJ
	 WFBXobitr4JKUiECBCTE1uOytX/XQOX8bCh9MRrT1V2wW0BnYidGqrZWMEMhFgXrSW
	 N3aZBZ51Y5i7+1LZ/Vw/QXFWJXp+Fi4qNFe9jTjfn+XubYg7K6m9BWLpcXa8wCiGKp
	 boaCrEHBF0jRQ==
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
Subject: [PATCH AUTOSEL 6.3 37/59] wifi: iwlwifi: pcie: Fix integer overflow in iwl_write_to_user_buf
Date: Thu,  4 May 2023 15:41:20 -0400
Message-Id: <20230504194142.3805425-37-sashal@kernel.org>
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
index 0a9af1ad1f206..6d5d0d40477a6 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2863,7 +2863,7 @@ static bool iwl_write_to_user_buf(char __user *user_buf, ssize_t count,
 				  void *buf, ssize_t *size,
 				  ssize_t *bytes_copied)
 {
-	int buf_size_left = count - *bytes_copied;
+	ssize_t buf_size_left = count - *bytes_copied;
 
 	buf_size_left = buf_size_left - (buf_size_left % sizeof(u32));
 	if (*size > buf_size_left)
-- 
2.39.2


