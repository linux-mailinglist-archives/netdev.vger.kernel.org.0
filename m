Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F32833AA7
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbfFCWDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:03:42 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37704 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbfFCWDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:03:42 -0400
Received: by mail-qk1-f193.google.com with SMTP id d15so1526850qkl.4
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 15:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0Ej4J8CCT6nTH/wduGavRKvzjrElQsQ1ce2aVsNPgak=;
        b=GWrqqlACaIQYYf1EAB+crhrtYxkwZryE6heb/TmMbja++VkE3kq/xqHHxi6mKfZTAP
         tN08Y6kVtz4hR85DRRaTfuukhZuWtyDHTsH1MfGkHiAubJC0j3X1GSOVXQUZ1NjQ7Oom
         ksW8g0JslOaQ3vZgEv/IdOgEqN/hvxInX5m7ZL8mxJqV78LVUSp0XdHyORKUYzviFkRY
         Cpy7ARJ0zXm52iMHWVhNfELo+HPrsg5SWpBozSB7WTkKkfKYQ8pnLjgbe6TB0He3CUk6
         LTl9x8RZEl9SvuvzV7MXZ4UIS2H4S5kXPpAZogQJsy8OeLs9Jq6EqmslZKxgjOHuxSKn
         oSiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0Ej4J8CCT6nTH/wduGavRKvzjrElQsQ1ce2aVsNPgak=;
        b=bCj1eFXL9Z7qzRtohy8qGj4hTEns3N6wM/jORyUcIXtD3NOlWiVjeK5ReAnBwkxuUZ
         QD7q3e4H+ABFs/OB9dmEggHs583qF8FtQTkzKMNMfSy2p3PGSJszDxZsDrF7CL3fZCOj
         lbBRLlX0+WKWM3bv9HbmSGOLREdvCpgp4wQA9ryn067IczGxvyMHDj9/LEEFU4pCzzL3
         XD8h7ixEjQYsn6UGrqaHT0iLsSR2ZiK3IcaetHCGKNgfeQq9575uwVkLXtl5BoIGXG9w
         nLXqH2raxqSDoXJbVCcUtfs1IyqtEMZnmXHqJBcxyuR6QWlc4lS7w+Q6mMAh6zXgoMo3
         bvnw==
X-Gm-Message-State: APjAAAUe48k2m+wr2xJpWQmt4V2D5R6O76GmOVNnnbxTqoyRcx6ugd9B
        IT/AroBJphBVxCIzF6RbnyR5shhFE4Q=
X-Google-Smtp-Source: APXvYqz1OLObaWHvDyD7NwXAiTCn6zkf079V21ccS29gBW3QjWhjRnpp6GQGgr90PFrM4+SPSoa3yA==
X-Received: by 2002:a37:9a4d:: with SMTP id c74mr23874570qke.123.1559595459692;
        Mon, 03 Jun 2019 13:57:39 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id f16sm1617472qth.46.2019.06.03.13.57.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Jun 2019 13:57:38 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>, linville@redhat.com,
        f.fainelli@gmail.com, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net v2] ethtool: fix potential userspace buffer overflow
Date:   Mon,  3 Jun 2019 16:57:13 -0400
Message-Id: <20190603205713.28121-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ethtool_get_regs() allocates a buffer of size ops->get_regs_len(),
and pass it to the kernel driver via ops->get_regs() for filling.

There is no restriction about what the kernel drivers can or cannot do
with the open ethtool_regs structure. They usually set regs->version
and ignore regs->len or set it to the same size as ops->get_regs_len().

But if userspace allocates a smaller buffer for the registers dump,
we would cause a userspace buffer overflow in the final copy_to_user()
call, which uses the regs.len value potentially reset by the driver.

To fix this, make this case obvious and store regs.len before calling
ops->get_regs(), to only copy as much data as requested by userspace,
up to the value returned by ops->get_regs_len().

While at it, remove the redundant check for non-null regbuf.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/core/ethtool.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 43e9add58340..1a0196fbb49c 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -1338,38 +1338,41 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 static int ethtool_get_regs(struct net_device *dev, char __user *useraddr)
 {
 	struct ethtool_regs regs;
 	const struct ethtool_ops *ops = dev->ethtool_ops;
 	void *regbuf;
 	int reglen, ret;
 
 	if (!ops->get_regs || !ops->get_regs_len)
 		return -EOPNOTSUPP;
 
 	if (copy_from_user(&regs, useraddr, sizeof(regs)))
 		return -EFAULT;
 
 	reglen = ops->get_regs_len(dev);
 	if (reglen <= 0)
 		return reglen;
 
 	if (regs.len > reglen)
 		regs.len = reglen;
 
 	regbuf = vzalloc(reglen);
 	if (!regbuf)
 		return -ENOMEM;
 
+	if (regs.len < reglen)
+		reglen = regs.len;
+
 	ops->get_regs(dev, &regs, regbuf);
 
 	ret = -EFAULT;
 	if (copy_to_user(useraddr, &regs, sizeof(regs)))
 		goto out;
 	useraddr += offsetof(struct ethtool_regs, data);
-	if (regbuf && copy_to_user(useraddr, regbuf, regs.len))
+	if (copy_to_user(useraddr, regbuf, reglen))
 		goto out;
 	ret = 0;
 
  out:
 	vfree(regbuf);
 	return ret;
 }
-- 
2.21.0

