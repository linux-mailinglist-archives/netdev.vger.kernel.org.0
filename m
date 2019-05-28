Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E13D12D0C0
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 22:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbfE1U7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 16:59:01 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38197 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbfE1U7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 16:59:00 -0400
Received: by mail-qk1-f193.google.com with SMTP id a27so37372qkk.5;
        Tue, 28 May 2019 13:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8OG5YTy2amAAS/qn+s2N6XLhUflDWtxdckD99yPf3DI=;
        b=cSS6Fn0C7CACaxkDp6GLMMcORYCT0EBMBEumNEdHQJTs3K6ZXJTMPKelfAUths/xS8
         IsWKtNE1Hn7Usqci4YILTUqI/g0mDnmWYgHXBSqUW049PrzONPjVupAUafzm0tvsmdrS
         f9rfZzHJXK0qWXJyCwFp7enZ7hY3nru0DX6M27E3HtOADNrRnlily9padts4g+V0JTKY
         CgHeipUgeh36zsqhONMhq1xUSMerLxiKqZZnxtao8VVJ7L0yhzFWyPEAzyvdyvvIZNi6
         6z0LPlBI+YPrNaZWcmwL8os0HHr9jOqlhDp0WNL427XZ33+BAQEanRpjq/X9BQAhWOcQ
         Y78g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8OG5YTy2amAAS/qn+s2N6XLhUflDWtxdckD99yPf3DI=;
        b=H0WjbBXB0zUxeu6FmoxXvkIDMERAP3CXYXCAaeLH4btyhgXtidk8EfkgoNfjylYjOJ
         p/pCMguKh6drTzpmpik6zg1CtPF9PNf3NLJNpnFPtgD2miYyw2VJ/wpYM7y6i2DITK3E
         /uXcNgmo23I6zWwAzAxwUBONhskhjNYWbCvTYASnxamS3If8eiDv/u6USnDvJObNCTHh
         fUNIrmUr35VFh2vr3WHfEmWbbqAjnccIMds+5TQWNsON8bZT1oRIXy0ZX+xQwMqOmqGH
         12w6/f9OyBXAn8NIm3Aapbma8dwlaO+xQ39WPb8Lsw7xXzUfSs8hYmjOvAcab04Hd9wQ
         45lA==
X-Gm-Message-State: APjAAAVx5gnXK6FQkwS6Ck2i3PsUxERmu3AiDcvu9s76lVyDrnOKd2pZ
        hNk+cwqVSyUXs3s/PsWqdzRECyn/ves=
X-Google-Smtp-Source: APXvYqy0J1sT5+xUgQmRW/Lf5V0flZu6UcG2znDSxwoH0reffd86ZxYeB12kOA3GlwDdOzUPP6lb8w==
X-Received: by 2002:a37:a094:: with SMTP id j142mr6443579qke.2.1559077139649;
        Tue, 28 May 2019 13:58:59 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id k30sm5880055qte.49.2019.05.28.13.58.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 May 2019 13:58:59 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linville@redhat.com,
        f.fainelli@gmail.com
Subject: [PATCH net-next] ethtool: copy reglen to userspace
Date:   Tue, 28 May 2019 16:58:48 -0400
Message-Id: <20190528205848.21208-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ethtool_get_regs() allocates a buffer of size reglen obtained from
ops->get_regs_len(), thus only this value must be used when copying
the buffer back to userspace. Also no need to check regbuf twice.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/core/ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 4a593853cbf2..f3369f31d93a 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -1338,38 +1338,38 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
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

