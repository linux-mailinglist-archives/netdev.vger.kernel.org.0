Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A61E9715D5
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 12:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388013AbfGWKPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 06:15:45 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:54015 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729916AbfGWKPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 06:15:45 -0400
Received: by mail-pg1-f202.google.com with SMTP id t18so15705846pgu.20
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 03:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=xmjcnxOIy3vC3x78cRcn02eU5r4Uf6FShc4XTyftpqk=;
        b=kuFkkcSujUiIq0s947Lw9Tp0ec8BAF5566m0Ea5cfeB/kY3rwjxSFeJyHZGFaJ/8jZ
         5uIhAkorhU9vf5OfIp8TRHWKOQyI0rv5qvqrp7zYSzdj2PKAUGUXhCWRueXs1HPiJ9iQ
         eDoEiGXY9Nltl94wcz3szBNq00KfdQOo+UXyUKuexIltf0c79pL4pzPoUgjLKY4VHUw/
         LSN6aGyum4M7l896bP5Bv6+NTIwygxuV/HtIi+p8EtVnmKk85wxKmbkb6k3TKJzcBggH
         qvCFqZg4AD1u4bSdWBT03jc4l0yIhv8vWy5tXx2HE1yOneRcVrqB+h6Pihpn5VqHP/Rr
         N1gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=xmjcnxOIy3vC3x78cRcn02eU5r4Uf6FShc4XTyftpqk=;
        b=uKKlzk3zXUwzSSVVf/mIrhSFANhPo0D7KZRp3O39W8CPXxcJouxi9+/nNhwX9HUjQJ
         0rkDlkoLTbeHSI/TZe/rxAmT2GsoUqKPpdBAUcbIRpvIemhwlttO33ZBNf4HPbotE9wC
         djrhWMeW/DAj5frArBjDODnGK0cK1zC29/lL6GVLeUqE02RrkJK3UDxe/WJjztqry7D+
         1bFVcrR9wYk0ZfSmnRAVTDMizzeucqWbUgnkjWC+7XyqWAdSlEZ9pCh6QFGacDN/jYba
         iPURWYC0OaD4O3LArY+J6KeTTclGqocNuCAMUb0kF1VwjxYG21dHWdzoi06wemts61DA
         eUjA==
X-Gm-Message-State: APjAAAVjAtkbuqbPLeQpLpv4FSMngNU2gnanYtBivIc6p5gb27zZUJlY
        Zqp+uoUBlnUPNVTvKsOMJ9OBVHbzqf5v7g==
X-Google-Smtp-Source: APXvYqyycRwBbp/QjzvXuQlhNuUoExeaBwHusb/AbMx69B05jNj0CjW0YEIbJFu8/zEjMvZPfelfsyyqujSnuw==
X-Received: by 2002:a63:c0d:: with SMTP id b13mr75567383pgl.420.1563876944086;
 Tue, 23 Jul 2019 03:15:44 -0700 (PDT)
Date:   Tue, 23 Jul 2019 03:15:36 -0700
Message-Id: <20190723101538.136328-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
Subject: [PATCH bpf 0/2] bpf: gso_segs fixes
From:   Eric Dumazet <edumazet@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stanislav Fomichev <sdf@google.com>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First patch changes the kernel, second patch
adds a new test.

Note that other patches might be needed to take
care of similar issues in sock_ops_convert_ctx_access()
and SOCK_OPS_GET_FIELD()

Eric Dumazet (2):
  bpf: fix access to skb_shared_info->gso_segs
  selftests/bpf: add another gso_segs access

 net/core/filter.c                              |  6 +++---
 tools/testing/selftests/bpf/verifier/ctx_skb.c | 11 +++++++++++
 2 files changed, 14 insertions(+), 3 deletions(-)

-- 
2.22.0.657.g960e92d24f-goog

