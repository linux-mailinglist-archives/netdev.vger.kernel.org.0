Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE993240CC
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 16:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234317AbhBXP04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 10:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238541AbhBXPTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 10:19:40 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C507CC061788
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 07:18:58 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id h125so3563653lfd.7
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 07:18:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IcQAC8JHIQCwNRyMQ2oZvSV03+7k8VdXHLYW4etfu6I=;
        b=TDaITrQOpbe/EIowgBYNadH9MuOEfuFMCmhM+qL4gBFsD6FIdRyzLXXKLSZcif5U9a
         6c7eMmlmHHQOviFRCd2S6hy+O+krmGcZNr5ty3Oyx12pJ0fqZqKsrG7m3NTHC53Q18sj
         /1tvGOZMTqaHK5iXt5GcEzgwdKztHiJmxppbGduEMjW0L7y5TESK8eomfWdqYIh9h+GZ
         qtCQYLzYi43kBM+0HokPGoBeU31eK6IkSPMMrMcPLgfXcQg90eDQ4q3nJA85okegdyNo
         6tMb1/RDv5gWT54jLNc7Ae2fjRPBKrx6S+V7TWDVVTBE0jd2B71JAa35r3R9+agOV6dE
         mSSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IcQAC8JHIQCwNRyMQ2oZvSV03+7k8VdXHLYW4etfu6I=;
        b=SpnOGMsnRtvyGRCR1wHMW2BaIOpYm8hO7NqLashDIYhduCieAQzDKnrkvJ692aWhv6
         2ru2o9kr/zuLkW9Zx4uTCLBbBuzDeaaQhBkWIN8if71OAlhRHLOPE2uPmTYXd+4GZW4E
         IgQa6V9aJyScqHLJWc5PYNPwYo8l4LMV4QZI10bzfYentpwPTHzEZlXQyclU4XyvNn7p
         hgl/KSMZPqPMzLsCgyB7Vd5kG6qIopsvG1ynl7i1pUZynglVCWv4WGmJldNzNULk9QKw
         ExMXnPr8pY91FW3Au8I0McW7vTTFQoaKj26z+vqVPm2Noh2fnx8iiBwUn/p8fJP0/CIy
         oVdA==
X-Gm-Message-State: AOAM5314vzI4nOaISSF+MmIZSACmRzQf2UArX50nf72VCzVRD2ILB+67
        7aAnBEhku6gAc/FeIS66TvA=
X-Google-Smtp-Source: ABdhPJxCTi2m+hT4sKvQfG2+WG9CAj2ZPbnQTdyBq/cI+2LcDXJsWOcb7ET37mWzN1EpzFmelKH9Sw==
X-Received: by 2002:a19:3f93:: with SMTP id m141mr19185820lfa.423.1614179937341;
        Wed, 24 Feb 2021 07:18:57 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id j137sm546006lfj.55.2021.02.24.07.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 07:18:56 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH net] net: broadcom: bcm4908_enet: fix NAPI poll returned value
Date:   Wed, 24 Feb 2021 16:18:42 +0100
Message-Id: <20210224151842.2419-2-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210224151842.2419-1-zajec5@gmail.com>
References: <20210224151842.2419-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Missing increment was resulting in poll function always returning 0
instead of amount of processed packets.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/ethernet/broadcom/bcm4908_enet.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index 7983c7a9fca9..0b70e9e0ddad 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -583,6 +583,8 @@ static int bcm4908_enet_poll(struct napi_struct *napi, int weight)
 
 		enet->netdev->stats.rx_packets++;
 		enet->netdev->stats.rx_bytes += len;
+
+		handled++;
 	}
 
 	if (handled < weight) {
-- 
2.26.2

