Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64F8519B8EC
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 01:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733241AbgDAX1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 19:27:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48608 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732503AbgDAX1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 19:27:40 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jJmlk-0007s0-IS; Wed, 01 Apr 2020 23:27:36 +0000
From:   Colin King <colin.king@canonical.com>
To:     Igor Russkikh <irusskikh@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: atlantic: fix missing | operator when assigning rec->llc
Date:   Thu,  2 Apr 2020 00:27:36 +0100
Message-Id: <20200401232736.410028-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

rec->llc is currently being assigned twice, once with the lower 8 bits
from packed_record[8] and then re-assigned afterwards with data from
packed_record[9].  This looks like a type, I believe the second assignment
should be using the |= operator rather than a direct assignment.

Addresses-Coverity: ("Unused value")
Fixes: b8f8a0b7b5cb ("net: atlantic: MACSec ingress offload HW bindings")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
index 97901c114bfa..fbe9d88b13c7 100644
--- a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
+++ b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
@@ -491,7 +491,7 @@ get_ingress_preclass_record(struct aq_hw_s *hw,
 	rec->snap[1] = packed_record[8] & 0xFF;
 
 	rec->llc = (packed_record[8] >> 8) & 0xFF;
-	rec->llc = packed_record[9] << 8;
+	rec->llc |= packed_record[9] << 8;
 
 	rec->mac_sa[0] = packed_record[10];
 	rec->mac_sa[0] |= packed_record[11] << 16;
-- 
2.25.1

