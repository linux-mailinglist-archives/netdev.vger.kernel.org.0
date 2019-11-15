Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC5F9FD22E
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 02:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfKOBEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 20:04:20 -0500
Received: from www62.your-server.de ([213.133.104.62]:50704 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727112AbfKOBEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 20:04:20 -0500
Received: from 57.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.57] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iVQ25-00080O-5I; Fri, 15 Nov 2019 02:04:17 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH rfc bpf-next 0/8] Optimize BPF tail calls for direct jumps
Date:   Fri, 15 Nov 2019 02:03:54 +0100
Message-Id: <cover.1573779287.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25633/Thu Nov 14 10:50:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This gets rid of indirect jumps for BPF tail calls whenever possible.
See patch 7/8 for more general details. This is on top of Alexei's
'[v4,bpf-next,00/20] Introduce BPF trampoline' series [0]. For non-RFC
I'll still massage commit messages a bit and expand the existing set
of tail call tests with a few more kselftest cases.

Thanks,
Daniel

  [0] https://patchwork.ozlabs.org/project/netdev/list/?series=142923

Daniel Borkmann (8):
  bpf, x86: generalize and extend bpf_arch_text_poke for direct jumps
  bpf: add bpf_prog_under_eviction helper
  bpf: move bpf_free_used_maps into sleepable section
  bpf: move owner type,jited info into array auxillary data
  bpf: add jit poke descriptor mock-up for jit images
  bpf: add poke dependency tracking for prog array maps
  bpf, x86: emit patchable direct jump as tail call
  bpf: constant map key tracking for prog array pokes

 arch/x86/net/bpf_jit_comp.c  | 234 ++++++++++++++++++++++++-----------
 include/linux/bpf.h          |  85 +++++++++++--
 include/linux/bpf_verifier.h |   1 +
 include/linux/filter.h       |  10 ++
 kernel/bpf/arraymap.c        | 152 ++++++++++++++++++++++-
 kernel/bpf/core.c            |  73 ++++++++++-
 kernel/bpf/map_in_map.c      |   5 +-
 kernel/bpf/syscall.c         |  41 ++----
 kernel/bpf/verifier.c        |  98 +++++++++++++++
 9 files changed, 578 insertions(+), 121 deletions(-)

-- 
2.21.0

