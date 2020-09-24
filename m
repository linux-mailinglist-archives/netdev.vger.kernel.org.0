Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4091E277950
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 21:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbgIXT2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 15:28:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46171 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728758AbgIXT2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 15:28:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600975686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6ZxhQbhk8RyXZjVdUCbG5aOqk3ATuORnBLze3jZRmXw=;
        b=SWOTugy7rQVtoMprMfXTNY3pFj5dk7zdokMMZLgpP+52C1vAgKuTc53qgPxwB3Xv2VMAnJ
        PqYyNH/NMko5L66n6EQM3tmazh2A2TF5Ff2v02TinPj5dJvecc3cZqWvbQZ5qR/zJAtQ9H
        Vt5WblgwHoDvotpBvkdGPJDuB9AygxU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-N7HV4rHuM5eb9TqBR7xQIQ-1; Thu, 24 Sep 2020 15:28:02 -0400
X-MC-Unique: N7HV4rHuM5eb9TqBR7xQIQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9F091084C9E;
        Thu, 24 Sep 2020 19:28:01 +0000 (UTC)
Received: from ceranb.redhat.com (unknown [10.40.195.153])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B50860BF3;
        Thu, 24 Sep 2020 19:28:00 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 2/2] netlink: fix memory leak
Date:   Thu, 24 Sep 2020 21:27:58 +0200
Message-Id: <20200924192758.577595-2-ivecera@redhat.com>
In-Reply-To: <20200924192758.577595-1-ivecera@redhat.com>
References: <20200924192758.577595-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Potentially allocated memory allocated for mask is not freed when
the allocation for value fails.

Fixes: 81a30f416ec7 ("netlink: add bitset command line parser handlers")

Cc: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 netlink/parser.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/netlink/parser.c b/netlink/parser.c
index c5a368a65a7a..3b25f5d5a88e 100644
--- a/netlink/parser.c
+++ b/netlink/parser.c
@@ -630,8 +630,10 @@ static int parse_numeric_bitset(struct nl_context *nlctx, uint16_t type,
 	}
 
 	value = calloc(nwords, sizeof(uint32_t));
-	if (!value)
+	if (!value) {
+		free(mask);
 		return -ENOMEM;
+	}
 	ret = __parse_num_string(arg, len1, value, force_hex1);
 	if (ret < 0) {
 		parser_err_invalid_value(nlctx, arg);
-- 
2.26.2

