Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9EE58D0D
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 23:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfF0VbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 17:31:14 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33857 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbfF0VbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 17:31:13 -0400
Received: by mail-pf1-f193.google.com with SMTP id c85so1867809pfc.1
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 14:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oPUnlR3IocPQry83CmSKQwmnrO3o5gpAtaL1JK7tJ4k=;
        b=QoiYUgPjTI/kTJZmp/uCXs8cFL6TZKXWJ5M2WOiywJytdjVRLKjjW6ix6nSUK9Oim5
         F1dD4oQxoPErXS+wQQ8mBrFGx6CXcaLmavzwWxC3qlgak6p3hpQywc+F8vv610h0A9+2
         y1gJpnc1jL0Utr5y0LH6VXvauC4tNS2XcvXvZxd95U71FZJ2py/iW64Yz9bt7t9sKXMX
         ngN46Nml1TQM8xH8FRe/glkrvGLjwKJD0QYbB/aR+sv66pYcR8kTSMymGziJMSPw5gK2
         tq4n2S9EiWo2Q63i7P3msshOjwSrke4Z11Oho9jrQtqOhgVHsoYztUh6z+tNQ7aNX+EJ
         kIcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oPUnlR3IocPQry83CmSKQwmnrO3o5gpAtaL1JK7tJ4k=;
        b=NemaIZXYQ/gFKiG348oDkLsJDDldQYP9hFhbfAEjCs1AGnAU/fWL45VFcAQIw4R6IX
         YH9Yxcc0GDDDwYh8HZXJxAyLUrivoL0rEQTrABHLQxH+4LPhF3HwV9saKk1DLJL3Uuan
         3ZRoEHauxKcSw+pXNOgj0a9/W8CObF3HU8752IQWz5LMJ9pyV/DILYaNOX37KD40Kart
         YYVh9hLA18r0cW6Ad/nVTB8nb9Q6o5GMrIF6f5rLJfvIrxT41Y4WWhutgYu7PF+k9RSx
         IWaTou2+eeSmPRAoHxn7PtIAfSaEz0Bs1LVb0MXoRAw5t0hPMuEd9O1qcH4sCOaeqEdI
         f2kg==
X-Gm-Message-State: APjAAAWicYL8Ns0I9/wG818hmwXKOhTUTQw6fjIvClnsu9Z2xz6rFGSo
        T06555W9GbzdQEkNka6rq4/GGBj9ZDU=
X-Google-Smtp-Source: APXvYqxjHtGW0chdGIodrIipECKBWDBOg5/n6vz4vKZF/a5LiVE/5Nl0kxbWdANhlYy0lFOmY+GyNw==
X-Received: by 2002:a63:593:: with SMTP id 141mr4987859pgf.78.1561671072941;
        Thu, 27 Jun 2019 14:31:12 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id n7sm39232pff.59.2019.06.27.14.31.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 14:31:12 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+d6636a36d3c34bd88938@syzkaller.appspotmail.com
Subject: [Patch net] netrom: fix a memory leak in nr_rx_frame()
Date:   Thu, 27 Jun 2019 14:30:58 -0700
Message-Id: <20190627213058.3028-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the skb is associated with a new sock, just assigning
it to skb->sk is not sufficient, we have to set its destructor
to free the sock properly too.

Reported-by: syzbot+d6636a36d3c34bd88938@syzkaller.appspotmail.com
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/netrom/af_netrom.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 86b87925ef34..96740d389377 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -869,7 +869,7 @@ int nr_rx_frame(struct sk_buff *skb, struct net_device *dev)
 	unsigned short frametype, flags, window, timeout;
 	int ret;
 
-	skb->sk = NULL;		/* Initially we don't know who it's for */
+	skb_orphan(skb);
 
 	/*
 	 *	skb->data points to the netrom frame start
@@ -968,6 +968,7 @@ int nr_rx_frame(struct sk_buff *skb, struct net_device *dev)
 	window = skb->data[20];
 
 	skb->sk             = make;
+	skb->destructor     = sock_efree;
 	make->sk_state	    = TCP_ESTABLISHED;
 
 	/* Fill in his circuit details */
-- 
2.21.0

