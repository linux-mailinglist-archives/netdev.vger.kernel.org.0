Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C82D1253E3D
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 08:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgH0Gyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 02:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbgH0Gyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 02:54:35 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FC1C061264;
        Wed, 26 Aug 2020 23:54:35 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id v15so2664274pgh.6;
        Wed, 26 Aug 2020 23:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=BCoL4GC0gNjAzmmMRfC/gvKA1COigx1ubzs0rhx5Lso=;
        b=VLaHMikwWNRlOpknfV2L9wpgFm0GPiV2o5zjbJeBijU7IWF/iGoEDEtGbJ30Le5UJP
         NoqQ+oAZ1FPOvuYv3mdRXTebnPgvys7VyNehhUDcGw10vRx67egVgmkiMU3ixxBzEb0y
         qlHVOFlfp3X8UeIfVeaA+NDFD+PQhTi6kaWX7KXk5v1S5tKZYDb+bhEEUhN8xVPWpHcC
         5z7XBCqEi4IpxYh7u9+migwkB6amlkIj4SKK9+mGCYqX8Tu2VImrbFBQq05jI23dJhPB
         jrEUwfSL15fXZsi2Jg16d5kqgVDo4xTELNvBpdh4Mywl0I6sfHiRDR8rwOwy2lpvUacI
         r9YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BCoL4GC0gNjAzmmMRfC/gvKA1COigx1ubzs0rhx5Lso=;
        b=X0sqjMaWBh+fM/Vr6Rfb4W2suUWr2K7G65Eseg1/koy36hzsB3ouv+ZrvNY4rCheri
         PCv3BYmJbJwF/TCshM8387ghhyHnXgq72rH1xaV9WsU023Bfkwz00WqQhUgd89xxiQde
         JeV4OebA8+mAzlnyBPbsEOpK+m3QvYCP4mmTsQ5KtQanhsRU1JO8y+/xlaPQUceiXWLc
         8uBmwOfxjOu1FIvJZZFk/Ydjua3uswnDgCr9TnIkANzEqpwebX+k98lOFD+4UpgzslCi
         od+B2Q1FMJQ6PTSWeAwI1GXgGwhsLvmlQVfeyv63QoaMyUsvdKo2+rZBrSVZKfsHb+aa
         g4Dg==
X-Gm-Message-State: AOAM5307piuX2AFajqBG2Xf0F6QGjOK7G25+20TiZu7pp+BFc2XdnBKP
        lWYW3O6KGdI/ck2pBiiBwJY=
X-Google-Smtp-Source: ABdhPJx50mcT7++XwHrFN234jCQjWBTei+BiA76W2qY8K8ZVAoJvc/yUmoOJ7RUT03UT0V23iKGDeA==
X-Received: by 2002:a63:1b0b:: with SMTP id b11mr14028827pgb.447.1598511274585;
        Wed, 26 Aug 2020 23:54:34 -0700 (PDT)
Received: from localhost.localdomain ([2405:204:810b:d5b5:fcb1:360f:550f:6dac])
        by smtp.gmail.com with ESMTPSA id o2sm1162174pjh.4.2020.08.26.23.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 23:54:34 -0700 (PDT)
From:   Himadri Pandya <himadrispandya@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        gregkh@linuxfoundation.org,
        Himadri Pandya <himadrispandya@gmail.com>
Subject: [PATCH] net: usb: Fix uninit-was-stored issue in asix_read_phy_addr()
Date:   Thu, 27 Aug 2020 12:23:55 +0530
Message-Id: <20200827065355.15177-1-himadrispandya@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The buffer size is 2 Bytes and we expect to receive the same amount of
data. But sometimes we receive less data and run into uninit-was-stored
issue upon read. Hence modify the error check on the return value to match
with the buffer size as a prevention.

Reported-and-tested by: syzbot+a7e220df5a81d1ab400e@syzkaller.appspotmail.com
Signed-off-by: Himadri Pandya <himadrispandya@gmail.com>
---
 drivers/net/usb/asix_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index e39f41efda3e..7bc6e8f856fe 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -296,7 +296,7 @@ int asix_read_phy_addr(struct usbnet *dev, int internal)
 
 	netdev_dbg(dev->net, "asix_get_phy_addr()\n");
 
-	if (ret < 0) {
+	if (ret < 2) {
 		netdev_err(dev->net, "Error reading PHYID register: %02x\n", ret);
 		goto out;
 	}
-- 
2.17.1

