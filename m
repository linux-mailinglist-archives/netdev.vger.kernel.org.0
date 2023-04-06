Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9376D9789
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 15:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236898AbjDFNCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 09:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236782AbjDFNCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 09:02:37 -0400
Received: from mail-wr1-x461.google.com (mail-wr1-x461.google.com [IPv6:2a00:1450:4864:20::461])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C628A42
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 06:02:35 -0700 (PDT)
Received: by mail-wr1-x461.google.com with SMTP id h17so39426115wrt.8
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 06:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1680786154;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lJTyubGtR9afjmMP145Wo4eieXkwomc+B8BdIn4crp4=;
        b=LUVXrdEAoV9dUnQ7+Y9pUxMz4cNKc2gzDcY4bL0V5NNAjSeX8JDmQkghnNyC65NW3j
         tXpyfa9hByTXsI7pWbVFipVgNkR5GcRi7JfigkrN0rI5MdIwAjxlwwF7N6MKCB6rVg6B
         zAGl6zHj+fJQFs4iJ1mLbBDaOUpf/FTlTkqeo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680786154;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lJTyubGtR9afjmMP145Wo4eieXkwomc+B8BdIn4crp4=;
        b=TIUgJGJDAgZgO+311V3sLo/exvGCTo06wrbnpcVaUcUzRlxt/AJOMoCeEea9EV2/d3
         R/BnK1FPMSzz/0mWbWaIEn8Hi81+MJJMpdTTdCOLVDJTs4T54wk+n0HljWlwMnmBV/Bn
         6+AbNl4bUHdZ0GaZ2BCiS2oE7rQ0Vi09ZfJFdVnaSAqPIBz4URSvC4yfmmGPNJaLq+Fa
         4BYeLb0A+xDMYwdprBoaj/DSQJFQ9qtIcOih+EO3JJaImQL4AnSS6YGuPGvA8BzR6Xu0
         C8RIvs65jE+KgWrY08w66yi4lS+0JiBqXKFOSP4JMCWbGRN9ds86eN+PaHKhsn1aNVKH
         d33w==
X-Gm-Message-State: AAQBX9c41HKy5Dz6ZLkj9a981wgv08QX51I7UOMzjzNMJT+16hJStuQf
        7LzYa8RjjEAssrrEH+xcvZwaj++HzkjbI+GyS4Z8bsjIsROE
X-Google-Smtp-Source: AKy350ZJuEOdq2/XFfjsEgrMWKZpy6wjFQGhFwJ7LSmInG/+mNrqnKTo1u90+GvuaHQyIVA4dwWY714FS0T4
X-Received: by 2002:adf:dd8b:0:b0:2ee:c42e:a54e with SMTP id x11-20020adfdd8b000000b002eec42ea54emr1692233wrl.50.1680786144488;
        Thu, 06 Apr 2023 06:02:24 -0700 (PDT)
Received: from fedora.dectris.local (dect-ch-bad-pfw.cyberlink.ch. [62.12.151.50])
        by smtp-relay.gmail.com with ESMTPS id s3-20020adfeb03000000b002e62dd5b3d6sm65625wrn.3.2023.04.06.06.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 06:02:24 -0700 (PDT)
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
Subject: [PATCH bpf-next v3 0/3] xsk: Support UMEM chunk_size > PAGE_SIZE
Date:   Thu,  6 Apr 2023 15:02:02 +0200
Message-Id: <20230406130205.49996-1-kal.conley@dectris.com>
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
 net/xdp/xdp_umem.c                       | 51 ++++++++++++++++++++----
 net/xdp/xsk_buff_pool.c                  | 28 ++++++++-----
 tools/testing/selftests/bpf/xskxceiver.c | 27 ++++++++++++-
 tools/testing/selftests/bpf/xskxceiver.h |  2 +
 8 files changed, 127 insertions(+), 33 deletions(-)

-- 
2.39.2

