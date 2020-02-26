Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAAE216FF97
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 14:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgBZNE5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 Feb 2020 08:04:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24948 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727307AbgBZNE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 08:04:56 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-haPgIOFzO9ugDYp7qQJWDA-1; Wed, 26 Feb 2020 08:04:52 -0500
X-MC-Unique: haPgIOFzO9ugDYp7qQJWDA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C4E8800D5F;
        Wed, 26 Feb 2020 13:04:50 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.43.17.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0CB8819C7F;
        Wed, 26 Feb 2020 13:04:44 +0000 (UTC)
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
Date:   Wed, 26 Feb 2020 14:03:40 +0100
Message-Id: <20200226130345.209469-14-jolsa@kernel.org>
In-Reply-To: <20200226130345.209469-1-jolsa@kernel.org>
References: <20200226130345.209469-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

