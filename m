Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 154E64A5761
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 07:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbiBAGw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 01:52:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233800AbiBAGw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 01:52:59 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4470C061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 22:52:58 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id c3so14626981pls.5
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 22:52:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sfT02dMqmRPeDYcfBW4Ot6Mw3ohaVZKOvepx1gDsRC8=;
        b=ILrrhmkTDlch0ybz09BtmP88ZLA75l+bjsC/C/ImUq6zbir2eW/4JxF1EtHZ54fEDL
         X8x54e7HKruzdFB+5Ar8SC/gZnO+xSTlk10P1WQ64YzG1SF0xCDZEhvVGlnVHU8/y+C9
         SRktLFzzkTJo+xEZt32sWAp0+577BYTz1hGB1vdjkhNjxgbWiZzs11ew1x8j/TzXYQfq
         GRG5xeys7tWhFpIuYmeJIGbx1wTRrS0qmQuMfzRRY3cPpzBvz7GilJJIcm0mfBbSIiUF
         ZDVqUaX3dkn1pCgBFIikCCVCA00COOB8DAz+/5aWuMjOGb4b+IAbLEBTbEMZWoV+DCrM
         NYkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sfT02dMqmRPeDYcfBW4Ot6Mw3ohaVZKOvepx1gDsRC8=;
        b=1uk76l9iJOFwlaUgh0bF1MTMjpb1yaNvFtpYeu2KF5u3D42Z58qWSuNuIDDaR5DtiV
         M4bcgRhqaE+/ZPQSUV+q5vyTdMaRPqtmp1dBBjKE8HAw/k9lXnYe61Usn+0xveyDZf74
         Uk+n+hjpqBfNYXgAagwZcnxQvdblOzj9V908RJXBy8g3GBbWsae5rjSul4/c3FkMc7WL
         4Xp+cnt1Zmxkn9FPD75I5T9+AnOgxANTnXj69FBF5nvVijXbMYfjoE7BMxEBQiDxJgYs
         zD+9ul8TDVGTQk75Q/h+mykl51+WPkRKDav8TLrRQtVwn0iOC/dyrVtsejy0cpzt7/EY
         RtQA==
X-Gm-Message-State: AOAM531lOWJfjyCHPPhOhI8hV/BbUBYgqffyKuBZH5TxEeHCDV+R5si3
        kVJSDkZY/IADZbfter0rTfc=
X-Google-Smtp-Source: ABdhPJyzAAcxrt+U5W8UtcWI+WCyX4Q8ERSUrT5w+PmBlZWPrG8218xOzjsZpHqg+X20pD0er6lmTA==
X-Received: by 2002:a17:902:7e83:: with SMTP id z3mr20884502pla.122.1643698378478;
        Mon, 31 Jan 2022 22:52:58 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4c2d:864b:dd30:3c5e])
        by smtp.gmail.com with ESMTPSA id l13sm30610546pgs.16.2022.01.31.22.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 22:52:58 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Talal Ahmad <talalahmad@google.com>,
        Arjun Roy <arjunroy@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] tcp: fix mem under-charging with zerocopy sendmsg()
Date:   Mon, 31 Jan 2022 22:52:54 -0800
Message-Id: <20220201065254.680532-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We got reports of following warning in inet_sock_destruct()

	WARN_ON(sk_forward_alloc_get(sk));

Whenever we add a non zero-copy fragment to a pure zerocopy skb,
we have to anticipate that whole skb->truesize will be uncharged
when skb is finally freed.

skb->data_len is the payload length. But the memory truesize
estimated by __zerocopy_sg_from_iter() is page aligned.

Fixes: 9b65b17db723 ("net: avoid double accounting for pure zerocopy skbs")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Talal Ahmad <talalahmad@google.com>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Willem de Bruijn <willemb@google.com>
---
 net/ipv4/tcp.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 78e81465f5f3632f54093495d2f2a064e60c7237..bdf108f544a45a2aa24bc962fb81dfd0ca1e0682 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1322,10 +1322,13 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 			/* skb changing from pure zc to mixed, must charge zc */
 			if (unlikely(skb_zcopy_pure(skb))) {
-				if (!sk_wmem_schedule(sk, skb->data_len))
+				u32 extra = skb->truesize -
+					    SKB_TRUESIZE(skb_end_offset(skb));
+
+				if (!sk_wmem_schedule(sk, extra))
 					goto wait_for_space;
 
-				sk_mem_charge(sk, skb->data_len);
+				sk_mem_charge(sk, extra);
 				skb_shinfo(skb)->flags &= ~SKBFL_PURE_ZEROCOPY;
 			}
 
-- 
2.35.0.rc2.247.g8bbb082509-goog

