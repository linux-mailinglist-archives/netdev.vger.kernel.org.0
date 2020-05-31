Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 234DB1E9A93
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 23:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgEaVrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 17:47:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbgEaVrK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 17:47:10 -0400
Received: from lore-desk.lan (unknown [151.48.128.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27920206B6;
        Sun, 31 May 2020 21:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590961629;
        bh=oC1qQKWjcs0kl6BKd6GBac5QD9FNgKqTBkiXDlCNpAU=;
        h=From:To:Cc:Subject:Date:From;
        b=ZN+h6ygnwihYg0OsMvSBVX2sXu/Ea5U+cxemIPn6tRDKkLcjXVcsyuZgRtTlYgbje
         1vTeIyDexz07LhU5ml5lWSiOHhtPgj3NcHNL/UBQHua5EeMbVlthe/NQsgB+8/Ercy
         B3IOfLprhbpSYEQYgvcvvZ1spGK0U3QR4oTX3db4=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, brouer@redhat.com,
        toke@redhat.com, daniel@iogearbox.net, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org
Subject: [PATCH bpf-next 0/6] introduce support for XDP programs in CPUMAP
Date:   Sun, 31 May 2020 23:46:45 +0200
Message-Id: <cover.1590960613.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to what David Ahern proposed in [1] for DEVMAPs, introduce the
capability to attach and run a XDP program to CPUMAP entries.
The idea behind this feature is to add the possibility to define on which CPU
run the eBPF program if the underlying hw does not support RSS.
I respin patch 1/6 from a previous series sent by David [2]
This series is based on the following series:
- https://patchwork.ozlabs.org/project/netdev/cover/cover.1590698295.git.lorenzo@kernel.org/
- https://patchwork.ozlabs.org/project/netdev/cover/20200529220716.75383-1-dsahern@kernel.org/

[1] https://patchwork.ozlabs.org/project/netdev/cover/20200529220716.75383-1-dsahern@kernel.org/
[2] https://patchwork.ozlabs.org/project/netdev/patch/20200513014607.40418-2-dsahern@kernel.org/

David Ahern (1):
  net: Refactor xdp_convert_buff_to_frame

Lorenzo Bianconi (5):
  samples/bpf: xdp_redirect_cpu_user: do not update bpf maps in option
    loop
  cpumap: formalize map value as a named struct
  bpf: cpumap: add the possibility to attach a eBPF program to cpumap
  bpf: cpumap: implement XDP_REDIRECT for eBPF programs attached to map
    entries
  samples/bpf: xdp_redirect_cpu: load a eBPF program on cpumap

 include/linux/bpf.h                 |   6 ++
 include/net/xdp.h                   |  35 ++++---
 include/trace/events/xdp.h          |  18 +++-
 include/uapi/linux/bpf.h            |   1 +
 kernel/bpf/cpumap.c                 | 147 +++++++++++++++++++++++-----
 net/core/dev.c                      |   8 ++
 net/core/filter.c                   |   7 ++
 samples/bpf/xdp_redirect_cpu_kern.c |  34 +++++--
 samples/bpf/xdp_redirect_cpu_user.c | 140 ++++++++++++++++++++++----
 tools/include/uapi/linux/bpf.h      |   1 +
 10 files changed, 329 insertions(+), 68 deletions(-)

-- 
2.26.2

