Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7E11E8AF6
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 00:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbgE2WHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 18:07:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727879AbgE2WHV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 18:07:21 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95C6520776;
        Fri, 29 May 2020 22:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590790041;
        bh=VTi2FkcgfEm5oHMUr49iC4/2rhm237J2+Mangk8Q6do=;
        h=From:To:Cc:Subject:Date:From;
        b=AICbjLWZ0MdqhSV3KR4kusqimlA9dWp+iOK5vK2iChDQlsf3zaIiwiYYWprfQyoFZ
         vTw0wAaq9H0gq9HsuYT/f7xfqOVmqF0WuNmrhF9MJepIUuOjEMh1IDZz+UHEaW1wGU
         KuV0mp2TAQqMIqmeRJw0K80crrnkcexBi+8Yv+JU=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com, toke@redhat.com, lorenzo@kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH v4 bpf-next 0/5] bpf: Add support for XDP programs in DEVMAP entries
Date:   Fri, 29 May 2020 16:07:11 -0600
Message-Id: <20200529220716.75383-1-dsahern@kernel.org>
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

v4
- moved struct bpf_devmap_val from uapi to devmap.c, named the union
  and dropped the prefix from the elements - Jesper
- fixed 2 bugs in selftests

v3
- renamed struct to bpf_devmap_val
- used offsetofend to check for expected map size, modification of
  Toke's comment
- check for explicit value sizes
- adjusted switch statement in dev_map_run_prog per Andrii's comment
- changed SEC shortcut to xdp_devmap
- changed selftests to use skeleton and new map declaration

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
 include/uapi/linux/bpf.h                      |   3 +
 kernel/bpf/devmap.c                           | 130 +++++++++++++++---
 net/core/dev.c                                |  18 +++
 net/core/filter.c                             |  17 +++
 tools/include/uapi/linux/bpf.h                |   3 +
 tools/lib/bpf/libbpf.c                        |   2 +
 .../bpf/prog_tests/xdp_devmap_attach.c        |  97 +++++++++++++
 .../bpf/progs/test_xdp_devmap_helpers.c       |  22 +++
 .../bpf/progs/test_xdp_with_devmap_helpers.c  |  44 ++++++
 11 files changed, 328 insertions(+), 18 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_devmap_helpers.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c

-- 
2.21.1 (Apple Git-122.3)

