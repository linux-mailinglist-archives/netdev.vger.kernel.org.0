Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C0F2AA7BB
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 20:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbgKGTj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 14:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgKGTjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 14:39:25 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92CDC0613CF;
        Sat,  7 Nov 2020 11:39:25 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id n15so4671950otl.8;
        Sat, 07 Nov 2020 11:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=umgOFSJKneTT4hVW+UHmrcTgF4QshDfext+F1vpx4yE=;
        b=LkwWflC+i3Igs2WVRfu3mUGpxMJBmKVzpAfGt6qd43ryZRsh+IMOIE5z8KO8o14uzs
         d1NDfluOkv1g05OooeqUXqWiF2R8flp8v5quuFFWe2O6gTgCMq9UwXy6au/N+Q/BbPNr
         4vaCveIR5kveXvHcS2QFM+fkM4TLIg2cRBZykweCr8J2wWbiHiKIl2Ue+IK/CyD9Tko7
         F3FBz29Z0JaKSmUjEAFlg03k3F4XEM5UwW5BFVfGWoFh8DXMjU50RW9UayjZ+9/WIKxr
         U9ZJAdk7dnf04XHe7sQ3opEmwJngzCcw+l/Ac0uemG1qMNadxwsTxKdxyh9tXX88+xiB
         kqbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=umgOFSJKneTT4hVW+UHmrcTgF4QshDfext+F1vpx4yE=;
        b=prxkPYozxBqMdp6wPcjOz6Elajy1pkwRNY0wXNNNu7l5UeT7GniaCzpgxw//iBoGh6
         WAv68aZDZCfNgtS0S0PeeUGgErUVOeuKksnTJs+m1ko/2aJ923nojEg8x4SX+/1Cc3Dc
         pC33QF+yLAfo+R3MDKAboIL2CemYud5/JqsHdwklvrbiL3Sr7y6LsphnJSU/nXzkZKbW
         pjxr7a6RDw7Bm/BQvNGMalEyfqjf4y6ZV88faxX6bCIANaV4HAAcHN4Xqx5iOMsglM41
         7v1oiAPUveh/qOpW/GeQ2QxiukaHTHjimVCGAAGimb6fCVJXeTwHzOXJqlAxGlfSpvc8
         O8ZA==
X-Gm-Message-State: AOAM533QRKh8dnI4svy0dQ00GydBQrdEivzAAUUA0+H+L+ixHXyE7l+Q
        fzpJRAnULlCmuNoxRiqurro=
X-Google-Smtp-Source: ABdhPJwgVaKh1amjH7VOKqvRSrC2rBZkR8YlWq223q35VVOWaHrnBEGBlrvSrJMMWsCZr/t1uOHY2g==
X-Received: by 2002:a05:6830:1e70:: with SMTP id m16mr5098361otr.51.1604777965014;
        Sat, 07 Nov 2020 11:39:25 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 85sm1252346oie.30.2020.11.07.11.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 11:39:24 -0800 (PST)
Subject: [bpf PATCH 5/5] bpf,
 sockmap: Avoid failures from skb_to_sgvec when skb has frag_list
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, jakub@cloudflare.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Sat, 07 Nov 2020 11:39:12 -0800
Message-ID: <160477795249.608263.2308084426369232846.stgit@john-XPS-13-9370>
In-Reply-To: <160477770483.608263.6057216691957042088.stgit@john-XPS-13-9370>
References: <160477770483.608263.6057216691957042088.stgit@john-XPS-13-9370>
User-Agent: StGit/0.23-36-gc01b
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When skb has a frag_list its possible for skb_to_sgvec() to fail. This
happens when the scatterlist has fewer elements to store pages than would
be needed for the initial skb plus any of its frags.

This case appears rare, but is possible when running an RX parser/verdict
programs exposed to the internet. Currently, when this happens we throw
an error, break the pipe, and kfree the msg. This effectively breaks the
application or forces it to do a retry.

Lets catch this case and handle it by doing an skb_linearize() on any
skb we receive with frags. At this point skb_to_sgvec should not fail
because the failing conditions would require frags to be in place.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 59c36a672256..b2063ae5648c 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -425,9 +425,16 @@ static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
 					struct sock *sk,
 					struct sk_msg *msg)
 {
-	int num_sge = skb_to_sgvec(skb, msg->sg.data, 0, skb->len);
-	int copied;
+	int num_sge, copied;
 
+	/* skb linearize may fail with ENOMEM, but lets simply try again
+	 * later if this happens. Under memory pressure we don't want to
+	 * drop the skb. We need to linearize the skb so that the mapping
+	 * in skb_to_sgvec can not error.
+	 */
+	if (skb_linearize(skb))
+		return -EAGAIN;
+	num_sge = skb_to_sgvec(skb, msg->sg.data, 0, skb->len);
 	if (unlikely(num_sge < 0)) {
 		kfree(msg);
 		return num_sge;


