Return-Path: <netdev+bounces-6182-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EBAA7150FD
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 23:42:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B7D041C20AB0
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 21:42:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A11110971;
	Mon, 29 May 2023 21:42:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1157C
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 21:42:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06878CF
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 14:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685396552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=BcMdRyXE7H5peXDHahPrVN1tKGd535ReTVl8Ek9QGuE=;
	b=O9iSem64HK5A6WqNfuucAiABeLOrhbBJGVwFE+JT//D6OKo+rsSX1ru90Qp217kpvo9dPr
	QqOhODkHs+9HJT+vKbtho8ttWROdAejP1tiwFY46rEcHKgTJx7WmQIyhg8h0pGtQjiXAml
	enq+0MPQqrEDaLN4iUvzc9HK8fKEF6Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-264-CEy74gIqM5SMslk_CEeDVw-1; Mon, 29 May 2023 17:42:26 -0400
X-MC-Unique: CEy74gIqM5SMslk_CEeDVw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74633101A53A;
	Mon, 29 May 2023 21:42:26 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.192.39])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AABB5C154D1;
	Mon, 29 May 2023 21:42:24 +0000 (UTC)
From: Andrea Claudi <aclaudi@redhat.com>
To: netdev@vger.kernel.org
Cc: stephen@networkplumber.org,
	dsahern@gmail.com
Subject: [PATCH iproute2] iproute_lwtunnel: fix array boundary check
Date: Mon, 29 May 2023 23:42:16 +0200
Message-Id: <f20348ddef412b090829a025f92718158450eb6f.1685396319.git.aclaudi@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

seg6_mode_types is made up of 5 elements, so ARRAY_SIZE(seg6_mode_types)
evaluates to 5. Thus, when mode = 5, this function returns
seg6_mode_types[5], resulting in an out-of-bound access.

Fix this bailing out when mode is equal to or greater than 5.

Fixes: cf87da417bb4 ("iproute: add support for seg6 l2encap mode")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 ip/iproute_lwtunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index 96de3b20..94985972 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -140,7 +140,7 @@ static const char *seg6_mode_types[] = {
 
 static const char *format_seg6mode_type(int mode)
 {
-	if (mode < 0 || mode > ARRAY_SIZE(seg6_mode_types))
+	if (mode < 0 || mode >= ARRAY_SIZE(seg6_mode_types))
 		return "<unknown>";
 
 	return seg6_mode_types[mode];
-- 
2.40.1


