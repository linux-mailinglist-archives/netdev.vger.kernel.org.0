Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082C1595F0D
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 17:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234649AbiHPPbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 11:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233425AbiHPPbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 11:31:00 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74B6DE5
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 08:30:58 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id qn6so19565047ejc.11
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 08:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=sOa6Jzmf8uXcU8S9raIpxY6dV/FZ4nkatvU/1yFWbRI=;
        b=T7wg69pGydm6z2bR4DrzbfctcdaGxIW7VoKKx4AYscFjWeYT7gQ/2ISdgyr6Raznhi
         99eO7eBwF0oz9OBnKodq/eqVOD/7ZZW+LR/1MJRUJuFMN5MMTrUGBfAWxlnMttW8mwJp
         7c/zldRjy0Xb09nkx5FsdYfzQlOIXzMyQiOeo9/lB1/YVUB5foumom7WjmZ3lz7jSJ4r
         WdzI2xhzpgQgfafhS0kkgUBIYwiMby2JTU3Op3aXAn0btezymvGCjdZ2+zX+x/sRgw53
         5u4Gcgr/ZduwDHoc1vc2ULmAz0ygbPVIfu43Y6s2Jn73QdBHkmeINYnEiAWqkqXLXLjS
         QgZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=sOa6Jzmf8uXcU8S9raIpxY6dV/FZ4nkatvU/1yFWbRI=;
        b=CgPiMVsWmYoCDWphmfthb/WEFDIX/zF59GtaWogZp7F23th3AS7wSad2pG2QRS5bXP
         fuY1rLc+aQalIXd8eeLsvYOubcuiy29j8SGV89mkZxn1vGMlLJagwEH/cTfn0e9YDPjc
         N7a+yCFvQQK5EW7oj9t1NCDnR25hwVNT9SB0Bl2w0e5OgSUO0hObN4qkhRkqhvw0igAS
         CVQjQnNZMTfJREhPotLPzVg1vLgV0C3z1kekRTjezYK7/AzXP+21dyw5+T50hkCrkJfT
         9siB54q6u3eS5WkObwuV9HRF2hY/zpfxN9IWbcCLGIL/VvSNE+DaNPHJCorydVapn3Od
         XiZQ==
X-Gm-Message-State: ACgBeo3GfaDzQO2RRRY8mTBwUiV7pxnS94MQ6c4fWbDfNJTJ7RPwYlCB
        CI8rHushgPhpzeMLtm4L708NM+iATkO5FocB
X-Google-Smtp-Source: AA6agR5lq+6wXKqWuYBpx2EOT5mGQT005i/GMFZCMqroaYvdIgFfJ7bSFsf2Obb1b3wDYh1JqOt/Bw==
X-Received: by 2002:a17:906:7007:b0:6ff:8028:42e with SMTP id n7-20020a170906700700b006ff8028042emr14034527ejj.278.1660663857007;
        Tue, 16 Aug 2022 08:30:57 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id u4-20020a50eac4000000b0043ba7df7a42sm8697827edp.26.2022.08.16.08.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 08:30:56 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, Nikolay Aleksandrov <razor@blackwall.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH ipsec v2] xfrm: policy: fix metadata dst->dev xmit null pointer dereference
Date:   Tue, 16 Aug 2022 18:30:50 +0300
Message-Id: <20220816153050.22612-1-razor@blackwall.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220816145838.13951-1-razor@blackwall.org>
References: <20220816145838.13951-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we try to transmit an skb with metadata_dst attached (i.e. dst->dev
== NULL) through xfrm interface we can hit a null pointer dereference[1]
in xfrmi_xmit2() -> xfrm_lookup_with_ifid() due to the check for a
loopback skb device when there's no policy which dereferences dst->dev
unconditionally. Not having dst->dev can be interepreted as it not being
a loopback device, so just add a check for a null dst_orig->dev.

With this fix xfrm interface's Tx error counters go up as usual.

