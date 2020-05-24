Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2893E1E0153
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 20:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387868AbgEXSAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 14:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387766AbgEXSAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 14:00:14 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77800C061A0E
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 11:00:13 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id 19so17629077qtp.8
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 11:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=EWEch6lPeJPMBFVbdww5PgF/8BGENumPiEH0cXhUWQM=;
        b=vCZtBHVYyIThLehGMKu9fP5bRNhbU0v03UzjmCh2NhGMtKsvZ9d1l09hPBIrsDPIKD
         zsHGzX4Qi9rN8DSf1Hk3yWYJfdSaMLp9kVcJUEKDEyd0TfHZM0gMI5saHZsM+9/s97cG
         vYPQeMXlujC0X+xib/QgfLoyYle6cFEpOTmPVr3mBDY0e09qwqcFZo662KliN57vE6CE
         fDROwmWESfeVBoEY5tmWz/a9pPM7OLRTxNBRJy0Sk/hEAzNf/WJ4Ry3rO1WLt5RzpAoa
         gRXQwbfqI6tDVQ8M59ibWyNkapw9Vy139ezDUaOfBxeuJq84oFwq+wdasgYTNr6UQX08
         VSNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=EWEch6lPeJPMBFVbdww5PgF/8BGENumPiEH0cXhUWQM=;
        b=it5ndDtcRQErrd4VEQcDbZ+NLa+4fweb2ogxZ82q9rOcdG0+cogg5uihCz47RD2y6W
         cLVpME9oTAZOe4U7fopzKoqhpvfZn6NsKekTq1grf4POmJPyVnpSFc2M0Zen/RGLFl7b
         Ecs8NcmbGOap8eh6lLnB5q3Pv5fCNdD/HHV5e2ysCOVDVhAbSDz8YuVNl3OONmCsgp9U
         odRqmi2+X71lnCFU4hxSjgo6bEXs7qEsxmD87sGz0PB25Svmtn1e5EbtsUz5i2cN716i
         q7yqByGwG6QToZQNmY4nYWvyKVIpi24+2ztmMcXwIFX40MCCIizwGI1ZUiLsgdPnoY+5
         jMZQ==
X-Gm-Message-State: AOAM531OIjgDnXruNue3wXBswK2gXykAgaOrCwT+c+O0NLGU09YzWnVv
        xZJbW/H7fowG4Ph2mdpe9FOPh6kpx9cqfg==
X-Google-Smtp-Source: ABdhPJxFAbemuMpVyUYs+gm6wBGLIkn8/8oWRvJQUiwfbO6JDtIc39eU9CTwCmkcY6H/OYLFsr9QNmz5/oVBbQ==
X-Received: by 2002:a0c:f407:: with SMTP id h7mr12084403qvl.116.1590343212476;
 Sun, 24 May 2020 11:00:12 -0700 (PDT)
Date:   Sun, 24 May 2020 11:00:02 -0700
Message-Id: <20200524180002.148619-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH net-next] tcp: allow traceroute -Mtcp for unpriv users
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <maze@google.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unpriv users can use traceroute over plain UDP sockets, but not TCP ones.

$ traceroute -Mtcp 8.8.8.8
You do not have enough privileges to use this traceroute method.

$ traceroute -n -Mudp 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  192.168.86.1  3.631 ms  3.512 ms  3.405 ms
 2  10.1.10.1  4.183 ms  4.125 ms  4.072 ms
 3  96.120.88.125  20.621 ms  19.462 ms  20.553 ms
 4  96.110.177.65  24.271 ms  25.351 ms  25.250 ms
 5  69.139.199.197  44.492 ms  43.075 ms  44.346 ms
 6  68.86.143.93  27.969 ms  25.184 ms  25.092 ms
 7  96.112.146.18  25.323 ms 96.112.146.22  25.583 ms 96.112.146.26  24.502=
 ms
 8  72.14.239.204  24.405 ms 74.125.37.224  16.326 ms  17.194 ms
 9  209.85.251.9  18.154 ms 209.85.247.55  14.449 ms 209.85.251.9  26.296 m=
s^C

We can easily support traceroute over TCP, by queueing an error message
into socket error queue.

Note that applications need to set IP_RECVERR/IPV6_RECVERR option to
enable this feature, and that the error message is only queued
while in SYN_SNT state.

socket(AF_INET6, SOCK_STREAM, IPPROTO_IP) =3D 3
setsockopt(3, SOL_IPV6, IPV6_RECVERR, [1], 4) =3D 0
setsockopt(3, SOL_SOCKET, SO_TIMESTAMP_OLD, [1], 4) =3D 0
setsockopt(3, SOL_IPV6, IPV6_UNICAST_HOPS, [5], 4) =3D 0
connect(3, {sa_family=3DAF_INET6, sin6_port=3Dhtons(8787), sin6_flowinfo=3D=
htonl(0),
        inet_pton(AF_INET6, "2002:a05:6608:297::", &sin6_addr), sin6_scope_=
id=3D0}, 28) =3D -1 EHOSTUNREACH (No route to host)
recvmsg(3, {msg_name=3D{sa_family=3DAF_INET6, sin6_port=3Dhtons(8787), sin6=
_flowinfo=3Dhtonl(0),
        inet_pton(AF_INET6, "2002:a05:6608:297::", &sin6_addr), sin6_scope_=
id=3D0},
        msg_namelen=3D1024->28, msg_iov=3D[{iov_base=3D"`\r\337\320\0004\6\=
1&\7\370\260\200\231\16\27\0\0\0\0\0\0\0\0 \2\n\5f\10\2\227"..., iov_len=3D=
1024}],
        msg_iovlen=3D1, msg_control=3D[{cmsg_len=3D32, cmsg_level=3DSOL_SOC=
KET, cmsg_type=3DSO_TIMESTAMP_OLD, cmsg_data=3D{tv_sec=3D1590340680, tv_use=
c=3D272424}},
                                   {cmsg_len=3D60, cmsg_level=3DSOL_IPV6, c=
msg_type=3DIPV6_RECVERR}],
        msg_controllen=3D96, msg_flags=3DMSG_ERRQUEUE}, MSG_ERRQUEUE) =3D 1=
44

Suggested-by: Maciej =C5=BBenczykowski <maze@google.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
---
 net/ipv4/tcp_ipv4.c | 2 ++
 net/ipv6/tcp_ipv6.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 6c05f1ceb538cbb9981835440163485de2ccf716..900c6d154cbcf04fb09d71f1445=
d0723bcf3c409 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -573,6 +573,8 @@ int tcp_v4_err(struct sk_buff *icmp_skb, u32 info)
 		if (fastopen && !fastopen->sk)
 			break;
=20
+		ip_icmp_error(sk, skb, err, th->dest, info, (u8 *)th);
+
 		if (!sock_owned_by_user(sk)) {
 			sk->sk_err =3D err;
=20
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 413b3425ac66bd758bb83562efa955f277da90a5..01a6f5111a77b4397038bf4d40c=
c09a94e57408c 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -463,6 +463,8 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6=
_skb_parm *opt,
 		if (fastopen && !fastopen->sk)
 			break;
=20
+		ipv6_icmp_error(sk, skb, err, th->dest, ntohl(info), (u8 *)th);
+
 		if (!sock_owned_by_user(sk)) {
 			sk->sk_err =3D err;
 			sk->sk_error_report(sk);		/* Wake people up to see the error (see conne=
ct in sock.c) */
--=20
2.27.0.rc0.183.gde8f92d652-goog

