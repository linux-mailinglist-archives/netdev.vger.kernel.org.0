Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD366B5494
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 23:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbjCJWiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 17:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbjCJWiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 17:38:13 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4473BDBF;
        Fri, 10 Mar 2023 14:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1678487892; x=1710023892;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4Ah8kgw+7F5+l+p1/S9MDspeHNTTxxxtpxdebEtglq0=;
  b=BP57SktkS25gmmdAcjktPyKix7xHJiY9I9wNl9I+To8eH1Sg2soQiXBV
   Jz3FnBn6/vHX0Al7Fu8FLuR3888y9yNAO1L9xgqGjUUu0X1Vd8fwUzG9r
   MAzpsHwzrp9Ifg6ftRxUpxchNRNr2mNFF77D9nD33yFnnVTV97yxhWCv+
   s=;
X-IronPort-AV: E=Sophos;i="5.98,251,1673913600"; 
   d="scan'208";a="305948878"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-a65ebc6e.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 22:38:08 +0000
Received: from EX19MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-m6i4x-a65ebc6e.us-east-1.amazon.com (Postfix) with ESMTPS id 6528763E62;
        Fri, 10 Mar 2023 22:38:06 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Fri, 10 Mar 2023 22:38:04 +0000
Received: from 88665a182662.ant.amazon.com.com (10.106.100.20) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Fri, 10 Mar 2023 22:38:01 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <kuniyu@amazon.com>
CC:     <kuba@kernel.org>, <martin.lau@kernel.org>,
        <netdev@vger.kernel.org>, <pholzing@redhat.com>,
        <regressions@lists.linux.dev>, <stable@vger.kernel.org>
