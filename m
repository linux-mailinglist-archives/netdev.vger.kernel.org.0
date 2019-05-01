Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A45E103B7
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 03:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbfEABi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 21:38:27 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:48324 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726328AbfEABi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 21:38:27 -0400
Received: from pps.filterd (m0050095.ppops.net [127.0.0.1])
        by m0050095.ppops.net-00190b01. (8.16.0.27/8.16.0.27) with SMTP id x411bPQR015663;
        Wed, 1 May 2019 02:38:25 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id; s=jan2016.eng;
 bh=m6NyWbemQn6VjsWvnZsWs5uwncIc5b8bRn3q6kyAQ6M=;
 b=nsqKmRkNa43QvukpatbuLhNCX13tYwR1BLz1/aIhjVBklAW+sDq105m0IGsozwFB9t2T
 lNqXa+dmfHFPjC8FlTF6Ci1vgEQazGid4O0b1L+g5t9Ky7Mr6uPdzveVHt8l6JDpkQYJ
 L1DlR7i8QXuGzHEH4ee1kPbYKZYq9mgqOM0meApekoe96y0t10vsdbAKx/RNp9SFThIM
 NSizTKgTrW/ZXOBLl+4tY53efKRbDDj2NUNk0IrBPNC2E7Ne/FamEBk6iZorxkfTj734
 g5VoYbr+bVIY8kagkRRH9n8m5TfJk07t/yx3e4pFZr5KqXC9ONscNpJCjLcfXQnZbyaC aA== 
Received: from prod-mail-ppoint2 (prod-mail-ppoint2.akamai.com [184.51.33.19] (may be forged))
        by m0050095.ppops.net-00190b01. with ESMTP id 2s6grx3w25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 May 2019 02:38:25 +0100
Received: from pps.filterd (prod-mail-ppoint2.akamai.com [127.0.0.1])
        by prod-mail-ppoint2.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x411WcJG028906;
        Tue, 30 Apr 2019 21:38:23 -0400
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint2.akamai.com with ESMTP id 2s4jdver1n-1;
        Tue, 30 Apr 2019 21:38:23 -0400
Received: from bos-lpwg1 (bos-lpwg1.kendall.corp.akamai.com [172.29.171.203])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id 38CFA1FC6B;
        Wed,  1 May 2019 01:38:23 +0000 (GMT)
Received: from johunt by bos-lpwg1 with local (Exim 4.86_2)
        (envelope-from <johunt@akamai.com>)
        id 1hLeCv-0001Kh-BE; Tue, 30 Apr 2019 21:38:49 -0400
From:   Josh Hunt <johunt@akamai.com>
To:     stephen@networkplumber.org, dsahern@gmail.com
Cc:     netdev@vger.kernel.org, Josh Hunt <johunt@akamai.com>
Subject: [PATCH v2] ss: add option to print socket information on one line
Date:   Tue, 30 Apr 2019 21:38:38 -0400
Message-Id: <1556674718-5081-1-git-send-email-johunt@akamai.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-01_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905010009
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-01_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905010010
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Multi-line output in ss makes it difficult to search for things with
grep. This new option will make it easier to find sockets matching
certain criteria with simple grep commands.

Example without option:
$ ss -emoitn
State      Recv-Q Send-Q Local Address:Port               Peer Address:Port
ESTAB      0      0      127.0.0.1:13265              127.0.0.1:36743               uid:1974 ino:48271 sk:1 <->
	 skmem:(r0,rb2227595,t0,tb2626560,f0,w0,o0,bl0,d0) ts sack reno wscale:7,7 rto:211 rtt:10.245/16.616 ato:40 mss:65483 cwnd:10 bytes_acked:41865496 bytes_received:21580440 segs_out:242496 segs_in:351446 data_segs_out:242495 data_segs_in:242495 send 511.3Mbps lastsnd:2383 lastrcv:2383 lastack:2342 pacing_rate 1022.6Mbps rcv_rtt:92427.6 rcv_space:43725 minrtt:0.007

