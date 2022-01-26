Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9134549D316
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 21:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiAZUFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 15:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiAZUF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 15:05:28 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42907C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 12:05:28 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id j10so351949pgc.6
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 12:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hgYixXVaEt0zIEePBIk0CJaBxJU1H5Lp5r02IoH5IRo=;
        b=BzINxNmJM3Datd6DC5KxwVDRJky6DDshBPBvLPfN8VQ+cllN1Grm6KJXFDZ0km28Yd
         8PuBdy8jNCHt9bl5DnqfxpLZ8VLEMY6ZYXpJ6sKG27mEb7J3t1RSCQTbpH4rXWU+Fxcz
         PBsMlg0M5b2LtitVLZZWkA75/CWNVJ+5ILTkek/aVgIHUKE0jZx+qBnOwdGwLUqFP9x1
         dRfyiy6ihiVExYur61LhELLUSBnhb5Whb8b/zDYM4XTWJZuPtQUjX6R0S8n4vEaZecS3
         Uv/o/I39IRjKTcb/tBUc3Ex5Sf9gMuNGs1AUbx5+dWZAoL9pO8Gpq7E0SYbBB6AOmGs6
         Z/uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hgYixXVaEt0zIEePBIk0CJaBxJU1H5Lp5r02IoH5IRo=;
        b=Y/wad/pXPUgJJPeSLfty693LbGUsjJFkxA9OqVSdt38uEZolrW8rHnJlUPvkIHAN/E
         zFHWco5KXOZ6Gxvu6r0NrOBzJR8FrLbD18Ca0oZduVfnAmcL11d62eHGlbA9LJTxxn46
         F7yHPQacq61ZgWrneVw9FzpxPPSAWWxFggBjKCeGgssqUv9NzkaGKgWP5dajsHx4iyTj
         7j7UAthd45qshxCKsmtaCmm3M4qZr/EG9X8rVLhqo/7DOtXntGKsXPMlZTYiFOrRGLKq
         yRsYSkqOYLNaGHFsRkKGrFEC2kWI58k+gq/BP+S4a0yU3v9DmEmk93KBDOw8a4ddT5vd
         9KPw==
X-Gm-Message-State: AOAM531cbWGZUC8fiBdVkFGX7r+lpVl0BO+VHnfi7BM3NlraAwz07HiO
        k4MrppvTbjwYB+/RvdkX5xY=
X-Google-Smtp-Source: ABdhPJwcE7/ssoxEfrFJxEUgIoIz5f8Tn/EKXz8bx1pa1UpVYlh0l3PGec9jn1WZ3USrjT4Ai4uUsg==
X-Received: by 2002:a63:4e1f:: with SMTP id c31mr397271pgb.398.1643227527835;
        Wed, 26 Jan 2022 12:05:27 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:cfcb:2c25:b567:59da])
        by smtp.gmail.com with ESMTPSA id s8sm2708497pfw.158.2022.01.26.12.05.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 12:05:27 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ray Che <xijiache@gmail.com>,
        Geoff Alexander <alexandg@cs.unm.edu>, Willy Tarreau <w@1wt.eu>
Subject: [PATCH net 1/2] ipv4: tcp: send zero IPID in SYNACK messages
Date:   Wed, 26 Jan 2022 12:05:17 -0800
Message-Id: <20220126200518.990670-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
In-Reply-To: <20220126200518.990670-1-eric.dumazet@gmail.com>
References: <20220126200518.990670-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

In commit 431280eebed9 ("ipv4: tcp: send zero IPID for RST and
ACK sent in SYN-RECV and TIME-WAIT state") we took care of some
ctl packets sent by TCP.

It turns out we need to use a similar strategy for SYNACK packets.

By default, they carry IP_DF and IPID==0, but there are ways
to ask them to use the hashed IP ident generator and thus
be used to build off-path attacks.
(Ref: Off-Path TCP Exploits of the Mixed IPID Assignment)

One of this way is to force (before listener is started)
echo 1 >/proc/sys/net/ipv4/ip_no_pmtu_disc

Another way is using forged ICMP ICMP_FRAG_NEEDED
with a very small MTU (like 68) to force a false return from
ip_dont_fragment()

In this patch, ip_build_and_send_pkt() uses the following
heuristics.

1) Most SYNACK packets are smaller than IPV4_MIN_MTU and therefore
can use IP_DF regardless of the listener or route pmtu setting.

2) In case the SYNACK packet is bigger than IPV4_MIN_MTU,
we use prandom_u32() generator instead of the IPv4 hashed ident one.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Ray Che <xijiache@gmail.com>
Cc: Geoff Alexander <alexandg@cs.unm.edu>
Cc: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/ip_output.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index e331c8d4e6cfc4f2199a7877d8257b3b3b519561..6529484e8a36e1d9aef942879a5d2d18cecf2dc9 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -162,12 +162,19 @@ int ip_build_and_send_pkt(struct sk_buff *skb, const struct sock *sk,
 	iph->daddr    = (opt && opt->opt.srr ? opt->opt.faddr : daddr);
 	iph->saddr    = saddr;
 	iph->protocol = sk->sk_protocol;
-	if (ip_dont_fragment(sk, &rt->dst)) {
+	/* Do not bother generating IPID for small packets (eg SYNACK) */
+	if (skb->len <= IPV4_MIN_MTU || ip_dont_fragment(sk, &rt->dst)) {
 		iph->frag_off = htons(IP_DF);
 		iph->id = 0;
 	} else {
 		iph->frag_off = 0;
-		__ip_select_ident(net, iph, 1);
+		/* TCP packets here are SYNACK with fat IPv4/TCP options.
+		 * Avoid using the hashed IP ident generator.
+		 */
+		if (sk->sk_protocol == IPPROTO_TCP)
+			iph->id = prandom_u32();
+		else
+			__ip_select_ident(net, iph, 1);
 	}
 
 	if (opt && opt->opt.optlen) {
-- 
2.35.0.rc0.227.g00780c9af4-goog

