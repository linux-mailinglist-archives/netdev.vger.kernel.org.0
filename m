Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C21F16B782
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 03:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbgBYCFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 21:05:47 -0500
Received: from gateway21.websitewelcome.com ([192.185.45.38]:43301 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726962AbgBYCFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 21:05:46 -0500
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 50BD7400C55A1
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 20:05:46 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 6PbWjdRLC8vkB6PbWjYu9R; Mon, 24 Feb 2020 20:05:46 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3WYY4D95dFsGR6aMI/L2pR572DKPC2ZtgZvA51FyZmc=; b=SDfjbEqUWa5eyJtudos2VU69K3
        slC/oG4O9+M6lqicfB/Ypvnl9pHtHkvcPAIjDbTrwGhc8GHF4Au8ftHWr+66MZVLJVQ7dZ0OsGH1Z
        9Sucy77xWuZhLOkv/4ujdkydQ1ibfudhitglXMVtz1bJoWHMjxniLqb9N2jd5UPyR8eJRymHlK8tX
        4RZghqUUz+K6pn6HbGp6HZAQQf85GBWGNLEbaF6n0Ny1YItVZmR0769hFHowRnXBb3oLJFXbxGYVN
        o/70KaI/Ig0ILP2MtfxHPPJml1+3We6thtdY1fFwKJch3vb1g90h7wwsGjfOgCVaisGZQnWeL3pvS
        ZtP5SOxQ==;
Received: from [201.166.191.97] (port=60674 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j6PbT-003Hcz-Ke; Mon, 24 Feb 2020 20:05:44 -0600
Date:   Mon, 24 Feb 2020 20:08:04 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] brcmfmac: Replace zero-length array with
 flexible-array member
Message-ID: <20200225020804.GA9428@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 201.166.191.97
X-Source-L: No
X-Exim-ID: 1j6PbT-003Hcz-Ke
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.166.191.97]:60674
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 20
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
index 3347439543bb..46c66415b4a6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
@@ -60,7 +60,7 @@ struct brcmf_fw_request {
 	u16 bus_nr;
 	u32 n_items;
 	const char *board_type;
-	struct brcmf_fw_item items[0];
+	struct brcmf_fw_item items[];
 };
 
 struct brcmf_fw_name {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
index 79c8a858b6d6..a5cced2c89ac 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
@@ -32,7 +32,7 @@ struct brcmf_fweh_queue_item {
 	u8 ifaddr[ETH_ALEN];
 	struct brcmf_event_msg_be emsg;
 	u32 datalen;
-	u8 data[0];
+	u8 data[];
 };
 
 /**
-- 
2.25.0

