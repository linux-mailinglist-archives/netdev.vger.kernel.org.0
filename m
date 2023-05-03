Return-Path: <netdev+bounces-222-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 95EC96F6067
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 23:04:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE0F41C21041
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 21:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EC53BE6F;
	Wed,  3 May 2023 21:04:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BEFBE4C
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 21:04:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58DB7A96
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 14:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683147848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8sEtZ4KKiBJy1POn8D3R9hO+Z4vqPZk3VVqn1QTUgNY=;
	b=G/xtCcOn5HSGHUw+9L1WB/q5binKSRQF9T88ya+/YwTNOnR5lMAWrRKhs5fjSW380pYATS
	gWAe0k3tWf+dGDhmwxzK5XPAoh6tInqxC0x17I0r/meSAcwttkNapDxaSeL2493gYiGWhH
	aNlxOgDlL0UHHxDrXgPnxT9TkNO4T0E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-451-fJg2bl7TOeqo1WYiWd5sJg-1; Wed, 03 May 2023 17:04:05 -0400
X-MC-Unique: fJg2bl7TOeqo1WYiWd5sJg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3B4710504A5;
	Wed,  3 May 2023 21:04:04 +0000 (UTC)
Received: from fedora-x1.redhat.com (unknown [10.22.10.67])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3B0452166B26;
	Wed,  3 May 2023 21:04:03 +0000 (UTC)
From: Kamal Heib <kheib@redhat.com>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	kheib@redhat.com
Subject: [PATCH iproute2-next] rdma: Report device protocol
Date: Wed,  3 May 2023 17:03:42 -0400
Message-Id: <20230503210342.66155-1-kheib@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add support for reporting the device protocol.

$ rdma dev
11: mlx5_0: node_type ca proto roce fw 12.28.2006
    node_guid 248a:0703:004b:f094 sys_image_guid 248a:0703:004b:f094
12: mlx5_1: node_type ca proto ib fw 12.28.2006
    node_guid 248a:0703:0049:d4f0 sys_image_guid 248a:0703:0049:d4f0
13: mlx5_2: node_type ca proto ib fw 12.28.2006
    node_guid 248a:0703:0049:d4f1 sys_image_guid 248a:0703:0049:d4f0
17: siw0: node_type rnic proto iw node_guid
    0200:00ff:fe00:0000 sys_image_guid 0200:00ff:fe00:0000

Signed-off-by: Kamal Heib <kheib@redhat.com>
---
 rdma/dev.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/rdma/dev.c b/rdma/dev.c
index c684dde4a56f..04c2a574405c 100644
--- a/rdma/dev.c
+++ b/rdma/dev.c
@@ -189,6 +189,16 @@ static void dev_print_node_type(struct rd *rd, struct nlattr **tb)
 			   node_str);
 }
 
+static void dev_print_dev_proto(struct rd *rd, struct nlattr **tb)
+{
+       const char *str;
+       if (!tb[RDMA_NLDEV_ATTR_DEV_PROTOCOL])
+               return;
+
+       str = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_PROTOCOL]);
+       print_color_string(PRINT_ANY, COLOR_NONE, "proto", "proto %s ", str);
+}
+
 static int dev_parse_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
@@ -206,6 +216,7 @@ static int dev_parse_cb(const struct nlmsghdr *nlh, void *data)
 	print_color_string(PRINT_ANY, COLOR_NONE, "ifname", "%s: ", name);
 
 	dev_print_node_type(rd, tb);
+	dev_print_dev_proto(rd, tb);
 	dev_print_fw(rd, tb);
 	dev_print_node_guid(rd, tb);
 	dev_print_sys_image_guid(rd, tb);
-- 
2.40.1


