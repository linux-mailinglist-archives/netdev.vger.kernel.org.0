Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94BA50BA79
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 16:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448854AbiDVOpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 10:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448842AbiDVOpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 10:45:34 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E825BE71;
        Fri, 22 Apr 2022 07:42:39 -0700 (PDT)
Received: from fsav116.sakura.ne.jp (fsav116.sakura.ne.jp [27.133.134.243])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 23MEf0Hj018198;
        Fri, 22 Apr 2022 23:41:00 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav116.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav116.sakura.ne.jp);
 Fri, 22 Apr 2022 23:41:00 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav116.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 23MEexme018193
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 22 Apr 2022 23:41:00 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <b0f99499-fb6a-b9ec-7bd3-f535f11a885d@I-love.SAKURA.ne.jp>
Date:   Fri, 22 Apr 2022 23:40:59 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [syzbot] KASAN: use-after-free Read in tcp_retransmit_timer (5)
Content-Language: en-US
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        OFED mailing list <linux-rdma@vger.kernel.org>
Cc:     syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>,
        andrii@kernel.org, andriin@fb.com, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, dsahern@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tpa@hlghospital.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org, bpf@vger.kernel.org
References: <00000000000045dc96059f4d7b02@google.com>
 <000000000000f75af905d3ba0716@google.com>
 <c389e47f-8f82-fd62-8c1d-d9481d2f71ff@I-love.SAKURA.ne.jp>
In-Reply-To: <c389e47f-8f82-fd62-8c1d-d9481d2f71ff@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, RDS developers.

