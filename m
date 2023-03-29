Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0976CF1BA
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 20:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbjC2SHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 14:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbjC2SHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 14:07:41 -0400
Received: from mail-ed1-x564.google.com (mail-ed1-x564.google.com [IPv6:2a00:1450:4864:20::564])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA3C420A
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:07:39 -0700 (PDT)
Received: by mail-ed1-x564.google.com with SMTP id ew6so66733051edb.7
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1680113258;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eW8cixxE4mCH2k16m1Z6ulTnFQEPlmr5i1F469P39mc=;
        b=ZDpNlD1h58yVtYr/IQiNAT6g38PhKD5dcW0/mO9gAymHD4WqC6eMQFqMujX4oFEH5u
         wwo5lMWHIs8CrWmkzq/7GlXqjl4SWHUJKokl2hFBXV53/zsloMY4DjJ7lY94wlKCTf4L
         yOqrWQjQoE2aIhITmMQevmCm3zJPaQYs85IEw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680113258;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eW8cixxE4mCH2k16m1Z6ulTnFQEPlmr5i1F469P39mc=;
        b=pEj69wXyNqFV3l6wC7ew3zlggS9x5sYGvvZHA6/Km4TbskHLQtJu+jz3now6Epz4Z8
         Pmtq+vI3V8/g+k7PJQEqZ1OztFaTlgM30zkYBt+DqT9m3YamAy2hQ3unKrZkTxO0KIRE
         U77sYBxav9+tlwRxneSOvU/E6G41yu1eCVrsd1CAA8EgC9SCrQsszeuWvHL2nHmpl5UM
         yMzd1I5wt9vUxyHUtdnfTeFZi4fwZrQPi7RUpTt02cMH9lTyWxDB31Qy2SSfYAjfIumz
         oBu6tDSmhDkcOCoary1SN7henk3p+9FZ6KnXTAY3noCelqLjvZBL0VFihYjA/HRRSDED
         UF4w==
X-Gm-Message-State: AAQBX9fscPybrRrfVlBNW0fpz4fgvV4lFW/HcResbgNejdcyF6CsnTQk
        yVUw26PfnTKyz6BfkHCcWfZFcLdEjBWSDJlSpbYhqhwAq8ua
X-Google-Smtp-Source: AKy350bpuNnR9jzhvkniiSlXw5ZyNHh4pc81Zx+/fobNXo8UNzgBD0QNe7u7QOk/eRjiTe3d6sDNFoy9lyAy
X-Received: by 2002:a17:907:7ba1:b0:8b1:820a:7b60 with SMTP id ne33-20020a1709077ba100b008b1820a7b60mr26288171ejc.6.1680113258051;
        Wed, 29 Mar 2023 11:07:38 -0700 (PDT)
Received: from fedora.dectris.local (dect-ch-bad-pfw.cyberlink.ch. [62.12.151.50])
        by smtp-relay.gmail.com with ESMTPS id m10-20020a1709066d0a00b00920438f59b3sm12072998ejr.154.2023.03.29.11.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 11:07:38 -0700 (PDT)
X-Relaying-Domain: dectris.com
From:   Kal Conley <kal.conley@dectris.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Kal Conley <kal.conley@dectris.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 00/10] xsk: Support UMEM chunk_size > PAGE_SIZE
Date:   Wed, 29 Mar 2023 20:04:52 +0200
Message-Id: <20230329180502.1884307-1-kal.conley@dectris.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main purpose of this patchset is to add AF_XDP support for UMEM
chunk sizes > PAGE_SIZE. This is enabled for UMEMs backed by HugeTLB
pages.

The patchset starts off with many fixes and improvements to the XSK
selftests. Next, an existing issue is fixed whereby unaligned
descriptors may overrun the end of the UMEM in certain cases. Finally,
AF_XDP support for UMEM chunk_size > PAGE_SIZE is added.

v2 contains major improvements over v1. It should be both a joy to read
and review. :-)

Changes since v1:
  * Add many fixes/improvements to the XSK selftests.
  * Add check for unaligned descriptors that overrun UMEM.
  * Fix compile errors when CONFIG_HUGETLB_PAGE is not set.
  * Fix incorrect use of _Static_assert.
  * Update AF_XDP documentation.
  * Rename unaligned 9K frame size test.
  * Make xp_check_dma_contiguity less conservative.
  * Add more information to benchmark table.

Thanks to Magnus Karlsson for his initial feedback!

Kal Conley (10):
  selftests: xsk: Add xskxceiver.h dependency to Makefile
  selftests: xsk: Use correct UMEM size in testapp_invalid_desc
  selftests: xsk: Add test case for packets at end of UMEM
  selftests: xsk: Deflakify STATS_RX_DROPPED test
  selftests: xsk: Disable IPv6 on VETH1
  xsk: Add check for unaligned descriptors that overrun UMEM
  selftests: xsk: Add test UNALIGNED_INV_DESC_4K1_FRAME_SIZE
  xsk: Support UMEM chunk_size > PAGE_SIZE
  selftests: xsk: Use hugepages when umem->frame_size > PAGE_SIZE
  selftests: xsk: Add tests for 8K and 9K frame sizes

 Documentation/networking/af_xdp.rst      | 19 ++++--
 include/net/xdp_sock.h                   |  3 +
 include/net/xdp_sock_drv.h               | 12 ++++
 include/net/xsk_buff_pool.h              | 24 +++++---
 net/xdp/xdp_umem.c                       | 50 ++++++++++++---
 net/xdp/xsk_buff_pool.c                  | 34 +++++++----
 net/xdp/xsk_queue.h                      |  1 +
 tools/testing/selftests/bpf/Makefile     |  2 +-
 tools/testing/selftests/bpf/test_xsk.sh  |  1 +
 tools/testing/selftests/bpf/xskxceiver.c | 77 +++++++++++++++++++++---
 tools/testing/selftests/bpf/xskxceiver.h |  4 +-
 11 files changed, 183 insertions(+), 44 deletions(-)

-- 
2.39.2

