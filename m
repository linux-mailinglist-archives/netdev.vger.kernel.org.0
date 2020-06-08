Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DCA1F1DC7
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 18:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387431AbgFHQvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 12:51:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59177 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730523AbgFHQvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 12:51:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591635080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=IJqgJi0TbFuBA4SoeHkaZM+/7OxWIOPGA5NgaEXtFn8=;
        b=Siscq+kw++7N74yH5HKHIwaFfIiNd3EkbZ5g0wA8NxUUBy11WMKRfGrbmUYo2/hYi5FjK/
        44YFHokWKV9gzqKVxFT98maFTCOORRwU56du4lP3+oBj2/iIc8Xh+aJ1W7Xp1/hTef22Yw
        6ddUr/KqOB/KfKoPnJTMxnbt9e+DF5I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-LQUUDFU8PMG0OfbRQn-xWQ-1; Mon, 08 Jun 2020 12:51:18 -0400
X-MC-Unique: LQUUDFU8PMG0OfbRQn-xWQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 363E38730A2;
        Mon,  8 Jun 2020 16:51:17 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B90BB5C1C5;
        Mon,  8 Jun 2020 16:51:13 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 7918E300003EB;
        Mon,  8 Jun 2020 18:51:12 +0200 (CEST)
Subject: [PATCH bpf 0/3] bpf: avoid using/returning file descriptor value zero
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@gmail.com>, bpf@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Date:   Mon, 08 Jun 2020 18:51:12 +0200
Message-ID: <159163498340.1967373.5048584263152085317.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make it easier to handle UAPI/kABI extensions by avoid BPF using/returning
file descriptor value zero. Use this in recent devmap extension to keep
older applications compatible with newer kernels.

For special type maps (e.g. devmap and cpumap) the map-value data-layout is
a configuration interface. This is a kernel Application Binary Interface
(kABI) that can only be tail extended. Thus, new members (and thus features)
can only be added to the end of this structure, and the kernel uses the
map->value_size from userspace to determine feature set 'version'.

For this kind of kABI to be extensible and backward compatible, is it common
that new members/fields (that represent a new feature) in the struct are
initialised as zero, which indicate that the feature isn't used. This makes
it possible to write userspace applications that are unaware of new kernel
features, but just include latest uapi headers, zero-init struct and
populate features it knows about.

The recent extension of devmap with a bpf_prog.fd requires end-user to
supply the file-descriptor value minus-1 to communicate that the features
isn't used. This isn't compatible with the described kABI extension model.

---

Jesper Dangaard Brouer (3):
      bpf: syscall to start at file-descriptor 1
      bpf: devmap adjust uapi for attach bpf program
      bpf: selftests and tools use struct bpf_devmap_val from uapi


 fs/file.c                                          |    2 +
 include/linux/file.h                               |    1 +
 include/uapi/linux/bpf.h                           |   13 +++++++
 kernel/bpf/devmap.c                                |   17 ++-------
 kernel/bpf/syscall.c                               |   38 +++++++++++++++++---
 tools/include/uapi/linux/bpf.h                     |   13 +++++++
 .../selftests/bpf/prog_tests/xdp_devmap_attach.c   |    8 ----
 .../selftests/bpf/progs/test_xdp_devmap_helpers.c  |    2 +
 .../bpf/progs/test_xdp_with_devmap_helpers.c       |    3 +-
 9 files changed, 66 insertions(+), 31 deletions(-)

--

