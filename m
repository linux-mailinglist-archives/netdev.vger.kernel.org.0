Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C137431FB87
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 16:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhBSPAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 10:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbhBSPAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 10:00:16 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C778EC061756;
        Fri, 19 Feb 2021 06:59:33 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id c8so21954239ljd.12;
        Fri, 19 Feb 2021 06:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nC9kwGOyo2cb6wG6XNQD/v+S5EsZ+WWCpphEOR6VRGw=;
        b=a7qUEiGSLjPMFupolbfYkgOu5RIuBx4gbLDdiE0jsXGHnCCQ2bFKa8PKAYJrj0lH5V
         gRjVeXo04t+XXQi5+GCecAfU+E2UeMK6GjeiQ77qaNk7Eo7Lob9ajlBzNlXDFOiSQLjn
         0oeV+Fv3wiFS9B1irgiMwGC2VP5/OLgItP8EwAOH2MvkXWgRY/ECQXj93K+3e8p3pyJm
         fd+8WmNnMZKsC6NaIc5dGlLsIXPaowxnR9FlYZUAXswoVLg1J5o2SsxITv0RcixG74ll
         v4ICAb5WA9u1WcVoiEfDuGks3SHIkoDlBOZ3YSuPSEjiFxY5L8Uj0++zcJuHMmN2zXcs
         A3nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nC9kwGOyo2cb6wG6XNQD/v+S5EsZ+WWCpphEOR6VRGw=;
        b=WAD/ghLkaPK2037zw+P2QalmbQlxDhj2Eo1Znmv+0qIxQJhh4nJfBZhCbbjcwB88vO
         L0Mt7iJpydISC+RUvlEfl45bs8Phgv0MToU8b8bbN3R1auYnRiFD8Sd3F9Jm3Smmicw3
         mBFc2iWseed/thuqU5VaTIPcLeRajgobjMTIn4VxACWoYHvWXaJO0SLBjV5+yCO80RIt
         lZv2qTDX3Xoilc7Kl8dCIzDL2cPEGnW/TXLZBgWWH7viVuPf1REuckvTteoTymM5kssh
         ehcxRU9XMfMZRwkcS7DWe9shgL3Vr+irfwyfzNYbmokdfYq4M0+MLE5oxP8IMjgnjfDJ
         J2qg==
X-Gm-Message-State: AOAM533in0uzovH0zdrtfmui8YzfpjGlDSK51DMYZq/hzVRnEokLGtAl
        d9GbtDNZ6g1Nw/IuzRRdK/o=
X-Google-Smtp-Source: ABdhPJxO+mKy7KF8QDDdb5QJWxtMyi42Ub7zmbL2k9fsiSDkpzW0v5kqlMCRzGR6vgY8ojlGWwe7Uw==
X-Received: by 2002:a19:2d52:: with SMTP id t18mr6025805lft.554.1613746772364;
        Fri, 19 Feb 2021 06:59:32 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id d9sm974092lfl.290.2021.02.19.06.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 06:59:31 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        bjorn.topel@intel.com, maciej.fijalkowski@intel.com,
        hawk@kernel.org, toke@redhat.com, magnus.karlsson@intel.com,
        john.fastabend@gmail.com, kuba@kernel.org, davem@davemloft.net
Subject: [PATCH bpf-next 0/2] Optimize bpf_redirect_map()/xdp_do_redirect()
Date:   Fri, 19 Feb 2021 15:59:20 +0100
Message-Id: <20210219145922.63655-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi XDP-folks,

This two patch series contain two optimizations for the
bpf_redirect_map() helper and the xdp_do_redirect() function.

The bpf_redirect_map() optimization is about avoiding the map lookup
dispatching. Instead of having a switch-statement and selecting the
correct lookup function, we let the verifier patch the
bpf_redirect_map() call to a specific lookup function. This way the
run-time lookup is avoided.

The xdp_do_redirect() patch restructures the code, so that the map
pointer indirection can be avoided.

Performance-wise I got 3% improvement for XSKMAP
(sample:xdpsock/rx-drop), and 4% (sample:xdp_redirect_map) on my
machine.

More details in each commit. Changes since the RFC is outlined in each
commit.


Cheers,
Björn


Björn Töpel (2):
  bpf, xdp: per-map bpf_redirect_map functions for XDP
  bpf, xdp: restructure redirect actions

 include/linux/bpf.h        |  20 ++--
 include/linux/filter.h     |  13 ++-
 include/net/xdp_sock.h     |   6 +-
 include/trace/events/xdp.h |  66 ++++++-----
 kernel/bpf/cpumap.c        |   3 +-
 kernel/bpf/devmap.c        |   5 +-
 kernel/bpf/verifier.c      |  28 +++--
 net/core/filter.c          | 219 ++++++++++++++++++-------------------
 net/xdp/xskmap.c           |   1 -
 9 files changed, 192 insertions(+), 169 deletions(-)


base-commit: 7b1e385c9a488de9291eaaa412146d3972e9dec5
-- 
2.27.0

