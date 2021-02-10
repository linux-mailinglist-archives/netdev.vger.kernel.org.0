Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801AC31722A
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 22:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbhBJVQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 16:16:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233521AbhBJVPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 16:15:42 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D863BC061788
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 13:13:54 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id a16so3228215ilq.5
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 13:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wkGHGHCDtF/e56vw7nKTBuP3UHCQdUWg9HZpFXYrggA=;
        b=Jh9f0ljt8Jhp+qw+yxtvXzyErFX+M3LwJERppl/c3WO3UsxWbzHyBUpI1DBT+EH3nJ
         43F8yDWf3EuwgrgrNZ0CWmWFgL1D26RAoMcEY+u0x1RaVLNrwlre6K9qmx8HjR4p3elV
         Hzlpfx9o23l5EgrFk36pQzqkmnbOHbyNV8A9pC4ezk2LuovAAFSwNnQofDEqsu4y5HgM
         IZNoH7ZJvAiG4J/lQfq3dMGAUn36xRL9++Es+hQC5N+2huEx38Ha47QBO2EuBY0s8Uti
         TNAX7706iRTGqeLJZVvbHXjAkuhLAWfT7VULCMrfAPimnTBFaE4yqUvA5L/gtklYqrUT
         tacg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wkGHGHCDtF/e56vw7nKTBuP3UHCQdUWg9HZpFXYrggA=;
        b=qrZ2OXqlXjt1x4aA4ic7BcfxmveyR1PnR5fXNzb+YH3zYKJ1igT3Jbfe48gdDOFeKi
         MAsqLxvWfRUDqrkiBpSAW4qHZiI32M0qwJ7DfonHZNjzbFAq3qp8JXfZLMvmbHcAZp1m
         txGaRUfz8VKWlHk7Q1c/KJkTNY8R54cf6XHFrgr3FoYLI/9X3G7LHLRLMWavH+aO3vEW
         Ok2QaWpmrwgtkbmn3OuqI+QNZWggRcWy+DQtEfCN+ra+fusCPFRiRoM74Kjh8YdSP8/e
         7sAX1HVzu7ZH1Zsmk1RgetE/VAeHdx++jbKwZOalmYIcYbeMb8+Gb3UX6OI5i/IGOpM8
         t/Pw==
X-Gm-Message-State: AOAM533CSZkNaWXyfW0eR8LhxP04BO0aea1U13FklthOyXuQyod4H3+X
        WsRWiIIByr8rQ8DyQDSSMBvbuQ==
X-Google-Smtp-Source: ABdhPJyPzxJ19bCcVdJ2bK/7klllblUMnUgpGCczbJlwIGDQuvnm3ZO4nC9nNOWXR1oR7Sm/LnYXPA==
X-Received: by 2002:a92:d11:: with SMTP id 17mr2997477iln.57.1612991632527;
        Wed, 10 Feb 2021 13:13:52 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id v1sm1549546ilm.35.2021.02.10.13.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 13:13:51 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: ipa: pass checksum trailer with received packets
Date:   Wed, 10 Feb 2021 15:13:49 -0600
Message-Id: <20210210211349.13158-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For a QMAP RX endpoint, received packets will be passed to the RMNet
driver.  If RX checksum offload is enabled, the RMNet driver expects
to find a trailer following each packet that contains computed
checksum information.  Currently the IPA driver is passing the
packet without the trailer.

Fix this bug.

Fixes: 84f9bd12d46db ("soc: qcom: ipa: IPA endpoints")
Signed-off-by: Alex Elder <elder@linaro.org>
---

David/Jakub,
I would like to have this back-ported as bug fix.  At its core, the
fix is simple, but even if it were reduced to a one-line change, the
result won't cleanly apply to both net/master and net-next/master.
How should this be handled?  What can I do to make it easier?

Thanks.

					-Alex

 drivers/net/ipa/ipa_endpoint.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 7209ee3c31244..5e3c2b3f38a95 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1232,6 +1232,11 @@ static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
 	void *data = page_address(page) + NET_SKB_PAD;
 	u32 unused = IPA_RX_BUFFER_SIZE - total_len;
 	u32 resid = total_len;
+	u32 trailer_len = 0;
+
+	/* If checksum offload is enabled, each packet includes a trailer */
+	if (endpoint->data->checksum)
+		trailer_len = sizeof(struct rmnet_map_dl_csum_trailer);
 
 	while (resid) {
 		const struct ipa_status *status = data;
@@ -1260,18 +1265,18 @@ static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
 		 */
 		align = endpoint->data->rx.pad_align ? : 1;
 		len = le16_to_cpu(status->pkt_len);
-		len = sizeof(*status) + ALIGN(len, align);
-		if (endpoint->data->checksum)
-			len += sizeof(struct rmnet_map_dl_csum_trailer);
+		len = sizeof(*status) + ALIGN(len, align) + trailer_len;
 
 		if (!ipa_endpoint_status_drop(endpoint, status)) {
 			void *data2;
 			u32 extra;
 			u32 len2;
 
-			/* Client receives only packet data (no status) */
+			/* Strip off the status element and pass only the
+			 * packet data (plus checksum trailer if enabled).
+			 */
 			data2 = data + sizeof(*status);
-			len2 = le16_to_cpu(status->pkt_len);
+			len2 = le16_to_cpu(status->pkt_len) + trailer_len;
 
 			/* Have the true size reflect the extra unused space in
 			 * the original receive buffer.  Distribute the "cost"
-- 
2.20.1

