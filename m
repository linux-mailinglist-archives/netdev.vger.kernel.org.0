Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3BA94715F8
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbhLKT65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:58:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231975AbhLKT6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:58:23 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CFA6C0617A1;
        Sat, 11 Dec 2021 11:58:23 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id y12so39236423eda.12;
        Sat, 11 Dec 2021 11:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5OJ4KZ3Wvo0KL3MZbU9A20ovDpRwukmdDwNvqmPd5Z0=;
        b=Lise8Fy0+dkn2OI43x7rNZ5Lu8jAguDwpy6S55WrJPu5bGbZUQYqZuzl50PtkWXqHP
         0kLA1WP7MHkCPIf/nR41qpAqQZoc+au2/F4dK0UDZ/sBKxtMi25F6n738gqf0W586Yga
         Pnn+AfqJIo6gGp9fcbr4RvZklGk1LFpw07TX325bCv5rInfoOLldmh3dYDAtBy8KUEbl
         MLZyQ9Gfswdm3AYlh9BIogq2S9KirW8/GZRMS+K0b0JSdQSobmDtf5VjZMeU9qy8KTL6
         5CZDs/LfkzhRu5CQLXgH5XTmxG1GJMlH3RjHVfoMwlzR2ttBl9LEITWjNonwy1TFf8Ll
         NMUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5OJ4KZ3Wvo0KL3MZbU9A20ovDpRwukmdDwNvqmPd5Z0=;
        b=rCDgI47hoSfHkg4Rf4GxapYKh4SN7sfgfJSDTrorhNSqGRzuvfnq50466VNL56wjcQ
         ED5brQdIY4+K4zzkJUvT4iP4T71v6EaqPXUBIkBf5XyXV6hMSbvdLz+NHKV9DTFHKW4r
         FOj/a7ohmYmFDg09VniMcjxawC+cE2qBdzLHZf6DVhFzDZnY+aVPvszynKMLeMUgyvGa
         sGveOIZTbvzkdx6/RX5M3R70E/abBsW9kUjcIWES15ixnZ+kp2OvwQz1rq2H9Z6H6jOo
         ORRmt++mZu4NpcWj6UfN9R3pOtq5E+wG21Ao24thsZkMefhObyB/p4kQYRLjtngignUJ
         6Ruw==
X-Gm-Message-State: AOAM531ulPM2IeLjTRKqEmJoOv86O8P+Q19sllVhaRin0PMnAaeNDdD3
        P/5/yVdUOG/zVnWZA/CD120=
X-Google-Smtp-Source: ABdhPJz3ItItpveSMJlx+FiRqXJHzLL33W5fRUVI4I9PQqmMMiGRGHVt0Ea79VwipBIXiTzJG9p08Q==
X-Received: by 2002:a17:907:3ea7:: with SMTP id hs39mr34080738ejc.164.1639252701856;
        Sat, 11 Dec 2021 11:58:21 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id e15sm3581479edq.46.2021.12.11.11.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 11:58:21 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH v4 07/15] net: da: tag_qca: enable promisc_on_master flag
Date:   Sat, 11 Dec 2021 20:57:50 +0100
Message-Id: <20211211195758.28962-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211211195758.28962-1-ansuelsmth@gmail.com>
References: <20211211195758.28962-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ethernet MDIO packets are non-standard and DSA master expects the first
6 octets to be the MAC DA. To address these kind of packet, enable
promisc_on_master flag for the tagger.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 net/dsa/tag_qca.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index 34e565e00ece..f8df49d5956f 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -68,6 +68,7 @@ static const struct dsa_device_ops qca_netdev_ops = {
 	.xmit	= qca_tag_xmit,
 	.rcv	= qca_tag_rcv,
 	.needed_headroom = QCA_HDR_LEN,
+	.promisc_on_master = true,
 };
 
 MODULE_LICENSE("GPL");
-- 
2.32.0

