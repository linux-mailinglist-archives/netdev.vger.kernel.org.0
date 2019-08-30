Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27ACCA2C29
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 03:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbfH3BMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 21:12:20 -0400
Received: from gateway22.websitewelcome.com ([192.185.46.234]:47559 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727938AbfH3BMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 21:12:14 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 1CB75726F
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 20:12:13 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 3VSXiYKZu90on3VSXiK8Ue; Thu, 29 Aug 2019 20:12:13 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VTOOgjyJtQhQpU+6Umy1FeKBLztwuppbHPl7xEc0pLg=; b=kSF6EZJBtijHZHJOxCRXSqFXMQ
        rw1497KhcwcHpz/079SGvB1oLDCkEWwfNw4L9x7W6L+8DkSgu54hxeTFO0gWuIltTWIK+/gQvRYxw
        KbEC1OBXv0ccuOtSQzOgS7ufNpjPsvnEA9X4iGgobxL9MK5wh1bMFlGxO7nO3MAJZsTvSc5HTk74x
        xfZSnPdvwVJ6gOwKkxgtYkVLq0yxHKX9+ycjySZb5kh7lCiOPEJZ/1CRhOk/06rYeG6RMhauloED9
        cLt6uvCwTfT5Zyl1sz2/zpTp79ir/tvYykMYI2VQWoM15gZsjPnFXtRXQQYA7kDrSHYStDJhDAr6c
        aGTrHCjQ==;
Received: from [189.152.216.116] (port=50230 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1i3VSV-000hFw-WB; Thu, 29 Aug 2019 20:12:12 -0500
Date:   Thu, 29 Aug 2019 20:12:11 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] Bluetooth: mgmt: Use struct_size() helper
Message-ID: <20190830011211.GA26531@embeddedor>
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
X-Source-IP: 189.152.216.116
X-Source-L: No
X-Exim-ID: 1i3VSV-000hFw-WB
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.152.216.116]:50230
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 5
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One of the more common cases of allocation size calculations is finding
the size of a structure that has a zero-sized array at the end, along
with memory for some number of elements for that array. For example:

struct mgmt_rp_get_connections {
	...
        struct mgmt_addr_info addr[0];
} __packed;

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes.

So, replace the following form:

sizeof(*rp) + (i * sizeof(struct mgmt_addr_info));

with:

struct_size(rp, addr, i)

Also, notice that, in this case, variable rp_len is not necessary,
hence it is removed.

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 net/bluetooth/mgmt.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 150114e33b20..acb7c6d5643f 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2588,7 +2588,6 @@ static int get_connections(struct sock *sk, struct hci_dev *hdev, void *data,
 {
 	struct mgmt_rp_get_connections *rp;
 	struct hci_conn *c;
-	size_t rp_len;
 	int err;
 	u16 i;
 
@@ -2608,8 +2607,7 @@ static int get_connections(struct sock *sk, struct hci_dev *hdev, void *data,
 			i++;
 	}
 
-	rp_len = sizeof(*rp) + (i * sizeof(struct mgmt_addr_info));
-	rp = kmalloc(rp_len, GFP_KERNEL);
+	rp = kmalloc(struct_size(rp, addr, i), GFP_KERNEL);
 	if (!rp) {
 		err = -ENOMEM;
 		goto unlock;
@@ -2629,10 +2627,8 @@ static int get_connections(struct sock *sk, struct hci_dev *hdev, void *data,
 	rp->conn_count = cpu_to_le16(i);
 
 	/* Recalculate length in case of filtered SCO connections, etc */
-	rp_len = sizeof(*rp) + (i * sizeof(struct mgmt_addr_info));
-
 	err = mgmt_cmd_complete(sk, hdev->id, MGMT_OP_GET_CONNECTIONS, 0, rp,
-				rp_len);
+				struct_size(rp, addr, i));
 
 	kfree(rp);
 
-- 
2.23.0

