Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12ED842D1CE
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 07:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbhJNFIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 01:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhJNFIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 01:08:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C09CC061570;
        Wed, 13 Oct 2021 22:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=Rr5zZ6rN525EfM/CGmlkNwg2FaH9Hx3btifOz7Ng8DU=; b=GHCy1KWtBfu5MaFJDZ+uSLIaZV
        xoYBtQnqNIRvx9Dt5uWY3NRZpv1Re8mir3hNRvA/RmdWtrOfSgM/DGjro3Ob+K4zWWflcTXwwiGu8
        Pcisq0IuwJAEt1qhygm989YnkH+FNEpYdfiPRcmoZLDmwC65KpPGGcKxMogTn7h8ZOHtDma+742+n
        U13ampz8d7roFL/rkOxlnKT0/3RhXOyan6P+WhF0vPp/77r2KOaE7AYrAqv8B9ckO9CAWAidUBRX4
        NtWHWWmynP61aI4ZoNwjizQA5LMQ7rI5ivQppyp4Ndw67fdshFglLkdkTaKUbITLRiyG08J5PAsmx
        gW4X9SJQ==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1maswR-001b4E-KS; Thu, 14 Oct 2021 05:06:07 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>, linux-um@lists.infradead.org,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-parisc@vger.kernel.org
Subject: [PATCH net-next] net: tulip: winbond-840: fix build for UML
Date:   Wed, 13 Oct 2021 22:06:06 -0700
Message-Id: <20211014050606.7288-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On i386, when builtin (not a loadable module), the winbond-840 driver
inspects boot_cpu_data to see what CPU family it is running on, and
then acts on that data. The "family" struct member (x86) does not exist
when running on UML, so prevent that test and do the default action.

Prevents this build error on UML + i386:

../drivers/net/ethernet/dec/tulip/winbond-840.c: In function ‘init_registers’:
../drivers/net/ethernet/dec/tulip/winbond-840.c:882:19: error: ‘struct cpuinfo_um’ has no member named ‘x86’
  if (boot_cpu_data.x86 <= 4) {

Fixes: 68f5d3f3b654 ("um: add PCI over virtio emulation driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-um@lists.infradead.org
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-parisc@vger.kernel.org
---
 drivers/net/ethernet/dec/tulip/winbond-840.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20211013.orig/drivers/net/ethernet/dec/tulip/winbond-840.c
+++ linux-next-20211013/drivers/net/ethernet/dec/tulip/winbond-840.c
@@ -877,7 +877,7 @@ static void init_registers(struct net_de
 		8000	16 longwords		0200 2 longwords	2000 32 longwords
 		C000	32  longwords		0400 4 longwords */
 
-#if defined (__i386__) && !defined(MODULE)
+#if defined (__i386__) && !defined(MODULE) && !defined(CONFIG_UML)
 	/* When not a module we can work around broken '486 PCI boards. */
 	if (boot_cpu_data.x86 <= 4) {
 		i |= 0x4800;
