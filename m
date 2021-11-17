Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95EC345433F
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 10:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbhKQJGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 04:06:00 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:44803 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbhKQJF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 04:05:59 -0500
Received: (Authenticated sender: pbl@bestov.io)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 6833B100013;
        Wed, 17 Nov 2021 09:02:56 +0000 (UTC)
From:   Riccardo Paolo Bestetti <pbl@bestov.io>
Cc:     Riccardo Paolo Bestetti <pbl@bestov.io>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH v2] ipv4/raw: support binding to nonlocal addresses
Date:   Wed, 17 Nov 2021 10:00:11 +0100
Message-Id: <20211117090010.125393-1-pbl@bestov.io>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211102141921.197561-1-pbl@bestov.io>
References: <20211102141921.197561-1-pbl@bestov.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to inet v4 raw sockets for binding to nonlocal addresses
through the IP_FREEBIND and IP_TRANSPARENT socket options, as well as
the ipv4.ip_nonlocal_bind kernel parameter.

Add helper function to inet_sock.h to check for bind address validity on
the base of the address type and whether nonlocal address are enabled
for the socket via any of the sockopts/sysctl, deduplicating checks in
ipv4/ping.c, ipv4/af_inet.c, ipv6/af_inet6.c (for mapped v4->v6
addresses), and ipv4/raw.c.

Add test cases with IP[V6]_FREEBIND verifying that both v4 and v6 raw
sockets support binding to nonlocal addresses after the change. Add
necessary support for the test cases to nettest.

Signed-off-by: Riccardo Paolo Bestetti <pbl@bestov.io>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
20211117: resending this, as Patchwork didn't pick it up last time

Responding to review by David Ahern (21 March 2021),

Thank you for your review.

> Please add test cases to ipv4_addr_bind and ipv6_addr_bind in
> tools/testing/selftests/net/fcnal-test.sh. The latter will verify if
> IPv6 works the same or needs a change.
I have added the tests for both v4 and v6.  IPv6 raw sockets already
supported the functionality (under the IPV6_* sockopts), and the (new)
related tests pass, confirming this.

I have not added negative tests (i.e. checking that the same addresses
/fail/ to bind without the necessary flags) because I haven't seen such
tests for other features.  If you feel that's needed, I can look into
it.

> Also, this check duplicates the ones in __inet_bind and __inet6_bind; it
> would be good to use an inline helper to reduce the duplication.
Done.  The same check was also duplicated in net/ipv4/ping.c, as
detailed in the commit message.  I have also deduplicated that, if it
should have been left alone I'll quickly fire up a v3 and revert that.

Sorry for the delay with v2, had a busy year.


 include/net/inet_sock.h                   | 12 +++++++
 net/ipv4/af_inet.c                        |  7 ++--
 net/ipv4/ping.c                           | 14 +++-----
 net/ipv4/raw.c                            | 13 ++++----
 net/ipv6/af_inet6.c                       |  7 ++--
 tools/testing/selftests/net/fcnal-test.sh | 40 +++++++++++++++++++++++
 tools/testing/selftests/net/nettest.c     | 33 ++++++++++++++++++-
 7 files changed, 100 insertions(+), 26 deletions(-)

diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index 89163ef8cf4b..13b05d116f6b 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -373,4 +373,16 @@ static inline bool inet_can_nonlocal_bind(struct net *net,
 		inet->freebind || inet->transparent;
 }
 
+static inline bool inet_addr_valid_or_nonlocal(struct net *net,
+					       struct inet_sock *inet,
+					       __be32 addr,
+					       int addr_type)
+{
+	return inet_can_nonlocal_bind(net, inet) ||
+		addr == htonl(INADDR_ANY) ||
+		addr_type == RTN_LOCAL ||
+		addr_type == RTN_MULTICAST ||
+		addr_type == RTN_BROADCAST;
+}
+
 #endif	/* _INET_SOCK_H */
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 1d816a5fd3eb..fb5cf3623e03 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -492,11 +492,8 @@ int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
 	 *  is temporarily down)
 	 */
 	err = -EADDRNOTAVAIL;
