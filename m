Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4F5621F10
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 22:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbfEQUZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 16:25:31 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36455 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727161AbfEQUZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 16:25:30 -0400
Received: by mail-pg1-f196.google.com with SMTP id a3so3812845pgb.3
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 13:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references:to;
        bh=8PpxL/NV/+OrQDBUeE3IDvaPw47rgqTOM0Cb9MrQeH0=;
        b=apLP3m9od6HVgQ/hIke6j+uThVwRcRHt07SCqxZlM5KeMh7TiELavV8neN/TQtJSvN
         oJ+AihUKcmIq4UKyluLNk9vwLMIKIjRIcBMSuyk6iwILU7iKHB/U0MMAsJ8oGeA21HfQ
         qM5UyGFKUVel3HvMYamS5lUbOpWxjs+yybsQdHYAtKtnv7PEapAsONbMmwIKbiOmplwo
         35lVYwJ8olqvTWYf12GGQRe+8Q7rvCg71u5XYHi8qHH8+CNvHT0HHD+YFxy/BnllGGku
         LLbOVxPMpO8rtFhsGhJ7FWqPCda8+3vJbLq8CumvZrtTzuE+FHIhCXlDyPBPgnvMG+cc
         laZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references:to;
        bh=8PpxL/NV/+OrQDBUeE3IDvaPw47rgqTOM0Cb9MrQeH0=;
        b=kKSZC1P0XW90fYU/TxilAfHTeG3UCXMqc+zOwMQu0vL2tiaU5FypO9mv+qXVm13AQr
         unNFjwG1qvlK4kkrKzJuCaQDW0Qe7LmW+hEJpZ1FVV0HvDQmznLAFgA8Vm7B5UIHBypk
         ataxeeRck4Vd/6auS+CXFs1wu/1+XYCORvDA7l9Gmt06nwF0lcXJXCQAA7twf1TXfd5q
         DgaEn9fyfS8K3GA6vOkRHZGc+ng1/uQmOiFzVuMBO0z7lNg1bhItOvTKh+/NZMv+oKKl
         yxDIucrJUmEDMELWLGHJWhhhg8zwfGTKbgX1mqh/7cmrVwhbloUb162HhDstmSOqchla
         5Neg==
X-Gm-Message-State: APjAAAXhDiOP88ftULvQPZwL72DI0egtvvw0nn63Cvde3vO2xaoXY81/
        tF/r4JTvzQovt/dRtmXH7gY=
X-Google-Smtp-Source: APXvYqxJA1JOmwDZu4KhGqq9Y+b7MQKpZsbFOgs5+gTYwadmzMLvP0MmOH3FdN4onukzJEWzA/+GCQ==
X-Received: by 2002:a63:ed16:: with SMTP id d22mr57827369pgi.35.1558124730300;
        Fri, 17 May 2019 13:25:30 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (122-58-182-39-adsl.sparkbb.co.nz. [122.58.182.39])
        by smtp.gmail.com with ESMTPSA id w125sm12062430pfw.69.2019.05.17.13.25.29
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Fri, 17 May 2019 13:25:29 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id D3AF1360084; Sat, 18 May 2019 08:25:26 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     netdev@vger.kernel.org
Cc:     schmitz@debian.org, Michael Schmitz <schmitzmic@gmail.com>,
        sfr@canb.auug.org.au, davem@davemloft.net
Subject: [PATCH 2/3] net: 8390: switch X-Surf 100 driver to use ax88796b PHY
Date:   Sat, 18 May 2019 08:25:17 +1200
Message-Id: <1558124718-19209-3-git-send-email-schmitzmic@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1558124718-19209-1-git-send-email-schmitzmic@gmail.com>
References: <1558124718-19209-1-git-send-email-schmitzmic@gmail.com>
In-Reply-To: <20190514105649.512267cd@canb.auug.org.au>
References: <20190514105649.512267cd@canb.auug.org.au>
To:     netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The asix.c driver name causes a module name conflict with a driver
of the same name in drivers/net/usb. Select the new ax88796b PHY
driver when X-SURF 100 support is configured.

Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
Fixes: 31dd83b96641 ("net-next: phy: new Asix Electronics PHY driver")
---
 drivers/net/ethernet/8390/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/8390/Kconfig b/drivers/net/ethernet/8390/Kconfig
index f2f0264..443b34e 100644
--- a/drivers/net/ethernet/8390/Kconfig
+++ b/drivers/net/ethernet/8390/Kconfig
@@ -49,7 +49,7 @@ config XSURF100
 	tristate "Amiga XSurf 100 AX88796/NE2000 clone support"
 	depends on ZORRO
 	select AX88796
-	select ASIX_PHY
+	select AX88796B_PHY
 	help
 	  This driver is for the Individual Computers X-Surf 100 Ethernet
 	  card (based on the Asix AX88796 chip). If you have such a card,
-- 
1.9.1

