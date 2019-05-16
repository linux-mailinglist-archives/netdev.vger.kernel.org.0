Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 419A220ABC
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 17:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbfEPPKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 11:10:03 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:43893 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbfEPPKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 11:10:02 -0400
Received: by mail-pf1-f201.google.com with SMTP id t1so2375216pfa.10
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 08:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=DpNV65Youz9rtc8RuhOsGHbzi/Opb6nleTtFSXR4wv8=;
        b=qql+K+dP4wNE/y9ZEucaXINUF/Z4M6NBeukNVTXr81jKbprC7T+11/ClqRk0Ozb0We
         gmfGqAEyLVuFwfO5ZyjleyM7/i4DNcYjChR4Ujpr9Xs2CkESUKRVSf/V7XpeTfKhnIkc
         OcXl6BS8foTBRVm+lM/1kX2A9WFTg1SAwoDXRL4S3akrSHXBED7WjYlS1fSnDZcHQ3/K
         wx8Sp4KKtW5RYZDXPFjsd9uLeJoDoDltBbg0YLvCPEXdTnWJHhqYuCJyhfuKPamudBQS
         gCmcyXJ/yDTJbyje331GYchOfT9JnN0o4dQog31w5DQA2jmrFOLJHrgjLzTeAPiL97Ma
         YVyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=DpNV65Youz9rtc8RuhOsGHbzi/Opb6nleTtFSXR4wv8=;
        b=t6JIiGNcrqOZMkGw8eYTgZ/0tCXCdg8qLT9RKY367DUiL49TZ37/mHqIXpFaoWRbz3
         IODhaeZEwH0H/BE2ggV0waac+Wt+3kVZXeI6S7+S/QKRYqyRssU2OWGQ7foXEdMT1SfX
         avztGBnwf07/7OT30txsLaLxs1TfuDSuz+ydmf9X3gvsa/7eARrMrnXDmW9cmgk426ag
         jTij2UNYE/Dx8Mc6iZDtu8mnn3GRcvw3UxKIs5/6jy5oAJc93hKE/JVBpM2MpnN7VcHe
         Uii6HD446SaADXmp9omWXJ5p4hjqDME4+FTkL6okFowcJUl1yrH8/PT/fKb5AuYCn9Qe
         ppBw==
X-Gm-Message-State: APjAAAWPN/duIuSJgAdopb64OpHd5+45hUbNUN5/Jb7C/wvJGz5Qrap4
        ZWxLUo2XGaO6/Z0LAUB+bQm+0uW04dwtYw==
X-Google-Smtp-Source: APXvYqyNu22fSY+DSnxbH++feELYlCDdzGluynCJ8Z1di8r5em/wpb+/GNtGMWSa+/I1OHtfosOD3Z5Obx1yCA==
X-Received: by 2002:a63:b90a:: with SMTP id z10mr9889531pge.257.1558019401285;
 Thu, 16 May 2019 08:10:01 -0700 (PDT)
Date:   Thu, 16 May 2019 08:09:57 -0700
Message-Id: <20190516150957.217157-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH net] net: avoid weird emergency message
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When host is under high stress, it is very possible thread
running netdev_wait_allrefs() returns from msleep(250)
10 seconds late.

This leads to these messages in the syslog :

[...] unregister_netdevice: waiting for syz_tun to become free. Usage count = 0

If the device refcount is zero, the wait is over.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 108ac8137b9be8bc7041b3e49e09c25eeb891d8f..b6b8505cfb3e2394f74b41b8e01055c697ad384b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8927,7 +8927,7 @@ static void netdev_wait_allrefs(struct net_device *dev)
 
 		refcnt = netdev_refcnt_read(dev);
 
-		if (time_after(jiffies, warning_time + 10 * HZ)) {
+		if (refcnt && time_after(jiffies, warning_time + 10 * HZ)) {
 			pr_emerg("unregister_netdevice: waiting for %s to become free. Usage count = %d\n",
 				 dev->name, refcnt);
 			warning_time = jiffies;
-- 
2.21.0.1020.gf2820cf01a-goog

