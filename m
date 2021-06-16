Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91CE83A9DDE
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 16:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234115AbhFPOn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 10:43:57 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:21218 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234083AbhFPOn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 10:43:56 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623854510; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=C06ty5zKAA85QV5FLdrKzAOkLXJ5LuazSdJfg2jTE0g=; b=UtRAZENMvIYlzr07Q3KVLObA/V8WelTVP70Z2gT1Da5BIGO7k5vWQ03slqEnzOlLuRTNE/hH
 m5zxnfyquY0ezY9f4JWMc9Iesp5k8eJYndYjKYmo7naifyRohY+fk8NmhWR651qth5BGzkfG
 dUs5pKp9Uq0A1E8HW9HT9BMh0mI=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 60ca0d858491191eb34bd939 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 16 Jun 2021 14:41:09
 GMT
Sender: linyyuan=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F19AFC43460; Wed, 16 Jun 2021 14:41:08 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from localhost.localdomain (unknown [101.87.142.17])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: linyyuan)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5A71BC433D3;
        Wed, 16 Jun 2021 14:40:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5A71BC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=linyyuan@codeaurora.org
From:   Linyu Yuan <linyyuan@codeaurora.org>
To:     Oliver Neukum <oliver@neukum.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        Linyu Yuan <linyyuan@codeaurora.org>
Subject: [PATCH] net: cdc_eem: fix tx fixup skb leak
Date:   Wed, 16 Jun 2021 22:40:44 +0800
Message-Id: <20210616144044.20693-1-linyyuan@codeaurora.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

when usbnet transmit a skb, eem fixup it in eem_tx_fixup(),
if skb_copy_expand() failed, it return NULL,
usbnet_start_xmit() will have no chance to free original skb.

fix it by free orginal skb in eem_tx_fixup() first,
then check skb clone status, if failed, return NULL to usbnet.

Signed-off-by: Linyu Yuan <linyyuan@codeaurora.org>
---
 drivers/net/usb/cdc_eem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/cdc_eem.c b/drivers/net/usb/cdc_eem.c
index 2e60bc1b9a6b..359ea0d10e59 100644
--- a/drivers/net/usb/cdc_eem.c
+++ b/drivers/net/usb/cdc_eem.c
@@ -123,10 +123,10 @@ static struct sk_buff *eem_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
 	}
 
 	skb2 = skb_copy_expand(skb, EEM_HEAD, ETH_FCS_LEN + padlen, flags);
+	dev_kfree_skb_any(skb);
 	if (!skb2)
 		return NULL;
 
-	dev_kfree_skb_any(skb);
 	skb = skb2;
 
 done:
-- 
2.25.1

