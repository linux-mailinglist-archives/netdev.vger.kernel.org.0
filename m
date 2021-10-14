Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A9642D1CA
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 07:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhJNFHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 01:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhJNFHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 01:07:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3504AC061570
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 22:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=pUhOvffUgdaRMsLNdO+OJlABBj1ygAcEK6RBWKzkh94=; b=F2EKzsH9diBbQJCbC9hPl0QC5/
        La0VtYb/5r9r8Ng2xchcvx8J9MbS9UWV/nC2pcc2NNgSGVt6mwtRuaK82TdcZR591/odOzL8J151k
        dd8qaUzuexxYK9MTi/SPnmtsQwDw1qQrWQnticWRo+i5NG8/DcxilZ0FuwydeeOJ+vtdft3NZZriA
        IQbs/XaQemQCmCrtvqrSDfXJzjfsp2ZC0zTVv5vsDDHVV8adNj1EsfjEhDqPHZPDJmeyrerjuKQQH
        gASsR2a8M/FdTI6zdSKvpwyja3dHZavbw81uClCWDwd4H+pIGozZz86HV2anEhDWw3YOwv9pJJw1Q
        kJdE6QhA==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1masvN-001axd-AG; Thu, 14 Oct 2021 05:05:01 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>, linux-um@lists.infradead.org,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: fealnx: fix build for UML
Date:   Wed, 13 Oct 2021 22:05:00 -0700
Message-Id: <20211014050500.5620-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On i386, when builtin (not a loadable module), the fealnx driver
inspects boot_cpu_data to see what CPU family it is running on, and
then acts on that data. The "family" struct member (x86) does not exist
when running on UML, so prevent that test and do the default action.

Prevents this build error on UML + i386:

../drivers/net/ethernet/fealnx.c: In function ‘netdev_open’:
../drivers/net/ethernet/fealnx.c:861:19: error: ‘struct cpuinfo_um’ has no member named ‘x86’

Fixes: 68f5d3f3b654 ("um: add PCI over virtio emulation driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-um@lists.infradead.org
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/fealnx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20211013.orig/drivers/net/ethernet/fealnx.c
+++ linux-next-20211013/drivers/net/ethernet/fealnx.c
@@ -857,7 +857,7 @@ static int netdev_open(struct net_device
 	np->bcrvalue |= 0x04;	/* big-endian */
 #endif
 
-#if defined(__i386__) && !defined(MODULE)
+#if defined(__i386__) && !defined(MODULE) && !defined(CONFIG_UML)
 	if (boot_cpu_data.x86 <= 4)
 		np->crvalue = 0xa00;
 	else
