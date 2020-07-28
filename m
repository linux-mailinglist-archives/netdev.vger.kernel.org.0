Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2EB0230306
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 08:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgG1GhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 02:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbgG1GhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 02:37:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD3DC0619D4
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 23:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=eVLgf6mf7XoEoaPERsg4sJOLSfAN6Omqo9f1ggAtEtw=; b=RraZofKtydVvZhbmY+dJhxKGsk
        EV6dxs/jgAPg+BwpdkDjLRHmlX6RCYLTiujPWhnqBaf3UmukvR88jdhnRZzP3wDG1/wEUfjafzJTL
        yS8CJo5U/z3L0bb8aRRoziF3FGywUKdPoovpECk19SP09Id2c0RGBoIVt38GpuvzZxAA65eTsDqtp
        e5+HVvFfL9suL/VKggTLrURmRjz4syQvGyngekkXBYyktZO5GuLNm9xorI3xx0sZZzpYir6D1P7er
        /6BQx9J66vsr0TdeeRX2w3M25TSTNstQ+V1NcJbR5U8WRiawPm3Zo9k9TNC9iA3rsgiGoFckYao1q
        BYXD0QzA==;
Received: from [2001:4bb8:180:6102:7902:553b:654a:8555] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0JEH-0006jl-6n; Tue, 28 Jul 2020 06:36:50 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jan Engelhardt <jengelh@inai.de>, Ido Schimmel <idosch@idosch.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        David Laight <David.Laight@ACULAB.COM>, netdev@vger.kernel.org
Subject: [PATCH 2/4] net: make sockptr_is_null strict aliasing safe
Date:   Tue, 28 Jul 2020 08:36:41 +0200
Message-Id: <20200728063643.396100-3-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200728063643.396100-1-hch@lst.de>
References: <20200728063643.396100-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While the kernel in general is not strict aliasing safe we can trivially
do that in sockptr_is_null without affecting code generation, so always
check the actually assigned union member.

Reported-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/sockptr.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/sockptr.h b/include/linux/sockptr.h
index 7d5cdb2b30b5f0..b13ea1422f93a5 100644
--- a/include/linux/sockptr.h
+++ b/include/linux/sockptr.h
@@ -64,7 +64,9 @@ static inline int __must_check init_user_sockptr(sockptr_t *sp, void __user *p)
 
 static inline bool sockptr_is_null(sockptr_t sockptr)
 {
-	return !sockptr.user && !sockptr.kernel;
+	if (sockptr_is_kernel(sockptr))
+		return !sockptr.kernel;
+	return !sockptr.user;
 }
 
 static inline int copy_from_sockptr(void *dst, sockptr_t src, size_t size)
-- 
2.27.0

