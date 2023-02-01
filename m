Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0234686ED7
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 20:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbjBATXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 14:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbjBATXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 14:23:02 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375F0E059;
        Wed,  1 Feb 2023 11:22:59 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id be8so19481450plb.7;
        Wed, 01 Feb 2023 11:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RqZRAezoKYYy8uGhEGpwENO1d5CS3JBRn3AdFHjwWpE=;
        b=lHYfUP0EDPvRhTzOcjQLO69TXZVUsfBFJt1+VzuAJTN0lbs9Pa7B0kdxVy7JCyvPMx
         K847PGEIw96DqtzhxrvWkeAC+uiulI6i0MVGxlExV4b4jhBMUH1Zmr0dFYJrSuHN0cnc
         2w1lcp+wr7H6sfA+Dfry1m8LuVQ22eDctmVqYlped10fKxBr0zMVo2Ud+Oqx0Dc00vgj
         BIvct5RsoFrIwXfkbKe0zfED9xj2HZQreW6DPTNTwno2xCgyzH8Hoo+NCYgl8Ac6RkBs
         7VCAOJ9lL6pbp6M+HWtwGijWe5jeTNbj+ldUyE9iaw3CGWYnqmVVAliic16JUUySVlgW
         Rluw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RqZRAezoKYYy8uGhEGpwENO1d5CS3JBRn3AdFHjwWpE=;
        b=1+uBJOBikK9lmmTbjvBRoDYIQ28RnXbBgq5dV4wVgbl+D2N40ZufGm5odVFc6sj7Dd
         xX24i/CE5CfGDxehvdwxL17AqH1YncU7jdMbg6hYoFiDXaI9QAFXkh0KUKNCv6E3kj+h
         yN16zqWy65VOXK/I9UN05ZvwU2MmK5vTsiLNLBLSYoyVbgKnF8hpcmh7XyLntQdmAX8h
         LSG/PSZOTbGd9UiwPPotzF634xPpBP17mKV+iHOPh1juv5J3rCZRJhxd5jKcA3ef895o
         QsM3iuLxP9bXPglMghQ1hmp5d1ANgsH9k5E5nB8PCrZijMFViQlxWlhzeVG/ENDs7TAL
         qYbw==
X-Gm-Message-State: AO0yUKU2n4GVhZ+UOKue+8r6hIa2ieSls3H1S/fX85OVk5oR3U790RPr
        61GLBc/rR6R9v0yH6u7HVLs=
X-Google-Smtp-Source: AK7set8BIo7jLAcpfF2QSdSl2VjcXRZGFVrmwIPXfOPfRGdqZf0mAzZciRKvCuuGa82cjpRGbpTjdw==
X-Received: by 2002:a17:902:d502:b0:18f:a0de:6ac8 with SMTP id b2-20020a170902d50200b0018fa0de6ac8mr4375632plg.2.1675279378539;
        Wed, 01 Feb 2023 11:22:58 -0800 (PST)
Received: from ip-172-31-38-16 (ec2-52-37-71-140.us-west-2.compute.amazonaws.com. [52.37.71.140])
        by smtp.gmail.com with ESMTPSA id s12-20020a17090302cc00b001743ba85d39sm12111233plk.110.2023.02.01.11.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 11:22:58 -0800 (PST)
Date:   Wed, 1 Feb 2023 19:22:57 +0000
From:   aloktiagi <aloktiagi@gmail.com>
To:     ebiederm@xmission.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tycho@tycho.pizza, sargun@sargun.me,
        aloktiagi@gmail.com
Subject: [RFC] net: add new socket option SO_SETNETNS
Message-ID: <Y9q8Ec1CJILZz7dj@ip-172-31-38-16.us-west-2.compute.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This socket option provides a mechanism for users to switch a sockets network
namespace. This enables use cases where multiple IPv6 only network namespaces
can use a single IPv4 network namespace for IPv4 only egress connectivity by
switching their sockets from IPv6 to IPv4 network namespace. This allows for
migration of systems to IPv6 only while keeping their connectivity to IPv4 only
destinations intact.

Today, we achieve this by setting up seccomp filter to intercept network system
calls like connect() from a container in a container manager which runs in an
IPv4 only network namespace. The container manager creates a new IPv4 connection
and injects the new file descriptor through SECCOMP_NOTIFY_IOCTL_ADDFD replacing
the original file descriptor from the connect() call. This does not work for
cases where the original file descriptor is handed off to a system like epoll
before the connect() call. After a new file descriptor is injected the original
file descriptor being referenced by the epoll fd is not longer valid leading to
failures. As a workaround the container manager when intercepting connect()
loops through all open socket file descriptors to check if they are referencing
the socket attempting the connect() and replace the reference with the to be
injected file descriptor. This workaround is cumbersome and makes the solution
prone to similar yet to be discovered issues.

