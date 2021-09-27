Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59BA41A180
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 23:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237267AbhI0VuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 17:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237009AbhI0VuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 17:50:05 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7407BC061575
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 14:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=kmnCCl7YzOVDnM3V/AysBDGb3zIQhhYsnuxom0rubl8=; b=klH4b5MkAAq2Nyivz2uRzhvyMw
        1so4XvGPcUvTjckDy+xfuzRHu7FpxMdHs80deRfLg7n5V2OmgShu0TyuHIzRBiHcYYsSi2Ow6ztE3
        umQ8xzDBu1FdmGJslW1U2QZnWzHkVQ3MFSoWOGlfEiSYra3LB9RUsaAWqDOq3Q39qGR+86X9ETknj
        8o8qaZzswr8JEsrJH7L2or2IxibGUp9MWeAyvvN0fuyImaEhPV6DS73NJEG82UYsBNPScMtzp2qNz
        6N/wTaz68lY0WFjCiNCiAQCakM9sSPKhWhCkFs1g1p2SA5XnoFFmARRQune7ltYjR5+tBXQaDWXbW
        igx+IVig==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mUyU4-004R2O-CW; Mon, 27 Sep 2021 21:48:24 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Aaron Young <aaron.young@oracle.com>,
        Rashmi Narasimhan <rashmi.narasimhan@oracle.com>
Subject: [PATCH net] net: sun: SUNVNET_COMMON should depend on INET
Date:   Mon, 27 Sep 2021 14:48:23 -0700
Message-Id: <20210927214823.13683-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_INET is not set, there are failing references to IPv4
functions, so make this driver depend on INET.

Fixes these build errors:

sparc64-linux-ld: drivers/net/ethernet/sun/sunvnet_common.o: in function `sunvnet_start_xmit_common':
sunvnet_common.c:(.text+0x1a68): undefined reference to `__icmp_send'
sparc64-linux-ld: drivers/net/ethernet/sun/sunvnet_common.o: in function `sunvnet_poll_common':
sunvnet_common.c:(.text+0x358c): undefined reference to `ip_send_check'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Aaron Young <aaron.young@oracle.com>
Cc: Rashmi Narasimhan <rashmi.narasimhan@oracle.com>
---
Fixes: prior to 31762eaa0d08 ("ldmvsw: Split sunvnet driver into common code")
[I don't have enough git fu to go back beyond this.]

 drivers/net/ethernet/sun/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20210927.orig/drivers/net/ethernet/sun/Kconfig
+++ linux-next-20210927/drivers/net/ethernet/sun/Kconfig
@@ -73,6 +73,7 @@ config CASSINI
 config SUNVNET_COMMON
 	tristate "Common routines to support Sun Virtual Networking"
 	depends on SUN_LDOMS
+	depends on INET
 	default m
 
 config SUNVNET
