Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99D7A555D9
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 19:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731449AbfFYR1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 13:27:25 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:54899 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731307AbfFYR1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 13:27:24 -0400
Received: by mail-pl1-f201.google.com with SMTP id u10so9559609plq.21
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 10:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=hTJIxoyoSbZZ+l0CCDRQzN4eQIToWW0/kgz0Q6JFjf4=;
        b=MhcjcAs3LEBD+vkQbdD9TWhi3dSZjKM7pPmbUKoDowcFMsmHVmyLRh1fNOIBfflDAX
         CIzNUb96xZm7BILKsyS4feJ9qPRHLbikO0Aazvo95ekSx51HHld4RtuyCrpAz9bNYP34
         lt/arVszR6L3Q8Zk+95EG2nmSRBxuNEgVIEjAxlFZxN7Oryd3qA0FMcZzqCqBIDcEudw
         KKk/0nw1x+fXv9Qx4pf39ELAnC8KYlh04TAPCMnHOH8Q278mHQ6fXkUT/IPicg+8rTWR
         in+g31w2EvhnAz/+/cOb5J6464aCVd75M3KBw80dmqjy8GQmmPGjmgHQA7xcycbcqPcA
         C21Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=hTJIxoyoSbZZ+l0CCDRQzN4eQIToWW0/kgz0Q6JFjf4=;
        b=DgDaHgkM+FMMTdjlvU3afUrZx92vESsus6HPzJT0L4bNdRd+qmofxtKDhnasW997q/
         7Pcf3/qXiNk7U8arEoucVW8xmV2yqy803eQEBVqs2bmyQztaTgJxfC8koXHk/eejmI1f
         WGEJIoqJD1TSudSLI4zm4UG4af7TMqnGzIV6ry4nKR2WtSMQ7h8WLlZ+xBOkRUNIVUbl
         6zeziq758rtuqJdgsZy3gQudw3gSEeTGQfOljdAp/gFkVjp2QFFLQt4BPuocLxWPR+gV
         yeKT+aeAxVDiF6NhRRz7cfJ30Xf6m0QPlZ1cqXb2MtahOCpaAetJ2hJHF2AIDPI934pR
         ytVw==
X-Gm-Message-State: APjAAAUddAEv6imK9oJDCXC5O15wmq7v34P1TpFYSC3EJXaDOfSiowHf
        e8vX0oT7cba/AxrFvMJEMlgOUZ+tOML6GcW5
X-Google-Smtp-Source: APXvYqzS171nDYh6J6BwTctWj9MK+TT5o8Ua6zQVGFYAkmN/ikFB54mK/+hw9BGKX8GAIwsEV9thskkpDDY4C5XG
X-Received: by 2002:a63:1462:: with SMTP id 34mr40179941pgu.417.1561483643508;
 Tue, 25 Jun 2019 10:27:23 -0700 (PDT)
Date:   Tue, 25 Jun 2019 10:27:15 -0700
Message-Id: <20190625172717.158613-1-allanzhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v4 0/2] bpf: Allow bpf_skb_event_output for more prog types
From:   allanzhang <allanzhang@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     allanzhang <allanzhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Software event output is only enabled by a few prog types right now (TC,
LWT out, XDP, sockops). Many other skb based prog types need
bpf_skb_event_output to produce software event.

Added socket_filter, cg_skb, sk_skb prog types to generate sw event.

allanzhang (2):
  bpf: Allow bpf_skb_event_output for a few prog types
  bpf: Add selftests for bpf_perf_event_output

 net/core/filter.c                             |  6 ++
 tools/testing/selftests/bpf/test_verifier.c   | 33 ++++++-
 .../selftests/bpf/verifier/event_output.c     | 94 +++++++++++++++++++
 3 files changed, 132 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/verifier/event_output.c

-- 
2.22.0.410.gd8fdbe21b5-goog

