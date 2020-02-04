Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94791151F7C
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 18:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbgBDRb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 12:31:26 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43272 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727310AbgBDRbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 12:31:25 -0500
Received: by mail-qt1-f193.google.com with SMTP id d18so14918966qtj.10
        for <netdev@vger.kernel.org>; Tue, 04 Feb 2020 09:31:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hK2Oacgd+hegoPvUJWsPpLrIsRidBQW0BfFhwwgqsjQ=;
        b=jIIvi1nRU2ymDQFI2AXXbMBPHLcchANtFU63BlBTKgNeb1+ovTw48xXlHI+6+R00wR
         mbn6yW0ewUDRmvHJuc6mkm4iKHwkWYJ4lCyuI7IDlDBupVcajY5VTqnDJzDD84UoX2aS
         vfJm8nDUgIczj0rXJY9d7qIFb5cArctcoUw4TI/Mffiujzvu/yo/6eDuMPnoQxgjioMs
         ufBkFYhCXLOouRm++mphWn2b3pF2LWLBDHenytUL3Kl1C2kVE0PHiyeCDMYwN3Ada8cv
         XsdN9t4MRSpt1ZP6cwuoTAZ3JHfh3yMboFpS58ejjBVQyE4dupoaPxVNQMPRBts3p9Yi
         H7sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hK2Oacgd+hegoPvUJWsPpLrIsRidBQW0BfFhwwgqsjQ=;
        b=T7mnm4LF5X1WCjifMzqQqY8N5RxEbfCjUh8jK890LaSnEKjaNWisUEUebxseYDCA40
         eSo/XrBrAi28Vtaj87UiHyIzOn3fTXXlJUy0/OqootyfFztjzFbvMi1GCOcArb88nDhS
         i0vI6MCVGEOxDFotYs0lmEJ0cF6Nysvm3zS29jnL1O8DlJamyxZALwTTprxTTmLKBKw4
         PCqYpCbnnoRYkaHKRSn9aGR1mZC8vHGJbx8kg6CCZGWvo0UBCng+zBMZF/7Ct7NzjTT1
         ltO8hWVPn0Ge3PTre38015B7+qulz1LI7Ben35mNokEGL3m4hIZu6q3JWLBFkwKl8ljk
         hxIA==
X-Gm-Message-State: APjAAAUcjCNC+49RKblGIwWe2RQtLXfHCZSSgVFGTjWFAcWYfR7QkhFG
        c0hEj4zHET9pTksH94obKd44g24m
X-Google-Smtp-Source: APXvYqwuPhAQgupDolBBT7JMaA0XnnhVsdETplo44bV3BAEVBetfWZ6rIdYPRUBltLWnzJgfVA1u7Q==
X-Received: by 2002:ac8:8d6:: with SMTP id y22mr28258779qth.85.1580837484582;
        Tue, 04 Feb 2020 09:31:24 -0800 (PST)
Received: from localhost.localdomain ([45.72.237.143])
        by smtp.gmail.com with ESMTPSA id m54sm12466623qtf.67.2020.02.04.09.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 09:31:24 -0800 (PST)
From:   Alexander Aring <alex.aring@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, andrea.mayer@uniroma2.it,
        dav.lebrun@gmail.com, mcr@sandelman.ca, stefan@datenfreihafen.org,
        Alexander Aring <alex.aring@gmail.com>
Subject: [PATCH net 1/2] net: ipv6: seg6_iptunnel: set tunnel headroom to zero
Date:   Tue,  4 Feb 2020 12:30:18 -0500
Message-Id: <20200204173019.4437-2-alex.aring@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200204173019.4437-1-alex.aring@gmail.com>
References: <20200204173019.4437-1-alex.aring@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch sets headroom of segmentation route tunnel to zero. The
headroom setting was introduced for mpls in commit 14972cbd34ff
("net: lwtunnel: Handle fragmentation") which sits on layer 2.5. As the
Linux interface MTU value is Layer 3 and don't consider anything before
that it is misleading to set the headroom value to anything than 0.

Example setup to trigger this issue:

ip netns add foo
ip link add veth0 type veth peer name veth1
ip link set veth1 netns foo
ip link set mtu 1280 dev veth0

ip link set veth0 up
ip -n foo link set veth1 up

ip addr add beef::1/64 dev veth0
ip -6 route add beef::3 encap seg6 mode encap segs beef::2 dev veth0

then do a:

ping beef::3

You the sendmsg() will return -EINVAL because the packet doesn't fit
into the IPv6 minimum MTU anymore. It was consider the headroom value
in their destination mtu which substracts whatever headroom is from
the interface MTU 1280.

Signed-off-by: Alexander Aring <alex.aring@gmail.com>
---
 net/ipv6/seg6_iptunnel.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index ab7f124ff5d7..5b6e88f16e2d 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -449,8 +449,6 @@ static int seg6_build_state(struct nlattr *nla,
 	if (tuninfo->mode != SEG6_IPTUN_MODE_L2ENCAP)
 		newts->flags |= LWTUNNEL_STATE_OUTPUT_REDIRECT;
 
-	newts->headroom = seg6_lwt_headroom(tuninfo);
-
 	*ts = newts;
 
 	return 0;
-- 
2.20.1

