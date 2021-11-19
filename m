Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A9B457342
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 17:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235718AbhKSQnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 11:43:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42993 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236569AbhKSQnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 11:43:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637340049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0OpO20ideHnQHb/2bPhDkZIRWm09Tp4EfZkfP/WCui8=;
        b=A8RKJPJDatRci3CFRe0HVoCLuxhEOg4q3x02dNzrAsW+2StqXYBSy1yAqttNDbFBp6lY+3
        G5EvJ6f/I4jCzkm/DIQ0jo8bNygFRg/vXM9Cz9YwbH6WqVEL9pA5YhMMpgDgcVqat8ZMkY
        cqoH0S0U9/Orr783+IBKjInAy+/gcDY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-vVMd5echOWu9oe1DROINQA-1; Fri, 19 Nov 2021 11:40:46 -0500
X-MC-Unique: vVMd5echOWu9oe1DROINQA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3094425C8;
        Fri, 19 Nov 2021 16:40:44 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B33F60BF1;
        Fri, 19 Nov 2021 16:40:43 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH net-next 1/2] bpf: do not WARN in bpf_warn_invalid_xdp_action()
Date:   Fri, 19 Nov 2021 17:39:15 +0100
Message-Id: <f391ed9d2c8fc80a292a289dac2a69cb33b96b49.1637339774.git.pabeni@redhat.com>
In-Reply-To: <cover.1637339774.git.pabeni@redhat.com>
References: <cover.1637339774.git.pabeni@redhat.com>
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
index e471c9b09670..3ba584bb23f8 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8183,9 +8183,9 @@ void bpf_warn_invalid_xdp_action(u32 act)
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

