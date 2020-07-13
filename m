Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75EC721D091
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 09:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbgGMHnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 03:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbgGMHnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 03:43:12 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B692C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 00:43:12 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id l63so5658098pge.12
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 00:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=cYrn5Bfv+jEpWmHxo2r439RC/z0s/uzCMv12BRrgAWA=;
        b=JOa7GCumFIm46nVX+NC4U5YZEQVdoc1fNzohC51JzmhtXNSmy9yHhOAuCFEEtcixKZ
         iPIs0wDQTif2oJHe1UFPR8VnnMCYOhDg51FqDuH+t/m0Z4Y1ibJ7Q7Z7+Wwnq2kcsEOy
         o8tp7c6kIGOuPnY5vxuFFfTQ8s/Vl1B6em0jEQp6saNvx53SlZU5jhGS1Zv4e3KDRRDT
         Se75iKaPbxa0fD9g7wgmSIdpRA4f5pL94IqDp2e7H7WFUlRWlYz9HaUYihfRfAudPLvh
         gH5T+NdoBVMD8PLxIMmc6WZ1Jj03UUK7E1XWz9yLc4t6hxhiMjlpXAEi2p1e9syIOkWN
         CG/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=cYrn5Bfv+jEpWmHxo2r439RC/z0s/uzCMv12BRrgAWA=;
        b=CMgMG7WEewPwSw2UfT7j9dW9xasXMzNzqc43UIfGLIK7A5cnK79d4zG1j6SUU/cy0O
         tJeFr18e7ca+LryMsGoBPK4uguD+SsBgKPKvbrCCtUwH5yw8YT+pIsDwNqMFuuOT0gXm
         k7fAHjQqGQTHCaWwC//6oV/0rr+Qo0uqqat/uN3n0lX0ZiHHmVkhZh0+NtZ8skjMQR9O
         URxb9ylq0KY881u2mXGM37fS7TAhd5xHhXKuHr60F+jnGgGvR0vCrwKbnTJejf29uBPa
         AVqFjLcoJbfWBYBoRuIszj+mUirti05Bvk0YSlszm2c7MWw+ZTKxoMeKo6xSwSqD2egL
         DwGw==
X-Gm-Message-State: AOAM530JHFpRBzQ1j9cBWThmsxKK05ytFPlY5EliXVHhcezquflDU6el
        +ROr3Kla2l32vc6YFFhDKB9BRV0A
X-Google-Smtp-Source: ABdhPJypK/2TbQGnU2dLuPvSWyiU+Bqq3CCp0v5hf+SmyK3IbohodecYRU5Z8a6wDbwC5nT6XfdDnw==
X-Received: by 2002:a63:e556:: with SMTP id z22mr67254011pgj.130.1594626191745;
        Mon, 13 Jul 2020 00:43:11 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s6sm13146598pfd.20.2020.07.13.00.43.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Jul 2020 00:43:11 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 3/3] xfrm: interface: not xfrmi_ipv6/ipip_handler twice
Date:   Mon, 13 Jul 2020 15:42:38 +0800
Message-Id: <55bb83485a64f16f12af4fe57246e7416660f493.1594625993.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <46e40c0e3e7f2b2739720e3a6926293410d0fc7f.1594625993.git.lucien.xin@gmail.com>
References: <cover.1594625993.git.lucien.xin@gmail.com>
 <834afa201899677daeb9d0f33d34bca15bf45a19.1594625993.git.lucien.xin@gmail.com>
 <46e40c0e3e7f2b2739720e3a6926293410d0fc7f.1594625993.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1594625993.git.lucien.xin@gmail.com>
References: <cover.1594625993.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As we did in the last 2 patches for vti(6), this patch is to define a
new xfrm_tunnel object 'xfrmi_ipip6_handler' to register for AF_INET6,
and a new xfrm6_tunnel object 'xfrmi_ip6ip_handler' to register for
AF_INET.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/xfrm/xfrm_interface.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index a79eb49..5d50f1d 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -816,6 +816,13 @@ static struct xfrm6_tunnel xfrmi_ipv6_handler __read_mostly = {
 	.err_handler	=	xfrmi6_err,
 	.priority	=	-1,
 };
+
+static struct xfrm6_tunnel xfrmi_ip6ip_handler __read_mostly = {
+	.handler	=	xfrmi6_rcv_tunnel,
+	.cb_handler	=	xfrmi_rcv_cb,
+	.err_handler	=	xfrmi6_err,
+	.priority	=	-1,
+};
 #endif
 
 static struct xfrm4_protocol xfrmi_esp4_protocol __read_mostly = {
@@ -854,6 +861,13 @@ static struct xfrm_tunnel xfrmi_ipip_handler __read_mostly = {
 	.err_handler	=	xfrmi4_err,
 	.priority	=	-1,
 };
+
+static struct xfrm_tunnel xfrmi_ipip6_handler __read_mostly = {
+	.handler	=	xfrmi4_rcv_tunnel,
+	.cb_handler	=	xfrmi_rcv_cb,
+	.err_handler	=	xfrmi4_err,
+	.priority	=	-1,
+};
 #endif
 
 static int __init xfrmi4_init(void)
@@ -873,7 +887,7 @@ static int __init xfrmi4_init(void)
 	err = xfrm4_tunnel_register(&xfrmi_ipip_handler, AF_INET);
 	if (err < 0)
 		goto xfrm_tunnel_ipip_failed;
-	err = xfrm4_tunnel_register(&xfrmi_ipip_handler, AF_INET6);
+	err = xfrm4_tunnel_register(&xfrmi_ipip6_handler, AF_INET6);
 	if (err < 0)
 		goto xfrm_tunnel_ipip6_failed;
 #endif
@@ -897,7 +911,7 @@ static int __init xfrmi4_init(void)
 static void xfrmi4_fini(void)
 {
 #if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
-	xfrm4_tunnel_deregister(&xfrmi_ipip_handler, AF_INET6);
+	xfrm4_tunnel_deregister(&xfrmi_ipip6_handler, AF_INET6);
 	xfrm4_tunnel_deregister(&xfrmi_ipip_handler, AF_INET);
 #endif
 	xfrm4_protocol_deregister(&xfrmi_ipcomp4_protocol, IPPROTO_COMP);
@@ -922,7 +936,7 @@ static int __init xfrmi6_init(void)
 	err = xfrm6_tunnel_register(&xfrmi_ipv6_handler, AF_INET6);
 	if (err < 0)
 		goto xfrm_tunnel_ipv6_failed;
-	err = xfrm6_tunnel_register(&xfrmi_ipv6_handler, AF_INET);
+	err = xfrm6_tunnel_register(&xfrmi_ip6ip_handler, AF_INET);
 	if (err < 0)
 		goto xfrm_tunnel_ip6ip_failed;
 #endif
@@ -946,7 +960,7 @@ static int __init xfrmi6_init(void)
 static void xfrmi6_fini(void)
 {
 #if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
-	xfrm6_tunnel_deregister(&xfrmi_ipv6_handler, AF_INET);
+	xfrm6_tunnel_deregister(&xfrmi_ip6ip_handler, AF_INET);
 	xfrm6_tunnel_deregister(&xfrmi_ipv6_handler, AF_INET6);
 #endif
 	xfrm6_protocol_deregister(&xfrmi_ipcomp6_protocol, IPPROTO_COMP);
-- 
2.1.0

