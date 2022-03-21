Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B12954E20D5
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 08:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344664AbiCUHCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 03:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241003AbiCUHCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 03:02:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172FCBEF;
        Mon, 21 Mar 2022 00:01:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A4AC60F82;
        Mon, 21 Mar 2022 07:01:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8CAC340E8;
        Mon, 21 Mar 2022 07:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647846079;
        bh=1LD0xuwdOgPcNOgMJ6zSDIel0EcKiTIJVshsWznG2Vo=;
        h=From:To:Cc:Subject:Date:From;
        b=MYqrlJWlPTbX+CGGOlGTeJe47Qu7Cvt+Kyn00BhVb4ZRxCT2YGTq82JsWaN5cw7Z6
         ogKy3atkbFXVs/E0rNVAx8UFYAlxa0aAIfTajVuZaHcfQWUhkklpCoIbi4Q+aKjPao
         /OW2QdC0Iw/5KjShuSF2WF8P9HY9+Dk4qZDmuoiUTj5b6cZKpMHC7s5EpkxVZjJBLk
         3VPm3VoFSw2GGTqSgkWVugpXqFJIaJJ7c/wcXARn0TiMKMvKKhrP/fifTgk5DOpvxv
         iZ760rtV8rW4DHLI7HXCHbN7AYf2sSOafDle7U8ZK6fRDHYslmxphWbE14o4ar3a+5
         oc4OwXj535j4w==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH bpf-next 0/2] bpf: Fix kprobe_multi return probe backtrace
Date:   Mon, 21 Mar 2022 08:01:11 +0100
Message-Id: <20220321070113.1449167-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
Andrii reported that backtraces from kprobe_multi program attached
as return probes are not complete and showing just initial entry [1].

Sending the fix together with bpf_get_func_ip inline revert, which is
no longer suitable.

thanks,
jirka


---
[1] https://lore.kernel.org/bpf/CAEf4BzZDDqK24rSKwXNp7XL3ErGD4bZa1M6c_c4EvDSt3jrZcg@mail.gmail.com/T/#m8d1301c0ea0892ddf9dc6fba57a57b8cf11b8c51

Jiri Olsa (2):
      Revert "bpf: Add support to inline bpf_get_func_ip helper on x86"
      bpf: Fix kprobe_multi return probe backtrace

 kernel/bpf/verifier.c    | 21 +--------------------
 kernel/trace/bpf_trace.c | 68 +++++++++++++++++++++++++++++++++++++-------------------------------
 2 files changed, 38 insertions(+), 51 deletions(-)
