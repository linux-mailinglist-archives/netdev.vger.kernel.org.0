Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FD042D66D
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 11:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhJNJw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 05:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbhJNJw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 05:52:58 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280A1C061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 02:50:54 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id ay35so4876401qkb.10
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 02:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vX0mCVgZ/TEe/oLuoOJv1/ATY6BWIt4qZwuFYY1g4pY=;
        b=L0hQaE1NNuQQ+DzUa8/YHduVX8X2dWRp2hZTJbc3xbBqu/4hoYULu1UZnUmwUmSDdC
         SIICh6vdmswlK8k03+ZJnxjyZM5Hc3g8n04vrnIaLB5hPgYr3BsaVN/0oRgV4o6ingMx
         8dgj4HAuJqdaey6aMB8Jtibepi5KIF7jGd9GHlkgJB+EywtBgVGmKN/0rZn5CQw+N4uQ
         IZsUYp6nDX6JLAT2QPghae4yXbO/ulnJ7gAN/vveWvoDLY9v0oULM3tJToziz+dHS4sQ
         DKneGH7rztuZ+jRe3FOuGLq0e5ZCidmBUduKJvHamcOITD4EKaqpzIhB5TC4bwX54zA2
         E+NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vX0mCVgZ/TEe/oLuoOJv1/ATY6BWIt4qZwuFYY1g4pY=;
        b=0nvKKdIJvWtakZHyOSbks+0UvX6MPFR5e13d3I/2X+Fij8ytTWHgAc6BHSz/LcvM8O
         ZxFER8u46RZ9i1YnMPC3uIGhxjQgk0tdMv593nyBtSsmVjH8LPdrT/2EAc+1L56ifkkD
         IiMF6KJNShlnrojxh6GUVwZJpA5rVaG8SsYnSi2iGC5hpz10aPrWOKc6/GkVXVqODsQE
         Um6oqQOFaUBnzrRqtCW/6HSqd0UI3EpFi5/jRzPN7Zsx9/kkc76Co6FGJrMTHKZqnKUY
         ocJGJ/pVtq2gaWDPrudF1CPDQCLzFENv3XlXHQ3IsM/UIYlIkSzKbrAJY8STzfOpk7Bd
         jOSg==
X-Gm-Message-State: AOAM531mPtNjBPLQi3zaSk/xxVCzmPAfpHaFVdPj+nvprwt3+RlU7W59
        cztRHpsNMG3K00mtfzA+AO+5KDPuSlEV4Q==
X-Google-Smtp-Source: ABdhPJwqh6+s/Og2RbPeNFIrmfr11lvl4QNCVw+mUOV4YVk5nq6PU0E/2tJf4ZEEJNlxLw8OdHG1cA==
X-Received: by 2002:a37:a88b:: with SMTP id r133mr3800461qke.290.1634205053066;
        Thu, 14 Oct 2021 02:50:53 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id u3sm1079670qkj.53.2021.10.14.02.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 02:50:52 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCHv3 net] icmp: fix icmp_ext_echo_iio parsing in icmp_build_probe
Date:   Thu, 14 Oct 2021 05:50:50 -0400
Message-Id: <31628dd76657ea62f5cf78bb55da6b35240831f1.1634205050.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In icmp_build_probe(), the icmp_ext_echo_iio parsing should be done
step by step and skb_header_pointer() return value should always be
checked, this patch fixes 3 places in there:

  - On case ICMP_EXT_ECHO_CTYPE_NAME, it should only copy ident.name
    from skb by skb_header_pointer(), its len is ident_len. Besides,
    the return value of skb_header_pointer() should always be checked.

  - On case ICMP_EXT_ECHO_CTYPE_INDEX, move ident_len check ahead of
    skb_header_pointer(), and also do the return value check for
    skb_header_pointer().

  - On case ICMP_EXT_ECHO_CTYPE_ADDR, before accessing iio->ident.addr.
    ctype3_hdr.addrlen, skb_header_pointer() should be called first,
    then check its return value and ident_len.
    On subcases ICMP_AFI_IP and ICMP_AFI_IP6, also do check for ident.
    addr.ctype3_hdr.addrlen and skb_header_pointer()'s return value.
    On subcase ICMP_AFI_IP, the len for skb_header_pointer() should be
    "sizeof(iio->extobj_hdr) + sizeof(iio->ident.addr.ctype3_hdr) +
    sizeof(struct in_addr)" or "ident_len".

v1->v2:
  - To make it more clear, call skb_header_pointer() once only for
    iio->indent's parsing as Jakub Suggested.
v2->v3:
  - The extobj_hdr.length check against sizeof(_iio) should be done
    before calling skb_header_pointer(), as Eric noticed.

Fixes: d329ea5bd884 ("icmp: add response to RFC 8335 PROBE messages")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/icmp.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 8b30cadff708..b7e277d8a84d 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -1054,14 +1054,19 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
 	iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr), &_iio);
 	if (!ext_hdr || !iio)
 		goto send_mal_query;
-	if (ntohs(iio->extobj_hdr.length) <= sizeof(iio->extobj_hdr))
+	if (ntohs(iio->extobj_hdr.length) <= sizeof(iio->extobj_hdr) ||
+	    ntohs(iio->extobj_hdr.length) > sizeof(_iio))
 		goto send_mal_query;
 	ident_len = ntohs(iio->extobj_hdr.length) - sizeof(iio->extobj_hdr);
+	iio = skb_header_pointer(skb, sizeof(_ext_hdr),
+				 sizeof(iio->extobj_hdr) + ident_len, &_iio);
+	if (!iio)
+		goto send_mal_query;
+
 	status = 0;
 	dev = NULL;
 	switch (iio->extobj_hdr.class_type) {
 	case ICMP_EXT_ECHO_CTYPE_NAME:
-		iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(_iio), &_iio);
 		if (ident_len >= IFNAMSIZ)
 			goto send_mal_query;
 		memset(buff, 0, sizeof(buff));
@@ -1069,30 +1074,24 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
 		dev = dev_get_by_name(net, buff);
 		break;
 	case ICMP_EXT_ECHO_CTYPE_INDEX:
-		iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
-					 sizeof(iio->ident.ifindex), &_iio);
 		if (ident_len != sizeof(iio->ident.ifindex))
 			goto send_mal_query;
 		dev = dev_get_by_index(net, ntohl(iio->ident.ifindex));
 		break;
 	case ICMP_EXT_ECHO_CTYPE_ADDR:
-		if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
+		if (ident_len < sizeof(iio->ident.addr.ctype3_hdr) ||
+		    ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
 				 iio->ident.addr.ctype3_hdr.addrlen)
 			goto send_mal_query;
 		switch (ntohs(iio->ident.addr.ctype3_hdr.afi)) {
 		case ICMP_AFI_IP:
-			iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
-						 sizeof(struct in_addr), &_iio);
-			if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
-					 sizeof(struct in_addr))
+			if (iio->ident.addr.ctype3_hdr.addrlen != sizeof(struct in_addr))
 				goto send_mal_query;
 			dev = ip_dev_find(net, iio->ident.addr.ip_addr.ipv4_addr);
 			break;
 #if IS_ENABLED(CONFIG_IPV6)
 		case ICMP_AFI_IP6:
-			iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(_iio), &_iio);
-			if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
-					 sizeof(struct in6_addr))
+			if (iio->ident.addr.ctype3_hdr.addrlen != sizeof(struct in6_addr))
 				goto send_mal_query;
 			dev = ipv6_stub->ipv6_dev_find(net, &iio->ident.addr.ip_addr.ipv6_addr, dev);
 			dev_hold(dev);
-- 
2.27.0