Subject: Re: [REGRESSION] v6.1+ bind() does not fail with EADDRINUSE if dual stack is bound
Date:   Fri, 10 Mar 2023 14:37:52 -0800
Message-ID: <20230310223752.31024-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230310212547.25491-1-kuniyu@amazon.com>
References: <20230310212547.25491-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.100.20]
X-ClientProxiedBy: EX19D044UWB002.ant.amazon.com (10.13.139.188) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Kuniyuki Iwashima <kuniyu@amazon.com>
Date:   Fri, 10 Mar 2023 13:25:47 -0800
> From:   Paul Holzinger <pholzing@redhat.com>
> Date:   Fri, 10 Mar 2023 17:01:31 +0100
> > Hi all,
> > 
> > there seems to be a regression which allows you to bind the same port 
> > twice when the first bind call bound to all ip addresses (i. e. dual stack).
> > 
> > A second bind call for the same port will succeed if you try to bind to 
> > a specific ipv4 (e. g. 127.0.0.1), binding to 0.0.0.0 or an ipv6 address 
> > fails correctly with EADDRINUSE.
> > 
> > I included a small c program below to show the issue. Normally the 
> > second bind call should fail, this was the case before v6.1.
> > 
> > 
> > I bisected the regression to commit 5456262d2baa ("net: Fix incorrect 
> > address comparison when searching for a bind2 bucket").
> > 
> > I also checked that the issue is still present in v6.3-rc1.
> 
> Thanks for the detailed report.
> 
> It seems we should take care of the special case in
> inet_bind2_bucket_match_addr_any().

I confimed this change fixes the regression.
I'll check other paths that 5456262d2baa touched.

---8<---
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index e41fdc38ce19..62c5f7501571 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -828,8 +828,15 @@ bool inet_bind2_bucket_match_addr_any(const struct inet_bind2_bucket *tb, const
 #if IS_ENABLED(CONFIG_IPV6)
 	struct in6_addr addr_any = {};
 
-	if (sk->sk_family != tb->family)
-		return false;
+	if (sk->sk_family != tb->family) {
+		if (sk->sk_family == AF_INET6)
+			return net_eq(ib2_net(tb), net) && tb->port == port &&
+				tb->l3mdev == l3mdev && tb->rcv_saddr == 0;
+		else
+			return net_eq(ib2_net(tb), net) && tb->port == port &&
+				tb->l3mdev == l3mdev &&
+				ipv6_addr_equal(&tb->v6_rcv_saddr, &in6addr_any);
+	}
 
 	if (sk->sk_family == AF_INET6)
 		return net_eq(ib2_net(tb), net) && tb->port == port &&
---8<---


Tested:

---8<---
>>> from socket import *
>>> 
>>> s = socket(AF_INET6, SOCK_STREAM, 0)
>>> s2 = socket(AF_INET, SOCK_STREAM, 0)
>>> 
>>> s.bind(('::', 0))
>>> s
<socket.socket fd=3, family=AddressFamily.AF_INET6, type=SocketKind.SOCK_STREAM, proto=0, laddr=('::', 53147, 0, 0)>
>>> 
>>> s2.bind(('0.0.0.0', s.getsockname()[1]))
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
OSError: [Errno 98] Address already in use
>>> s2.bind(('127.0.0.1', s.getsockname()[1]))
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
OSError: [Errno 98] Address already in use
>>> 
>>> 
>>> s3 = socket(AF_INET, SOCK_STREAM, 0)
>>> s4 = socket(AF_INET6, SOCK_STREAM, 0)
>>> 
>>> s3.bind(('0.0.0.0', 0))
>>> s3
<socket.socket fd=5, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('0.0.0.0', 58359)>
>>> 
>>> s4.bind(('::0', s3.getsockname()[1]))
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
OSError: [Errno 98] Address already in use
>>> s4.bind(('::1', s3.getsockname()[1]))
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
OSError: [Errno 98] Address already in use
---8<---

Thanks,
Kuniyuki


> 
> I'll fix it.
> 
> Thanks,
> Kuniyuki
> 
> > 
> > 
> > Original report: https://github.com/containers/podman/issues/17719
> > 
> > #regzbot introduced: 5456262d2baa
> > 
> > 
> > ```
> > 
> > #include <sys/socket.h>
> > #include <sys/un.h>
> > #include <stdlib.h>
> > #include <stdio.h>
> > #include <netinet/in.h>
> > #include <unistd.h>
> > 
> > int main(int argc, char *argv[])
> > {
> >      int ret, sock1, sock2;
> >      struct sockaddr_in6 addr;
> >      struct sockaddr_in addr2;
> > 
> >      sock1 = socket(AF_INET6, SOCK_STREAM, 0);
> >      if (sock1 == -1)
> >      {
> >          perror("socket1");
> >          exit(1);
> >      }
> >      sock2 = socket(AF_INET, SOCK_STREAM, 0);
> >      if (sock2 == -1)
> >      {
> >          perror("socket2");
> >          exit(1);
> >      }
> > 
> >      memset(&addr, 0, sizeof(addr));
> >      addr.sin6_family = AF_INET6;
> >      addr.sin6_addr = in6addr_any;
> >      addr.sin6_port = htons(8080);
> > 
> >      memset(&addr2, 0, sizeof(addr2));
> >      addr2.sin_family = AF_INET;
> >      addr2.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
> >      addr2.sin_port = htons(8080);
> > 
> >      ret = bind(sock1, (struct sockaddr *)&addr, sizeof(addr));
> >      if (ret == -1)
> >      {
> >          perror("bind1");
> >          exit(1);
> >      }
> >      printf("bind1 ret: %d\n", ret);
> > 
> >      if ((listen(sock1, 5)) != 0)
> >      {
> >          perror("listen1");
> >          exit(1);
> >      }
> > 
> >      ret = bind(sock2, (struct sockaddr *)&addr2, sizeof(addr2));
> >      if (ret == -1)
> >      {
> >          perror("bind2");
> >          exit(1);
> >      }
> >      printf("bind2 ret: %d\n", ret);
> > 
> >      if ((listen(sock2, 5)) != 0)
> >      {
> >          perror("listen2");
> >          exit(1);
> >      }
> > 
> >      // uncomment pause() to see with ss -tlpn the bound ports
> >      // pause();
> > 
> >      return 0;
> > }
> > 
> > ```
> > 
> > 
> > Best regards,
> > 
> > Paul
