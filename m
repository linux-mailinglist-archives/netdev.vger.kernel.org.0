Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7593550B5
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 12:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241335AbhDFKUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 06:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237824AbhDFKUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 06:20:52 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8153C061756
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 03:20:44 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id q26so7912544wrz.9
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 03:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bcefdudaPy/YI+OKTqE8aidgvlYBD0QZn69/G4d7ptU=;
        b=k42kwbijED+nek4rwjT2eYPMSE6B3+1xLQvx9UTI9SshTJD3v84BfJVZEFjLOPYBJC
         IoQsKOD6DzNmnJpfZugbl9hVRVqnO4EMHYW0cpbrd4FVtuNukCCmG/Cq88HkoeIw3pzI
         vaCB3wm1DgJsZY2O/S29K3wLQjDsy0w0cjjqd4nVuREkjicEvtmJ//Uzqcvpa04KZKN/
         HqYuYU3GuCAraZ9RiHdUW5OY3+eBHLXiMyZN2rIimKifq0GUh1bXH0CU1pjuxVFZi9yW
         Pet5QfjwITn0I8KVgvkJ9JYNaoVtg2KMwG8JtpszWQ4htzP9kvQic1uGwKIxIBL0uo+2
         Ub7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bcefdudaPy/YI+OKTqE8aidgvlYBD0QZn69/G4d7ptU=;
        b=kM5RxDSYz9olBQoYsXCM1phdykqGgATvxpL25wZh/NiPUMNLgNBJ8TKMWF50cqkTcs
         Sro0NzVHjcgUKl8Tyye239K7/mBGlJQOEa+rHwMA3gsIHb3VwMyRAx6D+gmrbbB+ZeK0
         66lb7KVmItEqsQvkVeh3alN94kXnHZ22/41aL+YT2zdcSjzRD0p84Rqg2JIvZTBJ8CIe
         y+5qF3xAd9GClDo0m2s/+GKdFnmM5eIFN3arH5E1SycgwEjcJKCLDf9OZ8ThHE0FsBvb
         D0MWN9Yxa6/I5/Kgk5YpqqUHFaUJPSS9g4yEoFslAAZuH9CerE18Qon1NTOeVbmXnsAa
         2mUg==
X-Gm-Message-State: AOAM530s7CW0zWJW7MTfat5tqKgTcLwh3PrjBVIWYTI9FJZ64PB+bdiU
        FC5lWXC43G3lH6HWRSSrRrfu6A==
X-Google-Smtp-Source: ABdhPJxJVkIpA89rUaR8Fw2m4JV6uB6QMclzVKcvrYWcfp4fzIMR43EdfrRODU2sw+7Mtf7KKjG/NA==
X-Received: by 2002:adf:8b45:: with SMTP id v5mr33654146wra.398.1617704443479;
        Tue, 06 Apr 2021 03:20:43 -0700 (PDT)
Received: from localhost.localdomain (2.0.5.1.1.6.3.8.5.c.c.3.f.b.d.3.0.0.0.0.6.1.f.d.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:df16:0:3dbf:3cc5:8361:1502])
        by smtp.gmail.com with ESMTPSA id u2sm32373544wrp.12.2021.04.06.03.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 03:20:43 -0700 (PDT)
From:   Phillip Potter <phil@philpotter.co.uk>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: tun: set tun->dev->addr_len during TUNSETLINK processing
Date:   Tue,  6 Apr 2021 11:20:40 +0100
Message-Id: <20210406102040.1122-1-phil@philpotter.co.uk>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When changing type with TUNSETLINK ioctl command, set tun->dev->addr_len
to match the appropriate type, using new tun_get_addr_len utility function
which returns appropriate address length for given type. Fixes a
KMSAN-found uninit-value bug reported by syzbot at:
https://syzkaller.appspot.com/bug?id=0766d38c656abeace60621896d705743aeefed51

Reported-by: syzbot+001516d86dbe88862cec@syzkaller.appspotmail.com
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
---

V2: Removed inline specifier from tun_get_addr_len function.

---
 drivers/net/tun.c | 48 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 978ac0981d16..524a9f771b86 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -69,6 +69,14 @@
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
 #include <linux/mutex.h>
+#include <linux/ieee802154.h>
+#include <linux/if_ltalk.h>
+#include <uapi/linux/if_fddi.h>
+#include <uapi/linux/if_hippi.h>
+#include <uapi/linux/if_fc.h>
+#include <net/ax25.h>
+#include <net/rose.h>
+#include <net/6lowpan.h>
 
 #include <linux/uaccess.h>
 #include <linux/proc_fs.h>
@@ -2925,6 +2933,45 @@ static int tun_set_ebpf(struct tun_struct *tun, struct tun_prog __rcu **prog_p,
 	return __tun_set_ebpf(tun, prog_p, prog);
 }
 
+/* Return correct value for tun->dev->addr_len based on tun->dev->type. */
+static unsigned char tun_get_addr_len(unsigned short type)
+{
+	switch (type) {
+	case ARPHRD_IP6GRE:
+	case ARPHRD_TUNNEL6:
+		return sizeof(struct in6_addr);
+	case ARPHRD_IPGRE:
+	case ARPHRD_TUNNEL:
+	case ARPHRD_SIT:
+		return 4;
+	case ARPHRD_ETHER:
+		return ETH_ALEN;
+	case ARPHRD_IEEE802154:
+	case ARPHRD_IEEE802154_MONITOR:
+		return IEEE802154_EXTENDED_ADDR_LEN;
+	case ARPHRD_PHONET_PIPE:
+	case ARPHRD_PPP:
+	case ARPHRD_NONE:
+		return 0;
+	case ARPHRD_6LOWPAN:
+		return EUI64_ADDR_LEN;
+	case ARPHRD_FDDI:
+		return FDDI_K_ALEN;
+	case ARPHRD_HIPPI:
+		return HIPPI_ALEN;
+	case ARPHRD_IEEE802:
+		return FC_ALEN;
+	case ARPHRD_ROSE:
+		return ROSE_ADDR_LEN;
+	case ARPHRD_NETROM:
+		return AX25_ADDR_LEN;
+	case ARPHRD_LOCALTLK:
+		return LTALK_ALEN;
+	default:
+		return 0;
+	}
+}
+
 static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 			    unsigned long arg, int ifreq_len)
 {
@@ -3088,6 +3135,7 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 				break;
 			}
 			tun->dev->type = (int) arg;
+			tun->dev->addr_len = tun_get_addr_len(tun->dev->type);
 			netif_info(tun, drv, tun->dev, "linktype set to %d\n",
 				   tun->dev->type);
 			call_netdevice_notifiers(NETDEV_POST_TYPE_CHANGE,
-- 
2.30.2

