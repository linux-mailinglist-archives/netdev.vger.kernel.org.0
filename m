Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA1345ADAA
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 21:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbhKWU7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 15:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhKWU7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 15:59:24 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0688C061574;
        Tue, 23 Nov 2021 12:56:15 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id b11so71455pld.12;
        Tue, 23 Nov 2021 12:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YIZZn3EfhIV4B8xywTZD34ebhvmRwyiaGIZ1+xNz9a8=;
        b=LB9MQdPfmfkpwuRRwEQ5fkzkuIN7FC6dTbCli9EiFEDqNfRnZz3uy/Rw+xkHmli205
         ynAJBxt+TEjXwWLum4sa+altcBeGKtlqqyYFwqiOfnFjxY/y3sf6+AYh6sb21JxIiOx7
         IVhFtHPf3PuGPT1dei9EzZ93nuPkgeg9jvdb2FiD+qDQWSpLokP5o2tG0ymGcz/6CTS7
         K9bIdPPtQ/iujiHwcK0D1/YGnFeKlexjHa+pCd2ZC3HZAKyhZYz4ZkvjmHwWlar5kL8s
         vAphQQYXovMy5qXuPR+tuuimNrg+8N2QTaqobHuMrz6w7xEHOOL8Bskk+nleDBRPQI8m
         /gOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YIZZn3EfhIV4B8xywTZD34ebhvmRwyiaGIZ1+xNz9a8=;
        b=Sw9zWMPyRcBsL6PdO/s8GkgFLOv6lpmpqKz4uxR+nd4i4vaBEDav5/nql7cJfP4XKX
         WWKaMqcA4BkwFa3NF4gKamXWCAqWekByv/88f1bF4+wEbRRSi+VOKqU4Zk4N4Cj0n7sg
         z1eODMNAcgc4ifD6y6D3lU2ECtaLmn97sczzJ2LhsWcvovgDEASP79kYjfEEv1rwxa+X
         N3yMZz4JUyJloxWWVODDCpnQeZxahFQehgeAzmi6U3b7xLNLdcM21vhJEkEQMm7VCM/X
         fNO5LnpKKWoz6h30PgxPAKAjROUGG8gAy0g5q+wru06VeKR3NNL3wpdsOE/yL1JLFMmk
         c1AQ==
X-Gm-Message-State: AOAM530XwNgKdBS23lWwFgpq2tkfQmwCNmI6WNlvMs5cwlFaY1WfEOAl
        3pIbOtJoV0P7fMSkF8BhxcU=
X-Google-Smtp-Source: ABdhPJx5vcos3QJeg5Fpvk38X+NWRxGmKKN/JhM+yuCozW6rdCcVM8MOWOVSocKhtwdfWNY+AU0JvA==
X-Received: by 2002:a17:90b:4d8f:: with SMTP id oj15mr6807940pjb.127.1637700975394;
        Tue, 23 Nov 2021 12:56:15 -0800 (PST)
Received: from athina.mtv.corp.google.com ([2620:15c:211:200:cd70:5ac2:9066:1bb8])
        by smtp.gmail.com with ESMTPSA id j7sm13526031pfu.164.2021.11.23.12.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 12:56:14 -0800 (PST)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH bpf-next] bpf: allow readonly direct path access for skfilter
Date:   Tue, 23 Nov 2021 12:56:07 -0800
Message-Id: <20211123205607.452497-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

skfilter bpf programs can read the packet directly via llvm.bpf.load.byte/
/half/word which are 8/16/32-bit primitive bpf instructions and thus
behave basically as well as DPA reads.  But there is no 64-bit equivalent,
due to the support for the equivalent 64-bit bpf opcode never having been
added (unclear why, there was a patch posted).
DPA uses a slightly different mechanism, so doesn't suffer this limitation.

Using 64-bit reads, 128-bit ipv6 address comparisons can be done in just
2 steps, instead of the 4 steps needed with llvm.bpf.word.

This should hopefully allow simpler (less instructions, and possibly less
logic and maybe even less jumps) programs.  Less jumps may also mean vastly
faster bpf verifier times (it can be exponential in the number of jumps...).

This can be particularly important when trying to do something like scan
a netlink message for a pattern (2000 iteration loop) to decide whether
a message should be dropped, or delivered to userspace (thus waking it up).

I'm requiring CAP_NET_ADMIN because I'm not sure of the security
implications...

Tested: only build tested
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 kernel/bpf/verifier.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 331b170d9fcc..0c2e25fb9844 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3258,6 +3258,11 @@ static bool may_access_direct_pkt_data(struct bpf_verifier_env *env,
 	enum bpf_prog_type prog_type = resolve_prog_type(env->prog);
 
 	switch (prog_type) {
+	case BPF_PROG_TYPE_SOCKET_FILTER:
+		if (meta || !capable(CAP_NET_ADMIN))
+			return false;
+		fallthrough;
+
 	/* Program types only with direct read access go here! */
 	case BPF_PROG_TYPE_LWT_IN:
 	case BPF_PROG_TYPE_LWT_OUT:
-- 
2.34.0.rc2.393.gf8c9666880-goog

