Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2FB635AB7
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236371AbiKWK52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237358AbiKWK5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:57:05 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65105F2C28;
        Wed, 23 Nov 2022 02:50:01 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AN8UFL8010187;
        Wed, 23 Nov 2022 10:49:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=mXiiolj1vyMDqNLNcOvBqyT7McpywFknUHRx0axon80=;
 b=Fc/bdz03SPpDg182pzk7w7sA2MdaSJJ4QY7+UL15/nyt+cca7TMNWBVbwYenN7RDKxx1
 JTgxT2RKOnAZTppL6ZZT7I7XabG5eYe2iOyY2WKfXiHqDTKB5RwJll9wVIEIT/BQQ4iB
 KW6CxNlLdRWP2TKJiCPW6Mo/DJsOeqOPfFPDGEY93OiKlpqvOxLx0Q5W5eIRbn2HaAmA
 Kp5A6IcxpJRFSuDNRyafvJPnsRAuohuKXpA2CoNY4R4ZfROQ5XbvrbBT9KbTWmVqsS8h
 tZpY07BPbGi/znvElthTx9hSDxF/w/JMZCA3s1AWjJzMFcF12yFFczu2FEn7gIqRqvIp ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m10bm9q6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 10:49:52 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ANAfYaF001797;
        Wed, 23 Nov 2022 10:49:52 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m10bm9q66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 10:49:51 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ANAb27W001428;
        Wed, 23 Nov 2022 10:49:49 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3kxps8wj5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 10:49:49 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ANAoRfS43647358
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 10:50:27 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3043F5204F;
        Wed, 23 Nov 2022 10:49:46 +0000 (GMT)
Received: from LAPTOP-8S6R7U4L.localdomain (unknown [9.171.0.166])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6240652050;
        Wed, 23 Nov 2022 10:49:45 +0000 (GMT)
From:   Jan Karcher <jaka@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Jan Karcher <jaka@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Subject: [PATCH net] net/smc: Fix expected buffersizes and sync logic
Date:   Wed, 23 Nov 2022 11:49:07 +0100
Message-Id: <20221123104907.14624-1-jaka@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KPfWBkxcK3dGgQDX4ql8805QeBciClmx
X-Proofpoint-GUID: ODtQyDf4S08fxcYZfwWLsMOrrd7BXWcS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_05,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 clxscore=1011
 lowpriorityscore=0 malwarescore=0 phishscore=0 spamscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211230079
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fixed commit changed the expected behavior of buffersizes
set by the user using the setsockopt mechanism.
Before the fixed patch the logic for determining the buffersizes used
was the following:

default  = net.ipv4.tcp_{w|r}mem[1]
sockopt  = the setsockopt mechanism
val      = the value assigned in default or via setsockopt
sk_buf   = short for sk_{snd|rcv}buf
real_buf = the real size of the buffer (sk_buf_size in __smc_buf_create)

  exposed   | net/core/sock.c  |    af_smc.c    |  smc_core.c
            |                  |                |
+---------+ |                  | +------------+ | +-------------------+
| default |----------------------| sk_buf=val |---| real_buf=sk_buf/2 |
+---------+ |                  | +------------+ | +-------------------+
            |                  |                |    ^
            |                  |                |    |
+---------+ | +--------------+ |                |    |
| sockopt |---| sk_buf=val*2 |-----------------------|
+---------+ | +--------------+ |                |
            |                  |                |

The fixed patch introduced a dedicated sysctl for smc
and removed the /2 in smc_core.c resulting in the following flow:

default  = net.smc.{w|r}mem (which defaults to net.ipv4.tcp_{w|r}mem[1])
sockopt  = the setsockopt mechanism
val      = the value assigned in default or via setsockopt
sk_buf   = short for sk_{snd|rcv}buf
real_buf = the real size of the buffer (sk_buf_size in __smc_buf_create)

  exposed   | net/core/sock.c  |    af_smc.c    |  smc_core.c
            |                  |                |
+---------+ |                  | +------------+ | +-----------------+
| default |----------------------| sk_buf=val |---| real_buf=sk_buf |
+---------+ |                  | +------------+ | +-----------------+
            |                  |                |    ^
            |                  |                |    |
+---------+ | +--------------+ |                |    |
| sockopt |---| sk_buf=val*2 |-----------------------|
+---------+ | +--------------+ |                |
            |                  |                |

This would result in double of memory used for existing configurations
that are using setsockopt.