With SO_SETNETNS, the container manager can simply switch the original
unconnected socket’s network namespace to the IPv4 only network namespace
without the need for injecting any new socket. The container can then proceed
with the connect() call and establish connectivity to the IPv4 only destination.

This socket option is only allowed for sockets that have never been connected
since connected or recently disconnected sockets maybe bound to their network
namespaces network device and switching their namespace may lead to undefined
behavior.

Signed-off-by: aloktiagi <aloktiagi@gmail.com>
---
 include/uapi/asm-generic/socket.h          |   2 +
 net/core/sock.c                            |  46 +++++
 tools/testing/selftests/net/Makefile       |   1 +
 tools/testing/selftests/net/so_set_netns.c | 208 +++++++++++++++++++++
 4 files changed, 257 insertions(+)
 create mode 100644 tools/testing/selftests/net/so_set_netns.c

diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
index 638230899e98..dc9498233fe5 100644
--- a/include/uapi/asm-generic/socket.h
+++ b/include/uapi/asm-generic/socket.h
@@ -132,6 +132,8 @@
 
 #define SO_RCVMARK		75
 
+#define SO_SETNETNS		76
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
diff --git a/net/core/sock.c b/net/core/sock.c
index f954d5893e79..34cb72b211a6 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1535,6 +1535,52 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 		WRITE_ONCE(sk->sk_txrehash, (u8)val);
 		break;
 
+	case SO_SETNETNS:
+	{
+		struct net *other_ns, *my_ns;
+
+		if (sk->sk_family != AF_INET && sk->sk_family != AF_INET6) {
+			ret = -EOPNOTSUPP;
+			break;
+		}
+
+		if (sk->sk_type != SOCK_STREAM && sk->sk_type != SOCK_DGRAM) {
+			ret = -EOPNOTSUPP;
+			break;
+		}
+
+		other_ns = get_net_ns_by_fd(val);
+		if (IS_ERR(other_ns)) {
+			ret = PTR_ERR(other_ns);
+			break;
+		}
+
+		if (!ns_capable(other_ns->user_ns, CAP_NET_ADMIN)) {
+			ret = -EPERM;
+			goto out_err;
+		}
+
+		/* check that the socket has never been connected or recently disconnected */
+		if (sk->sk_state != TCP_CLOSE || sk->sk_shutdown & SHUTDOWN_MASK) {
+			ret = -EOPNOTSUPP;
+			goto out_err;
+		}
+
+		/* check that the socket is not bound to an interface*/
+		if (sk->sk_bound_dev_if != 0) {
+			ret = -EOPNOTSUPP;
+			goto out_err;
+		}
+
+		my_ns = sock_net(sk);
+		sock_net_set(sk, other_ns);
+		put_net(my_ns);
+		break;
+out_err:
+		put_net(other_ns);
+		break;
+	}
+
 	default:
 		ret = -ENOPROTOOPT;
 		break;
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 3007e98a6d64..c2e7679e31bb 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -75,6 +75,7 @@ TEST_GEN_PROGS += so_incoming_cpu
 TEST_PROGS += sctp_vrf.sh
 TEST_GEN_FILES += sctp_hello
 TEST_GEN_FILES += csum
+TEST_GEN_PROGS += so_set_netns
 
 TEST_FILES := settings
 
