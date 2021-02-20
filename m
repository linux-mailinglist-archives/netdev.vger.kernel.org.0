Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43013205EB
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 16:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbhBTPbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 10:31:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhBTPbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Feb 2021 10:31:50 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3852EC061574;
        Sat, 20 Feb 2021 07:31:08 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id y7so39384116lji.7;
        Sat, 20 Feb 2021 07:31:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BlJKsRFcufgphtlSZCK/DC5jv1Fpb691N3jPCLM61DY=;
        b=FMYiqjecoiYnKqlXFE3vDV4lbi9xKrqJbYr/W28tHfds1rwADXBXA0gj0wylzmv4MW
         I/akLQCyGl6FWmHJqLKbLZEiAYe4MuEs7XELzderEXqjMfyeZEWFd16/4dxFLMcXWejz
         UZYmXk8fESNWUe7tVx4QEGZfUbA1Tdv3a5B1PuGq/WwLmifz+ZkD20iEV5ToqJseMq93
         43ari6RKPOe3aAtVQy5IUBdQszxaJEfvRwuo1llmssEcP7X/+XznHO4EFoYrs/TAOvPK
         K+LI1MqRcdSefwYnqZynXzWmgNdpkOQggZfuIPXn2dIOYuT6JUuR1XIU90ZpxX+k3/8c
         utdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BlJKsRFcufgphtlSZCK/DC5jv1Fpb691N3jPCLM61DY=;
        b=Vg+grh04HOOdtG95zWaXdBo5sUxy40OcXCAKLAQTOjJKZpmWreWLAMLq04Ot+TOEml
         vNIvYclROTPZYIQajhdKQSoZZFUQG31h9XWXhgwxacfkP72hY3TeVL/Cq/51qjd5PxNb
         e4YJsbGGFf33NDqWJgLEm0r1wEpNNgm+jIWnH+GLcx6iWQvpE8euSWFGa7UdPhzXeKN2
         Cv15UoJ8xrhugDdleKMfqYjlaequVkF4IXNGuYcst4ggVaoOSFn8QEpPj/gjz6+8CWdr
         oddcMQFnhxYd2+uE7N1Elqyw8Ka2OonTVQ8AzmVhbhc3gDO3tB/m+zIfKfSZjlHNxyir
         ifog==
X-Gm-Message-State: AOAM531PDUc5Gr1SU/A/WzSxfLocA9rgSkMdHys2OcTr6Tkdi/0sxYle
        sPrXGS4SLl3RJuqKpO/0DYM=
X-Google-Smtp-Source: ABdhPJzRFT5BSryPMvVRyb9sE4Acu/S+ZBsumlfr25bWvyOnm5BD8hcWm3XBtCmTA2NkoSPHEwnCgw==
X-Received: by 2002:a05:651c:1314:: with SMTP id u20mr9309926lja.322.1613835066646;
        Sat, 20 Feb 2021 07:31:06 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id x1sm1312437ljh.62.2021.02.20.07.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 07:31:05 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        bjorn.topel@intel.com, maciej.fijalkowski@intel.com,
        hawk@kernel.org, toke@redhat.com, magnus.karlsson@intel.com,
        john.fastabend@gmail.com, kuba@kernel.org, davem@davemloft.net
Subject: [PATCH bpf-next v2 0/2] Optimize bpf_redirect_map()/xdp_do_redirect()
Date:   Sat, 20 Feb 2021 16:30:54 +0100
Message-Id: <20210220153056.111968-1-bjorn.topel@gmail.com>
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

 include/linux/bpf.h        |  21 ++--
 include/linux/filter.h     |  13 ++-
 include/net/xdp_sock.h     |   6 +-
 include/trace/events/xdp.h |  66 ++++++-----
 kernel/bpf/cpumap.c        |   3 +-
 kernel/bpf/devmap.c        |   5 +-
 kernel/bpf/verifier.c      |  28 +++--
 net/core/filter.c          | 217 ++++++++++++++++++-------------------
 net/xdp/xskmap.c           |   1 -
 9 files changed, 193 insertions(+), 167 deletions(-)


base-commit: 7b1e385c9a488de9291eaaa412146d3972e9dec5
-- 
2.27.0

