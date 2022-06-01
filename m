Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6D2539D5D
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 08:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239816AbiFAGqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 02:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbiFAGqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 02:46:42 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905D71C1;
        Tue, 31 May 2022 23:46:39 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id s12so951993plp.0;
        Tue, 31 May 2022 23:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EFwOnU1Z5Ynw8a8Slm95HzIXY1s77XJoGiJeg0kO+kQ=;
        b=Cs03CyEhzJTXOOzlVXoWHibVtcRQ3FmgE1pyF+gSoPQ8xzmO4D4JlLsWpKtvvt1W7m
         EP+taoO3udGuU5QeWPPQdvAMwU5HaA3DQIU4unrjoz61NX3TwstjKqhvUDpd8YJPNSA+
         Ihvpc8LOhZ+c4doCvFDgqDMv5+I4JXr1PJTkeKB08/Y6aD9FFYPa0xiTdRBS2P3BGq8Z
         Ha6ycIeWPQR2+TdeWlgFjAol3iKyac/U8MGrjEQG4xUKH5OTDwJodSck2++izkc8H1Sx
         gJlRtMH/5aGYo+yMDjgnHz9fIoy/6b7wFHzV3C23psc1ejof58bnKXQHThSoXJLctTKv
         Py5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EFwOnU1Z5Ynw8a8Slm95HzIXY1s77XJoGiJeg0kO+kQ=;
        b=bWNrY8FvW7ahDs2QdwO0ZOYfd9a3fJz8kv7kTMxx95v1kXl/dG9zbR9h6ZJD8uedTR
         YlWQ6uCH+gll5+8c3uX3a5WZo0rlWLLLmHC+tvEQODATntvWujBTEbSu+62hxUEgOimw
         5mnnZbK0iRkTaQpmvaMBXMhqye/HnPeYrI9kZ06nTvHj7Dx3F0C9x2R+nzBFhth2UqUB
         Xk/zjCD7pjM10Vdzbz76QGY97JiMaxaCjaLONgteGuoWxAU1Glf05iCuCe9gLt5mNd0B
         9jCSe5WPmNIJlHgf6/hq28vM+eHcxWIsreSb4h2vvtccNZdYQKGZ5CnOboLtvQAzCc5r
         3zQQ==
X-Gm-Message-State: AOAM533ZXjtyN25vTSLH/3fmwNiaKIkEbbJMpVr4Gr8uIhLNWd9HgFya
        1/lplsXzTP1rnt5E6bEkknA=
X-Google-Smtp-Source: ABdhPJy/Wm5LAWAsuLyUNVvfF0queZvYjtDyGTp62nQAE2KJu1zk3S6BuIIsvGwwral8AeKV6ndFfg==
X-Received: by 2002:a17:903:240b:b0:14b:1100:aebc with SMTP id e11-20020a170903240b00b0014b1100aebcmr65529691plo.133.1654065998914;
        Tue, 31 May 2022 23:46:38 -0700 (PDT)
Received: from localhost.localdomain ([103.84.139.165])
        by smtp.gmail.com with ESMTPSA id ij7-20020a170902ab4700b0015e8d4eb1fasm682332plb.68.2022.05.31.23.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 23:46:38 -0700 (PDT)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, timo.teras@iki.fi
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH v2] xfrm: xfrm_policy: fix a possible double xfrm_pols_put() in xfrm_bundle_lookup()
Date:   Wed,  1 Jun 2022 14:46:25 +0800
Message-Id: <20220601064625.26414-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xfrm_policy_lookup() will call xfrm_pol_hold_rcu() to get a refcount of
pols[0]. This refcount can be dropped in xfrm_expand_policies() when
xfrm_expand_policies() return error. pols[0]'s refcount is balanced in
here. But xfrm_bundle_lookup() will also call xfrm_pols_put() with
num_pols == 1 to drop this refcount when xfrm_expand_policies() return
error.

This patch also fix an illegal address access. pols[0] will save a error
point when xfrm_policy_lookup fails. This lead to xfrm_pols_put to resolve
an illegal address in xfrm_bundle_lookup's error path.

Fix these by setting num_pols = 0 in xfrm_expand_policies()'s error path.

Fixes: 80c802f3073e ("xfrm: cache bundles instead of policies for outgoing flows")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---

v2:
Fix an illegal address access.

