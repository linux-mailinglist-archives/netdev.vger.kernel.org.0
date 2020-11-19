Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87912B9CF0
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 22:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgKSVYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 16:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgKSVYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 16:24:02 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D75C0613CF;
        Thu, 19 Nov 2020 13:24:01 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id l2so7006330qkf.0;
        Thu, 19 Nov 2020 13:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=UWiJFAJrRJVWOtvz3wQUC/wgiDj3DblZKCOoxZM1/OA=;
        b=BJzEYI/mMICjxog5etBiXoSf7SSV9DPZ2MzTyjv4JP0o3OA19AT9XxwtQoo7CNhmFQ
         LiaZBJHGCsaBbQPgmKFjGi3EFzWFr7up1/bLlciQYtPD6RA/8eQrDs8lCk25s/I9lh7W
         loR2CbDQOboARDv/CMzrIxA6DFNKxv8z6NPFKSl672LiwdXnBYQ80mkfdGWAtNWqcWT7
         sHgju+RgZRGb9OQApWTu8aBh4YSvnCAy2z0Ee+ARUhqKJX4meq6/W8V+v88Tvj3uF87s
         JD8TuAkyTAqN1ynSpMDUmb9qXHkXLkdFKnbZnvyZHpw6lt5SSU1V5ea7HO0G95xEDk+b
         sSQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=UWiJFAJrRJVWOtvz3wQUC/wgiDj3DblZKCOoxZM1/OA=;
        b=TANJJ8RVeMYzhaMwMiP1pGGhLf4SIjfHqWc0A0w30tWmzlZtNZ3JvlU51T1/tDc+yv
         V8GkLLeQOnNtSog3MthP7yXjFU4cyS5rD4NIDWthNH5AlNtvFv68mpVQsfsw2eAfuME3
         hocXoWeua6SWan6pEVt2X62H/rWhry5L2occdynj1PYJsqTQZUo+NBQNntSjQyFkQ2en
         Y7K8X+pj3e5lhNe+aapjJEZRDadAEPkU6maWU5eFbBPDKb3JLBRd6yfojX57z+DnDHhW
         ylf7gE7bmPaU6lYqEHpZXRPoc/vEv8Xa+tiSnjP0OkdOrtQ/3KUSmNg8AT5F40TCKXbt
         dQQQ==
X-Gm-Message-State: AOAM533IZy3UAoJC5U/1oSf5K2LhzPx1+ocTBp0G96REUMPCK9Z/wQdx
        1x0G8m49tY1PyCvfdp6J0dtzaIgZuX9X0w==
X-Google-Smtp-Source: ABdhPJye3QjQ+8rVvFwp+gyIPgPH38isUS6n34m3zyGsUaGeu6XeK/A20Pi/TpriGt3N0IKpOBxHHw==
X-Received: by 2002:a37:793:: with SMTP id 141mr12835577qkh.462.1605821040873;
        Thu, 19 Nov 2020 13:24:00 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id x72sm766124qkb.90.2020.11.19.13.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 13:24:00 -0800 (PST)
Subject: [net PATCH 2/2] tcp: Set INET_ECN_xmit configuration in
 tcp_reinit_congestion_control
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net, kafai@fb.com,
        kernel-team@fb.com, edumazet@google.com, brakmo@fb.com,
        alexanderduyck@fb.com, weiwan@google.com
Date:   Thu, 19 Nov 2020 13:23:58 -0800
Message-ID: <160582103862.66684.1529849392380485857.stgit@localhost.localdomain>
In-Reply-To: <160582070138.66684.11785214534154816097.stgit@localhost.localdomain>
References: <160582070138.66684.11785214534154816097.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

When setting congestion control via a BPF program it is seen that the
SYN/ACK for packets within a given flow will not include the ECT0 flag. A
bit of simple printk debugging shows that when this is configured without
BPF we will see the value INET_ECN_xmit value initialized in
tcp_assign_congestion_control however when we configure this via BPF the
socket is in the closed state and as such it isn't configured, and I do not
see it being initialized when we transition the socket into the listen
state. The result of this is that the ECT0 bit is configured based on
whatever the default state is for the socket.

Any easy way to reproduce this is to monitor the following with tcpdump:
tools/testing/selftests/bpf/test_progs -t bpf_tcp_ca

Without this patch the SYN/ACK will follow whatever the default is. If dctcp
all SYN/ACK packets will have the ECT0 bit set, and if it is not then ECT0
will be cleared on all SYN/ACK packets. With this patch applied the SYN/ACK
bit matches the value seen on the other packets in the given stream.

Fixes: 91b5b21c7c16 ("bpf: Add support for changing congestion control")
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 net/ipv4/tcp_cong.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index db47ac24d057..563d016e7478 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -198,6 +198,11 @@ static void tcp_reinit_congestion_control(struct sock *sk,
 	icsk->icsk_ca_setsockopt = 1;
 	memset(icsk->icsk_ca_priv, 0, sizeof(icsk->icsk_ca_priv));
 
+	if (ca->flags & TCP_CONG_NEEDS_ECN)
+		INET_ECN_xmit(sk);
+	else
+		INET_ECN_dontxmit(sk);
+
 	if (!((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
 		tcp_init_congestion_control(sk);
 }


