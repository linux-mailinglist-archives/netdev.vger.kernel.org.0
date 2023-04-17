Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E13956E5202
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 22:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjDQUoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 16:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjDQUoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 16:44:18 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946D9422E
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 13:44:17 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54fba72c1adso117748757b3.18
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 13:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681764257; x=1684356257;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PqlM60o+rRzKZJOcZ2/h8B9aGVSXuYUPI8EMIR6gtwA=;
        b=ouKHkBJH2vt0l79UQdYY6LbxNJ5z/pet2yM0l831S6FhN6a41dllRh7e4MB6LRBEkD
         dDJ9+cCAzjCnV6lXeJ6KvDDnOCu+VVfQ3YSSlUflNLkWL6J/fUGoKwOk7EDSOMPqBi4G
         WPv8p251sy3h3zFWvtUMQDS9Qt9dE44YoT73wpJE0jQ0bdTH7PxLN2WnWW282IPC//9p
         nZqJJaVf6korW9ou60hOPXbFCbOD79Y6/7kQrqn01vQhkf8wXA/xjO59fdl0rZvtr0zj
         uGDY+TT4napbwOOQ/9CqvrtSn1sfT0nwccFtVLCXNwrmjVonPWP1S0ffYAyLQ0LNwBGx
         eGRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681764257; x=1684356257;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PqlM60o+rRzKZJOcZ2/h8B9aGVSXuYUPI8EMIR6gtwA=;
        b=Ra5/rb9YM1FtFwks72kI7lxjrTX6z5qaqGNWIpijGTglaHBLmDvisr+OSxbuwwAfTQ
         Gw+QD5i+puR2BCcj4SiyqgrozOmOBs2k0KttHz/brqamRRFFDjrUCZCEQUhNZWRo7zZD
         6r1Z2ZXMGC1VAxYjidWYATdnsq4n7Rrl379P469Yi9qku0LKAWO+A9xxyuZtzP535EOR
         CYJ1ZQjin70uwr/yAk0RLvh0O/e0gBmcjh6mvCQupxc6ydoYG9AWst2bftcBukOd7d++
         dxRFBgUknV1diXprqGct9uVhADFKoJNNiOo1cY/7UpaanSmDIL/6Xu0Gb+wrWVGwqH7V
         wRpw==
X-Gm-Message-State: AAQBX9eyyC5CIXF+qYcwwnCCwIMO1mp1xLH3YLGZ0bs0xUcgvtDCidg+
        kOWCY593hAS71HDzyHR/N4qh7qQUJLGv/J7pCTXntdByEa5YNHl+yt42yLNgqpbfXmenFmgmqZ+
        FwYIxMLiYi8+anWduc8/18pWS4L6A9iAcLK66sEgGbQGrXB26TSyUOvXLm1mfzG3+
X-Google-Smtp-Source: AKy350bSSqVoInXqkKn5wjDXCMQNg9TgwX/WCrfBJPM1eqAEUKdm2Hwpg2GHkQkOZGtBx2erl4Bo1b/Inmgx
X-Received: from coldfire.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:b34])
 (user=maheshb job=sendgmr) by 2002:a81:4420:0:b0:54f:9364:608f with SMTP id
 r32-20020a814420000000b0054f9364608fmr9708082ywa.2.1681764256710; Mon, 17 Apr
 2023 13:44:16 -0700 (PDT)
Date:   Mon, 17 Apr 2023 13:44:07 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230417204407.2463297-1-maheshb@google.com>
Subject: [PATCH next] ipv6: add icmpv6_error_anycast_as_unicast for ICMPv6
From:   Mahesh Bandewar <maheshb@google.com>
To:     Netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Mahesh Bandewar <maheshb@google.com>,
        "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <maze@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ICMPv6 error packets are not sent to the anycast destinations and this
prevents things like traceroute from working. So create a setting similar
to ECHO when dealing with Anycast sources (icmpv6_echo_ignore_anycast).

