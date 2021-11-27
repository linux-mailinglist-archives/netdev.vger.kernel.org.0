Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F77845FFF4
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 16:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355406AbhK0PuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 10:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350380AbhK0PsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 10:48:07 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E82C061748;
        Sat, 27 Nov 2021 07:44:52 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id r10-20020a056830080a00b0055c8fd2cebdso18471263ots.6;
        Sat, 27 Nov 2021 07:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1FCj0eg3qCaMYcJXsF4imAvHr1mf3lurCF+mcbDbEBs=;
        b=Qf45wa8fLOp9BUn1Le2czW7jAmqgqTrZRN9J9PA+lNZ43PIPd9HEnbEOK2QWpcoiJy
         Gf9XBTlMSjTcS3HrQ1lGOdYs54yKVe+DnoqLn+plOlSZb4by51wV70StOG158AeVSx+P
         RmTa5wgoICakylcnD7UEMPwRE/E/f5oJPeZPumOr4YVb+QHICSZeXCppW0qIH7jK0KsD
         3H038dH7vGaK3U6s/NXvp4eMeQyNVUprfaHzD/4mfCHM5lD4wfrYpBDg9mXQ2vzG/sFy
         qDu29dR3UPWDfjvdUUMqMMF7qm/NCgK9rqPQgTLM3qtWGAYkKDmDrVKlBW4BeaauJfNx
         3U8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=1FCj0eg3qCaMYcJXsF4imAvHr1mf3lurCF+mcbDbEBs=;
        b=v0FuS9e4zVRE7klZ35NK7KfQAWv3MaYciS60Qwoda/zuqhbIMU1fy6/7aP380jGtt9
         9V9Y8MFo3ZqMStedbS9YFQ4iRYC3sP1414RbMikoTHi8vi0HBhPHbUOGXlo+N01wqqFF
         hX2XryARd4bqkmbqqgJU9ExYwsTas9k5FbXY13hfdQoh/EUWSETmsdSAagvA0fAlMPse
         Jgpuhh0r2xHXSpUKNeWpryWgRnc6suLMq4rpNqE+4uGWDJ7YG02XFyftwpb/tZ/mkjdp
         b6poXpqjdWuyjzrFNknyqM3hSQ12DfAh0qzQPQmHQ9nYUfL714jp032SdHfIJBDbuG5J
         vCdQ==
X-Gm-Message-State: AOAM530FJR8onZoLhSjDL9jaZD2qvna6F0sfIMewVV6UqSm5qIEOqtWa
        2734oPTEsNyswg6IWtCLwuw=
X-Google-Smtp-Source: ABdhPJzRYuRmQj7vEqYGDPE43oGeBHCDNNMnrWWDZ4u66bbB/oYUTmJrWR/gReCZUw/i+mq4YDbrgw==
X-Received: by 2002:a9d:12a6:: with SMTP id g35mr35177546otg.61.1638027892296;
        Sat, 27 Nov 2021 07:44:52 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n26sm1510723ooq.36.2021.11.27.07.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Nov 2021 07:44:51 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
To:     Anton Altaparmakov <anton@tuxera.com>
Cc:     linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Joel Stanley <joel@jms.id.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v3 3/3] vmxnet3: Use generic Kconfig option for page size limit
Date:   Sat, 27 Nov 2021 07:44:42 -0800
Message-Id: <20211127154442.3676290-4-linux@roeck-us.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211127154442.3676290-1-linux@roeck-us.net>
References: <20211127154442.3676290-1-linux@roeck-us.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the architecture independent Kconfig option PAGE_SIZE_LESS_THAN_64KB
to indicate that VMXNET3 requires a page size smaller than 64kB.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v3: Added patch to make VMXNET3 page size dependency architecture
    independent

 drivers/net/Kconfig | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 10506a4b66ef..6cccc3dc00bc 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -567,9 +567,7 @@ config XEN_NETDEV_BACKEND
 config VMXNET3
 	tristate "VMware VMXNET3 ethernet driver"
 	depends on PCI && INET
-	depends on !(PAGE_SIZE_64KB || ARM64_64K_PAGES || \
-		     IA64_PAGE_SIZE_64KB || PARISC_PAGE_SIZE_64KB || \
-		     PPC_64K_PAGES)
+	depends on PAGE_SIZE_LESS_THAN_64KB
 	help
 	  This driver supports VMware's vmxnet3 virtual ethernet NIC.
 	  To compile this driver as a module, choose M here: the
-- 
2.33.0

