Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1A345AF20
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 23:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235266AbhKWWf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 17:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbhKWWfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 17:35:25 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B475C061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 14:32:17 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id h63so333997pgc.12
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 14:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9nt1VLkNH7jukWHnwaKvka7/LA0NVJcVbkCutBEosqg=;
        b=AEwwB39WJkYMOizV7JbvnG1ENaMqleBgH2G7EHawqKURBIgYgsWPV8vA4FAcFEgE1R
         QdHx5MkmpVtxemehn7VpULnUrqgWRnE5pY4rOvLRP/KmEclBUQNuB84tLdLpFXpbT2J6
         y3+MPz+BQI2zhryuu5UyteXTNqKUspw+ormy3dQWs9/a6Ka6j5fTrH2OMlrqM4b6iXpG
         AI5eJ6umIcvl9Bf/3Y+CAlaWdPwoCzPP7r8uwHh+QrJZ11mZczrdDvEeGt9+11bseSQu
         mHmiYA++AEs3qg78eS17Y/w3Of7yjiB3KuNbDfUZs0HqwiWHKyu7PbK909kB8hE3cmAs
         km4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9nt1VLkNH7jukWHnwaKvka7/LA0NVJcVbkCutBEosqg=;
        b=qpQ07nBLLYfmwBeS4NhjliEGpg864G7j0cH5PLppCTjPkyzNi1M5ILpVO+AjgAUyiF
         o3BUlrDNhK4oMRlgOkXn/5OsaaC5/M38fwdu+wdY10ROE+QZ8f44fOhM8XsU/UWyGNIb
         BmlT5GAxSYjtQUZT3Nwn5eO25QpIRW3liWGGn/DM08VgSmSmd+g1nF11AXP6Vq7yOaxt
         twUnhqfkWS10Hlku+zzBUqRvJyUvtXvHhjm/Fp9x6zTZo0grczmR8FVbs7a7Ge1qNYqt
         EK1gsihthWa6sI/YRVAHzQHT8EwSxJCa2inrjdFyCtfti7deyds1DlLkRfF29MdDoh1i
         qQvA==
X-Gm-Message-State: AOAM531aJLZqOkaUXKmA7gWXgd6jFLDOst775LJ4XIgW248812MmxT+l
        VNYCpWLPToLqWJwOIHuHJBOTDlU/66T9tg==
X-Google-Smtp-Source: ABdhPJzN+rIUX2geX2wx8CWq6bI0JUYdSd6B42t4dDvcE3hS/nLuxShTK+DfXHKXDkM9DK7sg4+9nQ==
X-Received: by 2002:a63:874a:: with SMTP id i71mr6384628pge.81.1637706736814;
        Tue, 23 Nov 2021 14:32:16 -0800 (PST)
Received: from athina.mtv.corp.google.com ([2620:15c:211:200:cd70:5ac2:9066:1bb8])
        by smtp.gmail.com with ESMTPSA id q17sm14921335pfu.117.2021.11.23.14.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 14:32:16 -0800 (PST)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH] net-ipv6: changes to ->tclass (via IPV6_TCLASS) should sk_dst_reset()
Date:   Tue, 23 Nov 2021 14:32:08 -0800
Message-Id: <20211123223208.1117871-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This is to match ipv4 behaviour, see __ip_sock_set_tos()
implementation.

Technically for ipv6 this might not be required because normally we
do not allow tclass to influence routing, yet the cli tooling does
support it:

lpk11:~# ip -6 rule add pref 5 tos 45 lookup 5
lpk11:~# ip -6 rule
5:      from all tos 0x45 lookup 5

and in general dscp/tclass based routing does make sense.

We already have cases where dscp can affect vlan priority and/or
transmit queue (especially on wifi).

So let's just make things match.  Easier to reason about and no harm.

Cc: Eric Dumazet <edumazet@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 net/ipv6/ipv6_sockglue.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 204b0b4d10c8..3a66f2394b82 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -603,7 +603,10 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 			val &= ~INET_ECN_MASK;
 			val |= np->tclass & INET_ECN_MASK;
 		}
-		np->tclass = val;
+		if (np->tclass != val) {
+			np->tclass = val;
+			sk_dst_reset(sk);
+		}
 		retv = 0;
 		break;
 
-- 
2.34.0.rc2.393.gf8c9666880-goog

