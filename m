Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8762C156532
	for <lists+netdev@lfdr.de>; Sat,  8 Feb 2020 16:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbgBHPnD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 8 Feb 2020 10:43:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60598 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727557AbgBHPnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Feb 2020 10:43:02 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-45redfCwPh-WpmZuHuWcIg-1; Sat, 08 Feb 2020 10:42:57 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D037C8014D1;
        Sat,  8 Feb 2020 15:42:55 +0000 (UTC)
Received: from krava.redhat.com (ovpn-204-79.brq.redhat.com [10.40.204.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD4225C28F;
        Sat,  8 Feb 2020 15:42:52 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: [PATCH 10/14] bpf: Re-initialize lnode in bpf_ksym_del
Date:   Sat,  8 Feb 2020 16:42:05 +0100
Message-Id: <20200208154209.1797988-11-jolsa@kernel.org>
In-Reply-To: <20200208154209.1797988-1-jolsa@kernel.org>
References: <20200208154209.1797988-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 45redfCwPh-WpmZuHuWcIg-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When bpf_prog is removed from kallsyms it's on the way
out to be removed, so we don't care about lnode state.

However the bpf_ksym_del will be used also by bpf_trampoline
and bpf_dispatcher objects, which stay allocated even when
they are not in kallsyms list, hence the lnode re-init.

The list_del_rcu commentary states that we need to call
synchronize_rcu, before we can change/re-init the list_head
pointers.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 73242fd07893..66b17bea286e 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -676,6 +676,13 @@ void bpf_ksym_del(struct bpf_ksym *ksym)
 	spin_lock_bh(&bpf_lock);
 	__bpf_ksym_del(ksym);
 	spin_unlock_bh(&bpf_lock);
+
+	/*
+	 * As explained in list_del_rcu, We must call synchronize_rcu
+	 * before changing list_head pointers.
+	 */
+	synchronize_rcu();
+	INIT_LIST_HEAD_RCU(&ksym->lnode);
 }
 
 static bool bpf_prog_kallsyms_candidate(const struct bpf_prog *fp)
-- 
2.24.1