diff --git a/tools/testing/selftests/net/so_set_netns.c b/tools/testing/selftests/net/so_set_netns.c
new file mode 100644
index 000000000000..cc7767d23a5d
--- /dev/null
+++ b/tools/testing/selftests/net/so_set_netns.c
@@ -0,0 +1,208 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+
+#include <arpa/inet.h>
+#include <errno.h>
+#include <error.h>
+#include <fcntl.h>
+#include <sched.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+
+#include <linux/tcp.h>
+#include <linux/socket.h>
+
+#include <sys/types.h>
+#include <sys/sendfile.h>
+#include <sys/socket.h>
+#include <sys/stat.h>
+
+#include "../kselftest_harness.h"
+
+#ifndef SO_SETNETNS
+#define SO_SETNETNS            76
+#endif
+
+static int unshare_open(void)
+{
+	const char *netns_path = "/proc/self/ns/net";
+	int fd, ret;
+
+	if (unshare(CLONE_NEWNET) != 0)
+		return -1;
+
+	fd = open(netns_path, O_RDONLY);
+	if (fd <= 0)
+		return -1;
+
+	ret = system("ip link set lo up");
+	if (ret < 0)
+		return -1;
+
+	return fd;
+}
+
+static int switch_ns(int fd)
+{
+	if (setns(fd, CLONE_NEWNET))
+		return -1;
+	return 0;
+}
+
+static void init_namespaces(struct __test_metadata *_metadata,
+			   int *netns_client, int *netns_server)
+{
+	*netns_client = unshare_open();
+	ASSERT_GE(*netns_client, 0);
+
+	*netns_server = unshare_open();
+	ASSERT_GE(*netns_server, 0);
+}
+
+static void setup_network(struct __test_metadata *_metadata,
+			  int *netns_client, int *netns_server)
+{
+	int ret;
+
+	ret = switch_ns(*netns_client);
+	ASSERT_EQ(ret, 0);
+
+	ret = system("ip addr add fd::1/64 dev lo");
+	ASSERT_EQ(ret, 0);
+
+	ret = switch_ns(*netns_server);
+	ASSERT_EQ(ret, 0);
+
+	ret = system("ip addr add 192.168.1.1/24 dev lo");
+	ASSERT_EQ(ret, 0);
+}
+
+static void setup_client_server(struct __test_metadata *_metadata,
+				int *netns_client, int *netns_server,
+			        int *client_fd, int *server_fd)
+{
+	struct sockaddr_in addr;
+	int ret;
+
+	ret = switch_ns(*netns_client);
+	ASSERT_EQ(ret, 0);
+
+	*client_fd = socket(AF_INET, SOCK_STREAM, 0);
+
+	ret = switch_ns(*netns_server);
+	ASSERT_EQ(ret, 0);
+
+	addr.sin_family = AF_INET;
+	addr.sin_addr.s_addr = inet_addr("192.168.1.1");
+	addr.sin_port = htons(80);
+
+	*server_fd = socket(AF_INET, SOCK_STREAM, 0);
+	ret = bind(*server_fd, &addr, sizeof(addr));
+	ASSERT_EQ(ret, 0);
+	ret = listen(*server_fd, 10);
+	ASSERT_EQ(ret, 0);
+}
+
+FIXTURE(so_set_netns)
+{
+	int netns_client, netns_server;
+	int client_fd, server_fd;
+};
+
+FIXTURE_SETUP(so_set_netns)
+{
+	init_namespaces(_metadata, &self->netns_client, &self->netns_server);
+	setup_network(_metadata, &self->netns_client, &self->netns_server);
+	setup_client_server(_metadata,
+			    &self->netns_client, &self->netns_server,
+			    &self->client_fd, &self->server_fd);
+}
+
+FIXTURE_TEARDOWN(so_set_netns)
+{
+	close(self->client_fd);
+	close(self->server_fd);
+	close(self->netns_client);
+	close(self->netns_server);
+}
+
+TEST_F(so_set_netns, test_socket_ns_switch_unconnected) {
+	struct sockaddr_in addr;
+	int ret;
+
+	addr.sin_family = AF_INET;
+	addr.sin_addr.s_addr = inet_addr("192.168.1.1");
+	addr.sin_port = htons(80);
+
+	ret = switch_ns(self->netns_client);
+	ASSERT_EQ(ret, 0);
+
+	ret = setsockopt(self->client_fd,
+                         SOL_SOCKET, SO_SETNETNS,
+                         &self->netns_server,
+                         sizeof(self->netns_server));
+	ASSERT_EQ(ret, 0);
+
+	ret = connect(self->client_fd, &addr, sizeof(addr));
+	ASSERT_EQ(ret, 0);
+}
+
+TEST_F(so_set_netns, test_socket_ns_switch_connected) {
+	struct sockaddr_in addr;
+	int ret;
+
+	addr.sin_family = AF_INET;
+	addr.sin_addr.s_addr = inet_addr("192.168.1.1");
+	addr.sin_port = htons(80);
+
+	ret = setsockopt(self->client_fd,
+                         SOL_SOCKET, SO_SETNETNS,
+			 &self->netns_server,
+			 sizeof(self->netns_server));
+	ASSERT_EQ(ret, 0);
+
+	ret = connect(self->client_fd, &addr, sizeof(addr));
+	ASSERT_EQ(ret, 0);
+
+	// switching network namespace of connected
+	// socket should fail
+	ret = setsockopt(self->client_fd,
+			 SOL_SOCKET, SO_SETNETNS,
+			 &self->netns_client,
+			 sizeof(self->netns_client));
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, EOPNOTSUPP);
+}
+
+TEST_F(so_set_netns, test_socket_ns_switch_disconnected) {
+	struct sockaddr_in addr;
+	int ret;
+
+	addr.sin_family = AF_INET;
+	addr.sin_addr.s_addr = inet_addr("192.168.1.1");
+	addr.sin_port = htons(80);
+
+	ret = setsockopt(self->client_fd,
+			 SOL_SOCKET, SO_SETNETNS,
+			 &self->netns_server,
+			 sizeof(self->netns_server));
+	ASSERT_EQ(ret, 0);
+
+	ret = connect(self->client_fd, &addr, sizeof(addr));
+	ASSERT_EQ(ret, 0);
+
+	close(self->server_fd);
+
+	// switching network namespace of recently disconnected
+	// socket should fail
+	ret = setsockopt(self->client_fd,
+			 SOL_SOCKET, SO_SETNETNS,
+			 &self->netns_client,
+			 sizeof(self->netns_client));
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, EOPNOTSUPP);
+}
+
+TEST_HARNESS_MAIN
-- 
2.34.1

