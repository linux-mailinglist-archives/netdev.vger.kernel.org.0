Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6290423DA55
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 14:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgHFM3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 08:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727028AbgHFLPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 07:15:35 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9EEC0617B1
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 04:06:47 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id c2so28977051edx.8
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 04:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=PYSsCrOysop+Sh0mOiJ6j1B4kZ/DvpynNkFjKlnFTtk=;
        b=RiFKf1ZDy1QYFqUEaD38cJSlgDMEp2uzQNfOQF28/kHkXz8nwtGrTxRXuMrcxIYUCW
         i2SyC7q4a+Hlfbov9p/707mge6kYnZcvbb5lGvpuhHnY31qyhnKNTbtuVD2yDg9qiOEk
         qNaAgDRhdrN8EJBFTY21+UBpZpx4oQr7+6Fvj9CXtFRbGci0z3mOdfwp0aC+9050chrZ
         LLwgUne6B29yqzjvBmLRuhX/PYNrfZXCRyh0YlNI+DC5W0JzExy464GxzNPr5wtaLEDz
         Gk7/o17kfdrVqw+JiskeC3yrY8gnyjlwl4LeYXXih14fnlWw37D7OPiB9aJpJevfHU86
         mDeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=PYSsCrOysop+Sh0mOiJ6j1B4kZ/DvpynNkFjKlnFTtk=;
        b=KjNckHMKWEo4QPLZxtN3+uxeFziDEQ0R2oPVMY64NGIclYD4PsLpMhZGA09Io5pJc0
         8QN5AWgsVaEGGI/0YfKQ7JkPG5DZqgFqRDyzIrwJevd8lTAiQ0EvYnrsLFixEUBGb0ke
         wF15jH38zr7S3f2RqNsTnPw5qE6N/L9Z//pC2x2O1QSvmLvwCSSl6bmGYZ3gDfuA3/Oi
         dms8D9kJg0K1AeM3/hwRZsGsRRMHaHbeT37lTrnTm+d5ZPlgqQ50yi+7hn2Wl1DQBb39
         wBkcQnKTfNadXAWdII+FLAQSBvJDgCu6Xb+xlS8wPQrm5UdixjKO+W2c5DZLPC7vYGUz
         7h+g==
X-Gm-Message-State: AOAM530KtBDpZgtBKKHSCdqQ3bMXzI+EFTTNmP8CnBpT4llX7gAtruax
        tpoR6Cq/qj1Dj+LDRNj46EBayQ3ql0HaLBdCz/f79VjLtLh2cHYB7Hx4/sgICPmJCfzyCx6Ki2w
        I0Ud81o2RmA==
X-Google-Smtp-Source: ABdhPJwLqyoWjwRDYILTF5e67AwRbZf7hhQrvTreE0IkPpokDMYDsXaFaI97KW0N6QvK5JTBtuHSbQ==
X-Received: by 2002:a05:6402:899:: with SMTP id e25mr3435126edy.311.1596712006085;
        Thu, 06 Aug 2020 04:06:46 -0700 (PDT)
Received: from tim.froidcoeur.net (ptr-7tznw15pracyli75x11.18120a2.ip6.access.telenet.be. [2a02:1811:50e:f0f0:d05d:939:f42b:f575])
        by smtp.gmail.com with ESMTPSA id v13sm3597682edl.9.2020.08.06.04.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 04:06:45 -0700 (PDT)
From:   Tim Froidcoeur <tim.froidcoeur@tessares.net>
To:     tim.froidcoeur@tessares.net,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Patrick McHardy <kaber@trash.net>,
        KOVACS Krisztian <hidden@balabit.hu>
Cc:     matthieu.baerts@tessares.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v2 2/2] net: initialize fastreuse on inet_inherit_port
Date:   Thu,  6 Aug 2020 13:06:31 +0200
Message-Id: <20200806110631.475855-3-tim.froidcoeur@tessares.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200806110631.475855-1-tim.froidcoeur@tessares.net>
References: <20200806110631.475855-1-tim.froidcoeur@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the case of TPROXY, bind_conflict optimizations for SO_REUSEADDR or
SO_REUSEPORT are broken, possibly resulting in O(n) instead of O(1) bind
behaviour or in the incorrect reuse of a bind.

the kernel keeps track for each bind_bucket if all sockets in the
bind_bucket support SO_REUSEADDR or SO_REUSEPORT in two fastreuse flags.
These flags allow skipping the costly bind_conflict check when possible
(meaning when all sockets have the proper SO_REUSE option).

For every socket added to a bind_bucket, these flags need to be updated.
As soon as a socket that does not support reuse is added, the flag is
set to false and will never go back to true, unless the bind_bucket is
deleted.

Note that there is no mechanism to re-evaluate these flags when a socket
is removed (this might make sense when removing a socket that would not
allow reuse; this leaves room for a future patch).

For this optimization to work, it is mandatory that these flags are
properly initialized and updated.

When a child socket is created from a listen socket in
__inet_inherit_port, the TPROXY case could create a new bind bucket
without properly initializing these flags, thus preventing the
optimization to work. Alternatively, a socket not allowing reuse could
be added to an existing bind bucket without updating the flags, causing
bind_conflict to never be called as it should.

Call inet_csk_update_fastreuse when __inet_inherit_port decides to create
a new bind_bucket or use a different bind_bucket than the one of the
listen socket.

Fixes: 093d282321da ("tproxy: fix hash locking issue when using port redirection in __inet_inherit_port()")
Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Tim Froidcoeur <tim.froidcoeur@tessares.net>
---
 net/ipv4/inet_hashtables.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 2bbaaf0c7176..006a34b18537 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -163,6 +163,7 @@ int __inet_inherit_port(const struct sock *sk, struct sock *child)
 				return -ENOMEM;
 			}
 		}
+		inet_csk_update_fastreuse(tb, child);
 	}
 	inet_bind_hash(child, tb, port);
 	spin_unlock(&head->lock);
-- 
2.25.1


-- 


Disclaimer: https://www.tessares.net/mail-disclaimer/ 
<https://www.tessares.net/mail-disclaimer/>


