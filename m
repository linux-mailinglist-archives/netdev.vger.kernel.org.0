Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0151525BD7
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 04:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbfEVCCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 22:02:17 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46454 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfEVCCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 22:02:17 -0400
Received: by mail-qk1-f196.google.com with SMTP id a132so483060qkb.13
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 19:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=otPhRjELPSf0/MKxMTlfjswu9YGe4DiJlfWtnAEe4FM=;
        b=FBXhHzxvB9ZhwW1EgWcK6yrRfzho4HYgGcVCk0dSOf5sXqZLn3eLazrdvKYPTtJHqI
         PnpMvnwQgkYkpGI1Nnn833CrWa8pa1z4KYGvjmp/8fhbd/RyaOa7NV8N+sJ0A61XSvh3
         Nju+0JxSXG3Gmv7/NlQLIoyGfA0OMNST4RmOBQ+1Zv5tUphsEjeb1wOM5IYlcHMr8xVn
         lEOdRTlrSTX7TDg3ixXKkfit+3EcFq7+OEKW8L8dE3BbPTzCRxBFb6Uh9UZwNxVxDuSJ
         47o0LvavOokkZcLqHrjbt9txs0QX5gm4kH9dUayokLZ9odhISWZYtURq50mLB1hQCpUW
         WJHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=otPhRjELPSf0/MKxMTlfjswu9YGe4DiJlfWtnAEe4FM=;
        b=sJlX2IB8tCgsrVhdj3lqM5P+VGRNtvh5iSaaMGiCrQmZiG7BxbGLQie0ln5Im+3KO7
         4UHoZ7qm/3llwJuG4IMwgAWt0AjWBV74H6DMCFA3OtdWMV5rwKli1qlODBtgD/aNuZpK
         rnlqMX7DW/1IzmWz3GRhACl431dO+L0J1Y765KBbXMaD7sBDlIIb/BVEJcEkfVsagSFD
         ZerIbUc6rNH2CwMuXhiro+S8o+Z+vrgLSQfYHq/4S1qG7neEDHYCq62nnYjpNwml5Z5Y
         tKd8mJMeGgpmH5aSbG4v7o0WHVcNyW/L3YsAMVQOWqu0vwPuGMeWNeOIqjnXiHZ/6iF+
         bGww==
X-Gm-Message-State: APjAAAXRa54Ynhob+qUhwe0ZMDmaOrBduqfF8kP/zkUBElDPVF5E9OgU
        U4egbVnHT3PZoaE68wihyZmVcA==
X-Google-Smtp-Source: APXvYqwQAVsJM3AiHAliB47oRvLcZkau+9hohZZhGezoPQ2U/lwtO3lkGNC3EwF5dsg4O8nY8AEUJw==
X-Received: by 2002:a37:9481:: with SMTP id w123mr65469364qkd.319.1558490535762;
        Tue, 21 May 2019 19:02:15 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id w195sm11440663qkb.54.2019.05.21.19.02.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 19:02:15 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net 2/3] net/tls: fix state removal with feature flags off
Date:   Tue, 21 May 2019 19:02:01 -0700
Message-Id: <20190522020202.4792-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190522020202.4792-1-jakub.kicinski@netronome.com>
References: <20190522020202.4792-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TLS offload drivers shouldn't (and currently don't) block
the TLS offload feature changes based on whether there are
active offloaded connections or not.

This seems to be a good idea, because we want the admin to
be able to disable the TLS offload at any time, and there
is no clean way of disabling it for active connections
(TX side is quite problematic).  So if features are cleared
existing connections will stay offloaded until they close,
and new connections will not attempt offload to a given
device.

However, the offload state removal handling is currently
broken if feature flags get cleared while there are
active TLS offloads.

RX side will completely bail from cleanup, even on normal
remove path, leaving device state dangling, potentially
causing issues when the 5-tuple is reused.  It will also
fail to release the netdev reference.

Remove the RX-side warning message, in next release cycle
it should be printed when features are disabled, rather
than when connection dies, but for that we need a more
efficient method of finding connection of a given netdev
(a'la BPF offload code).

Fixes: 4799ac81e52a ("tls: Add rx inline crypto offload")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 net/tls/tls_device.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index aa33e4accc32..07650446e892 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -939,12 +939,6 @@ void tls_device_offload_cleanup_rx(struct sock *sk)
 	if (!netdev)
 		goto out;
 
-	if (!(netdev->features & NETIF_F_HW_TLS_RX)) {
-		pr_err_ratelimited("%s: device is missing NETIF_F_HW_TLS_RX cap\n",
-				   __func__);
-		goto out;
-	}
-
 	netdev->tlsdev_ops->tls_dev_del(netdev, tls_ctx,
 					TLS_OFFLOAD_CTX_DIR_RX);
 
-- 
2.21.0

