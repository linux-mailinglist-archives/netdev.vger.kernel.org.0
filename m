Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44010581CF4
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 03:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240113AbiG0BMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 21:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiG0BMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 21:12:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6382CDE8
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 18:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=DewYU1MMcgcaZ5TkOP0OAdg0HlHDI4mOJqLv+jp1qp0=; b=eH33iKMrlQnnw6bo+dwzEL86wb
        0kVusBBdPsS66gcjikNBJTG0yaVstYNSfRDnPqkPDkCe0OLddc2SgiJ/UJrv0KPgMzE51LU7eNwLT
        rJF/2IVgFFT15wxJntk1aRv5+epAjwFFl/Gh47M38GDoq5lIp/WPos5Tl6HWaT3hNgCsMfOCMY8k7
        RF7Tpyyz71QUbYTv4HQagQ2x4M/R73byHVOyQtDb9eDBFNtlBgnby6n8Zq+/FsybhdvvNdEafbnG3
        wq9/sz9jNdF46kcTBNPZdAu1GDOu8GlVTtjeKeb3BAySZmio01VSeZ/zme3Q1bf++wHEQI0a2cV5x
        jMr29jKA==;
Received: from [2601:1c0:6280:3f0::a6b3] (helo=casper.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oGVb4-002UbV-Fa; Wed, 27 Jul 2022 01:12:24 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Vadim Fedorenko <vadfed@fb.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH] ptp: ocp: select CRC16 to fix build error
Date:   Tue, 26 Jul 2022 18:12:13 -0700
Message-Id: <20220727011213.24274-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ptp_ocp.c uses crc16(), so it should select CRC16 to
prevent a build error:

ERROR: modpost: "crc16" [drivers/ptp/ptp_ocp.ko] undefined!

Fixes: 3c3673bde50c ("ptp: ocp: Add firmware header checks")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vadim Fedorenko <vadfed@fb.com>
Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
---
 drivers/ptp/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -176,6 +176,7 @@ config PTP_1588_CLOCK_OCP
 	depends on !S390
 	depends on COMMON_CLK
 	select NET_DEVLINK
+	select CRC16
 	help
 	  This driver adds support for an OpenCompute time card.
 
