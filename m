Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6503A42D1CB
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 07:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbhJNFHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 01:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhJNFHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 01:07:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFF2C061570
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 22:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=fy6uHjcmFnCcjPVTgw9SQgG/30BidBcTvAaDoM+yDQM=; b=aKm6Kup9pUlt6v6d7gfIO8ZcRi
        NdWp3yQM0xjyUo1ELiYY5pHxOk/P+1sNEjKHNj6whOrFdCj8uy4wNUv2pYjUy2mNbDiNsSUymOz/h
        /KLAEad55GjMIivsk0EQzMzV11udeNtOIMYz2J6WDnJWlU8/Nv8nwdxQ2ZQGtpnFnrtcywcbMcfQd
        L9L/1evmVBqSC/rqQh8/Ki2o5FNTGam2M1Sxi2Yw7bE05D0DOjYiJ/ZFN5VB+DLJv5YyoIQLAe+ll
        NYC4UNvx5sE7P/7kT21PF7GjKuYkgzWP+GHsrpCL+pMBDhNTc9MhVsY8GUVUT+6AB2z2+9Sc58dQH
        hNoW4x0g==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1masvd-001azO-KR; Thu, 14 Oct 2021 05:05:17 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>, linux-um@lists.infradead.org,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next] net: intel: igc_ptp: fix build for UML
Date:   Wed, 13 Oct 2021 22:05:16 -0700
Message-Id: <20211014050516.6846-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On a UML build, the igc_ptp driver uses CONFIG_X86_TSC for timestamp
conversion. The function that is used is not available on UML builds,
so have the function use the default system_counterval_t timestamp
instead for UML builds.

Prevents this build error on UML:

../drivers/net/ethernet/intel/igc/igc_ptp.c: In function ‘igc_device_tstamp_to_system’:
../drivers/net/ethernet/intel/igc/igc_ptp.c:777:9: error: implicit declaration of function ‘convert_art_ns_to_tsc’ [-Werror=implicit-function-declaration]
  return convert_art_ns_to_tsc(tstamp);
../drivers/net/ethernet/intel/igc/igc_ptp.c:777:9: error: incompatible types when returning type ‘int’ but ‘struct system_counterval_t’ was expected
  return convert_art_ns_to_tsc(tstamp);

Fixes: 68f5d3f3b654 ("um: add PCI over virtio emulation driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-um@lists.infradead.org
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: intel-wired-lan@lists.osuosl.org
---
 drivers/net/ethernet/intel/igc/igc_ptp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20211013.orig/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ linux-next-20211013/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -773,7 +773,7 @@ static bool igc_is_crosststamp_supported
 
 static struct system_counterval_t igc_device_tstamp_to_system(u64 tstamp)
 {
-#if IS_ENABLED(CONFIG_X86_TSC)
+#if IS_ENABLED(CONFIG_X86_TSC) && !defined(CONFIG_UML)
 	return convert_art_ns_to_tsc(tstamp);
 #else
 	return (struct system_counterval_t) { };
