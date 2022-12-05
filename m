Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 219EC642E75
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 18:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiLERQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 12:16:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiLERP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 12:15:59 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FFE1B1E5
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 09:15:57 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id l42-20020a9d1b2d000000b0066c6366fbc3so7672446otl.3
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 09:15:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U8TFZBYQQ8h+X8k7K87tVsmzs5n8iJUVUvNZgNZrxs4=;
        b=LgrDFSd2pv32PVcdAaI+6RMH8jk4ARJef8HZhK0D4RiUvujWUWSKYh7ZvDU7tAxe6U
         QhrofEM58nqfRn/5PmuCPNqWFZD1OY4MX6X/3tgGa0xtTb5Fzyt8p2VH/c758Qjcd/Be
         vknOIG6MM2iqu5ZpXuPaXw9DA81mZ4P29SvnuQ9VtzX8eS7/iSbk3YWwbyDVvXX4+WGs
         y96pDwpov7ffzVjfAYvvKFljlzLtG2cZbAwPpaYo+r3qGhkIj6g3J16DpDyh5BN/2nop
         NHPgxpIkwg8px2u5pTw2cBW3dAV64tuaRwAz9/tKYPvaCCQRqG1pO8TA9c7AYBDA+8Hz
         UXRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U8TFZBYQQ8h+X8k7K87tVsmzs5n8iJUVUvNZgNZrxs4=;
        b=JzB8JpANfWLNJEYiQT7yZwqL9mIU/YuUtwPmnfLCsKtoXLhBGBeWTHmhi0UjZ0O0Ty
         ZVFk+i8F1yb81QTJUgRYlp+DBUORimtu0vSK6dqJYkWrOahgW9MDAoWB7LHSdTTt6zTX
         a5yYBVEi260B/0rVrDTpDhHJ5PWkGkLtC7IfQcT9EJEeG+zi8lwHrFo12xandfbDVtyG
         ejeIz1df7p0Y3uzJqcVC69BG3h02tBnn5I7Xw9bTUuAY6j4x05wAdoyTtbuUXfKX3KhL
         WClk+ucueFBxbhVOeBKQKMxtaI2hn7irNuAIZztq3e9ToqnQ41hVG0xbMgH4ajl4o2Dm
         46OQ==
X-Gm-Message-State: ANoB5pkiicDkijF6LL2wxUUc9XzoQPij5S28jHIFbjzki0Z1BGlWYToQ
        1PmiyMtbHqc8TC7PtSywNmYJ0do5VdRMvVsL
X-Google-Smtp-Source: AA0mqf7RxqsWUQqSlYa3+K7EwcAjsWHNBxu3O0TTfsKlwP6t4VmIQGkloL6SQ7b+Z2FT1eNe1/zOtA==
X-Received: by 2002:a05:6830:6505:b0:66c:fb5b:4904 with SMTP id cm5-20020a056830650500b0066cfb5b4904mr41790155otb.237.1670260556998;
        Mon, 05 Dec 2022 09:15:56 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:56de:4ea4:df4e:f7cc])
        by smtp.gmail.com with ESMTPSA id l17-20020a056871069100b0013d6d924995sm9429225oao.19.2022.12.05.09.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 09:15:56 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuniyu@amazon.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v3 0/4] net/sched: retpoline wrappers for tc
Date:   Mon,  5 Dec 2022 14:15:16 -0300
Message-Id: <20221205171520.1731689-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In tc all qdics, classifiers and actions can be compiled as modules.
This results today in indirect calls in all transitions in the tc hierarchy.
Due to CONFIG_RETPOLINE, CPUs with mitigations=on might pay an extra cost on
indirect calls. For newer Intel cpus with IBRS the extra cost is
nonexistent, but AMD Zen cpus and older x86 cpus still go through the
retpoline thunk.

Known built-in symbols can be optimized into direct calls, thus
avoiding the retpoline thunk. So far, tc has not been leveraging this
build information and leaving out a performance optimization for some
CPUs. In this series we wire up 'tcf_classify()' and 'tcf_action_exec()'
with direct calls when known modules are compiled as built-in as an
opt-in optimization.

We measured these changes in one AMD Zen 4 cpu (Retpoline), one AMD Zen 3 cpu (Retpoline),
one Intel 10th Gen CPU (IBRS), one Intel 3rd Gen cpu (Retpoline) and one
Intel Xeon CPU (IBRS) using pktgen with 64b udp packets. Our test setup is a
dummy device with clsact and matchall in a kernel compiled with every
tc module as built-in.  We observed a 3-8% speed up on the retpoline CPUs,
when going through 1 tc filter, and a 60-100% speed up when going through 100 filters.
For the IBRS cpus we observed a 1-2% degradation in both scenarios, we believe
the extra branches checks introduced a small overhead therefore we added
a Kconfig option to make these changes opt-in even in CONFIG_RETPOLINE kernels.

