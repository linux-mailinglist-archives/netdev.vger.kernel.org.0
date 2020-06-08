Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DBE1F1AD8
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 16:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbgFHOUH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 8 Jun 2020 10:20:07 -0400
Received: from sender4-op-o14.zoho.com ([136.143.188.14]:17435 "EHLO
        sender4-op-o14.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728988AbgFHOUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 10:20:06 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1591625102; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=MVz/bBPQ4T32MPV4N3HrWnMleKmJYEQ8Tzbg2ssZ+vr+6jfARLUxb7XqVdb4F5pm9ZLMZ6v4awwXK8HSOyHI59nJjcPk/9kEnmX9B7u0u7FHA2z/oHTrsG5KFaVwdlCA3AYehmtX/ywbfEbL1xyQc6dU2ITEsxu2AguK6rg95GI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1591625102; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=NOtOgNoo0eF/OaePMkS1bUxpY2EVUUNxmJLOtmUNmok=; 
        b=Lk2Y+lEolRLWVp1ZSwDwZbda/CYH9zEsq9mC4MUEMnNEayDaP70PN4jsPKUjnVsPZmROsf9xf5J3LfltzgZ3zw2mQg9QzVenhcxUe5gGS2RRTKAK9FjTU3shFOTaxWGWsCzey2/5duXho5gXl+SjjjhjE88I5MjgyKCKoQ/N5wU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        spf=pass  smtp.mailfrom=dan@dlrobertson.com;
        dmarc=pass header.from=<dan@dlrobertson.com> header.from=<dan@dlrobertson.com>
Received: from gothmog.test (pool-108-48-181-150.washdc.fios.verizon.net [108.48.181.150]) by mx.zohomail.com
        with SMTPS id 1591625098981901.2410628727737; Mon, 8 Jun 2020 07:04:58 -0700 (PDT)
From:   Dan Robertson <dan@dlrobertson.com>
To:     netdev@vger.kernel.org
Cc:     Dan Robertson <dan@dlrobertson.com>
Message-ID: <20200608140404.1449-2-dan@dlrobertson.com>
Subject: [PATCH 1/1] devlink: fix build with musl libc
Date:   Mon,  8 Jun 2020 14:04:04 +0000
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200608140404.1449-1-dan@dlrobertson.com>
References: <20200608140404.1449-1-dan@dlrobertson.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-ZohoMailClient: External
Content-Type: text/plain; charset=utf8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The devlink tool makes use of the sigaction function and structure, but
does not include the signal.h header. This causes builds with musl libc
to fail. According to the Open Group specification this header should
be included for the sigaction function and structure definition.

Fixes: c4dfddccef4e ("fix JSON output of mon command")
Signed-off-by: Dan Robertson <dan@dlrobertson.com>
---
 devlink/devlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 507972c3..01533e2a 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -26,6 +26,7 @@
 #include <libmnl/libmnl.h>
 #include <netinet/ether.h>
 #include <sys/types.h>
+#include <signal.h>
 
 #include "SNAPSHOT.h"
 #include "list.h"

