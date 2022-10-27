Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28B4261023F
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236865AbiJ0UAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236888AbiJ0UAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:00:32 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8AA11A20
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:00:22 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-36b1a68bfa6so23265657b3.22
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IJRg5lgl7kzO11/gALyLFHMHPMyjmqqtY1BF5RnPR14=;
        b=pIzQsnpSaVOO8sqt3SlIBbbbp5f8vt+5f4S6vG1zTlEcojcd7pFtgx9OtrR6wqKYtV
         u1JVcAjJhAibGxcLrpDTMDfv01VAJOia439UJ2cheASuIRUoU9ylX8KdY7WJ+8qtgK4F
         P6hbry+vEmgMIr+S+Xnf0kTyly656ScneE299J74XPrm2fnUJz/IjMv6rYfutp03nBRO
         jjwQ8mL7smDVBDwnkj2WuFIlZhZmWsdDC35QfGv7btqEWHRvnftWZgUO5PqRWP3xcKPA
         dVjd7Fdx6E8rFaXuM7VZlrE6FOs73jcVJ0xH8hc1+DwWlBt9Z5dL0WkPhjWnlsYROdQ7
         IOoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IJRg5lgl7kzO11/gALyLFHMHPMyjmqqtY1BF5RnPR14=;
        b=PWQbGirKRUl9B20bbm6pCHypNNoleaLvh41FgBQB++VBtCWLEyER/HeadL0+oVTUAq
         pWLbKCii2D1RZgY3UxH4UA1xvqDqeG0gWMB9+oQKujNfNkzXLDqLOe185yyrF/bef86l
         el2dV+8gdw2YpfLkcFPBJsvS5RTmND6K3B500MR94piprkNjAkbGdvcZzhdA0Vw4ISxT
         XAWEU4ohtPkxzdZdRUBb0Rz0XfQ1/sTeGaWrJ3zZCx0M7etgWyY/obVVlSTOL4wh558a
         GaW33fnyEv/1pWNlhoIWPmUxYY9MkyCOrWRVSyr2JgBZhwXChxJEEEw9nYWtUNU1QQnD
         aguA==
X-Gm-Message-State: ACrzQf1dVOtbz5jyGv+0YEhSfchMvZ1uGV782L8jHKa6V9Uid/69P2ch
        YdQZC8/SoIlLeQ1aglDWzibV+F8=
X-Google-Smtp-Source: AMsMyM6zYTuXcO6vunm67vhV12nr//6lfCXy+lo+BgbWwTf9fJWfDDLT6f4KPEgSZ+iSKGUJ2C/F2tQ=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a5b:390:0:b0:6b0:22:89fe with SMTP id
 k16-20020a5b0390000000b006b0002289femr0ybp.200.1666900821424; Thu, 27 Oct
 2022 13:00:21 -0700 (PDT)
Date:   Thu, 27 Oct 2022 13:00:14 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221027200019.4106375-1-sdf@google.com>
Subject: [RFC bpf-next 0/5] xdp: hints via kfuncs
From:   Stanislav Fomichev <sdf@google.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an RFC for the alternative approach suggested by Martin and
Jakub. I've tried to CC most of the people from the original discussion,
feel free to add more if you think I've missed somebody.

Summary:
- add new BPF_F_XDP_HAS_METADATA program flag and abuse
  attr->prog_ifindex to pass target device ifindex at load time
- at load time, find appropriate ndo_unroll_kfunc and call
  it to unroll/inline kfuncs; kfuncs have the default "safe"
  implementation if unrolling is not supported by a particular
  device
- rewrite xskxceiver test to use C bpf program and extend
  it to export rx_timestamp (plus add rx timestamp to veth driver)

I've intentionally kept it small and hacky to see whether the approach is
workable or not.

Pros:
- we avoid BTF complexity; the BPF programs themselves are now responsible
  for agreeing on the metadata layout with the AF_XDP consumer
- the metadata is free if not used
- the metadata should, in theory, be cheap if used; kfuncs should be
  unrolled to the same code as if the metadata was pre-populated and
  passed with a BTF id
- it's not all or nothing; users can use small subset of metadata which
  is more efficient than the BTF id approach where all metadata has to be
  exposed for every frame (and selectively consumed by the users)

Cons:
- forwarding has to be handled explicitly; the BPF programs have to
  agree on the metadata layout (IOW, the forwarding program
  has to be aware of the final AF_XDP consumer metadata layout)
- TX picture is not clear; but it's not clear with BTF ids as well;
  I think we've agreed that just reusing whatever we have at RX
  won't fly at TX; seems like TX XDP program might be the answer
  here? (with a set of another tx kfuncs to "expose" bpf/af_xdp metatata
  back into the kernel)

Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Anatoly Burakov <anatoly.burakov@intel.com>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Maryam Tahhan <mtahhan@redhat.com>
Cc: xdp-hints@xdp-project.net
Cc: netdev@vger.kernel.org

Stanislav Fomichev (5):
  bpf: Support inlined/unrolled kfuncs for xdp metadata
  veth: Support rx timestamp metadata for xdp
  libbpf: Pass prog_ifindex via bpf_object_open_opts
  selftests/bpf: Convert xskxceiver to use custom program
  selftests/bpf: Test rx_timestamp metadata in xskxceiver

 drivers/net/veth.c                            |  31 +++++
 include/linux/bpf.h                           |   1 +
 include/linux/btf.h                           |   1 +
 include/linux/btf_ids.h                       |   4 +
 include/linux/netdevice.h                     |   3 +
 include/net/xdp.h                             |  22 ++++
 include/uapi/linux/bpf.h                      |   5 +
 kernel/bpf/syscall.c                          |  28 ++++-
 kernel/bpf/verifier.c                         |  60 +++++++++
 net/core/dev.c                                |   7 ++
 net/core/xdp.c                                |  28 +++++
 tools/include/uapi/linux/bpf.h                |   5 +
 tools/lib/bpf/libbpf.c                        |   1 +
 tools/lib/bpf/libbpf.h                        |   6 +-
 tools/testing/selftests/bpf/Makefile          |   1 +
 .../testing/selftests/bpf/progs/xskxceiver.c  |  43 +++++++
 tools/testing/selftests/bpf/xskxceiver.c      | 119 +++++++++++++++---
 tools/testing/selftests/bpf/xskxceiver.h      |   5 +-
 18 files changed, 348 insertions(+), 22 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/xskxceiver.c

-- 
2.38.1.273.g43a17bfeac-goog

