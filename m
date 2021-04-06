Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1976355AA2
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 19:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236627AbhDFRqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 13:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235624AbhDFRqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 13:46:07 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC82C06174A
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 10:45:59 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 12so7767301wmf.5
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 10:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bWI2J9FDV7hGVDtesljodAlDs+1YaqqWq1jWOTvqfMw=;
        b=ZnQuCXCqLztGWO9civ2ZeI/w2lUHMYZt0jO0NuGzxrazuyF6yYZqDQA6hvZNL7BUfF
         zggZjMMjcFnZ/H1g6bONqDKyvI3JlTf4VeaqezYlYet7HOtyAliJjCDsiNbL67gH5o79
         kUvTGsM40muyp2moqR0dFPxLkT8dbfO87JwihQ79wlbNTLOGNmdSzbbWte5wz2yPrZKc
         MMSWFlpqsN62QxW6U+XAKEA/makDv4snZkM0fklHpKxMrthLLf/uMzRFkQfeEhkkC68K
         1rHu36KSzAXoEf0JnwIScZBPuu1CnnLFyweG0Nnmh7nd6cGrUchKqTQRLx9ccr+kvsCw
         764g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bWI2J9FDV7hGVDtesljodAlDs+1YaqqWq1jWOTvqfMw=;
        b=r0uQwD7zG3IPoHGVe61w0oYng02Xea6zweW5xfeOMfeQO3ig6+RPEkL1OixcGIOX6t
         y5a7HQU4gKWEYdi8MRC/LZlgvvBEIBKlPUZ/J/NwdsgwX8PxV1Voa59CN7WSrVUYxD4q
         61Uomfl+/FLkFDN6rJUeewvdy9mIboKPF6deGT+vIGtn3DvQg5dSWRs2ZerbZpchNcYH
         jqU/Tuq1rVTTZ2Ah9kYSLWymp5tbtqidLL8teo1XATnTMmuoGUoKz9VZ7KXtuMUqQA/K
         CzkUAXNMVjSDNT4OsgJ03pgDVu6EJ27NMAU6tnyQRTYaLcf2rzgYwWRt4MZKfCW2f8XU
         PrGw==
X-Gm-Message-State: AOAM532L01bfR1hTCcCs4ALWDcpEfwGMoj2gHSexqx+9mr96PK+llbzu
        p3qxMci+Vm3DISTdBHbPQ+j7lQ==
X-Google-Smtp-Source: ABdhPJyeLuP+IdXxjgrEQfJXkaCtSaHMwYs6hwjkmGjk9i5KERdtyo4mz1ZSM9/QZEMem6WrmNwZFQ==
X-Received: by 2002:a1c:ac02:: with SMTP id v2mr5253941wme.111.1617731157874;
        Tue, 06 Apr 2021 10:45:57 -0700 (PDT)
Received: from localhost.localdomain (2.0.5.1.1.6.3.8.5.c.c.3.f.b.d.3.0.0.0.0.6.1.f.d.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:df16:0:3dbf:3cc5:8361:1502])
        by smtp.gmail.com with ESMTPSA id j30sm36407046wrj.62.2021.04.06.10.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 10:45:57 -0700 (PDT)
From:   Phillip Potter <phil@philpotter.co.uk>
To:     davem@davemloft.net
Cc:     eric.dumazet@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] net: tun: set tun->dev->addr_len during TUNSETLINK processing
Date:   Tue,  6 Apr 2021 18:45:54 +0100
Message-Id: <20210406174554.915-1-phil@philpotter.co.uk>
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
Diagnosed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
---

V2: Removed inline specifier from tun_get_addr_len function.
V3: Gave appropriate credit to Eric Dumazet for diagnosing the issue.

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

