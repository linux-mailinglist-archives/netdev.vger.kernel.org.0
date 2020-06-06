Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244571F0839
	for <lists+netdev@lfdr.de>; Sat,  6 Jun 2020 21:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbgFFTKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 15:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728553AbgFFTKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jun 2020 15:10:10 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7F8C03E96A;
        Sat,  6 Jun 2020 12:10:09 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id e5so10386375ote.11;
        Sat, 06 Jun 2020 12:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cTw5dVSMwgnbi7FFVWG6b2nkWHLOFqVz8oS6c47Yp3w=;
        b=D7RuLr42OlAzuzZ6e5hiRKdIJxPHCuyazV70MOrCLNoIB3U2Lm7VIfR/naHeeJOatj
         oMuA6nFGWJv0DfkXT+TlntrHAJM7yivM9FLuQSk5o7PQb+45+B7Qu5/OJBjiNnPxgqaL
         ADza4HhEk0dfNfhbZwqomd4X8SVxP3+6wjPSxwC0DsQrzXg59xc4PfvAvZdhIZqHStal
         KJc85wps8HsFTTmf0XwAzylVUnaC58gU+d0OW5Wei2peBWc8FkGrVT+g5o1UkeRCmkja
         DZU5A2iamFEwrnSYFmMh/PpxbGNTMh2hNYicQGqys1FSTPzrBkkljWJD7CnBZ7U2ImoV
         ax4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cTw5dVSMwgnbi7FFVWG6b2nkWHLOFqVz8oS6c47Yp3w=;
        b=cZNxIagtzcuJrm8gdecqC/oX3tqhDvnEvDKBYMahkaRqH6LUdfWxkZerMs0F/kpuoe
         pywEeRoYZ0d3Ik1Mg6Rn14+CSF/ZraTNkDDNcYg6f6qfar+RqVJ1e4nezp2A5bqgZfIn
         g8qN+EaP1RJPdOlI1v2ryQHCUGK5whN8RP2mF66Lhu9kVSKPC7TPbzDy7R/G6uzDIU94
         xvyZhgjVWp8wSB1DwhuEnlZTERJBesgEROBqdZcF/cAJsYmVRFOPO2oP4416QPgEf1iR
         IRJEgB2d4QBuusm53svY7Jov2gd7TRa/XLzVLrGhLlkfizWFOO3LSWKtLP/yBmEUuG2L
         9Ipg==
X-Gm-Message-State: AOAM532K5QHTu4/n7RKs24Q93QwWms/vcE/YB5V5jRs2uEflubqyjVHO
        J2E0AovmJ5JmzGllrwBdkjvKEQ50B2g=
X-Google-Smtp-Source: ABdhPJy61MvJ4C7cH913G/3NwYmTMNxge9YrVXCAqiNk6ZiFMinuObbHq0uWZE5pIaIty5cGQOmycA==
X-Received: by 2002:a9d:d83:: with SMTP id 3mr11719097ots.365.1591470606991;
        Sat, 06 Jun 2020 12:10:06 -0700 (PDT)
Received: from proxmox.local.lan ([2605:6000:1b0c:4825:226:b9ff:fe41:ba6b])
        by smtp.googlemail.com with ESMTPSA id m83sm1397207oig.51.2020.06.06.12.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2020 12:10:06 -0700 (PDT)
From:   Tom Seewald <tseewald@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     tseewald@gmail.com, Christoph Hellwig <hch@lst.de>,
        netdev@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH] Fix build failure of OCFS2 when TCP/IP is disabled
Date:   Sat,  6 Jun 2020 14:08:26 -0500
Message-Id: <20200606190827.23954-1-tseewald@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 12abc5ee7873 ("tcp: add tcp_sock_set_nodelay") and
commit c488aeadcbd0 ("tcp: add tcp_sock_set_user_timeout"), building the
kernel with OCFS2_FS=y but without INET=y causes it to fail with:

ld: fs/ocfs2/cluster/tcp.o: in function `o2net_accept_many':
tcp.c:(.text+0x21b1): undefined reference to `tcp_sock_set_nodelay'
ld: tcp.c:(.text+0x21c1): undefined reference to `tcp_sock_set_user_timeout
'
ld: fs/ocfs2/cluster/tcp.o: in function `o2net_start_connect':
tcp.c:(.text+0x2633): undefined reference to `tcp_sock_set_nodelay'
ld: tcp.c:(.text+0x2643): undefined reference to `tcp_sock_set_user_timeout
'

This is due to tcp_sock_set_nodelay() and tcp_sock_set_user_timeout() being
declared in linux/tcp.h and defined in net/ipv4/tcp.c, which depend on
TCP/IP being enabled.

To fix this, make OCFS2_FS depend on INET=y which already requires NET=y.

Signed-off-by: Tom Seewald <tseewald@gmail.com>
---
 fs/ocfs2/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/Kconfig b/fs/ocfs2/Kconfig
index 1177c33df895..aca16624b370 100644
--- a/fs/ocfs2/Kconfig
+++ b/fs/ocfs2/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config OCFS2_FS
 	tristate "OCFS2 file system support"
-	depends on NET && SYSFS && CONFIGFS_FS
+	depends on INET && SYSFS && CONFIGFS_FS
 	select JBD2
 	select CRC32
 	select QUOTA
-- 
2.20.1

