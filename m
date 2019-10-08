Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36DFECF22C
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 07:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbfJHFfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 01:35:45 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44614 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729440AbfJHFfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 01:35:45 -0400
Received: by mail-pg1-f193.google.com with SMTP id u12so1296421pgb.11
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 22:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c+MlKA1m2tTZYnAFJCNrRzRYdNxkzCxs74AclVlGkzU=;
        b=b8+d0MjjwG+t4bUE2/q8+1v+mm99xqMe7LKLJ1vY8V8rYXtGH72miS7ndoFFeD1p1o
         XyDEjLSY/r0/vtDkxUnyieqSqntHMExRzoPaROtdgcEbUMKsSWtmpe9aLWY/cWs5ydEt
         u1r1NgkQ4RnuKT5DITsXQijdE+EVemcOEKHkU+uoqtEOxikSJgXCnDSMtY6RLLA/MjNN
         0PB4oTEYUe2/xDGliZWMAlvNtjRrqw7uc8GiAGsmvoFM4TIKEeLSkxojk9TVe63rb6od
         6tigkc9Ieac3ElzA40IE1aE+g9VfNF+kXr97lQEi22PQmgAEreCmWASPsGrIsXay8ujC
         sVBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c+MlKA1m2tTZYnAFJCNrRzRYdNxkzCxs74AclVlGkzU=;
        b=gG7MtB+8DM9uv73yjyf+vFeXbjHwKpIpfmy9E7Hmgw5I0HsZvOsCj57p1c9U9fTSs+
         pA04mggAvJEi1IhuFCE7Kz/bKOqmbFX8DYs1+P0OLRVRtqyqX9RFPvNz+Y4DyVogHIu5
         uF+nJZJxEUMhi4ih8ZwPJIwUNXXJ4IH6UxrZzXpNow2gBhiPPVAyhsPN2SBtFyF0ja27
         X+F2FM9LugdJoty6j8GAYTBuLD+MN1kl9buoKML4ciEnkdVRzBmKiTZNdhu5NHnneu3O
         24cEeK2/OrEjDPVx9F2zP4n5VUBDuU6GtClMQtQbuLkF7waIX2Y2Vx0FOttCh0ogqH69
         j6kQ==
X-Gm-Message-State: APjAAAUSyO91GVD9hS7dotOFPosjMHFIxY0OQtUq3+MBBp0Rva/NAXAv
        w3s6Kdqqe+jdNoUNSmx+Ucg=
X-Google-Smtp-Source: APXvYqykjhGkvNP9b6wFy6KiGhmTKhciRJkB5zQJEOfARUYma3T/t3pKNMz+BAkXkP3q3aOzuzmk6w==
X-Received: by 2002:a63:f852:: with SMTP id v18mr447750pgj.198.1570512944627;
        Mon, 07 Oct 2019 22:35:44 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id e9sm13806806pgs.86.2019.10.07.22.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 22:35:43 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2] netfilter: fix a memory leak in nf_conntrack_in
Date:   Mon,  7 Oct 2019 22:35:06 -0700
Message-Id: <20191008053507.252202-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 net/netfilter/nf_conntrack_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0c63120b2db2..35459d04a050 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1679,7 +1679,8 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 		if ((tmpl && !nf_ct_is_template(tmpl)) ||
 		     ctinfo == IP_CT_UNTRACKED) {
 			NF_CT_STAT_INC_ATOMIC(state->net, ignore);
-			return NF_ACCEPT;
+			ret = NF_ACCEPT;
+			goto out;
 		}
 		skb->_nfct = 0;
 	}
-- 
2.23.0.581.g78d2f28ef7-goog

