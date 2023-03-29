Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 558CB6CD812
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 13:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjC2LDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 07:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjC2LDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 07:03:45 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F7C40E3
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 04:03:43 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id cn12so61552820edb.4
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 04:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112; t=1680087822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DslxHK6KBlhiVdu3Lr2KxbgUyV3iiwJejUtCbzhCHrg=;
        b=Yy5k9qZEJOVBgeYN+QLmeqRbC7KZuQGj8fxV1P1wv2QR/sUQHJaSjxK/EfY8bu2quQ
         E7/aHYMvw+AlJHkzNq+d6wkXAaiw4NSeudky28BWk3pWDBboxyqwYTCNAyKMhpCecREJ
         2WnWEb0e14cv8l4h9uUxiiQIeeWmiWQzGDIKOS5HnLSzsVCLeXP59swtQDl8VkjAg0uA
         OLMC69ugF//IudDWJBTDrw5QJfDhYWywaz8PjGTJONmnpsEPp9lSFFyqOWgal0tW/Rfh
         JEFAXEa6dP40HO61CT6wc4MpRKTECR1yZQf/R0RsgezvfrZ6wG4RXjucNsIp0QCpWH4U
         rktA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680087822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DslxHK6KBlhiVdu3Lr2KxbgUyV3iiwJejUtCbzhCHrg=;
        b=O8ANTMhy3S1wIRMFIVnR3tWdSTwFgjIEf0lW2greKFvycsWr0SAc2dKtTJpVllv8Tm
         LDO5f+Qg/kAHi5HUingU+900uR8vBxSE26TW7T4SUh3FP8nWNq/CWskJZVtKF8vrOlj2
         +em40jnQdGA2lYRkngN+32/vXf/uTdS0yU4+TmcSH8LkNwlaI0tJNOFM3Ujutl+HWMiy
         SFyn35aMH6zX2ymlvKM8GePuhYa0awVCw2qNvcorrpm1wlFOOEbjAdRCXxVi6MM2OiY0
         ANSk9qhnvAJG5ypRqZj/p3NSh95AZv69hpOAjUfc2kWY86Z/azI5PdvqNXbZYTBBBkG1
         r5yQ==
X-Gm-Message-State: AAQBX9cOhd62HkkMxrPBJE5nTHCTxJfSxKA4YZJd5OScfRIGaYS6ME2d
        MpkhRU0PipgqWxwwoRFikhxhLg==
X-Google-Smtp-Source: AKy350bAeJm/lTdNut+XFjwpE5mB8COw9m59DKjlI8EOn4LXgTEkUyvLPcmriazqkZ4ieGvpm+xugw==
X-Received: by 2002:a17:906:612:b0:933:4d47:55b7 with SMTP id s18-20020a170906061200b009334d4755b7mr1840523ejb.2.1680087822487;
        Wed, 29 Mar 2023 04:03:42 -0700 (PDT)
Received: from localhost.localdomain (178-133-100-41.mobile.vf-ua.net. [178.133.100.41])
        by smtp.gmail.com with ESMTPSA id md12-20020a170906ae8c00b008e68d2c11d8sm16406975ejb.218.2023.03.29.04.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 04:03:42 -0700 (PDT)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mst@redhat.com, jasowang@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
Subject: [RFC PATCH 2/5] virtio-net: Added property to load eBPF RSS with fds.
Date:   Wed, 29 Mar 2023 13:45:43 +0300
Message-Id: <20230329104546.108016-3-andrew@daynix.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230329104546.108016-1-andrew@daynix.com>
References: <20230329104546.108016-1-andrew@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

eBPF RSS program and maps may now be passed during initialization.
Initially was implemented for libvirt to launch qemu without permissions,
and initialized eBPF program through the helper.

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 hw/net/virtio-net.c            | 77 ++++++++++++++++++++++++++++++++--
 include/hw/virtio/virtio-net.h |  1 +
 2 files changed, 74 insertions(+), 4 deletions(-)

diff --git a/hw/net/virtio-net.c b/hw/net/virtio-net.c
index 53e1c32643..45d448a83d 100644
--- a/hw/net/virtio-net.c
+++ b/hw/net/virtio-net.c
@@ -42,6 +42,7 @@
 #include "sysemu/sysemu.h"
 #include "trace.h"
 #include "monitor/qdev.h"
