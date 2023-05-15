Return-Path: <netdev+bounces-2758-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A8FB703DAA
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 21:24:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F3C41C20506
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 19:24:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 910F619503;
	Mon, 15 May 2023 19:24:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4CA101E6
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 19:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8A6C433D2;
	Mon, 15 May 2023 19:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684178646;
	bh=q0fr9L7z3JD2gn3NXYVjkph6/iEcTo88CXHUvYj1KB8=;
	h=Date:From:To:Cc:Subject:From;
	b=A5CiJtDIEzB0JjF6pW+io36+Hwt4X4BHAvnJK56vtYydPVlK3AUoHIuStNvfJwUTg
	 bHD3yARQzu8ZdedRKcM+Xd686MEV2fWZdLQdXNO94vBUfBdvgisr3ngAC4B77lXWvZ
	 LfZb59zjgddNNSWvSHynNGVk1k3NG+jLoLo8jg6RotdJqB3o+NxCAPurCuD/bTQ7VX
	 MtvUxG8LqTo5LY+GTb3pqjh/McCD8L69q0h04+Xou509N5uJTYG+sJfcaU5uDFVGzr
	 oXKr8IS2/qXwy28Fuj5R/PsvQATqccUnNVxvw4DaaDQfgRSsuDBAO7ovBFKB+4uNDs
	 24InHsAU8zB0g==
Date: Mon, 15 May 2023 13:24:55 -0600
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Kalle Valo <kvalo@kernel.org>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH][next] wifi: wil6210: fw: Replace zero-length arrays with
 DECLARE_FLEX_ARRAY() helper
Message-ID: <ZGKHByxujJoygK+l@work>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Zero-length arrays are deprecated, and we are moving towards adopting
C99 flexible-array members, instead. So, replace zero-length arrays
declarations alone in structs with the new DECLARE_FLEX_ARRAY()
helper macro.

This helper allows for flexible-array members alone in structs.

Link: https://github.com/KSPP/linux/issues/193
Link: https://github.com/KSPP/linux/issues/287
Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/ath/wil6210/fw.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/fw.h b/drivers/net/wireless/ath/wil6210/fw.h
index 440614d61156..aa1620e0d24f 100644
--- a/drivers/net/wireless/ath/wil6210/fw.h
+++ b/drivers/net/wireless/ath/wil6210/fw.h
@@ -47,7 +47,7 @@ struct wil_fw_record_fill { /* type == wil_fw_type_fill */
  * for informational purpose, data_size is @head.size from record header
  */
 struct wil_fw_record_comment { /* type == wil_fw_type_comment */
-	u8 data[0]; /* free-form data [data_size], see above */
+	DECLARE_FLEX_ARRAY(u8, data); /* free-form data [data_size], see above */
 } __packed;
 
 /* Comment header - common for all comment record types */
@@ -131,7 +131,7 @@ struct wil_fw_data_dwrite {
  * data_size is @head.size where @head is record header
  */
 struct wil_fw_record_direct_write { /* type == wil_fw_type_direct_write */
-	struct wil_fw_data_dwrite data[0];
+	DECLARE_FLEX_ARRAY(struct wil_fw_data_dwrite, data);
 } __packed;
 
 /* verify condition: [@addr] & @mask == @value
-- 
2.34.1


