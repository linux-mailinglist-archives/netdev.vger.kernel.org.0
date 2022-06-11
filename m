Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0495547664
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 18:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbiFKQU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 12:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbiFKQUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 12:20:54 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3BED98;
        Sat, 11 Jun 2022 09:20:53 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id gd1so1979951pjb.2;
        Sat, 11 Jun 2022 09:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=52FEawlxx2XEiajDreVr4B3bR3J/54lh0TNcaiAALg0=;
        b=ab0xT3CV4RuMF2OiZPI2xLVnhRW5/shoC498Em+y8YYDEYcbMvP9qE+0CrXXuGYXDZ
         7adMdG5Yk5R8vWiiyTC+caNJKMNj4mMwHBGfhIdh0H1s+4PUIjJs5a1l1Hhj8AF+OD5U
         zPbH0CnWeY2+iIzQbJtNVAqy0Dob1LbtaPZBUIQYftBbJbh45QJu3iwzc4Csd9v+SEbO
         V5aQqxcQ9kTpXo7Whe0D4KQ3Tc6A2BxU6XgsIOH9qncWbIiTLYyM0FG7JQb8/LkqLKll
         Hf9P1QgIT+EBxyRYmolJ17kcsnVm0Tf5h4/I5sca+OM9bCJvILT1kH1Re23b0JEHtNR6
         x6gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=52FEawlxx2XEiajDreVr4B3bR3J/54lh0TNcaiAALg0=;
        b=GczezX7xucMaSxOSAlQmQDQbe7W+q5ygj3EErxPkSNXvUIjyoBWRTUKjaGL/dliYPc
         gMKjBuYZLNao+nSl3zpkqYHAW0/xaV+hzqAuhrZYbbYfhGC9inDVTIO2vRtSGh5mx/5D
         xYd5upjL/xm7gW1Vw+XjWa2ssgiDel5Y9s7diPzqt7ivVI0B4kJ4ygWxI9vDydx4VUY6
         oDjvSr3IJ74ymNss5CtIdqrd9fgG+LTkobWI5u2iVc70a/xxXjsZEkKfAodt7eprFDYs
         VBPRfCkTVfayk+yEotytE/r1zc9pdAkf+TF0+LXBk2aedfOEOeZS1+eNTP4qrNq66NBI
         J6dw==
X-Gm-Message-State: AOAM533kzlC5s2a1TVlqcdrEAILQXKHx1ObX+WHDzalE3LyZ1elvhulP
        bMaehtYyPJjXJKePG9w7KDxCPE30aB9EjQ==
X-Google-Smtp-Source: ABdhPJw6r3T6eGmWuqAklyCuOxc8EvgaHFctN+cJSKeE6vFCz3HGkpFK4sGIkNZ0F1va5sjswgR38A==
X-Received: by 2002:a17:90a:2d89:b0:1dc:a406:3566 with SMTP id p9-20020a17090a2d8900b001dca4063566mr5906026pjd.135.1654964452408;
        Sat, 11 Jun 2022 09:20:52 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id je9-20020a170903264900b0015e8d4eb2e3sm1692469plb.301.2022.06.11.09.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jun 2022 09:20:52 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH 2/2] can: etas_es58x: fix signedness of USB RX and TX pipes
Date:   Sun, 12 Jun 2022 01:20:37 +0900
Message-Id: <20220611162037.1507-3-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611162037.1507-1-mailhol.vincent@wanadoo.fr>
References: <20220611162037.1507-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

USB pipes are meant to be unsigned int (c.f. [1]). However, fields
rx_pipe and tx_pipe of struct es58x_device are both signed
integers. Change the type of those two fields from int to unsigned
int.

[1] https://elixir.bootlin.com/linux/v5.18/source/include/linux/usb.h#L1571

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/usb/etas_es58x/es58x_core.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.h b/drivers/net/can/usb/etas_es58x/es58x_core.h
index 512c5b7a1cfa..d769bdf740b7 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.h
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.h
@@ -400,8 +400,8 @@ struct es58x_device {
 	const struct es58x_parameters *param;
 	const struct es58x_operators *ops;
 
-	int rx_pipe;
-	int tx_pipe;
+	unsigned int rx_pipe;
+	unsigned int tx_pipe;
 
 	struct usb_anchor rx_urbs;
 	struct usb_anchor tx_urbs_busy;
-- 
2.35.1

