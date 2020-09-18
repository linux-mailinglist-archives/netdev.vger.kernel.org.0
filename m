Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C7A26FC74
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 14:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgIRM1I convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 18 Sep 2020 08:27:08 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:39893 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726479AbgIRM1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 08:27:05 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-Vj-ZWnJTMQyEKZJkdrg9Jg-1; Fri, 18 Sep 2020 08:27:00 -0400
X-MC-Unique: Vj-ZWnJTMQyEKZJkdrg9Jg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1AE1F88EF21;
        Fri, 18 Sep 2020 12:26:59 +0000 (UTC)
Received: from krava.redhat.com (ovpn-114-24.ams2.redhat.com [10.36.114.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB25110016DA;
        Fri, 18 Sep 2020 12:26:55 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH bpf-next 1/2] bpf: Use --no-fail option if CONFIG_BPF is not enabled
Date:   Fri, 18 Sep 2020 14:26:53 +0200
Message-Id: <20200918122654.2625699-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently all the resolve_btfids 'users' are under CONFIG_BPF
code, so if we have CONFIG_BPF disabled, resolve_btfids will
fail, because there's no data to resolve.

In case CONFIG_BPF is disabled, using resolve_btfids --no-fail
option, that makes resolve_btfids leave quietly if there's no
data to resolve.

Fixes: c9a0f3b85e09 ("bpf: Resolve BTF IDs in vmlinux image")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 scripts/link-vmlinux.sh | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index e6e2d9e5ff48..3173b8cf08cb 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -342,8 +342,13 @@ vmlinux_link vmlinux "${kallsymso}" ${btf_vmlinux_bin_o}
 
 # fill in BTF IDs
 if [ -n "${CONFIG_DEBUG_INFO_BTF}" ]; then
-info BTFIDS vmlinux
-${RESOLVE_BTFIDS} vmlinux
+	info BTFIDS vmlinux
+	# Let's be more permissive if CONFIG_BPF is disabled
+	# and do not fail if there's no data to resolve.
+	if [ -z "${CONFIG_BPF}" ]; then
+	  no_fail=--no-fail
+	fi
+	${RESOLVE_BTFIDS} $no_fail vmlinux
 fi
 
 if [ -n "${CONFIG_BUILDTIME_TABLE_SORT}" ]; then
-- 
2.26.2

