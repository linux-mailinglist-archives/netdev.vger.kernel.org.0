Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6685FE1F
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 23:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbfGDV1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 17:27:07 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:39719 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727093AbfGDV1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 17:27:07 -0400
Received: by mail-wr1-f52.google.com with SMTP id x4so7843833wrt.6
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 14:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=Bu29TzmUk2drkOkTMs3d2hr+pj0BaeOOKmBc8wkppTw=;
        b=L25WLc2gVfOM7jMB54dR6hYXVTkbmU51btB64ZE/1doE4XqMy4+/5ZgBZ+C9UxxUYD
         GBFM9spoJ4XQtQNq3GHlch27/jAAMZDl0nACTwejtDzCCYCRgy+q4mydeHTmYJm/Z1xG
         NZ0gWnRIbRrTWtvzH5W9bnUlVxBFE5imGjUITn3LjfkUyCmW1LFZx9xLf00Atmn75WR0
         pSb7agTj2x0cJ4m+uWKniTbQLKdAej/EQnV3TlPWSMw8ALe5swImtvtFHFjoCMw2qabS
         9DQ5YECpkxoKzr7y2c5cUsI6ZkAkBP2nibIUl+tjwiCTaX/RwGw51GmuaooiANJ9eFRI
         45Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Bu29TzmUk2drkOkTMs3d2hr+pj0BaeOOKmBc8wkppTw=;
        b=tAqhzMSY3j4Gcaxfr2PpkXC9LlU9RoRMBYT/Q19lAbIsdj2yz6q/KYYnrCgekflS3s
         jnOdQxdRSnhcHCb9qqDse5Y3yAVbO6uPvxlakvkj5GyiSk+oS4ChFHIG1jypjg5Cz90i
         ckX3YEjLjciIdkPkV+p7FPtpOvIDaZlOYSq3K8RAeXSh41Rdb0Ud3Yfp2n6RlyjLDBqb
         AER483YpeSeIRw97a5jcB0q7byf8Ba0NXHAMIuauLT5J403kxVEmDZNFxNjaxRSZEGJO
         pP58joqzcDSGeWOuAmDIpZP8ISh1YxbRSYfkP/emJvZkDu3PbHMAHpU84gzm+CihU8qV
         vtmg==
X-Gm-Message-State: APjAAAURQHRD+xbTtItLQ5IzNf/ROCltdwUU7xMR/yjuMIzAJ76NfqYt
        3JwU4EnprpzNNuA7y6veYViaLg==
X-Google-Smtp-Source: APXvYqzQa3QUiZR0GoFf9lB3wg/Q1ec4x0Ro6wBGruDAVYZhglqlQnOvkj7ECPEkf3qDCXIxKS4x+w==
X-Received: by 2002:adf:e78b:: with SMTP id n11mr339457wrm.191.1562275623888;
        Thu, 04 Jul 2019 14:27:03 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id t17sm9716654wrs.45.2019.07.04.14.27.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 04 Jul 2019 14:27:03 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     ecree@solarflare.com, naveen.n.rao@linux.vnet.ibm.com,
        andriin@fb.com, jakub.kicinski@netronome.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [RFC bpf-next 0/8] bpf: accelerate insn patching speed
Date:   Thu,  4 Jul 2019 22:26:43 +0100
Message-Id: <1562275611-31790-1-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an RFC based on latest bpf-next about acclerating insn patching
speed, it is now near the shape of final PATCH set, and we could see the
changes migrating to list patching would brings, so send out for
comments. Most of the info are in cover letter. I splitted the code in a
way to show API migration more easily.

Test Results
===
  - Full pass on test_verifier/test_prog/test_prog_32 under all three
    modes (interpreter, JIT, JIT with blinding).

  - Benchmarking shows 10 ~ 15x faster on medium sized prog, and reduce
    patching time from 5100s (nearly one and a half hour) to less than
    0.5s for 1M insn patching.

Known Issues
===
  - The following warning is triggered when running scale test which
    contains 1M insns and patching:
      warning of mm/page_alloc.c:4639 __alloc_pages_nodemask+0x29e/0x330

    This is caused by existing code, it can be reproduced on bpf-next
    master with jit blinding enabled, then run scale unit test, it will
    shown up after half an hour. After this set, patching is very fast, so
    it shows up quickly.

  - No line info adjustment support when doing insn delete, subprog adj
    is with bug when doing insn delete as well. Generally, removal of insns
    could possibly cause remove of entire line or subprog, therefore
    entries of prog->aux->linfo or env->subprog needs to be deleted. I
    don't have good idea and clean code for integrating this into the
    linearization code at the moment, will do more experimenting,
    appreciate ideas and suggestions on this.
     
    Insn delete doesn't happen on normal programs, for example Cilium
    benchmarks, and happens rarely on test_progs, so the test coverage is
    not good. That's also why this RFC have a full pass on selftest with
    this known issue.

  - Could further use mem pool to accelerate the speed, changes are trivial
    on top of this RFC, and could be 2x extra faster. Not included in this
    RFC as reducing the algo complexity from quadratic to linear of insn
    number is the first step.

Background
===
This RFC aims to accelerate BPF insn patching speed, patching means expand
one bpf insn at any offset inside bpf prog into a set of new insns, or
remove insns.

