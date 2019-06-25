Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA945270A
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 10:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730940AbfFYItB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 04:49:01 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38780 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730925AbfFYIs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 04:48:59 -0400
Received: by mail-pg1-f195.google.com with SMTP id z75so6003984pgz.5
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 01:48:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding:cc:from:to;
        bh=f1EqKr7GJC/8CxAccGmLUlVnbKRyObp1Mx1bLRI3a2c=;
        b=uLf4A7r4o4X1AaeqNyyiaiwTvT3cbwjX14g9SO3eyVlM9nqcPYvcD64hwwDhiBvEwF
         sWnC8y14B58TkpSguJcXeDeX/2fFsHZKU3ejMPymGOQScVb10rWYg985M7iSIBU3I4FX
         PSDchpLHdxmHNtSf+f+HlqPEMGO19vJMd9ZwEE9NoU5O1z4Dizej97zUbBYig9wWKb8v
         y7NUlcSgVDNAZRVpeZTi1vFhRMOtU3Kh8MbGjx66SH5z5oUgRWSQRJQ1Es/7Y/dw8PbH
         uX91wrNsAEnCvo0L6OEGnGb6HYisFTy7IKBXYBmlINKwgP3A/LJuduAJXwdfIEmN+3Zb
         33Uw==
X-Gm-Message-State: APjAAAWyABz9YKQ9RZuKRqriTY58kjlQjM9EfXdeZgDNaCPlwRCt874j
        JfsbhCYPOYBAaEWvvCWlyTF2HQ==
X-Google-Smtp-Source: APXvYqxi11fDTnliRbD2FFe1yfBEWRAkKNciTSRn86oA7mCGILT1K0pRVbT5ADMTCuMKh8BJFb7/Xg==
X-Received: by 2002:a63:d4c:: with SMTP id 12mr9800277pgn.30.1561452538882;
        Tue, 25 Jun 2019 01:48:58 -0700 (PDT)
Received: from localhost (220-132-236-182.HINET-IP.hinet.net. [220.132.236.182])
        by smtp.gmail.com with ESMTPSA id f15sm1829014pje.17.2019.06.25.01.48.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 01:48:58 -0700 (PDT)
Subject: [PATCH v2 1/2] net: macb: Kconfig: Make MACB depend on COMMON_CLK
Date:   Tue, 25 Jun 2019 01:48:27 -0700
Message-Id: <20190625084828.540-2-palmer@sifive.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190625084828.540-1-palmer@sifive.com>
References: <20190625084828.540-1-palmer@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@sifive.com>
From:   Palmer Dabbelt <palmer@sifive.com>
To:     nicolas.ferre@microchip.com, harinik@xilinx.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit c218ad559020 ("macb: Add support for SiFive FU540-C000") added a
dependency on the common clock framework to the macb driver, but didn't
express that dependency in Kconfig.  As a result macb now fails to
compile on systems without COMMON_CLK, which specifically causes a build
failure on powerpc allyesconfig.

This patch adds the dependency, which results in the macb driver no
longer being selectable on systems without the common clock framework.
All known systems that have this device already support the common clock
framework, so this should not cause trouble for any uses.  Supporting
both the FU540-C000 and systems without COMMON_CLK is quite ugly.

I've build tested this on powerpc allyesconfig and RISC-V defconfig
(which selects MACB), but I have not even booted the resulting kernels.

Fixes: c218ad559020 ("macb: Add support for SiFive FU540-C000")
Signed-off-by: Palmer Dabbelt <palmer@sifive.com>
---
 drivers/net/ethernet/cadence/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/Kconfig b/drivers/net/ethernet/cadence/Kconfig
index 1766697c9c5a..64d8d6ee7739 100644
--- a/drivers/net/ethernet/cadence/Kconfig
+++ b/drivers/net/ethernet/cadence/Kconfig
@@ -21,7 +21,7 @@ if NET_VENDOR_CADENCE
 
 config MACB
 	tristate "Cadence MACB/GEM support"
-	depends on HAS_DMA
+	depends on HAS_DMA && COMMON_CLK
 	select PHYLIB
 	---help---
 	  The Cadence MACB ethernet interface is found on many Atmel AT32 and
@@ -42,7 +42,7 @@ config MACB_USE_HWSTAMP
 
 config MACB_PCI
 	tristate "Cadence PCI MACB/GEM support"
-	depends on MACB && PCI && COMMON_CLK
+	depends on MACB && PCI
 	---help---
 	  This is PCI wrapper for MACB driver.
 
-- 
2.21.0