SMC historically decided to use the explicit value given by the user
to allocate the memory. This is why we used the /2 in smc_core.c.
That logic was not applied to the default value.
Since we now have our own sysctl, which is also exposed to the user,
we should sync the logic in a way that both values are the real value
used by our code and shown by smc_stats. To achieve this this patch
changes the behavior to:

default  = net.smc.{w|r}mem (which defaults to net.ipv4.tcp_{w|r}mem[1])
sockopt  = the setsockopt mechanism
val      = the value assigned in default or via setsockopt
sk_buf   = short for sk_{snd|rcv}buf
real_buf = the real size of the buffer (sk_buf_size in __smc_buf_create)

  exposed   | net/core/sock.c  |    af_smc.c     |  smc_core.c
            |                  |                 |
+---------+ |                  | +-------------+ | +-----------------+
| default |----------------------| sk_buf=val*2|---|real_buf=sk_buf/2|
+---------+ |                  | +-------------+ | +-----------------+
            |                  |                 |    ^
            |                  |                 |    |
+---------+ | +--------------+ |                 |    |
| sockopt |---| sk_buf=val*2 |------------------------|
+---------+ | +--------------+ |                 |
            |                  |                 |

This way both paths follow the same pattern and the expected behavior
is re-established.

Fixes: 0227f058aa29 ("net/smc: Unbind r/w buffer size from clcsock and make them tunable")
Signed-off-by: Jan Karcher <jaka@linux.ibm.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
---
 net/smc/af_smc.c   | 9 +++++++--
 net/smc/smc_core.c | 8 ++++----
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 036532cf39aa..a8c84e7bac99 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -366,6 +366,7 @@ static void smc_destruct(struct sock *sk)
 static struct sock *smc_sock_alloc(struct net *net, struct socket *sock,
 				   int protocol)
 {
+	int buffersize_without_overhead;
 	struct smc_sock *smc;
 	struct proto *prot;
 	struct sock *sk;
@@ -379,8 +380,12 @@ static struct sock *smc_sock_alloc(struct net *net, struct socket *sock,
 	sk->sk_state = SMC_INIT;
 	sk->sk_destruct = smc_destruct;
 	sk->sk_protocol = protocol;
-	WRITE_ONCE(sk->sk_sndbuf, READ_ONCE(net->smc.sysctl_wmem));
-	WRITE_ONCE(sk->sk_rcvbuf, READ_ONCE(net->smc.sysctl_rmem));
+	buffersize_without_overhead =
+		min_t(int, READ_ONCE(net->smc.sysctl_wmem), INT_MAX / 2);
+	WRITE_ONCE(sk->sk_sndbuf, buffersize_without_overhead * 2);
+	buffersize_without_overhead =
+		min_t(int, READ_ONCE(net->smc.sysctl_rmem), INT_MAX / 2);
+	WRITE_ONCE(sk->sk_rcvbuf, buffersize_without_overhead * 2);
 	smc = smc_sk(sk);
 	INIT_WORK(&smc->tcp_listen_work, smc_tcp_listen_work);
 	INIT_WORK(&smc->connect_work, smc_connect_work);
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 00fb352c2765..36850a2ae167 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -2314,10 +2314,10 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 
 	if (is_rmb)
 		/* use socket recv buffer size (w/o overhead) as start value */
-		sk_buf_size = smc->sk.sk_rcvbuf;
+		sk_buf_size = smc->sk.sk_rcvbuf / 2;
 	else
 		/* use socket send buffer size (w/o overhead) as start value */
-		sk_buf_size = smc->sk.sk_sndbuf;
+		sk_buf_size = smc->sk.sk_sndbuf / 2;
 
 	for (bufsize_short = smc_compress_bufsize(sk_buf_size, is_smcd, is_rmb);
 	     bufsize_short >= 0; bufsize_short--) {
@@ -2376,7 +2376,7 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 	if (is_rmb) {
 		conn->rmb_desc = buf_desc;
 		conn->rmbe_size_short = bufsize_short;
-		smc->sk.sk_rcvbuf = bufsize;
+		smc->sk.sk_rcvbuf = bufsize * 2;
 		atomic_set(&conn->bytes_to_rcv, 0);
 		conn->rmbe_update_limit =
 			smc_rmb_wnd_update_limit(buf_desc->len);
@@ -2384,7 +2384,7 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 			smc_ism_set_conn(conn); /* map RMB/smcd_dev to conn */
 	} else {
 		conn->sndbuf_desc = buf_desc;
-		smc->sk.sk_sndbuf = bufsize;
+		smc->sk.sk_sndbuf = bufsize * 2;
 		atomic_set(&conn->sndbuf_space, bufsize);
 	}
 	return 0;
-- 
2.34.1

