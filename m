Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77080F80A5
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 20:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfKKTyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 14:54:31 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42112 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbfKKTya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 14:54:30 -0500
Received: by mail-wr1-f65.google.com with SMTP id a15so15973299wrf.9;
        Mon, 11 Nov 2019 11:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=20txlUJ7gvdO0tkGUOgm6wj1CtIHPkIsh+wOv+owYcI=;
        b=P4kJDZB/+n6iZzdi6MJ8VWswH0+nwIov4JLWyezLlNxZCCAj1Bvi7W6ra1boWYqQ0S
         KREcpRcwhCKJDmweGXngjaN7g3evr/OcfhkI1rMXEvKd6CP+JIeeuqP0hFi+XHTgJdFY
         WUWLnEq8CvtgqoE4HXi7VeIa+Ptrz3IDC3oyfxO63prcF0xdefVbI5H89y/3p932e25V
         5UcE35XB+12Hu2AbaojaUoIeqWFEdeXCb4d55j1Y8s8ZjqohKTFLQAr+0Euox4nnIaeQ
         NDiipmZAa457pg4DRA2TuteOT5pnTN2NxhpVFA0zqbFWtEOEuPpJ08ZrNCjJdxKs+Ay1
         9sYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=20txlUJ7gvdO0tkGUOgm6wj1CtIHPkIsh+wOv+owYcI=;
        b=SSs8OhnFHw/KvVXbieSvdjuTPbRlP1jhkZs4r9Vj/6BOimbrR9vTkCJHE1rZOr/IMQ
         J7DdUlkn/caiv6rvATn/VBpxVh19p/xwpLPGazOCknkQvmXlQIfAYucBUTWjgAB2N9/p
         SWEJu0Tecyi4PDd0uLTJLsr8RRFAcVKUWUNZIaqgyOyUR8toThlMpoQ+lTXepLe/8JVv
         H4k1HlAgPPWyI9ZzjXV2lp05ko39//q9XDfGjMcriHvXr0n6Hfj3DdZZxylB7+5qhBeM
         AHdwR2lvZys2tBOgCDMzkErgGuIoupVFGq2NrDj5MbZvDyoOcniVROzZuCy3l8I23iTd
         EYNw==
X-Gm-Message-State: APjAAAVsMZUVSpUvlKnBXuWHM2H7d3+tlo9p8I/YYAJ/pQ1qMDRBwKjQ
        NhS6tXQN4nYbsdy+Z7jNPdAYL/ou
X-Google-Smtp-Source: APXvYqxM4ouUDp0Q8CtCJHhxFRTR2PXD3PKjDazSIR6Izp1yH9JZxYIERhoQzNWG8c4jPEI1PIGAug==
X-Received: by 2002:adf:da42:: with SMTP id r2mr21389542wrl.383.1573502067949;
        Mon, 11 Nov 2019 11:54:27 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z4sm552508wmf.36.2019.11.11.11.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 11:54:27 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     olteanv@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: dsa: Prevent usage of NET_DSA_TAG_8021Q as tagging protocol
Date:   Mon, 11 Nov 2019 11:54:20 -0800
Message-Id: <20191111195421.11619-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is possible for a switch driver to use NET_DSA_TAG_8021Q as a valid
DSA tagging protocol since it registers itself as such, unfortunately
since there are not xmit or rcv functions provided, the lack of a xmit()
function will lead to a NPD in dsa_slave_xmit() to start with.

net/dsa/tag_8021q.c is only comprised of a set of helper functions at
the moment, but is not a fully autonomous or functional tagging "driver"
(though it could become later on). We do not have any users of
NET_DSA_TAG_8021Q so now is a good time to make sure there are not
issues being encountered by making this file strictly a place holder for
helper functions.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/Kconfig     |  2 +-
 net/dsa/tag_8021q.c | 11 -----------
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 29e2bd5cc5af..136612792c08 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -20,7 +20,7 @@ if NET_DSA
 
 # tagging formats
 config NET_DSA_TAG_8021Q
-	tristate "Tag driver for switches using custom 802.1Q VLAN headers"
+	tristate
 	select VLAN_8021Q
 	help
 	  Unlike the other tagging protocols, the 802.1Q config option simply
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 9c1cc2482b68..f54f4a778821 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -341,14 +341,3 @@ struct sk_buff *dsa_8021q_remove_header(struct sk_buff *skb)
 	return skb;
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_remove_header);
-
-static const struct dsa_device_ops dsa_8021q_netdev_ops = {
-	.name		= "8021q",
-	.proto		= DSA_TAG_PROTO_8021Q,
-	.overhead	= VLAN_HLEN,
-};
-
-MODULE_LICENSE("GPL v2");
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_8021Q);
-
-module_dsa_tag_driver(dsa_8021q_netdev_ops);
-- 
2.17.1

