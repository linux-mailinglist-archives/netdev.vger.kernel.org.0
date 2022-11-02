Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E444D616BF6
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 19:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbiKBSUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 14:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbiKBSUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 14:20:34 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6482F662
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 11:20:29 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id g127so13606103ybg.8
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 11:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dXAcaDDFzjoLhHRGcpbdPaqgQzXEOT+W5IONiMWb5hk=;
        b=dcRTl7dyVOUaj/g6ge8SSMiG1ESSTCQ25hhjNASac687d5SVlIUZKi79KYHWqlwac4
         wEcgk6DCbF0Jxmfw4wMSSdQF+JlcJgBHhesAKEHA+yRGC0uW3qvSqYv/g5UtEEECLmT4
         IIVQqE9SNSDxLh6nD2uX/hGLqzWJLTo99EeXDu9QPASCbwCWKq4oUkEywbXOm431YBXR
         2zsTQciA7ofOV0ibUqiGl+af2jB9QlYdyoHUbb/3QDK5py/DMt8fwPfEol26G6cMkUcc
         ///w3XMnbZC0FInd69NZ4w5RLXlRbq7dJaX7qpob2rcbMP9UPG4hEVM97lxt0JhUBjYe
         4PQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dXAcaDDFzjoLhHRGcpbdPaqgQzXEOT+W5IONiMWb5hk=;
        b=gmaM1fTEvnc6mGh0xiiVUW1Uz4j+SHIdvAupt41xr/z7W9M9xSNo7EyO5sV/zjviU6
         7xb5RU99tMg17bQH68phuByvLyp6gL7KIfTmQEBPM24a898EosV+W69UhntGj3FJ7SSI
         YoA8Ip/DwfQhRtjlRByzxoO1ij/ngAO1Q1CLbQ8ZcxLBSxSCLHFwMLDlt/NJj/kpgsmG
         sJ+K9uFNNonjNjxDULSEweW8SxWThh/yB3XgANpXNQJvb/uTGfh0PsDLpG18Q/K/UU8m
         0g6b2AEsDHbTk/A+dEkDpD+ij3ZoCaddQyXDHPCw0xTVtEZLyqyO3ORdTrpEpYFbagbB
         UiAg==
X-Gm-Message-State: ACrzQf290kIPAtu1EYowJmxWrL8Hpoo7KSTr/ZNEPXfFbxRlvWAhu3oN
        zZHa2sVCKzxX8ETwFJIM9/go6h6yqS27Lwye0B71Mg==
X-Google-Smtp-Source: AMsMyM6opRWbm677nMf3zkRiQVD5zIi2GzxNTVuD+EPNbG+FiyureeHFIDWRyJCDVNIL5qvNlgQxZ70uWX9vJomaNlk=
X-Received: by 2002:a25:d64e:0:b0:6cb:7faa:af94 with SMTP id
 n75-20020a25d64e000000b006cb7faaaf94mr25177311ybg.36.1667413227920; Wed, 02
 Nov 2022 11:20:27 -0700 (PDT)
MIME-Version: 1.0
References: <20221024051744.GA48642@debian> <20221101085153.12ccae1c@kernel.org>
 <CAJLv34RKj6u_7EZwYWiNujC-R4nxKHJ24DVYqydgHPy88NqMPA@mail.gmail.com>
In-Reply-To: <CAJLv34RKj6u_7EZwYWiNujC-R4nxKHJ24DVYqydgHPy88NqMPA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 2 Nov 2022 11:20:16 -0700
Message-ID: <CANn89iJeg+wQUdi7i=EbSS7Z__j+LEakPab3oKD7_Rr4hmV_xg@mail.gmail.com>
Subject: Re: [PATCH net-next] gro: avoid checking for a failed search
To:     Richard Gobert <richardbgobert@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        pabeni@redhat.com, lixiaoyan@google.com, alexanderduyck@fb.com,
        steffen.klassert@secunet.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 2, 2022 at 9:46 AM Richard Gobert <richardbgobert@gmail.com> wrote:
>
> > Why does it matter? You see a measurable perf win?
>
> In the common case, we will exit the loop with a break,
> so this patch eliminates an unnecessary check.
>
> On some architectures this optimization might be done
> automatically by the compiler, but I think it will be better
> to make it explicit here. Although on x86 this optimization
> happens automatically, I noticed that on my build target
> (ARM/GCC) this does change the binary.

