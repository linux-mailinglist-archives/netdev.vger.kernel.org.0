Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F323563822B
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 02:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiKYBt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 20:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKYBt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 20:49:27 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABACB382
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 17:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1669340966; x=1700876966;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V6hRe+lw7TrFeuA/E5iAbYWM1waB+/VodsZz3s36HwY=;
  b=temTl6RbfYhlFAb/u74aMycpqTyx2Ikzj72db5IrRmO+wSn7++0QDIXX
   G0iI/jS3QX04eFiMf5+7Y7/mUaUYtIsIqh0ZMMtb4VqdB4xJfMpIPX9N2
   ldcHCzXkArUSHbd+Q/z5DPgaFFnSKLFbcrZNTKHKfpu6xKWG5MrE+8SSN
   Y=;
X-IronPort-AV: E=Sophos;i="5.96,191,1665446400"; 
   d="scan'208";a="283772769"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-9fe6ad2f.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 01:49:21 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-9fe6ad2f.us-east-1.amazon.com (Postfix) with ESMTPS id B384A824B1;
        Fri, 25 Nov 2022 01:49:18 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 25 Nov 2022 01:49:17 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.134) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Fri, 25 Nov 2022 01:49:13 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <harperchen1110@gmail.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <syzkaller@googlegroups.com>
Subject: Re: [PATCH v1 net] af_unix: Call sk_diag_fill() under the bucket lock.
Date:   Fri, 25 Nov 2022 10:49:04 +0900
Message-ID: <20221125014905.98714-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAO4mrffDLiqo3hWRC=uP_E-3VQSV4O=1BiOaS0Z1J0GHLVgzVQ@mail.gmail.com>
References: <CAO4mrffDLiqo3hWRC=uP_E-3VQSV4O=1BiOaS0Z1J0GHLVgzVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.134]
X-ClientProxiedBy: EX13D31UWC002.ant.amazon.com (10.43.162.220) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Wei Chen <harperchen1110@gmail.com>
Date:   Thu, 24 Nov 2022 17:37:04 +0800
> Dear Linux developers,
> 
> My step tracing over Linux found the following C program would trigger
> the reported crash. I hope it is helpful for bug fix.

Thank you, Wei.

I guess you commented out the sock_diag_check_cookie() validation ?
Otherwise you would have to set req.udr.udiag_cookie.

For the record, my repro:

---8<---
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/un.h>
#include <linux/netlink.h>
#include <linux/rtnetlink.h>
#include <linux/sock_diag.h>
#include <linux/unix_diag.h>

void main(void)
{
	struct sockaddr_nl nladdr = {
		.nl_family = AF_NETLINK
	};
	struct {
		struct nlmsghdr nlh;
		struct unix_diag_req udr;
	} req = {
		.nlh = {
			.nlmsg_len = sizeof(req),
			.nlmsg_type = SOCK_DIAG_BY_FAMILY,
			.nlmsg_flags = NLM_F_REQUEST
		},
		.udr = {
			.sdiag_family = AF_UNIX,
			.udiag_show = UDIAG_SHOW_UID,
		}
	};
	struct iovec iov = {
		.iov_base = &req,
		.iov_len = sizeof(req)
	};
	struct msghdr msg = {
		.msg_name = &nladdr,
		.msg_namelen = sizeof(nladdr),
		.msg_iov = &iov,
		.msg_iovlen = 1
	};
	int netlink_fd, unix_fd, ret;
	struct stat file_stat;
	socklen_t optlen;
	__u64 cookie;

	unix_fd = socket(AF_UNIX, SOCK_STREAM, 0);
	fstat(unix_fd, &file_stat);
	optlen = sizeof(cookie);
	getsockopt(unix_fd, SOL_SOCKET, SO_COOKIE, &cookie, &optlen);

	req.udr.udiag_ino = file_stat.st_ino;
	req.udr.udiag_cookie[0] = (__u32)cookie;
	req.udr.udiag_cookie[1] = (__u32)(cookie >> 32);

	netlink_fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_SOCK_DIAG);
	sendmsg(netlink_fd, &msg, 0);

	close(netlink_fd);
	close(unix_fd);
}
---8<---


