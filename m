Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADA596DF65C
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 15:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjDLNDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 09:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjDLNDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 09:03:15 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E51A4EDD
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 06:03:10 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 85-20020a250b58000000b00b8f071f5062so8019595ybl.20
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 06:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681304589;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=taes8BYJjZPc9U0iN1DeNr6Fcbi/Nev444CdlhzzD5A=;
        b=bbBs0KKHVSQpukby4h7ktqUAZSymmnCFv9wXpBmz0pY/8FveI1HOvXzmjiGtwto37N
         WyyPNOLOzmCoeAD25VX3h56D/UwcH8Fjr/2KZOHGStY7o8mVARpo6Mg9brmeG5nybTAf
         4T6ToLWotyjmRxf0sjIWyQJ9FB41H/RXbmtK1uZqdfSUo7NiVm8yXN+YRVin2rp2xH+x
         GShh0ImNG6vQuvGWwwyC1jbK/5iPaBjSebMzOW44XsuO7ihw3fDpADyG8N/iU9HUvWga
         H5ZtYP3p7ScyIKjMvDd4pzAcZiThG2THt8O28HBFqBuWcD0wOuJrOb0tgv427CDEWAS8
         FRJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681304589;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=taes8BYJjZPc9U0iN1DeNr6Fcbi/Nev444CdlhzzD5A=;
        b=HWReFEHlRIium+b8QG0CmsHjeXT8lcweie7RxQamq068cysv7sUlWHKSgGgaCK1+8i
         qa/5OYEuj75lnLKjxMY29flnSZ2nqmXofPV1yisb7rqFCTv4lDiKL2eCsHb7lYqkVhnC
         sC3kP0msMrQgWL1DutRc7hm/XSYf5GWzhn4ZaxEzbAR6I5tGEIVSqdkA6bXrgH2iW1oj
         zzvvAAomndZqwDn0FOSTEHRZ+I2jNjeYzxiGmDS80z2nI/eL8B2Qz+1eofbvMPTESl4I
         LaxmiONYK6Hz7KEQI88tUhrkTNpSsXoBs0NzXwvXJRnVeUM30tSNSEt/QRXyF35vv48x
         NcbQ==
X-Gm-Message-State: AAQBX9djVMx7WDTJlXgCTcUJ6zvowLI5I5GzwrT7NJyVpF7cGK8Lo2Uw
        ZQuhyANfJuq24/1IT5KLNFcJi4avjhBiVg==
X-Google-Smtp-Source: AKy350aSmDGYsdck73mVZLNRh+K/a9PSx9jVqKOhJq9+lwdKCQ1CBnEM6jL2IFHzfB/kdgBcYTZIJ4Qp9KGTmA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:d705:0:b0:b6b:6a39:949c with SMTP id
 o5-20020a25d705000000b00b6b6a39949cmr6963293ybg.6.1681304589355; Wed, 12 Apr
 2023 06:03:09 -0700 (PDT)
Date:   Wed, 12 Apr 2023 13:03:08 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230412130308.1202254-1-edumazet@google.com>
Subject: [PATCH net] udp6: fix potential access to stale information
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        lena wang <lena.wang@mediatek.com>,
        "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <maze@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

lena wang reported an issue caused by udpv6_sendmsg()
mangling msg->msg_name and msg->msg_namelen, which
are later read from ____sys_sendmsg() :

	/*
	 * If this is sendmmsg() and sending to current destination address was
	 * successful, remember it.
	 */
	if (used_address && err >=3D 0) {
		used_address->name_len =3D msg_sys->msg_namelen;
		if (msg_sys->msg_name)
			memcpy(&used_address->name, msg_sys->msg_name,
			       used_address->name_len);
	}

udpv6_sendmsg() wants to pretend the remote address family
is AF_INET in order to call udp_sendmsg().

A fix would be to modify the address in-place, instead
of using a local variable, but this could have other side effects.

Instead, restore initial values before we return from udpv6_sendmsg().

Fixes: c71d8ebe7a44 ("net: Fix security_socket_sendmsg() bypass problem.")
Reported-by: lena wang <lena.wang@mediatek.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Maciej =C5=BBenczykowski <maze@google.com>
---
 net/ipv6/udp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 9fb2f33ee3a76a09bbe15a9aaf1371a804f91ee2..a675acfb901d102ce56563b1d50=
ae827d9e04859 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1395,9 +1395,11 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *ms=
g, size_t len)
 			msg->msg_name =3D &sin;
 			msg->msg_namelen =3D sizeof(sin);
 do_udp_sendmsg:
-			if (ipv6_only_sock(sk))
-				return -ENETUNREACH;
-			return udp_sendmsg(sk, msg, len);
+			err =3D ipv6_only_sock(sk) ?
+				-ENETUNREACH : udp_sendmsg(sk, msg, len);
+			msg->msg_name =3D sin6;
+			msg->msg_namelen =3D addr_len;
+			return err;
 		}
 	}
=20
--=20
2.40.0.577.gac1e443424-goog

