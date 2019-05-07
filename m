Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A060215A8E
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfEGFqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729270AbfEGFlU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:41:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9948205ED;
        Tue,  7 May 2019 05:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207679;
        bh=kxTii2ZzhW44xrLVe3drDnbmjm4vKaWPoTd0ghA4gcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ohWh8aVwnJFy8J1pMkr0C0yYOA52Myu9kEYPE8vCm9HshYWBO1gmdAzpcuhJvWMIm
         RtIDGOY1fzaJ5ji3IKAIXkfFKCYLBcjOJpSn871j0TQNtnNLsgvwkvMi6Z0bhAw6WH
         vAyQxnOZTdjSUTHBe2pQ7rhu3ymXbelQew7LSR0A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <alexander.levin@microsoft.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 94/95] nfc: nci: Potential off by one in ->pipes[] array
Date:   Tue,  7 May 2019 01:38:23 -0400
Message-Id: <20190507053826.31622-94-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 6491d698396fd5da4941980a35ca7c162a672016 ]

This is similar to commit e285d5bfb7e9 ("NFC: Fix the number of pipes")
where we changed NFC_HCI_MAX_PIPES from 127 to 128.

As the comment next to the define explains, the pipe identifier is 7
bits long.  The highest possible pipe is 127, but the number of possible
pipes is 128.  As the code is now, then there is potential for an
out of bounds array access:

    net/nfc/nci/hci.c:297 nci_hci_cmd_received() warn: array off by one?
    'ndev->hci_dev->pipes[pipe]' '0-127 == 127'

Fixes: 11f54f228643 ("NFC: nci: Add HCI over NCI protocol support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 include/net/nfc/nci_core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index 87499b6b35d6..df5c69db68af 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -166,7 +166,7 @@ struct nci_conn_info {
  * According to specification 102 622 chapter 4.4 Pipes,
  * the pipe identifier is 7 bits long.
  */
-#define NCI_HCI_MAX_PIPES          127
+#define NCI_HCI_MAX_PIPES          128
 
 struct nci_hci_gate {
 	u8 gate;
-- 
2.20.1

