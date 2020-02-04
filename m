Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3A415148A
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 04:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgBDDZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 22:25:14 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36640 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbgBDDZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 22:25:13 -0500
Received: by mail-pf1-f193.google.com with SMTP id 185so8705165pfv.3
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 19:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=mTOd3ZHsOFhFYhBIpMTzD1CVED9iMsx+Md+Roh+wTgU=;
        b=qgl3h9TFKRvOsEKuEPd87yoRoKhr7gaCBXVc4AV4ZZTyAOwk5wGVBK1c/o8Xw6qXct
         ZGMkA+fvPPBuJ9OH8FaUBKZ+JO1fpKt5NC/OTkNcT3PBcj0Bd9yuMN2GG6vHYnRCC+3y
         WNpnGHZRN9hTpBEIdrSQpSsz2u8uT75EzU6iLmTUJE6d8dIATU28+d8J7bzMpsfS8mO5
         v6K2C4Vb4qg+TqGjYE+WU6/lPzSPY+GzCsw1029awsKQ+ptC58RcDe7X6hY3R8HXACQ6
         Ri3VUsO5Qv2BM5ZEhdMrRapbXzwf+lHticEzTxKGHg4RjQKouZGmiFGSrvc97TYCIx/9
         nS9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mTOd3ZHsOFhFYhBIpMTzD1CVED9iMsx+Md+Roh+wTgU=;
        b=MHdaoys4KpNm6OG0d7tGe3qKUg3MAF0YMtDMOb/0NGpjA2OmoPzMXyyxwFmaa2v9oi
         BGug7rpWFK7YlqGGzPIh/7iQFP4Jw0ScnB63biGg8VH0QBzXWHNsGR6IJTHUI8FdULoO
         bRrP03CdShMbdrRSC7IT20B0Rzmk0BhHJhfObigBdl9wdG2X4sSpE0/0E4mR6Q+TZOqq
         NaCw+f+KkDbc/EKEg3F0NhqHupnX2JkNvsMbCibh3Zr2aS9IewfY1PyVreZFXjzw+sLv
         XHB3sUuPJQsvY1d1UkgbINHd19XZYFTCCmS5ZhLoMcasX9/GXWzdadANeBKhr9xWIKAp
         uNrA==
X-Gm-Message-State: APjAAAXZD7wr9/GvBMq/+A5M1eMCa/HhxSqP7HtvxBxHMvvBitYuNRo9
        7Sh9ngaTRUOAgduZa/j3Rug=
X-Google-Smtp-Source: APXvYqwg7U1K+Ei274S5DBkSxRASQFheP886xqHPcqlYAVyv+JdlzPtOmc3nhn/dja+8vGXwz/CNBA==
X-Received: by 2002:a63:3d42:: with SMTP id k63mr5664924pga.318.1580786712884;
        Mon, 03 Feb 2020 19:25:12 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id w203sm22299302pfc.96.2020.02.03.19.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 19:25:11 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        laforge@gnumonks.org, netdev@vger.kernel.org,
        osmocom-net-gprs@lists.osmocom.org
Cc:     ap420073@gmail.com
Subject: [PATCH net] gtp: use __GFP_NOWARN to avoid memalloc warning
Date:   Tue,  4 Feb 2020 03:24:59 +0000
Message-Id: <20200204032459.15728-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gtp hashtable size is received by user-space.
So, this hashtable size could be too large. If so, kmalloc will internally
print a warning message.
This warning message is actually not necessary for the gtp module.
So, this patch adds __GFP_NOWARN to avoid this message.

Splat looks like:
[ 2171.200049][ T1860] WARNING: CPU: 1 PID: 1860 at mm/page_alloc.c:4713 __alloc_pages_nodemask+0x2f3/0x740
[ 2171.238885][ T1860] Modules linked in: gtp veth openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrag_ipv]
[ 2171.262680][ T1860] CPU: 1 PID: 1860 Comm: gtp-link Not tainted 5.5.0+ #321
[ 2171.263567][ T1860] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[ 2171.264681][ T1860] RIP: 0010:__alloc_pages_nodemask+0x2f3/0x740
[ 2171.265332][ T1860] Code: 64 fe ff ff 65 48 8b 04 25 c0 0f 02 00 48 05 f0 12 00 00 41 be 01 00 00 00 49 89 47 0
[ 2171.267301][ T1860] RSP: 0018:ffff8880b51af1f0 EFLAGS: 00010246
[ 2171.268320][ T1860] RAX: ffffed1016a35e43 RBX: 0000000000000000 RCX: 0000000000000000
[ 2171.269517][ T1860] RDX: 0000000000000000 RSI: 000000000000000b RDI: 0000000000000000
[ 2171.270305][ T1860] RBP: 0000000000040cc0 R08: ffffed1018893109 R09: dffffc0000000000
[ 2171.275973][ T1860] R10: 0000000000000001 R11: ffffed1018893108 R12: 1ffff11016a35e43
[ 2171.291039][ T1860] R13: 000000000000000b R14: 000000000000000b R15: 00000000000f4240
[ 2171.292328][ T1860] FS:  00007f53cbc83740(0000) GS:ffff8880da000000(0000) knlGS:0000000000000000
[ 2171.293409][ T1860] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2171.294586][ T1860] CR2: 000055f540014508 CR3: 00000000b49f2004 CR4: 00000000000606e0
[ 2171.295424][ T1860] Call Trace:
[ 2171.295756][ T1860]  ? mark_held_locks+0xa5/0xe0
[ 2171.296659][ T1860]  ? __alloc_pages_slowpath+0x21b0/0x21b0
[ 2171.298283][ T1860]  ? gtp_encap_enable_socket+0x13e/0x400 [gtp]
[ 2171.298962][ T1860]  ? alloc_pages_current+0xc1/0x1a0
[ 2171.299475][ T1860]  kmalloc_order+0x22/0x80
[ 2171.299936][ T1860]  kmalloc_order_trace+0x1d/0x140
[ 2171.300437][ T1860]  __kmalloc+0x302/0x3a0
[ 2171.300896][ T1860]  gtp_newlink+0x293/0xba0 [gtp]
[ ... ]

Fixes: 459aa660eb1d ("gtp: add initial driver for datapath of GPRS Tunneling Protocol (GTP-U)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/gtp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 7032a2405e1a..af07ea760b35 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -767,12 +767,12 @@ static int gtp_hashtable_new(struct gtp_dev *gtp, int hsize)
 	int i;
 
 	gtp->addr_hash = kmalloc_array(hsize, sizeof(struct hlist_head),
-				       GFP_KERNEL);
+				       GFP_KERNEL | __GFP_NOWARN);
 	if (gtp->addr_hash == NULL)
 		return -ENOMEM;
 
 	gtp->tid_hash = kmalloc_array(hsize, sizeof(struct hlist_head),
-				      GFP_KERNEL);
+				      GFP_KERNEL | __GFP_NOWARN);
 	if (gtp->tid_hash == NULL)
 		goto err1;
 
-- 
2.17.1

