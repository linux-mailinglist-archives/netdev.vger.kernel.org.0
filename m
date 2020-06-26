Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF55420B7A6
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgFZRzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:55:46 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46146 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726946AbgFZRzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:55:45 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QHtAQF021101
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:55:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=Yyg3mh2BruNtS5AB0w5EW5zC5V17U6ck8GTtkzkT4oI=;
 b=giIKDaqfLJnAzmOU+qdnZpS7eIyAOY6AtKBFEwuZnj+fuRpBRnRQxquT0JPCgp11rUO3
 V6HN7BPm9Ah32sDJ1Vp3vEnN6mhpPpKiMxZhq+V33gfrczswVVKVt8hRrFK2j5IAaTfT
 JWgJrMOWjfZ39lhc062mKbpSftawMa9UQvU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31ux0qeneq-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:55:38 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 10:55:30 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id EE11C2942E38; Fri, 26 Jun 2020 10:55:26 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 04/10] bpf: tcp: Allow bpf prog to write and parse BPF TCP header option
Date:   Fri, 26 Jun 2020 10:55:26 -0700
Message-ID: <20200626175526.1461133-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200626175501.1459961-1-kafai@fb.com>
References: <20200626175501.1459961-1-kafai@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_09:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 suspectscore=1 phishscore=0 clxscore=1015
 cotscore=-2147483648 mlxlogscore=999 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006260126
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The earlier effort in BPF-TCP-CC allows the TCP Congestion Control
algorithm to be written in BPF.  It opens up opportunities to allow
a faster turnaround time in testing/releasing new congestion control
ideas to production environment.

The same flexibility can be extended to writing TCP header option.
It is not uncommon that people want to test new TCP header option
to improve the TCP performance.  Another use case is for data-center
that has a more controlled environment and has more flexibility in
putting header options for internal use only.

For example, we want to test the idea in putting maximum delay
ACK in TCP header option which is similar to a draft RFC proposal [1].

This patch introduces the necessary BPF API and use them in the
TCP stack to allow BPF_PROG_TYPE_SOCK_OPS program to parse
and write TCP header options.  It currently supports most of
the TCP packet except RST.

Header Option Format
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80
The bpf prog will be allowed to write options under kind (254)
which is defined as the experimental TCP options in RFC 6994.
The exact format will be:

 0                  8                 16                             31
=E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
=E2=94=82   Kind: 254      =E2=94=82     length      =E2=94=82      magic=
: 0xeB9F              =E2=94=82
=E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4
=E2=94=82                                                                =
      =E2=94=82
=E2=94=82               BPF program written data                         =
      =E2=94=82
=E2=94=82                                                                =
      =E2=94=82
=E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98

By putting it under the standard kind 254 and magic 0xeB9F, it will be
recognizable by the usual tool like tcpdump and tshark.  The kernel
can ensure the header option format is valid before sending out to
the wire and avoid the bpf program from writing options
duplicated/conflicted with what the kernel TCP stack has
already written.

A similar experimental numbering also exists in other protocols (e.g. IPv=
6).
Thus,  a similar idea (and API) could be extended to other layers/protoco=
ls
in the future.

As mentioned above, this patch set does not allow the bpf program to crea=
te
its own option "kind".  However, the header-writing's BPF API (mainly thr=
ough
the helper "bpf_reserve_hdr_opt" and "bpf_store_hdr_opt") could be extend=
ed
in the future to allow a "raw" mode (e.g. by introducing a new helper
flag).

Sockops Callback Flags:
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80
The header parsing and writing callback can be turned on
by setting the existing callback flags "tp->bpf_sock_ops_cb_flags".
BPF_SOCK_OPS_PARSE_HDR_OPT_CB_FLAG and
BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG are (newly) added.
The default is off, i.e. the bpf prog will not
be called to parse or write bpf hdr option.

3 Way HandShake
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80
* Passive side

When writing SYNACK, the received SYN skb will be available to the
bpf prog.  The bpf prog will also know if it is in syncookie
mode (want_cookie) or not.  The bpf prog can use the SYN skb (which
may carry the bpf hdr opt sent from the remote peer) to decide what
bpf header option should be written to the outgoing SYNACK skb.

The bpf prog can store the bpf header option of the received
SYN by using the existing "TCP_SAVE_SYN" setsockopt.
The example in a latter patch also uses TCP_SAVE_SYN.
[ Note that the fullsock here is a listen sk, bpf_sk_storage
  is not very useful here since the listen sk will be shared
  by many concurrent connection requests.

  Extending bpf_sk_storage support to request_sock will add weight
  to the minisock and it is not necessary better than storing the
  whole ~100 bytes SYN pkt. ]

When the connection is established, the bpf prog will be called
in the existing PASSIVE_ESTABLISHED_CB callback.  At that time,
the bpf prog can get the bpf header option from the saved syn and
then apply the needed operation to the newly established socket.
The latter patch will use the max delay ack specified in the SYN
packet as an example.  The received ack (that concludes the 3WHS)
will also be available to the bpf prog during PASSIVE_ESTABLISHED_CB
through the sock_ops->skb_data, which could be useful in
syncookie scenario.

There is an existing getsockopt "TCP_SAVED_SYN" to return the whole
saved syn which includes the IP[46] header and the TCP header.
A (new) BPF only "TCP_BPF_SYN_HDR_OPT" getsockopt is added to get
the bpf header option alone (without the IP and TCP header) from the
saved syn.  The kernel remembers the offset to the bpf header option (i.e=
.
kind:254, magic:0xeB9F) as it passes the TCP header.  It is stored in
the tcp_skb_cb and then also saved in the "struct saved_syn".  The new
"TCP_BPF_SYN_HDR_OPT" can directly return the bpf header option to the
bpf prog instead of asking the bpf prog to parse the IP[46] header and
TCP header again in order to get to the bpf header option.

In the new "TCP_BPF_SYN_HDR_OPT" getsockopt, the kernel will know
where it can get the SYN's bpf header option from:
  - the just received syn (available when the bpf prog is writing SYNACK)
  or
  - the saved syn (available in PASSIVE_ESTABLISHED_CB).

The bpf prog does not need to know where this bpf header option
can be obtained from.  The "TCP_BPF_SYN_HDR_OPT" getsockopt will
hide this details.

Fastopen should work the same as the regular non fastopen case.
This is a test in a latter patch.

For syncookie, the latter example patch asks the active
side's bpf prog to resend the header options in ACK.  Please refer
to this latter example for its details and limitation.

* Active side

The bpf prog will get a chance to write the bpf header option
in the SYN packet during WRITE_HDR_OPT_CB.  The received SYNACK
pkt will also be available to the bpf prog during the existing
ACTIVE_ESTABLISHED_CB callback through the sock_ops->skb_data.

In short, regardless of active or passive ESTABLISHED_CB,
the sock_ops->skb_data is always the received skb that
completed the 3WHS.

If the bpf prog does not need to write/parse header options
beyond the 3WHS, the bpf prog can clear the bpf_sock_ops_cb_flags
to avoid being called for header options.

Established Connection
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80
The bpf prog will be called as long as the parse/write
*_HDR_OPT_CB_FLAG is enabled in bpf_sock_ops_cb_flags.
That will allow the bpf prog to parse/write header options
in the data, pure-ack, and fin packet.

Writing BPF Header Option
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80
[ bpf prog context: sock_ops ]

When writing header, the bpf prog is first called to reserve
the needed number of bytes in skb during "HDR_OPT_LEN_CB" and
then called to write the header during "WRITE_HDR_OPT_CB".
During these two write CB, the sock_ops->skb_* is always
representing the outgoing skb.

The bpf prog is expected to use the two (new) helpers,
"bpf_reserve_hdr_opt" and "bpf_store_hdr_opt", to
reserve option space and write the option.

In cgroup MULTI mode, the max reserved space among multiple bpf progs
will be used.  e.g. prog#1 reserves 8 bytes and a latter prog#2 reserves
4 bytes.  8 bytes will be reserved.
When multiple bpf progs write the bpf header option, the last
prog's header option will be used.  The "bpf_store_hdr_opt"
helper will take care of the TCP header option's kind-length.

When writing header in "WRITE_HDR_OPT_CB", the sock_ops->skb_data
is pointing to the outgoing skb.  If there is a need, the bpf prog
can inspect what has been written to the header.
sock_ops->skb_bpf_hdr_opt_off also provides an offset to the
beginning of the bpf header option (i.e. the beginning of
kind:245, magic:0xeB9F).
However, during option space reservation in "HDR_OPT_LEN_CB",
the sock_ops->skb_data does not have the tcp header because
the header has not been written yet.

