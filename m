Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 313AF192BB4
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgCYPDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:03:45 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:36277 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbgCYPDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 11:03:43 -0400
Received: by mail-wr1-f43.google.com with SMTP id 31so3555394wrs.3
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 08:03:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KgHCs0fhXCN9bXYP/Wv/xykHCLjHG1gXBaVKVY3pwUk=;
        b=nW3aFWY3xVZ509K+2jSHFszTgJaqhHBWPgbhtvcYnIu20BeUxdcCtKmYF/ldLNgyWq
         hI7ou3HIGcJAg0CiqCmpEKApDLwLK4egNIWjiKXGGDersyKhmmMKeVGrKXdoS/PFecDw
         C7N4IQrYDiwceCUurHcrgpSiykkAwnFIHqrYrdiRWPGYh7/vZlz0iug1xu6ZHHt4MA3V
         6BrSOalLbKIVNGi0mb3uRpuTuK0SEWOCNKpmbKTflT8YBzFtrPtmZ+jKAFzbkS3AZC8y
         sfF8a9u/8YKM+IgwgNxB5yX+1hlqocba5d6dzndL+bwtrddcudafRxWw/j9xPLw86lQj
         AsoA==
X-Gm-Message-State: ANhLgQ22SXU9gfnH8QLSHdaWnXZ/Suc/Y+Uld7HP4ACS35iAhViyqlJw
        Yg+56p0HXFrUb9uSLlIJGnnKWzNS1+0=
X-Google-Smtp-Source: ADFU+vvxhxoj69B1ZOOvMxSwLRThEqPjDXKO3EoljOLfnQkTgWBhpgKffV4gTxrSu9QidZaVwzOezA==
X-Received: by 2002:a5d:4cc2:: with SMTP id c2mr4010350wrt.398.1585148620372;
        Wed, 25 Mar 2020 08:03:40 -0700 (PDT)
Received: from dontpanic.criteois.lan ([2a01:e35:243a:cf10:6bd:73a4:bc42:c458])
        by smtp.gmail.com with ESMTPSA id f12sm9569363wmh.4.2020.03.25.08.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 08:03:39 -0700 (PDT)
From:   William Dauchy <w.dauchy@criteo.com>
To:     netdev@vger.kernel.org
Cc:     William Dauchy <w.dauchy@criteo.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>, pshelar@nicira.com
Subject: [PATCH net] net, ip_tunnel: fix interface lookup with no key
Date:   Wed, 25 Mar 2020 16:03:04 +0100
Message-Id: <20200325150304.5506-1-w.dauchy@criteo.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

when creating a new ipip interface with no local/remote configuration,
the lookup is done with TUNNEL_NO_KEY flag, making it impossible to
match the new interface (only possible match being fallback or metada
case interface); e.g: `ip link add tunl1 type ipip dev eth0`

If we consider `key` being zero in ipip case, we might consider ok to
go through this last loop, and make it possible to match such interface.
In fact this is what is done when we create a gre interface without key
and local/remote.

context being on my side, I'm creating an extra ipip interface attached
to the physical one, and moving it to a dedicated namespace.

Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
Signed-off-by: William Dauchy <w.dauchy@criteo.com>
---
 net/ipv4/ip_tunnel.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 74e1d964a615..f6578bcadbed 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -142,9 +142,6 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
 			cand = t;
 	}
 
-	if (flags & TUNNEL_NO_KEY)
-		goto skip_key_lookup;
-
 	hlist_for_each_entry_rcu(t, head, hash_node) {
 		if (t->parms.i_key != key ||
 		    t->parms.iph.saddr != 0 ||
-- 
2.25.1

