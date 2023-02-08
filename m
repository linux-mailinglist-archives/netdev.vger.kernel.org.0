Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C87968F6B1
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 19:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbjBHSNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 13:13:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbjBHSNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 13:13:04 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E12E17177
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 10:13:02 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id u22so8619179ejj.10
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 10:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=diag.uniroma1.it; s=google;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WG+17oAZUfaHQyeBN8o9yCxMkSId4LwLQoMJU6ajzzg=;
        b=TQroIY7niUVOIh95dPmJQIQDR/7QZpaPf02EFS9BWDUhodtY2mjzoWr0N9F33k82GM
         GyT5EyabkIrROYq8lfwag8Ox+AlXWBo1NhCal+VD78zV4KPZXp1QchDTILqgK6fc3tIy
         g3fu8wYp31S9oPMGLdsa37CirLrbYgHaWS/e8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WG+17oAZUfaHQyeBN8o9yCxMkSId4LwLQoMJU6ajzzg=;
        b=z0NP1dy/F//seLmZ2XfNVXF/S7Y3WVUHGS50VH27oqOzgiWqQciVrPjk5hh5D816mT
         nYaXyBGCGyMvWLU2WAnl5lNyUiQ0J9+2Vr4pMfsiMPykEa1N7uin9agMD92IGkna3BHd
         jbTEk+OlvzSJerhoKzu5wx49Q/pFHonk1eyKeWIHxfA+19X3sDPWxwE8NbY4PGFMKaaN
         FeUMHRYPamlWjsq2ZCiphiAxQRuAICytTpxr/DFgKMEbgqCyCuo6H99bTe4iLCkMy40X
         tM16yD4JHe9J9My+FpNXAGXKRZ085MTlcDqLyOQIVz3MkCopX+KLWA8H+XDZcFedu/6j
         ssfQ==
X-Gm-Message-State: AO0yUKUTMV9WVzybooV3LjdxwCIDGrXvUCShz7BCaFrBBWAx+EbHrzBf
        BFwtpe1009VnvH/OM3FAshMRNA==
X-Google-Smtp-Source: AK7set8muqG/n3xWtMoVLPSPCINAWbxHb3mFi6VGwibvl/xoBnOzwZHAVfDnGJTztVm0xT7h8osJ+g==
X-Received: by 2002:a17:906:e218:b0:871:dd2:4af0 with SMTP id gf24-20020a170906e21800b008710dd24af0mr8146841ejb.26.1675879980995;
        Wed, 08 Feb 2023 10:13:00 -0800 (PST)
Received: from [192.168.17.2] (wolkje-127.labs.vu.nl. [130.37.198.127])
        by smtp.gmail.com with ESMTPSA id sb1-20020a170906edc100b008888f4120d4sm8484483ejb.129.2023.02.08.10.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 10:13:00 -0800 (PST)
From:   Pietro Borrello <borrello@diag.uniroma1.it>
Date:   Wed, 08 Feb 2023 18:12:22 +0000
Subject: [PATCH net-next] sctp: check ep asocs list before access
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230208-sctp-filter-v1-1-84ae70d90091@diag.uniroma1.it>
X-B4-Tracking: v=1; b=H4sIAAXm42MC/x2NywrCMBBFf6XM2oGY2Pr4leIijbd2QGOZCVIo/
 XdTl4dzD3clgwqMbs1Kiq+YfHKF46GhNMX8BMujMnnng/PuwpbKzKO8CpTP4dQGdO01dI5qMUQ
 DDxpzmvbmHa2udjErRln+Nz1lFM5YCt237QcMTNUfgAAAAA==
To:     Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pietro Borrello <borrello@diag.uniroma1.it>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1675879980; l=2915;
 i=borrello@diag.uniroma1.it; s=20221223; h=from:subject:message-id;
 bh=37sFUIKlcdDaHzdEu0jQJw9diuGOvo8A584FuAvw2YU=;
 b=3JokCj8HzXH6jF4xRVw3O6R1m1SPZMyRDE/SmwvdpmaKZiEtnNkERE5ZCgJS87k8bAsDXk2g+qgr
 56UdMMNOBKEw/e8YwV5nn2hsPSpnmSSAPE50HtZduHDziUSsSuxD
X-Developer-Key: i=borrello@diag.uniroma1.it; a=ed25519;
 pk=4xRQbiJKehl7dFvrG33o2HpveMrwQiUPKtIlObzKmdY=
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add list_empty() check before accessing first entry of ep->asocs list
in sctp_sock_filter(), which is not gauranteed to have an entry.

Fixes: 8f840e47f190 ("sctp: add the sctp_diag.c file")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
---

The list_entry on an empty list creates a type confused pointer.
While using it is undefined behavior, in this case it seems there
is no big risk, as the `tsp->asoc != assoc` check will almost
certainly fail on the type confused pointer.
We report this bug also since it may hide further problems since
the code seems to assume a non-empty `ep->asocs`.

We were able to trigger sctp_sock_filter() using syzkaller, and
cause a panic inserting `BUG_ON(list_empty(&ep->asocs))`, so the
list may actually be empty.
But we were not able to minimize our testcase and understand how
sctp_sock_filter may end up with an empty asocs list.
We suspect a race condition between a connecting sctp socket
and the diag query.

We attach the stacktrace when triggering the injected
`BUG_ON(list_empty(&ep->asocs))`:

```
[  217.044169][T18237] kernel BUG at net/sctp/diag.c:364!
[  217.044845][T18237] invalid opcode: 0000 [#1] PREEMPT SMP KASAN
[  217.045681][T18237] CPU: 0 PID: 18237 Comm: syz-executor Not
tainted 6.1.0-00003-g190ee984c3e0-dirty #72
[  217.046934][T18237] Hardware name: QEMU Standard PC (i440FX +
PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
[  217.048241][T18237] RIP: 0010:sctp_sock_filter+0x1ce/0x1d0
[...]
[  217.060554][T18237] Call Trace:
[  217.061003][T18237]  <TASK>
[  217.061409][T18237]  sctp_transport_traverse_process+0x17d/0x470
[  217.062212][T18237]  ? sctp_ep_dump+0x620/0x620
[  217.062835][T18237]  ? sctp_sock_filter+0x1d0/0x1d0
[  217.063524][T18237]  ? sctp_transport_lookup_process+0x280/0x280
[  217.064330][T18237]  ? sctp_diag_get_info+0x260/0x2c0
[  217.065026][T18237]  ? sctp_for_each_endpoint+0x16f/0x200
[  217.065762][T18237]  ? sctp_diag_get_info+0x2c0/0x2c0
[  217.066435][T18237]  ? sctp_for_each_endpoint+0x1c0/0x200
[  217.067155][T18237]  sctp_diag_dump+0x2ea/0x480
[...]
[  217.093117][T18237]  do_writev+0x22d/0x460
```
---
 net/sctp/diag.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index a557009e9832..02831497cc9b 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -346,6 +346,9 @@ static int sctp_sock_filter(struct sctp_endpoint *ep, struct sctp_transport *tsp
 	struct sctp_association *assoc =
 		list_entry(ep->asocs.next, struct sctp_association, asocs);
 
+	if (list_empty(&ep->asocs))
+		return 0;
+
 	/* find the ep only once through the transports by this condition */
 	if (tsp->asoc != assoc)
 		return 0;

---
base-commit: 4ec5183ec48656cec489c49f989c508b68b518e3
change-id: 20230208-sctp-filter-73453e659360

Best regards,
-- 
Pietro Borrello <borrello@diag.uniroma1.it>

