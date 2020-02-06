Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 128A315405C
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 09:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgBFIfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 03:35:32 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35182 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgBFIfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 03:35:32 -0500
Received: by mail-pf1-f194.google.com with SMTP id y73so2738613pfg.2;
        Thu, 06 Feb 2020 00:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=EjKQV8mnfXuPq6ZNft4LufVyA8xUS7YjJsmHdUEjjxE=;
        b=Ui4d2VylsSDMa0HmtdmryLKpwY/jMjyqBWP7JHGy9nc4mwo0cw1MlebFGuKl9tHrQD
         WEJNHswdbN4sSvuBbczVp43LmaFqKgCXw4FzGN6XykdQNU6QwmbIT2qPUflesWq/cfrp
         Wu60XTiWsY5C+MNhFKtP1S+aBneC06K1jZdCsIoYwW0rboDjFzDU93SElZrNflJT2asm
         FtNIyXKpVISJAEizSe098Cg73YWMSPSJR1ZAaE7zK4zIYtxPhUPPJfJzmGPU0UHZkb1C
         N5wvsYiYHFCLTESXADs4Cp37aiosoXyrsov3cvuHGdaPgKDo8e10V+yWeaujX7uL+o5u
         zykA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=EjKQV8mnfXuPq6ZNft4LufVyA8xUS7YjJsmHdUEjjxE=;
        b=k0AXehbr5QfR21djz3qFjv4V4/aVbJt0kU//2yXx6uZzeNx2VLoYJ9TqP+l6Vboa8a
         AOXH6g6mLXb8QtwiVCisYxr6EvSXN+k+iGSuRMhg4Gf3H57wrQXGuypDq7GrvjpfFEaW
         0+rlDbgA5IgI9ZQBOZwCrofEb1b5p2mRbl1zkMG5Pb5bu539O37FgRUrO3q6OEte2Ds1
         a7L17wVLUKKUs7kpnxEa/CrVsFkdxLkcsOH/CmsHV8pu0dI2YsANdRBmESjNoypUHeD3
         ZfVzCZXZJUJj/JGtP0gAI++XeMrWVJR0lKlFumTjA8XT1c75PgfcMyVtQYCqjP6EpNeL
         ZRrw==
X-Gm-Message-State: APjAAAWTXCLg0NhR0XtDF+9vN1D7dfC3p6zpAvQI+VCokuxGTduX4LTF
        Lb2jsSYVnYpwTx1o9nVXSKOCuh7OQnAJFg==
X-Google-Smtp-Source: APXvYqzLcloPNmsd0xMTfBjl4a3B8lfa37HS98GrX0fWyI9AaycYzZK0svad181tB2CoqvOKVw5LPA==
X-Received: by 2002:aa7:94a4:: with SMTP id a4mr2556837pfl.178.1580978131269;
        Thu, 06 Feb 2020 00:35:31 -0800 (PST)
Received: from localhost.localdomain ([124.156.165.26])
        by smtp.gmail.com with ESMTPSA id 5sm2292070pfx.163.2020.02.06.00.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 00:35:30 -0800 (PST)
From:   Lingpeng Chen <forrest0579@gmail.com>
To:     bpf <bpf@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Lingpeng Chen <forrest0579@gmail.com>
Subject: [PATCH bpf-next 0/2] bpf: Add sock ops get netns helpers
Date:   Thu,  6 Feb 2020 16:35:13 +0800
Message-Id: <20200206083515.10334-1-forrest0579@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently 5-tuple(sip+dip+sport+dport+proto) can't identify a
uniq connection because there may be multi net namespace.
For example, there may be a chance that netns a and netns b all
listen on 127.0.0.1:8080 and the client with same port 40782
connect to them. Without netns number, sock ops program
can't distinguish them.
Using bpf_sock_ops_get_netns helpers to get current connection
netns number to distinguish connections.

Lingpeng Chen (2):
  bpf: Add sock ops get netns helpers
  bpf: Sync uapi bpf.h to tools/

 include/uapi/linux/bpf.h       |  8 +++++++-
 net/core/filter.c              | 18 ++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  8 +++++++-
 3 files changed, 32 insertions(+), 2 deletions(-)


-- 
2.17.1

