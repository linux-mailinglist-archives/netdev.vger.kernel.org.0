Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF28621EF4
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiKHWQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:16:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbiKHWQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:16:57 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B8360694;
        Tue,  8 Nov 2022 14:16:55 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id q71so14567852pgq.8;
        Tue, 08 Nov 2022 14:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uMh1b31c7i6XsU0LQPKswbpB9miDlwJdgzwIoNkomoM=;
        b=D8a7HmAZ8j9bHs/0z/j849Uqer2syTLivLZ6I+S2N+e4I9a+5QU5tDFG1UfrUtJvUW
         9lbS9uxTeEO8O12ISbtaXN3vL74ajw3aSw5i8BtK4f0U5M9LiWqQ+8gTFB6lPtjjOSHx
         Djfua0gLfsePY8EVIXxLqmYAMvBD0i1T0cGrL8/56HrgPgCjpb20ZgHFZDe00w782AUT
         2iODCQ3zF3+y54uypBTVJ4c8pZ7o9BT+WCC5WG9JV/bLTICowj1UjQZ397SgtSALfWhH
         KqU3mjbeeaX80iyPlXcW+ILbl7VxPHNQzz1eEGJQ4LzLfAGSaRNDH44v5uMR3SzpGSqD
         726g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uMh1b31c7i6XsU0LQPKswbpB9miDlwJdgzwIoNkomoM=;
        b=AHVKGrHQy9VUXXzAtTLBkpuZglVxFHRqpzz7XoVHimdMx4WsOiVDFYTWogSDFSZYns
         GiOcMct3Ezttk6dIY8u6BE7BXGP4L1q5ttljsdKk2LQDnchIhyysiVLxM3D9mhhGw9rX
         CwIM9Hi1uK43D0ZQbrqCT7rohUC4BNkgtvOIsZGZMo8hFzeZkrNkxhxTn/GpzrsOWelg
         etRFCgzd7lX81NHU5h32jS1pejdnJOVb+Bf24cMWBOFnreH/QQMMKJAH82Gosbybrj5o
         PbIbpxF9nILtPTHQtOgawKAUnT3ihlmMuhLJ6RVEmHgjNHt/CHuuzUnOjCP+6KbBvepd
         KF7Q==
X-Gm-Message-State: ACrzQf0OwNnbYXQzcDHQSsqwO43q3NvE567KXpA517/dMZMLB1e37y3j
        xmX7SbSV2dAKd3hBaRGmrL8=
X-Google-Smtp-Source: AMsMyM4bBNYPnIuZ7L487cOJnGK6eJROm1wmrUdKEKt4F5D01XtwpeSgU5bVy2wcI2JAo9EXA2tPSA==
X-Received: by 2002:aa7:8888:0:b0:56d:41a9:dbb3 with SMTP id z8-20020aa78888000000b0056d41a9dbb3mr52589119pfe.15.1667945815134;
        Tue, 08 Nov 2022 14:16:55 -0800 (PST)
Received: from john.lan ([98.97.44.106])
        by smtp.gmail.com with ESMTPSA id p3-20020a622903000000b005636326fdbfsm6848366pfp.78.2022.11.08.14.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 14:16:54 -0800 (PST)
From:   John Fastabend <john.fastabend@gmail.com>
To:     daniel@iogearbox.net, kuba@kernel.org, davem@davemloft.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Subject: [1/1 bpf-next] bpf: veth driver panics when xdp prog attached before veth_open
Date:   Tue,  8 Nov 2022 14:16:50 -0800
Message-Id: <20221108221650.808950-2-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20221108221650.808950-1-john.fastabend@gmail.com>
References: <20221108221650.808950-1-john.fastabend@gmail.com>
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

The following panic is observed when bringing up (veth_open) a veth device
that has an XDP program attached.

