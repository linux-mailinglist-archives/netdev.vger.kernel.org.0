Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC282B5447
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 23:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729558AbgKPW1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 17:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728982AbgKPW1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 17:27:41 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CABC0613CF;
        Mon, 16 Nov 2020 14:27:41 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id o3so7057644ota.8;
        Mon, 16 Nov 2020 14:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=RlgwZdM9GqzQMPHs9fItBuNKu4uwvnR753hh212yRb8=;
        b=qHxuHFsqfqQlp4t05X5lllKzsesPm9qQj4+fuO/OWl+fKVTQxBiF1H33ofs6kAyDxR
         Zl2OfaEp0l5L64Fs1dLQ5SDWictwOUGUSy6UsU2oXI7RoWl1Y9hjH6lzV+bYif+sDORX
         qRYGIEtoG1aea/JF2X9imQe4ZzTifdPfF1GNDUMer3czvWJp1seSc51uCKFpDS2/31+4
         YHFpRAPIxBDjX78eGR1Pr9aZmUV/gYC+o/qKL2gBLiHGyiZgrWN1kHjWKxOpqZz8C5cD
         tLjsX1Y5UYhxCXpsqAO16uoKhGSutgdRH2lxkmzwnwS4YUv3IAfV777Vjg+3zoXq8n//
         T1bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=RlgwZdM9GqzQMPHs9fItBuNKu4uwvnR753hh212yRb8=;
        b=Gy36X+EPVRBEIJv3UeMyIUEmkZi6iHftHT7Z7GD4uhlwyU6rKVag7o3yPhUyZ2sBcO
         3Y7fOSe/p8TvEvD7lN6LD5IYLJ+YUxb00tQem0r5RY95DrkH5xU2YioxpZisrZSN94pW
         YF+QuSe5JyFrnyW4dFXm8OKO0veTHPWnVnm//uESgCySiw+KUAPo/sm/0zjS9z4XjnsL
         6VHB54MMvPv86AR1We9DoAzuXcLIzzRiuUkbC4v3RFJVE5tAy5i0Ah5JIuStpDAax0Jm
         4NCw4lfACAsmfcSjJ5DOGwKp+9Iw8WdU5LBQKValcyQOTqnk3KXJb8lI7vzemPxGOZqB
         OYEw==
X-Gm-Message-State: AOAM5300F/+VZaTb2ouTuP/Qerp6egvO5Okouf3JPjh6rhJr9qKk1iLw
        5geH2xzeC6eeqhckkopRLHzYRZwz2i9oNw==
X-Google-Smtp-Source: ABdhPJzfPJWK9CG2wB4aCbLlOjmMCdx3Of3c+dNfKbIJ81HD91DEfXGZxqDIo8ymbfSRZNJkCTPudA==
X-Received: by 2002:a9d:19cf:: with SMTP id k73mr1064290otk.360.1605565660190;
        Mon, 16 Nov 2020 14:27:40 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 68sm5171333oto.71.2020.11.16.14.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 14:27:35 -0800 (PST)
Subject: [bpf PATCH v3 0/6] sockmap fixes 
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, ast@kernel.org, daniel@iogearbox.net
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Mon, 16 Nov 2020 14:27:23 -0800
Message-ID: <160556562395.73229.12161576665124541961.stgit@john-XPS-13-9370>
User-Agent: StGit/0.23-36-gc01b
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This includes fixes for sockmap found after I started running skmsg and
verdict programs on systems that I use daily. To date with attached
series I've been running for multiple weeks without seeing any issues
on systems doing calls, mail, movies, etc.

Also I started running packetdrill and after this series last remaining
fix needed is to handle MSG_EOR correctly. This will come as a follow
up to this, but because we use sendpage to pass pages into TCP stack
we need to enable TCP side some.

v3:
 - Simplify patch5 as suggested by Jakub
v2:
 - Added patch3 to use truesize in sk_rmem_schedule (Daniel)
 - cleaned up some small nits... goto and extra set of brackets (Daniel)


---

John Fastabend (6):
      bpf, sockmap: fix partial copy_page_to_iter so progress can still be made
      bpf, sockmap: Ensure SO_RCVBUF memory is observed on ingress redirect
      bpf, sockmap: Use truesize with sk_rmem_schedule()
      bpf, sockmap: Avoid returning unneeded EAGAIN when redirecting to self
      bpf, sockmap: Handle memory acct if skb_verdict prog redirects to self
      bpf, sockmap: Avoid failures from skb_to_sgvec when skb has frag_list


 net/core/skmsg.c   | 87 +++++++++++++++++++++++++++++++++++++++-------
 net/ipv4/tcp_bpf.c |  3 +-
 2 files changed, 76 insertions(+), 14 deletions(-)

--
Signature

