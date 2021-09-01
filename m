Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215263FDEFB
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 17:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343807AbhIAPuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 11:50:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48648 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343806AbhIAPtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 11:49:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630511328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lY6FHcyagtkCfpanNgkbTGxz6E1KZnTksRuPUbRJYko=;
        b=MKDR0pMQ8K0kkNqUkQxw+hM5fjZTqASn9O4Ilr8p0GWJo0xycdp2MKyVpRWpZ0emce/bWJ
        CZYrLyqsJnlwWg7OfLNQaTZRYqAc6tr0whBhaKyCx457YG18iftGelRFQCx7JxrkspbJ7w
        UaMgOVLTq3l8CQIt6qiChq/y2GSywHc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-OYUt3_K8OcWwrFOj1LsSLw-1; Wed, 01 Sep 2021 11:48:45 -0400
X-MC-Unique: OYUt3_K8OcWwrFOj1LsSLw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1082512B;
        Wed,  1 Sep 2021 15:48:43 +0000 (UTC)
Received: from dmarchan.remote.csb (unknown [10.40.192.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CEA6810016FB;
        Wed,  1 Sep 2021 15:48:35 +0000 (UTC)
From:   David Marchand <david.marchand@redhat.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, david.marchand@redhat.com,
        maxime.coquelin@redhat.com, sriram.narasimhan@hp.com,
        jasowang@redhat.com
Subject: [PATCH iproute2] iptuntap: fix multi-queue flag display
Date:   Wed,  1 Sep 2021 17:48:26 +0200
Message-Id: <20210901154826.31109-1-david.marchand@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When creating a tap with multi_queue flag, this flag is not displayed
when dumping:

$ ip tuntap add tap23 mode tap multi_queue
$ ip tuntap
tap23: tap persist0x100

While at it, add a space between known flags and hexdump of unknown
ones.

Fixes: c41e038f48a3 ("iptuntap: allow creation of multi-queue tun/tap device")
Signed-off-by: David Marchand <david.marchand@redhat.com>
---
 ip/iptuntap.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/ip/iptuntap.c b/ip/iptuntap.c
index 9cdb4a80..96ca1ae7 100644
--- a/ip/iptuntap.c
+++ b/ip/iptuntap.c
@@ -243,6 +243,9 @@ static void print_flags(long flags)
 	if (flags & IFF_ONE_QUEUE)
 		print_string(PRINT_ANY, NULL, " %s", "one_queue");
 
+	if (flags & IFF_MULTI_QUEUE)
+		print_string(PRINT_ANY, NULL, " %s", "multi_queue");
+
 	if (flags & IFF_VNET_HDR)
 		print_string(PRINT_ANY, NULL, " %s", "vnet_hdr");
 
@@ -253,9 +256,10 @@ static void print_flags(long flags)
 		print_string(PRINT_ANY, NULL, " %s", "filter");
 
 	flags &= ~(IFF_TUN | IFF_TAP | IFF_NO_PI | IFF_ONE_QUEUE |
-		   IFF_VNET_HDR | IFF_PERSIST | IFF_NOFILTER);
+		   IFF_MULTI_QUEUE | IFF_VNET_HDR | IFF_PERSIST |
+		   IFF_NOFILTER);
 	if (flags)
-		print_0xhex(PRINT_ANY, NULL, "%#llx", flags);
+		print_0xhex(PRINT_ANY, NULL, " %#llx", flags);
 
 	close_json_array(PRINT_JSON, NULL);
 }
-- 
2.23.0