+#include "monitor/monitor.h"
 #include "hw/pci/pci_device.h"
 #include "net_rx_pkt.h"
 #include "hw/virtio/vhost.h"
@@ -1305,14 +1306,81 @@ static void virtio_net_detach_epbf_rss(VirtIONet *n)
     virtio_net_attach_ebpf_to_backend(n->nic, -1);
 }
 
-static bool virtio_net_load_ebpf(VirtIONet *n)
+static int virtio_net_get_ebpf_rss_fds(char *str, char *fds[], int nfds)
+{
+    char *ptr = str;
+    char *cur = NULL;
+    size_t len = strlen(str);
+    int i = 0;
+
+    for (; i < nfds && ptr < str + len;) {
+        cur = strchr(ptr, ':');
+
+        if (cur == NULL) {
+            fds[i] = g_strdup(ptr);
+        } else {
+            fds[i] = g_strndup(ptr, cur - ptr);
+        }
+
+        i++;
+        if (cur == NULL) {
+            break;
+        } else {
+            ptr = cur + 1;
+        }
+    }
+
+    return i;
+}
+
+static bool virtio_net_load_ebpf_fds(VirtIONet *n)
 {
-    if (!virtio_net_attach_ebpf_to_backend(n->nic, -1)) {
-        /* backend does't support steering ebpf */
+    char *fds_strs[EBPF_RSS_MAX_FDS];
+    int fds[EBPF_RSS_MAX_FDS];
+    int nfds;
+    int ret = false;
+    Error *errp;
+    int i = 0;
+
+    if (n == NULL || !n->ebpf_rss_fds) {
         return false;
     }
 
-    return ebpf_rss_load(&n->ebpf_rss);
+    nfds = virtio_net_get_ebpf_rss_fds(n->ebpf_rss_fds,
+                                       fds_strs, EBPF_RSS_MAX_FDS);
+    for (i = 0; i < nfds; i++) {
+        fds[i] = monitor_fd_param(monitor_cur(), fds_strs[i], &errp);
+    }
+
+    if (nfds == EBPF_RSS_MAX_FDS) {
+        ret = ebpf_rss_load_fds(&n->ebpf_rss, fds[0], fds[1], fds[2], fds[3]);
+    }
+
+    if (!ret) {
+        for (i = 0; i < nfds; i++) {
+            close(fds[i]);
+        }
+    }
+
+    for (i = 0; i < nfds; i++) {
+        g_free(fds_strs[i]);
+    }
+
+    return ret;
+}
+
+static bool virtio_net_load_ebpf(VirtIONet *n)
+{
+    bool ret = true;
+
+    if (virtio_net_attach_ebpf_to_backend(n->nic, -1)) {
+        if (!(n->ebpf_rss_fds
+                && virtio_net_load_ebpf_fds(n))) {
+            ret = ebpf_rss_load(&n->ebpf_rss);
+        }
+    }
+
+    return ret;
 }
 
 static void virtio_net_unload_ebpf(VirtIONet *n)
@@ -3900,6 +3968,7 @@ static Property virtio_net_properties[] = {
                     VIRTIO_NET_F_RSS, false),
     DEFINE_PROP_BIT64("hash", VirtIONet, host_features,
                     VIRTIO_NET_F_HASH_REPORT, false),
+    DEFINE_PROP_STRING("ebpf_rss_fds", VirtIONet, ebpf_rss_fds),
     DEFINE_PROP_BIT64("guest_rsc_ext", VirtIONet, host_features,
                     VIRTIO_NET_F_RSC_EXT, false),
     DEFINE_PROP_UINT32("rsc_interval", VirtIONet, rsc_timeout,
diff --git a/include/hw/virtio/virtio-net.h b/include/hw/virtio/virtio-net.h
index ef234ffe7e..e10ce88f91 100644
--- a/include/hw/virtio/virtio-net.h
+++ b/include/hw/virtio/virtio-net.h
@@ -219,6 +219,7 @@ struct VirtIONet {
     VirtioNetRssData rss_data;
     struct NetRxPkt *rx_pkt;
     struct EBPFRSSContext ebpf_rss;
+    char *ebpf_rss_fds;
 };
 
 size_t virtio_net_handle_ctrl_iov(VirtIODevice *vdev,
-- 
2.39.1

