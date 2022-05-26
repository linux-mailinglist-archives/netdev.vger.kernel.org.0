Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9762535586
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 23:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348697AbiEZVf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 17:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348775AbiEZVfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 17:35:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10DB8A075;
        Thu, 26 May 2022 14:35:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E9C3B82208;
        Thu, 26 May 2022 21:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD01C385A9;
        Thu, 26 May 2022 21:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653600921;
        bh=qwyv+nJxlBVdDqdbd2VTKT9hv2wBJCSqK1tCHBMY/+g=;
        h=From:To:Cc:Subject:Date:From;
        b=IYn0VSwgwkkmsGR108hPDZOx0qg28bpENvgoWj0w25ef0I47jjC6fS1xhiyID0RG3
         wIhIcEj2tbRXU0CYAn484+QHu9PoG99+AjVDX2pS5J0lHCguduI7GzSlAANSRm+Q0r
         img6Ew3vUQGuH6OZjs0jTPnaHLsNO2C+v104t4VtNee9lhf3ugX+wuFH+ATi/u2RBL
         FQOE3uDsZhsDwaKrIUDOZYbB6ZmEG0goo+Xrh+UkZLGzaPLOrWrhHAQmUVSDrrxPXM
         QNy08q14RZFWVNYi5kBY++ahJnCQVfPZfhBwubcjnARAxC8E2GnNPJhaODI5IkyX1L
         rtjKe2wPJRoXA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, yhs@fb.com
Subject: [PATCH v4 bpf-next 00/14] net: netfilter: add kfunc helper to update ct timeout
Date:   Thu, 26 May 2022 23:34:48 +0200
Message-Id: <cover.1653600577.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes since v3:
- split bpf_xdp_ct_add in bpf_xdp_ct_alloc/bpf_skb_ct_alloc and
  bpf_ct_insert_entry
- add verifier code to properly populate/configure ct entry
- improve selftests

Changes since v2:
- add bpf_xdp_ct_add and bpf_ct_refresh_timeout kfunc helpers
- remove conntrack dependency from selftests
- add support for forcing kfunc args to be referenced and related selftests

Changes since v1:
- add bpf_ct_refresh_timeout kfunc selftest

Kumar Kartikeya Dwivedi (11):
  bpf: Add support for forcing kfunc args to be referenced
  bpf: Print multiple type flags in verifier log
  bpf: Support rdonly PTR_TO_BTF_ID for pointer to const return value
  bpf: Support storing rdonly PTR_TO_BTF_ID in BPF maps
  bpf: Support passing rdonly PTR_TO_BTF_ID to kfunc
  bpf: Whitelist some fields in nf_conn for BPF_WRITE
  bpf: Define acquire-release pairs for kfuncs
  selftests/bpf: Add verifier tests for forced kfunc ref args
  selftests/bpf: Add C tests for rdonly PTR_TO_BTF_ID
  selftests/bpf: Add verifier tests for rdonly PTR_TO_BTF_ID
  selftests/bpf: Add negative tests for bpf_nf

Lorenzo Bianconi (3):
  net: netfilter: add kfunc helper to update ct timeout
  net: netfilter: add kfunc helpers to alloc and insert a new ct entry
  selftests/bpf: add selftest for bpf_xdp_ct_add and
    bpf_ct_refresh_timeout kfunc

 include/linux/bpf.h                           |  17 +-
 include/linux/bpf_verifier.h                  |   1 +
 include/linux/btf.h                           |  40 ++
 include/linux/filter.h                        |   3 +
 include/net/netfilter/nf_conntrack.h          |   1 +
 include/net/netfilter/nf_conntrack_bpf.h      |   5 +
 include/uapi/linux/bpf.h                      |   2 +-
 kernel/bpf/btf.c                              | 206 ++++++++--
 kernel/bpf/helpers.c                          |   4 +-
 kernel/bpf/verifier.c                         | 110 ++++--
 net/bpf/test_run.c                            |  20 +-
 net/core/filter.c                             |  28 ++
 net/netfilter/nf_conntrack_bpf.c              | 367 ++++++++++++++++--
 net/netfilter/nf_conntrack_core.c             |  23 +-
 tools/include/uapi/linux/bpf.h                |   2 +-
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  58 ++-
 .../selftests/bpf/prog_tests/map_kptr.c       |   9 +-
 tools/testing/selftests/bpf/progs/map_kptr.c  |  31 +-
 .../selftests/bpf/progs/map_kptr_fail.c       | 114 ++++++
 .../testing/selftests/bpf/progs/test_bpf_nf.c |  87 ++++-
 .../selftests/bpf/progs/test_bpf_nf_fail.c    |  73 ++++
 tools/testing/selftests/bpf/test_verifier.c   |  17 +-
 tools/testing/selftests/bpf/verifier/calls.c  |  53 +++
 .../testing/selftests/bpf/verifier/map_kptr.c | 156 ++++++++
 24 files changed, 1276 insertions(+), 151 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_nf_fail.c

-- 
2.35.3

