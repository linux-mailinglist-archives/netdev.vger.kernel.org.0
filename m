Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618571CB881
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 21:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgEHTl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 15:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726797AbgEHTl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 15:41:58 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5C4C061A0C;
        Fri,  8 May 2020 12:41:58 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id t3so2431743otp.3;
        Fri, 08 May 2020 12:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SF7w4IVLXKR2MN5g9z0w/WoW8pEbm4v0BnCRIDC/Omw=;
        b=MMlHVCrYNt8/FKkH14O8Mb8KKWNzpOvTnGtPi/pg2/d55abXEK6K4BXYx+JWYaZIKn
         21dr3qgLJVft+JV0agpkwz7lZ6dIFf3J9LpBh6eIoBX3pHizf3mhCyCbXDIO+Sgftyfm
         NfKv5YPTThpuZepy1mg0MHUaZcwfZ9wodBmM0aOCi7Lmyw3xsLUAmdvblehzjAcSv73O
         oXndWT72ezLE3WpSSFnaIn2kLAm0dlMnnVgV2NhpRIHBE0deEVE9C7nJKqKZJjN9JyPg
         tPFTLsXGbEkRln1K8htoYEDJZafzmCBwlU3NvVWnd87CW65C5cq4yQxP8PD338+8GM4e
         /8wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SF7w4IVLXKR2MN5g9z0w/WoW8pEbm4v0BnCRIDC/Omw=;
        b=o2kmuaNCqIh8qU/E86CiMmc+m++pbqMcc0k4pjqRY7+X3PKwfvgyO9PEEqj3r+8H4V
         iyqwjHX/sK8U370xYMD8Cb7IEhZSVKWzXPcrvMs/+LWj+kOOoVuX55KnuOCbcEslQzvz
         Rj5zmUfCdhf5Mer71UA9UpzLExoXOumxOdiV036qEL3cz9IQSY9JDmVkkVheDDQtDajZ
         yZZ1ACbXmfusYlTYoUbsQSmbvxCYW/Sc9GepJKyokaIcbC2df353YSu0g6wfyehLaf45
         mNpb7hr5mk2LSoY8/UhbkvUR8ueaLVkxa3evhibYL50N9J5lnMAOaHPTn3V23Q4dS3eB
         zC1g==
X-Gm-Message-State: AGi0PubC3X48M10STs14mnKmx9XBL7QdudxYWZZ+b6ynwBkVp5reLi6f
        vj1Q8H47qc7vBotynxj2YSE=
X-Google-Smtp-Source: APiQypI+yZ/q+n9vOWzjkzHKWX+cCC3fC1eMEiyn/b8lAySJ9BQDFG+p68lSw7hsK1v+oIE3KSoncQ==
X-Received: by 2002:a9d:a55:: with SMTP id 79mr3629382otg.295.1588966917698;
        Fri, 08 May 2020 12:41:57 -0700 (PDT)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id q3sm715371oom.12.2020.05.08.12.41.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 12:41:57 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH net-next] net: ipa: Remove ipa_endpoint_stop{,_rx_dma} again
Date:   Fri,  8 May 2020 12:41:33 -0700
Message-Id: <20200508194132.3412384-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building arm64 allyesconfig:

drivers/net/ipa/ipa_endpoint.c: In function 'ipa_endpoint_stop_rx_dma':
drivers/net/ipa/ipa_endpoint.c:1274:13: error: 'IPA_ENDPOINT_STOP_RX_SIZE' undeclared (first use in this function)
drivers/net/ipa/ipa_endpoint.c:1274:13: note: each undeclared identifier is reported only once for each function it appears in
drivers/net/ipa/ipa_endpoint.c:1289:2: error: implicit declaration of function 'ipa_cmd_dma_task_32b_addr_add' [-Werror=implicit-function-declaration]
drivers/net/ipa/ipa_endpoint.c:1291:45: error: 'ENDPOINT_STOP_DMA_TIMEOUT' undeclared (first use in this function)
drivers/net/ipa/ipa_endpoint.c: In function 'ipa_endpoint_stop':
drivers/net/ipa/ipa_endpoint.c:1309:16: error: 'IPA_ENDPOINT_STOP_RX_RETRIES' undeclared (first use in this function)

These functions were removed in a series, merged in as
commit 33395f4a5c1b ("Merge branch 'net-ipa-kill-endpoint-stop-workaround'").

Remove them again so that the build works properly.

Fixes: 3793faad7b5b ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/ipa/ipa_endpoint.c | 61 ----------------------------------
 1 file changed, 61 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 5fec30e542cb..82066a223a67 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1269,67 +1269,6 @@ static void ipa_endpoint_reset(struct ipa_endpoint *endpoint)
 			ret, endpoint->channel_id, endpoint->endpoint_id);
 }
 
-static int ipa_endpoint_stop_rx_dma(struct ipa *ipa)
-{
-	u16 size = IPA_ENDPOINT_STOP_RX_SIZE;
-	struct gsi_trans *trans;
-	dma_addr_t addr;
-	int ret;
-
-	trans = ipa_cmd_trans_alloc(ipa, 1);
-	if (!trans) {
-		dev_err(&ipa->pdev->dev,
-			"no transaction for RX endpoint STOP workaround\n");
-		return -EBUSY;
-	}
-
-	/* Read into the highest part of the zero memory area */
-	addr = ipa->zero_addr + ipa->zero_size - size;
-
-	ipa_cmd_dma_task_32b_addr_add(trans, size, addr, false);
-
-	ret = gsi_trans_commit_wait_timeout(trans, ENDPOINT_STOP_DMA_TIMEOUT);
-	if (ret)
-		gsi_trans_free(trans);
-
-	return ret;
-}
-
-/**
- * ipa_endpoint_stop() - Stops a GSI channel in IPA
- * @client:	Client whose endpoint should be stopped
- *
- * This function implements the sequence to stop a GSI channel
- * in IPA. This function returns when the channel is is STOP state.
- *
- * Return value: 0 on success, negative otherwise
- */
-int ipa_endpoint_stop(struct ipa_endpoint *endpoint)
-{
-	u32 retries = IPA_ENDPOINT_STOP_RX_RETRIES;
-	int ret;
-
-	do {
-		struct ipa *ipa = endpoint->ipa;
-		struct gsi *gsi = &ipa->gsi;
-
-		ret = gsi_channel_stop(gsi, endpoint->channel_id);
-		if (ret != -EAGAIN || endpoint->toward_ipa)
-			break;
-
-		/* For IPA v3.5.1, send a DMA read task and check again */
-		if (ipa->version == IPA_VERSION_3_5_1) {
-			ret = ipa_endpoint_stop_rx_dma(ipa);
-			if (ret)
-				break;
-		}
-
-		msleep(1);
-	} while (retries--);
-
-	return retries ? ret : -EIO;
-}
-
 static void ipa_endpoint_program(struct ipa_endpoint *endpoint)
 {
 	if (endpoint->toward_ipa) {

base-commit: 30e2206e11ce27ae910cc0dab21472429e400a87
-- 
2.26.2

