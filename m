Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D664FBA2C
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 21:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfKMUr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 15:47:57 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33579 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbfKMUr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 15:47:56 -0500
Received: by mail-pg1-f195.google.com with SMTP id h27so2124961pgn.0;
        Wed, 13 Nov 2019 12:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5CFKWDDUgI0v3hoXkpIRJxPSOP/yeALUP1oQBvJImpU=;
        b=cv+4QDLiN0T+7PHF87p/toHeNQoTs4UNkZv5//JTZAuJTnmWjahAai8xxVutKDaX6p
         AqqRPOio0lUm3VrlZr0yFyXS52am4BwaKlAk2e9N63UHzGq0oT6NULzOoQdbNC9Ttx42
         p7zW2sQWGiWJDcYSzU+pajdLGJTosglOCEcrWmfHsBMxUEJuNALjKF/NSB1orEyFblrj
         a1jQANF6DTFtJUj7mwv0pNMdhzvxlD0R4Dun31DZmg/akHe/QHXdnZrSJGUREA3DkTee
         giwIPoBzOlTLjL7HkrbCsxsU25/2+zzcci00yU57YmwAUPOoqx02yugX9Tc6pQ2xA8wN
         7Avw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5CFKWDDUgI0v3hoXkpIRJxPSOP/yeALUP1oQBvJImpU=;
        b=ug58Nam1akMffyvfh78sahRZa3hKapgAsYDnQA6jbhJMTktbmcKJfytnZHr85UisaK
         1HmSGIYRgghKnK6bi30lIFgc0mrVuSoTaYBI669HOpFJBAFE28+7uPEmb6N/5109mCDK
         qIFjLE3k82UorXV/sL13gg+7qlc1cksXDQerL1NO6smVy9qeqRll/NSKzKF5JzrFToWp
         Pp6X8KgFkK4hgZnWi1ZDGhF+KDQjQDmRkq7x2KLVGAnclSKyZ6TH/gpMHkehha6m0qez
         qBlkjkELSzo/pwscLeXZAcM4n0txvDrVX7dL+R5qDTNZytgwagGshAaDkjc++0PPUwNL
         QMPA==
X-Gm-Message-State: APjAAAWczw54BgOt1hDc/g1L1B1irbknriOz+RbEsHFvQTWvKhyy0zrs
        8Ox4GW+xzKdSAdT/yEqT4ODI5DnulR0=
X-Google-Smtp-Source: APXvYqwqw/sQyEivtly4XvW4M/Yy7EqYODDgUBFE4idmdtxgW5lQ+28LR25Cemxzlp1Vbi1ypBlh0Q==
X-Received: by 2002:a17:90a:dd42:: with SMTP id u2mr5800898pjv.57.1573678075629;
        Wed, 13 Nov 2019 12:47:55 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id g20sm3235861pgk.46.2019.11.13.12.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 12:47:55 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com
Subject: [RFC PATCH bpf-next 0/4] Introduce xdp_call.h and the BPF dispatcher
Date:   Wed, 13 Nov 2019 21:47:33 +0100
Message-Id: <20191113204737.31623-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This RFC(!) introduces the BPF dispatcher and xdp_call.h, and it's a
mechanism to avoid the retpoline overhead by text-poking/rewriting
indirect calls to direct calls.

The ideas build on Alexei's V3 of the BPF trampoline work, namely:
  * Use the existing BPF JIT infrastructure generate code
  * Use bpf_arch_text_poke() to modify the kernel text  

To try the series out, you'll need V3 of the BPF trampoline work [1].

The main idea; Each XDP call-site calls the jited dispatch table,
instead of an indirect call. The dispatch table calls the XDP programs
directly. In pseudo code this be something similar to:

unsigned int do_call(struct bpf_prog *prog, struct xdp_buff *xdp)
{
	if (&prog == PROG1)
		return call_direct_PROG1(xdp);
	if (&prog == PROG2)
		return call_direct_PROG2(xdp);
	return indirect_call(prog, xdp);
}

The current dispatcher supports four entries. It could support more,
but I don't know if it's really practical (...and I was lazy -- more
than 4 entries meant moving to >1B Jcc. :-P). The dispatcher is
re-generated for each new XDP program/entry. The upper limit of four
in this series means that if six i40e netdevs have an XDP program
running, the fifth and sixth will be using an indirect call.

Now to the performance numbers. I ran this on my 3 GHz Skylake, 64B
UDP packets are sent to the i40e at ~40 Mpps.

Benchmark:
  # ./xdp_rxq_info --dev enp134s0f0 --action XDP_DROP

  1. Baseline:            26.0 Mpps
  2. Dispatcher 1 entry:  35,5 Mpps (+36.5%)
  3. Dispatcher 4 enties: 32.9 Mpps (+26.5%)
  4. Dispatcher 5 enties: 24.2 Mpps (-6.9%)

Scenario 4 is that the benchmark uses the dispatcher, but the table is
full. This means that the caller pays for the dispatching *and* the
retpoline.

Is this a good idea? The performance is nice! Can it be done in a
better way? Useful for other BPF programs? I would love your input!


Thanks!
Björn

[1] https://patchwork.ozlabs.org/cover/1191672/

Björn Töpel (4):
  bpf: teach bpf_arch_text_poke() jumps
  bpf: introduce BPF dispatcher
  xdp: introduce xdp_call
  i40e: start using xdp_call.h

 arch/x86/net/bpf_jit_comp.c                 | 130 ++++++++++++-
 drivers/net/ethernet/intel/i40e/i40e_main.c |   5 +
 drivers/net/ethernet/intel/i40e/i40e_txrx.c |   5 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  |   5 +-
 include/linux/bpf.h                         |   3 +
 include/linux/xdp_call.h                    |  49 +++++
 kernel/bpf/Makefile                         |   1 +
 kernel/bpf/dispatcher.c                     | 197 ++++++++++++++++++++
 8 files changed, 388 insertions(+), 7 deletions(-)
 create mode 100644 include/linux/xdp_call.h
 create mode 100644 kernel/bpf/dispatcher.c

-- 
2.20.1

