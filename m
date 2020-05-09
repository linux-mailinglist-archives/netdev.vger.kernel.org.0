Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2630F1CC214
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 16:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgEIOQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 10:16:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33171 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727857AbgEIOQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 10:16:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589033803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rHjTn2dsi89n+bmwnI8/mn+rjn6MipnID9zbEJHvSgc=;
        b=i2pXYAt9OlyxcUibsmfPSlwr2Qasef9wuvj4j52JvhPLJmumezExtTu89hLbWSVh6CsoXa
        qKaJnjelV0ZsWJ2L1emhEuK83DAhnJjnNyXy4QRmzIM0JHYUvby+13cKkHWbRuyUsdCA47
        HGLLhQKB6tu/FZRUBjZhzDO0mJzSzIs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-lfE60qrmNmmQNfkccNOfKA-1; Sat, 09 May 2020 10:16:40 -0400
X-MC-Unique: lfE60qrmNmmQNfkccNOfKA-1
Received: by mail-wr1-f71.google.com with SMTP id y7so2430396wrd.12
        for <netdev@vger.kernel.org>; Sat, 09 May 2020 07:16:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rHjTn2dsi89n+bmwnI8/mn+rjn6MipnID9zbEJHvSgc=;
        b=RCwDqt+cTxUMbmKOhh2ZxfD1Fypk/9OJNW6KASqIiIQLEXkn8pGMUu2PKrzCWwBC3y
         sgvgIOdgJWy5NVdf4hkcGErhgTA6wSgqu9FCwSsmX3tY3fdp3GxKDVSE0nfTuAVH4G+k
         oFeCIZU1wRJNqWjPDwX7pxYmROgMnGlz1aNwlJ/CwyJso/4Eos2m+/D8Ln4REPgXwQvt
         X4u/0hoqBqmtzjKMlMbM14apKnw2eJY6j9ahrUgIlMGDSm6IT1FazU4zrchfKjcE82q2
         VeiNjpanb8Y8NZD5hUHP68bmkmY+6PSYA/AmKjdw38RNz/df4raIByauKwfUiLShpUba
         VFmw==
X-Gm-Message-State: AGi0PuaC2L1OXRLTom6dazR7eUBfHuVgaYA1ECBptSg8xLXuXpD3On66
        etN8gI704hcNfxMVAOwFSgHIk+kk4bjKMHmuUhg7QrcfoE6TDgvWwoIfvtwNF4kgnmofyQzmdUH
        cmJ22BlsJmS8Ow/lT
X-Received: by 2002:a1c:7f86:: with SMTP id a128mr21548976wmd.95.1589033798883;
        Sat, 09 May 2020 07:16:38 -0700 (PDT)
X-Google-Smtp-Source: APiQypKREsLCLIr+USziB/WduDKj8G7m2OP44M3QbttWguPUKJjf4TtfLBWVR5wkFGD4Q6idIx3zhw==
X-Received: by 2002:a1c:7f86:: with SMTP id a128mr21548958wmd.95.1589033798686;
        Sat, 09 May 2020 07:16:38 -0700 (PDT)
Received: from turbo.teknoraver.net (net-2-44-90-75.cust.vodafonedsl.it. [2.44.90.75])
        by smtp.gmail.com with ESMTPSA id p23sm12668665wmj.37.2020.05.09.07.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2020 07:16:38 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Stefan Chulski <stefanc@marvell.com>
Subject: [PATCH net] mvpp2: enable rxhash only on the first port
Date:   Sat,  9 May 2020 16:15:46 +0200
Message-Id: <20200509141546.5750-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently rxhash only works on the first port of the CP (Communication
Processor). Enabling it on other ports completely blocks packet reception.
This patch only adds rxhash as supported feature to the first port,
so rxhash can't be enabled on other ports:

	# ethtool -K eth0 rxhash on
	# ethtool -K eth1 rxhash on
	# ethtool -K eth2 rxhash on
	Cannot change receive-hashing
	Could not change any device features
	# ethtool -K eth3 rxhash on
	Cannot change receive-hashing
	Could not change any device features

Fixes: 895586d5dc32 ("net: mvpp2: cls: Use RSS contexts to handle RSS tables")
Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 2b5dad2ec650..ba71583c7ae3 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5423,7 +5423,8 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 			    NETIF_F_HW_VLAN_CTAG_FILTER;
 
 	if (mvpp22_rss_is_supported()) {
-		dev->hw_features |= NETIF_F_RXHASH;
+		if (port->id == 0)
+			dev->hw_features |= NETIF_F_RXHASH;
 		dev->features |= NETIF_F_NTUPLE;
 	}
 
-- 
2.26.2

