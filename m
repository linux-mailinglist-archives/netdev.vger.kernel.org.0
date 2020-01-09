Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1B421358A6
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 12:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730301AbgAIL6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 06:58:45 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34668 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730251AbgAIL6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 06:58:45 -0500
Received: by mail-wm1-f66.google.com with SMTP id w5so1885337wmi.1
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 03:58:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XW/jU4nMv4mGFekrAe/bVdVaRHEifMOWCDSe/Rg3qfU=;
        b=rpbyJddq33B9qvSn4dhdc1kg2jDsQ5NECfImsJP0BmRVxX8YUmk+GZcwqJ/9GgwemW
         SkhY18OP1SxlTsHKFBzzBjzzArXq/PvYW5botlr9MrTX37wAcoZbEusNvNDDoddttatK
         20KjUtmfCziPSocV4nL54W0IvoVY7BP+gDu/8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XW/jU4nMv4mGFekrAe/bVdVaRHEifMOWCDSe/Rg3qfU=;
        b=jqHpqHEMTf46gR1fYaw7cQgJZege5SF4KMNL2fAfKOD3pkOClTZAMjJmOWsf4fFrpm
         rLtAahYgW48sRKPeM1OB6y8356SSdR1D7suIneHDjneV3qVvx517IuIQ7nnBinN1ulId
         fKHIuIxeR1sto4YldSWwiVM4ebs6bRlQPCkTY1khiCVw/MSaCVngpozEuhqEGHHISG3K
         vf61fN/lIBMmVVJCn1FtxoYgluCD/O6ykv68dLBCxLJ+w1v68qNjxtEU7WB86tHOR3Rn
         w8yKS679B7eeU37O9vT4FcDL49CDr3SS6B4mS4G4OdOCk1Xokiazj2AKRsg9NzfmuUIC
         LxEQ==
X-Gm-Message-State: APjAAAVh8z+M1Gxiw8/uNaTT9Eb3oY/loZE5R6+4unN693/HFuvR1tpL
        vyYO31wCVIV5GohEdzFZ95o1Eg==
X-Google-Smtp-Source: APXvYqyBBcuvlKP3rGxkVcWLSllnjwn3aZuUrL+BdEqPQQcw/OUbBeFbOxs/AISfrFWwOfHd6Su6cg==
X-Received: by 2002:a7b:cc14:: with SMTP id f20mr4618431wmh.58.1578571123550;
        Thu, 09 Jan 2020 03:58:43 -0800 (PST)
Received: from localhost.localdomain ([2a06:98c0:1000:8250:cd2c:908b:e15b:9937])
        by smtp.gmail.com with ESMTPSA id z124sm2728120wmc.20.2020.01.09.03.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 03:58:42 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Joe Stringer <joe@isovalent.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kernel-team@cloudflare.com, edumazet@google.com
Subject: [PATCH bpf 0/1] Fix memory leak in helpers dealing with sockets
Date:   Thu,  9 Jan 2020 11:57:47 +0000
Message-Id: <20200109115749.12283-1-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While rolling out a new BPF based TC classifier I hit a memory leak, which
manifests in large numbers of request and time wait sockets not being released.

The root cause is that the current BPF helpers dealing with sockets are naive:
they assume that sk->sk_flags is always valid. struct request_sock and
struct inet_timewait_sock break this.

I've fixed this up by adding a helper that checks sk_state in addition to sk_flags.
The solution is a bit clumsy: it encapsulates details of struct sock in BPF.
It would probably be nicer to have a sock_gen_put + SOCK_RCU_FREE function exposed
in sock.h, but that might be too big a change for backports.

Thoughts?

Lorenz Bauer (1):
  net: bpf: don't leak time wait and request sockets

 net/core/filter.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

-- 
2.20.1