At the moment, insn patching is quadratic of insn number, this is due to
branch targets of jump insns needs to be adjusted, and the algo used is:

  for insn inside prog
    patch insn + regeneate bpf prog
    for insn inside new prog
      adjust jump target

This is causing significant time spending when a bpf prog requires large
amount of patching on different insns. Benchmarking shows it could take
more than half minutes to finish patching when patching number is more
than 50K, and the time spent could be more than one hour when patching
number is around 1M.

  15000   :    3s
  45000   :   29s
  95000   :  125s
  195000  :  712s
  1000000 : 5100s

This RFC introduces new patching infrastructure. Before doing insn
patching, insns in bpf prog are turned into a singly linked list, insert
new insns just insert new list node, delete insns just set delete flag.
And finally, the list is linearized back into array, and branch target
adjustment is done for all jump insns during linearization. This algo
brings the time complexity from quadratic to linear of insn number.

Benchmarking shows the new patching infrastructure could be 10 ~ 15x faster
on medium sized prog, and for a 1M patching it reduce the time from 5100s
to less than 0.5s.

Patching API
===
Insn patching could happen on two layers inside BPF. One is "core layer"
where only BPF insns are patched. The other is "verification layer" where
insns have corresponding aux info as well high level subprog info, so
insn patching means aux info needs to be patched as well, and subprog info
needs to be adjusted. BPF prog also has debug info associated, so line info
should always be updated after insn patching.

So, list creation, destroy, insert, delete is the same for both layer,
but lineration is different. "verification layer" patching require extra
work. Therefore the patch APIs are:

   list creation:                bpf_create_list_insn
   list patch:                   bpf_patch_list_insn
   list pre-patch:               bpf_prepatch_list_insn
   list lineration (core layer): prog = bpf_linearize_list_insn(prog, list)
   list lineration (veri layer): env = verifier_linearize_list_insn(env, list)
   list destroy:                 bpf_destroy_list_insn

list patch could change the insn at patch point, it will invalid the aux
info at patching point. list pre-patch insert new insns before patch point
where the insn and associated aux info are not touched, it is used for
example in convert_ctx_access when generating prologue. 

Typical API sequence for one patching pass:

   struct bpf_list_insn list = bpf_create_list_insn(struct bpf_prog);
   for (elem = list; elem; elem = elem->next)
      patch_buf = gen_patch_buf_logic;
      elem = bpf_patch_list_insn(elem, patch_buf, cnt);
   bpf_prog = bpf_linearize_list_insn(list)
   bpf_destroy_list_insn(list)
  
Several patching passes could also share the same list:

   struct bpf_list_insn list = bpf_create_list_insn(struct bpf_prog);
   for (elem = list; elem; elem = elem->next)
      patch_buf = gen_patch_buf_logic1;
      elem = bpf_patch_list_insn(elem, patch_buf, cnt);
   for (elem = list; elem; elem = elem->next)
      patch_buf = gen_patch_buf_logic2;
      elem = bpf_patch_list_insn(elem, patch_buf, cnt);
   bpf_prog = bpf_linearize_list_insn(list)
   bpf_destroy_list_insn(list)

but note new inserted insns int early passes won't have aux info except
zext info. So, if one patch pass requires all aux info updated and
recalculated for all insns including those pathced, it should first
linearize the old list, then re-create the list. The RFC always create and
linearize the list for each migrated patching pass separately.

Compared with old patching code, this new infrastructure has much less core
code, even though the final code has a couple of extra lines but that is
mostly due to for list based infrastructure, we need to do more error
checks, so the list and associated aux data structure could be freed when
errors happens.

Patching Restrictions
===
  - For core layer, the linearization assume no new jumps inside patch buf.
    Currently, the only user of this layer is jit blinding.
  - For verifier layer, there could be new jumps inside patch buf, but
    they should have branch target resolved themselves, meaning new jumps
    doesn't jump to insns out of the patch buf. This is the case for all
    existing verifier layer users.
  - bpf_insn_aux_data for all patched insns including the one at patch
    point are invalidated, only 32-bit zext info will be recalcuated.
    If the aux data of insn at patch point needs to be retained, it is
    purely insn insertion, so need to use the pre-patch API.

I plan to send out a PATCH set once I finished insn deletion line info adj
support, please have a looks at this RFC, and appreciate feedbacks.

Jiong Wang (8):
  bpf: introducing list based insn patching infra to core layer
  bpf: extend list based insn patching infra to verification layer
  bpf: migrate jit blinding to list patching infra
  bpf: migrate convert_ctx_accesses to list patching infra
  bpf: migrate fixup_bpf_calls to list patching infra
  bpf: migrate zero extension opt to list patching infra
  bpf: migrate insn remove to list patching infra
  bpf: delete all those code around old insn patching infrastructure

 include/linux/bpf_verifier.h |   1 -
 include/linux/filter.h       |  27 +-
 kernel/bpf/core.c            | 431 +++++++++++++++++-----------
 kernel/bpf/verifier.c        | 649 +++++++++++++++++++------------------------
 4 files changed, 580 insertions(+), 528 deletions(-)

-- 
2.7.4

