Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F87474D02
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 22:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237846AbhLNVKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 16:10:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237809AbhLNVKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 16:10:35 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662F4C061401;
        Tue, 14 Dec 2021 13:10:35 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id x15so68470834edv.1;
        Tue, 14 Dec 2021 13:10:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4eIBpE5JL23eJLpbXYARtkXjBt7PEvR6KJPTH926Cjw=;
        b=HAoD2GZCMeVAp0AXTnKr2YjwAEzTw0m5V1CMDUVfdWgu3eaaRJqtfWzZDcKQwaat7E
         YYavXHiae3uyPYhixF9ipzggRn3Henh6jvmY9PceDF+xrXK870Br5lKa4RlCeN39fZlo
         NmT1pbYNrsmsEn0jBKM+3b8aw6ThKdqf0zS+NsDwXWBh5hOuvAs7Py+m68XYZ+lwGTAC
         nBitGI+OD+lHHQUjAQKk0Lw1J3m+wEElEMf+cwznkjWXCOR8sHrJ+cC6MObm27VE33vD
         XTOLz7z6W81LZ4lu7PamEkf53EVPJ8gv2Js2Rxmqt7a0JBSu/C0QKeh4gPZbgOp1NkuY
         YE1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4eIBpE5JL23eJLpbXYARtkXjBt7PEvR6KJPTH926Cjw=;
        b=TZBI/fo9bS7Ep80OC+fRaP9NHgUgrcQ8TTJxgsvNNG3YcTYwyD8Q+aF5b1SE+tHhSE
         ZgeYuZGO002RinsgkAD3HxEz1//69WIBi3zX+5vDa1aN7+jsrJx1kqpLTi+uCgfaIbVf
         oFgA3IWE7nMfi5McsWuaBVmMFd0RQ07D8A1rGx2E7ynEzS2WOt4XNzD+1FE5YymNFEdK
         Ra/b/G1/nOUc4JnqET94GQxmQWXAqI+Gwo0SeL14D/MZwBs4/rx5UZbYhIajdE2D3mq+
         37IGcNl2kVBJzSsMUpy+4PYS8r1BX9mJ6mEDMG9sNscjLxHH54m/30mhjMVKfytdzhyk
         VNCg==
X-Gm-Message-State: AOAM5321JwmqeO+BNm/ljhB2CBSI0TYJSxwxoewXAbY8sEQxViHDK3km
        deIkC9Osd9tNcJ++UUutTSg=
X-Google-Smtp-Source: ABdhPJyqawfzr0FTMCH1+TlwrKo9tsxlsoAxQNoJHC9ucHM/mWbc44YgCg/HEnM4NZrSdRakUCd+Fg==
X-Received: by 2002:a50:da48:: with SMTP id a8mr10948919edk.146.1639516233910;
        Tue, 14 Dec 2021 13:10:33 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id b4sm261034ejl.206.2021.12.14.13.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 13:10:33 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH RFC v5 07/16] net: dsa: tag_qca: enable promisc_on_master flag
Date:   Tue, 14 Dec 2021 22:10:02 +0100
Message-Id: <20211214211011.24850-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211214211011.24850-1-ansuelsmth@gmail.com>
References: <20211214211011.24850-1-ansuelsmth@gmail.com>
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
2.33.1

