Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83FB1AE87D
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 01:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbgDQXE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 19:04:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45444 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbgDQXE5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 19:04:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PF5lEC8BsnuweXc21+omeuXFblzwcTAqDLtvV4euvcI=; b=pPaGzJXKflMYK3cAo0OhKmkoSJ
        2LIG0MCT+AtuL0a1tT0aKgezdyjC9VMF0PSZydnc87Jk4f2R89q1kqiRneEyOKow4YcFJ/0pl1SKd
        GUTKbQMYCo4iQaLp5wyzGC9u7Q6/WrZjm/4K/n1qrmpVRGeSlRLKn9TNzloQD9RakW3U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jPa2J-003Mpe-2g; Sat, 18 Apr 2020 01:04:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 3/3] net: ethtool: self_test: Mark interface in testing operative status
Date:   Sat, 18 Apr 2020 01:03:50 +0200
Message-Id: <20200417230350.802675-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200417230350.802675-1-andrew@lunn.ch>
References: <20200417230350.802675-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an interface is executing a self test, put the interface into
operative status testing.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/ethtool/ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 89d0b1827aaf..593fa665f820 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1746,7 +1746,9 @@ static int ethtool_self_test(struct net_device *dev, char __user *useraddr)
 	if (!data)
 		return -ENOMEM;
 
+	netif_testing_on(dev);
 	ops->self_test(dev, &test, data);
+	netif_testing_off(dev);
 
 	ret = -EFAULT;
 	if (copy_to_user(useraddr, &test, sizeof(test)))
-- 
2.26.1

