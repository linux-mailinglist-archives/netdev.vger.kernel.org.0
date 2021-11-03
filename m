Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89BE44449BC
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 21:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbhKCUur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 16:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbhKCUuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 16:50:46 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC17C061714;
        Wed,  3 Nov 2021 13:48:09 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id s14so3923774ilv.10;
        Wed, 03 Nov 2021 13:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IsEm7YwJ2jCN77f8FH/qoi3xCimi77N04M1MEq6g5zo=;
        b=VjEsHs2KoDE3PcvNYWg9ZU9q+FmpHmb6FhRJv622Imf5CFXD9qIhufjISnV1wd/hjU
         xbQo9Y8bZT0pRoGz7HWM+55cINGrO1/PbGjSZoHSXtg/hEwQDiqPU37wv/ka0gibrS42
         ZkL8yaII2ylsL7EmQg92eWdbmp2wRm08v5tTZfVbJ32dUInsFN/zMc0RF01vTakND12+
         ustIskSbxcGo6D/KihGEC6dm0EqXPYwIkM+YsNLgVnld4d8OF1TOfBeEUI7Ztmd5j4F/
         2B//iZlMOqEX+74w7zqIpxc/itWeZpmng7KwWCtQnUrA5dymkH4D779lbmvlk68eQMt4
         n4ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IsEm7YwJ2jCN77f8FH/qoi3xCimi77N04M1MEq6g5zo=;
        b=l3cmvmHz8nXuOzvCfF9tIU7fYpAxnu9h8RJ6MoKwixtWkviA2QWp7avHq8cIsIUxxH
         9mggwO8mcanIvnEYxIAPNooLOLWUtvtPiIgq2Bei0vFtYt7137csTFusSpCv0Z63SCvk
         yMCyaSL+AR5c6its+0v/4d3hM3jYaTTBJdiQR1qfoxsiPlo48NbDe5IidZB2KOKygHjO
         NsedXZbAxqMwNh5Jw3lbWzZdFiysaIBoBdvktaMD/VdEgl+vBZ5sbM2tGEJrPi9QsheQ
         JGCyASkw24v5RLE6iTrfNJWneQVjASU6xuTKyonsfsTCUavRR/AExY+FWz7f1efTUULR
         WIpw==
X-Gm-Message-State: AOAM5314ocRwS1EYNDUr5o7S9mlpmZf7xqOGSFZLqBh2r3/J+xnJ5KmM
        uq6AUzUdhF/ad1s8lQDLbqDDdY9sbLMZCw==
X-Google-Smtp-Source: ABdhPJz3iTLVp4wa42AjPV6nn6noOPUC8e5Gkj6Rc+8PP4vcsJwIT111T8onPtN8GFnTcnn0yrM98Q==
X-Received: by 2002:a92:cda5:: with SMTP id g5mr8656063ild.97.1635972488917;
        Wed, 03 Nov 2021 13:48:08 -0700 (PDT)
Received: from john.lan ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id y11sm1507612ior.4.2021.11.03.13.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 13:48:08 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     daniel@iogearbox.net, joamaki@gmail.com, xiyou.wangcong@gmail.com,
        jakub@cloudflare.com, john.fastabend@gmail.com
Subject: [PATCH bpf v2 2/5] bpf, sockmap: Remove unhash handler for BPF sockmap usage
Date:   Wed,  3 Nov 2021 13:47:33 -0700
Message-Id: <20211103204736.248403-3-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211103204736.248403-1-john.fastabend@gmail.com>
References: <20211103204736.248403-1-john.fastabend@gmail.com>
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
Tested-by: Jussi Maki <joamaki@gmail.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/ipv4/tcp_bpf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 5f4d6f45d87f..246f725b78c9 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -475,7 +475,6 @@ static void tcp_bpf_rebuild_protos(struct proto prot[TCP_BPF_NUM_CFGS],
 				   struct proto *base)
 {
 	prot[TCP_BPF_BASE]			= *base;
-	prot[TCP_BPF_BASE].unhash		= sock_map_unhash;
 	prot[TCP_BPF_BASE].close		= sock_map_close;
 	prot[TCP_BPF_BASE].recvmsg		= tcp_bpf_recvmsg;
 	prot[TCP_BPF_BASE].sock_is_readable	= sk_msg_is_readable;
-- 
2.33.0

