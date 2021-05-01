Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7427C3707F0
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 18:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhEAQpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 12:45:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31607 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231517AbhEAQpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 May 2021 12:45:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619887469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Rva2vPRMRJrYfDyC9PlLYOn6p2k58ez3co1vvesl5o=;
        b=aTmUfKpTjqNKVeKY81pRFt5BQPj364Ij9wnw3BeIiJK3IsTzIpe2lT55JlUpy2HIF8to3l
        yJpVhC7JaSFIx2Miv/sARDh234o1bB44tsCQoUmCIft2nWi/HMJXEUK9tw56nKdICNHQ7R
        Fi2dcXgVhunyhCmB2aIQ1f4L3+5EV2M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-zMIPUWwBNSqDA8zzPanBzg-1; Sat, 01 May 2021 12:44:27 -0400
X-MC-Unique: zMIPUWwBNSqDA8zzPanBzg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6AEE01898298;
        Sat,  1 May 2021 16:44:26 +0000 (UTC)
Received: from localhost.localdomain (ovpn-112-28.ams2.redhat.com [10.36.112.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 969D660BE5;
        Sat,  1 May 2021 16:44:25 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2 2/2] dcb: fix memory leak
Date:   Sat,  1 May 2021 18:39:23 +0200
Message-Id: <0d19dbb485632ecfbbc09e04e8151f7157e6960b.1619886883.git.aclaudi@redhat.com>
In-Reply-To: <cover.1619886883.git.aclaudi@redhat.com>
References: <cover.1619886883.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

main() dinamically allocates dcb, but when dcb_help() is called it
returns without freeing it.

Fix this using a goto, as it is already done in the same function.

Fixes: 67033d1c1c8a ("Add skeleton of a new tool, dcb")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 dcb/dcb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/dcb/dcb.c b/dcb/dcb.c
index 64a9ef02..696f00e4 100644
--- a/dcb/dcb.c
+++ b/dcb/dcb.c
@@ -571,7 +571,8 @@ int main(int argc, char **argv)
 			break;
 		case 'h':
 			dcb_help();
-			return 0;
+			ret = EXIT_SUCCESS;
+			goto dcb_free;
 		default:
 			fprintf(stderr, "Unknown option.\n");
 			dcb_help();
-- 
2.30.2

