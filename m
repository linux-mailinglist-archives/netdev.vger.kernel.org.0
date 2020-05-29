Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5D51E7544
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 07:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbgE2FVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 01:21:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgE2FVQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 01:21:16 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92E99208B8;
        Fri, 29 May 2020 05:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590729675;
        bh=lT11Tbj+fJhuC/fH3+v5BmwIlh+g585JwvWGiPjw1sY=;
        h=From:To:Cc:Subject:Date:From;
        b=GPzAyIyTucxPeYDL80/3Thsbe8nLR/vUsOvOGBk8hgFexrCwumV6SQFHlQWfvOjYM
         th0oZiCbniyYNmA/CWiiQ7th/mIP7nka2ma6UpY1yAuHpeaZyIRpsDihXNJracdvq/
         +LqyFXi/btxZ7BZqa/Km6g1ZhoxpKAZZaZSIANPA=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com, toke@redhat.com, lorenzo@kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH v3 bpf-next 0/5] bpf: Add support for XDP programs in DEVMAP entries
Date:   Thu, 28 May 2020 23:20:52 -0600
Message-Id: <20200529052057.69378-1-dsahern@kernel.org>
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
 include/uapi/linux/bpf.h                      |  12 ++
 kernel/bpf/devmap.c                           | 121 +++++++++++++++---
 net/core/dev.c                                |  18 +++
 net/core/filter.c                             |  17 +++
 tools/include/uapi/linux/bpf.h                |  12 ++
 tools/lib/bpf/libbpf.c                        |   2 +
 .../bpf/prog_tests/xdp_devmap_attach.c        |  89 +++++++++++++
 .../bpf/progs/test_xdp_devmap_helpers.c       |  22 ++++
 .../bpf/progs/test_xdp_with_devmap_helpers.c  |  43 +++++++
 11 files changed, 328 insertions(+), 18 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_devmap_helpers.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c

-- 
2.21.1 (Apple Git-122.3)