Parsing BPF Header Option
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80

As mentioned earlier, the received SYN/SYNACK/ACK during the 3WHS
will be available to some specific CB (e.g. the *_ESTABLISHED_CB)

For established connection, if the kernel finds a bpf header
option (i.e. option with kind:254 and magic:0xeB9F) and the
the "PARSE_HDR_OPT_CB_FLAG" flag is set,  the
bpf prog will be called in the "BPF_SOCK_OPS_PARSE_HDR_OPT_CB" op.
The received skb will be available through sock_ops->skb_data
and the bpf header option offset will also be specified
in sock_ops->skb_bpf_hdr_opt_off.

[1]: draft-wang-tcpm-low-latency-opt-00
     https://tools.ietf.org/html/draft-wang-tcpm-low-latency-opt-00

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/bpf-cgroup.h     |  25 ++++
 include/linux/filter.h         |   6 +
 include/net/tcp.h              |  53 ++++++++-
 include/uapi/linux/bpf.h       | 187 +++++++++++++++++++++++++++++-
 net/core/filter.c              | 202 +++++++++++++++++++++++++++++++++
 net/ipv4/tcp_fastopen.c        |   2 +-
 net/ipv4/tcp_input.c           |  79 ++++++++++++-
 net/ipv4/tcp_ipv4.c            |   3 +-
 net/ipv4/tcp_minisocks.c       |   1 +
 net/ipv4/tcp_output.c          | 186 +++++++++++++++++++++++++++++-
 net/ipv6/tcp_ipv6.c            |   3 +-
 tools/include/uapi/linux/bpf.h | 187 +++++++++++++++++++++++++++++-
 12 files changed, 914 insertions(+), 20 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index c66c545e161a..c069295564a4 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -270,6 +270,31 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map =
*map, void *key,
 #define BPF_CGROUP_RUN_PROG_UDP6_RECVMSG_LOCK(sk, uaddr)			\
 	BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_UDP6_RECVMSG, NULL)
