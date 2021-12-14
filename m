Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571B1474E27
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 23:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237921AbhLNWpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 17:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234699AbhLNWoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 17:44:30 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F05C061751;
        Tue, 14 Dec 2021 14:44:29 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id r25so67605423edq.7;
        Tue, 14 Dec 2021 14:44:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4eIBpE5JL23eJLpbXYARtkXjBt7PEvR6KJPTH926Cjw=;
        b=J3NW0fXEvwaOGalEbfYRPGBDlh/q9Ft4mz6qKSwbZfBdeTLgA4rQt/XNgLMA9arWyM
         EIR9+THF13Hi7yL/7b849jRoksuCw9Pu7dfwnQSw6V7KLPRG8SIH6N6Lu7Af77LNoKdi
         H7xmxCrDCru6btHnlVE4fK0dCf8Ao/4VMAJt2hPCDUpZIpWjz2la7FSwyPaoOiqMj6FM
         JBZGwWSGF/mc9zzJZEvPyh24sQ41DAbdBa0EaTs52JZUNKg1ynN2V1ujwF3kWpt0aldW
         1SVxb0/MM4pbRRh0tfMDz93Y201BFZVYvC+KzkUuO5DhCrZVLeLpUj9rDNKyal0ukdGQ
         dw8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4eIBpE5JL23eJLpbXYARtkXjBt7PEvR6KJPTH926Cjw=;
        b=o3uxs1tJsAtW0lU37qwtiio7AlvFHLnmLs2cqrI0kraPBC3n3TdvwTJIgSbb3QpuoL
         K6LSjr6VffTybtgzjLkjPjYuHt81ZMx+nwOq36mv6DkSzp2ab1SiHqCsmOy7ygVYxY7N
         6Bwq4ydY5KzHhAuYAHA0eJhZGZ205ZsXXcYF0b0CC37zfWbKTW4eDU+XzrbfgKMpfYlv
         ND/6QvTS/kim8bapDuhqPPo/49BUJEGKAjlGUY1s9bKOGJxxIcoMyGr4ojWbF1kB01bm
         zpillDcHn35P82V2kOM2FdA76NEaBnwegAKHI/8LBhBggqws0iGmJfWG20f7YFKMQULC
         n5gQ==
X-Gm-Message-State: AOAM532OJrZIEhEK6OUWGU3Ci1k2YVN86FKZV/TB+Rylwedl/Hc11u0r
        6SvB4F1c5KSrYQ/6g+Vwgow=
X-Google-Smtp-Source: ABdhPJwJy0OMf7FFRno7tU0NOOPYFzgEH3CxD6kQjCBzW5vLUJOv7vo5pcXt/kis7rfIb9FuxyesXg==
X-Received: by 2002:a17:906:fcbb:: with SMTP id qw27mr8386819ejb.320.1639521868424;
        Tue, 14 Dec 2021 14:44:28 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id b19sm39008ejl.152.2021.12.14.14.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 14:44:28 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH RFC v6 07/16] net: dsa: tag_qca: enable promisc_on_master flag
Date:   Tue, 14 Dec 2021 23:44:00 +0100
Message-Id: <20211214224409.5770-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211214224409.5770-1-ansuelsmth@gmail.com>
References: <20211214224409.5770-1-ansuelsmth@gmail.com>
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

