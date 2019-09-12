Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 838C1B0FAE
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 15:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732044AbfILNQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 09:16:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42554 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731895AbfILNQy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 09:16:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version
        :Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hmJTFW0ji6tacYpYS7wCNWS/Fbqw2O8sMFBRx38fDD0=; b=cmIKtlXboRsFKQ8iFZcb6m3/Cm
        s26LP0B3vt+1Uu53xM8WcHVozcvbKi9z2+qYyRLkLp1QchGzU5w6NinKke9GOL7LpvjACtmxC0Ypp
        dIKIYc/wlYTP9t0Pku8X/kKZixxnTvvxTPTmIyPdeH9p2yKvtFbCO1s5SGihHSxd4VN4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i8Oxu-0006SN-88; Thu, 12 Sep 2019 15:16:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net] net: dsa: Fix load order between DSA drivers and taggers
Date:   Thu, 12 Sep 2019 15:16:45 +0200
Message-Id: <20190912131645.24782-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DSA core, DSA taggers and DSA drivers all make use of
module_init(). Hence they get initialised at device_initcall() time.
The ordering is non-deterministic. It can be a DSA driver is bound to
a device before the needed tag driver has been initialised, resulting
in the message:

No tagger for this switch

Rather than have this be fatal, return -EPROBE_DEFER so that it is
tried again later once all the needed drivers have been loaded.

Fixes: d3b8c04988ca ("dsa: Add boilerplate helper to register DSA tag driver modules")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---

I did wonder if we should play with the core and tag drivers and make
them use subsystem_initcall(), but EPROBE_DEFER seems to be the more
preferred solution nowadays.
---
 net/dsa/dsa2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 3abd173ebacb..96f787cf9b6e 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -623,6 +623,8 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master)
 	tag_protocol = ds->ops->get_tag_protocol(ds, dp->index);
 	tag_ops = dsa_tag_driver_get(tag_protocol);
 	if (IS_ERR(tag_ops)) {
+		if (PTR_ERR(tag_ops) == -ENOPROTOOPT)
+			return -EPROBE_DEFER;
 		dev_warn(ds->dev, "No tagger for this switch\n");
 		return PTR_ERR(tag_ops);
 	}
-- 
2.23.0

