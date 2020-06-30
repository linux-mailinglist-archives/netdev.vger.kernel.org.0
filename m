Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC52B20EFA6
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 09:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731132AbgF3Hhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 03:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730979AbgF3Hhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 03:37:51 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA06DC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 00:37:51 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id o13so6586413pgf.0
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 00:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=/2x+x6/EXHMosj9/XKEHqgqlxb+0TqzXOMFNfOMaTKM=;
        b=suaWBpYToyJpb7X37v+crZ2f0J8XCJB67/FDLdmuiebnesu4lGTHXaUO7sSVgCSDho
         HpgaxVe9I7VDn1XyF4JBlmIJ+9bJz3rgVoXUACZMELwwKkjfvzBmWaeYWr18yzL5WTMX
         jXcZV45SeAjnxSiQccGgiO9fL8uUL35kKuf2O4P+k3B9rDb/91SFi56e0UQywm6O5BYW
         xjVY4PK3dOym7vI1vo+9yGYhYX6jtRBx0DuPbINnz/kYQ/Lt18xshLgZtlBh1Wiu7G8A
         Dk9Pw2tXXADzmm8MWSwkaBCxKrJgHintB13/YJqbcXQlfQF881uCYLVyH/jx9oAIbrUO
         abUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=/2x+x6/EXHMosj9/XKEHqgqlxb+0TqzXOMFNfOMaTKM=;
        b=Ma9EchdW8f2/cGju+nbJtDdJh1uFcToIUedXJFcMczazUYKShESqI41uBtWVOuU2J7
         cvvEvtt/bHVw4C3NK82D2umRdhn4H1pFz0DmpYvSTMzhiTNKk1GzkGSh19ew9TR/7Q2f
         QnPSikD+St7I5yOwtF0AkVL1n99/ysAmCfSxyhBgYILioffZlAaH4eacw98CovFklYMF
         dHt4yF7AMJH4X2pzN9QaoL2PChFEWKDwrxkXNCLNkSBA0B6nYvCDm0jairZvBhfulHR5
         HsKCTpeNulIfiqMVxRoXnxQcPjetJ4Qv8hq9h1crJxQsmRdUHtjphaA+Ss0j4prLbSOi
         aARg==
X-Gm-Message-State: AOAM532AptPOJOVFHaglV4cJ+jSGcj93TEfDbepayU47JgYrybL27kXk
        QEd/Jnaxe9MP6/KCnSW0J4rgmSTi
X-Google-Smtp-Source: ABdhPJxSCAMpjW556sMv8gSaUZwSCLBj6mRdhalJ8shCA9rAYJ0Fd5pv5G6fXmjdhw7mzwW09usrzA==
X-Received: by 2002:a63:7054:: with SMTP id a20mr13397226pgn.17.1593502671016;
        Tue, 30 Jun 2020 00:37:51 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d16sm1656484pfo.156.2020.06.30.00.37.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jun 2020 00:37:50 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCHv2 ipsec-next 08/10] ipcomp: assign if_id to child tunnel from parent tunnel
Date:   Tue, 30 Jun 2020 15:36:33 +0800
Message-Id: <088d28eeaf2ba1d7d24cd112a813c57583c5547b.1593502515.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <66b5ef2dc7245ab1707ca8119831e58c26a552a0.1593502515.git.lucien.xin@gmail.com>
References: <cover.1593502515.git.lucien.xin@gmail.com>
 <348f1f3d64495bde03a9ce0475f4fa7a34584e9c.1593502515.git.lucien.xin@gmail.com>
 <b660e1514219be1d3723c203c91b0a04974ddac9.1593502515.git.lucien.xin@gmail.com>
 <2bc9f58f60183a7148fad5d8bc954924f02374f8.1593502515.git.lucien.xin@gmail.com>
 <929721f47bfba5847e39897be8aa2d1620370592.1593502515.git.lucien.xin@gmail.com>
 <b29f04cd51bc17c22e6d34714afb3e4c17137e95.1593502515.git.lucien.xin@gmail.com>
 <1b18c11f965775fed2647eb78071af89177a70b5.1593502515.git.lucien.xin@gmail.com>
 <66b5ef2dc7245ab1707ca8119831e58c26a552a0.1593502515.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1593502515.git.lucien.xin@gmail.com>
References: <cover.1593502515.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The child tunnel if_id will be used for xfrm interface's lookup
when processing the IP(6)IP(6) packets in the next patches.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/ipcomp.c  | 1 +
 net/ipv6/ipcomp6.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/ipv4/ipcomp.c b/net/ipv4/ipcomp.c
index 59bfa38..b426832 100644
--- a/net/ipv4/ipcomp.c
+++ b/net/ipv4/ipcomp.c
@@ -72,6 +72,7 @@ static struct xfrm_state *ipcomp_tunnel_create(struct xfrm_state *x)
 	t->props.flags = x->props.flags;
 	t->props.extra_flags = x->props.extra_flags;
 	memcpy(&t->mark, &x->mark, sizeof(t->mark));
+	t->if_id = x->if_id;
 
 	if (xfrm_init_state(t))
 		goto error;
diff --git a/net/ipv6/ipcomp6.c b/net/ipv6/ipcomp6.c
index 99668bf..daef890 100644
--- a/net/ipv6/ipcomp6.c
+++ b/net/ipv6/ipcomp6.c
@@ -91,6 +91,7 @@ static struct xfrm_state *ipcomp6_tunnel_create(struct xfrm_state *x)
 	t->props.mode = x->props.mode;
 	memcpy(t->props.saddr.a6, x->props.saddr.a6, sizeof(struct in6_addr));
 	memcpy(&t->mark, &x->mark, sizeof(t->mark));
+	t->if_id = x->if_id;
 
 	if (xfrm_init_state(t))
 		goto error;
-- 
2.1.0