-	if (!inet_can_nonlocal_bind(net, inet) &&
-	    addr->sin_addr.s_addr != htonl(INADDR_ANY) &&
-	    chk_addr_ret != RTN_LOCAL &&
-	    chk_addr_ret != RTN_MULTICAST &&
-	    chk_addr_ret != RTN_BROADCAST)
+	if (!inet_addr_valid_or_nonlocal(net, inet, addr->sin_addr.s_addr,
+	                                 chk_addr_ret))
 		goto out;
 
 	snum = ntohs(addr->sin_port);
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 1e44a43acfe2..e540b0dcf085 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -311,15 +311,11 @@ static int ping_check_bind_addr(struct sock *sk, struct inet_sock *isk,
 		pr_debug("ping_check_bind_addr(sk=%p,addr=%pI4,port=%d)\n",
 			 sk, &addr->sin_addr.s_addr, ntohs(addr->sin_port));
 
-		if (addr->sin_addr.s_addr == htonl(INADDR_ANY))
-			chk_addr_ret = RTN_LOCAL;
-		else
-			chk_addr_ret = inet_addr_type(net, addr->sin_addr.s_addr);
-
-		if ((!inet_can_nonlocal_bind(net, isk) &&
-		     chk_addr_ret != RTN_LOCAL) ||
-		    chk_addr_ret == RTN_MULTICAST ||
-		    chk_addr_ret == RTN_BROADCAST)
+		chk_addr_ret = inet_addr_type(net, addr->sin_addr.s_addr);
+
+		if (!inet_addr_valid_or_nonlocal(net, inet_sk(sk),
+					         addr->sin_addr.s_addr,
+	                                         chk_addr_ret))
 			return -EADDRNOTAVAIL;
 
 #if IS_ENABLED(CONFIG_IPV6)
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index bb446e60cf58..fa60517372b5 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -717,6 +717,7 @@ static int raw_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 {
 	struct inet_sock *inet = inet_sk(sk);
 	struct sockaddr_in *addr = (struct sockaddr_in *) uaddr;
+	struct net *net = sock_net(sk);
 	u32 tb_id = RT_TABLE_LOCAL;
 	int ret = -EINVAL;
 	int chk_addr_ret;
@@ -725,16 +726,16 @@ static int raw_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 		goto out;
 
 	if (sk->sk_bound_dev_if)
-		tb_id = l3mdev_fib_table_by_index(sock_net(sk),
-						 sk->sk_bound_dev_if) ? : tb_id;
+		tb_id = l3mdev_fib_table_by_index(net,
+						  sk->sk_bound_dev_if) ? : tb_id;
 
-	chk_addr_ret = inet_addr_type_table(sock_net(sk), addr->sin_addr.s_addr,
-					    tb_id);
+	chk_addr_ret = inet_addr_type_table(net, addr->sin_addr.s_addr, tb_id);
 
 	ret = -EADDRNOTAVAIL;
-	if (addr->sin_addr.s_addr && chk_addr_ret != RTN_LOCAL &&
-	    chk_addr_ret != RTN_MULTICAST && chk_addr_ret != RTN_BROADCAST)
+	if (!inet_addr_valid_or_nonlocal(net, inet, addr->sin_addr.s_addr,
+					 chk_addr_ret))
 		goto out;
+
 	inet->inet_rcv_saddr = inet->inet_saddr = addr->sin_addr.s_addr;
 	if (chk_addr_ret == RTN_MULTICAST || chk_addr_ret == RTN_BROADCAST)
 		inet->inet_saddr = 0;  /* Use device */
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index b5878bb8e419..0c557edbbd20 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -337,11 +337,8 @@ static int __inet6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
 		chk_addr_ret = inet_addr_type_dev_table(net, dev, v4addr);
 		rcu_read_unlock();
 
-		if (!inet_can_nonlocal_bind(net, inet) &&
-		    v4addr != htonl(INADDR_ANY) &&
-		    chk_addr_ret != RTN_LOCAL &&
-		    chk_addr_ret != RTN_MULTICAST &&
-		    chk_addr_ret != RTN_BROADCAST) {
+		if (!inet_addr_valid_or_nonlocal(net, inet, v4addr,
+						 chk_addr_ret)) {
 			err = -EADDRNOTAVAIL;
 			goto out;
 		}
diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 3313566ce906..7caa4f0e067d 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -66,6 +66,10 @@ NSB_LO_IP=172.16.2.2
 NSA_LO_IP6=2001:db8:2::1
 NSB_LO_IP6=2001:db8:2::2
 
+# non-local addresses for freebind tests
+NL_IP=172.17.1.1
+NL_IP6=2001:db8:4::1
+
 MD5_PW=abc123
 MD5_WRONG_PW=abc1234
 
@@ -316,6 +320,9 @@ addr2str()
 	${NSB_LO_IP6})	echo "ns-B loopback IPv6";;
 	${NSB_LINKIP6}|${NSB_LINKIP6}%*) echo "ns-B IPv6 LLA";;
 
+	${NL_IP})       echo "nonlocal IP";;
+	${NL_IP6})      echo "nonlocal IPv6";;
+
 	${VRF_IP})	echo "VRF IP";;
 	${VRF_IP6})	echo "VRF IPv6";;
 
@@ -1767,6 +1774,14 @@ ipv4_addr_bind_novrf()
 		log_test_addr ${a} $? 0 "Raw socket bind to local address after device bind"
 	done
 
+	#
+	# raw socket with nonlocal bind
+	#
+	a=${NL_IP}
+	log_start
+	run_cmd nettest -s -R -P icmp -f -l ${a} -I ${NSA_DEV} -b
+	log_test_addr ${a} $? 0 "Raw socket bind to nonlocal address after device bind"
+
 	#
 	# tcp sockets
 	#
