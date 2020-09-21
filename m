Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3E1271C26
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 09:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgIUHhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 03:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgIUHhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 03:37:19 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001DBC0613CE
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 00:37:18 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a17so11578944wrn.6
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 00:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NROX0bNqDI7FiJUF4YVflXDepbR7cwfa195+TAp7FqI=;
        b=sUQGXw3W8ui6W7UW369yPnoa8QnsVfzpFzRk+yz8aIrOp3Tmms9uqhuYD7DfokVb/L
         osUVCqbl+aTyxWJWIEOs5Y0vwjvEbawxdlFktY7qVaTnsz3d+ZxxEecwnNkbf4j31sOw
         AHY7pQyCucaxwt9rPcnG12nT/LfdqDV6Rzn4NAMZZxlkLispA+gqm333Ej79LNMAG8RV
         6YAYWKk5tbRWGqhS1c+uyfGn72Iq3++pzCRNSDwb46pkKw4aCyPIMHu6NypP7o+Cllh2
         F96YHK98ncy3AZ/fOMaUBP8OGausbuY5jiAJ3Y/jWeMxfaHuYGmWpGZSvqmni6807C8M
         U0hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NROX0bNqDI7FiJUF4YVflXDepbR7cwfa195+TAp7FqI=;
        b=nm7ZcVQ+51SjRKT0Sbu2eIhGobvTvkxLK2rrb1KqdwSzvPNUCSDMnpmtUdR84KzvA7
         ORLeVdI7NX7N0JLlpMmAvWjJOXBZRFSS0OEq9YV9N71pN2YqHmbTcjzobWkeW/DSf56+
         GK0O2HWsW8dZSoH2towiTOoyNfrcqa5fWphTyksxu6ARJpU8QRzvQ4lywySFsdbIgW/4
         1wnzxLvWuKhcSg9Exm+ReqKMrs7OhmAA4g7rPlzb007TeU4applPnxJjCHwJ9w5ZP/4z
         LNeeE8XO+OY1jkfIidOz3SnV+bdEKGDxJ6dqUYPSG5RccUh3zId0YXBBR64T61hXqe6n
         xg1g==
X-Gm-Message-State: AOAM531Z7duVFOb9FHf2g6APD1K1Zge3P9cPSO4QE/o6PshQzXdoNcdz
        uRyhAXR49JPnas62Fyx94d54UQ==
X-Google-Smtp-Source: ABdhPJyUkazSF0v/Gm+h2UP/98/PEaQBIlc5UJ6gJvjQmbcaVK8BZGumzpDTykPTQpPOH3TP4MyNoQ==
X-Received: by 2002:adf:ee8d:: with SMTP id b13mr55137256wro.249.1600673837648;
        Mon, 21 Sep 2020 00:37:17 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:490:8730:5875:9da3:b857:e7f4])
        by smtp.gmail.com with ESMTPSA id v9sm19976761wrv.35.2020.09.21.00.37.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Sep 2020 00:37:17 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     manivannan.sadhasivam@linaro.org, hemantk@codeaurora.org,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        bjorn.andersson@linaro.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH v2 2/2] net: qrtr: Start MHI channels during init
Date:   Mon, 21 Sep 2020 09:43:04 +0200
Message-Id: <1600674184-3537-2-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600674184-3537-1-git-send-email-loic.poulain@linaro.org>
References: <1600674184-3537-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Start MHI device channels so that transfers can be performed.
The MHI stack does not auto-start channels anymore.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 v2: split MHI and qrtr changes in dedicated commits

 net/qrtr/mhi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
index ff0c414..7100f0b 100644
--- a/net/qrtr/mhi.c
+++ b/net/qrtr/mhi.c
@@ -76,6 +76,11 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
 	struct qrtr_mhi_dev *qdev;
 	int rc;
 
+	/* start channels */
+	rc = mhi_prepare_for_transfer(mhi_dev);
+	if (rc)
+		return rc;
+
 	qdev = devm_kzalloc(&mhi_dev->dev, sizeof(*qdev), GFP_KERNEL);
 	if (!qdev)
 		return -ENOMEM;
-- 
2.7.4

