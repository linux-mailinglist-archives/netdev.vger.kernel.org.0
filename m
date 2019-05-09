Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A03418599
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 08:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfEIGyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 02:54:32 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40157 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbfEIGyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 02:54:32 -0400
Received: by mail-pl1-f193.google.com with SMTP id b3so652649plr.7
        for <netdev@vger.kernel.org>; Wed, 08 May 2019 23:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gofkIzz+KCIjzb4owK5EZXqVIssnZI7Btkooy0y1chM=;
        b=i6wa9O5c59+4auTHFv8eHmOKt1pRpsXkGMRTZNUaFc4F/wYm6tKd70A5ky9UYeZGeC
         fau/ENa4qae7KSQ+zW2buDHJ0jdBupDiWaFwF7II68z946+VUUBwZUpOp5oF/y3mM5Lc
         yIMb6SMA5p0eYfQHswjfar3x0FyNpDp1B2myH+G+iOLM8e0/ffkqdVPqT3jjtaGg2/p3
         GhcqxNJXcLx1BpvU8cIn79YhnXNXDQD9WyQvVm3Twasb7dhCksxowHCpPSTqOprf2sw9
         6yUNFA1osjqdYV+fmSuPmhPIw9kvwjclwNdJc3UNGTdgUMkewhyi9tQ1hequ5OWQv4yV
         jO+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gofkIzz+KCIjzb4owK5EZXqVIssnZI7Btkooy0y1chM=;
        b=QVwSsneF8984IEUkF0U51iHGknxeP6M5xoLnVIYIpaz2wbS5cJRmBKISbHL5SmXtub
         zcrmGYT6YGrI4WwBDeRmoZiOQlkl9GAaEW6F6eng7VT930Zk+uDqHLS/BQQQDGDc8EPM
         r9Y6P7C/nHoy+tpMY6TD0tasxcWqCJq+KIMfp2w2ljFM4yEjcp8taNZYZjJANceI9nfc
         8TLvgZzAS3YTNuoYRtH3CkyhvHe2OOBoio7WXKwO/WXRyLEH8b52InLfESBf0iEr3b3I
         3i9bq0adgnQbBmBPKr4PaV0BmWcfhhODNkpvmgqJZN4sAKnH+l2kjv63scFqzvX2jeGs
         nulw==
X-Gm-Message-State: APjAAAXICVDjWl1BjcHMuaYkz8p/Vmwwb3AejWePefY5rjjaMwajJGhq
        DW4lsNlFrArYgy6QVwwbQdJhdqzJgZ0=
X-Google-Smtp-Source: APXvYqzLitTzCvI4GYtvP6cN25ztiVlCDhJ8UFNxLrkipxXsI+Fr6OSopi4f06hp34VSis7Ck5AeQg==
X-Received: by 2002:a17:902:e188:: with SMTP id cd8mr2996942plb.110.1557384870948;
        Wed, 08 May 2019 23:54:30 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z71sm3098386pgd.40.2019.05.08.23.54.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 May 2019 23:54:30 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Miller <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] macvlan: disable SIOCSHWTSTAMP in container
Date:   Thu,  9 May 2019 14:54:08 +0800
Message-Id: <20190509065408.19444-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Miroslav pointed that with NET_ADMIN enabled in container, a normal user
could be mapped to root and is able to change the real device's rx
filter via ioctl on macvlan, which would affect the other ptp process on
host. Fix it by disabling SIOCSHWTSTAMP in container.

Fixes: 254c0a2bfedb ("macvlan: pass get_ts_info and SIOC[SG]HWTSTAMP ioctl to real device")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/macvlan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index b395423b19bc..92efa93649f0 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -836,6 +836,8 @@ static int macvlan_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 	switch (cmd) {
 	case SIOCSHWTSTAMP:
+		if (!net_eq(dev_net(dev), &init_net))
+			break;
 	case SIOCGHWTSTAMP:
 		if (netif_device_present(real_dev) && ops->ndo_do_ioctl)
 			err = ops->ndo_do_ioctl(real_dev, &ifrr, cmd);
-- 
2.19.2

