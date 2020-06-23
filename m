Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D0A204F20
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 12:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732259AbgFWKfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 06:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732076AbgFWKfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 06:35:04 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9465AC061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 03:35:02 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id i27so22794476ljb.12
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 03:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ckNZyFhILcN6tTy3sbdLcXRbhqu7O7I6+l82jLAf/oo=;
        b=gcLnIZwmr46yO7C7Aw8/ee5lRzLULbGM2uebrVAIdF/WaITv2S6PkqlN8HPJN7F8fk
         KlVEzPOK4FhzfWA7TCTNqdSvVMPujpG0zMLbSQlVm1/jL8uULEifZnww0qRHh8MpPWe2
         TQgl0WrDjPkhJayWRcvGb4SdJY9R1ZAJYCfa0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ckNZyFhILcN6tTy3sbdLcXRbhqu7O7I6+l82jLAf/oo=;
        b=rgTGG9tQe5JKPQ7nYqulUZ0qcQyS2eMjNryxD3H0Db3FWD5Ro+sU2Ndv9IhTdpdhrD
         coFK4TeDZtOgmpoQQ6PAC3lEcu5CkKaa3y1b2aBbIVHuyUA1hhd49WZ455hsM6HXKnBH
         XKdsieXUn1cQdTQbvR5S469jT/tOLpKXE1JzOy521mlfQTsSA0aSXGZPwVyLSoag70yx
         0Rwu/vGnVLS1K8CuEoBCqL/llEVA7wWE0U4CPTnT/llajXxkAJPsSE0SCOLMcsrZTuXU
         S2L/YIy6IiT7xZur9D/p8plKSj0Rjj4tnLDnErmLM1sf9uzeyTNqMfxNY5RXV49RcGOT
         0KQw==
X-Gm-Message-State: AOAM531dDm6jK9AGpg/t2/3yzQXAPb2CdkVQqHNwQFBBV1zjvanSbvnH
        MoHoec94xD4XdkrndL2RebITMA==
X-Google-Smtp-Source: ABdhPJxD7hsOiiFUc+D1OLjeylemR8lyswAtHxnKLHjYnJUMSYZkyKFIXWfnI/I7ZiePV8v4vmkhQA==
X-Received: by 2002:a2e:b814:: with SMTP id u20mr11807935ljo.261.1592908500718;
        Tue, 23 Jun 2020 03:35:00 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id w20sm2871301lfe.66.2020.06.23.03.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 03:35:00 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: [PATCH bpf-next v2 0/3] bpf, netns: Prepare for multi-prog attachment
Date:   Tue, 23 Jun 2020 12:34:56 +0200
Message-Id: <20200623103459.697774-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set prepares ground for link-based multi-prog attachment for
future netns attach types, with BPF_SK_LOOKUP attach type in mind [0].

Two changes are needed in order to attach and run a series of BPF programs:

  1) an bpf_prog_array of programs to run (patch #2), and
  2) a list of attached links to keep track of attachments (patch #3).

I've been using these patches with the next iteration of BPF socket lookup
hook patches, and saw that they are self-contained and can be split out to
ease the review burden.

Nothing changes for BPF flow_dissector. That is at most one prog can be
attached.

Thanks,
-jkbs

[0] https://lore.kernel.org/bpf/20200511185218.1422406-1-jakub@cloudflare.com/

Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Stanislav Fomichev <sdf@google.com>

v1 -> v2:

- Show with a (void) cast that bpf_prog_array_replace_item() return value
  is ignored on purpose. (Andrii)
- Explain why bpf-cgroup cannot replace programs in bpf_prog_array based
  on bpf_prog pointer comparison in patch #2 description. (Andrii)

Jakub Sitnicki (3):
  flow_dissector: Pull BPF program assignment up to bpf-netns
  bpf, netns: Keep attached programs in bpf_prog_array
  bpf, netns: Keep a list of attached bpf_link's

 include/linux/bpf.h          |   3 +
 include/net/flow_dissector.h |   3 +-
 include/net/netns/bpf.h      |   7 +-
 kernel/bpf/core.c            |  20 +++-
 kernel/bpf/net_namespace.c   | 189 +++++++++++++++++++++++++----------
 net/core/flow_dissector.c    |  34 +++----
 6 files changed, 173 insertions(+), 83 deletions(-)

-- 
2.25.4

