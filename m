Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97B2114ACC6
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 00:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbgA0XzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 18:55:12 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:54523 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728057AbgA0XzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 18:55:11 -0500
Received: by mail-pj1-f73.google.com with SMTP id a31so272122pje.4
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 15:55:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4KjA2O3e5WfLc30wyB/HF4idXFgGIVfHNa/bFpMvIf4=;
        b=jeDzCCaf1mffpWsNrUWt3r7/AOzqb0HR4TMgu+vUxItxw6dM6qGy/RsJMXmJ6WYtdX
         7H8qxJXbYGCxHSQx3QtCpcOzkdM45i3w9usgyo/DrZsvjkKUMrf4ydiONm+ks/OZxmvr
         3NdNCDOAf2Ml6HAvOos5npaI8Mv3di0sVVio3OCZp7bEC1JysLrZEbnWde7rnyJwnHi/
         +/mzZWV6qyHFvgt3m00Et6fna971JpKrXzOX23GkJhQTJnCNsxnJA1w8wXDW5VNmEzDW
         tS2PA0lJg4Pka6yL4zllgKJA7fgCr3xDBatOSLX0vWRq+yM/k362tyJzSFjiQso3iRXx
         vQkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4KjA2O3e5WfLc30wyB/HF4idXFgGIVfHNa/bFpMvIf4=;
        b=KxRK+axCk4Q1Eck4jbX02nk3IW1H6tikPbLa520GyDL3/WKjtHNil4J9yGBSsF+fDO
         0Kl/jVRPMpdZGzD/v8nW2YXAjc4XTtmASyKpYb0lhkXgGUDQQgBHrSvH33ZYdkGVv/t3
         egqaxU8/tXow9MrIQ4Wt5gA8vcQ0gufcZ2r8mkVlP/i+PnZstHcd3yvqtpaFtFPuA1ZI
         RBXIoIdD1JMGtQqNrTwPzOqlJjoYd8CcJtNEBVV4Iu1LlMnbhO3dkd9vXGRVvuDnIceQ
         joFE/V3fRT5IsX1ZrwqzTVlyHuiifuMsi6gtfhOdt3kA5F3skUd6ILyRCbAnJ/VZoeKP
         Xakw==
X-Gm-Message-State: APjAAAXy8NPTaE8KKBY9EKgg8nO39loGkZ0pcOthOqjX125IpLF5Vncf
        kfbG38FOKuMOA9EPsobaIPEAloEwUJuSNy8pAovbBw==
X-Google-Smtp-Source: APXvYqxX2cTYOYi/6gfypjziF+v7JoXLJYFHxYRZUMf0IT3deC7wiZG5csxN84jPhbo7NcVApT5J2LUA/tX8yW3rQK9e7g==
X-Received: by 2002:a63:d041:: with SMTP id s1mr22025574pgi.363.1580169310297;
 Mon, 27 Jan 2020 15:55:10 -0800 (PST)
Date:   Mon, 27 Jan 2020 15:53:55 -0800
In-Reply-To: <20200127235356.122031-1-brendanhiggins@google.com>
Message-Id: <20200127235356.122031-5-brendanhiggins@google.com>
Mime-Version: 1.0
References: <20200127235356.122031-1-brendanhiggins@google.com>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH v1 4/5] ptp: 1588_clock_ines: add unspecified HAS_IOMEM dependency
From:   Brendan Higgins <brendanhiggins@google.com>
To:     jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        Richard Cochran <richardcochran@gmail.com>
Cc:     linux-um@lists.infradead.org, linux-kernel@vger.kernel.org,
        davidgow@google.com, heidifahim@google.com,
        Brendan Higgins <brendanhiggins@google.com>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently CONFIG_PTP_1588_CLOCK_INES=y implicitly depends on
CONFIG_HAS_IOMEM=y; consequently, on architectures without IOMEM we get
the following build error:

/usr/bin/ld: drivers/ptp/ptp_ines.o: in function `ines_ptp_ctrl_probe':
drivers/ptp/ptp_ines.c:795: undefined reference to `devm_ioremap_resource'

Fix the build error by adding the unspecified dependency.

Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
---
 drivers/ptp/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index 475c60dccaa4f..17e670fa1d4c8 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -80,6 +80,7 @@ config PTP_1588_CLOCK_INES
 	depends on NETWORK_PHY_TIMESTAMPING
 	depends on PHYLIB
 	depends on PTP_1588_CLOCK
+	depends on HAS_IOMEM
 	help
 	  This driver adds support for using the ZHAW InES 1588 IP
 	  core.  This clock is only useful if the MII bus of your MAC
-- 
2.25.0.341.g760bfbb309-goog

