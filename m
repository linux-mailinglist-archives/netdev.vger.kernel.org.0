Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 069172998C7
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 22:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387664AbgJZVas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 17:30:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387588AbgJZVas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 17:30:48 -0400
Received: from localhost.localdomain (unknown [192.30.34.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89612207F7;
        Mon, 26 Oct 2020 21:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603747847;
        bh=LD/9TNQnrUu8vBtBBBr6HN9mRHCkAG1JzcNRgZIuFss=;
        h=From:To:Cc:Subject:Date:From;
        b=AmkM87HXTYOCoxtZ3kxeyJonodGVFniSH62c6M7OzRrU8+N82YsLKy8GQfhknXMoQ
         EJnJwtPL4O1f/bRdbnzjiV0cWYFs0IMExwD8Ol6AXLexHL/iCKvzbDwCHurw4P/4Q8
         nPs6vEnKFjZKCaNEVqvangcN+b2T5/Z5fkzvwvjI=
From:   Arnd Bergmann <arnd@kernel.org>
To:     Chas Williams <3chas3@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH net-next 01/11] atm: horizon: shut up clang null pointer arithmetic warning
Date:   Mon, 26 Oct 2020 22:29:48 +0100
Message-Id: <20201026213040.3889546-1-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Building a "W=1" kernel with clang produces a warning about
suspicous pointer arithmetic:

drivers/atm/horizon.c:1844:52: warning: performing pointer arithmetic
on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
  for (mem = (HDW *) memmap; mem < (HDW *) (memmap + 1); ++mem)

The way that the addresses are handled is very obscure, and
rewriting it to be more conventional seems fairly pointless, given
that this driver probably has no users.
Shut up this warning by adding a cast to uintptr_t.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/atm/horizon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/horizon.c b/drivers/atm/horizon.c
index 4f2951cbe69c..cd368786b216 100644
--- a/drivers/atm/horizon.c
+++ b/drivers/atm/horizon.c
@@ -1841,7 +1841,7 @@ static int hrz_init(hrz_dev *dev)
   
   printk (" clearing memory");
   
-  for (mem = (HDW *) memmap; mem < (HDW *) (memmap + 1); ++mem)
+  for (mem = (HDW *) memmap; mem < (HDW *) ((uintptr_t)memmap + 1); ++mem)
     wr_mem (dev, mem, 0);
   
   printk (" tx channels");
-- 
2.27.0