What about taking this as an opportunity to reduce the indentation
level by one tab ?

Untested patch:

diff --git a/net/core/gro.c b/net/core/gro.c
index bc9451743307bc380cca96ae6995aa0a3b83d185..ddfe92c9a5e869d241931b72d6b3426a0e858468
100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -491,43 +491,44 @@ static enum gro_result dev_gro_receive(struct
napi_struct *napi, struct sk_buff
        list_for_each_entry_rcu(ptype, head, list) {
                if (ptype->type != type || !ptype->callbacks.gro_receive)
                        continue;
+               goto found_ptype;
+       }
+       rcu_read_unlock();
+       goto normal;

-               skb_set_network_header(skb, skb_gro_offset(skb));
-               skb_reset_mac_len(skb);
-               BUILD_BUG_ON(sizeof_field(struct napi_gro_cb, zeroed)
!= sizeof(u32));
-               BUILD_BUG_ON(!IS_ALIGNED(offsetof(struct napi_gro_cb, zeroed),
-                                        sizeof(u32))); /* Avoid slow
unaligned acc */
-               *(u32 *)&NAPI_GRO_CB(skb)->zeroed = 0;
-               NAPI_GRO_CB(skb)->flush = skb_has_frag_list(skb);
-               NAPI_GRO_CB(skb)->is_atomic = 1;
-               NAPI_GRO_CB(skb)->count = 1;
-               if (unlikely(skb_is_gso(skb))) {
-                       NAPI_GRO_CB(skb)->count = skb_shinfo(skb)->gso_segs;
-                       /* Only support TCP at the moment. */
-                       if (!skb_is_gso_tcp(skb))
-                               NAPI_GRO_CB(skb)->flush = 1;
-               }
-
-               /* Setup for GRO checksum validation */
-               switch (skb->ip_summed) {
-               case CHECKSUM_COMPLETE:
-                       NAPI_GRO_CB(skb)->csum = skb->csum;
-                       NAPI_GRO_CB(skb)->csum_valid = 1;
-                       break;
-               case CHECKSUM_UNNECESSARY:
-                       NAPI_GRO_CB(skb)->csum_cnt = skb->csum_level + 1;
-                       break;
-               }
+found_ptype:
+       skb_set_network_header(skb, skb_gro_offset(skb));
+       skb_reset_mac_len(skb);
+       BUILD_BUG_ON(sizeof_field(struct napi_gro_cb, zeroed) != sizeof(u32));
+       BUILD_BUG_ON(!IS_ALIGNED(offsetof(struct napi_gro_cb, zeroed),
+                                sizeof(u32))); /* Avoid slow unaligned acc */
+       *(u32 *)&NAPI_GRO_CB(skb)->zeroed = 0;
+       NAPI_GRO_CB(skb)->flush = skb_has_frag_list(skb);
+       NAPI_GRO_CB(skb)->is_atomic = 1;
+       NAPI_GRO_CB(skb)->count = 1;
+       if (unlikely(skb_is_gso(skb))) {
+               NAPI_GRO_CB(skb)->count = skb_shinfo(skb)->gso_segs;
+               /* Only support TCP at the moment. */
+               if (!skb_is_gso_tcp(skb))
+                       NAPI_GRO_CB(skb)->flush = 1;
+       }

-               pp = INDIRECT_CALL_INET(ptype->callbacks.gro_receive,
-                                       ipv6_gro_receive, inet_gro_receive,
-                                       &gro_list->list, skb);
+       /* Setup for GRO checksum validation */
+       switch (skb->ip_summed) {
+       case CHECKSUM_COMPLETE:
+               NAPI_GRO_CB(skb)->csum = skb->csum;
+               NAPI_GRO_CB(skb)->csum_valid = 1;
+               break;
+       case CHECKSUM_UNNECESSARY:
+               NAPI_GRO_CB(skb)->csum_cnt = skb->csum_level + 1;
                break;
        }
-       rcu_read_unlock();

-       if (&ptype->list == head)
-               goto normal;
+       pp = INDIRECT_CALL_INET(ptype->callbacks.gro_receive,
+                               ipv6_gro_receive, inet_gro_receive,
+                               &gro_list->list, skb);
+
+       rcu_read_unlock();

        if (PTR_ERR(pp) == -EINPROGRESS) {
                ret = GRO_CONSUMED;