I was thinking that BPF program is relevant with the TCP/IPv6 socket triggering
use-after-free access. But disassembling syzkaller-generated BPF program concluded
that what "char program[2053]" is doing is not important
( https://lkml.kernel.org/r/d21e278f-a3ff-8603-f6ba-b51a8cddafa8@I-love.SAKURA.ne.jp ).

Then, I realized that TCP/IPv6 port 16385 (which the reproducer is accessing) is
used by kernel RDS server, which can explain
"It seems that a socket with sk->sk_net_refcnt=0 is created by unshare(CLONE_NEWNET)"
at https://lkml.kernel.org/r/fa445f0e-32b7-5e0d-9326-94bc5adba4c1@I-love.SAKURA.ne.jp
because the kernel RDS server starts during boot procedure.

------------------------------------------------------------
root@fuzz:~# unshare -n netstat -tanpe
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       User       Inode      PID/Program name
tcp6       0      0 :::16385                :::*                    LISTEN      0          19627      -
------------------------------------------------------------

With the debug printk() patch shown below,

------------------------------------------------------------
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 0ec2f5906a27..20b3c42b4140 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -429,7 +429,8 @@ static void net_free(struct net *net)
 {
 	if (refcount_dec_and_test(&net->passive)) {
 		kfree(rcu_access_pointer(net->gen));
-		kmem_cache_free(net_cachep, net);
+		memset(net, POISON_FREE, sizeof(struct net));
+		//kmem_cache_free(net_cachep, net);
 	}
 }
 
diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index 09cadd556d1e..5792fe3df8ac 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -146,10 +146,9 @@ int rds_tcp_accept_one(struct socket *sock)
 	my_addr = &saddr;
 	peer_addr = &daddr;
 #endif
-	rdsdebug("accepted family %d tcp %pI6c:%u -> %pI6c:%u\n",
-		 sock->sk->sk_family,
-		 my_addr, ntohs(inet->inet_sport),
-		 peer_addr, ntohs(inet->inet_dport));
+	pr_info("accepted family %d tcp %pI6c:%u -> %pI6c:%u refcnt=%d sock_net=%px init_net=%px\n",
+		sock->sk->sk_family, my_addr, ntohs(inet->inet_sport), peer_addr,
+		ntohs(inet->inet_dport), sock->sk->sk_net_refcnt, sock_net(sock->sk), &init_net);
 
 #if IS_ENABLED(CONFIG_IPV6)
 	/* sk_bound_dev_if is not set if the peer address is not link local
------------------------------------------------------------

I get

    accepted family 10 tcp ::ffff:127.0.0.1:16385 -> ::ffff:127.0.0.1:33086 refcnt=0 sock_net=ffffffff860d89c0 init_net=ffffffff860d89c0

if I do

    # echo > /dev/tcp/127.0.0.1/16385

 from init_net namespace, and I get

    accepted family 10 tcp ::ffff:127.0.0.1:16385 -> ::ffff:127.0.0.1:33088 refcnt=0 sock_net=ffff88810a208000 init_net=ffffffff860d89c0

if I do

    # echo > /dev/tcp/127.0.0.1/16385

 from non-init_net namespace. Note that sock->sk->sk_net_refcnt is 0 in both cases.

Like commit 2303f994b3e18709 ("mptcp: Associate MPTCP context with TCP socket") says

    /* kernel sockets do not by default acquire net ref, but TCP timer
     * needs it.
     */

, I came to feel that e.g. rds_tcp_accept_one() is accessing sock_net(sock->sk) on
accepted sockets with sock->sk->sk_net_refcnt=0 (because the listening socket was
created by kernel) is causing this problem. Why not rds kernel server does

	sock->sk->sk_net_refcnt = 1;
	get_net_track(net, &sock->sk->ns_tracker, GFP_KERNEL);
	sock_inuse_add(net, 1);

on accepted sockets like mptcp_subflow_create_socket() does?

For your testing, below is the latest reproducer.
You can try this reproducer with keep-memory-poisoned patch shown above.

------------------------------------------------------------
// https://syzkaller.appspot.com/bug?id=8f0e04b2beffcd42f044d46879cc224f6eb71a99
// autogenerated by syzkaller (https://github.com/google/syzkaller)

#define _GNU_SOURCE

#include <arpa/inet.h>
#include <endian.h>
#include <errno.h>
#include <fcntl.h>
#include <net/if.h>
#include <pthread.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>
#include <linux/bpf.h>
#include <linux/if_ether.h>
#include <linux/netlink.h>
#include <linux/rtnetlink.h>

#ifndef MSG_PROBE
#define MSG_PROBE 0x10
#endif

struct nlmsg {
	char* pos;
	int nesting;
	struct nlattr* nested[8];
	char buf[4096];
};

static void netlink_init(struct nlmsg* nlmsg, int typ, int flags,
                         const void* data, int size)
{
	memset(nlmsg, 0, sizeof(*nlmsg));
	struct nlmsghdr* hdr = (struct nlmsghdr*)nlmsg->buf;
	hdr->nlmsg_type = typ;
	hdr->nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK | flags;
	memcpy(hdr + 1, data, size);
	nlmsg->pos = (char*)(hdr + 1) + NLMSG_ALIGN(size);
}

static void netlink_attr(struct nlmsg* nlmsg, int typ, const void* data,
                         int size)
{
	struct nlattr* attr = (struct nlattr*)nlmsg->pos;
	attr->nla_len = sizeof(*attr) + size;
	attr->nla_type = typ;
	if (size > 0)
		memcpy(attr + 1, data, size);
	nlmsg->pos += NLMSG_ALIGN(attr->nla_len);
}

static int netlink_send_ext(struct nlmsg* nlmsg, int sock, uint16_t reply_type,
                            int* reply_len, bool dofail)
{
	if (nlmsg->pos > nlmsg->buf + sizeof(nlmsg->buf) || nlmsg->nesting)
		exit(1);
	struct nlmsghdr* hdr = (struct nlmsghdr*)nlmsg->buf;
	hdr->nlmsg_len = nlmsg->pos - nlmsg->buf;
	struct sockaddr_nl addr;
	memset(&addr, 0, sizeof(addr));
	addr.nl_family = AF_NETLINK;
	ssize_t n = sendto(sock, nlmsg->buf, hdr->nlmsg_len, 0,
			   (struct sockaddr*)&addr, sizeof(addr));
	if (n != (ssize_t)hdr->nlmsg_len) {
		if (dofail)
			exit(1);
		return -1;
	}
	n = recv(sock, nlmsg->buf, sizeof(nlmsg->buf), 0);
	if (reply_len)
		*reply_len = 0;
	if (n < 0) {
		if (dofail)
			exit(1);
		return -1;
	}
	if (n < (ssize_t)sizeof(struct nlmsghdr)) {
		errno = EINVAL;
		if (dofail)
			exit(1);
		return -1;
	}
	if (hdr->nlmsg_type == NLMSG_DONE)
		return 0;
	if (reply_len && hdr->nlmsg_type == reply_type) {
		*reply_len = n;
		return 0;
	}
	if (n < (ssize_t)(sizeof(struct nlmsghdr) + sizeof(struct nlmsgerr))) {
		errno = EINVAL;
		if (dofail)
			exit(1);
		return -1;
	}
	if (hdr->nlmsg_type != NLMSG_ERROR) {
		errno = EINVAL;
		if (dofail)
			exit(1);
		return -1;
	}
	errno = -((struct nlmsgerr*)(hdr + 1))->error;
	return -errno;
}

static int netlink_send(struct nlmsg* nlmsg, int sock)
{
	return netlink_send_ext(nlmsg, sock, 0, NULL, true);
}

static void netlink_device_change(int sock, const char* name, const void* mac, int macsize)
{
	struct nlmsg nlmsg;
	struct ifinfomsg hdr;
	memset(&hdr, 0, sizeof(hdr));
	hdr.ifi_flags = hdr.ifi_change = IFF_UP;
	hdr.ifi_index = if_nametoindex(name);
	netlink_init(&nlmsg, RTM_NEWLINK, 0, &hdr, sizeof(hdr));
	netlink_attr(&nlmsg, IFLA_ADDRESS, mac, macsize);
	netlink_send(&nlmsg, sock);
}

static void netlink_add_addr(int sock, const char* dev, const void* addr, int addrsize)
{
	struct nlmsg nlmsg;
	struct ifaddrmsg hdr;
	memset(&hdr, 0, sizeof(hdr));
	hdr.ifa_family = addrsize == 4 ? AF_INET : AF_INET6;
	hdr.ifa_prefixlen = addrsize == 4 ? 24 : 120;
	hdr.ifa_scope = RT_SCOPE_UNIVERSE;
	hdr.ifa_index = if_nametoindex(dev);
	netlink_init(&nlmsg, RTM_NEWADDR, NLM_F_CREATE | NLM_F_REPLACE, &hdr,
		     sizeof(hdr));
	netlink_attr(&nlmsg, IFA_LOCAL, addr, addrsize);
	netlink_attr(&nlmsg, IFA_ADDRESS, addr, addrsize);
	netlink_send(&nlmsg, sock);
}

static void netlink_add_addr4(int sock, const char* dev, const char* addr)
{
	struct in_addr in_addr;
	inet_pton(AF_INET, addr, &in_addr);
	netlink_add_addr(sock, dev, &in_addr, sizeof(in_addr));
}

static void netlink_add_addr6(int sock, const char* dev, const char* addr)
{
	struct in6_addr in6_addr;
	inet_pton(AF_INET6, addr, &in6_addr);
	netlink_add_addr(sock, dev, &in6_addr, sizeof(in6_addr));
}

static void initialize_netdevices(void)
{
	int fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_ROUTE);
	uint64_t macaddr = 0x00aaaaaaaaaa;
	if (fd == EOF)
		exit(1);
	netlink_add_addr4(fd, "lo", "127.0.0.1");
	netlink_add_addr6(fd, "lo", "::1");
	netlink_device_change(fd, "lo", &macaddr, ETH_ALEN);
	close(fd);
}

