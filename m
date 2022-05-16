Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74209528CDF
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 20:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344760AbiEPS1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 14:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344755AbiEPS1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 14:27:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 52A9B3DA7E
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 11:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652725636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=id00oVYTmyhqPqdSLuA7jfzPXEfe8AjRZdJymH4RAy0=;
        b=XGKI4KMCU82ymnvnqyw2x4IfJLKH2WsmkGtdQQTmYiW8LpqhX2XO9pZ4DMIhzR1UB6bPOt
        SBRtauWabedmbHyBTjPtnU3c8sjfJdRcq3cyKxUqltK1y+D2JSzrhzHd6VqR+lnR/1LSjm
        bb+FWqbYO107w0a6zqspTDHVBm8if2A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-29-hkLDBe64NLOiL3uXQ0xXTA-1; Mon, 16 May 2022 14:27:12 -0400
X-MC-Unique: hkLDBe64NLOiL3uXQ0xXTA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B4561DC245E;
        Mon, 16 May 2022 18:27:04 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 02FC4155F652;
        Mon, 16 May 2022 18:26:59 +0000 (UTC)
Date:   Mon, 16 May 2022 20:26:57 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Jiri Olsa <jolsa@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: [PATCH bpf 0/4] Fix 32-bit arch and compat support for the
 kprobe_multi attach type
Message-ID: <20220516182657.GA28596@asgard.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As suggested in [1], the kprobe_multi interface is to be fixed for 32-bit
architectures and compat, rather then disabled.  As it turned out,
there are a couple of additional problems that are to be addressed:
 - the absence of size overflow checks, leading to possible
   out-of-bounds writes (addressed by the first patch);
 - the assumption that long has the same size as u64, which would make
   cookies arrays size calculation incorrect on 32-bit architectures
   (addressed by the second patch);
 - the addrs array passing API, that is incompatible with compat and has
   to be changed (addressed in the fourth patch): those are kernel
   addresses and not user ones (as was incorrectly stated in [2]);
   this change is only semantical for 64-bit user/kernelspace,
   so it shouldn't impact ABI there, at least.

[1] https://lore.kernel.org/lkml/CAADnVQ+2gwhcMht4PuDnDOFKY68Wsq8QFz4Y69NBX_TLaSexQQ@mail.gmail.com/
[2] https://lore.kernel.org/lkml/20220510184155.GA8295@asgard.redhat.com/

Eugene Syromiatnikov (4):
  bpf_trace: check size for overflow in bpf_kprobe_multi_link_attach
  bpf_trace: support 32-bit kernels in bpf_kprobe_multi_link_attach
  bpf_trace: handle compat in kprobe_multi_resolve_syms
  bpf_trace: pass array of u64 values in kprobe_multi.addrs

 kernel/trace/bpf_trace.c                           | 63 ++++++++++++++++------
 tools/lib/bpf/bpf.h                                |  2 +-
 tools/lib/bpf/libbpf.c                             |  8 +--
 tools/lib/bpf/libbpf.h                             |  2 +-
 .../testing/selftests/bpf/prog_tests/bpf_cookie.c  |  2 +-
 .../selftests/bpf/prog_tests/kprobe_multi_test.c   |  2 +-
 6 files changed, 54 insertions(+), 25 deletions(-)

-- 
2.1.4

