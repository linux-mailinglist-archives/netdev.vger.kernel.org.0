Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD312D7EE8
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 19:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390682AbgLKSzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 13:55:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38204 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389455AbgLKSyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 13:54:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607712802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gYvPlMxgSa/S/NGYqFw1rXj3z3erU+lWixL46UYSdbA=;
        b=eMU5HrE5wUkxPB6hgdHn1lVU4WW8O8kbIyqAbGkmxUu5l27bN6BC1zOlrzNseO3ZDmlBnf
        XgzS1RB4eqtaKyPfEdGPCyS1Q0rOOeAHHfRXipdziMPQn30i7biz0mYvY8zbQRXge7bNv0
        OsFHBB0aZnOle2Kgk4YHXXMD+2XBDa4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291--c0zgdZ1OOCdzHHM7NUtMA-1; Fri, 11 Dec 2020 13:53:20 -0500
X-MC-Unique: -c0zgdZ1OOCdzHHM7NUtMA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 747B8107ACF7;
        Fri, 11 Dec 2020 18:53:19 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-114-11.ams2.redhat.com [10.36.114.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E26B60BE5;
        Fri, 11 Dec 2020 18:53:18 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2 2/2] tc: pedit: fix memory leak in print_pedit
Date:   Fri, 11 Dec 2020 19:53:03 +0100
Message-Id: <3045373e80b840cc2c658696af1c6b7fb367c96e.1607712061.git.aclaudi@redhat.com>
In-Reply-To: <cover.1607712061.git.aclaudi@redhat.com>
References: <cover.1607712061.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

keys_ex is dinamically allocated with calloc on line 770, but
is not freed in case of error at line 823.

Fixes: 081d6c310d3a ("tc: pedit: Support JSON dumping")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 tc/m_pedit.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tc/m_pedit.c b/tc/m_pedit.c
index 51dcf109..aa874408 100644
--- a/tc/m_pedit.c
+++ b/tc/m_pedit.c
@@ -819,8 +819,10 @@ static int print_pedit(struct action_util *au, FILE *f, struct rtattr *arg)
 			print_uint(PRINT_FP, NULL, "\n\t key #%d  at ", i);
 
 			err = print_pedit_location(f, htype, key->off);
-			if (err)
+			if (err) {
+				free(keys_ex);
 				return err;
+			}
 
 			/* In FP, report the "set" command as "val" to keep
 			 * backward compatibility. Report the true name in JSON.
-- 
2.29.2

