Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB2745EC74
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 12:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238018AbhKZLYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 06:24:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27760 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230313AbhKZLWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 06:22:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637925580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VP2wsyySLKig79PhgG1vpE6dmyB/yBoLf1Bs2JAB+/A=;
        b=I9RXbj6lUspCiuXUgr8LMySvMBuPOFupaSjrkjHOebuH5DicQGnYIKUXo8mfQ25HoDK5Nd
        bF5TAIXZNs+7sBGv0sEvTwUloxE/IGAxlhg4g9SYPMW5YUkqm0M0ie1fBa5YWPSn+75rcP
        Lm+I4w7n/1YwQyHy/uZyc37UityEG48=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-470-x8yMdHCFMlyA4jV8o0C42A-1; Fri, 26 Nov 2021 06:19:37 -0500
X-MC-Unique: x8yMdHCFMlyA4jV8o0C42A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03D6F185302E;
        Fri, 26 Nov 2021 11:19:36 +0000 (UTC)
Received: from gerbillo.fritz.box (unknown [10.39.194.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A24B260BF4;
        Fri, 26 Nov 2021 11:19:34 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH net-next v2 1/2] bpf: do not WARN in bpf_warn_invalid_xdp_action()
Date:   Fri, 26 Nov 2021 12:19:10 +0100
Message-Id: <1817b31eac5f1b10abb2870ff09ed6af4814ef01.1637924200.git.pabeni@redhat.com>
In-Reply-To: <cover.1637924200.git.pabeni@redhat.com>
References: <cover.1637924200.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The WARN_ONCE() in bpf_warn_invalid_xdp_action() can be triggered by
any bugged program, and even attaching a correct program to a NIC
not supporting the given action.

The resulting splat, beyond polluting the logs, fouls automated tools:
e.g. a syzkaller reproducers using an XDP program returning an
unsupported action will never pass validation.

Replace the WARN_ONCE with a less intrusive pr_warn_once().

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/core/filter.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 8271624a19aa..5631acf3f10c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8185,9 +8185,9 @@ void bpf_warn_invalid_xdp_action(u32 act)
 {
 	const u32 act_max = XDP_REDIRECT;
 
-	WARN_ONCE(1, "%s XDP return value %u, expect packet loss!\n",
-		  act > act_max ? "Illegal" : "Driver unsupported",
-		  act);
+	pr_warn_once("%s XDP return value %u, expect packet loss!\n",
+		     act > act_max ? "Illegal" : "Driver unsupported",
+		     act);
 }
 EXPORT_SYMBOL_GPL(bpf_warn_invalid_xdp_action);
 
-- 
2.33.1

