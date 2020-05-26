Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABAE21E2666
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 18:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731342AbgEZQEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 12:04:52 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:60538 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728016AbgEZQEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 12:04:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590509091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=80ClBT2/9ekT7ekQL96ySM/68NWsvqejpgFFfCG/jmU=;
        b=NN4dykSChBJh9681SVpFAJ/xSncU8BH7iPOzGZ85hm98ehep+MJw4DHy5If+rkLxiIqHaP
        c0DvKZaaQ547R9ZzrUH12z3BZdXuc0QrocEfNVLYt7+IZ6qB9xhjp321Q+KXvQcPOb/nhV
        34QA/Mh+u0ucNoZ+4r8Er+wLeeoQXyU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-RSw94rYwPvunZR970dyJLg-1; Tue, 26 May 2020 12:04:47 -0400
X-MC-Unique: RSw94rYwPvunZR970dyJLg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 962D01009455;
        Tue, 26 May 2020 16:04:46 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.40.192.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E3545C1BB;
        Tue, 26 May 2020 16:04:38 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, jhs@mojatatu.com
Subject: [iproute2 PATCH 2/2] bpf: Fixes a snprintf truncation warning
Date:   Tue, 26 May 2020 18:04:11 +0200
Message-Id: <3cfc5d226243fbc186c0b937c6150d7f00b84e6e.1590508215.git.aclaudi@redhat.com>
In-Reply-To: <cover.1590508215.git.aclaudi@redhat.com>
References: <cover.1590508215.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gcc v9.3.1 reports:

bpf.c: In function ‘bpf_get_work_dir’:
bpf.c:784:49: warning: ‘snprintf’ output may be truncated before the last format character [-Wformat-truncation=]
  784 |  snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir), "%s/", mnt);
      |                                                 ^
bpf.c:784:2: note: ‘snprintf’ output between 2 and 4097 bytes into a destination of size 4096
  784 |  snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir), "%s/", mnt);
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fix this simply checking snprintf return code and properly handling the error.

Fixes: e42256699cac ("bpf: make tc's bpf loader generic and move into lib")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 lib/bpf.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/bpf.c b/lib/bpf.c
index 23cb0d96a85ba..c7d45077c14e5 100644
--- a/lib/bpf.c
+++ b/lib/bpf.c
@@ -781,7 +781,11 @@ static const char *bpf_get_work_dir(enum bpf_prog_type type)
 		}
 	}
 
-	snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir), "%s/", mnt);
+	ret = snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir), "%s/", mnt);
+	if (ret < 0 || ret >= sizeof(bpf_wrk_dir)) {
+		mnt = NULL;
+		goto out;
+	}
 
 	ret = bpf_gen_hierarchy(bpf_wrk_dir);
 	if (ret) {
-- 
2.25.4