=20
+/* The SOCK_OPS"_SK" macro should be used when sock_ops->sk is not a
+ * fullsock and its parent fullsock cannot be traced by
+ * sk_to_full_sk().
+ *
+ * e.g. sock_ops->sk is a request_sock and it is under syncookie mode.
+ * Its listener-sk is not attached to the rsk_listener.
+ * In this case, the caller holds the listener-sk (unlocked),
+ * set its sock_ops->sk to req_sk, and call this SOCK_OPS"_SK" with
+ * the listener-sk such that the cgroup-bpf-progs of the
+ * listener-sk will be run.
+ *
+ * Regardless of syncookie mode or not,
+ * calling bpf_setsockopt on listener-sk will not make sense anyway,
+ * so passing req_sk to bpf prog is appropriate here.
+ */
+#define BPF_CGROUP_RUN_PROG_SOCK_OPS_SK(sock_ops, sk)			\
+({									\
+	int __ret =3D 0;							\
+	if (cgroup_bpf_enabled)						\
+		__ret =3D __cgroup_bpf_run_filter_sock_ops(sk,		\
+							 sock_ops,	\
+							 BPF_CGROUP_SOCK_OPS); \
+	__ret;								\
+})
+
 #define BPF_CGROUP_RUN_PROG_SOCK_OPS(sock_ops)				       \
 ({									       \
 	int __ret =3D 0;							       \
diff --git a/include/linux/filter.h b/include/linux/filter.h
index aae52cbda670..2ba008f4937c 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1241,8 +1241,14 @@ struct bpf_sock_ops_kern {
 		u32 reply;
 		u32 replylong[4];
 	};
+	void	*syn_skb;
+	void	*skb;
+	void	*skb_data_end;
 	u8	op;
 	u8	is_fullsock;
+	u8	write_hdr_opt_len;
+	u8	skb_bpf_hdr_opt_off;
+	u8	reservable_hdr_opt_len;	/* Only used in HDR_OPT_LEN */
 	u64	temp;			/* temp and everything after is not
 					 * initialized to 0 before calling
 					 * the BPF program. New fields that
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 07a9dfe35242..e93ef2d324f3 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -395,7 +395,7 @@ void tcp_metrics_init(void);
 bool tcp_peer_is_proven(struct request_sock *req, struct dst_entry *dst)=
;
 void tcp_close(struct sock *sk, long timeout);
 void tcp_init_sock(struct sock *sk);
-void tcp_init_transfer(struct sock *sk, int bpf_op);
+void tcp_init_transfer(struct sock *sk, bool passive, struct sk_buff *sk=
b);
 __poll_t tcp_poll(struct file *file, struct socket *sock,
 		      struct poll_table_struct *wait);
 int tcp_getsockopt(struct sock *sk, int level, int optname,
@@ -459,6 +459,7 @@ enum tcp_synack_type {
 };
 struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry =
*dst,
 				struct request_sock *req,
+				struct sk_buff *syn_skb,
 				struct tcp_fastopen_cookie *foc,
 				enum tcp_synack_type synack_type);
 int tcp_disconnect(struct sock *sk, int flags);
@@ -2023,6 +2024,7 @@ struct tcp_request_sock_ops {
 	u32 (*init_ts_off)(const struct net *net, const struct sk_buff *skb);
 	int (*send_synack)(const struct sock *sk, struct dst_entry *dst,
 			   struct flowi *fl, struct request_sock *req,
+			   struct sk_buff *syn_skb,
 			   struct tcp_fastopen_cookie *foc,
 			   enum tcp_synack_type synack_type);
 };
@@ -2222,6 +2224,55 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_p=
sock *psock,
 		      struct msghdr *msg, int len, int flags);
 #endif /* CONFIG_NET_SOCK_MSG */
=20
+#ifdef CONFIG_CGROUP_BPF
+/* Copy the listen sk's HDR_OPT_CB flags to its child.
+ *
+ * During 3-Way-HandShake, the synack is usually sent from
+ * the listen sk with the HDR_OPT_CB flags set so that
+ * bpf-prog will be called to write the BPF hdr option.
+ *
+ * In fastopen, the child sk is used to send synack instead
+ * of the listen sk.  Thus, inheriting the HDR_OPT_CB flags
+ * from the listen sk gives the bpf-prog a chance to write
+ * BPF hdr option in the synack pkt during fastopen.
+ *
+ * Both fastopen and non-fastopen child will inherit the
+ * HDR_OPT_CB flags to keep the bpf-prog having a consistent
+ * behavior when deciding to clear this cb flags (or not)
+ * during the PASSIVE_ESTABLISHED_CB.
+ *
+ * In the future, other cb flags could be inherited here also.
+ */
+static inline void bpf_skops_init_child(const struct sock *sk,
+					struct sock *child)
+{
+	tcp_sk(child)->bpf_sock_ops_cb_flags =3D
+		tcp_sk(sk)->bpf_sock_ops_cb_flags &
+		(BPF_SOCK_OPS_PARSE_HDR_OPT_CB_FLAG |
+		 BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG);
+}
+
+static inline void bpf_skops_init_skb(struct bpf_sock_ops_kern *skops,
+				      struct sk_buff *skb,
+				      u8 bpf_hdr_opt_off)
+{
+	skops->skb =3D skb;
+	skops->skb_data_end =3D skb->data + skb_headlen(skb);
+	skops->skb_bpf_hdr_opt_off =3D bpf_hdr_opt_off;
+}
+#else
+static inline void bpf_skops_init_child(const struct sock *sk,
+					struct sock *child)
+{
+}
+
+static inline void bpf_skops_init_skb(struct bpf_sock_ops_kern *skops,
+				      struct sk_buff *skb,
+				      u8 bpf_hdr_opt_off)
+{
+}
+#endif
+
 /* Call BPF_SOCK_OPS program that returns an int. If the return value
  * is < 0, then the BPF op failed (for example if the loaded BPF
  * program does not support the chosen operation or there is no BPF
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 0cb8ec948816..479b83d05811 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3285,6 +3285,110 @@ union bpf_attr {
  *		Dynamically cast a *sk* pointer to a *udp6_sock* pointer.
  *	Return
  *		*sk* if casting is valid, or NULL otherwise.
+ *
+ * long bpf_store_hdr_opt(struct bpf_sock_ops *skops, u32 offset, const =
void *from, u32 len, u64 flags)
+ *	Description
+ *		Store BPF header option.  The data will be copied
+ *		from buffer *from* with length *len* to the bpf header
+ *		option at *offset*.
+ *
+ *		This helper does not allow updating the header "kind",
+ *		"kind length", and the 16-bit magic.  *offset* 0
+ *		points immediately after the 16-bit magic.
+ *		This helper will automatically update the "kind length" as
+ *		the bpf header option is written by this helper.  It can
+ *		guarantee that the header option format always
+ *		conforms to the standard.
+ *
+ *		The bpf program can write everything at once
+ *		from offset 0.
+ *
+ *		The bpf program can also do incremental write by calling
+ *		this helper multiple times with incremental (but
+ *		continuous) offset.
+ *
+ *		The bpf program (e.g. the parent cgroup bpf program)
+ *		can also rewrite a few bytes that has already been
+ *		written by some ealier bpf programs.  The bpf
+ *		program can also learn what header option has been
+ *		written by the earlier bpf programs through
+ *		sock_ops->skb_data.
+ *
+ *		A bpf program can always write at offset 0 again
+ *		to overwrite all bpf header options that has been written
+ *		by the previous bpf programs.  If the bpf program
+ *		writes less than the previous bpf programs do,
+ *		the tailing bytes will be removed unless
+ *		*BP_F_STORE_HDR_OPT_NOTRIM* is used.
+ *		e.g. bpf_store_hdr_opt(skops, 0, NULL, 0, 0) will
+ *		remove all previously written option.
+ *
+ *		This helper will reject the *offset* if there is any
+ *		byte/hole that has never been written before this
+ *		*offset*.
+ *
+ *		For example, it can write at offset 0 for 2 bytes,
+ *		then write at offset 2 for 1 bytes, and then finally
+ *		write at offset 3 for 2 bytes.  Thus, the bpf prog
+ *		has totally written 5 bytes.
+ *		The "kind length" will be 9 bytes:
+ *		4 bytes (1byte kind + 1byte kind_len + 2byte magic) +
+ *		5 bytes written by the bpf program.
+ *
+ *		However, this helper does not allow writing at offset 0
+ *		for 2 bytes and then immediately write at offset 3 without
+ *		writing at offset 2 first.
+ *
+ *		This helper can only be called during
+ *		BPF_SOCK_OPS_WRITE_HDR_OPT_CB.  The previous reserved
+ *		space is passed in sock_ops->args[0].
+ *
+ *		The following flags are supported:
+ *		* **BPF_F_STORE_HDR_OPT_NOTRIM**: Usually, bpf program
+ *		  does write with incremental offset instead of
+ *		  jumping the offset back and forth.
+ *		  Thus, by default, after calling this helper,
+ *		  anything previously written after offset + len
+ *		  will be removed.
+ *		  This flag can be used to keep the tailing
+ *		  data after "offset + len".
+ *
+ *	Return
+ *		0 on success, or negative error in case of failure:
+ *
+ *		**-EINVAL** if param is invalid
+ *
+ *		**-EFAULT** *offset* + *len* is outside of the
+ *		            reserved option space or
+ *			    there is unwritten byte before *offset*.
+ *
+ *		**-EPERM** This helper cannot be used under the
+ *			   current sock_ops->op.
+ *
+ * long bpf_reserve_hdr_opt(struct bpf_sock_ops *skops, u32 len, u64 fla=
gs)
+ *	Description
+ *		Reserve *len* bytes for the bpf header option.  This
+ *		space will be available to use by bpf_store_hdr_opt()
+ *		later.
+ *
+ *		If bpf_reserve_hdr_opt() is called multiple times (e.g
+ *		by mulitple cgroup bpf programs),
+ *		the maximum *len* among them will be reserved.
+ *
+ *		This helper can only be called during
+ *		BPF_SOCK_OPS_HDR_OPT_LEN_CB.  The maximum
+ *		reservable space is passed in
+ *		sock_ops->args[0].
+ *
+ *	Return
+ *		0 on success, or negative error in case of failure:
+ *
+ *		**-EINVAL** if param is invalid
+ *
+ *		**-ENOSPC** Not enough remaining space in the header.
+ *
+ *		**-EPERM** This helper cannot be used under the
+ *			   current sock_ops->op.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3427,7 +3531,9 @@ union bpf_attr {
 	FN(skc_to_tcp_sock),		\
 	FN(skc_to_tcp_timewait_sock),	\
 	FN(skc_to_tcp_request_sock),	\
-	FN(skc_to_udp6_sock),
+	FN(skc_to_udp6_sock),		\
+	FN(store_hdr_opt),		\
+	FN(reserve_hdr_opt),
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
  * function eBPF program intends to call
@@ -4024,6 +4130,11 @@ struct bpf_sock_ops {
 	__u64 bytes_received;
 	__u64 bytes_acked;
 	__bpf_md_ptr(struct bpf_sock *, sk);
+	__bpf_md_ptr(void *, skb_data);
+	__bpf_md_ptr(void *, skb_data_end);
+	__u32 skb_len;
+	__u32 skb_bpf_hdr_opt_off;
+	__u32 skb_tcp_flags;
 };
=20
 /* Definitions for bpf_sock_ops_cb_flags */
@@ -4032,8 +4143,14 @@ enum {
 	BPF_SOCK_OPS_RETRANS_CB_FLAG	=3D (1<<1),
 	BPF_SOCK_OPS_STATE_CB_FLAG	=3D (1<<2),
 	BPF_SOCK_OPS_RTT_CB_FLAG	=3D (1<<3),
+	BPF_SOCK_OPS_PARSE_HDR_OPT_CB_FLAG =3D (1<<4),
+	BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG =3D (1<<5),
 /* Mask of all currently supported cb flags */
-	BPF_SOCK_OPS_ALL_CB_FLAGS       =3D 0xF,
+	BPF_SOCK_OPS_ALL_CB_FLAGS       =3D 0x3F,
+};
+
+enum {
+	BPF_F_STORE_HDR_OPT_NOTRIM	=3D (1ULL << 0),
 };
=20
 /* List of known BPF sock_ops operators.
@@ -4089,6 +4206,58 @@ enum {
 					 */
 	BPF_SOCK_OPS_RTT_CB,		/* Called on every RTT.
 					 */
+	BPF_SOCK_OPS_PARSE_HDR_OPT_CB,	/* Parse the BPF header option.
+					 * It will be called to handle
+					 * the packets received at
+					 * socket that has been established.
+					 */
+	BPF_SOCK_OPS_HDR_OPT_LEN_CB,	/* Reserve space for writing the BPF
+					 * header option later in
+					 * BPF_SOCK_OPS_WRITE_HDR_OPT_CB.
+					 * Arg1: Max reservable bytes
+					 * Arg2: bool want_cookie. (in
+					 *       writing SYNACK only)
+					 *
+					 * sock_ops->skb_data:
+					 *	Referring to the
+					 *	outgoing skb.
+					 *	It is pointing to the
+					 *	TCP payload because
+					 *	no TCP header has
+					 *	been written yet.
+					 *
+					 * sock_ops->skb_tcp_flags:
+					 *	the tcp_flags of the
+					 *	outgoing skb. (e.g.
+					 *      SYN, ACK, FIN).
+					 *
+					 * bpf_reserve_hdr_opt() should
+					 * be used to reserve space.
+					 */
+	BPF_SOCK_OPS_WRITE_HDR_OPT_CB,	/* Write the BPF header OPTIONS
+					 * Arg1: num of bytes reserved during
+					 *       BPF_SOCK_OPS_HDR_OPT_LEN_CB
+					 * Arg2: bool want_cookie. (in
+					 *       writing SYNACK only)
+					 *
+					 * sock_ops->skb_data:
+					 *	referring to the
+					 *	outgoing skb.
+					 *	It is pointing to the
+					 *	TCP header.
+					 *
+					 * sock_ops->skb_bpf_hdr_opt_off:
+					 *	offset to the bpf
+					 *	header option.  bpf
+					 *	prog can inspect what bpf
+					 *	option has already been
+					 *	written.
+					 *
+					 * sock_ops->skb_tcp_flags:
+					 *	the tcp_flags of the
+					 *	outgoing skb. (e.g.
+					 *	SYN, ACK, FIN).
+					 */
 };
=20
 /* List of TCP states. There is a build check in net/ipv4/tcp.c to detec=
t
@@ -4116,6 +4285,20 @@ enum {
 enum {
 	TCP_BPF_IW		=3D 1001,	/* Set TCP initial congestion window */
 	TCP_BPF_SNDCWND_CLAMP	=3D 1002,	/* Set sndcwnd_clamp */
+	/* Copy the BPF header option from syn pkt to optval
+	 *
+	 * BPF_PROG_TYPE_SOCK_OPS only.  It is similar to the
+	 * TCP_SAVED_SYN but it only gets the bpf header option
+	 * from the syn packet.
+	 *
+	 *       0: Success
+	 * -ENOSPC: Not enough space in optval. Only optlen number of
+	 *          bytes is copied.
+	 * -ENOMSG: BPF TCP header option not found
+	 * -ENOENT: The SYN skb is not available now and the earlier SYN pkt
+	 *	    is not saved by TCP_SAVE_SYN.
+	 */
+	TCP_BPF_SYN_HDR_OPT	=3D 1003,
 };
