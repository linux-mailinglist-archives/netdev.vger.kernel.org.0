Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1C825BD8
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 04:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbfEVCCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 22:02:20 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44496 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfEVCCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 22:02:19 -0400
Received: by mail-qk1-f194.google.com with SMTP id w25so492790qkj.11
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 19:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BPAwZCutrvtvyee0AmICL6s4TQSsrziDR7n6uakE8Jw=;
        b=P5cCldp3gSghaRAoTPOXSvq6+Pp2UcAJnaNPV+BoGwcV0PbMOcQ6Fma66rNum6ttJV
         VqqkuNK3Xf3SeR85Kqe0aOfajK8U74q8iv0arNWgVRqgB6UwLXF+5fZIfrQ9OVTCC6el
         GKEHGFKsfF09tTSXjuYHmWblLP+ZDHQpeaHyZyCAAEz36YQAoO+of9mxFHQmyivGH4Sy
         zIvW1f5EbebyFV/pP1Wq5bB5lpdJMvzILTlZEJvcSK0QCTltXcdwycpdA4AMTPUg0Dxd
         yLcUT4oW4Y0bP3GTRt1ATKljCSQeSfiue0KAud7E7+s7ZRAkMTdbND+/Pp4pfWXOdhtj
         nVTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BPAwZCutrvtvyee0AmICL6s4TQSsrziDR7n6uakE8Jw=;
        b=PXhqqIEcMNR04Bz8yCVEdU4F0qbPZuZ5OhDDDPdtFjF+OqLCrbJgtlR5nymxFhAWSX
         jlv9tkhHnq7NlAYjtY0u67ZInujZTd6yh2443j9HYDKeX2/t/3FQlsXC0UkhBH86JrRP
         eq/gBRQ0Z6Qyg+bhQDg1H6jrPcVKtB2l60LeIxsqRI/fsGgF813LFq5Nu+A6M+eWvZ58
         BPznk2aHOlcHCxqKOYX1F6RPAzogPux2kLeriDFQSZnPGq63aPj8TI7N36tntlBv/x+M
         JtNbEBiVxtuAs1X2YZB+ZNGVOOGBkkr50T16BsmVXB4cfbCTOYARQrc1vABKStgn9HIn
         oxIA==
X-Gm-Message-State: APjAAAVN+zaSVeImGeskiv1uo3G039e174adUk9+X/VdrDTNCgY26B78
        YrSV7PrAgCTq9oQiIekq1XWuww==
X-Google-Smtp-Source: APXvYqyRAOKrDhbueg0ldENsYNUQKLbAC+MNOlbSzKCoaBxTty7aOPdqpxijC+hux4HgV8Rp7AxAkQ==
X-Received: by 2002:a37:5444:: with SMTP id i65mr67506410qkb.263.1558490537356;
        Tue, 21 May 2019 19:02:17 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id w195sm11440663qkb.54.2019.05.21.19.02.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 19:02:16 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net 3/3] net/tls: don't ignore netdev notifications if no TLS features
Date:   Tue, 21 May 2019 19:02:02 -0700
Message-Id: <20190522020202.4792-4-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190522020202.4792-1-jakub.kicinski@netronome.com>
References: <20190522020202.4792-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On device surprise removal path (the notifier) we can't
bail just because the features are disabled.  They may
have been enabled during the lifetime of the device.
This bug leads to leaking netdev references and
use-after-frees if there are active connections while
device features are cleared.

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 net/tls/tls_device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 07650446e892..b95c408fd771 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -997,7 +997,8 @@ static int tls_dev_event(struct notifier_block *this, unsigned long event,
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 
-	if (!(dev->features & (NETIF_F_HW_TLS_RX | NETIF_F_HW_TLS_TX)))
+	if (!dev->tlsdev_ops &&
+	    !(dev->features & (NETIF_F_HW_TLS_RX | NETIF_F_HW_TLS_TX)))
 		return NOTIFY_DONE;
 
 	switch (event) {
-- 
2.21.0

