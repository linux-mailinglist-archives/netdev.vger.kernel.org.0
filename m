Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 894B0429773
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 21:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234630AbhJKTTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 15:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234623AbhJKTTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 15:19:12 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C27DC06161C;
        Mon, 11 Oct 2021 12:17:11 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id f15so325610ilu.7;
        Mon, 11 Oct 2021 12:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mVRL1IBxtkGo2VfKL3uYUEStH8UIb/WtSaGcxktycbY=;
        b=Gr/46YvzPqB99wQ5NL5Qc1wl4ZFALf/1FZH+DYTNDidjDRI0VzOmYmBKPfImXwFuhC
         A2QfAgG7ADSfSKo/ELJRSF5pPCUbXLhuLHml3Hru2FKhjsz8fpTeQS36xpK/rLsZxNkC
         6qIXe6KKsJctvd6/jdvQ7aYBWvSPGG05mzBEAM9sGphItWpcyFRQs3X9OCYl6w02KC2W
         mA8hchqvlnymycZcr0Vnx/A5mNnatBvzdgIG+2dQdDzr/pu74cJYfTdhpWzY0H0gfZJS
         C03w4bWG1p+d6W+Deq+ImsYLXsd7rX9iqkevLX2i792SmY5Ls9JOkOf4B0+Sy50DdNb8
         M6PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mVRL1IBxtkGo2VfKL3uYUEStH8UIb/WtSaGcxktycbY=;
        b=pRu9Hp+vJBzU0U9nqoYTncucEBHR4yyyTlOLmJg+JYP/WDBHriQw1s2pQj5bneaEct
         QxkzYFwfoRekP5b8nMhvCtDmW8bHgO0Qlr4FhPxuo2JuT31iExipHDzfCXm7edXcaH1g
         Qqpuq9tAevk9bAoBJqUgW5h0/KT7EeEhr/4Q/eOT+CYxoqAk7INZv4N+y5bPoDJ2hYjA
         oU6p4xVEGWqbtWP+gt6z+KcZ93+9kNDGevGhxrnk3lOwPJO6g/aFPnlyg2ECNQjvEXkE
         PG3U67E6gR/26tMJZMC1BJgIZK30r1oDrw20qk+36+7jNktAjGpBqDSsP5wrZ+EBEKb0
         D60A==
X-Gm-Message-State: AOAM530G4JQC22coeLBgPUDW3ydn7QUR6LJ0q6Qp8gRXkPvvEqJ9UFQ8
        jEfhbbCKIkLpUE6v14UN/9tgguEFaQFbiQ==
X-Google-Smtp-Source: ABdhPJzbY6MYLqm250q6zZe4XdbBqRsZ32GoXWbykvyJJ3KfsxOVgWU7sSgYeFXriT53zQJGUNJG5Q==
X-Received: by 2002:a92:c24c:: with SMTP id k12mr14260642ilo.52.1633979830243;
        Mon, 11 Oct 2021 12:17:10 -0700 (PDT)
Received: from john.lan ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id n12sm4460077ilj.8.2021.10.11.12.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 12:17:09 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     john.fastabend@gmail.com, daniel@iogearbox.net, joamaki@gmail.com,
        xiyou.wangcong@gmail.com
Subject: [PATCH bpf 1/4] bpf, sockmap: Remove unhash handler for BPF sockmap usage
Date:   Mon, 11 Oct 2021 12:16:44 -0700
Message-Id: <20211011191647.418704-2-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011191647.418704-1-john.fastabend@gmail.com>
References: <20211011191647.418704-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We do not need to handle unhash from BPF side we can simply wait for the
close to happen. The original concern was a socket could transition from
ESTABLISHED state to a new state while the BPF hook was still attached.
But, we convinced ourself this is no longer possible and we also
improved BPF sockmap to handle listen sockets so this is no longer a
problem.

More importantly though there are cases where unhash is called when data is
in the receive queue. The BPF unhash logic will flush this data which is
wrong. To be correct it should keep the data in the receive queue and allow
a receiving application to continue reading the data. This may happen when
tcp_abort is received for example. Instead of complicating the logic in
unhash simply moving all this to tcp_close hook solves this.

Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF path")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/ipv4/tcp_bpf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index d3e9386b493e..35dcfb04f53d 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -476,7 +476,6 @@ static void tcp_bpf_rebuild_protos(struct proto prot[TCP_BPF_NUM_CFGS],
 				   struct proto *base)
 {
 	prot[TCP_BPF_BASE]			= *base;
-	prot[TCP_BPF_BASE].unhash		= sock_map_unhash;
 	prot[TCP_BPF_BASE].close		= sock_map_close;
 	prot[TCP_BPF_BASE].recvmsg		= tcp_bpf_recvmsg;
 	prot[TCP_BPF_BASE].stream_memory_read	= tcp_bpf_stream_read;
-- 
2.33.0

