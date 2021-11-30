Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0948D462CE5
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 07:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbhK3GnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 01:43:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbhK3GnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 01:43:00 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3034EC061574
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 22:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=mBTj9I4bPELs0gmVLF5+MfOfgPVZkwnwY9OPSSXiAyI=; b=n7R7pub8RzpPxJC4QYTVsz/P+P
        gppBaRMYwdgmyUcr1C8Vkzdq2BX0WDojclMeJcVzXFTs1dEVClNPGoO3mUvQ7QWoHWW4PdLCdAqZD
        b592m2r1Or2CtDx0dm9OUs/Cx7bsOE4ZaNz30zRcEx2CgAF4I1iYOsB7K1e8xp2yJxiKvlo1VY9Me
        7xbr7z+wY26v+1vDRe7TtrWJPnpZxEzjDgSeH1lTzrPbmBSMN4jLvb9uG7OORmpFEuKlxgittoE8F
        Ol51oLr4lqqR8PDRd5myLtNDu1TNtXRrK8Kj5U/vziXmjVszEB7EitjLbYKbIV0OCkI8u7U6LN2F5
        XnHs8lGA==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mrwnk-003ozd-4x; Tue, 30 Nov 2021 06:39:40 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        linux-xtensa@linux-xtensa.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 1/2 -net] natsemi: xtensa: allow writing to const dev_addr array
Date:   Mon, 29 Nov 2021 22:39:39 -0800
Message-Id: <20211130063939.6929-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let the compiler know that it's ok to write to this const field.

Fixes these build errors:

../drivers/net/ethernet/natsemi/xtsonic.c: In function 'sonic_probe1':
../drivers/net/ethernet/natsemi/xtsonic.c:166:36: error: assignment of read-only location '*(dev->dev_addr + (sizetype)(i * 2))'
  166 |                 dev->dev_addr[i*2] = val;
../drivers/net/ethernet/natsemi/xtsonic.c:167:38: error: assignment of read-only location '*(dev->dev_addr + ((sizetype)(i * 2) + 1))'
  167 |                 dev->dev_addr[i*2+1] = val >> 8;

Fixes: 74f2a5f0ef64 ("xtensa: Add support for the Sonic Ethernet device for the XT2000 board.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-xtensa@linux-xtensa.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/natsemi/xtsonic.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- linux-next-20211129.orig/drivers/net/ethernet/natsemi/xtsonic.c
+++ linux-next-20211129/drivers/net/ethernet/natsemi/xtsonic.c
@@ -125,6 +125,7 @@ static int __init sonic_probe1(struct ne
 	unsigned int silicon_revision;
 	struct sonic_local *lp = netdev_priv(dev);
 	unsigned int base_addr = dev->base_addr;
+	unsigned char *devadr;
 	int i;
 	int err = 0;
 
@@ -161,10 +162,10 @@ static int __init sonic_probe1(struct ne
 	SONIC_WRITE(SONIC_CMD,SONIC_CR_RST);
 	SONIC_WRITE(SONIC_CEP,0);
 
-	for (i=0; i<3; i++) {
+	for (i=0, devadr = (unsigned char *)dev->dev_addr; i<3; i++) {
 		unsigned int val = SONIC_READ(SONIC_CAP0-i);
-		dev->dev_addr[i*2] = val;
-		dev->dev_addr[i*2+1] = val >> 8;
+		devadr[i*2] = val;
+		devadr[i*2+1] = val >> 8;
 	}
 
 	lp->dma_bitmode = SONIC_BITMODE32;
