Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF9CE8BACE
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 15:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbfHMNwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 09:52:49 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34390 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729190AbfHMNwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 09:52:49 -0400
Received: by mail-pg1-f193.google.com with SMTP id n9so45081284pgc.1
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 06:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ovjpjEPWfmUvAod/JC35mVWcJd1XFmKfCBJPpIAqywg=;
        b=pRq0mDZULKRztISYp1SfbBxGzObaiE8imA9owDUVRWKGXQGBl0WAqvNHD8aN1dtn6Z
         lGcUZO9KgBHb/A3UiBXu5E8KuPfTWh0WQSQYIibVLnNaDzYjYm98SQQ+PE38KOcNfjBL
         1u+66REJrirqjrEm1O9wJTTucXReCIihn7l6KoyDALfkQRhzstaaYAObZXbVqg8yXhQY
         GjadeSoaAQPeOXbQ8QNaXYJyYjq912GeddpY/onhtD8r5scYS6Mg6Sc87W3JkTqrZVsb
         6A1HH59c7ddD504AsWxV44vVchJ7R0jbUV3flE77HnFAC4AcosS0toAeQtVaPyoCnk85
         JHUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ovjpjEPWfmUvAod/JC35mVWcJd1XFmKfCBJPpIAqywg=;
        b=pXP+TlkhJ6AjXW9g/yR6t7sdxaTt6j3ZSkmdBtXJkIyrBEa8vT24VZGftTzMwNBqtj
         OcvgTmmHeOCL6r23PbIIjFopX3SMEB0vkD4S3Ol9AJWKOFKQ/gwXK9PM6ph+Rli99phi
         RjqU6gsTmaX7yrK/pnjm9Xd22ihfocvDMWXddOmdG7Ppc1M72isfD7V9mehEMne2LeE/
         TnkK0FC6yNoKfv6rG/h29ypU2tsnh0hkPgpiKaF/QEKPbWLaX4hJeEpXNzPBFpGjNvrD
         vliTl+fzsUXPE04X/cWHA+f7G739v/kBwzYoCMKiXwlM60VOOmdRLLg1aKvOpwj8hwsN
         IcCA==
X-Gm-Message-State: APjAAAVeImRi9v1dKfFkjZIMuKXBOKhip60qTDScip90Rk3M6EDYzLY3
        5xK4FPRDl3bH/8gzvalQhd6r1vAK66KcDA==
X-Google-Smtp-Source: APXvYqzHVphhQ0eWY746zq1oOHSga6tavL3b6S6g1nSYkf1JpkZRloIjSxw0uV+o9OZ/5HwxZug1mw==
X-Received: by 2002:a62:cdc3:: with SMTP id o186mr41422938pfg.168.1565704368076;
        Tue, 13 Aug 2019 06:52:48 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t6sm34247035pgu.23.2019.08.13.06.52.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 06:52:47 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Madhu Challa <challa@noironetworks.com>,
        David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jianlin Shi <jishi@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] ipv6/addrconf: allow adding multicast addr if IFA_F_MCAUTOJOIN is set
Date:   Tue, 13 Aug 2019 21:52:32 +0800
Message-Id: <20190813135232.27146-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ip address autojoin is not working for IPv6 as ipv6_add_addr()
will return -EADDRNOTAVAIL when adding a multicast address.

Reported-by: Jianlin Shi <jishi@redhat.com>
Fixes: 93a714d6b53d ("multicast: Extend ip address command to enable multicast group join/leave on")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv6/addrconf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index dc73888c7859..ced995f3fec4 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1045,7 +1045,8 @@ ipv6_add_addr(struct inet6_dev *idev, struct ifa6_config *cfg,
 	int err = 0;
 
 	if (addr_type == IPV6_ADDR_ANY ||
-	    addr_type & IPV6_ADDR_MULTICAST ||
+	    (addr_type & IPV6_ADDR_MULTICAST &&
+	     !(cfg->ifa_flags & IFA_F_MCAUTOJOIN)) ||
 	    (!(idev->dev->flags & IFF_LOOPBACK) &&
 	     !netif_is_l3_master(idev->dev) &&
 	     addr_type & IPV6_ADDR_LOOPBACK))
-- 
2.19.2