1 filter:
CPU        | before (pps) | after (pps) | diff
R9 7950X   | 5914980      | 6380227     | +7.8%
R9 5950X   | 4237838      | 4412241     | +4.1%
R9 5950X   | 4265287      | 4413757     | +3.4%   [*]
i5-3337U   | 1580565      | 1682406     | +6.4%
i5-10210U  | 3006074      | 3006857     | +0.0%
i5-10210U  | 3160245      | 3179945     | +0.6%   [*]
Xeon 6230R | 3196906      | 3197059     | +0.0%
Xeon 6230R | 3190392      | 3196153     | +0.01%  [*]

100 filters:
CPU        | before (pps) | after (pps) | diff
R9 7950X   | 373598       | 820396      | +119.59%
R9 5950X   | 313469       | 633303      | +102.03%
R9 5950X   | 313797       | 633150      | +101.77% [*]
i5-3337U   | 127454       | 211210      | +65.71%
i5-10210U  | 389259       | 381765      | -1.9%
i5-10210U  | 408812       | 412730      | +0.9%    [*]
Xeon 6230R | 415420       | 406612      | -2.1%
Xeon 6230R | 416705       | 405869      | -2.6%    [*]

[*] In these tests we ran pktgen with clone set to 1000.

On the 7950x system we also tested the impact of filters if iteration order
placement varied, first by compiling a kernel with the filter under test being
the first one in the static iteration and then repeating it with being last (of 15 classifiers existing today).
We saw a difference of +0.5-1% in pps between being the first in the iteration vs being the last.
Therefore we order the classifiers and actions according to relevance per our current thinking.

v2->v3:
- Address suggestions by Jakub, Paolo and Eric.
- Dropped RFC tag (I forgot to add it on v2).

v1->v2:
- Fix build errors found by the bots
- Address Kuniyuki Iwashima suggestions

Pedro Tammela (4):
  net/sched: move struct action_ops definition out of ifdef
  net/sched: add retpoline wrapper for tc
  net/sched: avoid indirect act functions on retpoline kernels
  net/sched: avoid indirect classify functions on retpoline kernels

 include/net/act_api.h      |  10 +-
 include/net/tc_wrapper.h   | 226 +++++++++++++++++++++++++++++++++++++
 net/sched/Kconfig          |  13 +++
 net/sched/act_api.c        |   3 +-
 net/sched/act_bpf.c        |   6 +-
 net/sched/act_connmark.c   |   6 +-
 net/sched/act_csum.c       |   6 +-
 net/sched/act_ct.c         |   5 +-
 net/sched/act_ctinfo.c     |   6 +-
 net/sched/act_gact.c       |   6 +-
 net/sched/act_gate.c       |   6 +-
 net/sched/act_ife.c        |   6 +-
 net/sched/act_ipt.c        |   6 +-
 net/sched/act_mirred.c     |   6 +-
 net/sched/act_mpls.c       |   6 +-
 net/sched/act_nat.c        |   7 +-
 net/sched/act_pedit.c      |   6 +-
 net/sched/act_police.c     |   6 +-
 net/sched/act_sample.c     |   6 +-
 net/sched/act_simple.c     |   6 +-
 net/sched/act_skbedit.c    |   6 +-
 net/sched/act_skbmod.c     |   6 +-
 net/sched/act_tunnel_key.c |   6 +-
 net/sched/act_vlan.c       |   6 +-
 net/sched/cls_api.c        |   3 +-
 net/sched/cls_basic.c      |   6 +-
 net/sched/cls_bpf.c        |   6 +-
 net/sched/cls_cgroup.c     |   6 +-
 net/sched/cls_flow.c       |   6 +-
 net/sched/cls_flower.c     |   6 +-
 net/sched/cls_fw.c         |   6 +-
 net/sched/cls_matchall.c   |   6 +-
 net/sched/cls_route.c      |   6 +-
 net/sched/cls_rsvp.c       |   2 +
 net/sched/cls_rsvp.h       |   6 +-
 net/sched/cls_rsvp6.c      |   2 +
 net/sched/cls_tcindex.c    |   7 +-
 net/sched/cls_u32.c        |   6 +-
 38 files changed, 374 insertions(+), 72 deletions(-)
 create mode 100644 include/net/tc_wrapper.h

-- 
2.34.1

