Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8296D5F913D
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbiJIWa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbiJIW3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:29:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C3A3C8FC;
        Sun,  9 Oct 2022 15:19:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75E40B80DCE;
        Sun,  9 Oct 2022 22:16:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0321C433C1;
        Sun,  9 Oct 2022 22:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353783;
        bh=xklVpIJmlttcbRUn9vRu+iL6LZXyO7Eb5rTig1bQAy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nv9+AGi/FYbRpeM55L50QNNz+6AXxL044haeQC8YcV+reQwXIrzzzUGuEBwHC9jo1
         YkffcL47gmla4GbbBrqaZxHCx2qGO3bEJ+Q3tb0oSFN+8LhHZvfM+6mcJLh20MjlgK
         gQqNOKzkY/MqL8ukcGLE2Y9GdaENBjkdMN1vVl4RSB9fsdCgeLtpJhZWGlp3WwKrcR
         pvxAiLPPAkanq1RU0CrfKx15RLDkRhsUjhNpgSmtYX8RkAmmZKt+8vLhd9BJbPqGJf
         YAJqM9d4FECqvYrUPf04kbB50uwezZotB272pdmgPGPTupghMKqhtToeGy5uHhEuRo
         EdppMl9E3dOWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Richard Gobert <richardbgobert@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, edumazet@google.com, pabeni@redhat.com,
        shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 21/73] net-next: Fix IP_UNICAST_IF option behavior for connected sockets
Date:   Sun,  9 Oct 2022 18:13:59 -0400
Message-Id: <20221009221453.1216158-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221453.1216158-1-sashal@kernel.org>
References: <20221009221453.1216158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Gobert <richardbgobert@gmail.com>

[ Upstream commit 0e4d354762cefd3e16b4cff8988ff276e45effc4 ]

The IP_UNICAST_IF socket option is used to set the outgoing interface
for outbound packets.

The IP_UNICAST_IF socket option was added as it was needed by the
Wine project, since no other existing option (SO_BINDTODEVICE socket
option, IP_PKTINFO socket option or the bind function) provided the
needed characteristics needed by the IP_UNICAST_IF socket option. [1]
The IP_UNICAST_IF socket option works well for unconnected sockets,
that is, the interface specified by the IP_UNICAST_IF socket option
is taken into consideration in the route lookup process when a packet
is being sent. However, for connected sockets, the outbound interface
is chosen when connecting the socket, and in the route lookup process
which is done when a packet is being sent, the interface specified by
the IP_UNICAST_IF socket option is being ignored.

This inconsistent behavior was reported and discussed in an issue
opened on systemd's GitHub project [2]. Also, a bug report was
submitted in the kernel's bugzilla [3].

To understand the problem in more detail, we can look at what happens
for UDP packets over IPv4 (The same analysis was done separately in
the referenced systemd issue).
When a UDP packet is sent the udp_sendmsg function gets called and
the following happens:

1. The oif member of the struct ipcm_cookie ipc (which stores the
output interface of the packet) is initialized by the ipcm_init_sk
function to inet->sk.sk_bound_dev_if (the device set by the
SO_BINDTODEVICE socket option).

2. If the IP_PKTINFO socket option was set, the oif member gets
overridden by the call to the ip_cmsg_send function.

3. If no output interface was selected yet, the interface specified
by the IP_UNICAST_IF socket option is used.

4. If the socket is connected and no destination address is
specified in the send function, the struct ipcm_cookie ipc is not
taken into consideration and the cached route, that was calculated in
the connect function is being used.

Thus, for a connected socket, the IP_UNICAST_IF sockopt isn't taken
into consideration.

This patch corrects the behavior of the IP_UNICAST_IF socket option
for connect()ed sockets by taking into consideration the
IP_UNICAST_IF sockopt when connecting the socket.

In order to avoid reconnecting the socket, this option is still
ignored when applied on an already connected socket until connect()
is called again by the Richard Gobert.

Change the __ip4_datagram_connect function, which is called during
socket connection, to take into consideration the interface set by
the IP_UNICAST_IF socket option, in a similar way to what is done in
the udp_sendmsg function.

[1] https://lore.kernel.org/netdev/1328685717.4736.4.camel@edumazet-laptop/T/
[2] https://github.com/systemd/systemd/issues/11935#issuecomment-618691018
[3] https://bugzilla.kernel.org/show_bug.cgi?id=210255

Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20220829111554.GA1771@debian
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/datagram.c                       |  2 ++
 tools/testing/selftests/net/fcnal-test.sh | 30 +++++++++++++++++++++++
 tools/testing/selftests/net/nettest.c     | 16 ++++++++++--
 3 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
index ffd57523331f..405a8c2aea64 100644
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -42,6 +42,8 @@ int __ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len
 			oif = inet->mc_index;
 		if (!saddr)
 			saddr = inet->mc_addr;
