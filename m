Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80C466E6E23
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 23:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbjDRV1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 17:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbjDRV1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 17:27:38 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94309B47A;
        Tue, 18 Apr 2023 14:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1681853240; x=1713389240;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mPAtd9FvdcYW8PHV7v552N7qJEi+dhgg4FhQAL2516s=;
  b=hq8XU58WPNuz49sgV9Y401qAq5hPSwC2sWFqD+KwVMzq/AgVAuCxhE3m
   o0ySnDFc/a1qMCuNcXdffGHLVm4BN3fMjbOJaCirJvvSqsFg7lYax9dva
   zd5sftnlyWDLjMwHR6lgS3XhSWSJaaOo8wbHU5LoTejljX6FL8yx9tyCi
   w=;
X-IronPort-AV: E=Sophos;i="5.99,207,1677542400"; 
   d="scan'208";a="321952178"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 21:27:16 +0000
Received: from EX19MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com (Postfix) with ESMTPS id 52C54A80F9;
        Tue, 18 Apr 2023 21:27:15 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Tue, 18 Apr 2023 21:27:01 +0000
Received: from 88665a182662.ant.amazon.com (10.106.101.27) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 18 Apr 2023 21:26:59 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <bspencer@blackberry.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kuniyu@amazon.com>
Subject: Re: netlink getsockopt() sets only one byte?
Date:   Tue, 18 Apr 2023 14:26:51 -0700
Message-ID: <20230418212651.10035-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <ZD7VkNWFfp22kTDt@datsun.rim.net>
References: <ZD7VkNWFfp22kTDt@datsun.rim.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.101.27]
X-ClientProxiedBy: EX19D042UWB001.ant.amazon.com (10.13.139.160) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Brad Spencer <bspencer@blackberry.com>
Date:   Tue, 18 Apr 2023 14:38:24 -0300
> Calling getsockopt() on a netlink socket with SOL_NETLINK options that
> use type int only sets the first byte of the int value but returns an
> optlen equal to sizeof(int), at least on x86_64.
> 
> 
> The detailed description:
> 
> It looks like netlink_getsockopt() calls put_user() with a char*
> pointer, and I think that causes it to copy only one byte from the val
> result, despite len being sizeof(int).

Right, we need to use copy_to_user() like udp_lib_getsockopt()
or cast optval as done in NETLINK_LIST_MEMBERSHIPS.

