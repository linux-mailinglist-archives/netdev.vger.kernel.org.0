Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB9229AB23
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 12:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2899578AbgJ0Ltc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 07:49:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56697 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2899552AbgJ0Lta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 07:49:30 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kXNTi-00027k-1Z; Tue, 27 Oct 2020 11:49:26 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: atm: fix update of position index in lec_seq_next
Date:   Tue, 27 Oct 2020 11:49:25 +0000
Message-Id: <20201027114925.21843-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The position index in leq_seq_next is not updated when the next
entry is fetched an no more entries are available. This causes
seq_file to report the following error:

"seq_file: buggy .next function lec_seq_next [lec] did not update
 position index"

Fix this by always updating the position index.

[ Note: this is an ancient 2002 bug, the sha is from the
  tglx/history repo ]

Fixes 4aea2cbff417 ("[ATM]: Move lan seq_file ops to lec.c [1/3]")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/atm/lec.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/atm/lec.c b/net/atm/lec.c
index dbabb65d8b67..7226c784dbe0 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -954,9 +954,8 @@ static void *lec_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	struct lec_state *state = seq->private;
 
-	v = lec_get_idx(state, 1);
-	*pos += !!PTR_ERR(v);
-	return v;
+	++*pos;
+	return lec_get_idx(state, 1);
 }
 
 static int lec_seq_show(struct seq_file *seq, void *v)
-- 
2.27.0