=20
 struct bpf_perf_event_value {
diff --git a/net/core/filter.c b/net/core/filter.c
index 1dd07972c5c7..5784f1bede2f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4629,6 +4629,64 @@ static const struct bpf_func_proto bpf_sock_ops_se=
tsockopt_proto =3D {
 BPF_CALL_5(bpf_sock_ops_getsockopt, struct bpf_sock_ops_kern *, bpf_sock=
,
 	   int, level, int, optname, char *, optval, int, optlen)
 {
+	if (IS_ENABLED(CONFIG_INET) &&
+	    level =3D=3D SOL_TCP && optname =3D=3D TCP_BPF_SYN_HDR_OPT) {
+		struct sk_buff *syn_skb =3D bpf_sock->syn_skb;
+		u8 *kind_start, copy_len =3D 0;
+		int ret =3D 0;
+
+		if (bpf_sock->syn_skb) {
+			/* sk is a request_sock here */
+
+			if (!TCP_SKB_CB(syn_skb)->bpf_hdr_opt_off) {
+				ret =3D -ENOMSG;
+				goto init_unused;
+			}
+
+			kind_start =3D syn_skb->data +
+				TCP_SKB_CB(syn_skb)->bpf_hdr_opt_off;
+		} else {
+			struct sock *sk =3D bpf_sock->sk;
+			struct saved_syn *saved_syn;
+
+			if (sk->sk_state =3D=3D TCP_NEW_SYN_RECV)
+				/* synack retransmit. bpf_sock->syn_skb will
+				 * not be available.
+				 */
+				saved_syn =3D inet_reqsk(sk)->saved_syn;
+			else
+				saved_syn =3D tcp_sk(sk)->saved_syn;
+
+			if (!saved_syn) {
+				ret =3D -ENOENT;
+				goto init_unused;
+			}
+
+			if (!saved_syn->bpf_hdr_opt_off) {
+				ret =3D -ENOMSG;
+				goto init_unused;
+			}
+
+			kind_start =3D saved_syn->data +
+				saved_syn->network_hdrlen +
+				saved_syn->bpf_hdr_opt_off;
+		}
+
+		copy_len =3D kind_start[1];
+		if (optlen < copy_len) {
+			copy_len =3D optlen;
+			ret =3D -ENOSPC;
+		}
+
+		memcpy(optval, kind_start, copy_len);
+
+init_unused:
+		if (optlen > copy_len)
+			memset(optval + copy_len, 0, optlen - copy_len);
+
+		return ret;
+	}
+
 	return _bpf_getsockopt(bpf_sock->sk, level, optname, optval, optlen);
 }
=20
@@ -4665,6 +4723,80 @@ static const struct bpf_func_proto bpf_sock_ops_cb=
_flags_set_proto =3D {
 	.arg2_type	=3D ARG_ANYTHING,
 };
=20
+BPF_CALL_5(bpf_sock_ops_store_hdr_opt, struct bpf_sock_ops_kern *, bpf_s=
ock,
+	   u32, offset, const void *, from, u32, len, u64, flags)
+{
+	u8 *kind_start, nr_written, max_len;
+	struct sk_buff *skb;
+
+	if (bpf_sock->op !=3D BPF_SOCK_OPS_WRITE_HDR_OPT_CB)
+		return -EPERM;
+
+	if (flags > BPF_F_STORE_HDR_OPT_NOTRIM)
+		return -EINVAL;
+
+	max_len =3D bpf_sock->write_hdr_opt_len;
+	if (len > max_len || offset > max_len - len)
+		return -EFAULT;
+
+	skb =3D bpf_sock->skb;
+	kind_start =3D skb->data + bpf_sock->skb_bpf_hdr_opt_off;
+	nr_written =3D kind_start[1] - TCPOLEN_EXP_BPF_BASE;
+	if (offset > nr_written)
+		return -EFAULT;
+
+	if (len)
+		memcpy(kind_start + TCPOLEN_EXP_BPF_BASE + offset, from, len);
+
+	if (kind_start[1] < TCPOLEN_EXP_BPF_BASE + offset + len ||
+	    !(flags & BPF_F_STORE_HDR_OPT_NOTRIM))
+		/* Update kind_len */
+		kind_start[1] =3D TCPOLEN_EXP_BPF_BASE + offset + len;
+
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_sock_ops_store_hdr_opt_proto =3D =
{
+	.func		=3D bpf_sock_ops_store_hdr_opt,
+	.gpl_only	=3D false,
+	.ret_type	=3D RET_INTEGER,
+	.arg1_type	=3D ARG_PTR_TO_CTX,
+	.arg2_type	=3D ARG_ANYTHING,
+	/* bpf_store_hdr_opt(skops, 0, NULL, 0, 0) will remove
+	 * all previously written options.
+	 */
+	.arg3_type	=3D ARG_PTR_TO_MEM_OR_NULL,
+	.arg4_type	=3D ARG_CONST_SIZE_OR_ZERO,
+	.arg5_type	=3D ARG_ANYTHING,
+};
+
+BPF_CALL_3(bpf_sock_ops_reserve_hdr_opt, struct bpf_sock_ops_kern *, bpf=
_sock,
+	   u32, len, u64, flags)
+{
+	if (bpf_sock->op !=3D BPF_SOCK_OPS_HDR_OPT_LEN_CB)
+		return -EPERM;
+
+	if (flags)
+		return -EINVAL;
+
+	if (len > bpf_sock->reservable_hdr_opt_len)
+		return -ENOSPC;
+
+	if (len > bpf_sock->write_hdr_opt_len)
+		bpf_sock->write_hdr_opt_len =3D len;
+
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_sock_ops_reserve_hdr_opt_proto =3D=
 {
+	.func		=3D bpf_sock_ops_reserve_hdr_opt,
+	.gpl_only	=3D false,
+	.ret_type	=3D RET_INTEGER,
+	.arg1_type	=3D ARG_PTR_TO_CTX,
+	.arg2_type	=3D ARG_ANYTHING,
+	.arg3_type	=3D ARG_ANYTHING,
+};
+
 const struct ipv6_bpf_stub *ipv6_bpf_stub __read_mostly;
 EXPORT_SYMBOL_GPL(ipv6_bpf_stub);
=20
@@ -6515,6 +6647,10 @@ sock_ops_func_proto(enum bpf_func_id func_id, cons=
t struct bpf_prog *prog)
 	case BPF_FUNC_sk_storage_delete:
 		return &bpf_sk_storage_delete_proto;
 #ifdef CONFIG_INET
+	case BPF_FUNC_store_hdr_opt:
+		return &bpf_sock_ops_store_hdr_opt_proto;
+	case BPF_FUNC_reserve_hdr_opt:
+		return &bpf_sock_ops_reserve_hdr_opt_proto;
 	case BPF_FUNC_tcp_sock:
 		return &bpf_tcp_sock_proto;
 #endif /* CONFIG_INET */
@@ -7313,6 +7449,21 @@ static bool sock_ops_is_valid_access(int off, int =
size,
 				return false;
 			info->reg_type =3D PTR_TO_SOCKET_OR_NULL;
 			break;
+		case offsetof(struct bpf_sock_ops, skb_data):
+			if (size !=3D sizeof(__u64))
+				return false;
+			info->reg_type =3D PTR_TO_PACKET;
+			break;
+		case offsetof(struct bpf_sock_ops, skb_data_end):
+			if (size !=3D sizeof(__u64))
+				return false;
+			info->reg_type =3D PTR_TO_PACKET_END;
+			break;
+		case offsetof(struct bpf_sock_ops, skb_tcp_flags):
+		case offsetof(struct bpf_sock_ops, skb_bpf_hdr_opt_off):
+			bpf_ctx_record_field_size(info, size_default);
+			return bpf_ctx_narrow_access_ok(off, size,
+							size_default);
 		default:
 			if (size !=3D size_default)
 				return false;
@@ -8601,6 +8752,57 @@ static u32 sock_ops_convert_ctx_access(enum bpf_ac=
cess_type type,
 				      si->dst_reg, si->src_reg,
 				      offsetof(struct bpf_sock_ops_kern, sk));
 		break;
+	case offsetof(struct bpf_sock_ops, skb_bpf_hdr_opt_off):
+		*insn++ =3D BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_sock_ops_kern,
+						       skb_bpf_hdr_opt_off),
+				      si->dst_reg, si->src_reg,
+				      bpf_target_off(struct bpf_sock_ops_kern,
+						     skb_bpf_hdr_opt_off, 1,
+						     target_size));
+		break;
+	case offsetof(struct bpf_sock_ops, skb_data_end):
+		*insn++ =3D BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_sock_ops_kern,
+						       skb_data_end),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct bpf_sock_ops_kern,
+					       skb_data_end));
+		break;
+	case offsetof(struct bpf_sock_ops, skb_data):
+		*insn++ =3D BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_sock_ops_kern,
+						       skb),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct bpf_sock_ops_kern,
+					       skb));
+		*insn++ =3D BPF_JMP_IMM(BPF_JEQ, si->dst_reg, 0, 1);
+		*insn++ =3D BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, data),
+				      si->dst_reg, si->dst_reg,
+				      offsetof(struct sk_buff, data));
+		break;
+	case offsetof(struct bpf_sock_ops, skb_len):
+		*insn++ =3D BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_sock_ops_kern,
+						       skb),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct bpf_sock_ops_kern,
+					       skb));
+		*insn++ =3D BPF_JMP_IMM(BPF_JEQ, si->dst_reg, 0, 1);
+		*insn++ =3D BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, len),
+				      si->dst_reg, si->dst_reg,
+				      offsetof(struct sk_buff, len));
+		break;
+	case offsetof(struct bpf_sock_ops, skb_tcp_flags):
+		off =3D offsetof(struct sk_buff, cb);
+		off +=3D offsetof(struct tcp_skb_cb, tcp_flags);
+		*target_size =3D sizeof_field(struct tcp_skb_cb, tcp_flags);
+		*insn++ =3D BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_sock_ops_kern,
+						       skb),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct bpf_sock_ops_kern,
+					       skb));
+		*insn++ =3D BPF_JMP_IMM(BPF_JEQ, si->dst_reg, 0, 1);
+		*insn++ =3D BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct tcp_skb_cb,
+						       tcp_flags),
+				      si->dst_reg, si->dst_reg, off);
+		break;
 	}
 	return insn - insn_buf;
 }
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 19ad9586c720..dd70b04da52a 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -272,7 +272,7 @@ static struct sock *tcp_fastopen_create_child(struct =
sock *sk,
 	refcount_set(&req->rsk_refcnt, 2);
=20
 	/* Now finish processing the fastopen child socket. */
-	tcp_init_transfer(child, BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB);
+	tcp_init_transfer(child, true, skb);
=20
 	tp->rcv_nxt =3D TCP_SKB_CB(skb)->seq + 1;
=20
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 640408a80b3d..16dbf5dd46c1 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -138,6 +138,69 @@ void clean_acked_data_flush(void)
 EXPORT_SYMBOL_GPL(clean_acked_data_flush);
 #endif
=20
+#ifdef CONFIG_CGROUP_BPF
+static void bpf_skops_parse_bpf_hdr(struct sock *sk, struct sk_buff *skb=
)
+{
+	struct bpf_sock_ops_kern sock_ops;
+
+	if (likely(!BPF_SOCK_OPS_TEST_FLAG(tcp_sk(sk),
+					   BPF_SOCK_OPS_PARSE_HDR_OPT_CB_FLAG)))
+		return;
+
+	/* The skb will be handled in the
+	 * BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB or
+	 * BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB.
+	 */
+	switch (sk->sk_state) {
+	case TCP_SYN_RECV:
+	case TCP_LISTEN:
+	case TCP_SYN_SENT:
+		return;
+	}
+
+	sock_owned_by_me(sk);
+
+	memset(&sock_ops, 0, offsetof(struct bpf_sock_ops_kern, temp));
+	sock_ops.op =3D BPF_SOCK_OPS_PARSE_HDR_OPT_CB;
+	sock_ops.is_fullsock =3D 1;
+	sock_ops.sk =3D sk;
+	bpf_skops_init_skb(&sock_ops, skb, TCP_SKB_CB(skb)->bpf_hdr_opt_off);
+
+	BPF_CGROUP_RUN_PROG_SOCK_OPS(&sock_ops);
+}
+
+static void bpf_skops_established(struct sock *sk, bool passive,
+				  struct sk_buff *skb)
+{
+	struct bpf_sock_ops_kern sock_ops;
+
+	sock_owned_by_me(sk);
+
+	memset(&sock_ops, 0, offsetof(struct bpf_sock_ops_kern, temp));
+	if (passive)
+		sock_ops.op =3D BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB;
+	else
+		sock_ops.op =3D BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB;
+	sock_ops.is_fullsock =3D 1;
+	sock_ops.sk =3D sk;
+	/* sk with TCP_REPAIR_ON does not have skb in tcp_finish_connect */
+	if (skb)
+		bpf_skops_init_skb(&sock_ops, skb,
+				   TCP_SKB_CB(skb)->bpf_hdr_opt_off);
+
+	BPF_CGROUP_RUN_PROG_SOCK_OPS(&sock_ops);
+}
+#else
+static void bpf_skops_parse_bpf_hdr(struct sock *sk, struct sk_buff *skb=
)
+{
+}
+
+static void bpf_skops_established(struct sock *sk, bool passive,
+				  struct sk_buff *skb)
+{
+}
+#endif
+
 static void tcp_gro_dev_warn(struct sock *sk, const struct sk_buff *skb,
 			     unsigned int len)
 {
@@ -5551,6 +5614,9 @@ static bool tcp_validate_incoming(struct sock *sk, =
struct sk_buff *skb,
 		goto discard;
 	}
=20
+	if (TCP_SKB_CB(skb)->bpf_hdr_opt_off)
+		bpf_skops_parse_bpf_hdr(sk, skb);
+
 	return true;
=20
 discard:
@@ -5759,7 +5825,7 @@ void tcp_rcv_established(struct sock *sk, struct sk=
_buff *skb)
 }
 EXPORT_SYMBOL(tcp_rcv_established);
=20
-void tcp_init_transfer(struct sock *sk, int bpf_op)
+void tcp_init_transfer(struct sock *sk, bool passive, struct sk_buff *sk=
b)
 {
 	struct inet_connection_sock *icsk =3D inet_csk(sk);
 	struct tcp_sock *tp =3D tcp_sk(sk);
@@ -5780,7 +5846,7 @@ void tcp_init_transfer(struct sock *sk, int bpf_op)
 		tp->snd_cwnd =3D tcp_init_cwnd(tp, __sk_dst_get(sk));
 	tp->snd_cwnd_stamp =3D tcp_jiffies32;
=20
-	tcp_call_bpf(sk, bpf_op, 0, NULL);
+	bpf_skops_established(sk, passive, skb);
 	tcp_init_congestion_control(sk);
 	tcp_init_buffer_space(sk);
 }
@@ -5799,7 +5865,7 @@ void tcp_finish_connect(struct sock *sk, struct sk_=
buff *skb)
 		sk_mark_napi_id(sk, skb);
 	}