[   61.519185] kernel BUG at net/core/dev.c:6442!
[   61.519456] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[   61.519752] CPU: 0 PID: 408 Comm: ip Tainted: G        W          6.1.0-rc2-185930-gd9095f92950b-dirty #26
[   61.520288] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
[   61.520806] RIP: 0010:napi_enable+0x3d/0x40
[   61.521077] Code: f6 f6 80 61 08 00 00 02 74 0d 48 83 bf 88 01 00 00 00 74 03 80 cd 01 48 89 d0 f0 48 0f b1 4f 10 48 39 c2 75 c8 c3 cc cc cc cc <0f> 0b 90 48 8b 87 b0 00 00 00 48 81 c7 b0 00 00 00 45 31 c0 48 39
[   61.522226] RSP: 0018:ffffbc9800cc36f8 EFLAGS: 00010246
[   61.522557] RAX: 0000000000000001 RBX: 0000000000000300 RCX: 0000000000000001
[   61.523004] RDX: 0000000000000010 RSI: ffffffff8b0de852 RDI: ffff9f03848e5000
[   61.523452] RBP: 0000000000000000 R08: 0000000000000800 R09: 0000000000000000
[   61.523899] R10: ffff9f0384a96800 R11: ffffffffffa48061 R12: ffff9f03849c3000
[   61.524345] R13: 0000000000000300 R14: ffff9f03848e5000 R15: 0000001000000100
[   61.524792] FS:  00007f58cb64d2c0(0000) GS:ffff9f03bbc00000(0000) knlGS:0000000000000000
[   61.525301] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   61.525673] CR2: 00007f6cc629b498 CR3: 000000010498c000 CR4: 00000000000006f0
[   61.526121] Call Trace:
[   61.526284]  <TASK>
[   61.526425]  __veth_napi_enable_range+0xd6/0x230
[   61.526723]  veth_enable_xdp+0xd0/0x160
[   61.526969]  veth_open+0x2e/0xc0
[   61.527180]  __dev_open+0xe2/0x1b0
[   61.527405]  __dev_change_flags+0x1a1/0x210
[   61.527673]  dev_change_flags+0x1c/0x60

This happens because we are calling veth_napi_enable() on already enabled
queues. The root cause is in commit 2e0de6366ac16 changed the control logic
dropping this case,

        if (priv->_xdp_prog) {
                err = veth_enable_xdp(dev);
                if (err)
                        return err;
-       } else if (veth_gro_requested(dev)) {
+               /* refer to the logic in veth_xdp_set() */
+               if (!rtnl_dereference(peer_rq->napi)) {
+                       err = veth_napi_enable(peer);
+                       if (err)
+                               return err;
+               }

so that now veth_napi_enable is called if the peer has not yet
initialiazed its peer_rq->napi. The issue is this will happen
even if the NIC is not up. Then in veth_enable_xdp just above
we have similar path,

  veth_enable_xdp
   napi_already_on = (dev->flags & IFF_UP) && rcu_access_pointer(rq->napi)
    err = veth_enable_xdp_range(dev, 0, dev->real_num_rx_queues, napi_already_on);

The trouble is an xdp prog is assigned before bringing the device up each
of the veth_open path will enable the peers xdp napi structs. But then when
we bring the peer up it will similar try to enable again because from
veth_open the IFF_UP flag is not set until after the op in __dev_open so
we believe napi_alread_on = false.

To fix this just drop the IFF_UP test and rely on checking if the napi
struct is enabled. This also matches the peer check in veth_xdp for
disabling.

To reproduce run ./test_xdp_meta.sh I found adding Cilium/Tetragon tests
for XDP.

Fixes: 2e0de6366ac16 ("veth: Avoid drop packets when xdp_redirect performs")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 drivers/net/veth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index b1ed5a93b6c5..2a4592780141 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1125,7 +1125,7 @@ static int veth_enable_xdp(struct net_device *dev)
 	int err, i;
 
 	rq = &priv->rq[0];
-	napi_already_on = (dev->flags & IFF_UP) && rcu_access_pointer(rq->napi);
+	napi_already_on = rcu_access_pointer(rq->napi);
 
 	if (!xdp_rxq_info_is_reg(&priv->rq[0].xdp_rxq)) {
 		err = veth_enable_xdp_range(dev, 0, dev->real_num_rx_queues, napi_already_on);
-- 
2.33.0