Interestingly, I only see the NULL deref with this patch applied.
Anyway, I'll post a fix later :)

---8<---
diff --git a/net/unix/diag.c b/net/unix/diag.c
index 105f522a89fe..f1c8f565af77 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -117,6 +117,7 @@ static int sk_diag_show_rqlen(struct sock *sk, struct sk_buff *nlskb)
 static int sk_diag_dump_uid(struct sock *sk, struct sk_buff *nlskb)
 {
 	uid_t uid = from_kuid_munged(sk_user_ns(nlskb->sk), sock_i_uid(sk));
+	printk(KERN_ERR "sk_diag_dump_uid: sk: %px\tskb->sk: %px, %px\n", sk, nlskb->sk, sk_user_ns(nlskb->sk));
 	return nla_put(nlskb, UNIX_DIAG_UID, sizeof(uid_t), &uid);
 }
 
---8<---


> 
> #include <errno.h>
> #include <stdio.h>
> #include <string.h>
> #include <unistd.h>
> #include <sys/socket.h>
> #include <sys/un.h>
> #include <linux/netlink.h>
> #include <linux/rtnetlink.h>
> #include <linux/sock_diag.h>
> #include <linux/unix_diag.h>
> #include <linux/stat.h>
> #include <sys/types.h>
> #include <sys/stat.h>
> 
> int main(void) {
>     int fd1 = socket(AF_UNIX, SOCK_STREAM, 0);
>     struct stat file_stat;
>     fstat(fd1, &file_stat);
>     int fd2 = socket(AF_NETLINK, SOCK_RAW, NETLINK_SOCK_DIAG);
> 
>     struct sockaddr_nl nladdr = {
>         .nl_family = AF_NETLINK
>     };
>     struct {
>         struct nlmsghdr nlh;
>         struct unix_diag_req udr;
>     } req = {
>         .nlh = {
>             .nlmsg_len = sizeof(req),
>             .nlmsg_type = SOCK_DIAG_BY_FAMILY,
>             .nlmsg_flags = NLM_F_REQUEST
>         },
>         .udr = {
>             .sdiag_family = AF_UNIX,
>             .udiag_states = -1,
>             .udiag_ino = file_stat.st_ino,
>             .udiag_show = 0x40
>         }
>     };
>     struct iovec iov = {
>         .iov_base = &req,
>         .iov_len = sizeof(req)
>     };
>     struct msghdr msg = {
>         .msg_name = &nladdr,
>         .msg_namelen = sizeof(nladdr),
>         .msg_iov = &iov,
>         .msg_iovlen = 1
>     };
> 
>     sendmsg(fd2, &msg, 0);
>     return 0;
> }
> 
> Best,
> Wei
> 
> On Wed, 23 Nov 2022 at 23:38, Paolo Abeni <pabeni@redhat.com> wrote:
> >
> > On Wed, 2022-11-23 at 07:22 -0800, Kuniyuki Iwashima wrote:
> > > From:   Wei Chen <harperchen1110@gmail.com>
> > > Date:   Wed, 23 Nov 2022 23:09:53 +0800
> > > > Dear Paolo,
> > > >
> > > > Could you explain the meaning of modified "ss" version to reproduce
> > > > the bug? I'd like to learn how to reproduce the bug in the user space
> > > > to facilitate the bug fix.
> > >
> > > I think it means to drop NLM_F_DUMP and modify args as needed because
> > > ss dumps all sockets, not exactly a single socket.
> >
> > Exactly! Additionally 'ss' must fill udiag_ino and udiag_cookie with
> > values matching a live unix socket. And before that you have to add
> > more code to allow 'ss' dumping such values (or fetch them with some
> > bpf/perf probe).
> >
> > >
> > > Ah, I misunderstood that the found sk is passed to sk_user_ns(), but it's
> > > skb->sk.
> >
> > I did not double check the race you outlined in this patch. That could
> > still possibly be a valid/existing one.
> >
> > > P.S.  I'm leaving for Japan today and will be bit slow this and next week
> > > for vacation.
> >
> > Have a nice trip ;)
> >
> > /P
