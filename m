Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 932651605F4
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 20:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgBPTbf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 16 Feb 2020 14:31:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56522 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727957AbgBPTbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 14:31:34 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-MPLiEuvGOq2eSxEDCcrY6g-1; Sun, 16 Feb 2020 14:31:29 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA9B78017DF;
        Sun, 16 Feb 2020 19:31:27 +0000 (UTC)
Received: from krava.redhat.com (ovpn-204-28.brq.redhat.com [10.40.204.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 739628574E;
        Sun, 16 Feb 2020 19:31:23 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/18] bpf: Return error value in bpf_dispatcher_update
Date:   Sun, 16 Feb 2020 20:30:00 +0100
Message-Id: <20200216193005.144157-14-jolsa@kernel.org>
In-Reply-To: <20200216193005.144157-1-jolsa@kernel.org>
References: <20200216193005.144157-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: MPLiEuvGOq2eSxEDCcrY6g-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't currently propagate error value from
bpf_dispatcher_update function. This will be
needed in following patch, that needs to update
kallsyms based on the success of dispatcher
update.

Suggested-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/dispatcher.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
index b3e5b214fed8..3a5871bbd6d0 100644
--- a/kernel/bpf/dispatcher.c
+++ b/kernel/bpf/dispatcher.c
@@ -102,7 +102,7 @@ static int bpf_dispatcher_prepare(struct bpf_dispatcher *d, void *image)
 	return arch_prepare_bpf_dispatcher(image, &ips[0], d->num_progs);
 }
 
-static void bpf_dispatcher_update(struct bpf_dispatcher *d, int prev_num_progs)
+static int bpf_dispatcher_update(struct bpf_dispatcher *d, int prev_num_progs)
 {
 	void *old, *new;
 	u32 noff;
@@ -118,15 +118,17 @@ static void bpf_dispatcher_update(struct bpf_dispatcher *d, int prev_num_progs)
 
 	new = d->num_progs ? d->image + noff : NULL;
 	if (new) {
-		if (bpf_dispatcher_prepare(d, new))
-			return;
+		err = bpf_dispatcher_prepare(d, new);
+		if (err)
+			return err;
 	}
 
 	err = bpf_arch_text_poke(d->func, BPF_MOD_JUMP, old, new);
 	if (err || !new)
-		return;
+		return err;
 
 	d->image_off = noff;
+	return 0;
 }
 
 void bpf_dispatcher_change_prog(struct bpf_dispatcher *d, struct bpf_prog *from,
-- 
2.24.1

