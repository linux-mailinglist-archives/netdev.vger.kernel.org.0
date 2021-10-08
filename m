Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D90484260FF
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 02:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241804AbhJHARz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 20:17:55 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:33332
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231335AbhJHARy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 20:17:54 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id D3D4E3FFDC;
        Fri,  8 Oct 2021 00:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633652158;
        bh=0n1NxMFLwaoPUaYk1VR+sLZ7l5MfCty7ar8jrz3earo=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=rWc8yUN2RhedM/vx8+NfE09Ptc41kcpPOKXpvOSnuU8QoXWdV4MM+3yTBoUt4J2kq
         +HIp7lXhm07F5qci6KRUqnfB2ydO15bKXV9QZl8wUa4emKpcC3MoTyaVxjrVZa39sV
         +5J2Ylp0TyLndjVebGZS8C+mSSlCFyz6EBjQxOrvd2ngoICqdMfv7UCebfZW1ZaRD+
         n5opm4g14C8krFn2i/XDDUNoPyUFE3D3VHeOpw2QBj/lDpXuEWMXZl6azXS1SU5ncu
         GVheQFUdMy9Madm2nk3v0fmTFrrv5sf3B5EfiIgzI0PX9dQhaXfbt0lEpD8AdQEHN/
         i+6Tej+mPnG6Q==
From:   Colin King <colin.king@canonical.com>
To:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John W . Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] carl9170: Fix error return -EAGAIN if not started
Date:   Fri,  8 Oct 2021 01:15:58 +0100
Message-Id: <20211008001558.32416-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is an error return path where the error return is being
assigned to err rather than count and the error exit path does
not return -EAGAIN as expected. Fix this by setting the error
return to variable count as this is the value that is returned
at the end of the function.

Addresses-Coverity: ("Unused value")
Fixes: 00c4da27a421 ("carl9170: firmware parser and debugfs code")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/carl9170/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/debug.c b/drivers/net/wireless/ath/carl9170/debug.c
index bb40889d7c72..f163c6bdac8f 100644
--- a/drivers/net/wireless/ath/carl9170/debug.c
+++ b/drivers/net/wireless/ath/carl9170/debug.c
@@ -628,7 +628,7 @@ static ssize_t carl9170_debugfs_bug_write(struct ar9170 *ar, const char *buf,
 
 	case 'R':
 		if (!IS_STARTED(ar)) {
-			err = -EAGAIN;
+			count = -EAGAIN;
 			goto out;
 		}
 
-- 
2.32.0

