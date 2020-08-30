Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C60256EA7
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 16:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgH3Oj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 10:39:58 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:50661 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727015AbgH3Oje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 10:39:34 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598798373; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=63k57UM9aKfRQtY/EP8nhwKq5dGcYV4cF/NPx0Pmcm0=; b=sdi9d+vUk/dlIzn4y8sRdxdPYwkNiziMnsnWdgv6jnxOV7O7Y4cu5zo5dlRF4C7WNwNLBqfH
 LeqtXwklvOHr5eR39LeoeuVL5nURm04vigo5TYXlUAfSwDYrODLDalNinRBOS7qYYV94wdnH
 MXNoKAcznIBXptxqA6cCvsaoy34=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5f4bba03f4f3e646136427d3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 30 Aug 2020 14:38:59
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 076CBC433CA; Sun, 30 Aug 2020 14:38:59 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from deesin-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: deesin)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A8D5FC433C6;
        Sun, 30 Aug 2020 14:38:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A8D5FC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=deesin@codeaurora.org
From:   Deepak Kumar Singh <deesin@codeaurora.org>
To:     bjorn.andersson@linaro.org, clew@codeaurora.org
Cc:     mathieu.poirier@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arun Kumar Neelakantam <aneela@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Carl Huang <cjhuang@codeaurora.org>,
        Necip Fazil Yildiran <necip@google.com>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
Subject: [PATCH V1 4/4] net: qrtr: Check function pointer before calling
Date:   Sun, 30 Aug 2020 20:08:12 +0530
Message-Id: <1598798292-5971-5-git-send-email-deesin@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598798292-5971-1-git-send-email-deesin@codeaurora.org>
References: <1598798292-5971-1-git-send-email-deesin@codeaurora.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arun Kumar Neelakantam <aneela@codeaurora.org>

sk_error_report callback function called without validating cause the NULL
pointer dereference.

Validate function pointer before using for error report.
---
 net/qrtr/qrtr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index e2dd38e..01cabd3 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -786,7 +786,8 @@ static void qrtr_reset_ports(void)
 
 		sock_hold(&ipc->sk);
 		ipc->sk.sk_err = ENETRESET;
-		ipc->sk.sk_error_report(&ipc->sk);
+		if (ipc->sk.sk_error_report)
+			ipc->sk.sk_error_report(&ipc->sk);
 		sock_put(&ipc->sk);
 	}
 	mutex_unlock(&qrtr_port_lock);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

