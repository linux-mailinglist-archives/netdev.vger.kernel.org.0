Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0BFEC49F
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 15:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfKAOY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 10:24:29 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:32977 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbfKAOY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 10:24:28 -0400
Received: by mail-pf1-f194.google.com with SMTP id c184so7210522pfb.0
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 07:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9IHvnBSUrDy/0DYdv8nzJjC4Qb9xT876DUgC/nGixdg=;
        b=iSmNz8NQ0pgtEIqu4lbggfqBER/eCvRutF590EdldSWDRSnkSVEjNKHTMm2VYsvEn+
         BpUBHRIGn6r8owK9RFKMwH5TVK/EfkQVJHlRq72Sto3gu70um8YQOY1raTnX8yg+dyMG
         314mn3bVUgu8H1nRDuQwa4ckWU0ix9MddbOCClHrdXdxUmc1mMWQLsNJO4rWBkfeX6WN
         amPA6qTLFHAH9faCI1p/MJYLEt4ThxyFYD/9sctspbc4kfLdzpN/sJlKoSCcqCI1bL70
         GKhUaQhnTSZE99SP4PxQldraRvm3fhZFVrnF65/kYfqmQ10VdksZ7JzsrTajt3mSFppS
         wTmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9IHvnBSUrDy/0DYdv8nzJjC4Qb9xT876DUgC/nGixdg=;
        b=GZAt/gG9Wuu5hQn/qyzu1nwx3HfZHK9l1O2T8ZW9e/8dRQ6cVyvaE4W93QhopKjITf
         w72Ny75oWKfB3z1RcHC2iFAyMgp1FoJj6uoc0U26aVRlnhqTQJ/knW0DGFLqOrO+2b7D
         YUP87sB/I+cZ/EVz1i/+zqlW+5PhvNhNnLgiwxIb6nPG+QjEHHF6kIV0SIrVfIStTrUD
         21wTYyHeC1Cpu3reqzozxcgE4LosG/zBiwZD/5MtLiWGQukEAxAId0K2qnpiLl1iYUqZ
         jIWuJdv+CNRvb4xlw7BwQS35uzr47tSUwNmTLIpgWungNdcltsvRSQPtNHj4kfkS2pyw
         t5ug==
X-Gm-Message-State: APjAAAXUNZAToKAtiD04YjHho0NxJSnE7rYSLj8zyO4WOyqpU+wZdfXH
        I+xYEkQK1L3/fYNgHTLHnp8=
X-Google-Smtp-Source: APXvYqz1JsEJuFdZfU9gMAvyChxTiqLfmxBoHwp2jCP3aNEOAA4a+z2mvFIPVlma8P9lGppn5wyEdg==
X-Received: by 2002:a63:f919:: with SMTP id h25mr5628710pgi.85.1572618267099;
        Fri, 01 Nov 2019 07:24:27 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([1.203.173.208])
        by smtp.gmail.com with ESMTPSA id c12sm8296499pfp.67.2019.11.01.07.24.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Nov 2019 07:24:26 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v6 06/10] net: openvswitch: simplify the flow_hash
Date:   Fri,  1 Nov 2019 22:23:50 +0800
Message-Id: <1572618234-6904-7-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Simplify the code and remove the unnecessary BUILD_BUG_ON.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Tested-by: Greg Rose <gvrose8192@gmail.com>
Acked-by: William Tu <u9012063@gmail.com>
---
 net/openvswitch/flow_table.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index a10d421..96757e2 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -432,13 +432,10 @@ int ovs_flow_tbl_flush(struct flow_table *flow_table)
 static u32 flow_hash(const struct sw_flow_key *key,
 		     const struct sw_flow_key_range *range)
 {
-	int key_start = range->start;
-	int key_end = range->end;
-	const u32 *hash_key = (const u32 *)((const u8 *)key + key_start);
-	int hash_u32s = (key_end - key_start) >> 2;
+	const u32 *hash_key = (const u32 *)((const u8 *)key + range->start);
 
 	/* Make sure number of hash bytes are multiple of u32. */
-	BUILD_BUG_ON(sizeof(long) % sizeof(u32));
+	int hash_u32s = range_n_bytes(range) >> 2;
 
 	return jhash2(hash_key, hash_u32s, 0);
 }
-- 
1.8.3.1

