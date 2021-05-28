Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4AB3942CE
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235974AbhE1MoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:44:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42506 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235955AbhE1Mnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 08:43:51 -0400
Received: from mail-ua1-f72.google.com ([209.85.222.72])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lmbod-0007yL-HD
        for netdev@vger.kernel.org; Fri, 28 May 2021 12:42:15 +0000
Received: by mail-ua1-f72.google.com with SMTP id 78-20020a9f26540000b02902426fc5ddd3so571297uag.16
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 05:42:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jAqSfj4V8Ljuoku0z/gnZf+7DpK+uMQ7YFx87xd1taE=;
        b=K/ntocmxWVxeT48+pq1C3hh0aAi1wdTkbz8KbaiTr9ijQQM4cvtw8itl++85q1QCRv
         7mxfnJ1s4mIsnHw5aq8pCsy+JAFcjaEn4QZRCrzNR+OIzd9uOexG7Ml9igg01uJ/oT/6
         vpQvU69IcVbPF908EKFrLAaP3uJBABdhvgPK8r0se7f3me2dN4nk51ot+9U9FY83H5mY
         6SlWKCE5Iyj4faqwbf5C3PfNe4FHI62IJCMxwjCC31wUu9jhZf7tVzyy2pfU20rfBClM
         RAxSB7+e3LholyZA8Y1atHWhta6jVsdBzY9oGQeL0ArSCYVlAnIAobRiuWTR/bYeBg8t
         ZJhg==
X-Gm-Message-State: AOAM532ix8HdQVqgRTucXhzTd9uawtI6kvLAu98uOvbz4mk07I2jOQAM
        BLRjYjZ1lIWxR7rho15V0p4uC7yca7mKfpRuHR8XY/e2XvKTLHXBAAOTy8AMHEoXNsmmZmTBqll
        72TCQm93u6WJrYh257A5CH+KSlrPr+63umA==
X-Received: by 2002:a1f:2850:: with SMTP id o77mr5533751vko.23.1622205734688;
        Fri, 28 May 2021 05:42:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwP8YHtx6Nm7Vih9OSRSik8WCc8W76wXEqvpaj46Qq9kY3UA3420v5Vf1Pwn5+9Osz0Gz33sA==
X-Received: by 2002:a1f:2850:: with SMTP id o77mr5533616vko.23.1622205733050;
        Fri, 28 May 2021 05:42:13 -0700 (PDT)
Received: from localhost.localdomain ([45.237.48.6])
        by smtp.gmail.com with ESMTPSA id b35sm782328uae.20.2021.05.28.05.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 05:42:12 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/12] nfc: pn533: drop of_match_ptr from device ID table
Date:   Fri, 28 May 2021 08:41:52 -0400
Message-Id: <20210528124200.79655-4-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210528124200.79655-1-krzysztof.kozlowski@canonical.com>
References: <20210528124200.79655-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver can match only via the DT table so the table should be always
used and the of_match_ptr does not have any sense (this also allows ACPI
matching via PRP0001, even though it might be not relevant here).  This
fixes compile warning (!CONFIG_OF):

    drivers/nfc/pn533/i2c.c:252:34: warning:
      ‘of_pn533_i2c_match’ defined but not used [-Wunused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/pn533/uart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/pn533/uart.c b/drivers/nfc/pn533/uart.c
index a0665d8ea85b..7bdaf8263070 100644
--- a/drivers/nfc/pn533/uart.c
+++ b/drivers/nfc/pn533/uart.c
@@ -319,7 +319,7 @@ static struct serdev_device_driver pn532_uart_driver = {
 	.remove = pn532_uart_remove,
 	.driver = {
 		.name = "pn532_uart",
-		.of_match_table = of_match_ptr(pn532_uart_of_match),
+		.of_match_table = pn532_uart_of_match,
 	},
 };
 
-- 
2.27.0

