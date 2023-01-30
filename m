Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292C3681BD3
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 21:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjA3UwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 15:52:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjA3UwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 15:52:09 -0500
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA81B367EF
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 12:51:53 -0800 (PST)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-1636eae256cso12488740fac.0
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 12:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/IB0oD7j6geI//ci/tiy0+ABQ2OwEHH45LjNSZJhYPQ=;
        b=FW9lX520twsG5jJ0zxY/6IfRSq59UShuLTRn6bR70IoKtt6Z2M9AolzsdfSyyO7VJu
         sz4NftgVz8UjuAx3a23Vjvj+W0ifh5QRTJ1A2GHJS4Sb3UUptQitnPLKz1TPrNmpfa/M
         qzl/mGjGG9imOoiuIERZMB4ehIEHte4+bgEB4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/IB0oD7j6geI//ci/tiy0+ABQ2OwEHH45LjNSZJhYPQ=;
        b=liDE+XH0i2OO94uh5XVpxJsD+/s/mdxNEiVkBfytele8hKynrpnUpbQTmBU8IXfVoT
         Ar3ab+MMjoj/O4qT097/qx9bRZP0b0I02HYlGrMFpvQifgva2oW2z21HR+A6rPIHHPeh
         LqNXRFGdFGdmKWZbF9hrDzQjOL+OClPz71qszj3UXSy3sJzmtRkCXObpGS+OhaSlbE8V
         E/NRC6GJ3kAnpj/sZvkk9mHdr4cKHyYe5itw1blV8rNiX/SMSYANgrqXWny5DKfvoDXO
         J+8oAVI/WgLyukqK+vWowuM96TxAbvBtgzNxLv54MB4UoebsJs+wHNrefyimTSaiStsm
         ndsw==
X-Gm-Message-State: AO0yUKXbOdTek87wwzkQkWWGnornPK7p6u+NheQ3S5b1MTRSaqe+FjDx
        ytmCfhtLI3cF8EOuisrrEco2kPRZHUFe4M5J1oA=
X-Google-Smtp-Source: AK7set8cdQ9A4QfoqBd5ctwoFW8HQtfRnJVCnRQ8c19mPc4aApku3LxRhuIDZRejZuRpZgON5tN4Dg==
X-Received: by 2002:a05:6870:82aa:b0:163:419b:3a90 with SMTP id q42-20020a05687082aa00b00163419b3a90mr6700740oae.17.1675111912755;
        Mon, 30 Jan 2023 12:51:52 -0800 (PST)
Received: from debian (108-213-68-242.lightspeed.sntcca.sbcglobal.net. [108.213.68.242])
        by smtp.gmail.com with ESMTPSA id hj15-20020a056870c90f00b001631c5f7404sm5675094oab.22.2023.01.30.12.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 12:51:52 -0800 (PST)
Date:   Mon, 30 Jan 2023 12:51:48 -0800
From:   Yan Zhai <yan@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        davem@davemloft.net, asml.silence@gmail.com, imagedong@tencent.com,
        keescook@chromium.org, jbenc@redhat.com, richardbgobert@gmail.com,
        willemb@google.com, steffen.klassert@secunet.com,
        daniel@iogearbox.net, linux-kernel@vger.kernel.org
Subject: [PATCH] net: fix NULL pointer in skb_segment_list
Message-ID: <Y9gt5EUizK1UImEP@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 3a1296a38d0c ("net: Support GRO/GSO fraglist chaining.")
introduced UDP listifyed GRO. The segmentation relies on frag_list being
untouched when passing through the network stack. This assumption can be
broken sometimes, where frag_list itself gets pulled into linear area,
leaving frag_list being NULL. When this happens it can trigger
following NULL pointer dereference, and panic the kernel. Reverse the
test condition should fix it.

[19185.577801][    C1] BUG: kernel NULL pointer dereference, address:
...
[19185.663775][    C1] RIP: 0010:skb_segment_list+0x1cc/0x390
...
[19185.834644][    C1] Call Trace:
[19185.841730][    C1]  <TASK>
[19185.848563][    C1]  __udp_gso_segment+0x33e/0x510
[19185.857370][    C1]  inet_gso_segment+0x15b/0x3e0
[19185.866059][    C1]  skb_mac_gso_segment+0x97/0x110
[19185.874939][    C1]  __skb_gso_segment+0xb2/0x160
[19185.883646][    C1]  udp_queue_rcv_skb+0xc3/0x1d0
[19185.892319][    C1]  udp_unicast_rcv_skb+0x75/0x90
[19185.900979][    C1]  ip_protocol_deliver_rcu+0xd2/0x200
[19185.910003][    C1]  ip_local_deliver_finish+0x44/0x60
[19185.918757][    C1]  __netif_receive_skb_one_core+0x8b/0xa0
[19185.927834][    C1]  process_backlog+0x88/0x130
[19185.935840][    C1]  __napi_poll+0x27/0x150
[19185.943447][    C1]  net_rx_action+0x27e/0x5f0
[19185.951331][    C1]  ? mlx5_cq_tasklet_cb+0x70/0x160 [mlx5_core]
[19185.960848][    C1]  __do_softirq+0xbc/0x25d
[19185.968607][    C1]  irq_exit_rcu+0x83/0xb0
[19185.976247][    C1]  common_interrupt+0x43/0xa0
[19185.984235][    C1]  asm_common_interrupt+0x22/0x40
...
[19186.094106][    C1]  </TASK>

Fixes: 3a1296a38d0c ("net: Support GRO/GSO fraglist chaining.")
Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Yan Zhai <yan@cloudflare.com>
---
 net/core/skbuff.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 4a0eb5593275..a31ff4d83ecc 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4100,7 +4100,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 
 	skb_shinfo(skb)->frag_list = NULL;
 
-	do {
+	while (list_skb) {
 		nskb = list_skb;
 		list_skb = list_skb->next;
 
@@ -4146,8 +4146,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 		if (skb_needs_linearize(nskb, features) &&
 		    __skb_linearize(nskb))
 			goto err_linearize;
-
-	} while (list_skb);
+	}
 
 	skb->truesize = skb->truesize - delta_truesize;
 	skb->data_len = skb->data_len - delta_len;
-- 
2.39.0

