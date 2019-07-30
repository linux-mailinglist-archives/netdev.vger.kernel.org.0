Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7FFB7A8E9
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 14:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729940AbfG3MpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 08:45:22 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42497 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbfG3MpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 08:45:22 -0400
Received: by mail-ed1-f67.google.com with SMTP id v15so62467634eds.9
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 05:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=XqRXzS8tuHZl8oC93VHtgriWIAlCqLKuRw/mcon2IGk=;
        b=b9kmar6n0xEU6gj0fCgUOxflyDJ+VUPFvmQ/1KShAaeRxxMtVCrlXQmgLCwn59f77+
         LeeP2FM1ZoL9fZqF6pBaMYebQ9yFdj70djgexlXOR+YpNdbY2RDEJvYiqQvUcsMTsIsa
         pjeA+/APmcUZRMmt9ejvH9TOufIPEdgzN/ItvaPFiMGj/uedP+Ax+7Vjtjsh8WOSFXFx
         fDSOep3QKAPju6VqSqs6AHyNdNCKAS8WagBSytj02O9URuIvmSswsycBJ3p8nR2YlhCw
         YtLcJDDxXcXlBcjaEh7NUCN4ouUw1fqdWr6h29XrFiGEHJNILbuyizQIXfpEVOEX+ny9
         CyTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XqRXzS8tuHZl8oC93VHtgriWIAlCqLKuRw/mcon2IGk=;
        b=rgCb6qx3PfICQOIeWIOrobh4KibdXQuHdBeSRQg34i6n8/LRhqgL/R0tvU8IpYnrwn
         l2lK+ZH3+YbbR9Rcb0wHUAYi/+TDgbhrVo95bQXLUzaHpcL+zKNYk566V1J7wBvOU4fF
         zZkdGzLPVjjtLSXDgG3J5Uu5J4fC3dQzkpn8z2PaKlceo3tMXY1tdtHgcVIkUX8KUP2X
         jvBDD7uOTNqSoiogHbrKqBdya6X91Jaz6qGy5HeOuBaMjZTwjTFSnnuOBMDadebsmRTx
         nEAOWsV06v2i444/Pd7m0jovQge20DaWQ10n+NAG/pM9vv0PnTcLFrGwKL1LbFnubum3
         J6mw==
X-Gm-Message-State: APjAAAVo9mX0UoLa8e9dpFMR5aCOXY7j9x/rqR3i71MEgzJsKgbLPODf
        8lZ8x9OpkDap0AsGzAlcAatpWJqE
X-Google-Smtp-Source: APXvYqxAgOALNZlF9S2g5++V0b39cbIslrTpjLr5ZNMKI3syP5YI54F+ljQuB5sJNdeVXjwABblnRw==
X-Received: by 2002:aa7:c692:: with SMTP id n18mr99186501edq.220.1564490720467;
        Tue, 30 Jul 2019 05:45:20 -0700 (PDT)
Received: from tegmen.arch.suse.de (nat.nue.novell.com. [195.135.221.2])
        by smtp.gmail.com with ESMTPSA id k51sm16834557edb.7.2019.07.30.05.45.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 05:45:19 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
X-Google-Original-From: Denis Kirjanov <dkirjanov@suse.com>
To:     petkan@nucleusys.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH] net: usb: pegasus: fix improper read if get_registers() fail
Date:   Tue, 30 Jul 2019 14:45:05 +0200
Message-Id: <20190730124505.130940-1-dkirjanov@suse.com>
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

