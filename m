Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57E865A4B49
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 14:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbiH2MOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 08:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbiH2MNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 08:13:08 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0439F74DFE;
        Mon, 29 Aug 2022 04:57:33 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id z20so7806227ljq.3;
        Mon, 29 Aug 2022 04:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:from:to:cc;
        bh=RA6DkUv8MSMocWrvkLNhvgNQ2goULR49gWe3I7wFN5U=;
        b=Kl/Syp3+EAcFpPOghWDlOngrZeqaB68uh8XYxqO5fuYmEbgki1wj+nrijfCN+cdXGp
         6YdI9b5SXky0nYiWsFCktpcJGgQr5k4HNp9w8s2Qt89SFICBk5XfKogvJYR4uQd/O2dm
         IzKreuWCUzvVjNe1S/ZUxQgrGbKkXudJi0kht+rXACJTHPO0Io/o8nZRbego4ffEpTie
         2s2JV7jjjEp5NV7V322GA61PhDQp4UJbVm0wML/sJ/zuE9RjNZ9ClRBOhg+Qvu2T6/LR
         31WH8omQWjZPqk+mQfAqe51ToWDH4WntzvBJkmvmBJw/SZe/zRveZn4IJaoUvwJrRCVJ
         nJFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:x-gm-message-state:from:to:cc;
        bh=RA6DkUv8MSMocWrvkLNhvgNQ2goULR49gWe3I7wFN5U=;
        b=ZXMcZbCO3NrW0I9VhvpetIhD4PkavjK1I5xIrzWltktHWhc2d0J7ScZTgFyJ5nN3XH
         SfijgnZu91PFMK/dQcSFovChgxf+lQPHdsspalBUYUhWHLV4LnSG7cDHqvQVfBThgVmZ
         c/itycxwd7FYQygUamLkXS3BKhaGPJrJION5njHU1WZ9dqp5V1RNy9gM51b+F/03Onh9
         2gWpFYnjVUNKPjW/rvXtWwOji+rZEz9zVV+zR44Bc3jGoJG8opI11+7cesvhJ/IJsFNr
         Yy5LLzlUObITy3xEBYOymuNb4yPsrI9KfXMP5w9AiyjAAk2I7OdFUSZojH/EO3XlcmDR
         b91g==
X-Gm-Message-State: ACgBeo3rkcAa2qgS30F/EaRou6iBzDPEZqFH01EgUrPQS4uaN+B4FlHq
        HdpM5vfdCfxA+hwgtSMq25zZOTaCHhk=
X-Google-Smtp-Source: AA6agR6RJ6ZVJZFxAhZOAd5g7YjpwROB/ifshazPwGfK0h0INlVdPFf++xccFA6R80raa/MsgU/irQ==
X-Received: by 2002:a5d:64c6:0:b0:225:4073:8fef with SMTP id f6-20020a5d64c6000000b0022540738fefmr6169096wri.253.1661772038535;
        Mon, 29 Aug 2022 04:20:38 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id n18-20020a05600c3b9200b003a846a014c1sm3709891wms.23.2022.08.29.04.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 04:20:38 -0700 (PDT)
Date:   Mon, 29 Aug 2022 13:18:51 +0200
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH v2] net-next: Fix IP_UNICAST_IF option behavior for connected
 sockets
Message-ID: <20220829111554.GA1771@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
v1 -> v2: Added self-tests and targeted to net-next.

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
2.36.1