+	} else if (!oif) {
+		oif = inet->uc_index;
 	}
 	fl4 = &inet->cork.fl.u.ip4;
 	rt = ip_route_connect(fl4, usin->sin_addr.s_addr, saddr, oif,
diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 03b586760164..31c3b6ebd388 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -1466,6 +1466,13 @@ ipv4_udp_novrf()
 		run_cmd nettest -D -r ${a} -d ${NSA_DEV} -S -0 ${NSA_IP}
 		log_test_addr ${a} $? 0 "Client, device bind via IP_UNICAST_IF"
 
+		log_start
+		run_cmd_nsb nettest -D -s &
+		sleep 1
+		run_cmd nettest -D -r ${a} -d ${NSA_DEV} -S -0 ${NSA_IP} -U
+		log_test_addr ${a} $? 0 "Client, device bind via IP_UNICAST_IF, with connect()"
+
+
 		log_start
 		show_hint "Should fail 'Connection refused'"
 		run_cmd nettest -D -r ${a}
@@ -1525,6 +1532,13 @@ ipv4_udp_novrf()
 	run_cmd nettest -D -d ${NSA_DEV} -S -r ${a}
 	log_test_addr ${a} $? 0 "Global server, device client via IP_UNICAST_IF, local connection"
 
+	log_start
+	run_cmd nettest -s -D &
+	sleep 1
+	run_cmd nettest -D -d ${NSA_DEV} -S -r ${a} -U
+	log_test_addr ${a} $? 0 "Global server, device client via IP_UNICAST_IF, local connection, with connect()"
+
+
 	# IPv4 with device bind has really weird behavior - it overrides the
 	# fib lookup, generates an rtable and tries to send the packet. This
 	# causes failures for local traffic at different places
@@ -1550,6 +1564,15 @@ ipv4_udp_novrf()
 		sleep 1
 		run_cmd nettest -D -r ${a} -d ${NSA_DEV} -S
 		log_test_addr ${a} $? 1 "Global server, device client via IP_UNICAST_IF, local connection"
+
+		log_start
+		show_hint "Should fail since addresses on loopback are out of device scope"
+		run_cmd nettest -D -s &
+		sleep 1
+		run_cmd nettest -D -r ${a} -d ${NSA_DEV} -S -U
+		log_test_addr ${a} $? 1 "Global server, device client via IP_UNICAST_IF, local connection, with connect()"
+
+
 	done
 
 	a=${NSA_IP}
@@ -3157,6 +3180,13 @@ ipv6_udp_novrf()
 		sleep 1
 		run_cmd nettest -6 -D -r ${a} -d ${NSA_DEV} -S
 		log_test_addr ${a} $? 1 "Global server, device client via IP_UNICAST_IF, local connection"
+
+		log_start
+		show_hint "Should fail 'No route to host' since addresses on loopback are out of device scope"
+		run_cmd nettest -6 -D -s &
+		sleep 1
+		run_cmd nettest -6 -D -r ${a} -d ${NSA_DEV} -S -U
+		log_test_addr ${a} $? 1 "Global server, device client via IP_UNICAST_IF, local connection, with connect()"
 	done
 
 	a=${NSA_IP6}
diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index d9a6fd2cd9d3..7900fa98eccb 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -127,6 +127,9 @@ struct sock_args {
 
 	/* ESP in UDP encap test */
 	int use_xfrm;
+
+	/* use send() and connect() instead of sendto */
+	int datagram_connect;
 };
 
 static int server_mode;
@@ -979,6 +982,11 @@ static int send_msg(int sd, void *addr, socklen_t alen, struct sock_args *args)
 			log_err_errno("write failed sending msg to peer");
 			return 1;
 		}
+	} else if (args->datagram_connect) {
+		if (send(sd, msg, msglen, 0) < 0) {
+			log_err_errno("send failed sending msg to peer");
+			return 1;
+		}
 	} else if (args->ifindex && args->use_cmsg) {
 		if (send_msg_cmsg(sd, addr, alen, args->ifindex, args->version))
 			return 1;
@@ -1659,7 +1667,7 @@ static int connectsock(void *addr, socklen_t alen, struct sock_args *args)
 	if (args->has_local_ip && bind_socket(sd, args))
 		goto err;
 
-	if (args->type != SOCK_STREAM)
+	if (args->type != SOCK_STREAM && !args->datagram_connect)
 		goto out;
 
 	if (args->password && tcp_md5sig(sd, addr, alen, args))
@@ -1854,7 +1862,7 @@ static int ipc_parent(int cpid, int fd, struct sock_args *args)
 	return client_status;
 }
 
-#define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:M:X:m:d:I:BN:O:SCi6xL:0:1:2:3:Fbqf"
+#define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:M:X:m:d:I:BN:O:SUCi6xL:0:1:2:3:Fbqf"
 #define OPT_FORCE_BIND_KEY_IFINDEX 1001
 #define OPT_NO_BIND_KEY_IFINDEX 1002
 
@@ -1891,6 +1899,7 @@ static void print_usage(char *prog)
 	"    -I dev        bind socket to given device name - server mode\n"
 	"    -S            use setsockopt (IP_UNICAST_IF or IP_MULTICAST_IF)\n"
 	"                  to set device binding\n"
+	"    -U            Use connect() and send() for datagram sockets\n"
 	"    -f            bind socket with the IP[V6]_FREEBIND option\n"
 	"    -C            use cmsg and IP_PKTINFO to specify device binding\n"
 	"\n"
@@ -2074,6 +2083,9 @@ int main(int argc, char *argv[])
 		case 'x':
 			args.use_xfrm = 1;
 			break;
+		case 'U':
+			args.datagram_connect = 1;
+			break;
 		default:
 			print_usage(argv[0]);
 			return 1;
-- 
2.35.1

