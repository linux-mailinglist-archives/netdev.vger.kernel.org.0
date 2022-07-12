Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 527E2571D86
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 16:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbiGLO70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 10:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233809AbiGLO7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 10:59:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C428515FDE
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 07:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657637948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rNMMrtYTZ3r/ojhGFO/7q3Z/iBX3TiYjKv+1Pm5Rw30=;
        b=iFmYXe5r++vZduRtpfA/6nm501f9yFVRaGSHHbbvdHA1ppIqWvFFrf/HRdKNiExha/9Wsd
        GjcP3qvvg8ORb/M9B24Si3qtSDZ4EE6YbapFU9CYPKGTIXPFr2ReyPLZq8eh3xw81PaupJ
        U4qgj/3ge1Nq2Vgl8aUdhStHDPSIPnk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205-dsndXIpmPdCnppEJ8jRctg-1; Tue, 12 Jul 2022 10:59:05 -0400
X-MC-Unique: dsndXIpmPdCnppEJ8jRctg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6940685A585;
        Tue, 12 Jul 2022 14:59:04 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.195.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 65A852166B26;
        Tue, 12 Jul 2022 14:59:01 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v6 01/23] selftests/bpf: fix config for CLS_BPF
Date:   Tue, 12 Jul 2022 16:58:28 +0200
Message-Id: <20220712145850.599666-2-benjamin.tissoires@redhat.com>
In-Reply-To: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
References: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When running test_progs under the VM (with vmtest.sh), some tests are
failing because the classifier bpf is not available.

Given that the script doesn't load that particular module, make it
part of vmlinux.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

new in v6
---
 tools/testing/selftests/bpf/config | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index c05904d631ec..c69c119f4bb7 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -1,6 +1,6 @@
 CONFIG_BPF=y
 CONFIG_BPF_SYSCALL=y
-CONFIG_NET_CLS_BPF=m
+CONFIG_NET_CLS_BPF=y
 CONFIG_BPF_EVENTS=y
 CONFIG_TEST_BPF=m
 CONFIG_CGROUP_BPF=y
-- 
2.36.1

