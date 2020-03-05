Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67A66179C91
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 01:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388565AbgCEADM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 19:03:12 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:40103 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388558AbgCEADM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 19:03:12 -0500
Received: by mail-pj1-f68.google.com with SMTP id k36so1681136pje.5
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 16:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=oNAGi5dQw1zLKiiC8OqykHa56d/qsfH57tNb+XmfXLE=;
        b=PirV0idZXC3F6t2N/Jq0jIH10B1RbbGBSQ2L8R4snNVN5bvar1oISHXMkn6K52MVii
         vifqO1BIuwdQN0PaTG84NJsaTlWUiniGbSZAWzBSH0qrDVuozA0u70H2+IKHIj+tsqAV
         GlHPnEAYxzlfKU8CGK0zx/mPRidpf7s/XD+eJoL4Xdo/0TuO/mLFXf5h6rg8keSneB3W
         bMf5hfV9eq9ZoALFP/xQHSO0qDwdjIa2GqwfdzsfcDXG9UzvXkO0iDegbNVBa9hf1GT1
         3OKm+/x1/rOcl9w5e76Z+lP8vpqRYNexZz0aDHWRh82+XMgCkA2Ex2UGh0cGYXGdlqu/
         Ol4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oNAGi5dQw1zLKiiC8OqykHa56d/qsfH57tNb+XmfXLE=;
        b=DaVWeWhM5B3VvUDHy64BNoKCMKHWWIReH4Lv+n1bwJZ7RlWK6BM62UP/ifS5hU+oAe
         xOMjWx4/DX2EVSHnF4oozZcTxV7MnvDpklGfoKGgmMueJyYvVb29aPFpnXwPn+qnJA4Z
         nLVGK38eHRYcKRo6Rea1LxM2oeZK6oIcxBAqIQVAG69nrTivHPXFGz8xSWUWcHn2KP+5
         f/OY5g6GCGl6LW19QbDvuH+oQicAP+57dhb8+3kZ1oTl91QLf9JPp+RngikWcLVsyjn9
         O421TuAz0QC/8AlFcD1m1Hz5NtWtaYd12JRi+AZN8VNWuRYbCBiLJy5zsNqUK16TO/V/
         V2dQ==
X-Gm-Message-State: ANhLgQ1YG+S5U4y89lAUMITj5PAUOdxN1uMZv1ttIRnat/7jbmIbSZCt
        j6Fu+uLg2+6ZiQf3713SmAE=
X-Google-Smtp-Source: ADFU+vtRrNSNOJBMcCTdmnhZk/n3CS/PzDfJoKCSNl72HgTIkt+JX9FkwthiHrnDPuHyL3zd8SR/jg==
X-Received: by 2002:a17:902:463:: with SMTP id 90mr5559850ple.213.1583366590847;
        Wed, 04 Mar 2020 16:03:10 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id q21sm30793056pff.105.2020.03.04.16.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 16:03:09 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next] hsr: fix refcnt leak of hsr slave interface
Date:   Thu,  5 Mar 2020 00:02:54 +0000
Message-Id: <20200305000254.8217-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the commit e0a4b99773d3 ("hsr: use upper/lower device infrastructure"),
dev_get() was removed but dev_put() in the error path wasn't removed.
So, if creating hsr interface command is failed, the reference counter leak
of lower interface would occur.

Test commands:
    ip link add dummy0 type dummy
    ip link add ipvlan0 link dummy0 type ipvlan mode l2
    ip link add ipvlan1 link dummy0 type ipvlan mode l2
    ip link add hsr0 type hsr slave1 ipvlan0 slave2 ipvlan1
    ip link del ipvlan0

Result:
[  633.271992][ T1280] unregister_netdevice: waiting for ipvlan0 to become free. Usage count = -1

Fixes: e0a4b99773d3 ("hsr: use upper/lower device infrastructure")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

The commit e0a4b99773d3 ("hsr: use upper/lower device infrastructure")
is not merged into "net" yet.
So, the target branch is "net-next".

 net/hsr/hsr_slave.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
index 123605cb5420..d3547e8c6d5b 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -108,7 +108,7 @@ static int hsr_portdev_setup(struct hsr_priv *hsr, struct net_device *dev,
 
 	res = dev_set_promiscuity(dev, 1);
 	if (res)
-		goto fail_promiscuity;
+		return res;
 
 	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
 	hsr_dev = master->dev;
@@ -128,9 +128,6 @@ static int hsr_portdev_setup(struct hsr_priv *hsr, struct net_device *dev,
 	netdev_upper_dev_unlink(dev, hsr_dev);
 fail_upper_dev_link:
 	dev_set_promiscuity(dev, -1);
-fail_promiscuity:
-	dev_put(dev);
-
 	return res;
 }
 
-- 
2.17.1

