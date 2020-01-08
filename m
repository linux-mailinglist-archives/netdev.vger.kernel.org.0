Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB4B61347D7
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbgAHQYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:24:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:32850 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727618AbgAHQYm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 11:24:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BD268B281;
        Wed,  8 Jan 2020 16:24:40 +0000 (UTC)
From:   Michal Rostecki <mrostecki@opensuse.org>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stanislav Fomichev <sdf@google.com>,
        Prashant Bhole <bhole_prashant_q7@lab.ntt.co.jp>,
        Peter Wu <peter@lekensteyn.nl>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v3 0/2] bpftool/libbpf: Add probe for large INSN limit
Date:   Wed,  8 Jan 2020 17:23:51 +0100
Message-Id: <20200108162428.25014-1-mrostecki@opensuse.org>
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
- Remove info about current 1M limit from probe's description.

v2 -> v3:
- Remove the "complexity" word from probe's description.

Michal Rostecki (2):
  libbpf: Add probe for large INSN limit
  bpftool: Add misc section and probe for large INSN limit

 tools/bpf/bpftool/feature.c   | 18 ++++++++++++++++++
 tools/lib/bpf/libbpf.h        |  1 +
 tools/lib/bpf/libbpf.map      |  1 +
 tools/lib/bpf/libbpf_probes.c | 21 +++++++++++++++++++++
 4 files changed, 41 insertions(+)

-- 
2.16.4

