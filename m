Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 113097A938
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 15:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730096AbfG3NOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 09:14:06 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:40517 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728361AbfG3NOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 09:14:06 -0400
Received: by mail-ed1-f66.google.com with SMTP id k8so62503481eds.7
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 06:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=XqRXzS8tuHZl8oC93VHtgriWIAlCqLKuRw/mcon2IGk=;
        b=Wz+vAroFb5a7hW7YfQPs4F81Jjq3/GBnpuuO7VskpNsAFa0bFC+AfdYUsbSBnFW5Gk
         haCwZj5y8cLlLXr0T3Ph63x3LgCeZaR0/vAGnPjVFtt79/1oEushLEGLMFIKwBDoAnlo
         wcSghNA2yv52d/TNE/aN32ZRvDUNJsvpCYixWFbH+nKTHjmxIJIUvN3RUqD8DxHkYXSD
         GlbJ3TSsyZ2YC57C4PM5A3tKPM7bZVe9tHsBEjiTIozCoz+gXkcuRX2KBhwBixkFsq2x
         iM+iAERzaCr9UyVV8UNa/o9F5cKzmySjOEFRIq4nSPQ5BX+ktScTe2Yrrrx6KqeLh0pH
         K0mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XqRXzS8tuHZl8oC93VHtgriWIAlCqLKuRw/mcon2IGk=;
        b=igJICOawJdoSu4LU9UOV6lsSTw1by6GAwCjZf5b4n1M6tbi3hsVer5Ka1Z9ZghrPXJ
         UzgUuDM5PDX5Ed0cqk9sePGRVVSrCvfurj0OCAwMT32Mul/iJ2nKA4chBDxuIFsxQ6hb
         EYkgY0xXYQxX+akL+hRJDr0jNHkOvbyyQDbOF5w920w10sB4OrDq1her98oQ0oxZtewv
         ZDHb/Z3R86m8YeyZbqAwvhr/UeoMKKCsLJMkRpUAy29Q5FHL6he7rY9UgZ1ZSDNGkIjL
         0HpjJqt5z1coA76hOEqHlw6tsI+lrcbjLn90pVw3w8PIJjrSa/JAxqKEV9T0ppiCP/vG
         +wng==
X-Gm-Message-State: APjAAAWJR4sjHNZqWqoAc57P4iidB3MAkvnSbgGQuQcnMvbynuVm1AUT
        Xuq6ZV3MgPw7o51+inxXusw=
X-Google-Smtp-Source: APXvYqxNgiacUy7xFUslm83GwGOj97pe2XJ/TrYMuNYgYNNF27diwQYtynWrx325/Ct2bnhVj5KOLQ==
X-Received: by 2002:a50:883b:: with SMTP id b56mr101232765edb.178.1564492444333;
        Tue, 30 Jul 2019 06:14:04 -0700 (PDT)
Received: from tegmen.arch.suse.de (nat.nue.novell.com. [195.135.221.2])
        by smtp.gmail.com with ESMTPSA id w4sm11878175eja.34.2019.07.30.06.14.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 06:14:03 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
X-Google-Original-From: Denis Kirjanov <dkirjanov@suse.com>
To:     petkan@nucleusys.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH] net: usb: pegasus: fix improper read if get_registers() fail
Date:   Tue, 30 Jul 2019 15:13:57 +0200
Message-Id: <20190730131357.30697-1-dkirjanov@suse.com>
X-Mailer: git-send-email 2.12.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

get_registers() may fail with -ENOMEM and in this
case we can read a garbage from the status variable tmp.

Reported-by: syzbot+3499a83b2d062ae409d4@syzkaller.appspotmail.com
Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
---
 drivers/net/usb/pegasus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 6d25dea5ad4b..f7d117d80cfb 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -282,7 +282,7 @@ static void mdio_write(struct net_device *dev, int phy_id, int loc, int val)
 static int read_eprom_word(pegasus_t *pegasus, __u8 index, __u16 *retdata)
 {
 	int i;
-	__u8 tmp;
+	__u8 tmp = 0;
 	__le16 retdatai;
 	int ret;
 
-- 
2.12.3

