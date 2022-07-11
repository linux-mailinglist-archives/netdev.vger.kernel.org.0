Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 548B556D822
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 10:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiGKIdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 04:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiGKIcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 04:32:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ADD3A1FCCA
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 01:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657528352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aKGFy03TW0CXqndqD4MQz+oIb7kOoMG9F98zOmwauWM=;
        b=hFzA1BwAxs+lojonVPs2JruKq0isMrc8+x3X/oDSYQ9k5rKzVmYDqRHMV6EQvvuwOVX5cw
        WxTcHr6QLndpCjjynBAm8EW7I3E5lUOxwoyAekqdwBzaW4+mlM4mseWh8at5joyl2cbV2s
        UoeV5GvMIDO/skSnpc+5XPWdMcsJoaM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-gSuQ_0p3PhyNcyK48n_gNw-1; Mon, 11 Jul 2022 04:32:23 -0400
X-MC-Unique: gSuQ_0p3PhyNcyK48n_gNw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F606802D1F;
        Mon, 11 Jul 2022 08:32:23 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 098DC1415118;
        Mon, 11 Jul 2022 08:32:22 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id DBED31C022D; Mon, 11 Jul 2022 10:32:21 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Artem Savkov <asavkov@redhat.com>
Subject: [RFC PATCH bpf-next 0/4] bpf_panic() helper
Date:   Mon, 11 Jul 2022 10:32:16 +0200
Message-Id: <20220711083220.2175036-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

eBPF is often used for kernel debugging, and one of the widely used and
powerful debugging techniques is post-mortem debugging with a full memory dump.
Triggering a panic at exactly the right moment allows the user to get such a
dump and thus a better view at the system's state. This patchset adds
bpf_panic() helper to do exactly that.

I realize that even though there are multiple guards present, a helper like
this is contrary to BPF being "safe", so this is sent as RFC to have a
discussion on whether adding destructive capabilities is deemed acceptable.

Artem Savkov (4):
  bpf: add a sysctl to enable destructive bpf helpers
  bpf: add BPF_F_DESTRUCTIVE flag for BPF_PROG_LOAD
  bpf: add bpf_panic() helper
  selftests/bpf: bpf_panic selftest

 include/linux/bpf.h                           |   8 +
 include/uapi/linux/bpf.h                      |  13 ++
 kernel/bpf/core.c                             |   1 +
 kernel/bpf/helpers.c                          |  13 ++
 kernel/bpf/syscall.c                          |  33 +++-
 kernel/bpf/verifier.c                         |   7 +
 kernel/trace/bpf_trace.c                      |   2 +
 tools/include/uapi/linux/bpf.h                |  13 ++
 .../selftests/bpf/prog_tests/bpf_panic.c      | 144 ++++++++++++++++++
 9 files changed, 233 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_panic.c

-- 
2.35.3

