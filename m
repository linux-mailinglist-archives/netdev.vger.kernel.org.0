Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFA13E06F3
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 17:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731398AbfJVPEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 11:04:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30157 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727152AbfJVPEw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 11:04:52 -0400
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com [209.85.208.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A09BA81F31
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 15:04:51 +0000 (UTC)
Received: by mail-lj1-f198.google.com with SMTP id i18so3024183ljg.14
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 08:04:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=nOZYBTRbnWWUf8nkBC3PdwUXqUStXdiFP0yu4lVeiS8=;
        b=NX4Fb+XEybnVT9MztTV+oHE0xtZUl2IEtyg0jLQZYU4wbxXafuDw3ogY9RCjgK3x0v
         XydZWqbXZXcN3eQu6UoFGXS7g6NueibSrT7BvgNuOzLZ6dQgAIOtAv3Nk02CrwjD15FM
         SN5l35yy5vVSxLjkoRuLrPcO1HaBgBoR2k88hFBQ6YlMoZgmCz8MAm9gPEskqYz4E853
         pPdaJeyQJh7I5lGcQsC/Ng1ZgOpWCiDYdLsvZ9ZZNHrsS3fWqUxgJ6PoPdWxh7V5Ujp3
         GY+yFtDT1KlvN+83uQLjRbnlNLqfNOhWrPjFZrLlHlhhUwKnHNCvN9+mC/0LtrReb/MY
         Bvog==
X-Gm-Message-State: APjAAAXudjXpb9MYKqeKigi4L0sUQWW1JheGw1dYeOATYj0yWtegIvDK
        j7PqYwfbocm4NbYm0mN1OJUu/EADqoUD/735/Y4M/Uy6Ia/Mb7ezqZDqEGG0mfLnXnU4auhNa4H
        hxnWQaBvqKBOg9xtN
X-Received: by 2002:ac2:43a8:: with SMTP id t8mr19235972lfl.134.1571756690195;
        Tue, 22 Oct 2019 08:04:50 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzHggRhi4w6xX8wnGy3Fl6vl+1YXeTL+m6n0xYVKV0a3ETqdyUdRYVpZ61jrG0x2ibhiBk+VA==
X-Received: by 2002:ac2:43a8:: with SMTP id t8mr19235955lfl.134.1571756689954;
        Tue, 22 Oct 2019 08:04:49 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id 27sm1723504ljv.82.2019.10.22.08.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 08:04:48 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C2EAE1804B1; Tue, 22 Oct 2019 17:04:47 +0200 (CEST)
Subject: [PATCH bpf-next 0/3] libbpf: Support pinning of maps using 'pinning'
 BTF attribute
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Tue, 22 Oct 2019 17:04:47 +0200
Message-ID: <157175668770.112621.17344362302386223623.stgit@toke.dk>
User-Agent: StGit/0.20
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support to libbpf for reading 'pinning' settings from BTF-based
map definitions. It introduces new variants of the bpf_object__(un)pin_maps()
functions which accepts options with the new options struct definition style.
These allow the caller to configure pinning options to use both old-style
"forced pinning" where all defined maps are pinned, and the new pinning that is
based on the BTF attribute.

The actual semantics of the pinning is similar to what iproute2 allows today,
and the eventual goal is to move the iproute2 implementation to be based on
libbpf and the functions introduced in this series. 

A follow-up series will add support to libbpf for automatic map pinning on
program load (with optional reuse of existing maps if they are already pinned).
However, the functions introduced in this series can be used standalone, and so
I decided to break things up to ease review.

---

Toke Høiland-Jørgensen (3):
      libbpf: Store map pin path in struct bpf_map
      libbpf: Support configurable pinning of maps from BTF annotations
      libbpf: Add pin option to automount BPF filesystem before pinning


 tools/lib/bpf/bpf_helpers.h |    8 ++
 tools/lib/bpf/libbpf.c      |  189 ++++++++++++++++++++++++++++++++++++-------
 tools/lib/bpf/libbpf.h      |   36 ++++++++
 tools/lib/bpf/libbpf.map    |    4 +
 4 files changed, 208 insertions(+), 29 deletions(-)

