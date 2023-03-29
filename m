Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 276FD6CD81C
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 13:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjC2LEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 07:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjC2LDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 07:03:48 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A1144A6
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 04:03:47 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id y4so61600621edo.2
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 04:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112; t=1680087825;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wrfwKePkllnALnkJ2zV/3yw/+BvIeTv0XWFEcNBw8YA=;
        b=1dcJ+wPmxC9snk2hmBPEKQoXzNuJWkkqm3ON1LX6qgcNx0LODC4FnhV8ZDgh9qxxHz
         7bHUxRbbIvcjerza/iEoLvHl/lR3VWp5km9cVI831ypXHNgO0EkUg+sUCcVYo0zNUIf2
         CjJFDKin+n+wlWQiU4Ggips5+i45qU30QX6d10hw3dKuiBqoNWtEJ+FMk0F3ewl9x3cc
         RCIG2QP0Djcave7xpgQw7q08JJEQ/ItGsBLMEDkxNn000ZCZ3KQowjl0Yf/4+4/osAFQ
         rvj/Nc5iwAAUJxjYpbKb6v6nG5yq6R19STcdmxfA1jsF2WqiJFIemuvit3TIY6a1HiGN
         MGYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680087825;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wrfwKePkllnALnkJ2zV/3yw/+BvIeTv0XWFEcNBw8YA=;
        b=pX8YpHs3/TuH9BNYnAJzPnmyzPm7KBY/jD8gyCJ4LsxQIMGZHGQpTR06XaIkZutMPC
         Y36bNAudeX5sDgRBQg6M2Cn5bKAJulFpLhkHnSJFYYw2CY4TXM5ua4e+aC0GBLX2U0aZ
         POfyOO+FhnFEGWqcfJ8AruMAeTf2uyXDBOdb4lj5EBt+VJDQQRRH48k15y54RAzdENtc
         BXNpDw8wTG97m8SdfWVDa8a2hrVJ6t+d3/Q+1/v9hwaVc+7K3mLOfRn7FijOyl+tXEt2
         sY6J63eyifntTMm8V/z8YrjoxF5aPOSNz9R40AA271/q/U6SmFbs4IIDBtfsRO87snuT
         6oTQ==
X-Gm-Message-State: AAQBX9ekfeXmW9dpF7DJHOxlhqT/ymnh2v4eJaV7fwOZS7YllnJYoAaL
        rf3HzXaxiPKNeqf6sPNFWuOjrg==
X-Google-Smtp-Source: AKy350Z16UKXumN3KnQDzRbKZJX9u64esHjbx9gtBr5Z8d0SvvEDLi9zU2vbK4QEzPWAONlYBMhi9A==
X-Received: by 2002:a17:906:71d7:b0:8a6:5720:9101 with SMTP id i23-20020a17090671d700b008a657209101mr20733205ejk.4.1680087825633;
        Wed, 29 Mar 2023 04:03:45 -0700 (PDT)
Received: from localhost.localdomain (178-133-100-41.mobile.vf-ua.net. [178.133.100.41])
        by smtp.gmail.com with ESMTPSA id md12-20020a170906ae8c00b008e68d2c11d8sm16406975ejb.218.2023.03.29.04.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 04:03:45 -0700 (PDT)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mst@redhat.com, jasowang@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
Subject: [RFC PATCH 4/5] qmp: Added new command to retrieve eBPF blob.
Date:   Wed, 29 Mar 2023 13:45:45 +0300
Message-Id: <20230329104546.108016-5-andrew@daynix.com>
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

Added command "request-ebpf". This command returns
eBPF program encoded base64. The program taken from the
skeleton and essentially is an ELF object that can be
loaded in the future with libbpf.

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 monitor/qmp-cmds.c | 17 +++++++++++++++++
 qapi/misc.json     | 25 +++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/monitor/qmp-cmds.c b/monitor/qmp-cmds.c
index b0f948d337..8f2fc3e7ec 100644
--- a/monitor/qmp-cmds.c
+++ b/monitor/qmp-cmds.c
@@ -32,6 +32,7 @@
 #include "hw/mem/memory-device.h"
 #include "hw/intc/intc.h"
 #include "hw/rdma/rdma.h"
+#include "ebpf/ebpf.h"
 
 NameInfo *qmp_query_name(Error **errp)
 {
@@ -209,3 +210,19 @@ static void __attribute__((__constructor__)) monitor_init_qmp_commands(void)
                          qmp_marshal_qmp_capabilities,
                          QCO_ALLOW_PRECONFIG, 0);
 }
+
+EbpfObject *qmp_request_ebpf(const char *id, Error **errp)
+{
+    EbpfObject *ret = NULL;
+    size_t size = 0;
+    const guchar *data = ebpf_find_binary_by_id(id, &size);
+
+    if (data) {
+        ret = g_new0(EbpfObject, 1);
+        ret->object = g_base64_encode(data, size);
+    } else {
+        error_setg(errp, "can't find eBPF object with id: %s", id);
+    }
+
+    return ret;
+}
diff --git a/qapi/misc.json b/qapi/misc.json
index 6ddd16ea28..4689802460 100644
--- a/qapi/misc.json
+++ b/qapi/misc.json
@@ -618,3 +618,28 @@
 { 'event': 'VFU_CLIENT_HANGUP',
   'data': { 'vfu-id': 'str', 'vfu-qom-path': 'str',
             'dev-id': 'str', 'dev-qom-path': 'str' } }
+
+##
+# @EbpfObject:
+#
+# Structure that holds eBPF ELF object encoded in base64.
+##
+{ 'struct': 'EbpfObject',
+  'data': {'object': 'str'} }
+
+##
+# @request-ebpf:
+#
+# Function returns eBPF object that can be loaded with libbpf.
+# Management applications (g.e. libvirt) may load it and pass file
+# descriptors to QEMU. Which allows running QEMU without BPF capabilities.
+#
+# Returns: RSS eBPF object encoded in base64.
+#
+# Since: 7.3
+#
+##
+{ 'command': 'request-ebpf',
+  'data': { 'id': 'str' },
+  'returns': 'EbpfObject' }
+
-- 
2.39.1