Example with new option:
$ ss -emoitnO
State    Recv-Q Send-Q          Local Address:Port            Peer Address:Port
ESTAB    0      0                   127.0.0.1:13265              127.0.0.1:36743 uid:1974 ino:48271 sk:1 <-> skmem:(r0,rb2227595,t0,tb2626560,f0,w0,o0,bl0,d0) ts sack reno wscale:7,7 rto:211 rtt:10.067/16.429 ato:40 mss:65483 pmtu:65535 rcvmss:536 advmss:65483 cwnd:10 bytes_sent:41868244 bytes_acked:41868244 bytes_received:21581866 segs_out:242512 segs_in:351469 data_segs_out:242511 data_segs_in:242511 send 520.4Mbps lastsnd:14355 lastrcv:14355 lastack:14314 pacing_rate 1040.7Mbps delivery_rate 74837.7Mbps delivered:242512 app_limited busy:1861946ms rcv_rtt:92427.6 rcv_space:43725 rcv_ssthresh:43690 minrtt:0.007

Signed-off-by: Josh Hunt <johunt@akamai.com>
---

v1 -> v2
* Update long option to --oneline to match other ip tools as per David.

 man/man8/ss.8 |  3 +++
 misc/ss.c     | 51 +++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/man/man8/ss.8 b/man/man8/ss.8
index 03a3dcc6c9c3..9054fab9be69 100644
--- a/man/man8/ss.8
+++ b/man/man8/ss.8
@@ -24,6 +24,9 @@ Output version information.
 .B \-H, \-\-no-header
 Suppress header line.
 .TP
+.B \-O, \-\-oneline
+Print each socket's data on a single line.
+.TP
 .B \-n, \-\-numeric
 Do not try to resolve service names.
 .TP
diff --git a/misc/ss.c b/misc/ss.c
index 9cb3ee19e542..e8e7b62eb4a5 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -121,6 +121,7 @@ static int follow_events;
 static int sctp_ino;
 static int show_tipcinfo;
 static int show_tos;
