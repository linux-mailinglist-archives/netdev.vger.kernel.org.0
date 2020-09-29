Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F39127CFCE
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730318AbgI2Nt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728487AbgI2Nt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 09:49:27 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45DEC061755;
        Tue, 29 Sep 2020 06:49:27 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id k8so4613441pfk.2;
        Tue, 29 Sep 2020 06:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=jGFHohiLMKmOcbBELvAHtKl6/eKf2Rs4EotDZ5VjkE0=;
        b=ZkkNgOj71CzBiqwUx2PHMXjo+A7b+XwnHK/P0XlALa0bzJUKaqJ98/zbXF9OPFtgiJ
         ozAXkcmyHmyyJUF7CWb+3+Axpl6wze+7Vo9WOx7WEX8iTmzTnhvtioMkALMgR8nsGzsC
         uZ3u4iNJ975QRy2MlKhWCd6a5u9dEdZnx5R/Ow3RedlXm7BtMdpLbrIubrEe2nbzjz9a
         G14kdFiIZ/d3iWTtNUjQoHloUCXiYG9CZ2l6QJXqocBKU/zcm63uBB5jmN+mYWeJWOuj
         cGvgk2f4p4uhvGb/QkkbTnyIw+UV3HwmUafdnJKM+g9tT84qcQXNjS8tDfdND7iwN8es
         EpAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=jGFHohiLMKmOcbBELvAHtKl6/eKf2Rs4EotDZ5VjkE0=;
        b=lOiKS8AIUmJaDsTwUPZSaELO7Z6nGj+ELBOmW5Ht1EFL7eKB+uKrYP+pxl5HGQMhOi
         X30VB4xn75Cru9HgdC96ZwpjzgPiWTuojMcoLchO5E2AYJTDO1YifRF34KGCn6H/2Ut6
         UUou6KuO8L+LQzu3sU2MsFoXvHwClWhRLnVIqswU0a50ndRMe1tSU0cOr31QkYVH5pim
         SaT9q7HMYdG3/7VY/l7S5O4DLsDc5NCAl2FksLaN5OVp2U7vbZMICg+IEWBeWpJiQd9I
         3QwImCZWUS964Fr81uforaiWs4bfv2ob3430NAo0W68nFVAE2qGBYuY0uv52tFxmVboW
         3UpQ==
X-Gm-Message-State: AOAM530pqM0rOCtTskt41+X9lgWdPVcDHS8/ZcXAQ4zynVkUPMuJzdqY
        /QzskAlWP3MnAnfz3t/fGFrmDoDVfkk=
X-Google-Smtp-Source: ABdhPJzC4hQYvDoZWetKVnRMIS2puis0AMvfyEcfImrXwhQXsPUPSYYB2RTuvwtBUSd6quLanPqKCQ==
X-Received: by 2002:a17:902:9041:b029:d0:cc02:8540 with SMTP id w1-20020a1709029041b02900d0cc028540mr4425386plz.41.1601387366744;
        Tue, 29 Sep 2020 06:49:26 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p4sm4849238pju.29.2020.09.29.06.49.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2020 06:49:24 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem@davemloft.net
Subject: [PATCH net-next 01/15] udp: check udp sock encap_type in __udp_lib_err
Date:   Tue, 29 Sep 2020 21:48:53 +0800
Message-Id: <51c1fdad515076f3014476711aec1c0a81c18d36.1601387231.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a chance that __udp4/6_lib_lookup() returns a udp encap
sock in __udp_lib_err(), like the udp encap listening sock may
use the same port as remote encap port, in which case it should
go to __udp4/6_lib_err_encap() for more validation before
processing the icmp packet.

This patch is to check encap_type in __udp_lib_err() for the
further validation for a encap sock.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/udp.c | 2 +-
 net/ipv6/udp.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 09f0a23..ca04a8a 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -702,7 +702,7 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
 	sk = __udp4_lib_lookup(net, iph->daddr, uh->dest,
 			       iph->saddr, uh->source, skb->dev->ifindex,
 			       inet_sdif(skb), udptable, NULL);
-	if (!sk) {
+	if (!sk || udp_sk(sk)->encap_type) {
 		/* No socket for error: try tunnels before discarding */
 		sk = ERR_PTR(-ENOENT);
 		if (static_branch_unlikely(&udp_encap_needed_key)) {
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 29d9691..cde9b88 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -560,7 +560,7 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 
 	sk = __udp6_lib_lookup(net, daddr, uh->dest, saddr, uh->source,
 			       inet6_iif(skb), inet6_sdif(skb), udptable, NULL);
-	if (!sk) {
+	if (!sk || udp_sk(sk)->encap_type) {
 		/* No socket for error: try tunnels before discarding */
 		sk = ERR_PTR(-ENOENT);
 		if (static_branch_unlikely(&udpv6_encap_needed_key)) {
-- 
2.1.0