=20
-	tcp_init_transfer(sk, BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB);
+	tcp_init_transfer(sk, false, skb);
=20
 	/* Prevent spurious tcp_cwnd_restart() on first data
 	 * packet.
@@ -6271,7 +6337,7 @@ int tcp_rcv_state_process(struct sock *sk, struct s=
k_buff *skb)
 		} else {
 			tcp_try_undo_spurious_syn(sk);
 			tp->retrans_stamp =3D 0;
-			tcp_init_transfer(sk, BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB);
+			tcp_init_transfer(sk, true, skb);
 			WRITE_ONCE(tp->copied_seq, tp->rcv_nxt);
 		}
 		smp_mb();
@@ -6718,7 +6784,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_o=
ps,
 		fastopen_sk =3D tcp_try_fastopen(sk, skb, req, &foc, dst);
 	}
 	if (fastopen_sk) {
-		af_ops->send_synack(fastopen_sk, dst, &fl, req,
+		af_ops->send_synack(fastopen_sk, dst, &fl, req, skb,
 				    &foc, TCP_SYNACK_FASTOPEN);
 		/* Add the child socket directly into the accept queue */
 		if (!inet_csk_reqsk_queue_add(sk, req, fastopen_sk)) {
@@ -6735,7 +6801,8 @@ int tcp_conn_request(struct request_sock_ops *rsk_o=
ps,
 		if (!want_cookie)
 			inet_csk_reqsk_queue_hash_add(sk, req,
 				tcp_timeout_init((struct sock *)req));
-		af_ops->send_synack(sk, dst, &fl, req, &foc,
+
+		af_ops->send_synack(sk, dst, &fl, req, skb, &foc,
 				    !want_cookie ? TCP_SYNACK_NORMAL :
 						   TCP_SYNACK_COOKIE);
 		if (want_cookie) {
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index a3535b7fe002..8a0b62fb4f79 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -963,6 +963,7 @@ static void tcp_v4_reqsk_send_ack(const struct sock *=
sk, struct sk_buff *skb,
 static int tcp_v4_send_synack(const struct sock *sk, struct dst_entry *d=
st,
 			      struct flowi *fl,
 			      struct request_sock *req,
+			      struct sk_buff *syn_skb,
 			      struct tcp_fastopen_cookie *foc,
 			      enum tcp_synack_type synack_type)
 {
@@ -975,7 +976,7 @@ static int tcp_v4_send_synack(const struct sock *sk, =
struct dst_entry *dst,
 	if (!dst && (dst =3D inet_csk_route_req(sk, &fl4, req)) =3D=3D NULL)
 		return -1;
=20
-	skb =3D tcp_make_synack(sk, dst, req, foc, synack_type);
+	skb =3D tcp_make_synack(sk, dst, req, syn_skb, foc, synack_type);
=20
 	if (skb) {
 		__tcp_v4_send_check(skb, ireq->ir_loc_addr, ireq->ir_rmt_addr);
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 495dda2449fe..56c306e3cd2f 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -548,6 +548,7 @@ struct sock *tcp_create_openreq_child(const struct so=
ck *sk,
 	newtp->fastopen_req =3D NULL;
 	RCU_INIT_POINTER(newtp->fastopen_rsk, NULL);
=20
+	bpf_skops_init_child(sk, newsk);
 	tcp_bpf_clone(sk, newsk);
=20
 	__TCP_INC_STATS(sock_net(sk), TCP_MIB_PASSIVEOPENS);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index a50e1990a845..a78a29980e1f 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -438,6 +438,7 @@ struct tcp_out_options {
 	u8 ws;			/* window scale, 0 to disable */
 	u8 num_sack_blocks;	/* number of SACK blocks to include */
 	u8 hash_size;		/* bytes in hash_location */
+	u8 bpf_hdr_opt_len;	/* length of BPF hdr option */
 	__u8 *hash_location;	/* temporary pointer, overloaded */
 	__u32 tsval, tsecr;	/* need to include OPTION_TS */
 	struct tcp_fastopen_cookie *fastopen_cookie;	/* Fast open cookie */
@@ -452,6 +453,152 @@ static void mptcp_options_write(__be32 *ptr, struct=
 tcp_out_options *opts)
 #endif
 }
=20
+#ifdef CONFIG_CGROUP_BPF
+static void bpf_skops_hdr_opt_len(struct sock *sk, struct sk_buff *skb,
+				  struct request_sock *req,
+				  struct sk_buff *syn_skb,
+				  bool want_cookie,
+				  struct tcp_out_options *opts,
+				  unsigned int *res_remaining)
+{
+	/* res_remaining has already been aligned to 4 bytes */
+	unsigned int remaining =3D *res_remaining;
+	struct bpf_sock_ops_kern sock_ops;
+	int err;
+
+	if (likely(!BPF_SOCK_OPS_TEST_FLAG(tcp_sk(sk),
+					BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG)) ||
+	    remaining <=3D TCPOLEN_EXP_BPF_BASE)
+		return;
+
+	BUILD_BUG_ON(TCPOLEN_EXP_BPF_BASE !=3D 4);
+	/* remaining is still rounded to 4 bytes */
+	remaining -=3D TCPOLEN_EXP_BPF_BASE;
+
+	/* init sock_ops */
+	memset(&sock_ops, 0, offsetof(struct bpf_sock_ops_kern, temp));
+
+	sock_ops.op =3D BPF_SOCK_OPS_HDR_OPT_LEN_CB;
+
+	if (req) {
+		/* The listen "sk" cannot be passed here because
+		 * it is not locked.  It would not make too much
+		 * sense to do bpf_setsockopt(listen_sk) based
+		 * on individual connection request also.
+		 *
+		 * Thus, "req" is passed here and the cgroup-bpf-progs
+		 * of the listen "sk" will be run.
+		 *
+		 * "req" is also used here for fastopen even the "sk" here is
+		 * the "child" sk.  It is to keep the behavior
+		 * consistent between fastopen and non-fastopen on
+		 * the bpf programming side.
+		 */
+		sock_ops.sk =3D (struct sock *)req;
+		sock_ops.syn_skb =3D syn_skb;
+	} else {
+		sock_owned_by_me(sk);
+
+		sock_ops.is_fullsock =3D 1;
+		sock_ops.sk =3D sk;
+	}
+
+	/* tcp_current_mss() does not pass a skb */
+	if (skb)
+		bpf_skops_init_skb(&sock_ops, skb, 0);
+
+	sock_ops.args[0] =3D remaining;
+	sock_ops.args[1] =3D want_cookie;
+	sock_ops.reservable_hdr_opt_len =3D remaining;
+
+	err =3D BPF_CGROUP_RUN_PROG_SOCK_OPS_SK(&sock_ops, sk);
+
+	if (err || !sock_ops.write_hdr_opt_len)
+		return;
+
+	opts->bpf_hdr_opt_len =3D sock_ops.write_hdr_opt_len +
+		TCPOLEN_EXP_BPF_BASE;
+	/* round up to 4 bytes */
+	opts->bpf_hdr_opt_len =3D (opts->bpf_hdr_opt_len + 3) & ~3;
+
+	*res_remaining -=3D opts->bpf_hdr_opt_len;
+}
+
+static void bpf_skops_write_hdr_opt(struct sock *sk, struct sk_buff *skb=
,
+				    struct request_sock *req,
+				    struct sk_buff *syn_skb,
+				    bool want_cookie,
+				    struct tcp_out_options *opts)
+{
+	u8 *kind_start, kind_len, max_kind_len =3D opts->bpf_hdr_opt_len;
+	struct tcphdr *th =3D (struct tcphdr *)skb->data;
+	struct bpf_sock_ops_kern sock_ops;
+	int err;
+
+	if (likely(!max_kind_len))
+		return;
+
+	memset(&sock_ops, 0, offsetof(struct bpf_sock_ops_kern, temp));
+
+	sock_ops.op =3D BPF_SOCK_OPS_WRITE_HDR_OPT_CB;
+
+	if (req) {
+		sock_ops.sk =3D (struct sock *)req;
+		sock_ops.syn_skb =3D syn_skb;
+	} else {
+		sock_owned_by_me(sk);
+
+		sock_ops.is_fullsock =3D 1;
+		sock_ops.sk =3D sk;
+	}
+
+	bpf_skops_init_skb(&sock_ops, skb, __tcp_hdrlen(th) - max_kind_len);
+
+	sock_ops.args[0] =3D max_kind_len - TCPOLEN_EXP_BPF_BASE;
+	sock_ops.args[1] =3D want_cookie;
+	sock_ops.write_hdr_opt_len =3D sock_ops.args[0];
+
+	kind_start =3D skb->data + sock_ops.skb_bpf_hdr_opt_off;
+	*(__be32 *)kind_start =3D htonl((TCPOPT_EXP << 24) |
+				      TCPOLEN_EXP_BPF_BASE |
+				      TCPOPT_BPF_MAGIC);
+
+	err =3D BPF_CGROUP_RUN_PROG_SOCK_OPS_SK(&sock_ops, sk);
+
+	kind_len =3D kind_start[1];
+	if (err || kind_len =3D=3D TCPOLEN_EXP_BPF_BASE) {
+		/* zero out the unwritten memory.
+		 *
+		 * bpf is the last one writing options, so it
+		 * can end with TCPOPT_EOL under abnormal cases.
+		 */
+		memset(kind_start, 0, max_kind_len);
+		kind_start[0] =3D TCPOPT_EOL;
+	} else if (kind_len < max_kind_len) {
+		/* Pad by NOP for normal case */
+		memset(kind_start + kind_len, TCPOPT_NOP,
+		       max_kind_len - kind_len);
+	}
+}
+#else
+static void bpf_skops_hdr_opt_len(struct sock *sk, struct sk_buff *skb,
+				  struct request_sock *req,
+				  struct sk_buff *syn_skb,
+				  bool want_cookie,
+				  struct tcp_out_options *opts,
+				  unsigned int *res_remaining)
+{
+}
+
+static void bpf_skops_write_hdr_opt(struct sock *sk, struct sk_buff *skb=
,
+				    struct request_sock *req,
+				    struct sk_buff *syn_skb,
+				    bool want_cookie,
+				    struct tcp_out_options *opts)
+{
+}
+#endif
+
 /* Write previously computed TCP options to the packet.
  *
  * Beware: Something in the Internet is very sensitive to the ordering o=
f
@@ -691,12 +838,16 @@ static unsigned int tcp_syn_options(struct sock *sk=
, struct sk_buff *skb,
 		}
 	}
=20
+	bpf_skops_hdr_opt_len(sk, skb, NULL, NULL, false, opts, &remaining);
+
 	return MAX_TCP_OPTION_SPACE - remaining;
 }
=20
 /* Set up TCP options for SYN-ACKs. */
 static unsigned int tcp_synack_options(const struct sock *sk,
 				       struct request_sock *req,
+				       struct sk_buff *syn_skb,
+				       bool want_cookie,
 				       unsigned int mss, struct sk_buff *skb,
 				       struct tcp_out_options *opts,
 				       const struct tcp_md5sig_key *md5,
@@ -756,15 +907,19 @@ static unsigned int tcp_synack_options(const struct=
 sock *sk,
=20
 	smc_set_option_cond(tcp_sk(sk), ireq, opts, &remaining);
=20
+	bpf_skops_hdr_opt_len((struct sock *)sk, skb, req, syn_skb,
+			      want_cookie, opts, &remaining);
+
 	return MAX_TCP_OPTION_SPACE - remaining;
 }
=20
 /* Compute TCP options for ESTABLISHED sockets. This is not the
  * final wire format yet.
  */
-static unsigned int tcp_established_options(struct sock *sk, struct sk_b=
uff *skb,
-					struct tcp_out_options *opts,
-					struct tcp_md5sig_key **md5)
+static unsigned int tcp_established_options(struct sock *sk,
+					    struct sk_buff *skb,
+					    struct tcp_out_options *opts,
+					    struct tcp_md5sig_key **md5)
 {
 	struct tcp_sock *tp =3D tcp_sk(sk);
 	unsigned int size =3D 0;
@@ -824,6 +979,16 @@ static unsigned int tcp_established_options(struct s=
ock *sk, struct sk_buff *skb
 			opts->num_sack_blocks * TCPOLEN_SACK_PERBLOCK;
 	}
=20
+	if (unlikely(BPF_SOCK_OPS_TEST_FLAG(tp,
+					    BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG))) {
+		unsigned int remaining =3D MAX_TCP_OPTION_SPACE - size;
+
+		bpf_skops_hdr_opt_len(sk, skb, NULL, NULL, false, opts,
+				      &remaining);
+
+		size =3D MAX_TCP_OPTION_SPACE - remaining;
+	}
+
 	return size;
 }
=20
@@ -1206,6 +1371,7 @@ static int __tcp_transmit_skb(struct sock *sk, stru=
ct sk_buff *skb,
 					       md5, sk, skb);
 	}
 #endif
+	bpf_skops_write_hdr_opt(sk, skb, NULL, NULL, false, &opts);
=20
 	icsk->icsk_af_ops->send_check(sk, skb);
=20
@@ -3333,9 +3499,11 @@ int tcp_send_synack(struct sock *sk)
  */
 struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry =
*dst,
 				struct request_sock *req,
+				struct sk_buff *syn_skb,
 				struct tcp_fastopen_cookie *foc,
 				enum tcp_synack_type synack_type)
 {
+	bool want_cookie =3D (synack_type =3D=3D TCP_SYNACK_COOKIE);
 	struct inet_request_sock *ireq =3D inet_rsk(req);
 	const struct tcp_sock *tp =3D tcp_sk(sk);
 	struct tcp_md5sig_key *md5 =3D NULL;
@@ -3393,8 +3561,11 @@ struct sk_buff *tcp_make_synack(const struct sock =
*sk, struct dst_entry *dst,
 	md5 =3D tcp_rsk(req)->af_specific->req_md5_lookup(sk, req_to_sk(req));
 #endif
 	skb_set_hash(skb, tcp_rsk(req)->txhash, PKT_HASH_TYPE_L4);
-	tcp_header_size =3D tcp_synack_options(sk, req, mss, skb, &opts, md5,
-					     foc) + sizeof(*th);
+	/* bpf program will be interested in the tcp_flags */
+	TCP_SKB_CB(skb)->tcp_flags =3D TCPHDR_SYN | TCPHDR_ACK;
+	tcp_header_size =3D tcp_synack_options(sk, req, syn_skb, want_cookie,
+					     mss, skb, &opts,
+					     md5, foc) + sizeof(*th);
=20
 	skb_push(skb, tcp_header_size);
 	skb_reset_transport_header(skb);
@@ -3416,6 +3587,8 @@ struct sk_buff *tcp_make_synack(const struct sock *=
sk, struct dst_entry *dst,
 	th->window =3D htons(min(req->rsk_rcv_wnd, 65535U));
 	tcp_options_write((__be32 *)(th + 1), NULL, &opts);
 	th->doff =3D (tcp_header_size >> 2);
+	bpf_skops_write_hdr_opt((struct sock *)sk, skb, req, syn_skb,
+				want_cookie, &opts);
 	__TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
=20
 #ifdef CONFIG_TCP_MD5SIG
@@ -3919,7 +4092,8 @@ int tcp_rtx_synack(const struct sock *sk, struct re=
quest_sock *req)
 	int res;
=20
 	tcp_rsk(req)->txhash =3D net_tx_rndhash();
-	res =3D af_ops->send_synack(sk, NULL, &fl, req, NULL, TCP_SYNACK_NORMAL=
);
+	res =3D af_ops->send_synack(sk, NULL, &fl, req, NULL, NULL,
+				  TCP_SYNACK_NORMAL);
 	if (!res) {
 		__TCP_INC_STATS(sock_net(sk), TCP_MIB_RETRANSSEGS);
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNRETRANS);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 8356d0562279..3036ae6532dd 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -500,6 +500,7 @@ static int tcp_v6_err(struct sk_buff *skb, struct ine=
t6_skb_parm *opt,
 static int tcp_v6_send_synack(const struct sock *sk, struct dst_entry *d=
st,
 			      struct flowi *fl,
 			      struct request_sock *req,
+			      struct sk_buff *syn_skb,
 			      struct tcp_fastopen_cookie *foc,
 			      enum tcp_synack_type synack_type)
 {
@@ -515,7 +516,7 @@ static int tcp_v6_send_synack(const struct sock *sk, =
struct dst_entry *dst,
 					       IPPROTO_TCP)) =3D=3D NULL)
 		goto done;
=20
-	skb =3D tcp_make_synack(sk, dst, req, foc, synack_type);
+	skb =3D tcp_make_synack(sk, dst, req, syn_skb, foc, synack_type);
=20
 	if (skb) {
 		__tcp_v6_send_check(skb, &ireq->ir_v6_loc_addr,
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 0cb8ec948816..479b83d05811 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3285,6 +3285,110 @@ union bpf_attr {
  *		Dynamically cast a *sk* pointer to a *udp6_sock* pointer.
  *	Return
  *		*sk* if casting is valid, or NULL otherwise.
+ *
+ * long bpf_store_hdr_opt(struct bpf_sock_ops *skops, u32 offset, const =
void *from, u32 len, u64 flags)
+ *	Description
+ *		Store BPF header option.  The data will be copied
+ *		from buffer *from* with length *len* to the bpf header
+ *		option at *offset*.
+ *
+ *		This helper does not allow updating the header "kind",
+ *		"kind length", and the 16-bit magic.  *offset* 0
+ *		points immediately after the 16-bit magic.
+ *		This helper will automatically update the "kind length" as
+ *		the bpf header option is written by this helper.  It can
+ *		guarantee that the header option format always
+ *		conforms to the standard.
+ *
+ *		The bpf program can write everything at once
+ *		from offset 0.
+ *
+ *		The bpf program can also do incremental write by calling
+ *		this helper multiple times with incremental (but
+ *		continuous) offset.
+ *
+ *		The bpf program (e.g. the parent cgroup bpf program)
+ *		can also rewrite a few bytes that has already been
+ *		written by some ealier bpf programs.  The bpf
+ *		program can also learn what header option has been
+ *		written by the earlier bpf programs through
+ *		sock_ops->skb_data.
+ *
+ *		A bpf program can always write at offset 0 again
+ *		to overwrite all bpf header options that has been written
+ *		by the previous bpf programs.  If the bpf program
+ *		writes less than the previous bpf programs do,
+ *		the tailing bytes will be removed unless
+ *		*BP_F_STORE_HDR_OPT_NOTRIM* is used.
+ *		e.g. bpf_store_hdr_opt(skops, 0, NULL, 0, 0) will
+ *		remove all previously written option.
+ *
+ *		This helper will reject the *offset* if there is any
+ *		byte/hole that has never been written before this
+ *		*offset*.
+ *
+ *		For example, it can write at offset 0 for 2 bytes,
+ *		then write at offset 2 for 1 bytes, and then finally
+ *		write at offset 3 for 2 bytes.  Thus, the bpf prog
+ *		has totally written 5 bytes.
+ *		The "kind length" will be 9 bytes:
+ *		4 bytes (1byte kind + 1byte kind_len + 2byte magic) +
+ *		5 bytes written by the bpf program.
+ *
+ *		However, this helper does not allow writing at offset 0
+ *		for 2 bytes and then immediately write at offset 3 without
+ *		writing at offset 2 first.
+ *
+ *		This helper can only be called during
+ *		BPF_SOCK_OPS_WRITE_HDR_OPT_CB.  The previous reserved
+ *		space is passed in sock_ops->args[0].
+ *
+ *		The following flags are supported:
+ *		* **BPF_F_STORE_HDR_OPT_NOTRIM**: Usually, bpf program
+ *		  does write with incremental offset instead of
+ *		  jumping the offset back and forth.
+ *		  Thus, by default, after calling this helper,
+ *		  anything previously written after offset + len
+ *		  will be removed.
+ *		  This flag can be used to keep the tailing
+ *		  data after "offset + len".
+ *
+ *	Return
+ *		0 on success, or negative error in case of failure:
+ *
+ *		**-EINVAL** if param is invalid
+ *
+ *		**-EFAULT** *offset* + *len* is outside of the
+ *		            reserved option space or
+ *			    there is unwritten byte before *offset*.
+ *
+ *		**-EPERM** This helper cannot be used under the
+ *			   current sock_ops->op.
+ *
+ * long bpf_reserve_hdr_opt(struct bpf_sock_ops *skops, u32 len, u64 fla=
gs)
+ *	Description
+ *		Reserve *len* bytes for the bpf header option.  This
+ *		space will be available to use by bpf_store_hdr_opt()
+ *		later.
+ *
+ *		If bpf_reserve_hdr_opt() is called multiple times (e.g
+ *		by mulitple cgroup bpf programs),
+ *		the maximum *len* among them will be reserved.
+ *
+ *		This helper can only be called during
+ *		BPF_SOCK_OPS_HDR_OPT_LEN_CB.  The maximum
+ *		reservable space is passed in
+ *		sock_ops->args[0].
+ *
+ *	Return
+ *		0 on success, or negative error in case of failure:
+ *
+ *		**-EINVAL** if param is invalid
+ *
+ *		**-ENOSPC** Not enough remaining space in the header.
+ *
+ *		**-EPERM** This helper cannot be used under the
+ *			   current sock_ops->op.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3427,7 +3531,9 @@ union bpf_attr {
 	FN(skc_to_tcp_sock),		\
 	FN(skc_to_tcp_timewait_sock),	\
 	FN(skc_to_tcp_request_sock),	\
-	FN(skc_to_udp6_sock),
+	FN(skc_to_udp6_sock),		\
+	FN(store_hdr_opt),		\
+	FN(reserve_hdr_opt),
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
  * function eBPF program intends to call
@@ -4024,6 +4130,11 @@ struct bpf_sock_ops {
 	__u64 bytes_received;
 	__u64 bytes_acked;
 	__bpf_md_ptr(struct bpf_sock *, sk);
+	__bpf_md_ptr(void *, skb_data);
+	__bpf_md_ptr(void *, skb_data_end);
+	__u32 skb_len;
+	__u32 skb_bpf_hdr_opt_off;
+	__u32 skb_tcp_flags;
 };
=20
 /* Definitions for bpf_sock_ops_cb_flags */
@@ -4032,8 +4143,14 @@ enum {
 	BPF_SOCK_OPS_RETRANS_CB_FLAG	=3D (1<<1),
 	BPF_SOCK_OPS_STATE_CB_FLAG	=3D (1<<2),
 	BPF_SOCK_OPS_RTT_CB_FLAG	=3D (1<<3),
+	BPF_SOCK_OPS_PARSE_HDR_OPT_CB_FLAG =3D (1<<4),
+	BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG =3D (1<<5),
 /* Mask of all currently supported cb flags */
-	BPF_SOCK_OPS_ALL_CB_FLAGS       =3D 0xF,
+	BPF_SOCK_OPS_ALL_CB_FLAGS       =3D 0x3F,
+};
+
+enum {
+	BPF_F_STORE_HDR_OPT_NOTRIM	=3D (1ULL << 0),
 };
=20
 /* List of known BPF sock_ops operators.
@@ -4089,6 +4206,58 @@ enum {
 					 */
 	BPF_SOCK_OPS_RTT_CB,		/* Called on every RTT.
 					 */
+	BPF_SOCK_OPS_PARSE_HDR_OPT_CB,	/* Parse the BPF header option.
+					 * It will be called to handle
+					 * the packets received at
+					 * socket that has been established.
+					 */
+	BPF_SOCK_OPS_HDR_OPT_LEN_CB,	/* Reserve space for writing the BPF
+					 * header option later in
+					 * BPF_SOCK_OPS_WRITE_HDR_OPT_CB.
+					 * Arg1: Max reservable bytes
+					 * Arg2: bool want_cookie. (in
+					 *       writing SYNACK only)
+					 *
+					 * sock_ops->skb_data:
+					 *	Referring to the
+					 *	outgoing skb.
+					 *	It is pointing to the
+					 *	TCP payload because
+					 *	no TCP header has
+					 *	been written yet.
+					 *
+					 * sock_ops->skb_tcp_flags:
+					 *	the tcp_flags of the
+					 *	outgoing skb. (e.g.
+					 *      SYN, ACK, FIN).
+					 *
+					 * bpf_reserve_hdr_opt() should
+					 * be used to reserve space.
+					 */
+	BPF_SOCK_OPS_WRITE_HDR_OPT_CB,	/* Write the BPF header OPTIONS
+					 * Arg1: num of bytes reserved during
+					 *       BPF_SOCK_OPS_HDR_OPT_LEN_CB
+					 * Arg2: bool want_cookie. (in
+					 *       writing SYNACK only)
+					 *
+					 * sock_ops->skb_data:
+					 *	referring to the
+					 *	outgoing skb.
+					 *	It is pointing to the
+					 *	TCP header.
+					 *
+					 * sock_ops->skb_bpf_hdr_opt_off:
+					 *	offset to the bpf
+					 *	header option.  bpf
+					 *	prog can inspect what bpf
+					 *	option has already been
+					 *	written.
+					 *
+					 * sock_ops->skb_tcp_flags:
+					 *	the tcp_flags of the
+					 *	outgoing skb. (e.g.
+					 *	SYN, ACK, FIN).
+					 */
 };
=20
 /* List of TCP states. There is a build check in net/ipv4/tcp.c to detec=
t
@@ -4116,6 +4285,20 @@ enum {
 enum {
 	TCP_BPF_IW		=3D 1001,	/* Set TCP initial congestion window */
 	TCP_BPF_SNDCWND_CLAMP	=3D 1002,	/* Set sndcwnd_clamp */
+	/* Copy the BPF header option from syn pkt to optval
+	 *
+	 * BPF_PROG_TYPE_SOCK_OPS only.  It is similar to the
+	 * TCP_SAVED_SYN but it only gets the bpf header option
+	 * from the syn packet.
+	 *
+	 *       0: Success
+	 * -ENOSPC: Not enough space in optval. Only optlen number of
+	 *          bytes is copied.
+	 * -ENOMSG: BPF TCP header option not found
+	 * -ENOENT: The SYN skb is not available now and the earlier SYN pkt
+	 *	    is not saved by TCP_SAVE_SYN.
+	 */
+	TCP_BPF_SYN_HDR_OPT	=3D 1003,
 };
=20
 struct bpf_perf_event_value {
--=20
2.24.1