---8<---
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 1db4742e443d..780f3e6496be 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1742,7 +1742,7 @@ static int netlink_getsockopt(struct socket *sock, int level, int optname,
 {
 	struct sock *sk = sock->sk;
 	struct netlink_sock *nlk = nlk_sk(sk);
-	int len, val, err;
+	int len, val, err = 0;
 
 	if (level != SOL_NETLINK)
 		return -ENOPROTOOPT;
@@ -1753,35 +1753,23 @@ static int netlink_getsockopt(struct socket *sock, int level, int optname,
 		return -EINVAL;
 
 	switch (optname) {
-	case NETLINK_PKTINFO:
+	case NETLINK_LIST_MEMBERSHIPS:
+		break;
+	default:
 		if (len < sizeof(int))
 			return -EINVAL;
 		len = sizeof(int);
+	}
+
+	switch (optname) {
+	case NETLINK_PKTINFO:
 		val = nlk->flags & NETLINK_F_RECV_PKTINFO ? 1 : 0;
-		if (put_user(len, optlen) ||
-		    put_user(val, optval))
-			return -EFAULT;
-		err = 0;
 		break;
 	case NETLINK_BROADCAST_ERROR:
-		if (len < sizeof(int))
-			return -EINVAL;
-		len = sizeof(int);
 		val = nlk->flags & NETLINK_F_BROADCAST_SEND_ERROR ? 1 : 0;
-		if (put_user(len, optlen) ||
-		    put_user(val, optval))
-			return -EFAULT;
-		err = 0;
 		break;
 	case NETLINK_NO_ENOBUFS:
-		if (len < sizeof(int))
-			return -EINVAL;
-		len = sizeof(int);
 		val = nlk->flags & NETLINK_F_RECV_NO_ENOBUFS ? 1 : 0;
-		if (put_user(len, optlen) ||
-		    put_user(val, optval))
-			return -EFAULT;
-		err = 0;
 		break;
 	case NETLINK_LIST_MEMBERSHIPS: {
 		int pos, idx, shift;
@@ -1796,6 +1784,7 @@ static int netlink_getsockopt(struct socket *sock, int level, int optname,
 			shift = (pos % sizeof(unsigned long)) * 8;
 			if (put_user((u32)(nlk->groups[idx] >> shift),
 				     (u32 __user *)(optval + pos))) {
+				netlink_unlock_table();
 				err = -EFAULT;
 				break;
 			}
@@ -1803,39 +1792,25 @@ static int netlink_getsockopt(struct socket *sock, int level, int optname,
 		if (put_user(ALIGN(nlk->ngroups / 8, sizeof(u32)), optlen))
 			err = -EFAULT;
 		netlink_unlock_table();
-		break;
+		return err;
 	}
 	case NETLINK_CAP_ACK:
-		if (len < sizeof(int))
-			return -EINVAL;
-		len = sizeof(int);
 		val = nlk->flags & NETLINK_F_CAP_ACK ? 1 : 0;
-		if (put_user(len, optlen) ||
-		    put_user(val, optval))
-			return -EFAULT;
-		err = 0;
 		break;
 	case NETLINK_EXT_ACK:
-		if (len < sizeof(int))
-			return -EINVAL;
-		len = sizeof(int);
 		val = nlk->flags & NETLINK_F_EXT_ACK ? 1 : 0;
-		if (put_user(len, optlen) || put_user(val, optval))
-			return -EFAULT;
-		err = 0;
 		break;
 	case NETLINK_GET_STRICT_CHK:
-		if (len < sizeof(int))
-			return -EINVAL;
-		len = sizeof(int);
 		val = nlk->flags & NETLINK_F_STRICT_CHK ? 1 : 0;
-		if (put_user(len, optlen) || put_user(val, optval))
-			return -EFAULT;
-		err = 0;
 		break;
 	default:
-		err = -ENOPROTOOPT;
+		return -ENOPROTOOPT;
 	}
+
+	if (put_user(len, optlen) ||
+	    copy_to_user(optval, &val, len))
+		return -EFAULT;
+
 	return err;
 }
 
---8<---


> 
> Is this the expected behaviour?  The returned size is 4, after all,
> and other int-sized socket options (outside of netlink) like
> SO_REUSEADDR set all bytes of the int.
> 
> Programs that do not expect this behaviour and do not initialize the
> value to some known bit pattern are likely to misinterpret the result,
> especially when checking to see if the value is or isn't zero.
> 
> Attached is a short program that demonstrates the issue on Arch Linux
> with the 6.3.0-rc6 mainline kernel on x86_64, and also with the same
> Arch Linux userland on 6.2.10-arch1-1.  I've seen the same behaviour
> on older Debian and Ubuntu kernels.
> 
>     gcc -Wall -o prog prog.c
>     
> Show only the first byte being written to when the setting is `0`:
> 
>     $ ./progboot
>     SOL_SOCKET SO_REUSEADDR:
>     size=4 value=0x0
>     SOL_NETLINK NETLINK_NO_ENOBUFS:
>     size=4 value=0xdeadbe00
>     prog: prog.c:39: tryOption: Assertion `value == 0' failed.
>     Aborted (core dumped)
> 
> Workaround by initializing to zero:
> 
>     $ ./prog workaround
>     SOL_SOCKET SO_REUSEADDR:
>     size=4 value=0x0
>     SOL_NETLINK NETLINK_NO_ENOBUFS:
>     size=4 value=0x0
> 
> Show only the first byte being written to when the setting is `1`:
> 
>     $ SET_FIRST=yes ./prog
>     SOL_SOCKET SO_REUSEADDR:
>     size=4 value=0x1
>     SOL_NETLINK NETLINK_NO_ENOBUFS:
>     size=4 value=0xdeadbe01
>     prog: prog.c:35: tryOption: Assertion `value == 1' failed.
>     Aborted (core dumped)
> 
> Workaround by initializing to zero:
> 
>     $ SET_FIRST=yes ./prog workaround
>     SOL_SOCKET SO_REUSEADDR:
>     size=4 value=0x1
>     SOL_NETLINK NETLINK_NO_ENOBUFS:
>     size=4 value=0x1
> 
> 
> Demonstration program:
> 
> #include <asm/types.h>
> #include <assert.h>
> #include <linux/netlink.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <sys/socket.h>
> #include <sys/socket.h>
> #include <unistd.h>
> 
> static void tryOption(const int fd,
>                       const int level,
>                       const int optname,
>                       const int workaround,
>                       const int setFirst)
> {
>   assert(fd != -1);
>   
>   // Setting it to 1 gives similar results.
>   if(setFirst)
>   {
>     int value = 1;
>     assert(!setsockopt(fd, level, optname, &value, sizeof(value)));
>   }
> 
>   // Get the option.
>   {
>     int value = workaround ? 0 : 0xdeadbeef;
>     socklen_t size = sizeof(value);
> 
>     // Only the first byte of `value` is written to!
>     assert(!getsockopt(fd, level, optname, &value, &size));
>     printf("size=%u value=0x%x\n", size, value);
>     if(setFirst)
>     {
>       assert(value == 1);
>     }
>     else
>     {
>       assert(value == 0);
>     }
> 
>     // But it always reports a 4 byte option size.
>     assert(size == sizeof(int));
>   }
> 
>   close(fd);
> }
> 
> int
> main(int argc, char** argv)
> {
>   // If any argument is supplied, apply a workaround.
>   const int workaround = argc > 1;
> 
>   // If $SET_FIRST is set to anything, set the option to 1 first.
>   const int setFirst = getenv("SET_FIRST") != NULL;
> 
>   // Other int options set all bytes of the int.
>   printf("SOL_SOCKET SO_REUSEADDR:\n");
>   tryOption(
>     socket(AF_INET, SOCK_STREAM, 0),
>     SOL_SOCKET,
>     SO_REUSEADDR,
>     workaround,
>     setFirst);
> 
>   // Netlink int socket options do not set all bytes of the int.
>   printf("SOL_NETLINK NETLINK_NO_ENOBUFS:\n");
>   tryOption(
>     socket(AF_NETLINK, SOCK_RAW, NETLINK_ROUTE),
>     SOL_NETLINK,
>     NETLINK_NO_ENOBUFS,
>     workaround,
>     setFirst);
> }
