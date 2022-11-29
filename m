Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A344763BA41
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 08:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiK2HJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 02:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiK2HJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 02:09:10 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0554E3E094;
        Mon, 28 Nov 2022 23:09:08 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1669705747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9LKeLmtho8x6GEA99mRxMgZ3Mep7J9m2V7qZSZY6huc=;
        b=NZ92l9jvS93wIq0r68NUC8rta6b+Ck34ooxEcK6wJtZ6t0+vfKzsuid65gOd60RZ37rjYi
        cZGiJhGXtJyO9F3gun9N0s3ht7ep5F41zooc8PNWTZKprFJPkzJsbMmfl3rQRF4jX5hJz5
        27CNLMj/x4LMHYaYJDsVbC5QuBRvY14=
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     bpf@vger.kernel.org
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        netdev@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH bpf-next 0/7] selftests/bpf: Remove unnecessary mount/umount dance
Date:   Mon, 28 Nov 2022 23:08:53 -0800
Message-Id: <20221129070900.3142427-1-martin.lau@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

Some of the tests do mount/umount dance when switching netns.
It is error-prone like https://lore.kernel.org/bpf/20221123200829.2226254-1-sdf@google.com/

Another issue is, there are many left over after running some of the tests:
#> mount | egrep sysfs | wc -l
19

Instead of further debugging this dance,  this set is to avoid the needs to
do this remounting altogether.  It will then allow those tests to be run
in parallel again.

Martin KaFai Lau (7):
  selftests/bpf: Use if_nametoindex instead of reading the
    /sys/net/class/*/ifindex
  selftests/bpf: Avoid pinning bpf prog in the tc_redirect_dtime test
  selftests/bpf: Avoid pinning bpf prog in the tc_redirect_peer_l3 test
  selftests/bpf: Avoid pinning bpf prog in the netns_load_bpf() callers
  selftests/bpf: Remove the "/sys" mount and umount dance in
    {open,close}_netns
  selftests/bpf: Remove serial from tests using {open,close}_netns
  selftests/bpf: Avoid pinning prog when attaching to tc ingress in
    btf_skc_cls_ingress

 tools/testing/selftests/bpf/network_helpers.c |  51 +--
 .../bpf/prog_tests/btf_skc_cls_ingress.c      |  25 +-
 .../selftests/bpf/prog_tests/empty_skb.c      |   2 +-
 .../selftests/bpf/prog_tests/tc_redirect.c    | 314 +++++++++---------
 .../selftests/bpf/prog_tests/test_tunnel.c    |   2 +-
 .../bpf/prog_tests/xdp_do_redirect.c          |   2 +-
 .../selftests/bpf/prog_tests/xdp_synproxy.c   |   2 +-
 7 files changed, 178 insertions(+), 220 deletions(-)

-- 
2.30.2