#ifndef __NR_bpf
#define __NR_bpf 321
#endif

static void execute_one(void)
{
	const union bpf_attr attr = {
		.prog_type = BPF_PROG_TYPE_SOCKET_FILTER,
		.insn_cnt = 2,
		.insns = (unsigned long long) "\xb7\x00\x00\x00\x00\x00\x00\x00\x95\x00\x00\x00\x00\x00\x00\x00",
		.license = (unsigned long long) "GPL",
	};
	struct sockaddr_in addr = {
		.sin_family = AF_INET,
		.sin_port = htons(0x4001), /* where kernel RDS TCPv6 socket is listening */
		.sin_addr.s_addr = inet_addr("127.0.0.1")
	};
	const struct msghdr msg = {
		.msg_name = &addr,
		.msg_namelen = sizeof(addr),
	};
	const int bpf_fd = syscall(__NR_bpf, BPF_PROG_LOAD, &attr, 72);
	const int sock_fd = socket(PF_INET, SOCK_STREAM, 0);
	alarm(3);
	while (1) {
		sendmsg(sock_fd, &msg, MSG_OOB | MSG_PROBE | MSG_CONFIRM | MSG_FASTOPEN);
		setsockopt(sock_fd, SOL_SOCKET, SO_ATTACH_BPF, &bpf_fd, sizeof(bpf_fd));
	}
}

int main(int argc, char *argv[])
{
	if (unshare(CLONE_NEWNET))
		return 1;
	initialize_netdevices();
	execute_one();
	return 0;
}
------------------------------------------------------------

