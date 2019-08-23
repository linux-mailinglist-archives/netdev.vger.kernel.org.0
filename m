Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65EA89A91E
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 09:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390967AbfHWHtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 03:49:51 -0400
Received: from mail5.windriver.com ([192.103.53.11]:52824 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390903AbfHWHtv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 03:49:51 -0400
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail5.wrs.com (8.15.2/8.15.2) with ESMTPS id x7N7lHxn011155
        (version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL);
        Fri, 23 Aug 2019 00:47:53 -0700
Received: from pek-xsun-d1.wrs.com (128.224.162.163) by
 ALA-HCA.corp.ad.wrs.com (147.11.189.50) with Microsoft SMTP Server id
 14.3.468.0; Fri, 23 Aug 2019 00:47:13 -0700
From:   Xulin Sun <xulin.sun@windriver.com>
To:     <kvalo@codeaurora.org>
CC:     <stefan.wahren@i2se.com>, <xulin.sun@windriver.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <brcm80211-dev-list@cypress.com>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <linux-wireless@vger.kernel.org>, <arend.vanspriel@broadcom.com>,
        <franky.lin@broadcom.com>, <hante.meuleman@broadcom.com>,
        <chi-hsien.lin@cypress.com>, <wright.feng@cypress.com>,
        <davem@davemloft.net>, <stanley.hsu@cypress.com>
Subject: [PATCH] brcmfmac: replace strncpy() by strscpy()
Date:   Fri, 23 Aug 2019 15:47:08 +0800
Message-ID: <20190823074708.20081-1-xulin.sun@windriver.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The strncpy() may truncate the copied string,
replace it by the safer strscpy().

To avoid below compile warning with gcc 8.2:

drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:In function 'brcmf_vndr_ie':
drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:4227:2:
warning: 'strncpy' output truncated before terminating nul copying 3 bytes from a string of the same length [-Wstringop-truncation]
  strncpy(iebuf, add_del_cmd, VNDR_IE_CMD_LEN - 1);
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Xulin Sun <xulin.sun@windriver.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index b6d0df354b36..7ad60374fa96 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -4226,9 +4226,7 @@ brcmf_parse_vndr_ies(const u8 *vndr_ie_buf, u32 vndr_ie_len,
 static u32
 brcmf_vndr_ie(u8 *iebuf, s32 pktflag, u8 *ie_ptr, u32 ie_len, s8 *add_del_cmd)
 {
-
-	strncpy(iebuf, add_del_cmd, VNDR_IE_CMD_LEN - 1);
-	iebuf[VNDR_IE_CMD_LEN - 1] = '\0';
+	strscpy(iebuf, add_del_cmd, VNDR_IE_CMD_LEN);
 
 	put_unaligned_le32(1, &iebuf[VNDR_IE_COUNT_OFFSET]);
 
-- 
2.17.1

