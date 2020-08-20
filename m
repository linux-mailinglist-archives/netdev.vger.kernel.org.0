Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19BC524C0C2
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 16:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgHTOkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 10:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbgHTOjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 10:39:55 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C814C061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 07:39:54 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id ba10so1812521edb.3
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 07:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Uq4HkDogoW4dT9jnSus8e9Js6VYyxxpok1IFLt3So9w=;
        b=Ug9yPPrSM1lx/5KMxaiQkHk+r0zlzT81IAg53jQVM3/f+QN/reN8IwaMyD/x7vyv5f
         orHmuMsIowjxZsDnefIxVvGS8RaN00quTCQaHDlzLS0oa+S23saX1a4mvCPeweT0xj9V
         gjHTXa+wgocF1BYlrKe5PlQt/atXfWVN3SktMesH5sUV5JscprYolepLmjkvM/n5MMnC
         jwwvyBhEjYLtiq5zHtTD0DYxns3wtRpNYXALSt4YL9dDZo3jm0p1s8b3a6onR4BZZ4pi
         RQOCEGoJPaF2zxkPuCTd+dVPBhnibgbgbKdmNFrdACwZJ+fnOaqq/4FMkh8ntWlh+xO1
         WHCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Uq4HkDogoW4dT9jnSus8e9Js6VYyxxpok1IFLt3So9w=;
        b=bDLnXJ+5OxaDZMoKP1wG2m++jOGqCjb/QNf3VMeUD04oeqHaEKrlzCGbxPY5sEJCGc
         XGubEe83RoAoS997DvhPwosQ2eN+EJ23iqmFiGhhOOeijuEqAD4ZAEopnfFBv7R2vG8q
         9x9f0UgFsu4a4QSuYC5OCQYe1PGTzw7zEfBexQ29mMyAr8hCwJ0wNGlDqK/zbhs4zj1E
         bFBCyKad1/SU7A1mntsPFNpg2Z//YDLwpwCc6P3s3dQkMr3oeo3gE4+zUiOTXI0kxPnf
         /C1E6Rqk3xkZaoKjKDP2QWsW/2TdEuphhHvdgos4kRxEBuWG0mTqTV/tbOEDGjtcvw4H
         qZZQ==
X-Gm-Message-State: AOAM531mb4IhRYadb2Qv4YTt/YIYUNIl1yfBo/d3w4qdP8zp/DrR8z7m
        nZN+p+FOhHk3iD4QkjUifuw5Kg==
X-Google-Smtp-Source: ABdhPJxFH+LNmDk18KrryE/nsfZ+macQNpBkFoX97b+bNf/0khNSGYWCcyYr4mBjbCFR5g89zsr2Fg==
X-Received: by 2002:aa7:d515:: with SMTP id y21mr3075492edq.381.1597934393341;
        Thu, 20 Aug 2020 07:39:53 -0700 (PDT)
Received: from madeliefje.horms.nl ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id m24sm1542511eje.80.2020.08.20.07.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 07:39:52 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Louis Peens <louis.peens@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next 1/2] nfp: flower: check that we don't exceed the FW key size
Date:   Thu, 20 Aug 2020 16:39:37 +0200
Message-Id: <20200820143938.21199-2-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200820143938.21199-1-simon.horman@netronome.com>
References: <20200820143938.21199-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@netronome.com>

Add a check to make sure the total length of the flow key sent to the
firmware stays within the supported limit.

Signed-off-by: Louis Peens <louis.peens@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/main.h  |  2 ++
 drivers/net/ethernet/netronome/nfp/flower/match.c | 11 +++++++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 3bf9c1afa45e..4924a217f5ba 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -30,6 +30,8 @@ struct nfp_app;
 #define NFP_FLOWER_MASK_ELEMENT_RS	1
 #define NFP_FLOWER_MASK_HASH_BITS	10
 
+#define NFP_FLOWER_KEY_MAX_LW		32
+
 #define NFP_FL_META_FLAG_MANAGE_MASK	BIT(7)
 
 #define NFP_FL_MASK_REUSE_TIME_NS	40000
diff --git a/drivers/net/ethernet/netronome/nfp/flower/match.c b/drivers/net/ethernet/netronome/nfp/flower/match.c
index f7f01e2e3dce..64690511e47b 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/match.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/match.c
@@ -434,6 +434,7 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
 	u32 port_id;
+	int ext_len;
 	int err;
 	u8 *ext;
 	u8 *msk;
@@ -589,5 +590,15 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 		}
 	}
 
+	/* Check that the flow key does not exceed the maximum limit.
+	 * All structures in the key is multiples of 4 bytes, so use u32.
+	 */
+	ext_len = (u32 *)ext - (u32 *)nfp_flow->unmasked_data;
+	if (ext_len > NFP_FLOWER_KEY_MAX_LW) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "unsupported offload: flow key too long");
+		return -EOPNOTSUPP;
+	}
+
 	return 0;
 }
-- 
2.20.1

