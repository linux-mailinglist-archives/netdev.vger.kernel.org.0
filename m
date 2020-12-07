Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A51712D13F1
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 15:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgLGOqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 09:46:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:37219 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgLGOqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 09:46:06 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kmHl9-0004iu-HP; Mon, 07 Dec 2020 14:45:03 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrea Mayer <andrea.mayer@uniroma2.it>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] seg6: fix unintentional integer overflow on left shift
Date:   Mon,  7 Dec 2020 14:45:03 +0000
Message-Id: <20201207144503.169679-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Shifting the integer value 1 is evaluated using 32-bit arithmetic
and then used in an expression that expects a unsigned long value
leads to a potential integer overflow. Fix this by using the BIT
macro to perform the shift to avoid the overflow.

Addresses-Coverity: ("Uninitentional integer overflow")
Fixes: 964adce526a4 ("seg6: improve management of behavior attributes")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/ipv6/seg6_local.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index b07f7c1c82a4..d68de8cd1207 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -1366,7 +1366,7 @@ static void __destroy_attrs(unsigned long parsed_attrs, int max_parsed,
 	 * attribute; otherwise, we call the destroy() callback.
 	 */
 	for (i = 0; i < max_parsed; ++i) {
-		if (!(parsed_attrs & (1 << i)))
+		if (!(parsed_attrs & BIT(i)))
 			continue;
 
 		param = &seg6_action_params[i];
-- 
2.29.2

