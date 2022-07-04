Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4D6565C27
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 18:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbiGDQcR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 4 Jul 2022 12:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234456AbiGDQcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 12:32:16 -0400
Received: from relay5.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025716474
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 09:32:12 -0700 (PDT)
Received: from omf12.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay12.hostedemail.com (Postfix) with ESMTP id 6E8A2120797;
        Mon,  4 Jul 2022 16:32:11 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf12.hostedemail.com (Postfix) with ESMTPA id AE74A22;
        Mon,  4 Jul 2022 16:32:07 +0000 (UTC)
Message-ID: <c3755af8c14da95ff9cf45f94da7648f3e58e8ae.camel@perches.com>
Subject: Re: [PATCH] ath9k: Use swap() instead of open coding it
From:   Joe Perches <joe@perches.com>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Tan Zhongjun <tanzhongjun@coolpad.com>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 04 Jul 2022 09:32:06 -0700
In-Reply-To: <87fsjh7wr0.fsf@toke.dk>
References: <20220704133205.1294-1-tanzhongjun@coolpad.com>
         <87fsjh7wr0.fsf@toke.dk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Stat-Signature: 3exa774zdqaki9p6dsbfb751hjgarhsc
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: AE74A22
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+DN+AboRQ96eNMmaarZviJ/PQ+xmpWzbU=
X-HE-Tag: 1656952327-399038
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-07-04 at 16:55 +0200, Toke Høiland-Jørgensen wrote:
> "Tan Zhongjun" <tanzhongjun@coolpad.com> writes:
> 
> > Use swap() instead of open coding it
> > 
> > Signed-off-by: Tan Zhongjun <tanzhongjun@coolpad.com>
> 
> Please don't send HTML email, the mailing lists will drop that. Also, an
> identical patch was submitted back in February and an issue was pointed
> out which your patch also suffers from:
> 
> https://lore.kernel.org/r/a2400dd73f6ea8672bb6e50124cc3041c0c43d6d.1644838854.git.yang.guang5@zte.com.cn

Perhaps instead use sort instead of a bubble sort.

Something like:
---
 drivers/net/wireless/ath/ath9k/calib.c | 35 ++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 0422a33395b77..4e298925049e8 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -17,29 +17,32 @@
 #include "hw.h"
 #include "hw-ops.h"
 #include <linux/export.h>
+#include <linux/sort.h>
 
 /* Common calibration code */
 
+static int cmp_int16_t(const void *a, const void *b)
+{
+	int16_t a1 = *(int16_t *)a;
+	int16_t b1 = *(int16_t *)b;
+
+	if (a1 < b1)
+		return -1;
+	if (a1 > b1)
+		return 1;
+	return 0;
+}
 
 static int16_t ath9k_hw_get_nf_hist_mid(int16_t *nfCalBuffer)
 {
 	int16_t nfval;
-	int16_t sort[ATH9K_NF_CAL_HIST_MAX];
-	int i, j;
-
-	for (i = 0; i < ATH9K_NF_CAL_HIST_MAX; i++)
-		sort[i] = nfCalBuffer[i];
-
-	for (i = 0; i < ATH9K_NF_CAL_HIST_MAX - 1; i++) {
-		for (j = 1; j < ATH9K_NF_CAL_HIST_MAX - i; j++) {
-			if (sort[j] > sort[j - 1]) {
-				nfval = sort[j];
-				sort[j] = sort[j - 1];
-				sort[j - 1] = nfval;
-			}
-		}
-	}
-	nfval = sort[(ATH9K_NF_CAL_HIST_MAX - 1) >> 1];
+	int16_t sorted[ATH9K_NF_CAL_HIST_MAX];
+
+	memcpy(sorted, nfCalBuffer, sizeof(int16_t) * ATH9K_NF_CAL_HIST_MAX);
+
+	sort(sorted, ARRAY_SIZE(sorted), sizeof(int16_t), cmp_int16_t, NULL);
+
+	nfval = sorted[(ATH9K_NF_CAL_HIST_MAX - 1) >> 1];
 
 	return nfval;
 }

