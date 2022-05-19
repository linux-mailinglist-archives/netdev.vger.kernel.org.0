Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0965352DC89
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 20:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243744AbiESSOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 14:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243734AbiESSOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 14:14:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D04A7E8B9D
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 11:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652984048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=/ffvSfNKs9zH72fFL+E1h0NPdgas9cPjscSEjFymamw=;
        b=P683kWLtStvWqABTD2//Dun8/fv5LJEyY43VzYfFmvXj7wJbxfqfBI5cH8nwseJsCw5tso
        LEtEg0yJ7FMmTUoGIC1u0WgE/dBrptPzeSA2yw8znLkpfedtzK9rCHwKsqpenSaufHRMK5
        EBdAxhIo9VqwdDiLSDm7jT2SV9sOP1o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-D6mY1wKCOQeHLZFr6e_-4g-1; Thu, 19 May 2022 14:14:02 -0400
X-MC-Unique: D6mY1wKCOQeHLZFr6e_-4g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19F5E3817A65;
        Thu, 19 May 2022 18:14:02 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3422BC33AE5;
        Thu, 19 May 2022 18:13:58 +0000 (UTC)
Date:   Thu, 19 May 2022 20:13:55 +0200
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
Subject: [PATCH bpf v4 0/3] Fix kprobe_multi interface issues for 5.18
Message-ID: <cover.1652982525.git.esyr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

While [1] seems to require additional work[2] due to changes
in the interface (and it has already been re-targeted for bpf-next),
I would like to ask to consider the following three patches, that fix
possible out-of-bounds write, properly disable the interface
for 32-bit compat user space, and prepare the libbpf interface change,
for the 5.18 release.  Thank you.

[1] https://lore.kernel.org/lkml/cover.1652772731.git.esyr@redhat.com/
[2] https://lore.kernel.org/lkml/YoTXiAk1EpZ0rLKE@krava/i

v4:
 - Added additional size checks for INT_MAX, as suggested by Yonghong
   Song
 - Added the third patch for the user space kprobe_multi.addrs type
   change, split from the 4th bpf-next patch, as suggested by Yonghong
   Song and Andrii Nakryiko

v3: https://lore.kernel.org/lkml/cover.1652876187.git.esyr@redhat.com/
 - Split out patches for 5.18
 - Removed superfluous size assignments after overflow_mul_check,
   as suggested by Yonghong Song

v2: https://lore.kernel.org/lkml/20220516230441.GA22091@asgard.redhat.com/
 - Fixed the isses reported by CI

v1: https://lore.kernel.org/lkml/20220516182657.GA28596@asgard.redhat.com/

Eugene Syromiatnikov (3):
  bpf_trace: check size for overflow in bpf_kprobe_multi_link_attach
  bpf_trace: bail out from bpf_kprobe_multi_link_attach when in compat
  libbpf, selftests/bpf: pass array of u64 values in kprobe_multi.addrs

 kernel/trace/bpf_trace.c                                  | 15 +++++++++------
 tools/lib/bpf/bpf.h                                       |  2 +-
 tools/lib/bpf/libbpf.c                                    |  8 ++++----
 tools/lib/bpf/libbpf.h                                    |  2 +-
 tools/testing/selftests/bpf/prog_tests/bpf_cookie.c       |  2 +-
 .../testing/selftests/bpf/prog_tests/kprobe_multi_test.c  |  8 ++++----
 6 files changed, 20 insertions(+), 17 deletions(-)

-- 
2.1.4

