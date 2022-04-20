Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8641F508DCB
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 18:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380788AbiDTQzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 12:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234342AbiDTQze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 12:55:34 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55473E5C4;
        Wed, 20 Apr 2022 09:52:47 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id g18so4742078ejc.10;
        Wed, 20 Apr 2022 09:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5BhEb2573/hfw8t8bp1ven7rd3mYWJSdIGH3HAvPqlI=;
        b=CdeRXIHm0B7wGIRmZBokbw1pSkh4JYi50ZL0X/S7rRu7uBKOWQyIsBWPVnaroDI2td
         JUNY0Wd9Oi7CDseFgKy/4cv95RHwNQBuaspUranyw43UV/Hl9yMixgbJSD+L3XIDL9qf
         WJCyF9dwCqvFqzyzRq06CN3uyw0lIDdM0sGl1JCai9EGcQ+EgUiFcQg2W/ro5mSE5y0p
         K9566CuiHN9pI1zAiUye4QZ2MowprLqQ6mGMkFpQZq1M9mwdI86mXjAjQyUr3j9hVTF9
         OtB6Qpfe1f4eLRVrbV8G162LrEGRMG48Piw8c8E2r7YLeoXB8ye64Mxpc5vCIUCz36oX
         2UMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5BhEb2573/hfw8t8bp1ven7rd3mYWJSdIGH3HAvPqlI=;
        b=swGgBNCYVuQV8FBZ9RvpFZklii/zuyibSRvpQal/2H3mAWz3saf4khokhm7iQ90YOd
         +LjtvO9NpZWxUQ2cT3utaS8g+NsvTi5bo4w5qnzBU/gl6AEXbry2rozWqKdfP+aFCv6h
         QyEUr2mjB1HQ1oQo2EgzlqFDVVnxFvwEi2EV0KuGcDcnjBLeP1g16EUxkkHkpCcTzqsK
         W/JCAkO1JqLaB5yooaweKjA29Ur82e1TUkI4BfHS53o0Et0PqqtssCMXCDwNmzkqQGlD
         jY4Euf07A2dIdZGbM8bt6035V/eoxsdNPsDixNm1+BqIwAzbxg4prP2mPBOyqXF9lCkp
         /g6g==
X-Gm-Message-State: AOAM5324tOH6VhoW5eUqcHttK5Q4XOKhO9sSC458f0nTmjZXMky0uQEg
        kYDEZChyRmE+yACOUcKUuNE=
X-Google-Smtp-Source: ABdhPJzWaOd2sknJ9j5JUkm5lcBO4eMDAc7cowTsH3kT1PCL9n5ltjT8yIryRAP8o9YCu2e4dm9AkA==
X-Received: by 2002:a17:907:4d0:b0:6e8:6ff4:c78a with SMTP id vz16-20020a17090704d000b006e86ff4c78amr19306707ejb.28.1650473566282;
        Wed, 20 Apr 2022 09:52:46 -0700 (PDT)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id eg12-20020a056402288c00b0041fb0f2e155sm10224232edb.20.2022.04.20.09.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 09:52:45 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, mkl@pengutronix.de,
        tgraf@suug.ch, shmulik.ladkani@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Eyal Birger <eyal.birger@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH bpf] lwt_bpf: fix crash when using bpf_skb_set_tunnel_key() from bpf_xmit lwt hook
Date:   Wed, 20 Apr 2022 19:52:19 +0300
Message-Id: <20220420165219.1755407-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xmit_check_hhlen() observes the dst for getting the device hard header
length to make sure a modified packet can fit. When a helper which changes
the dst - such as bpf_skb_set_tunnel_key() - is called as part of the xmit
program the accessed dst is no longer valid.

This leads to the following splat:

 BUG: kernel NULL pointer dereference, address: 00000000000000de
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] PREEMPT SMP PTI
 CPU: 0 PID: 798 Comm: ping Not tainted 5.18.0-rc2+ #103
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
 RIP: 0010:bpf_xmit+0xfb/0x17f
 Code: c6 c0 4d cd 8e 48 c7 c7 7d 33 f0 8e e8 42 09 fb ff 48 8b 45 58 48 8b 95 c8 00 00 00 48 2b 95 c0 00 00 00 48 83 e0 fe 48 8b 00 <0f> b7 80 de 00 00 00 39 c2 73 22 29 d0 b9 20 0a 00 00 31 d2 48 89
 RSP: 0018:ffffb148c0bc7b98 EFLAGS: 00010282
 RAX: 0000000000000000 RBX: 0000000000240008 RCX: 0000000000000000
 RDX: 0000000000000010 RSI: 00000000ffffffea RDI: 00000000ffffffff
 RBP: ffff922a828a4e00 R08: ffffffff8f1350e8 R09: 00000000ffffdfff
 R10: ffffffff8f055100 R11: ffffffff8f105100 R12: 0000000000000000
 R13: ffff922a828a4e00 R14: 0000000000000040 R15: 0000000000000000
 FS:  00007f414e8f0080(0000) GS:ffff922afdc00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00000000000000de CR3: 0000000002d80006 CR4: 0000000000370ef0
 Call Trace:
  <TASK>
  lwtunnel_xmit.cold+0x71/0xc8
  ip_finish_output2+0x279/0x520
  ? __ip_finish_output.part.0+0x21/0x130

Fix by fetching the device hard header length before running the bpf code.

Cc: stable@vger.kernel.org
Fixes: commit 3a0af8fd61f9 ("bpf: BPF for lightweight tunnel infrastructure")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 net/core/lwt_bpf.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
index 349480ef68a5..8b6b5e72b217 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -159,10 +159,8 @@ static int bpf_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 	return dst->lwtstate->orig_output(net, sk, skb);
 }
 
-static int xmit_check_hhlen(struct sk_buff *skb)
+static int xmit_check_hhlen(struct sk_buff *skb, int hh_len)
 {
-	int hh_len = skb_dst(skb)->dev->hard_header_len;
-
 	if (skb_headroom(skb) < hh_len) {
 		int nhead = HH_DATA_ALIGN(hh_len - skb_headroom(skb));
 
@@ -274,6 +272,7 @@ static int bpf_xmit(struct sk_buff *skb)
 
 	bpf = bpf_lwt_lwtunnel(dst->lwtstate);
 	if (bpf->xmit.prog) {
+		int hh_len = dst->dev->hard_header_len;
 		__be16 proto = skb->protocol;
 		int ret;
 
@@ -291,7 +290,7 @@ static int bpf_xmit(struct sk_buff *skb)
 			/* If the header was expanded, headroom might be too
 			 * small for L2 header to come, expand as needed.
 			 */
-			ret = xmit_check_hhlen(skb);
+			ret = xmit_check_hhlen(skb, hh_len);
 			if (unlikely(ret))
 				return ret;
 
-- 
2.32.0

