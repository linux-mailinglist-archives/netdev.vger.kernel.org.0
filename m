Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA8335EEB8
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 09:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349766AbhDNHqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 03:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349686AbhDNHqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 03:46:42 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A22C061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 00:46:21 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id a2-20020a0568300082b029028d8118b91fso85554oto.2
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 00:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HsZiAAIPK9zxZbLQaDZtyVvDSUyuSo45EeY0Pr2AMK4=;
        b=D2vTFHEh7+529fWgn+/YzWIMJsXuQPKsudrRQgdzZtCLJxKDpOjtue/eudcYZ+INjO
         yN58AjUrriPNpI4nGGNrpw8SLU29iU/wIRrNc159/w9ShsH2eOWeexqfOs1bFgJaOiqG
         MLZJkUVR9/ZigdfwN7IL9uguvKbcb67Kxr+Af7xMapTb73+CvUj/HdWtYXpabC7M++/J
         0udNlR1kYTHBQoSZOSPEDeCweaMiO6gTCa7XScr82RB7Hwae8PbVIQH9vHOZKHoXrCH2
         62zyQaCY2ZDC4yF5rv5xGDZtG4kOhZrSxEIHqSGrjvy5JWyxS8V4H+cqaRRKuhveNP1S
         Y6Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HsZiAAIPK9zxZbLQaDZtyVvDSUyuSo45EeY0Pr2AMK4=;
        b=G1rZzEkfarrokKO7Qyzg1NX9YBdSpBZwoGnxQrH0ihr/aojQjQgAgbOPMSdW5o9edm
         AVO6ohHlGI/yDm3MbcU8X4YUvb+U1Rt8L+b8z5DY0WYIJSzvstEv9V5oAUjaHaqDvEXg
         XqhLw1Y4UijGrf2lWfBpmGpG+aNMCCR1Np3Jh/3zHezuugiLx8YK1Uo/vqwQq6RgB4fw
         SIE6QBYj8xz1O5uIeDvZG0i5DAd3zr06xzXHMJcRAs+sWeY+n2ALxduSTzkRDi+S204L
         KV4nlGItCb/XwJENfmgfZxSY0Q1oBnYemKCxBWFbciXpY4eT8nmi08daeiFnzdzHyJwO
         JU+g==
X-Gm-Message-State: AOAM531YqGqx/62HVx0u5EoenwxgxFbDblZcO1r5Qk9kFHtI0ZT5l7uP
        Zj9OY4a/pA6QbNm05DiA7/w5UOMnIQz/ZQ==
X-Google-Smtp-Source: ABdhPJyrdQKYaxjiDg0gnfQW2Uoa9yciG1f0EBlNt1OtO9iKqwzl7C9OJ2UgtSnk2p+y2CYt3L2VJw==
X-Received: by 2002:a9d:12d2:: with SMTP id g76mr21727596otg.216.1618386381043;
        Wed, 14 Apr 2021 00:46:21 -0700 (PDT)
Received: from pear.attlocal.net ([2600:1700:271:1a80:7124:9f6b:8552:7fdf])
        by smtp.gmail.com with ESMTPSA id w3sm2833015otg.78.2021.04.14.00.46.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Apr 2021 00:46:20 -0700 (PDT)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>
Subject: [PATCH net 3/3] ibmvnic: remove duplicate napi_schedule call in open function
Date:   Wed, 14 Apr 2021 02:46:16 -0500
Message-Id: <20210414074616.11299-4-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210414074616.11299-1-lijunp213@gmail.com>
References: <20210414074616.11299-1-lijunp213@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the unnecessary napi_schedule() call in __ibmvnic_open() since
interrupt_rx() calls napi_schedule_prep/__napi_schedule during every
receive interrupt.

Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
Signed-off-by: Lijun Pan <lijunp213@gmail.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index f4bd63216672..ffb2a91750c7 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1156,11 +1156,6 @@ static int __ibmvnic_open(struct net_device *netdev)
 
 	netif_tx_start_all_queues(netdev);
 
-	if (prev_state == VNIC_CLOSED) {
-		for (i = 0; i < adapter->req_rx_queues; i++)
-			napi_schedule(&adapter->napi[i]);
-	}
-
 	adapter->state = VNIC_OPEN;
 	return rc;
 }
-- 
2.23.0

