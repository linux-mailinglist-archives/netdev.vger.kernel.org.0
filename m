Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6793828F613
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 17:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388461AbgJOPqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 11:46:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22900 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731105AbgJOPqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 11:46:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602776812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=5M26P0L/YGQdFvGc6undAIPcG+PqLaKsMBaJzgIC8aQ=;
        b=KXWLkB4SxySAEJ/WXOudXkE/BmkyzLC7JGPQGYRkK4P8lFWDvi0iWvMfBipnr3tYUwxk+W
        4eyhOsUS0dnAqHiSLw8gbLWTkFOOF3U/hmgG+XgoQ2b3vs1Xo61XrruOjz+8N6OR5ZN4RT
        bCqNI7a0EH1+yxJU4C0Z9TQAZAgwOOk=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-ufZBrqmOPTGDZeQdY5kiSQ-1; Thu, 15 Oct 2020 11:46:51 -0400
X-MC-Unique: ufZBrqmOPTGDZeQdY5kiSQ-1
Received: by mail-ua1-f69.google.com with SMTP id m11so173379uah.6
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 08:46:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=5M26P0L/YGQdFvGc6undAIPcG+PqLaKsMBaJzgIC8aQ=;
        b=Hi0niQwVowTm5G+68X7P3aZwFxlCEVtWJHT0fbetbc7b1NDwrS/Y1mZJnHhk3tBldT
         ISNv9r38xEYbXgQSdy3J976hXEJWRJV0yL/S5Lkuth8VSDPfgD9S4SS2Xi7OK6AJBfZ4
         gf6Lr4FH3cJM9XDbQzUnxx4JKn4CpREPDzC4Mydi1gvZB1MfpdruoqVhYQ1eiUL+7B6n
         A12CvUrei7oHPnV7eZeeGbPJcJeQT8dmnfGlV4TPNxW3a3VkAMlNofzTzhq2d7eHWdGn
         oLOi0OQQNqS71zvl+LHGU4X4/+vgG4hBrhIpQoQnhqDrKTO70YGLNAZVQ0tFqZvFParB
         oTSw==
X-Gm-Message-State: AOAM532ba7MhyT8HChih6QeD6YjdHZm8wfbjZK5NMXFM1bsLl2T1ob0o
        Fr2tQV6E/qH2DjgIT1d6XMuHznhEvFD8gOf5mXS6Harswc44U1DeDXRvlAUcG2tqEY4rqQqO6eZ
        TXrHRTpCBbrXlDM9b
X-Received: by 2002:a1f:17d7:: with SMTP id 206mr1052470vkx.11.1602776810557;
        Thu, 15 Oct 2020 08:46:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwI0VuDWzILusDGXZ0tIAks8AjGvRmJ1jOE0El4f1vWL77qpiC/BUAAmmIC7nWeq7Gxg+5ieA==
X-Received: by 2002:a1f:17d7:: with SMTP id 206mr1052440vkx.11.1602776809959;
        Thu, 15 Oct 2020 08:46:49 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id l6sm439779vkk.56.2020.10.15.08.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 08:46:49 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9BFDD1837DD; Thu, 15 Oct 2020 17:46:47 +0200 (CEST)
Subject: [PATCH RFC bpf-next 0/2] bpf: Rework bpf_redirect_neigh() to allow
 supplying nexthop from caller
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Thu, 15 Oct 2020 17:46:47 +0200
Message-ID: <160277680746.157904.8726318184090980429.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on previous discussion[0], we determined that it would be beneficial to
rework bpf_redirect_neigh() so the caller can supply the nexthop information
(e.g., from a previous call to bpf_fib_lookup()). This way, the two helpers can
be combined without incurring a second FIB lookup to find the nexthop, and
bpf_fib_lookup() becomes usable even if no nexthop entry currently exists.

This patch (and accompanying selftest update) accomplishes this by way of an
optional paramter to bpf_redirect_neigh(). This is an API change, and so should
really be merged into the bpf tree to be part of the 5.10 cycle; however, since
bpf-next has not yet been merged into bpf, I'm sending this as an RFC against
bpf-next for discussion, and will repost against bpf once that merge happens
(Daniel, unless you have a better way of doing this, of course).

-Toke

[0] https://lore.kernel.org/bpf/393e17fc-d187-3a8d-2f0d-a627c7c63fca@iogearbox.net/

---

Toke Høiland-Jørgensen (2):
      bpf_redirect_neigh: Support supplying the nexthop as a helper parameter
      selftests: Update test_tc_neigh to use the modified bpf_redirect_neigh()


 .../selftests/bpf/progs/test_tc_neigh.c       | 83 ++++++++++++++++---
 .../testing/selftests/bpf/test_tc_redirect.sh |  8 +-
 2 files changed, 78 insertions(+), 13 deletions(-)

