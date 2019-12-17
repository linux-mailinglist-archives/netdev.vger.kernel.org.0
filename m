Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2E5412392D
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 23:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfLQWMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 17:12:39 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39073 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbfLQWMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 17:12:39 -0500
Received: by mail-lf1-f68.google.com with SMTP id y1so149175lfb.6
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 14:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+VxjxeAv2t9rsmhLG5vd4txDaJ2R/vecyIcH3T4Q9hE=;
        b=EnGUkdVDhptludmZ76o1klnD3F/+HFYq1Y5qf6wgSUJmJNWnsA9nbg+sbsZjdP57ja
         zMvO/72lYIm8rqejsl02m2QZg3bio234mQfwmbF5u8Pjdo/YH05WSs951pQtuJ0NUTrg
         F62z4wukaceEAK3hFu6z3m+V//yZk29Ew66nN8H+VmRz/mVMJ+KfnMRj5iP5rj4i14hY
         0BdBmq8Li0pnnUGBHQ9YCmvQP6q0bBqJtSabWZdgecryqbn8bjqsbY3lOv5FV2JGz/mN
         WhYfuhRiw8w/Q5sZN9G8hzepxF7dEvW6smS1xKgz4Qu25Y3qpWZZIbMhUTsxp8XrG/tj
         W9lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+VxjxeAv2t9rsmhLG5vd4txDaJ2R/vecyIcH3T4Q9hE=;
        b=QO5LnlL9TdGN428ZV8aYJWqlDicJpYtKtLqMx5lkV64mU1mfppIGM7pj0maa8DavN7
         bL5nXYCOtTDdofsBg5bE6Y7MooXxcVMssDI0TriKUSHTgpO1j7JQrJ0QDFePSNbdFTcG
         INsYqt4pdChGlpH96qfmv75//+2irOANig8nGC0TdIKkM26rJq8iXqibhyO+EzWQ52ap
         z1/isHF1ZwwBPETyf/hoTUHjhz1jfZASMjHN+HLurhAe3vBDewQYX6AtNN8lPbcKFInE
         5cz9TRZiG6nJlnVMR97UlVW58ftHdurNNlWRkUSD+E9yL3D3smVgy784NDHOylRU2tpy
         ILbA==
X-Gm-Message-State: APjAAAWajBztWl2tKrbSb+c9YBBbL7mDwdXSpOn3lcfgBK+M4BnkSs3y
        EGRz7Ncn67kOO1tx7F6Idi0eZg==
X-Google-Smtp-Source: APXvYqwx8VuApWKYJabNsFFkZTk2RNmp7SyClGkQ9uz9CtT2TNw1lTEEMKrVtuUWRHe+Fg+zQ/fJhQ==
X-Received: by 2002:a19:40d8:: with SMTP id n207mr4258395lfa.4.1576620756873;
        Tue, 17 Dec 2019 14:12:36 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id u9sm13333440lju.95.2019.12.17.14.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 14:12:36 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 1/3] nfp: pass packet pointer to nfp_net_parse_meta()
Date:   Tue, 17 Dec 2019 14:12:00 -0800
Message-Id: <20191217221202.12611-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191217221202.12611-1-jakub.kicinski@netronome.com>
References: <20191217221202.12611-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make nfp_net_parse_meta() take a packet pointer and return
a drop/no drop decision. Right now it returns the end of
metadata and caller compares it to the packet pointer.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 .../ethernet/netronome/nfp/nfp_net_common.c    | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index d4eeb3b3cf35..780bd1daa601 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1661,9 +1661,9 @@ nfp_net_set_hash_desc(struct net_device *netdev, struct nfp_meta_parsed *meta,
 			 &rx_hash->hash);
 }
 
-static void *
+static bool
 nfp_net_parse_meta(struct net_device *netdev, struct nfp_meta_parsed *meta,
-		   void *data, int meta_len)
+		   void *data, void *pkt, int meta_len)
 {
 	u32 meta_info;
 
@@ -1694,13 +1694,13 @@ nfp_net_parse_meta(struct net_device *netdev, struct nfp_meta_parsed *meta,
 			data += 4;
 			break;
 		default:
-			return NULL;
+			return true;
 		}
 
 		meta_info >>= NFP_NET_META_FIELD_SIZE;
 	}
 
-	return data;
+	return data != pkt;
 }
 
 static void
@@ -1885,12 +1885,10 @@ static int nfp_net_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 			nfp_net_set_hash_desc(dp->netdev, &meta,
 					      rxbuf->frag + meta_off, rxd);
 		} else if (meta_len) {
-			void *end;
-
-			end = nfp_net_parse_meta(dp->netdev, &meta,
-						 rxbuf->frag + meta_off,
-						 meta_len);
-			if (unlikely(end != rxbuf->frag + pkt_off)) {
+			if (unlikely(nfp_net_parse_meta(dp->netdev, &meta,
+							rxbuf->frag + meta_off,
+							rxbuf->frag + pkt_off,
+							meta_len))) {
 				nn_dp_warn(dp, "invalid RX packet metadata\n");
 				nfp_net_rx_drop(dp, r_vec, rx_ring, rxbuf,
 						NULL);
-- 
2.23.0

