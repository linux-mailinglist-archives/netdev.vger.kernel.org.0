Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9B91E3472
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgE0BJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 21:09:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727852AbgE0BJI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 21:09:08 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 264CC207CB;
        Wed, 27 May 2020 01:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590541747;
        bh=6z94pBXfnVDft5De4N6GBoBH7z+U2X4UTVLYVD5IUgw=;
        h=From:To:Cc:Subject:Date:From;
        b=PKDZAJuGj6mRl+Wl65pYgtTiUmALdqsR/gfsi0vlGS5axZVo8qfWiHq/O79sd1iMF
         4GB4EcKHRDoqgDLw+tRMsKVF+WUrCw1Ri4pDXyYcQnwDi/p1RyB4TQUQpj8ln2/mtl
         3ilSswxW5ralEFSBQPsWWsIwm9/tG7HLIIuuVTQc=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        toke@redhat.com, daniel@iogearbox.net, john.fastabend@gmail.com,
        ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com, dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH bpf-next 0/5] bpf: Add support for XDP programs in DEVMAP entries
Date:   Tue, 26 May 2020 19:09:00 -0600
Message-Id: <20200527010905.48135-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implementation of Daniel's proposal for allowing DEVMAP entries to be
a device index, program fd pair.

Programs are run after XDP_REDIRECT and have access to both Rx device
and Tx device.

v1
- fixed prog put on invalid program - Toke
- changed write value from id to fd per Toke's comments about capabilities
- add test cases

David Ahern (5):
  bpf: Handle 8-byte values in DEVMAP and DEVMAP_HASH
  bpf: Add support to attach bpf program to a devmap entry
  xdp: Add xdp_txq_info to xdp_buff
  bpftool: Add SEC name for xdp programs attached to device map
  selftest: Add tests for XDP programs in devmap entries

 include/linux/bpf.h                           |   5 +
 include/net/xdp.h                             |   5 +
 include/uapi/linux/bpf.h                      |   3 +
 kernel/bpf/devmap.c                           | 143 +++++++++++++++---
 net/core/dev.c                                |  18 +++
 net/core/filter.c                             |  17 +++
 tools/include/uapi/linux/bpf.h                |   3 +
 tools/lib/bpf/libbpf.c                        |   2 +
 .../bpf/prog_tests/xdp_devmap_attach.c        | 101 +++++++++++++
 .../selftests/bpf/progs/test_xdp_devmap.c     |  19 +++
 .../bpf/progs/test_xdp_with_devmap.c          |  17 +++
 11 files changed, 315 insertions(+), 18 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_devmap.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_devmap.c

-- 
2.21.1 (Apple Git-122.3)