@@ -1815,6 +1830,14 @@ ipv4_addr_bind_vrf()
 	run_cmd nettest -s -R -P icmp -l ${a} -I ${VRF} -b
 	log_test_addr ${a} $? 1 "Raw socket bind to out of scope address after VRF bind"
 
+	#
+	# raw socket with nonlocal bind
+	#
+	a=${NL_IP}
+	log_start
+	run_cmd nettest -s -R -P icmp -f -l ${a} -I ${VRF} -b
+	log_test_addr ${a} $? 0 "Raw socket bind to nonlocal address after VRF bind"
+
 	#
 	# tcp sockets
 	#
@@ -1965,6 +1988,7 @@ ipv4_rt()
 
 	a=${NSA_IP}
 	log_start
+
 	run_cmd nettest ${varg} -s &
 	sleep 1
 	run_cmd nettest ${varg} -d ${NSA_DEV} -r ${a} &
@@ -3402,6 +3426,14 @@ ipv6_addr_bind_novrf()
 		log_test_addr ${a} $? 0 "Raw socket bind to local address after device bind"
 	done
 
+	#
+	# raw socket with nonlocal bind
+	#
+	a=${NL_IP6}
+	log_start
+	run_cmd nettest -6 -s -R -P icmp -f -l ${a} -I ${NSA_DEV} -b
+	log_test_addr ${a} $? 0 "Raw socket bind to nonlocal address"
+
 	#
 	# tcp sockets
 	#
@@ -3443,6 +3475,14 @@ ipv6_addr_bind_vrf()
 	run_cmd nettest -6 -s -R -P ipv6-icmp -l ${a} -I ${VRF} -b
 	log_test_addr ${a} $? 1 "Raw socket bind to invalid local address after vrf bind"
 
+	#
+	# raw socket with nonlocal bind
+	#
+	a=${NL_IP6}
+	log_start
+	run_cmd nettest -6 -s -R -P icmp -f -l ${a} -I ${VRF} -b
+	log_test_addr ${a} $? 0 "Raw socket bind to nonlocal address after VRF bind"
+
 	#
 	# tcp sockets
 	#
diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index b599003eb5ba..d9a6fd2cd9d3 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -85,6 +85,7 @@ struct sock_args {
 	int version;   /* AF_INET/AF_INET6 */
 
 	int use_setsockopt;
+	int use_freebind;
 	int use_cmsg;
 	const char *dev;
 	const char *server_dev;
@@ -514,6 +515,29 @@ static int set_membership(int sd, uint32_t grp, uint32_t addr, int ifindex)
 	return 0;
 }
 
+static int set_freebind(int sd, int version)
+{
+	unsigned int one = 1;
+	int rc = 0;
+
+	switch (version) {
+	case AF_INET:
+		if (setsockopt(sd, SOL_IP, IP_FREEBIND, &one, sizeof(one))) {
+			log_err_errno("setsockopt(IP_FREEBIND)");
+			rc = -1;
+		}
+		break;
+	case AF_INET6:
+		if (setsockopt(sd, SOL_IPV6, IPV6_FREEBIND, &one, sizeof(one))) {
+			log_err_errno("setsockopt(IPV6_FREEBIND");
+			rc = -1;
+		}
+		break;
+	}
+
+	return rc;
+}
+
 static int set_broadcast(int sd)
 {
 	unsigned int one = 1;
@@ -1419,6 +1443,9 @@ static int lsock_init(struct sock_args *args)
 		 set_unicast_if(sd, args->ifindex, args->version))
 		goto err;
 
+	if (args->use_freebind && set_freebind(sd, args->version))
+		goto err;
+
 	if (bind_socket(sd, args))
 		goto err;
 
@@ -1827,7 +1854,7 @@ static int ipc_parent(int cpid, int fd, struct sock_args *args)
 	return client_status;
 }
 
-#define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:M:X:m:d:I:BN:O:SCi6xL:0:1:2:3:Fbq"
+#define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:M:X:m:d:I:BN:O:SCi6xL:0:1:2:3:Fbqf"
 #define OPT_FORCE_BIND_KEY_IFINDEX 1001
 #define OPT_NO_BIND_KEY_IFINDEX 1002
 
@@ -1864,6 +1891,7 @@ static void print_usage(char *prog)
 	"    -I dev        bind socket to given device name - server mode\n"
 	"    -S            use setsockopt (IP_UNICAST_IF or IP_MULTICAST_IF)\n"
 	"                  to set device binding\n"
+	"    -f            bind socket with the IP[V6]_FREEBIND option\n"
 	"    -C            use cmsg and IP_PKTINFO to specify device binding\n"
 	"\n"
 	"    -L len        send random message of given length\n"
@@ -1999,6 +2027,9 @@ int main(int argc, char *argv[])
 		case 'S':
 			args.use_setsockopt = 1;
 			break;
+		case 'f':
+			args.use_freebind = 1;
+			break;
 		case 'C':
 			args.use_cmsg = 1;
 			break;
-- 
2.33.1