+int oneline = 0;
 
 enum col_id {
 	COL_NETID,
@@ -3053,7 +3054,8 @@ static int inet_show_sock(struct nlmsghdr *nlh,
 	}
 
 	if (show_mem || (show_tcpinfo && s->type != IPPROTO_UDP)) {
-		out("\n\t");
+		if (!oneline)
+			out("\n\t");
 		if (s->type == IPPROTO_SCTP)
 			sctp_show_info(nlh, r, tb);
 		else
@@ -3973,7 +3975,10 @@ static int packet_show_sock(struct nlmsghdr *nlh, void *arg)
 
 	if (show_details) {
 		if (pinfo) {
-			out("\n\tver:%d", pinfo->pdi_version);
+			if (oneline)
+				out(" ver:%d", pinfo->pdi_version);
+			else
+				out("\n\tver:%d", pinfo->pdi_version);
 			out(" cpy_thresh:%d", pinfo->pdi_copy_thresh);
 			out(" flags( ");
 			if (pinfo->pdi_flags & PDI_RUNNING)
@@ -3991,19 +3996,28 @@ static int packet_show_sock(struct nlmsghdr *nlh, void *arg)
 			out(" )");
 		}
 		if (ring_rx) {
-			out("\n\tring_rx(");
+			if (oneline)
+				out(" ring_rx(");
+			else
+				out("\n\tring_rx(");
 			packet_show_ring(ring_rx);
 			out(")");
 		}
 		if (ring_tx) {
-			out("\n\tring_tx(");
+			if (oneline)
+				out(" ring_tx(");
+			else
+				out("\n\tring_tx(");
 			packet_show_ring(ring_tx);
 			out(")");
 		}
 		if (has_fanout) {
 			uint16_t type = (fanout >> 16) & 0xffff;
 
-			out("\n\tfanout(");
+			if (oneline)
+				out(" fanout(");
+			else
+				out("\n\tfanout(");
 			out("id:%d,", fanout & 0xffff);
 			out("type:");
 
@@ -4032,7 +4046,10 @@ static int packet_show_sock(struct nlmsghdr *nlh, void *arg)
 		int num = RTA_PAYLOAD(tb[PACKET_DIAG_FILTER]) /
 			  sizeof(struct sock_filter);
 
-		out("\n\tbpf filter (%d): ", num);
+		if (oneline)
+			out(" bpf filter (%d): ", num);
+		else
+			out("\n\tbpf filter (%d): ", num);
 		while (num) {
 			out(" 0x%02x %u %u %u,",
 			    fil->code, fil->jt, fil->jf, fil->k);
@@ -4144,7 +4161,10 @@ static int xdp_stats_print(struct sockstat *s, const struct filter *f)
 
 static void xdp_show_ring(const char *name, struct xdp_diag_ring *ring)
 {
-	out("\n\t%s(", name);
+	if (oneline)
+		out(" %s(", name);
+	else
+		out("\n\t%s(", name);
 	out("entries:%u", ring->entries);
 	out(")");
 }
@@ -4152,7 +4172,10 @@ static void xdp_show_ring(const char *name, struct xdp_diag_ring *ring)
 static void xdp_show_umem(struct xdp_diag_umem *umem, struct xdp_diag_ring *fr,
 			  struct xdp_diag_ring *cr)
 {
-	out("\n\tumem(");
+	if (oneline)
+		out(" tumem(");
+	else
+		out("\n\tumem(");
 	out("id:%u", umem->id);
 	out(",size:%llu", umem->size);
 	out(",num_pages:%u", umem->num_pages);
@@ -4574,7 +4597,10 @@ static int tipc_show_sock(struct nlmsghdr *nlh, void *arg)
 	proc_ctx_print(&ss);
 
 	if (show_tipcinfo) {
-		out("\n type:%s", stype_nameg[ss.type]);
+		if (oneline)
+			out(" type:%s", stype_nameg[ss.type]);
+		else
+			out("\n type:%s", stype_nameg[ss.type]);
 		out(" cong:%s ",
 		       stat[TIPC_NLA_SOCK_STAT_LINK_CONG] ? "link" :
 		       stat[TIPC_NLA_SOCK_STAT_CONN_CONG] ? "conn" : "none");
@@ -4877,6 +4903,7 @@ static void _usage(FILE *dest)
 "\n"
 "   -K, --kill          forcibly close sockets, display what was closed\n"
 "   -H, --no-header     Suppress header line\n"
+"   -O, --oneline       socket's data printed on a single line\n"
 "\n"
 "   -A, --query=QUERY, --socket=QUERY\n"
 "       QUERY := {all|inet|tcp|udp|raw|unix|unix_dgram|unix_stream|unix_seqpacket|packet|netlink|vsock_stream|vsock_dgram|tipc}[,QUERY]\n"
@@ -5003,6 +5030,7 @@ static const struct option long_opts[] = {
 	{ "kill", 0, 0, 'K' },
 	{ "no-header", 0, 0, 'H' },
 	{ "xdp", 0, 0, OPT_XDPSOCK},
+	{ "oneline", 0, 0, 'O' },
 	{ 0 }
 
 };
@@ -5018,7 +5046,7 @@ int main(int argc, char *argv[])
 	int state_filter = 0;
 
 	while ((ch = getopt_long(argc, argv,
-				 "dhaletuwxnro460spbEf:miA:D:F:vVzZN:KHS",
+				 "dhaletuwxnro460spbEf:miA:D:F:vVzZN:KHSO",
 				 long_opts, NULL)) != EOF) {
 		switch (ch) {
 		case 'n':
@@ -5192,6 +5220,9 @@ int main(int argc, char *argv[])
 		case 'H':
 			show_header = 0;
 			break;
+		case 'O':
+			oneline = 1;
+			break;
 		case 'h':
 			help();
 		case '?':
-- 
2.7.4

