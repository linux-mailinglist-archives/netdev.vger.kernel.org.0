Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C7633E989
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 07:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhCQGKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 02:10:50 -0400
Received: from m12-11.163.com ([220.181.12.11]:42451 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230014AbhCQGKo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 02:10:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=AULiu
        rs4YjStSWptxVN159c8g3BSq/8ES1Yp+KInKUc=; b=W9mh2oxHiSK7/TrssMukF
        l9hWYDyWK+wF5HVI3ENlfqf3xblXWLFnHT+NREQlKsdvXAlG5wIPWZanTXlVd5c4
        9ZUL//N4NAdVosP0z2u67Fd6lelo+gjf4MdSWYRZPbB/zo5G2TFlbjtvwWufSCI8
        6r4tLp8ooMnooZXq+nYPK4=
Received: from COOL-20201210PM.ccdomain.com (unknown [218.94.48.178])
        by smtp7 (Coremail) with SMTP id C8CowABXXUUpnVFgjbvKSg--.5830S2;
        Wed, 17 Mar 2021 14:09:50 +0800 (CST)
From:   zuoqilin1@163.com
To:     amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, zuoqilin <zuoqilin@yulong.com>
Subject: [PATCH] mwifiex: Remove redundant assignment
Date:   Wed, 17 Mar 2021 14:09:56 +0800
Message-Id: <20210317060956.1009-1-zuoqilin1@163.com>
X-Mailer: git-send-email 2.28.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: C8CowABXXUUpnVFgjbvKSg--.5830S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJr45Gw4xtr48KFWkKFyDJrb_yoW8uryfpF
        s8W34vyw4rJF1kCws8AF1xAFW5K3WxKFy29F1rt34Skws29F93XF4UKryF9r4xKrs7Zry5
        ArW0q3W5A34kJFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jcOz3UUUUU=
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 52xr1xpolqiqqrwthudrp/xtbBRQ1YiVPAKjBU8QABs0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zuoqilin <zuoqilin@yulong.com>

There is no need to define the err variable,
and then assign -EINVAL, we can directly return -EINVAL.

Signed-off-by: zuoqilin <zuoqilin@yulong.com>
---
 drivers/net/wireless/marvell/mwifiex/ie.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/ie.c b/drivers/net/wireless/marvell/mwifiex/ie.c
index 40e99ea..c88213c 100644
--- a/drivers/net/wireless/marvell/mwifiex/ie.c
+++ b/drivers/net/wireless/marvell/mwifiex/ie.c
@@ -333,7 +333,6 @@ static int mwifiex_uap_parse_tail_ies(struct mwifiex_private *priv,
 	u16 gen_idx = MWIFIEX_AUTO_IDX_MASK, ie_len = 0;
 	int left_len, parsed_len = 0;
 	unsigned int token_len;
-	int err = 0;
 
 	if (!info->tail || !info->tail_len)
 		return 0;
@@ -351,7 +350,6 @@ static int mwifiex_uap_parse_tail_ies(struct mwifiex_private *priv,
 		hdr = (void *)(info->tail + parsed_len);
 		token_len = hdr->len + sizeof(struct ieee_types_header);
 		if (token_len > left_len) {
-			err = -EINVAL;
 			goto out;
 		}
 
@@ -377,7 +375,6 @@ static int mwifiex_uap_parse_tail_ies(struct mwifiex_private *priv,
 			fallthrough;
 		default:
 			if (ie_len + token_len > IEEE_MAX_IE_SIZE) {
-				err = -EINVAL;
 				goto out;
 			}
 			memcpy(gen_ie->ie_buffer + ie_len, hdr, token_len);
@@ -397,7 +394,6 @@ static int mwifiex_uap_parse_tail_ies(struct mwifiex_private *priv,
 	if (vendorhdr) {
 		token_len = vendorhdr->len + sizeof(struct ieee_types_header);
 		if (ie_len + token_len > IEEE_MAX_IE_SIZE) {
-			err = -EINVAL;
 			goto out;
 		}
 		memcpy(gen_ie->ie_buffer + ie_len, vendorhdr, token_len);
@@ -415,7 +411,6 @@ static int mwifiex_uap_parse_tail_ies(struct mwifiex_private *priv,
 
 	if (mwifiex_update_uap_custom_ie(priv, gen_ie, &gen_idx, NULL, NULL,
 					 NULL, NULL)) {
-		err = -EINVAL;
 		goto out;
 	}
 
@@ -423,7 +418,7 @@ static int mwifiex_uap_parse_tail_ies(struct mwifiex_private *priv,
 
  out:
 	kfree(gen_ie);
-	return err;
+	return -EINVAL;
 }
 
 /* This function parses different IEs-head & tail IEs, beacon IEs,
-- 
1.9.1

