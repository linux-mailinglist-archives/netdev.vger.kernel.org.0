Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8273A1A0B
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 17:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235211AbhFIPss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 11:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234044AbhFIPsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 11:48:47 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9BADC061574;
        Wed,  9 Jun 2021 08:46:52 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id x10so12742929plg.3;
        Wed, 09 Jun 2021 08:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e4aq/DyThBNoxMj07ot0bkg9LS2d0lWSCk/xRtR93s8=;
        b=YMWlm3oqjplYs/n4JR52ku/DKZ7xKAGjqx3rXE/XvL/DmvDQfJcZ3sKDrH8moXCoKe
         OvHl43kF5z1m/FPQm+1sZlzvoCD3N5EgAYZAvbtQSuqXW3azfHLHs9oCPWRlwIsnM6np
         BLcEPyV6E0tO1TVTFpo0pJV+a9DtRaXUR6KJ275tTJvhNROBmtWbJhcprbyRWHa12gkM
         vtU4L1AfQgDxF29A8rrjxZb+UwXERw6NVPGOZzvXa7HNrwGe49ryaAxxZkIu8m3XI9kv
         RnTYtwXDG0QHX/kmp3HCr9J8Dr47BOvYaN8qfTJ9L78dPGF85QpTEU/avVdNhuumFj2F
         UlEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e4aq/DyThBNoxMj07ot0bkg9LS2d0lWSCk/xRtR93s8=;
        b=af4Xiu6TrrLv+/Pl2nQgCKajWWvLPEdpC79GTnK7vIV/zc1Qygr9WzV1a8HJyWQaXf
         /plIhtgwGb2vj6CFU/h96tE3nZAouY6ZXwhsHuagu5geHTebAnKW1ErqKxOlGy/iOsfv
         m2S970xmy2zu8ZNQQvVTO9+Mbr6ulmd9Rurw28ZzwdwUxT6K1ZFdMYKr8WHzDbN9QO1c
         xj4d2gdjEtl/4vjij1KtUAmu+ga9lrja65hLvxRs4Vwc4K6ZEI5dvoQmfOkFlqBU7b/w
         0ZBhLsYxnvKHrCHczQY1IWJNSL/w0K68Bf9LNcPqvpTduDyLH7AtESvQcoTzgy5TP/C2
         ShKw==
X-Gm-Message-State: AOAM5317DTL0BgIfeZw+k69sfJqp0QUl4Hz4Wu6yCmV1cVp1yVSkHhi4
        wQNKpDYGh96mx/QFajVf4tzDvhJDKsn/rQ==
X-Google-Smtp-Source: ABdhPJz9it0NlbsWH0N+DNWPmelWAKAr0gcHsh1EmXiwp5vViDogczoL5DxxX5fEnkvRDT4wZI6uPA==
X-Received: by 2002:a17:902:b94a:b029:10d:6f56:eeac with SMTP id h10-20020a170902b94ab029010d6f56eeacmr403539pls.54.1623253612379;
        Wed, 09 Jun 2021 08:46:52 -0700 (PDT)
Received: from WRT-WX9.. ([141.164.41.4])
        by smtp.gmail.com with ESMTPSA id u20sm39753pfn.192.2021.06.09.08.46.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 08:46:52 -0700 (PDT)
From:   Changbin Du <changbin.du@gmail.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kici nski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Changbin Du <changbin.du@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH v2] net: do not invoke open_related_ns when NET_NS is disabled
Date:   Wed,  9 Jun 2021 23:46:35 +0800
Message-Id: <20210609154635.46792-1-changbin.du@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When NET_NS is not enabled, socket ioctl cmd SIOCGSKNS should do nothing
but acknowledge userspace it is not supported. Otherwise, kernel would
panic wherever nsfs trys to access ns->ops since the proc_ns_operations
is not implemented in this case.

[7.670023] Unable to handle kernel NULL pointer dereference at virtual address 00000010
[7.670268] pgd = 32b54000
[7.670544] [00000010] *pgd=00000000
[7.671861] Internal error: Oops: 5 [#1] SMP ARM
[7.672315] Modules linked in:
[7.672918] CPU: 0 PID: 1 Comm: systemd Not tainted 5.13.0-rc3-00375-g6799d4f2da49 #16
[7.673309] Hardware name: Generic DT based system
[7.673642] PC is at nsfs_evict+0x24/0x30
[7.674486] LR is at clear_inode+0x20/0x9c

The same to tun SIOCGSKNS command.

Signed-off-by: Changbin Du <changbin.du@gmail.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
---
 drivers/net/tun.c | 4 ++++
 net/socket.c      | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 84f832806313..8ec5977d2f34 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3003,9 +3003,13 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 	} else if (cmd == TUNSETQUEUE) {
 		return tun_set_queue(file, &ifr);
 	} else if (cmd == SIOCGSKNS) {
+#ifdef CONFIG_NET_NS
 		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 		return open_related_ns(&net->ns, get_net_ns);
+#else
+		return -EOPNOTSUPP;
+#endif
 	}
 
 	rtnl_lock();
diff --git a/net/socket.c b/net/socket.c
index 27e3e7d53f8e..bc644030d2e8 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1149,11 +1149,15 @@ static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 			mutex_unlock(&vlan_ioctl_mutex);
 			break;
 		case SIOCGSKNS:
+#ifdef CONFIG_NET_NS
 			err = -EPERM;
 			if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 				break;
 
 			err = open_related_ns(&net->ns, get_net_ns);
+#else
+			err = -EOPNOTSUPP;
+#endif
 			break;
 		case SIOCGSTAMP_OLD:
 		case SIOCGSTAMPNS_OLD:
-- 
2.30.2

