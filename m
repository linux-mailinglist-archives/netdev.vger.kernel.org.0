Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3446483F15
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 10:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiADJVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 04:21:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiADJVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 04:21:33 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FC6C061784;
        Tue,  4 Jan 2022 01:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=/EGiF3exvN0CmzCzzHj2LPHV2IaoCNuj0zydEgdxAKE=; b=Pt15MAngYfgJqqKX4nxiaLuLfe
        QKoioIJ57OZVAbpbRmhHVEwZLKRRbl0YSRQenum4jJg9v9GFSZMkGq/Y4YCpF9vBsXDZ0+/rAxNro
        5rw7jTN1M/7Hhfhuj855xCp5nkhUJ23hBnVGWw7tQYhfXuVC/eIT6k4m+1QO7sz+P/N93rDXwoWDA
        CC6wtP9nX0oi61HzMBjubVvAv4r4Tmb2UDWSo+ATNn7CFB8nlJ32uw77vR2m76uKlQp3lA23nCwUV
        0uPnk61gPWH40ZIsSNp1TRj4vUgPDRvpKmyKuCMfDdZB/sz/MLIqVlot+gnCxVsD7qN5szaxGTD/5
        r3M9jzZQ==;
Received: from [2001:4bb8:184:3f95:15c:3e66:a12b:4469] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n4g0X-00Axq0-5r; Tue, 04 Jan 2022 09:21:29 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     ralf@linux-mips.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] netrom: fix copying in user data in nr_setsockopt
Date:   Tue,  4 Jan 2022 10:21:26 +0100
Message-Id: <20220104092126.172508-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code used to copy in an unsigned long worth of data before
the sockptr_t conversion, so restore that.

Fixes: a7b75c5a8c41 ("net: pass a sockptr_t into ->setsockopt")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/netrom/af_netrom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 775064cdd0ee4..f1ba7dd3d253d 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -306,7 +306,7 @@ static int nr_setsockopt(struct socket *sock, int level, int optname,
 	if (optlen < sizeof(unsigned int))
 		return -EINVAL;
 
-	if (copy_from_sockptr(&opt, optval, sizeof(unsigned int)))
+	if (copy_from_sockptr(&opt, optval, sizeof(unsigned long)))
 		return -EFAULT;
 
 	switch (optname) {
-- 
2.30.2

