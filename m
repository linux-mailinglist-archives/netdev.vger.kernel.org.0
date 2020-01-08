Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B89B134EA3
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgAHVOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:14:02 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:43177 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726836AbgAHVOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 16:14:01 -0500
Received: by mail-io1-f65.google.com with SMTP id n21so4751518ioo.10;
        Wed, 08 Jan 2020 13:14:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=N2nei71pLCshVif89pL4b+GrQ+Q+f/VZ0XknSaj1BN0=;
        b=ez6aX3yyaaksdnA4FAOTaEvUTItH9zIdPty6cNHH2Xf11KlR4HWcCS7kWc3I8hfXLi
         ov5If4LCW1uSl5/QdnikfzJV/8TnVapsj7wR2gvWWxphV3eLoM8cOwZ4+liwF1XSB1rd
         cIzEC7PLafyG5zS87ERC+b6WqlpEKeBXYQq2EsCrFqatcLW0blab8seG72N6TXAHJPkl
         WtNh8ZKBRGw45EC6EI7Ic1LP+ciI/U8BoAZfkDoOB9mWrzuOtvQ21I7FYTqptWONkQnX
         NKxDOWLCCXbtxLChfSIzIT6RBq5hUf5BP1nm5jRkNHYcxXgG08o5kQOfgRZ6u3CGCqKc
         zArQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=N2nei71pLCshVif89pL4b+GrQ+Q+f/VZ0XknSaj1BN0=;
        b=ZJNKWGen6xpo2Np+OgpmWjx/FNsa+7NzIZodDgaKTTWFIFKcaljgRlocik1OVT5l96
         FSWcvmDplws7pphYxcRhuHX8B5OI4CnKwytXIERGhcnyexhJIatLYcllaN0ovI2feTBu
         UzSQ56Kj/ToxmKhc5pXp43RckSXB3hMy61UX8m2qo1CTbduyD3TsFfnq/yfm8F2eTLfH
         vNPkT0vDfdXRYz9KVJ+/TSvmtQ5zXRnwTqCETbzYk3JkXaoiI7f7TrA1wMZYsz30bt2U
         q1ggs5spOYapNOqS7/h/M7KKDuP1+gcNqBm5jmL+Ik47zwfRKVG6n6Nw3tOfpHN0uue4
         9u1g==
X-Gm-Message-State: APjAAAVMpaujfaOysxoKCJ6aThC+3/+xNsgfydJZV75dPGOhFj+J7alE
        +w372wMOg/u6BKUQL8PSg64sjEkn
X-Google-Smtp-Source: APXvYqzUC0QkZytrHLGqYoPfJG/poQmibjx9lixbwxTIndUV98ugaU3zC1UrDRvSGF+rDa60c1aBhg==
X-Received: by 2002:a6b:6f07:: with SMTP id k7mr4931133ioc.174.1578518040980;
        Wed, 08 Jan 2020 13:14:00 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 81sm1314393ilx.40.2020.01.08.13.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 13:14:00 -0800 (PST)
Subject: [bpf PATCH 0/9] Fixes for sockmap/tls from more complex BPF progs
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Date:   Wed, 08 Jan 2020 21:13:49 +0000
Message-ID: <157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To date our usage of sockmap/tls has been fairly simple, the BPF programs
did only well-defined pop, push, pull and apply/cork operations.

Now that we started to push more complex programs into sockmap we uncovered
a series of issues addressed here. Further OpenSSL3.0 version should be
released soon with kTLS support so its important to get any remaining
issues on BPF and kTLS support resolved.

Additionally, I have a patch under development to allow sockmap to be
enabled/disabled at runtime for Cilium endpoints. This allows us to stress
the map insert/delete with kTLS more than previously where Cilium only
added the socket to the map when it entered ESTABLISHED state and never
touched it from the control path side again relying on the sockets own
close() hook to remove it. The selftests are great but a cluster
full of thousands of sockets finds these things fairly quickly.

To test I have a set of test cases in test_sockmap.c that expose these
issues. Once we get fixes here merged and in bpf-next I'll submit the
tests to bpf-next tree to ensure we don't regress again. Also I've run
these patches in the Cilium CI with OpenSSL (master branch) this will
run tools such as netperf, ab, wrk2, curl, etc. to get a broad set of
testing.

I'm aware of two more issues that we are working to resolve in another
couple (probably two) patches. First we see an auth tag corruption in
kTLS when sending small 1byte chunks under stress. I've not pinned this
down yet. But, guessing because its under 1B stress tests it must be
some error path being triggered. And second we need to ensure BPF RX
programs are not skipped when kTLS ULP is loaded. This breaks some of
the sockmap selftests when running with kTLS. I'll send a follow up
for this.

Any review/comments appreciated. Thanks!

---

John Fastabend (9):
      bpf: sockmap/tls, during free we may call tcp_bpf_unhash() in loop
      bpf: sockmap, ensure sock lock held during tear down
      bpf: sockmap/tls, push write_space updates through ulp updates
      bpf: sockmap, skmsg helper overestimates push, pull, and pop bounds
      bpf: sockmap/tls, msg_push_data may leave end mark in place
      bpf: sockmap/tls, tls_sw can create a plaintext buf > encrypt buf
      bpf: sockmap/tls, skmsg can have wrapped skmsg that needs extra chaining
      bpf: sockmap/tls, tls_push_record can not handle zero length skmsg
      bpf: sockmap/tls, fix pop data with SK_DROP return code


 include/linux/skmsg.h |   13 +++++++++----
 include/net/tcp.h     |    6 ++++--
 net/core/filter.c     |   11 ++++++-----
 net/core/skmsg.c      |    2 ++
 net/core/sock_map.c   |    7 ++++++-
 net/ipv4/tcp_bpf.c    |    5 +----
 net/ipv4/tcp_ulp.c    |    6 ++++--
 net/tls/tls_main.c    |   10 +++++++---
 net/tls/tls_sw.c      |   34 ++++++++++++++++++++++++++++++----
 9 files changed, 69 insertions(+), 25 deletions(-)

--
Signature
