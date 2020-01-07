Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 588ED1326F5
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 14:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgAGNDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 08:03:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:35632 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbgAGNDe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 08:03:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 48252B089;
        Tue,  7 Jan 2020 13:03:32 +0000 (UTC)
From:   Michal Rostecki <mrostecki@opensuse.org>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Prashant Bhole <bhole_prashant_q7@lab.ntt.co.jp>,
        Peter Wu <peter@lekensteyn.nl>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 0/2] bpftool/libbpf: Add probe for large INSN limit
Date:   Tue,  7 Jan 2020 14:03:04 +0100
Message-Id: <20200107130308.20242-1-mrostecki@opensuse.org>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series implements a new BPF feature probe which checks for the
commit c04c0d2b968a ("bpf: increase complexity limit and maximum program
size"), which increases the maximum program size to 1M. It's based on
the similar check in Cilium, although Cilium is already aiming to use
bpftool checks and eventually drop all its custom checks.

Examples of outputs:

# bpftool feature probe
[...]
Scanning miscellaneous eBPF features...
Large complexity limit and maximum program size (1M) is available

# bpftool feature probe macros
[...]
/*** eBPF misc features ***/
#define HAVE_HAVE_LARGE_INSN_LIMIT

# bpftool feature probe -j | jq '.["misc"]'
{
  "have_large_insn_limit": true
}

v1 -> v2:
- Test for 'BPF_MAXINSNS + 1' number of total insns.
- Remove info about the current 1M limit from probe's description.

Michal Rostecki (2):
  libbpf: Add probe for large INSN limit
  bpftool: Add misc secion and probe for large INSN limit

 tools/bpf/bpftool/feature.c   | 18 ++++++++++++++++++
 tools/lib/bpf/libbpf.h        |  1 +
 tools/lib/bpf/libbpf.map      |  1 +
 tools/lib/bpf/libbpf_probes.c | 21 +++++++++++++++++++++
 4 files changed, 41 insertions(+)

-- 
2.16.4

