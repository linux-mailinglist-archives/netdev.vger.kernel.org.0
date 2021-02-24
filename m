Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAAC324440
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 20:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235513AbhBXTAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 14:00:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32374 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235031AbhBXS60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 13:58:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614193019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v9LQLzVj/XgMadw/p7LX8ICKSHncxAimW+HcgNIftlg=;
        b=KAOMUjeO/6HhWsVOAnhg8x2UkBgUf4ZIU8juOZtmoilMVEysSpfMOgJiZEQh6REhCTeh7O
        7nLgohNLoW+oYL1GjC6JdajA4vcFiWjyYiHpMCJdMD9jd4EG+Gey9ANlQ5mUq8nU9H2NnO
        zArWIdYZt6yfi6WKqC4Rx+lA1ZzWAGI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-kM7Hat76MumCvQC04j4t3Q-1; Wed, 24 Feb 2021 13:56:57 -0500
X-MC-Unique: kM7Hat76MumCvQC04j4t3Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C6431868405;
        Wed, 24 Feb 2021 18:56:55 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 696C39CA0;
        Wed, 24 Feb 2021 18:56:52 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 5ACFA30736C73;
        Wed, 24 Feb 2021 19:56:51 +0100 (CET)
Subject: [PATCH RFC net-next 3/3] mm: make zone->free_area[order] access
 faster
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Mel Gorman <mgorman@techsingularity.net>, linux-mm@kvack.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, chuck.lever@oracle.com,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 24 Feb 2021 19:56:51 +0100
Message-ID: <161419301128.2718959.4838557038019199822.stgit@firesoul>
In-Reply-To: <161419296941.2718959.12575257358107256094.stgit@firesoul>
References: <161419296941.2718959.12575257358107256094.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid multiplication (imul) operations when accessing:
 zone->free_area[order].nr_free

This was really tricky to find. I was puzzled why perf reported that
rmqueue_bulk was using 44% of the time in an imul operation:

       │     del_page_from_free_list():
 44,54 │ e2:   imul   $0x58,%rax,%rax

This operation was generated (by compiler) because the struct free_area have
size 88 bytes or 0x58 hex. The compiler cannot find a shift operation to use
and instead choose to use a more expensive imul, to find the offset into the
array free_area[].

The patch align struct free_area to a cache-line, which cause the
compiler avoid the imul operation. The imul operation is very fast on
modern Intel CPUs. To help fast-path that decrement 'nr_free' move the
member 'nr_free' to be first element, which saves one 'add' operation.

Looking up instruction latency this exchange a 3-cycle imul with a
1-cycle shl, saving 2-cycles. It does trade some space to do this.

Used: gcc (GCC) 9.3.1 20200408 (Red Hat 9.3.1-2)

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/linux/mmzone.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index b593316bff3d..4d83201717e1 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -93,10 +93,12 @@ extern int page_group_by_mobility_disabled;
 #define get_pageblock_migratetype(page)					\
 	get_pfnblock_flags_mask(page, page_to_pfn(page), MIGRATETYPE_MASK)
 
+/* Aligned struct to make zone->free_area[order] access faster */
 struct free_area {
-	struct list_head	free_list[MIGRATE_TYPES];
 	unsigned long		nr_free;
-};
+	unsigned long		__pad_to_align_free_list;
+	struct list_head	free_list[MIGRATE_TYPES];
+}  ____cacheline_aligned_in_smp;
 
 static inline struct page *get_page_from_free_area(struct free_area *area,
 					    int migratetype)


