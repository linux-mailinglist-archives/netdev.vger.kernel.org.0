Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359D242A024
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 10:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235236AbhJLIpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 04:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbhJLIpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 04:45:13 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5634DC061570
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 01:43:12 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id m13so11471437qvk.1
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 01:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KBeY5W1FSSoiZGx9cIzZiko539gaDiTJrcfwH0Y0wmM=;
        b=axWxJY9VS7BVvxEdsa1zz2uogoSlGNxZ6lVvHLbvDthiT/5Qi2C5CubTy9nrDK/R6+
         dtlY9E8Zcee/c/2sIEducORwWrBqv93mJLCCEjKywrNqgq4pytslfS+v6KnlHdDD/9sg
         Q4dAV5jUz/lGQSkg38PrSLl6gmzjlhCJI1KI5MkNdmdlEK6+IWNjrexovkrU5sBhM1fS
         opsvEoQaEYtN/zMv3fIWqYqXZwdp/e7/o3xssWedfVHlgn3ASatb4a8+e6cz9E2nDUHx
         IQ89TSb+ngovCJhTGwR/US0qETyLQlERC290y85YQ4wPw3n8ibMXrCUwXHZguXZtkaw6
         pIHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KBeY5W1FSSoiZGx9cIzZiko539gaDiTJrcfwH0Y0wmM=;
        b=u1R64IdYxXVX4ohOJDlXvZ1Ii+mNR05gYuUkjuZHoG3YeMzbtQiIOTF5p5ppd2jp01
         5S68zsrjShrJIIoYyEFYEDorgzbSuiN1xKcl1iFAyk1qWse3ohiicUN3+yzo9MBojc5D
         kHqTvf/V2g97HZnLM2QgbIBOxYd4WhcGXxFiKaLhMXpKEXQxjZdTm/MfaKJoO/5OfluF
         dEvQQEY9KvbcG9JGEnAZ+ki8v0dibfOOB8LoUZXE+2lw5irdY4lps4Ry0BL4KsgGW45w
         FsGNrU/Q5BUA2letcOWOBOvYM5tzeRw1zgnF2O+lWGerEEwyIuXj4nxjaTfCUj8VbhZ3
         nrVQ==
X-Gm-Message-State: AOAM531vlaysVeRveejNHPjTge1iaIAkgZw7bH+PPs/sd07P1dkrcOoC
        YfuHtmMoOJZze9q/7bmbsIIvt4QsfdscSw==
X-Google-Smtp-Source: ABdhPJw0dAwxvQ7v+qUdBYYwY9/bVlPu4F5WChTm//FXHeRogG/s/eFBse79L9wz05atdcYZkP9iIQ==
X-Received: by 2002:ad4:4421:: with SMTP id e1mr15320428qvt.66.1634028191268;
        Tue, 12 Oct 2021 01:43:11 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id a3sm6396722qta.48.2021.10.12.01.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 01:43:10 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH net] icmp: fix icmp_ext_echo_iio parsing in icmp_build_probe
Date:   Tue, 12 Oct 2021 04:43:07 -0400
Message-Id: <61b6693f08f4f96f00cdeb2b8c78568e39f85029.1634028187.git.lucien.xin@gmail.com>
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

Fixes: d329ea5bd884 ("icmp: add response to RFC 8335 PROBE messages")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/icmp.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 8b30cadff708..818c79266c48 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -1061,38 +1061,48 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
 	dev = NULL;
 	switch (iio->extobj_hdr.class_type) {
 	case ICMP_EXT_ECHO_CTYPE_NAME:
-		iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(_iio), &_iio);
 		if (ident_len >= IFNAMSIZ)
 			goto send_mal_query;
+		iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
+					 ident_len, &_iio);
+		if (!iio)
+			goto send_mal_query;
 		memset(buff, 0, sizeof(buff));
 		memcpy(buff, &iio->ident.name, ident_len);
 		dev = dev_get_by_name(net, buff);
 		break;
 	case ICMP_EXT_ECHO_CTYPE_INDEX:
-		iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
-					 sizeof(iio->ident.ifindex), &_iio);
 		if (ident_len != sizeof(iio->ident.ifindex))
 			goto send_mal_query;
+		iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
+					 ident_len, &_iio);
+		if (!iio)
+			goto send_mal_query;
 		dev = dev_get_by_index(net, ntohl(iio->ident.ifindex));
 		break;
 	case ICMP_EXT_ECHO_CTYPE_ADDR:
-		if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
-				 iio->ident.addr.ctype3_hdr.addrlen)
+		iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
+					 sizeof(iio->ident.addr.ctype3_hdr), &_iio);
+		if (!iio || ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
+					 iio->ident.addr.ctype3_hdr.addrlen)
 			goto send_mal_query;
 		switch (ntohs(iio->ident.addr.ctype3_hdr.afi)) {
 		case ICMP_AFI_IP:
+			if (iio->ident.addr.ctype3_hdr.addrlen != sizeof(struct in_addr))
+				goto send_mal_query;
 			iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
-						 sizeof(struct in_addr), &_iio);
-			if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
-					 sizeof(struct in_addr))
+						 ident_len, &_iio);
+			if (!iio)
 				goto send_mal_query;
 			dev = ip_dev_find(net, iio->ident.addr.ip_addr.ipv4_addr);
 			break;
 #if IS_ENABLED(CONFIG_IPV6)
 		case ICMP_AFI_IP6:
-			iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(_iio), &_iio);
-			if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
-					 sizeof(struct in6_addr))
+			if (iio->ident.addr.ctype3_hdr.addrlen != sizeof(struct in6_addr))
+				goto send_mal_query;
+			iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
+						 ident_len, &_iio);
+			if (!iio)
 				goto send_mal_query;
 			dev = ipv6_stub->ipv6_dev_find(net, &iio->ident.addr.ip_addr.ipv6_addr, dev);
 			dev_hold(dev);
-- 
2.27.0

