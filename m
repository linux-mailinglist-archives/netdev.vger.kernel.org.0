Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA716DC687
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 14:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjDJMH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 08:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjDJMH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 08:07:58 -0400
Received: from mail-ej1-x662.google.com (mail-ej1-x662.google.com [IPv6:2a00:1450:4864:20::662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C176F59C1
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 05:07:55 -0700 (PDT)
Received: by mail-ej1-x662.google.com with SMTP id gb34so12175212ejc.12
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 05:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1681128474;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7v43Rq8QtIQVPlLmfhiMAiQGZl0bJiLYuxpdQdVU7Bw=;
        b=JJ3EQf9KhNA390dNwa7lrAMTXl3bXlDJd5BuVZeFF/lu1wJZeg/d717gHaZICPwW2l
         Gcl+oN+gkHN3qIOvAop0432cyEvtWglv02ExiF69RsKjdk2LBP+wkEKFGhPU1O4RzD15
         ELSRBk2Sl6qZlQK+tocc+CJw805Z/QfXpbkBE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681128474;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7v43Rq8QtIQVPlLmfhiMAiQGZl0bJiLYuxpdQdVU7Bw=;
        b=uU9Whucm6Im3ZrVeS/nNvGecEn5TVCReAdKxWc07ZPXPG7Xf2VlHerKXPsaEGD56Oq
         ZECnxQ9Xu8+BG9j+VPr9z679C3WHulDd8rkuXwAAWHhjXnqCy5Sj5+WcJx//DNEiCpAI
         ni4Q3lWjDI95ofT8IpGXR5MkPyRCsFmVp4eD+bCCTxkNiFUmZkq4yxx683Wz6adPtJXu
         A+66QKovhGbFVwvJRK8sfFV2wk+aacHx3Dwq703H8lQcn8HHPA0LNz9TA56o8GrdFV3B
         mJLu+M1fBK5/Fgh4azwR3472a7fITZuVniLRmCThs/75bH0El0tnzC/g1EPx50FoHEvw
         m3AA==
X-Gm-Message-State: AAQBX9fXp3M+kfeFAV5xRNqhCbzXt7jrXwALdoomXS0aK/X6D2Lh4Nax
        yipX6xkeabKbC7gJHABBI5MOiBE2qw+adsQWzdmaha9q1oqA
X-Google-Smtp-Source: AKy350aU8co7KQVqsL+B7ABmpTXsAasYQbNi1uG8xMgjlcVqfUW+N7iY/c+WT8w3uzURTvL+O2vVxvekCSMr
X-Received: by 2002:a17:906:2605:b0:8aa:a9fe:a3fc with SMTP id h5-20020a170906260500b008aaa9fea3fcmr7848556ejc.8.1681128474126;
        Mon, 10 Apr 2023 05:07:54 -0700 (PDT)
Received: from fedora.dectris.local (dect-ch-bad-pfw.cyberlink.ch. [62.12.151.50])
        by smtp-relay.gmail.com with ESMTPS id nb39-20020a1709071ca700b008b1fc5abd08sm2089769ejc.56.2023.04.10.05.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 05:07:54 -0700 (PDT)
X-Relaying-Domain: dectris.com
From:   Kal Conley <kal.conley@dectris.com>
To:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Kal Conley <kal.conley@dectris.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next v5 0/4] xsk: Support UMEM chunk_size > PAGE_SIZE
Date:   Mon, 10 Apr 2023 14:06:25 +0200
Message-Id: <20230410120629.642955-1-kal.conley@dectris.com>
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

Note, v5 fixes a major bug in previous versions of this patchset.
In particular, dma_map_page_attrs used to be called once for each
order-0 page in a hugepage with the assumption that returned I/O
addresses are contiguous within a hugepage. This assumption is incorrect
when an IOMMU is enabled. To fix this, v5 does DMA page accounting
accounting at hugepage granularity.

Changes since v4:
  * Use hugepages in DMA map (fixes zero-copy mode with IOMMU).
  * Use pool->dma_pages to check for DMA. This change is needed to avoid
    performance regressions).
  * Update commit message and benchmark table.

Changes since v3:
  * Fix checkpatch.pl whitespace error.

Changes since v2:
  * Related fixes/improvements included with v2 have been removed. These
    changes have all been resubmitted as standalone patchsets.
  * Minimize uses of #ifdef CONFIG_HUGETLB_PAGE.
  * Improve AF_XDP documentation.
  * Update benchmark table in commit message.

Changes since v1:
  * Add many fixes/improvements to the XSK selftests.
  * Add check for unaligned descriptors that overrun UMEM.
  * Fix compile errors when CONFIG_HUGETLB_PAGE is not set.
  * Fix incorrect use of _Static_assert.
  * Update AF_XDP documentation.
  * Rename unaligned 9K frame size test.
  * Make xp_check_dma_contiguity less conservative.
  * Add more information to benchmark table.

Thanks to Magnus Karlsson for all his support!

Happy Easter!

Kal Conley (4):
  xsk: Use pool->dma_pages to check for DMA
  xsk: Support UMEM chunk_size > PAGE_SIZE
  selftests: xsk: Use hugepages when umem->frame_size > PAGE_SIZE
  selftests: xsk: Add tests for 8K and 9K frame sizes

 Documentation/networking/af_xdp.rst      | 36 ++++++++++------
 include/net/xdp_sock.h                   |  2 +
 include/net/xdp_sock_drv.h               | 12 ++++++
 include/net/xsk_buff_pool.h              | 12 +++---
 net/xdp/xdp_umem.c                       | 55 +++++++++++++++++++-----
 net/xdp/xsk_buff_pool.c                  | 43 ++++++++++--------
 tools/testing/selftests/bpf/xskxceiver.c | 27 +++++++++++-
 tools/testing/selftests/bpf/xskxceiver.h |  2 +
 8 files changed, 142 insertions(+), 47 deletions(-)

-- 
2.39.2

