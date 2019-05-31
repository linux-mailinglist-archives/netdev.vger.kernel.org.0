Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7F5D3178F
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 01:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfEaXMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 19:12:39 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:34866 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbfEaXMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 19:12:39 -0400
Received: by mail-qk1-f194.google.com with SMTP id l128so7450049qke.2
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 16:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8jGpMxBDyOT7KerzGZ04QQZ3tNmxUEm8+RdxKKHJt78=;
        b=EtxmoUI/MXZc1xoAYvvhygB5WtIP/HYEfEqmyB2ngK7nKbJPtA60SheJ7WGDHOthmA
         klKNjn3aGTR0xQwwHhAorZ3+2TfAhnRikAsQV/fkN4X84HqfdlHO4Ztv3Pq1Ugxecupr
         DM/5BWFEd1qfOoff1ZBEYmPdYVI/TRsb053DWBVWFgie50rvMy1As86KBNCF0czQG9LW
         +H6pKO318XpicgJN021xZqZUBrUJNcGB4wFL+pP99hito7D2liadJyMjrn4O0/blRL7V
         byTDg7YeEzml8SK5dPveFarH6JzvWH1Wfu5/xw//XTdcqHs60Y59c1IkVV8TKCzIhL5U
         Ek9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8jGpMxBDyOT7KerzGZ04QQZ3tNmxUEm8+RdxKKHJt78=;
        b=iYgY1ln+DqBxIgPnkjzzuYn4mt5TGq15iNOEay+5cQgT2YSyadYvbUOwpEjNUIsuFz
         /7E9E7LOIGeW8AhZlEGy5G0FLF9W38YFTy6+eBq3OipLGcGdVYX8p5J+sR8xtQ9d8Rbs
         f0ZjXtSWPUWFRVFPmpJuO1LpE463Dh7Lhg4qFbP5eNndpTtPLrL5I85+4iRU1ZABEya9
         tWFNr+YmYZHLVbLMQeY1JZdiI1juYvnWhSqeVVNo+zOnL9sv79qXRJ86DTRs/zckOZAY
         oPMiOxLzvEoH1yAAbyot87gvPvFdMGaaRNoBm0EIL7yo0c3vb+V98a8kgAJh/ZZoyEwn
         B2dw==
X-Gm-Message-State: APjAAAWmZDAeRdfWVnksjDRHCwEg9WKh28Y+qC8h6YtrQbZAzf9GcRDU
        4dF0Z5YYaN3Cx5dU6OWAxMwJKEl9VeU=
X-Google-Smtp-Source: APXvYqx/7XKSDajzjTjoxhLkoQQ5BPOOsX0dzBvyOeCfrm+ZMPPL1hsceDeLdNH3vPqzqQ+dJCMm5A==
X-Received: by 2002:a37:b1c5:: with SMTP id a188mr10827972qkf.51.1559344358602;
        Fri, 31 May 2019 16:12:38 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id f34sm4085089qta.19.2019.05.31.16.12.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 May 2019 16:12:38 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>, linville@redhat.com,
        f.fainelli@gmail.com, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net] ethtool: fix potential userspace buffer overflow
Date:   Fri, 31 May 2019 19:12:21 -0400
Message-Id: <20190531231221.29460-1-vivien.didelot@gmail.com>
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

Userspace may actually allocate a smaller buffer for registers dump,
for instance ethtool does that when dumping the raw registers directly
into a fixed-size file.

Because the current code uses the regs.len value potentially updated by
the driver when copying the buffer back to userspace, we may actually
cause a userspace buffer overflow in the final copy_to_user() call.

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

