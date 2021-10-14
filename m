Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED3742D181
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 06:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhJNE1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 00:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhJNE1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 00:27:04 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D43AC061570
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 21:25:00 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id d20so3047764qvm.8
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 21:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3fkZWo2Wp++1yWTKTt4ALTDTuIVEIxCwfbrXs1fYg8o=;
        b=An4bVgzkBYYFkVLuIgT7C0ScVNC1jY4bW0pAUsEPwbp7XaQjPU/V9SPxjrUb+m+S1L
         95i5Uern3jYKNyPmRqoSdnOzUWdErhvrsI4MbyfA2X6VdLNfQz+1ypY2P9MicR23+0A8
         B0LAyZjboPAHaMrakUtDu5lS8DiIrfP+AQyl8xFNKzg2RBVkwuAJO+wR3fzk0F8SpsHl
         hGhnlHz0cp+v2+s5AGTAMJ//osV6j8VK/+KPnqqRpl3feEBLhnoQoac8NraY6QJDTMkd
         Mc71DjlTuMLz796WAbP7qS1655HgLt8r2ACLtSzSZdpoGEVxmVwTP0cXHfYLEZjGRk/y
         nNbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3fkZWo2Wp++1yWTKTt4ALTDTuIVEIxCwfbrXs1fYg8o=;
        b=F/6LAWYzBIL7n/gMN+4Qx6zi0EthenzyJKEkE18Gf37NtcARGlM9hH9Y5lj9P7LWO9
         +45PFDwt4WPgEjaco/KXHgoyqfT15aQ7+o/Uq0Uuyej+8x9QkZnzYjd2nRbDTkMjV1AO
         cW0TA3XBt14tQZ04OhyjJSls3iKAoF43kqBtt/CjSo19gBIPBYoR5khpe3u03NjEiGcM
         J9jUXkUPsHW7TcCxFhIHMQznjxnjr9OGRPdh+apHgvtvIF9z6Kaxdpxumlz6zVRbjaAe
         hVrCaZbNjbsz1Ys+AYNuoXRz0yNU3Biy5WSnaC3cJQJLu3gmyh1SpN82GEik/ecsUuBN
         JgKQ==
X-Gm-Message-State: AOAM531ppB5m+zRml9k/luKXqOCsgicMT71wuvfl6RHowmbR2Of4zG03
        KtAfhBN2IHO5QNov1IFt0IU21a6waLs=
X-Google-Smtp-Source: ABdhPJyDPnuPl2ArRZzUAd1tTBl/8W3jjp6hUlhTlRgBXc1Uii7GurCeuvvVZ/LpK9rehD97FKP13g==
X-Received: by 2002:a05:6214:13ce:: with SMTP id cg14mr2987320qvb.51.1634185499064;
        Wed, 13 Oct 2021 21:24:59 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id h2sm887702qkf.106.2021.10.13.21.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 21:24:58 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCHv2 net] icmp: fix icmp_ext_echo_iio parsing in icmp_build_probe
Date:   Thu, 14 Oct 2021 00:24:57 -0400
Message-Id: <345b3f75bea482f7b3174297261db24cdf7e15e1.1634185497.git.lucien.xin@gmail.com>
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

Fixes: d329ea5bd884 ("icmp: add response to RFC 8335 PROBE messages")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/icmp.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 8b30cadff708..bccb2132a464 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -1057,11 +1057,15 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
 	if (ntohs(iio->extobj_hdr.length) <= sizeof(iio->extobj_hdr))
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
@@ -1069,30 +1073,24 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
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