Signed-off-by: Mahesh Bandewar <maheshb@google.com>
CC: Maciej =C5=BBenczykowski <maze@google.com>
---
 Documentation/networking/ip-sysctl.rst |  7 +++++++
 include/net/netns/ipv6.h               |  1 +
 net/ipv6/af_inet6.c                    |  1 +
 net/ipv6/icmp.c                        | 13 +++++++++++--
 4 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/network=
ing/ip-sysctl.rst
index 87dd1c5283e6..e97896d38e9f 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2719,6 +2719,13 @@ echo_ignore_anycast - BOOLEAN
=20
 	Default: 0
=20
+error_anycast_as_unicast - BOOLEAN
+	If set non-zero, then the kernel will respond with ICMP Errors
+	resulting from requests sent to it over the IPv6 protocol destined
+	to anycast address essentially treating anycast as unicast.
+
+	Default: 0
+
 xfrm6_gc_thresh - INTEGER
 	(Obsolete since linux-4.14)
 	The threshold at which we will start garbage collecting for IPv6
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index b4af4837d80b..3cceb3e9320b 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -55,6 +55,7 @@ struct netns_sysctl_ipv6 {
 	u64 ioam6_id_wide;
 	bool skip_notify_on_dev_down;
 	u8 fib_notify_on_flag_change;
+	u8 icmpv6_error_anycast_as_unicast;
 };
=20
 struct netns_ipv6 {
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 38689bedfce7..2b7ac752afc2 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -952,6 +952,7 @@ static int __net_init inet6_net_init(struct net *net)
 	net->ipv6.sysctl.icmpv6_echo_ignore_all =3D 0;
 	net->ipv6.sysctl.icmpv6_echo_ignore_multicast =3D 0;
 	net->ipv6.sysctl.icmpv6_echo_ignore_anycast =3D 0;
+	net->ipv6.sysctl.icmpv6_error_anycast_as_unicast =3D 0;
=20
 	/* By default, rate limit error messages.
 	 * Except for pmtu discovery, it would break it.
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index f32bc98155bf..db2aef50fdf5 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -362,9 +362,10 @@ static struct dst_entry *icmpv6_route_lookup(struct ne=
t *net,
=20
 	/*
 	 * We won't send icmp if the destination is known
-	 * anycast.
+	 * anycast unless we need to treat anycast as unicast.
 	 */
-	if (ipv6_anycast_destination(dst, &fl6->daddr)) {
+	if (!net->ipv6.sysctl.icmpv6_error_anycast_as_unicast &&
+	    ipv6_anycast_destination(dst, &fl6->daddr)) {
 		net_dbg_ratelimited("icmp6_send: acast source\n");
 		dst_release(dst);
 		return ERR_PTR(-EINVAL);
@@ -1192,6 +1193,13 @@ static struct ctl_table ipv6_icmp_table_template[] =
=3D {
 		.mode		=3D 0644,
 		.proc_handler =3D proc_do_large_bitmap,
 	},
+	{
+		.procname	=3D "error_anycast_as_unicast",
+		.data		=3D &init_net.ipv6.sysctl.icmpv6_error_anycast_as_unicast,
+		.maxlen		=3D sizeof(u8),
+		.mode		=3D 0644,
+		.proc_handler =3D proc_dou8vec_minmax,
+	},
 	{ },
 };
=20
@@ -1209,6 +1217,7 @@ struct ctl_table * __net_init ipv6_icmp_sysctl_init(s=
truct net *net)
 		table[2].data =3D &net->ipv6.sysctl.icmpv6_echo_ignore_multicast;
 		table[3].data =3D &net->ipv6.sysctl.icmpv6_echo_ignore_anycast;
 		table[4].data =3D &net->ipv6.sysctl.icmpv6_ratemask_ptr;
+		table[5].data =3D &net->ipv6.sysctl.icmpv6_error_anycast_as_unicast;
 	}
 	return table;
 }
--=20
2.40.0.634.g4ca3ef3211-goog

