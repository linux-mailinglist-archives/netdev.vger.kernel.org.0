Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0657F1E521E
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 02:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbgE1AO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 20:14:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbgE1AO0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 20:14:26 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A54A208B8;
        Thu, 28 May 2020 00:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590624865;
        bh=UVYGuTnBYHG6D8sdLn7a/vueVl3fLdb+JsLjk/YAoyk=;
        h=From:To:Cc:Subject:Date:From;
        b=QuCnPyr1CJCkSaUIBubBr/y9dVizITqT2VyMZFfMwwjTjvdXRZ6SuFbdvxyGLBjS/
         0GPeaMtznxAhhrPCNAWkQHRd38Xj+1df40ttKrvRVCfKcqzMBwLX7l7LPcVXjnz7Hr
         32YpGXL6cEIx9rmLJ+NoyKmxY2qCvLksZUQ2mwSo=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        toke@redhat.com, daniel@iogearbox.net, john.fastabend@gmail.com,
        ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com, dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH v2 bpf-next 0/5] bpf: Add support for XDP programs in DEVMAP entries
Date:   Wed, 27 May 2020 18:14:18 -0600
Message-Id: <20200528001423.58575-1-dsahern@kernel.org>
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

v2
- moved dev_map_ext_val definition to uapi to formalize the API for devmap
  extensions; add bpf_ prefix to the prog_fd and prog_id entries
- changed devmap code to handle struct in a way that it can support future
  extensions
- fixed subject in libbpf patch

v1
- fixed prog put on invalid program - Toke
- changed write value from id to fd per Toke's comments about capabilities
- add test cases

David Ahern (5):
  devmap: Formalize map value as a named struct
  bpf: Add support to attach bpf program to a devmap entry
  xdp: Add xdp_txq_info to xdp_buff
  libbpf: Add SEC name for xdp programs attached to device map
  selftest: Add tests for XDP programs in devmap entries

 include/linux/bpf.h                           |   5 +
 include/net/xdp.h                             |   5 +
 include/uapi/linux/bpf.h                      |  12 ++
 kernel/bpf/devmap.c                           | 119 +++++++++++++++---
 net/core/dev.c                                |  18 +++
 net/core/filter.c                             |  17 +++
 tools/include/uapi/linux/bpf.h                |  12 ++
 tools/lib/bpf/libbpf.c                        |   2 +
 .../bpf/prog_tests/xdp_devmap_attach.c        |  94 ++++++++++++++
 .../selftests/bpf/progs/test_xdp_devmap.c     |  19 +++
 .../selftests/bpf/progs/test_xdp_devmap2.c    |  19 +++
 .../bpf/progs/test_xdp_with_devmap.c          |  17 +++
 12 files changed, 322 insertions(+), 17 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_devmap.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_devmap2.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_devmap.c

-- 
2.21.1 (Apple Git-122.3)