[1] net-next calltrace captured via netconsole:
  BUG: kernel NULL pointer dereference, address: 00000000000000c0
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] PREEMPT SMP
  CPU: 1 PID: 7231 Comm: ping Kdump: loaded Not tainted 5.19.0+ #24
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
  RIP: 0010:xfrm_lookup_with_ifid+0x5eb/0xa60
  Code: 8d 74 24 38 e8 26 a4 37 00 48 89 c1 e9 12 fc ff ff 49 63 ed 41 83 fd be 0f 85 be 01 00 00 41 be ff ff ff ff 45 31 ed 48 8b 03 <f6> 80 c0 00 00 00 08 75 0f 41 80 bc 24 19 0d 00 00 01 0f 84 1e 02
  RSP: 0018:ffffb0db82c679f0 EFLAGS: 00010246
  RAX: 0000000000000000 RBX: ffffd0db7fcad430 RCX: ffffb0db82c67a10
  RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffb0db82c67a80
  RBP: ffffb0db82c67a80 R08: ffffb0db82c67a14 R09: 0000000000000000
  R10: 0000000000000000 R11: ffff8fa449667dc8 R12: ffffffff966db880
  R13: 0000000000000000 R14: 00000000ffffffff R15: 0000000000000000
  FS:  00007ff35c83f000(0000) GS:ffff8fa478480000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00000000000000c0 CR3: 000000001ebb7000 CR4: 0000000000350ee0
  Call Trace:
   <TASK>
   xfrmi_xmit+0xde/0x460
   ? tcf_bpf_act+0x13d/0x2a0
   dev_hard_start_xmit+0x72/0x1e0
   __dev_queue_xmit+0x251/0xd30
   ip_finish_output2+0x140/0x550
   ip_push_pending_frames+0x56/0x80
   raw_sendmsg+0x663/0x10a0
   ? try_charge_memcg+0x3fd/0x7a0
   ? __mod_memcg_lruvec_state+0x93/0x110
   ? sock_sendmsg+0x30/0x40
   sock_sendmsg+0x30/0x40
   __sys_sendto+0xeb/0x130
   ? handle_mm_fault+0xae/0x280
   ? do_user_addr_fault+0x1e7/0x680
   ? kvm_read_and_reset_apf_flags+0x3b/0x50
   __x64_sys_sendto+0x20/0x30
   do_syscall_64+0x34/0x80
   entry_SYSCALL_64_after_hwframe+0x46/0xb0
  RIP: 0033:0x7ff35cac1366
  Code: eb 0b 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b8 0f 1f 00 41 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 11 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 72 c3 90 55 48 83 ec 30 44 89 4c 24 2c 4c 89
  RSP: 002b:00007fff738e4028 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
  RAX: ffffffffffffffda RBX: 00007fff738e57b0 RCX: 00007ff35cac1366
  RDX: 0000000000000040 RSI: 0000557164e4b450 RDI: 0000000000000003
  RBP: 0000557164e4b450 R08: 00007fff738e7a2c R09: 0000000000000010
  R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000040
  R13: 00007fff738e5770 R14: 00007fff738e4030 R15: 0000001d00000001
   </TASK>
  Modules linked in: netconsole veth br_netfilter bridge bonding virtio_net [last unloaded: netconsole]
  CR2: 00000000000000c0

CC: Steffen Klassert <steffen.klassert@secunet.com>
CC: Daniel Borkmann <daniel@iogearbox.net>
Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
v2: adjust commit msg and subject for dst->dev (s/skb/dst/)

I wasn't sure if the target tree should be -net or -ipsec. The patch
applies to both cleanly in case it should go through -net.

To test the fix I attached a very simple egress bpf program to the xfrm
interface which just adds an empty md_dst to all transmitted skbs.

 net/xfrm/xfrm_policy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 4f8bbb825abc..cc6ab79609e2 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3162,7 +3162,7 @@ struct dst_entry *xfrm_lookup_with_ifid(struct net *net,
 	return dst;
 
 nopol:
-	if (!(dst_orig->dev->flags & IFF_LOOPBACK) &&
+	if ((!dst_orig->dev || !(dst_orig->dev->flags & IFF_LOOPBACK)) &&
 	    net->xfrm.policy_default[dir] == XFRM_USERPOLICY_BLOCK) {
 		err = -EPERM;
 		goto error;
-- 
2.36.1

