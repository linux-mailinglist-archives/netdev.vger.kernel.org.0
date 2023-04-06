Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6378C6D97D7
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 15:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237504AbjDFNTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 09:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236889AbjDFNT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 09:19:29 -0400
Received: from mail-ej1-x662.google.com (mail-ej1-x662.google.com [IPv6:2a00:1450:4864:20::662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01994D3
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 06:19:28 -0700 (PDT)
Received: by mail-ej1-x662.google.com with SMTP id g18so1328772ejx.7
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 06:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1680787166;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=g07JS6HwJMTcD1ZyJSmNJv7D8T89QHV+vCAkjMWduNo=;
        b=TSgBWyRgCmfdxZtJRM04NNEIUsiONIv5C3viFD6azAgUWJv9+Ycy9mIuAzMZW2Dlan
         vX5X3alAZ5kaS48qD9/06VJSRJMHUVB4wX2DXZpfJz83kFQ10/PU7oMi6RqkYNL5Ts/D
         pHr17mofUnIzMsNm5vwTEOxEKyPDOQyaI4++4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680787166;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g07JS6HwJMTcD1ZyJSmNJv7D8T89QHV+vCAkjMWduNo=;
        b=khFPgUiRyn/o+YsQokmJ/Tr2/rYo6ED/fvPkegnfAe8QL2E3h9OZ6Z4a6uqCE3thoC
         WwAyIml8cwwShqvKkG38JKf2LXx8bpeS7wMmHAubL2KIyAOUdWA9mwqLu1yVfsN+fFkC
         RoFkp76VVR1mJSGDHf/RbLF+TgvfUN4jyzgAZoppXEWnGi5DUtgTZ3rzIvqLsCi2DOg6
         ocWsfqk5Vmj/5XQiCDCms83Jl45C5s5G/UroD3ax+Q8cPZ2H1rS3M+ufzMGTKcB8f3pu
         mmTl2faW+3fM/rNUB8tEvIsAhm0D308L2UOYFmoKC7hXm6a4pWJ7S7C2oscXJPv8ky93
         w05A==
X-Gm-Message-State: AAQBX9fGRpwxgjB+Prd2vEEI64aVy47KWd6taYjBtwiOSspYv6cH3uti
        XsoTJinRXw5SEviwD4TPqtuAoqw26EhJ48E8WgsUECj21nUL
X-Google-Smtp-Source: AKy350YhG98jfKYefDhAFRIARwfaHGNYYmkeKyHJDXI2TgElbDdypkTLD2Or0KVWHiqTPYUz9hhaMUZ6EVxU
X-Received: by 2002:a17:907:7292:b0:8e1:12b6:a8fc with SMTP id dt18-20020a170907729200b008e112b6a8fcmr8528778ejc.4.1680787166425;
        Thu, 06 Apr 2023 06:19:26 -0700 (PDT)
Received: from fedora.dectris.local (dect-ch-bad-pfw.cyberlink.ch. [62.12.151.50])
        by smtp-relay.gmail.com with ESMTPS id 7-20020a170906014700b00947de8fa946sm137999ejh.201.2023.04.06.06.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 06:19:26 -0700 (PDT)
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
Subject: [PATCH bpf-next v4 0/3] xsk: Support UMEM chunk_size > PAGE_SIZE
Date:   Thu,  6 Apr 2023 15:18:03 +0200
Message-Id: <20230406131806.51332-1-kal.conley@dectris.com>
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

Happy easter!

Kal Conley (3):
  xsk: Support UMEM chunk_size > PAGE_SIZE
  selftests: xsk: Use hugepages when umem->frame_size > PAGE_SIZE
  selftests: xsk: Add tests for 8K and 9K frame sizes

 Documentation/networking/af_xdp.rst      | 36 ++++++++++-------
 include/net/xdp_sock.h                   |  1 +
 include/net/xdp_sock_drv.h               | 12 ++++++
 include/net/xsk_buff_pool.h              |  3 +-
 net/xdp/xdp_umem.c                       | 50 ++++++++++++++++++++----
 net/xdp/xsk_buff_pool.c                  | 28 ++++++++-----
 tools/testing/selftests/bpf/xskxceiver.c | 27 ++++++++++++-
 tools/testing/selftests/bpf/xskxceiver.h |  2 +
 8 files changed, 126 insertions(+), 33 deletions(-)

-- 
2.39.2