An log about illegal address access:
[  444.538191] BUG: kernel NULL pointer dereference, address: 000000000000002f
[  444.538200] #PF: supervisor write access in kernel mode
[  444.538204] #PF: error_code(0x0002) - not-present page
[  444.538208] PGD 0 P4D 0 
[  444.538215] Oops: 0002 [#1] SMP NOPTI
[  444.538220] CPU: 0 PID: 729 Comm: systemd-resolve Tainted: G             L    5.10.0-1044-oem #46-Ubuntu
[  444.538222] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/22/2020
[  444.538226] watchdog: BUG: soft lockup - CPU#1 stuck for 34s! [in:imklog:838]
[  444.538232] RIP: 0010:xfrm_lookup_with_ifid+0x6b5/0xa00
[  444.538236] Code: c1 e1 03 4c 8d 64 35 b8 4c 8d 3c 30 49 29 cc eb 0d 85 c9 7e 4e 49 83 ef 08 4d 39 fc 74 24 49 8b 3f b9 ff ff ff ff 4c 8d 47 30 <f0> 0f c1 4f 30 83 f9 01 75 dd e8 ec 98 ff ff 49 83 ef 08 4d 39 fc
[  444.538237] RSP: 0018:ffffc900016af9f8 EFLAGS: 00010286
[  444.538241] Modules linked in:
[  444.538243] RAX: ffffc900016afa30 RBX: 00000000ffffffff RCX: 00000000ffffffff
[  444.538244]  rfcomm bnep ipmi_devintf
[  444.538248] RDX: 0000000000035f40 RSI: 0000000000000000 RDI: ffffffffffffffff
[  444.538251] RBP: ffffc900016afa70 R08: 000000000000002f R09: 0000000000000002
[  444.538252]  ipmi_msghandler vsock_loopback
[  444.538255] R10: 0000000080000000 R11: 000000007f000001 R12: ffffc900016afa28
[  444.538257] R13: ffff888100e07500 R14: ffffffff828ee1c0 R15: ffffc900016afa30
[  444.538258]  vmw_vsock_virtio_transport_common vmw_vsock_vmci_transport
[  444.538262] FS:  00007fa7fb14cb80(0000) GS:ffff888139e00000(0000) knlGS:0000000000000000
[  444.538264] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  444.538267] CR2: 000000000000002f CR3: 00000001066f2003 CR4: 0000000000770ef0
[  444.538268]  vsock nls_iso8859_1 intel_rapl_msr snd_ens1371 snd_ac97_codec gameport ac97_bus intel_rapl_common crct10dif_pclmul snd_pcm ghash_clmulni_intel aesni_intel vmw_balloon crypto_simd
[  444.538282] PKRU: 55555554
[  444.538284] Call Trace:
[  444.538286]  snd_seq_midi cryptd glue_helper snd_seq_midi_event snd_rawmidi joydev
[  444.538293]  xfrm_lookup_route+0x23/0xa0
[  444.538294]  input_leds serio_raw btusb btrtl
[  444.538301]  ip_route_output_flow+0x58/0x60
[  444.538304]  udp_sendmsg+0x9ee/0xe30
[  444.538308]  ? put_cmsg+0x13e/0x170
[  444.538311]  ? ip_reply_glue_bits+0x50/0x50
[  444.538312]  btbcm btintel
[  444.538316]  ? skb_consume_udp+0x3f/0xd0
[  444.538319]  ? udp_recvmsg+0x1f7/0x5b0
[  444.538324]  ? __check_object_size+0x4d/0x150
[  444.538326]  ? __check_object_size+0x4d/0x150
[  444.538327]  snd_seq bluetooth ecdh_generic
[  444.538332]  ? _cond_resched+0x19/0x30
[  444.538338]  ? aa_sk_perm+0x43/0x1b0
[  444.538339]  ecc snd_seq_device snd_timer
[  444.538343]  inet_sendmsg+0x65/0x70
[  444.538346]  ? inet_sendmsg+0x65/0x70
[  444.538350]  sock_sendmsg+0x5e/0x70
[  444.538352]  ____sys_sendmsg+0x218/0x290
[  444.538355]  ? copy_msghdr_from_user+0x5c/0x90
[  444.538357]  ___sys_sendmsg+0x81/0xc0
[  444.538361]  ? kmem_cache_free+0x3c5/0x410
[  444.538362]  snd soundcore
[  444.538366]  ? dentry_free+0x37/0x70
[  444.538368]  vmw_vmci
[  444.538370]  ? mntput_no_expire+0x4c/0x260
[  444.538374]  ? __seccomp_filter+0x7f/0x670
[  444.538376]  __sys_sendmsg+0x62/0xb0
[  444.538378]  ? __secure_computing+0x42/0xe0
[  444.538381]  __x64_sys_sendmsg+0x1f/0x30
[  444.538382]  mac_hid sch_fq_codel vmwgfx
[  444.538386]  do_syscall_64+0x38/0x90
[  444.538390]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  444.538391]  ttm drm_kms_helper
[  444.538395] RIP: 0033:0x7fa7fc3f4617


 net/xfrm/xfrm_policy.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index f1876ea61fdc..f1a0bab920a5 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2678,8 +2678,10 @@ static int xfrm_expand_policies(const struct flowi *fl, u16 family,
 		*num_xfrms = 0;
 		return 0;
 	}
-	if (IS_ERR(pols[0]))
+	if (IS_ERR(pols[0])) {
+		*num_pols = 0;
 		return PTR_ERR(pols[0]);
+	}
 
 	*num_xfrms = pols[0]->xfrm_nr;
 
@@ -2694,6 +2696,7 @@ static int xfrm_expand_policies(const struct flowi *fl, u16 family,
 		if (pols[1]) {
 			if (IS_ERR(pols[1])) {
 				xfrm_pols_put(pols, *num_pols);
+				*num_pols = 0;
 				return PTR_ERR(pols[1]);
 			}
 			(*num_pols)++;
-- 
2.25.1

