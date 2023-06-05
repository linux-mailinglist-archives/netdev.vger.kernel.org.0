Return-Path: <netdev+bounces-7906-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B56A7220AE
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:12:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95A151C20B5C
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 08:12:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C60A125C1;
	Mon,  5 Jun 2023 08:12:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C3011CB0
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:12:32 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E83AD
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 01:12:31 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-56552a72cfbso77640937b3.3
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 01:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685952750; x=1688544750;
        h=content-transfer-encoding:cc:to:from:subject:mime-version
         :message-id:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v3USJQbqy4WY77G9ocAAH0AJrN/3ge/XHLP/FBLIXcc=;
        b=WLfZMDmhxbqbutdz80HpacMBOj/U+5l14efYpWizYfP7Q6mC3kPt15ACL+HsoKY9j2
         SgoGQnhdNvLsROswQQeWMQbDalqhTlLFEnUr11vw6UCQXIVEs2Od1NFADgU7aJatZUpU
         5YGw2wBLueLrCtG40UZ55TGMya8EpCmpaVSBSojLAFZ+ITgu8kA2DeQkZ8nkM75/Pds9
         dcAPHMwQADva+bbNSrkLbZQmXZg3U6UixxR8C72V5DaH4I1iaqpV63nPKVA9ma3U113p
         4MTWRKqgnlohqQTWm3+ioVI609AuuTInt9gB/zJMuG715QEIQ+slmClIAQLWsECfZPfr
         hnVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685952750; x=1688544750;
        h=content-transfer-encoding:cc:to:from:subject:mime-version
         :message-id:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v3USJQbqy4WY77G9ocAAH0AJrN/3ge/XHLP/FBLIXcc=;
        b=CMyPeSUB2RSIdlsVDmmwj9FNtXrvyGfxcFl+VnWKJ/fLztfG1wptc+z3uwx2vHz/zS
         2CHIzIcBo1DrkBpxg67TuqLNA+JtOOEJujzot+XgXmGi/suz0CYOOoYZqAtptdUlz/pv
         bq6bxcZGBq7uHRbGKgrh8HaexkW0L6NCcYSvFew/E0xPt79J08rhT5qaIRtS8WaIQkeH
         xJ9ERwypit2Mv4oafo6537QxxEuTcQv4o04iAKQ12zNdNZnayflxBEDhBS8pzk5G1Nkw
         9Cww5XCS4WVwDxWenXGNsKdmK4vgbonqqrCPwPlBBQE/U8KDmZ2Kd5cAEsWKiSXlT6f4
         YMNg==
X-Gm-Message-State: AC+VfDyr85ZhncTAyVtV6Z/dB5VMN4MUkVClN1TkZeB1CvC3IYOMuo63
	l5JVsJ0Hi9fPsXSPcoUHdE1Cn8GP
X-Google-Smtp-Source: ACHHUZ6hAvVB5qGgHmAY3/JwppX+RnYm1l2IeurNoJCCxLbQdol2PiJ70FRb6HBPpiGUGasMZthPg96n
X-Received: from athina.mtv.corp.google.com ([2620:15c:211:200:e3e5:f2e0:6e3:c38b])
 (user=maze job=sendgmr) by 2002:a81:a889:0:b0:565:dc02:9bfa with SMTP id
 f131-20020a81a889000000b00565dc029bfamr3819601ywh.5.1685952750456; Mon, 05
 Jun 2023 01:12:30 -0700 (PDT)
Date: Mon,  5 Jun 2023 01:12:18 -0700
Message-Id: <20230605081218.113588-1-maze@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Subject: [PATCH] net: revert "align SO_RCVMARK required privileges with SO_MARK"
From: "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <maze@google.com>
To: "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <zenczykowski@gmail.com>
Cc: Linux Network Development Mailing List <netdev@vger.kernel.org>, 
	"=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <maze@google.com>, Eyal Birger <eyal.birger@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>, Patrick Rohr <prohr@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This reverts:
    commit 1f86123b97491cc2b5071d7f9933f0e91890c976
    net: align SO_RCVMARK required privileges with SO_MARK

    The commit referenced in the "Fixes" tag added the SO_RCVMARK socket
    option for receiving the skb mark in the ancillary data.

    Since this is a new capability, and exposes admin configured details
    regarding the underlying network setup to sockets, let's align the
    needed capabilities with those of SO_MARK.

This reasoning is not really correct:
  SO_RCVMARK is used for 'reading' incoming skb mark (via cmsg), as such
  it is more equivalent to 'getsockopt(SO_MARK)' which has no priv check
  and retrieves the socket mark, rather than 'setsockopt(SO_MARK) which
  sets the socket mark and does require privs.

  Additionally incoming skb->mark may already be visible if
  sysctl_fwmark_reflect and/or sysctl_tcp_fwmark_accept are enabled.

  Furthermore, it is easier to block the getsockopt via bpf
  (either cgroup setsockopt hook, or via syscall filters)
  then to unblock it if it requires CAP_NET_RAW/ADMIN.

On Android the socket mark is (among other things) used to store
the network identifier a socket is bound to.  Setting it is privileged,
but retrieving it is not.  We'd like unprivileged userspace to be able
to read the network id of incoming packets (where mark is set via iptables
[to be moved to bpf])...

An alternative would be to add another sysctl to control whether
setting SO_RCVMARK is privilged or not.
(or even a MASK of which bits in the mark can be exposed)
But this seems like over-engineering...

Note: This is a non-trivial revert, due to later merged:
  commit e42c7beee71d0d84a6193357e3525d0cf2a3e168
  bpf: net: Consider has_current_bpf_ctx() when testing capable() in sk_set=
sockopt()
which changed both 'ns_capable' into 'sockopt_ns_capable' calls.

Fixes: 1f86123b9749 ("align SO_RCVMARK required privileges with SO_MARK")
Cc: Eyal Birger <eyal.birger@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Patrick Rohr <prohr@google.com>
Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
---
 net/core/sock.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 24f2761bdb1d..6e5662ca00fe 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1362,12 +1362,6 @@ int sk_setsockopt(struct sock *sk, int level, int op=
tname,
 		__sock_set_mark(sk, val);
 		break;
 	case SO_RCVMARK:
-		if (!sockopt_ns_capable(sock_net(sk)->user_ns, CAP_NET_RAW) &&
-		    !sockopt_ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
-			ret =3D -EPERM;
-			break;
-		}
-
 		sock_valbool_flag(sk, SOCK_RCVMARK, valbool);
 		break;
=20
--=20
2.41.0.rc0.172.g3f132b7071-goog


