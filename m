Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 964271C948D
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 17:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgEGPNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 11:13:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727945AbgEGPNe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 11:13:34 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42AF420936;
        Thu,  7 May 2020 15:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588864413;
        bh=GTM2+eUOtQwa+GzRb1C4IYjJnbBggbNRXgYQGHV5x9A=;
        h=Date:From:To:Cc:Subject:From;
        b=y3WWJF3pJSf1WcaUBDe37+/p02rqqfNAnvOmXlDx0p1T9syX7iGkiuC5STccIAiPn
         wbj/8lguQ9yaPDCwmud1DJyW1vPnBqGDeO7MA2Rk/nqe1uvMMWgXf2IAbZJjB5jJgD
         0ZkSonIJUv+yDvHwaOaYErDLKF/Unjt6pZuHDeMU=
Date:   Thu, 7 May 2020 10:17:58 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Cc:     wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] wcn36xx: Replace zero-length array with flexible-array
Message-ID: <20200507151758.GA4962@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
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

sizeof(flexible-array-member) triggers a warning because flexible array
members have incomplete type[1]. There are some instances of code in
which the sizeof operator is being incorrectly/erroneously applied to
zero-length arrays and the result is zero. Such instances may be hiding
some bugs. So, this work (flexible-array member conversions) will also
help to get completely rid of those sorts of issues.

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/hal.h      | 4 ++--
 drivers/net/wireless/ath/wcn36xx/testmode.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
index 6ba0fd57c951..aab5a58616fc 100644
--- a/drivers/net/wireless/ath/wcn36xx/hal.h
+++ b/drivers/net/wireless/ath/wcn36xx/hal.h
@@ -2240,7 +2240,7 @@ struct wcn36xx_hal_process_ptt_msg_req_msg {
 	struct wcn36xx_hal_msg_header header;
 
 	/* Actual FTM Command body */
-	u8 ptt_msg[0];
+	u8 ptt_msg[];
 } __packed;
 
 struct wcn36xx_hal_process_ptt_msg_rsp_msg {
@@ -2249,7 +2249,7 @@ struct wcn36xx_hal_process_ptt_msg_rsp_msg {
 	/* FTM Command response status */
 	u32 ptt_msg_resp_status;
 	/* Actual FTM Command body */
-	u8 ptt_msg[0];
+	u8 ptt_msg[];
 } __packed;
 
 struct update_edca_params_req_msg {
diff --git a/drivers/net/wireless/ath/wcn36xx/testmode.h b/drivers/net/wireless/ath/wcn36xx/testmode.h
index 4c6cfdb46580..09d68fab9add 100644
--- a/drivers/net/wireless/ath/wcn36xx/testmode.h
+++ b/drivers/net/wireless/ath/wcn36xx/testmode.h
@@ -20,7 +20,7 @@ struct ftm_rsp_msg {
 	u16 msg_id;
 	u16 msg_body_length;
 	u32 resp_status;
-	u8 msg_response[0];
+	u8 msg_response[];
 } __packed;
 
 /* The request buffer of FTM which contains a byte of command and the request */
-- 
2.26.2

