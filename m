Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53662EB8E1
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 05:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbhAFE0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 23:26:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbhAFE0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 23:26:23 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22447C06134D;
        Tue,  5 Jan 2021 20:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=2BjP3I/22j14cC7xYb+IGTqn5EWyFRNS8lMyLgi/7lo=; b=BiyuYZAPWKCCBypAusZR7een8H
        yLhuDL7W0cqFxNPu4NaXHs1KNkFpaXAoVwxtoGHU/2V+hcMV2NrJx6kcgIFCVtsYdQ5AcwRIfxuPA
        zmxcoNtwkh01HGsDwYyg9e8o/9vtOjopUiDbqP6brlcmzr3UV/ZpeziqdyB6I77dSn58PNKwdHoiq
        jCYrkHoieClHY/a0Q94CVPdEk3Dyayq28ZU6EZEB1wAs6WxHmxz+v5iJN+o27gIU5hYJgM5vKDqES
        GoZS0T9YulM97cSSFv3rbc3oJJwq37Pk9pwKevYr1NUNSVVH4ZknWcCh/XN7qd90JCom+4MEiBDey
        8QZiU2Og==;
Received: from [2601:1c0:6280:3f0::64ea] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kx0O8-00073N-Uv; Wed, 06 Jan 2021 04:25:37 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] ptp: ptp_ines: prevent build when HAS_IOMEM is not set
Date:   Tue,  5 Jan 2021 20:25:31 -0800
Message-Id: <20210106042531.1351-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ptp_ines.c uses devm_platform_ioremap_resource(), which is only
built/available when CONFIG_HAS_IOMEM is enabled.
CONFIG_HAS_IOMEM is not enabled for arch/s390/, so builds on S390
have a build error:

s390-linux-ld: drivers/ptp/ptp_ines.o: in function `ines_ptp_ctrl_probe':
ptp_ines.c:(.text+0x17e6): undefined reference to `devm_platform_ioremap_resource'

Prevent builds of ptp_ines.c when HAS_IOMEM is not set.

Fixes: bad1eaa6ac31 ("ptp: Add a driver for InES time stamping IP core.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Link: lore.kernel.org/r/202101031125.ZEFCUiKi-lkp@intel.com
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 drivers/ptp/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- lnx-511-rc2.orig/drivers/ptp/Kconfig
+++ lnx-511-rc2/drivers/ptp/Kconfig
@@ -78,6 +78,7 @@ config DP83640_PHY
 config PTP_1588_CLOCK_INES
 	tristate "ZHAW InES PTP time stamping IP core"
 	depends on NETWORK_PHY_TIMESTAMPING
+	depends on HAS_IOMEM
 	depends on PHYLIB
 	depends on PTP_1588_CLOCK
 	help
