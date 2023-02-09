Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8348869086A
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 13:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbjBIMNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 07:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjBIMNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 07:13:18 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64AE129428
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 04:13:11 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id c26so927591ejz.10
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 04:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=diag.uniroma1.it; s=google;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4qtFTvbHxRjvyTRQZm4FOypGXExhOGLEMmjpmKJUfdE=;
        b=fadsR6LJNu4N9d/Okgy64gjG/yQksFsSZ85Yb9Qte/MGtIV1b7C1gJPdMwNq5+PCYy
         up3LWvs+r8tVVKnY+zWpFgIXGpn7zNAip/DXXmKZEDjowKlaO/9K4E/LwUERh/xCa1+z
         mAl9AyezEjXQIHXqHOvHjTJEibuX8vUzbkXJI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4qtFTvbHxRjvyTRQZm4FOypGXExhOGLEMmjpmKJUfdE=;
        b=DKrzkOWq1vmYWpelleTYFQbo2uVawr370U4Tj8Fy+C3KDqTB7dfbSKH0HJFTK+Fn/0
         lxU28wWjDGhSkqt+0/lVBIGEqyLSFja4F14ZpE2AMjUOdQzTGXOCO6tKvOtr328FOQQ7
         SE57K4NXON7XrvExO9SCeAnYjuHg/f33NlTBjk+ZwefRMboFO7i2+aOZYxY2uRuGOQCd
         mxUFLa0aEP3KoQwjn3BVcEkHsoGEV22vOOb/mCp/4ZyKnIGXJDALH0WWPZgyoLYO59AC
         kIjbPa1GdR8sa9WnML0vUsB4dWG8Qk/OFqS1eJr5LG96ja7we7Y3Fp3c2dWTBcahj/Qs
         S0DA==
X-Gm-Message-State: AO0yUKW7CvTpbMWOtG4xWGRtBrLbc+W4IO3HSSijDEuF02fBkBvtZFqN
        jgkkZ7wq43yjVFDMqFaTzIYdGg==
X-Google-Smtp-Source: AK7set8g+72zfUkP2goBWQLOKa9VuG5jrw55G0ZPpvezzXsUk/XgNU6C3ANGKZW4+1EPfX/teIiq2w==
X-Received: by 2002:a17:907:a095:b0:877:8ae7:2e44 with SMTP id hu21-20020a170907a09500b008778ae72e44mr12932864ejc.5.1675944789864;
        Thu, 09 Feb 2023 04:13:09 -0800 (PST)
Received: from [192.168.17.2] (wolkje-127.labs.vu.nl. [130.37.198.127])
        by smtp.gmail.com with ESMTPSA id r13-20020a1709064d0d00b0080345493023sm784466eju.167.2023.02.09.04.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 04:13:09 -0800 (PST)
From:   Pietro Borrello <borrello@diag.uniroma1.it>
Date:   Thu, 09 Feb 2023 12:13:05 +0000
Subject: [PATCH net-next v2] sctp: sctp_sock_filter(): avoid list_entry()
 on possibly empty list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230208-sctp-filter-v2-1-6e1f4017f326@diag.uniroma1.it>
X-B4-Tracking: v=1; b=H4sIAFDj5GMC/22NOw6DMBBEr4K2ziJ/+KbKPaIUBhZYKRhkO4gIc
 fcY6pSjNzNvB0+OycM92cHRyp5nG4O6JdCOxg6E3MUMSigtlKjQt2HBnt+BHJY6yzUVea0LAXH
 RGE/YOGPb8dxMxsfWCRZHPW+X5gmWAlraArwiGdmH2X0v/yov/le1SpRYZYZK0dVC1PLRsRnSj
 2U3T0amHO+O4/gB16rWP9AAAAA=
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1675944789; l=3275;
 i=borrello@diag.uniroma1.it; s=20221223; h=from:subject:message-id;
 bh=Rt31ZLPkz0Il+RYbul7rqebXsGaOcZtgeKkEtCXl6uI=;
 b=Us/h7LxyZhJwKTaIzLyY8wiVM+lEItqODOMjjFfYrAuRfjfTiSRPlOX47URMzZ5nyf3MaonPXmOn
 11ZOz3moCrQO4exnvXRc2Ze0hTysr+Kq96ggS/UBXPHEC2UyzkZy
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

Use list_is_first() to check whether tsp->asoc matches the first
element of ep->asocs, as the list is not guaranteed to have an entry.

Fixes: 8f840e47f190 ("sctp: add the sctp_diag.c file")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
---
Changes in v2:
- Use list_is_first()
- Link to v1: https://lore.kernel.org/r/20230208-sctp-filter-v1-1-84ae70d90091@diag.uniroma1.it
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
 net/sctp/diag.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index a557009e9832..c3d6b92dd386 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -343,11 +343,9 @@ static int sctp_sock_filter(struct sctp_endpoint *ep, struct sctp_transport *tsp
 	struct sctp_comm_param *commp = p;
 	struct sock *sk = ep->base.sk;
 	const struct inet_diag_req_v2 *r = commp->r;
-	struct sctp_association *assoc =
-		list_entry(ep->asocs.next, struct sctp_association, asocs);
 
 	/* find the ep only once through the transports by this condition */
-	if (tsp->asoc != assoc)
+	if (!list_is_first(&tsp->asoc->asocs, &ep->asocs))
 		return 0;
 
 	if (r->sdiag_family != AF_UNSPEC && sk->sk_family != r->sdiag_family)

---
base-commit: 4ec5183ec48656cec489c49f989c508b68b518e3
change-id: 20230208-sctp-filter-73453e659360

Best regards,
-- 
Pietro Borrello <borrello@diag.uniroma1.it>

