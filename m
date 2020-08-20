Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4808D24C608
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 21:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgHTTBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 15:01:24 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18462 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727845AbgHTTBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 15:01:14 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KJ0xon017874
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 12:01:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=AjZcq/MMwJ+cQwTyWqwVf82QBGQjORDUX7LbiBdcOVU=;
 b=BXqdzzyxo+VNDVFMHt6MOOgxT8JoXnTXbqiV2e9Jk1vuyQ60E95BH3AQM9nbO7jWSAt5
 YDLRMZ4xDxF9cdXy1mSrOiOZQD8cyO+QGIuw/F42ZGOGl3ralrCgtxe3GkxEWyDNYwc9
 080bfnFKE6J1DvhF9zlFhxqSVLj2GPsdafI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304p3r0s2-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 12:01:08 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 12:01:05 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id DCFEB2945825; Thu, 20 Aug 2020 12:01:04 -0700 (PDT)
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
Subject: [PATCH v5 bpf-next 09/12] bpf: tcp: Allow bpf prog to write and parse TCP header option
Date:   Thu, 20 Aug 2020 12:01:04 -0700
Message-ID: <20200820190104.2885895-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200820190008.2883500-1-kafai@fb.com>
References: <20200820190008.2883500-1-kafai@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_03:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 spamscore=0 mlxscore=0 clxscore=1015 suspectscore=1 adultscore=0
 bulkscore=0 impostorscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200151
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Note: The TCP changes here is mainly to implement the bpf
  pieces into the bpf_skops_*() functions introduced
  in the earlier patches. ]

The earlier effort in BPF-TCP-CC allows the TCP Congestion Control
algorithm to be written in BPF.  It opens up opportunities to allow
a faster turnaround time in testing/releasing new congestion control
ideas to production environment.

The same flexibility can be extended to writing TCP header option.
It is not uncommon that people want to test new TCP header option
to improve the TCP performance.  Another use case is for data-center
that has a more controlled environment and has more flexibility in
putting header options for internal only use.

For example, we want to test the idea in putting maximum delay
ACK in TCP header option which is similar to a draft RFC proposal [1].

This patch introduces the necessary BPF API and use them in the
TCP stack to allow BPF_PROG_TYPE_SOCK_OPS program to parse
and write TCP header options.  It currently supports most of
the TCP packet except RST.

Supported TCP header option:
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80
This patch allows the bpf-prog to write any option kind.
Different bpf-progs can write its own option by calling the new helper
bpf_store_hdr_opt().  The helper will ensure there is no duplicated
option in the header.

By allowing bpf-prog to write any option kind, this gives a lot of
flexibility to the bpf-prog.  Different bpf-prog can write its
own option kind.  It could also allow the bpf-prog to support a
recently standardized option on an older kernel.

Sockops Callback Flags:
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80
The bpf program will only be called to parse/write tcp header option
if the following newly added callback flags are enabled
in tp->bpf_sock_ops_cb_flags:
BPF_SOCK_OPS_PARSE_UNKNOWN_HDR_OPT_CB_FLAG
BPF_SOCK_OPS_PARSE_ALL_HDR_OPT_CB_FLAG
BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG

A few words on the PARSE CB flags.  When the above PARSE CB flags are
turned on, the bpf-prog will be called on packets received
at a sk that has at least reached the ESTABLISHED state.
The parsing of the SYN-SYNACK-ACK will be discussed in the
"3 Way HandShake" section.

The default is off for all of the above new CB flags, i.e. the bpf prog
will not be called to parse or write bpf hdr option.  There are
details comment on these new cb flags in the UAPI bpf.h.

sock_ops->skb_data and bpf_load_hdr_opt()
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80
sock_ops->skb_data and sock_ops->skb_data_end covers the whole
TCP header and its options.  They are read only.

The new bpf_load_hdr_opt() helps to read a particular option "kind"
from the skb_data.

Please refer to the comment in UAPI bpf.h.  It has details
on what skb_data contains under different sock_ops->op.

3 Way HandShake
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80
The bpf-prog can learn if it is sending SYN or SYNACK by reading the
sock_ops->skb_tcp_flags.

* Passive side

When writing SYNACK (i.e. sock_ops->op =3D=3D BPF_SOCK_OPS_WRITE_HDR_OPT_=
CB),
the received SYN skb will be available to the bpf prog.  The bpf prog can
use the SYN skb (which may carry the header option sent from the remote b=
pf
prog) to decide what bpf header option should be written to the outgoing
SYNACK skb.  The SYN packet can be obtained by getsockopt(TCP_BPF_SYN*).
More on this later.  Also, the bpf prog can learn if it is in syncookie
mode (by checking sock_ops->args[0] =3D=3D BPF_WRITE_HDR_TCP_SYNACK_COOKI=
E).

The bpf prog can store the received SYN pkt by using the existing
bpf_setsockopt(TCP_SAVE_SYN).  The example in a later patch does it.
[ Note that the fullsock here is a listen sk, bpf_sk_storage
  is not very useful here since the listen sk will be shared
  by many concurrent connection requests.

  Extending bpf_sk_storage support to request_sock will add weight
  to the minisock and it is not necessary better than storing the
  whole ~100 bytes SYN pkt. ]

When the connection is established, the bpf prog will be called
in the existing PASSIVE_ESTABLISHED_CB callback.  At that time,
the bpf prog can get the header option from the saved syn and
then apply the needed operation to the newly established socket.
The later patch will use the max delay ack specified in the SYN
header and set the RTO of this newly established connection
as an example.

The received ACK (that concludes the 3WHS) will also be available to
the bpf prog during PASSIVE_ESTABLISHED_CB through the sock_ops->skb_data=
.
It could be useful in syncookie scenario.  More on this later.

There is an existing getsockopt "TCP_SAVED_SYN" to return the whole
saved syn pkt which includes the IP[46] header and the TCP header.
A few "TCP_BPF_SYN*" getsockopt has been added to allow specifying where =
to
start getting from, e.g. starting from TCP header, or from IP[46] header.

The new getsockopt(TCP_BPF_SYN*) will also know where it can get
the SYN's packet from:
  - (a) the just received syn (available when the bpf prog is writing SYN=
ACK)
        and it is the only way to get SYN during syncookie mode.
  or
  - (b) the saved syn (available in PASSIVE_ESTABLISHED_CB and also other
        existing CB).

The bpf prog does not need to know where the SYN pkt is coming from.
The getsockopt(TCP_BPF_SYN*) will hide this details.

Similarly, a flags "BPF_LOAD_HDR_OPT_TCP_SYN" is also added to
bpf_load_hdr_opt() to read a particular header option from the SYN packet=
.

* Fastopen

Fastopen should work the same as the regular non fastopen case.
This is a test in a later patch.

* Syncookie

For syncookie, the later example patch asks the active
side's bpf prog to resend the header options in ACK.  The server
can use bpf_load_hdr_opt() to look at the options in this
received ACK during PASSIVE_ESTABLISHED_CB.

* Active side

The bpf prog will get a chance to write the bpf header option
in the SYN packet during WRITE_HDR_OPT_CB.  The received SYNACK
pkt will also be available to the bpf prog during the existing
ACTIVE_ESTABLISHED_CB callback through the sock_ops->skb_data
and bpf_load_hdr_opt().

* Turn off header CB flags after 3WHS

If the bpf prog does not need to write/parse header options
beyond the 3WHS, the bpf prog can clear the bpf_sock_ops_cb_flags
to avoid being called for header options.
Or the bpf-prog can select to leave the UNKNOWN_HDR_OPT_CB_FLAG on
so that the kernel will only call it when there is option that
the kernel cannot handle.

[1]: draft-wang-tcpm-low-latency-opt-00
     https://tools.ietf.org/html/draft-wang-tcpm-low-latency-opt-00

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/bpf-cgroup.h     |  25 +++
 include/linux/filter.h         |   4 +
 include/net/tcp.h              |  49 +++++
 include/uapi/linux/bpf.h       | 300 ++++++++++++++++++++++++++-
 net/core/filter.c              | 365 +++++++++++++++++++++++++++++++++
 net/ipv4/tcp_input.c           |  20 +-
 net/ipv4/tcp_minisocks.c       |   1 +
 net/ipv4/tcp_output.c          | 104 +++++++++-
 tools/include/uapi/linux/bpf.h | 300 ++++++++++++++++++++++++++-
 9 files changed, 1150 insertions(+), 18 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 64f367044e25..2f98d2fce62e 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -279,6 +279,31 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map =
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
+ * so passing 'sock_ops->sk =3D=3D req_sk' to the bpf prog is appropriat=
e here.
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
index c427dfa5f908..995625950cc1 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1241,8 +1241,12 @@ struct bpf_sock_ops_kern {
 		u32 reply;
 		u32 replylong[4];
 	};
+	struct sk_buff	*syn_skb;
+	struct sk_buff	*skb;
+	void	*skb_data_end;
 	u8	op;
 	u8	is_fullsock;
+	u8	remaining_opt_len;
 	u64	temp;			/* temp and everything after is not
 					 * initialized to 0 before calling
 					 * the BPF program. New fields that
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 3e768a6b8264..1f967b4e22f6 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2235,6 +2235,55 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_p=
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
+		(BPF_SOCK_OPS_PARSE_ALL_HDR_OPT_CB_FLAG |
+		 BPF_SOCK_OPS_PARSE_UNKNOWN_HDR_OPT_CB_FLAG |
+		 BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG);
+}
+
+static inline void bpf_skops_init_skb(struct bpf_sock_ops_kern *skops,
+				      struct sk_buff *skb,
+				      unsigned int end_offset)
+{
+	skops->skb =3D skb;
+	skops->skb_data_end =3D skb->data + end_offset;
+}
+#else
+static inline void bpf_skops_init_child(const struct sock *sk,
+					struct sock *child)
+{
+}
+
+static inline void bpf_skops_init_skb(struct bpf_sock_ops_kern *skops,
+				      struct sk_buff *skb,
+				      unsigned int end_offset)
+{
+}
+#endif
+
 /* Call BPF_SOCK_OPS program that returns an int. If the return value
  * is < 0, then the BPF op failed (for example if the loaded BPF
  * program does not support the chosen operation or there is no BPF
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 6770d00d5781..277b145bf7c3 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3395,6 +3395,120 @@ union bpf_attr {
  *		A non-negative value equal to or less than *size* on success,
  *		or a negative error in case of failure.
  *
+ * long bpf_load_hdr_opt(struct bpf_sock_ops *skops, void *searchby_res,=
 u32 len, u64 flags)
+ *	Description
+ *		Load header option.  Support reading a particular TCP header
+ *		option for bpf program (BPF_PROG_TYPE_SOCK_OPS).
+ *
+ *		If *flags* is 0, it will search the option from the
+ *		sock_ops->skb_data.  The comment in "struct bpf_sock_ops"
+ *		has details on what skb_data contains under different
+ *		sock_ops->op.
+ *
+ *		The first byte of the *searchby_res* specifies the
+ *		kind that it wants to search.
+ *
+ *		If the searching kind is an experimental kind
+ *		(i.e. 253 or 254 according to RFC6994).  It also
+ *		needs to specify the "magic" which is either
+ *		2 bytes or 4 bytes.  It then also needs to
+ *		specify the size of the magic by using
+ *		the 2nd byte which is "kind-length" of a TCP
+ *		header option and the "kind-length" also
+ *		includes the first 2 bytes "kind" and "kind-length"
+ *		itself as a normal TCP header option also does.
+ *
+ *		For example, to search experimental kind 254 with
+ *		2 byte magic 0xeB9F, the searchby_res should be
+ *		[ 254, 4, 0xeB, 0x9F, 0, 0, .... 0 ].
+ *
+ *		To search for the standard window scale option (3),
+ *		the searchby_res should be [ 3, 0, 0, .... 0 ].
+ *		Note, kind-length must be 0 for regular option.
+ *
+ *		Searching for No-Op (0) and End-of-Option-List (1) are
+ *		not supported.
+ *
+ *		*len* must be at least 2 bytes which is the minimal size
+ *		of a header option.
+ *
+ *		Supported flags:
+ *		* **BPF_LOAD_HDR_OPT_TCP_SYN** to search from the
+ *		  saved_syn packet or the just-received syn packet.
+ *
+ *	Return
+ *		>0 when found, the header option is copied to *searchby_res*.
+ *		The return value is the total length copied.
+ *
+ *		**-EINVAL** If param is invalid
+ *
+ *		**-ENOMSG** The option is not found
+ *
+ *		**-ENOENT** No syn packet available when
+ *			    **BPF_LOAD_HDR_OPT_TCP_SYN** is used
+ *
+ *		**-ENOSPC** Not enough space.  Only *len* number of
+ *			    bytes are copied.
+ *
+ *		**-EFAULT** Cannot parse the header options in the packet
+ *
+ *		**-EPERM** This helper cannot be used under the
+ *			   current sock_ops->op.
+ *
+ * long bpf_store_hdr_opt(struct bpf_sock_ops *skops, const void *from, =
u32 len, u64 flags)
+ *	Description
+ *		Store header option.  The data will be copied
+ *		from buffer *from* with length *len* to the TCP header.
+ *
+ *		The buffer *from* should have the whole option that
+ *		includes the kind, kind-length, and the actual
+ *		option data.  The *len* must be at least kind-length
+ *		long.  The kind-length does not have to be 4 byte
+ *		aligned.  The kernel will take care of the padding
+ *		and setting the 4 bytes aligned value to th->doff.
+ *
+ *		This helper will check for duplicated option
+ *		by searching the same option in the outgoing skb.
+ *
+ *		This helper can only be called during
+ *		BPF_SOCK_OPS_WRITE_HDR_OPT_CB.
+ *
+ *	Return
+ *		0 on success, or negative error in case of failure:
+ *
+ *		**-EINVAL** If param is invalid
+ *
+ *		**-ENOSPC** Not enough space in the header.
+ *			    Nothing has been written
+ *
+ *		**-EEXIST** The option has already existed
+ *
+ *		**-EFAULT** Cannot parse the existing header options
+ *
+ *		**-EPERM** This helper cannot be used under the
+ *			   current sock_ops->op.
+ *
+ * long bpf_reserve_hdr_opt(struct bpf_sock_ops *skops, u32 len, u64 fla=
gs)
+ *	Description
+ *		Reserve *len* bytes for the bpf header option.  The
+ *		space will be used by bpf_store_hdr_opt() later in
+ *		BPF_SOCK_OPS_WRITE_HDR_OPT_CB.
+ *
+ *		If bpf_reserve_hdr_opt() is called multiple times,
+ *		the total number of bytes will be reserved.
+ *
+ *		This helper can only be called during
+ *		BPF_SOCK_OPS_HDR_OPT_LEN_CB.
+ *
+ *	Return
+ *		0 on success, or negative error in case of failure:
+ *
+ *		**-EINVAL** if param is invalid
+ *
+ *		**-ENOSPC** Not enough space in the header.
+ *
+ *		**-EPERM** This helper cannot be used under the
+ *			   current sock_ops->op.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3539,6 +3653,9 @@ union bpf_attr {
 	FN(skc_to_tcp_request_sock),	\
 	FN(skc_to_udp6_sock),		\
 	FN(get_task_stack),		\
+	FN(load_hdr_opt),		\
+	FN(store_hdr_opt),		\
+	FN(reserve_hdr_opt),
 	/* */
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
@@ -4158,6 +4275,36 @@ struct bpf_sock_ops {
 	__u64 bytes_received;
 	__u64 bytes_acked;
 	__bpf_md_ptr(struct bpf_sock *, sk);
+	/* [skb_data, skb_data_end) covers the whole TCP header.
+	 *
+	 * BPF_SOCK_OPS_PARSE_HDR_OPT_CB: The packet received
+	 * BPF_SOCK_OPS_HDR_OPT_LEN_CB:   Not useful because the
+	 *                                header has not been written.
+	 * BPF_SOCK_OPS_WRITE_HDR_OPT_CB: The header and options have
+	 *				  been written so far.
+	 * BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB:  The SYNACK that concludes
+	 *					the 3WHS.
+	 * BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB: The ACK that concludes
+	 *					the 3WHS.
+	 *
+	 * bpf_load_hdr_opt() can also be used to read a particular option.
+	 */
+	__bpf_md_ptr(void *, skb_data);
+	__bpf_md_ptr(void *, skb_data_end);
+	__u32 skb_len;		/* The total length of a packet.
+				 * It includes the header, options,
+				 * and payload.
+				 */
+	__u32 skb_tcp_flags;	/* tcp_flags of the header.  It provides
+				 * an easy way to check for tcp_flags
+				 * without parsing skb_data.
+				 *
+				 * In particular, the skb_tcp_flags
+				 * will still be available in
+				 * BPF_SOCK_OPS_HDR_OPT_LEN even though
+				 * the outgoing header has not
+				 * been written yet.
+				 */
 };
=20
 /* Definitions for bpf_sock_ops_cb_flags */
@@ -4166,8 +4313,48 @@ enum {
 	BPF_SOCK_OPS_RETRANS_CB_FLAG	=3D (1<<1),
 	BPF_SOCK_OPS_STATE_CB_FLAG	=3D (1<<2),
 	BPF_SOCK_OPS_RTT_CB_FLAG	=3D (1<<3),
-	BPF_SOCK_OPS_PARSE_ALL_HDR_OPT_CB_FLAG  =3D (1<<4),
+	/* Call bpf for all received TCP headers.  The bpf prog will be
+	 * called under sock_ops->op =3D=3D BPF_SOCK_OPS_PARSE_HDR_OPT_CB
+	 *
+	 * Please refer to the comment in BPF_SOCK_OPS_PARSE_HDR_OPT_CB
+	 * for the header option related helpers that will be useful
+	 * to the bpf programs.
+	 *
+	 * It could be used at the client/active side (i.e. connect() side)
+	 * when the server told it that the server was in syncookie
+	 * mode and required the active side to resend the bpf-written
+	 * options.  The active side can keep writing the bpf-options until
+	 * it received a valid packet from the server side to confirm
+	 * the earlier packet (and options) has been received.  The later
+	 * example patch is using it like this at the active side when the
+	 * server is in syncookie mode.
+	 *
+	 * The bpf prog will usually turn this off in the common cases.
+	 */
+	BPF_SOCK_OPS_PARSE_ALL_HDR_OPT_CB_FLAG	=3D (1<<4),
+	/* Call bpf when kernel has received a header option that
+	 * the kernel cannot handle.  The bpf prog will be called under
+	 * sock_ops->op =3D=3D BPF_SOCK_OPS_PARSE_HDR_OPT_CB.
+	 *
+	 * Please refer to the comment in BPF_SOCK_OPS_PARSE_HDR_OPT_CB
+	 * for the header option related helpers that will be useful
+	 * to the bpf programs.
+	 */
 	BPF_SOCK_OPS_PARSE_UNKNOWN_HDR_OPT_CB_FLAG =3D (1<<5),
+	/* Call bpf when the kernel is writing header options for the
+	 * outgoing packet.  The bpf prog will first be called
+	 * to reserve space in a skb under
+	 * sock_ops->op =3D=3D BPF_SOCK_OPS_HDR_OPT_LEN_CB.  Then
+	 * the bpf prog will be called to write the header option(s)
+	 * under sock_ops->op =3D=3D BPF_SOCK_OPS_WRITE_HDR_OPT_CB.
+	 *
+	 * Please refer to the comment in BPF_SOCK_OPS_HDR_OPT_LEN_CB
+	 * and BPF_SOCK_OPS_WRITE_HDR_OPT_CB for the header option
+	 * related helpers that will be useful to the bpf programs.
+	 *
+	 * The kernel gets its chance to reserve space and write
+	 * options first before the BPF program does.
+	 */
 	BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG =3D (1<<6),
 /* Mask of all currently supported cb flags */
 	BPF_SOCK_OPS_ALL_CB_FLAGS       =3D 0x7F,
@@ -4226,6 +4413,63 @@ enum {
 					 */
 	BPF_SOCK_OPS_RTT_CB,		/* Called on every RTT.
 					 */
+	BPF_SOCK_OPS_PARSE_HDR_OPT_CB,	/* Parse the header option.
+					 * It will be called to handle
+					 * the packets received at
+					 * an already established
+					 * connection.
+					 *
+					 * sock_ops->skb_data:
+					 * Referring to the received skb.
+					 * It covers the TCP header only.
+					 *
+					 * bpf_load_hdr_opt() can also
+					 * be used to search for a
+					 * particular option.
+					 */
+	BPF_SOCK_OPS_HDR_OPT_LEN_CB,	/* Reserve space for writing the
+					 * header option later in
+					 * BPF_SOCK_OPS_WRITE_HDR_OPT_CB.
+					 * Arg1: bool want_cookie. (in
+					 *       writing SYNACK only)
+					 *
+					 * sock_ops->skb_data:
+					 * Not available because no header has
+					 * been	written yet.
+					 *
+					 * sock_ops->skb_tcp_flags:
+					 * The tcp_flags of the
+					 * outgoing skb. (e.g. SYN, ACK, FIN).
+					 *
+					 * bpf_reserve_hdr_opt() should
+					 * be used to reserve space.
+					 */
+	BPF_SOCK_OPS_WRITE_HDR_OPT_CB,	/* Write the header options
+					 * Arg1: bool want_cookie. (in
+					 *       writing SYNACK only)
+					 *
+					 * sock_ops->skb_data:
+					 * Referring to the outgoing skb.
+					 * It covers the TCP header
+					 * that has already been written
+					 * by the kernel and the
+					 * earlier bpf-progs.
+					 *
+					 * sock_ops->skb_tcp_flags:
+					 * The tcp_flags of the outgoing
+					 * skb. (e.g. SYN, ACK, FIN).
+					 *
+					 * bpf_store_hdr_opt() should
+					 * be used to write the
+					 * option.
+					 *
+					 * bpf_load_hdr_opt() can also
+					 * be used to search for a
+					 * particular option that
+					 * has already been written
+					 * by the kernel or the
+					 * earlier bpf-progs.
+					 */
 };
=20
 /* List of TCP states. There is a build check in net/ipv4/tcp.c to detec=
t
@@ -4255,6 +4499,60 @@ enum {
 	TCP_BPF_SNDCWND_CLAMP	=3D 1002,	/* Set sndcwnd_clamp */
 	TCP_BPF_DELACK_MAX	=3D 1003, /* Max delay ack in usecs */
 	TCP_BPF_RTO_MIN		=3D 1004, /* Min delay ack in usecs */
+	/* Copy the SYN pkt to optval
+	 *
+	 * BPF_PROG_TYPE_SOCK_OPS only.  It is similar to the
+	 * bpf_getsockopt(TCP_SAVED_SYN) but it does not limit
+	 * to only getting from the saved_syn.  It can either get the
+	 * syn packet from:
+	 *
+	 * 1. the just-received SYN packet (only available when writing the
+	 *    SYNACK).  It will be useful when it is not necessary to
+	 *    save the SYN packet for latter use.  It is also the only way
+	 *    to get the SYN during syncookie mode because the syn
+	 *    packet cannot be saved during syncookie.
+	 *
+	 * OR
+	 *
+	 * 2. the earlier saved syn which was done by
+	 *    bpf_setsockopt(TCP_SAVE_SYN).
+	 *
+	 * The bpf_getsockopt(TCP_BPF_SYN*) option will hide where the
+	 * SYN packet is obtained.
+	 *
+	 * If the bpf-prog does not need the IP[46] header,  the
+	 * bpf-prog can avoid parsing the IP header by using
+	 * TCP_BPF_SYN.  Otherwise, the bpf-prog can get both
+	 * IP[46] and TCP header by using TCP_BPF_SYN_IP.
+	 *
+	 *      >0: Total number of bytes copied
+	 * -ENOSPC: Not enough space in optval. Only optlen number of
+	 *          bytes is copied.
+	 * -ENOENT: The SYN skb is not available now and the earlier SYN pkt
+	 *	    is not saved by setsockopt(TCP_SAVE_SYN).
+	 */
+	TCP_BPF_SYN		=3D 1005, /* Copy the TCP header */
+	TCP_BPF_SYN_IP		=3D 1006, /* Copy the IP[46] and TCP header */
+};
+
+enum {
+	BPF_LOAD_HDR_OPT_TCP_SYN =3D (1ULL << 0),
+};
+
+/* args[0] value during BPF_SOCK_OPS_HDR_OPT_LEN_CB and
+ * BPF_SOCK_OPS_WRITE_HDR_OPT_CB.
+ */
+enum {
+	BPF_WRITE_HDR_TCP_CURRENT_MSS =3D 1,	/* Kernel is finding the
+						 * total option spaces
+						 * required for an established
+						 * sk in order to calculate the
+						 * MSS.  No skb is actually
+						 * sent.
+						 */
+	BPF_WRITE_HDR_TCP_SYNACK_COOKIE =3D 2,	/* Kernel is in syncookie mode
+						 * when sending a SYN.
+						 */
 };
=20
 struct bpf_perf_event_value {
diff --git a/net/core/filter.c b/net/core/filter.c
index 1608f4b3987f..ab5603d5b62a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4669,9 +4669,82 @@ static const struct bpf_func_proto bpf_sock_ops_se=
tsockopt_proto =3D {
 	.arg5_type	=3D ARG_CONST_SIZE,
 };
=20
+static int bpf_sock_ops_get_syn(struct bpf_sock_ops_kern *bpf_sock,
+				int optname, const u8 **start)
+{
+	struct sk_buff *syn_skb =3D bpf_sock->syn_skb;
+	const u8 *hdr_start;
+	int ret;
+
+	if (syn_skb) {
+		/* sk is a request_sock here */
+
+		if (optname =3D=3D TCP_BPF_SYN) {
+			hdr_start =3D syn_skb->data;
+			ret =3D tcp_hdrlen(syn_skb);
+		} else {
+			/* optname =3D=3D TCP_BPF_SYN_IP */
+			hdr_start =3D skb_network_header(syn_skb);
+			ret =3D skb_network_header_len(syn_skb) +
+				tcp_hdrlen(syn_skb);
+		}
+	} else {
+		struct sock *sk =3D bpf_sock->sk;
+		struct saved_syn *saved_syn;
+
+		if (sk->sk_state =3D=3D TCP_NEW_SYN_RECV)
+			/* synack retransmit. bpf_sock->syn_skb will
+			 * not be available.  It has to resort to
+			 * saved_syn (if it is saved).
+			 */
+			saved_syn =3D inet_reqsk(sk)->saved_syn;
+		else
+			saved_syn =3D tcp_sk(sk)->saved_syn;
+
+		if (!saved_syn)
+			return -ENOENT;
+
+		if (optname =3D=3D TCP_BPF_SYN) {
+			hdr_start =3D saved_syn->data +
+				saved_syn->network_hdrlen;
+			ret =3D saved_syn->tcp_hdrlen;
+		} else {
+			/* optname =3D=3D TCP_BPF_SYN_IP */
+			hdr_start =3D saved_syn->data;
+			ret =3D saved_syn->network_hdrlen +
+				saved_syn->tcp_hdrlen;
+		}
+	}
+
+	*start =3D hdr_start;
+	return ret;
+}
+
 BPF_CALL_5(bpf_sock_ops_getsockopt, struct bpf_sock_ops_kern *, bpf_sock=
,
 	   int, level, int, optname, char *, optval, int, optlen)
 {
+	if (IS_ENABLED(CONFIG_INET) && level =3D=3D SOL_TCP &&
+	    optname >=3D TCP_BPF_SYN && optname <=3D TCP_BPF_SYN_IP) {
+		int ret, copy_len =3D 0;
+		const u8 *start;
+
+		ret =3D bpf_sock_ops_get_syn(bpf_sock, optname, &start);
+		if (ret > 0) {
+			copy_len =3D ret;
+			if (optlen < copy_len) {
+				copy_len =3D optlen;
+				ret =3D -ENOSPC;
+			}
+
+			memcpy(optval, start, copy_len);
+		}
+
+		/* Zero out unused buffer at the end */
+		memset(optval + copy_len, 0, optlen - copy_len);
+
+		return ret;
+	}
+
 	return _bpf_getsockopt(bpf_sock->sk, level, optname, optval, optlen);
 }
=20
@@ -6165,6 +6238,232 @@ static const struct bpf_func_proto bpf_sk_assign_=
proto =3D {
 	.arg3_type	=3D ARG_ANYTHING,
 };
=20
+static const u8 *bpf_search_tcp_opt(const u8 *op, const u8 *opend,
+				    u8 search_kind, const u8 *magic,
+				    u8 magic_len, bool *eol)
+{
+	u8 kind, kind_len;
+
+	*eol =3D false;
+
+	while (op < opend) {
+		kind =3D op[0];
+
+		if (kind =3D=3D TCPOPT_EOL) {
+			*eol =3D true;
+			return ERR_PTR(-ENOMSG);
+		} else if (kind =3D=3D TCPOPT_NOP) {
+			op++;
+			continue;
+		}
+
+		if (opend - op < 2 || opend - op < op[1] || op[1] < 2)
+			/* Something is wrong in the received header.
+			 * Follow the TCP stack's tcp_parse_options()
+			 * and just bail here.
+			 */
+			return ERR_PTR(-EFAULT);
+
+		kind_len =3D op[1];
+		if (search_kind =3D=3D kind) {
+			if (!magic_len)
+				return op;
+
+			if (magic_len > kind_len - 2)
+				return ERR_PTR(-ENOMSG);
+
+			if (!memcmp(&op[2], magic, magic_len))
+				return op;
+		}
+
+		op +=3D kind_len;
+	}
+
+	return ERR_PTR(-ENOMSG);
+}
+
+BPF_CALL_4(bpf_sock_ops_load_hdr_opt, struct bpf_sock_ops_kern *, bpf_so=
ck,
+	   void *, search_res, u32, len, u64, flags)
+{
+	bool eol, load_syn =3D flags & BPF_LOAD_HDR_OPT_TCP_SYN;
+	const u8 *op, *opend, *magic, *search =3D search_res;
+	u8 search_kind, search_len, copy_len, magic_len;
+	int ret;
+
+	/* 2 byte is the minimal option len except TCPOPT_NOP and
+	 * TCPOPT_EOL which are useless for the bpf prog to learn
+	 * and this helper disallow loading them also.
+	 */
+	if (len < 2 || flags & ~BPF_LOAD_HDR_OPT_TCP_SYN)
+		return -EINVAL;
+
+	search_kind =3D search[0];
+	search_len =3D search[1];
+
+	if (search_len > len || search_kind =3D=3D TCPOPT_NOP ||
+	    search_kind =3D=3D TCPOPT_EOL)
+		return -EINVAL;
+
+	if (search_kind =3D=3D TCPOPT_EXP || search_kind =3D=3D 253) {
+		/* 16 or 32 bit magic.  +2 for kind and kind length */
+		if (search_len !=3D 4 && search_len !=3D 6)
+			return -EINVAL;
+		magic =3D &search[2];
+		magic_len =3D search_len - 2;
+	} else {
+		if (search_len)
+			return -EINVAL;
+		magic =3D NULL;
+		magic_len =3D 0;
+	}
+
+	if (load_syn) {
+		ret =3D bpf_sock_ops_get_syn(bpf_sock, TCP_BPF_SYN, &op);
+		if (ret < 0)
+			return ret;
+
+		opend =3D op + ret;
+		op +=3D sizeof(struct tcphdr);
+	} else {
+		if (!bpf_sock->skb ||
+		    bpf_sock->op =3D=3D BPF_SOCK_OPS_HDR_OPT_LEN_CB)
+			/* This bpf_sock->op cannot call this helper */
+			return -EPERM;
+
+		opend =3D bpf_sock->skb_data_end;
+		op =3D bpf_sock->skb->data + sizeof(struct tcphdr);
+	}
+
+	op =3D bpf_search_tcp_opt(op, opend, search_kind, magic, magic_len,
+				&eol);
+	if (IS_ERR(op))
+		return PTR_ERR(op);
+
+	copy_len =3D op[1];
+	ret =3D copy_len;
+	if (copy_len > len) {
+		ret =3D -ENOSPC;
+		copy_len =3D len;
+	}
+
+	memcpy(search_res, op, copy_len);
+	return ret;
+}
+
+static const struct bpf_func_proto bpf_sock_ops_load_hdr_opt_proto =3D {
+	.func		=3D bpf_sock_ops_load_hdr_opt,
+	.gpl_only	=3D false,
+	.ret_type	=3D RET_INTEGER,
+	.arg1_type	=3D ARG_PTR_TO_CTX,
+	.arg2_type	=3D ARG_PTR_TO_MEM,
+	.arg3_type	=3D ARG_CONST_SIZE,
+	.arg4_type	=3D ARG_ANYTHING,
+};
+
+BPF_CALL_4(bpf_sock_ops_store_hdr_opt, struct bpf_sock_ops_kern *, bpf_s=
ock,
+	   const void *, from, u32, len, u64, flags)
+{
+	u8 new_kind, new_kind_len, magic_len =3D 0, *opend;
+	const u8 *op, *new_op, *magic =3D NULL;
+	struct sk_buff *skb;
+	bool eol;
+
+	if (bpf_sock->op !=3D BPF_SOCK_OPS_WRITE_HDR_OPT_CB)
+		return -EPERM;
+
+	if (len < 2 || flags)
+		return -EINVAL;
+
+	new_op =3D from;
+	new_kind =3D new_op[0];
+	new_kind_len =3D new_op[1];
+
+	if (new_kind_len > len || new_kind =3D=3D TCPOPT_NOP ||
+	    new_kind =3D=3D TCPOPT_EOL)
+		return -EINVAL;
+
+	if (new_kind_len > bpf_sock->remaining_opt_len)
+		return -ENOSPC;
+
+	/* 253 is another experimental kind */
+	if (new_kind =3D=3D TCPOPT_EXP || new_kind =3D=3D 253)  {
+		if (new_kind_len < 4)
+			return -EINVAL;
+		/* Match for the 2 byte magic also.
+		 * RFC 6994: the magic could be 2 or 4 bytes.
+		 * Hence, matching by 2 byte only is on the
+		 * conservative side but it is the right
+		 * thing to do for the 'search-for-duplication'
+		 * purpose.
+		 */
+		magic =3D &new_op[2];
+		magic_len =3D 2;
+	}
+
+	/* Check for duplication */
+	skb =3D bpf_sock->skb;
+	op =3D skb->data + sizeof(struct tcphdr);
+	opend =3D bpf_sock->skb_data_end;
+
+	op =3D bpf_search_tcp_opt(op, opend, new_kind, magic, magic_len,
+				&eol);
+	if (!IS_ERR(op))
+		return -EEXIST;
+
+	if (PTR_ERR(op) !=3D -ENOMSG)
+		return PTR_ERR(op);
+
+	if (eol)
+		/* The option has been ended.  Treat it as no more
+		 * header option can be written.
+		 */
+		return -ENOSPC;
+
+	/* No duplication found.  Store the header option. */
+	memcpy(opend, from, new_kind_len);
+
+	bpf_sock->remaining_opt_len -=3D new_kind_len;
+	bpf_sock->skb_data_end +=3D new_kind_len;
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
+	.arg2_type	=3D ARG_PTR_TO_MEM,
+	.arg3_type	=3D ARG_CONST_SIZE,
+	.arg4_type	=3D ARG_ANYTHING,
+};
+
+BPF_CALL_3(bpf_sock_ops_reserve_hdr_opt, struct bpf_sock_ops_kern *, bpf=
_sock,
+	   u32, len, u64, flags)
+{
+	if (bpf_sock->op !=3D BPF_SOCK_OPS_HDR_OPT_LEN_CB)
+		return -EPERM;
+
+	if (flags || len < 2)
+		return -EINVAL;
+
+	if (len > bpf_sock->remaining_opt_len)
+		return -ENOSPC;
+
+	bpf_sock->remaining_opt_len -=3D len;
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
 #endif /* CONFIG_INET */
=20
 bool bpf_helper_changes_pkt_data(void *func)
@@ -6193,6 +6492,9 @@ bool bpf_helper_changes_pkt_data(void *func)
 	    func =3D=3D bpf_lwt_seg6_store_bytes ||
 	    func =3D=3D bpf_lwt_seg6_adjust_srh ||
 	    func =3D=3D bpf_lwt_seg6_action ||
+#endif
+#ifdef CONFIG_INET
+	    func =3D=3D bpf_sock_ops_store_hdr_opt ||
 #endif
 	    func =3D=3D bpf_lwt_in_push_encap ||
 	    func =3D=3D bpf_lwt_xmit_push_encap)
@@ -6565,6 +6867,12 @@ sock_ops_func_proto(enum bpf_func_id func_id, cons=
t struct bpf_prog *prog)
 	case BPF_FUNC_sk_storage_delete:
 		return &bpf_sk_storage_delete_proto;
 #ifdef CONFIG_INET
+	case BPF_FUNC_load_hdr_opt:
+		return &bpf_sock_ops_load_hdr_opt_proto;
+	case BPF_FUNC_store_hdr_opt:
+		return &bpf_sock_ops_store_hdr_opt_proto;
+	case BPF_FUNC_reserve_hdr_opt:
+		return &bpf_sock_ops_reserve_hdr_opt_proto;
 	case BPF_FUNC_tcp_sock:
 		return &bpf_tcp_sock_proto;
 #endif /* CONFIG_INET */
@@ -7364,6 +7672,20 @@ static bool sock_ops_is_valid_access(int off, int =
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
+			bpf_ctx_record_field_size(info, size_default);
+			return bpf_ctx_narrow_access_ok(off, size,
+							size_default);
 		default:
 			if (size !=3D size_default)
 				return false;
@@ -8701,6 +9023,49 @@ static u32 sock_ops_convert_ctx_access(enum bpf_ac=
cess_type type,
 	case offsetof(struct bpf_sock_ops, sk):
 		SOCK_OPS_GET_SK();
 		break;
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
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 8c9da4b65dae..319cc7fd5117 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -146,6 +146,7 @@ static void bpf_skops_parse_hdr(struct sock *sk, stru=
ct sk_buff *skb)
 				       BPF_SOCK_OPS_PARSE_UNKNOWN_HDR_OPT_CB_FLAG);
 	bool parse_all_opt =3D BPF_SOCK_OPS_TEST_FLAG(tcp_sk(sk),
 						    BPF_SOCK_OPS_PARSE_ALL_HDR_OPT_CB_FLAG);
+	struct bpf_sock_ops_kern sock_ops;
=20
 	if (likely(!unknown_opt && !parse_all_opt))
 		return;
@@ -161,12 +162,15 @@ static void bpf_skops_parse_hdr(struct sock *sk, st=
ruct sk_buff *skb)
 		return;
 	}
=20
-	/* BPF prog will have access to the sk and skb.
-	 *
-	 * The bpf running context preparation and the actual bpf prog
-	 * calling will be implemented in a later PATCH together with
-	 * other bpf pieces.
-	 */
+	sock_owned_by_me(sk);
+
+	memset(&sock_ops, 0, offsetof(struct bpf_sock_ops_kern, temp));
+	sock_ops.op =3D BPF_SOCK_OPS_PARSE_HDR_OPT_CB;
+	sock_ops.is_fullsock =3D 1;
+	sock_ops.sk =3D sk;
+	bpf_skops_init_skb(&sock_ops, skb, tcp_hdrlen(skb));
+
+	BPF_CGROUP_RUN_PROG_SOCK_OPS(&sock_ops);
 }
=20
 static void bpf_skops_established(struct sock *sk, int bpf_op,
@@ -180,7 +184,9 @@ static void bpf_skops_established(struct sock *sk, in=
t bpf_op,
 	sock_ops.op =3D bpf_op;
 	sock_ops.is_fullsock =3D 1;
 	sock_ops.sk =3D sk;
-	/* skb will be passed to the bpf prog in a later patch. */
+	/* sk with TCP_REPAIR_ON does not have skb in tcp_finish_connect */
+	if (skb)
+		bpf_skops_init_skb(&sock_ops, skb, tcp_hdrlen(skb));
=20
 	BPF_CGROUP_RUN_PROG_SOCK_OPS(&sock_ops);
 }
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
index 673db6879e46..ab79d36ed07f 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -454,6 +454,18 @@ static void mptcp_options_write(__be32 *ptr, struct =
tcp_out_options *opts)
 }
=20
 #ifdef CONFIG_CGROUP_BPF
+static int bpf_skops_write_hdr_opt_arg0(struct sk_buff *skb,
+					enum tcp_synack_type synack_type)
+{
+	if (unlikely(!skb))
+		return BPF_WRITE_HDR_TCP_CURRENT_MSS;
+
+	if (unlikely(synack_type =3D=3D TCP_SYNACK_COOKIE))
+		return BPF_WRITE_HDR_TCP_SYNACK_COOKIE;
+
+	return 0;
+}
+
 /* req, syn_skb and synack_type are used when writing synack */
 static void bpf_skops_hdr_opt_len(struct sock *sk, struct sk_buff *skb,
 				  struct request_sock *req,
@@ -462,15 +474,60 @@ static void bpf_skops_hdr_opt_len(struct sock *sk, =
struct sk_buff *skb,
 				  struct tcp_out_options *opts,
 				  unsigned int *remaining)
 {
+	struct bpf_sock_ops_kern sock_ops;
+	int err;
+
 	if (likely(!BPF_SOCK_OPS_TEST_FLAG(tcp_sk(sk),
 					   BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG)) ||
 	    !*remaining)
 		return;
=20
-	/* The bpf running context preparation and the actual bpf prog
-	 * calling will be implemented in a later PATCH together with
-	 * other bpf pieces.
-	 */
+	/* *remaining has already been aligned to 4 bytes, so *remaining >=3D 4=
 */
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
+		 * a fullsock "child" sk.  It is to keep the behavior
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
+	sock_ops.args[0] =3D bpf_skops_write_hdr_opt_arg0(skb, synack_type);
+	sock_ops.remaining_opt_len =3D *remaining;
+	/* tcp_current_mss() does not pass a skb */
+	if (skb)
+		bpf_skops_init_skb(&sock_ops, skb, 0);
+
+	err =3D BPF_CGROUP_RUN_PROG_SOCK_OPS_SK(&sock_ops, sk);
+
+	if (err || sock_ops.remaining_opt_len =3D=3D *remaining)
+		return;
+
+	opts->bpf_opt_len =3D *remaining - sock_ops.remaining_opt_len;
+	/* round up to 4 bytes */
+	opts->bpf_opt_len =3D (opts->bpf_opt_len + 3) & ~3;
+
+	*remaining -=3D opts->bpf_opt_len;
 }
=20
 static void bpf_skops_write_hdr_opt(struct sock *sk, struct sk_buff *skb=
,
@@ -479,13 +536,42 @@ static void bpf_skops_write_hdr_opt(struct sock *sk=
, struct sk_buff *skb,
 				    enum tcp_synack_type synack_type,
 				    struct tcp_out_options *opts)
 {
-	if (likely(!opts->bpf_opt_len))
+	u8 first_opt_off, nr_written, max_opt_len =3D opts->bpf_opt_len;
+	struct bpf_sock_ops_kern sock_ops;
+	int err;
+
+	if (likely(!max_opt_len))
 		return;
=20
-	/* The bpf running context preparation and the actual bpf prog
-	 * calling will be implemented in a later PATCH together with
-	 * other bpf pieces.
-	 */
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
+	sock_ops.args[0] =3D bpf_skops_write_hdr_opt_arg0(skb, synack_type);
+	sock_ops.remaining_opt_len =3D max_opt_len;
+	first_opt_off =3D tcp_hdrlen(skb) - max_opt_len;
+	bpf_skops_init_skb(&sock_ops, skb, first_opt_off);
+
+	err =3D BPF_CGROUP_RUN_PROG_SOCK_OPS_SK(&sock_ops, sk);
+
+	if (err)
+		nr_written =3D 0;
+	else
+		nr_written =3D max_opt_len - sock_ops.remaining_opt_len;
+
+	if (nr_written < max_opt_len)
+		memset(skb->data + first_opt_off + nr_written, TCPOPT_NOP,
+		       max_opt_len - nr_written);
 }
 #else
 static void bpf_skops_hdr_opt_len(struct sock *sk, struct sk_buff *skb,
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 6770d00d5781..277b145bf7c3 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3395,6 +3395,120 @@ union bpf_attr {
  *		A non-negative value equal to or less than *size* on success,
  *		or a negative error in case of failure.
  *
+ * long bpf_load_hdr_opt(struct bpf_sock_ops *skops, void *searchby_res,=
 u32 len, u64 flags)
+ *	Description
+ *		Load header option.  Support reading a particular TCP header
+ *		option for bpf program (BPF_PROG_TYPE_SOCK_OPS).
+ *
+ *		If *flags* is 0, it will search the option from the
+ *		sock_ops->skb_data.  The comment in "struct bpf_sock_ops"
+ *		has details on what skb_data contains under different
+ *		sock_ops->op.
+ *
+ *		The first byte of the *searchby_res* specifies the
+ *		kind that it wants to search.
+ *
+ *		If the searching kind is an experimental kind
+ *		(i.e. 253 or 254 according to RFC6994).  It also
+ *		needs to specify the "magic" which is either
+ *		2 bytes or 4 bytes.  It then also needs to
+ *		specify the size of the magic by using
+ *		the 2nd byte which is "kind-length" of a TCP
+ *		header option and the "kind-length" also
+ *		includes the first 2 bytes "kind" and "kind-length"
+ *		itself as a normal TCP header option also does.
+ *
+ *		For example, to search experimental kind 254 with
+ *		2 byte magic 0xeB9F, the searchby_res should be
+ *		[ 254, 4, 0xeB, 0x9F, 0, 0, .... 0 ].
+ *
+ *		To search for the standard window scale option (3),
+ *		the searchby_res should be [ 3, 0, 0, .... 0 ].
+ *		Note, kind-length must be 0 for regular option.
+ *
+ *		Searching for No-Op (0) and End-of-Option-List (1) are
+ *		not supported.
+ *
+ *		*len* must be at least 2 bytes which is the minimal size
+ *		of a header option.
+ *
+ *		Supported flags:
+ *		* **BPF_LOAD_HDR_OPT_TCP_SYN** to search from the
+ *		  saved_syn packet or the just-received syn packet.
+ *
+ *	Return
+ *		>0 when found, the header option is copied to *searchby_res*.
+ *		The return value is the total length copied.
+ *
+ *		**-EINVAL** If param is invalid
+ *
+ *		**-ENOMSG** The option is not found
+ *
+ *		**-ENOENT** No syn packet available when
+ *			    **BPF_LOAD_HDR_OPT_TCP_SYN** is used
+ *
+ *		**-ENOSPC** Not enough space.  Only *len* number of
+ *			    bytes are copied.
+ *
+ *		**-EFAULT** Cannot parse the header options in the packet
+ *
+ *		**-EPERM** This helper cannot be used under the
+ *			   current sock_ops->op.
+ *
+ * long bpf_store_hdr_opt(struct bpf_sock_ops *skops, const void *from, =
u32 len, u64 flags)
+ *	Description
+ *		Store header option.  The data will be copied
+ *		from buffer *from* with length *len* to the TCP header.
+ *
+ *		The buffer *from* should have the whole option that
+ *		includes the kind, kind-length, and the actual
+ *		option data.  The *len* must be at least kind-length
+ *		long.  The kind-length does not have to be 4 byte
+ *		aligned.  The kernel will take care of the padding
+ *		and setting the 4 bytes aligned value to th->doff.
+ *
+ *		This helper will check for duplicated option
+ *		by searching the same option in the outgoing skb.
+ *
+ *		This helper can only be called during
+ *		BPF_SOCK_OPS_WRITE_HDR_OPT_CB.
+ *
+ *	Return
+ *		0 on success, or negative error in case of failure:
+ *
+ *		**-EINVAL** If param is invalid
+ *
+ *		**-ENOSPC** Not enough space in the header.
+ *			    Nothing has been written
+ *
+ *		**-EEXIST** The option has already existed
+ *
+ *		**-EFAULT** Cannot parse the existing header options
+ *
+ *		**-EPERM** This helper cannot be used under the
+ *			   current sock_ops->op.
+ *
+ * long bpf_reserve_hdr_opt(struct bpf_sock_ops *skops, u32 len, u64 fla=
gs)
+ *	Description
+ *		Reserve *len* bytes for the bpf header option.  The
+ *		space will be used by bpf_store_hdr_opt() later in
+ *		BPF_SOCK_OPS_WRITE_HDR_OPT_CB.
+ *
+ *		If bpf_reserve_hdr_opt() is called multiple times,
+ *		the total number of bytes will be reserved.
+ *
+ *		This helper can only be called during
+ *		BPF_SOCK_OPS_HDR_OPT_LEN_CB.
+ *
+ *	Return
+ *		0 on success, or negative error in case of failure:
+ *
+ *		**-EINVAL** if param is invalid
+ *
+ *		**-ENOSPC** Not enough space in the header.
+ *
+ *		**-EPERM** This helper cannot be used under the
+ *			   current sock_ops->op.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3539,6 +3653,9 @@ union bpf_attr {
 	FN(skc_to_tcp_request_sock),	\
 	FN(skc_to_udp6_sock),		\
 	FN(get_task_stack),		\
+	FN(load_hdr_opt),		\
+	FN(store_hdr_opt),		\
+	FN(reserve_hdr_opt),
 	/* */
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
@@ -4158,6 +4275,36 @@ struct bpf_sock_ops {
 	__u64 bytes_received;
 	__u64 bytes_acked;
 	__bpf_md_ptr(struct bpf_sock *, sk);
+	/* [skb_data, skb_data_end) covers the whole TCP header.
+	 *
+	 * BPF_SOCK_OPS_PARSE_HDR_OPT_CB: The packet received
+	 * BPF_SOCK_OPS_HDR_OPT_LEN_CB:   Not useful because the
+	 *                                header has not been written.
+	 * BPF_SOCK_OPS_WRITE_HDR_OPT_CB: The header and options have
+	 *				  been written so far.
+	 * BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB:  The SYNACK that concludes
+	 *					the 3WHS.
+	 * BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB: The ACK that concludes
+	 *					the 3WHS.
+	 *
+	 * bpf_load_hdr_opt() can also be used to read a particular option.
+	 */
+	__bpf_md_ptr(void *, skb_data);
+	__bpf_md_ptr(void *, skb_data_end);
+	__u32 skb_len;		/* The total length of a packet.
+				 * It includes the header, options,
+				 * and payload.
+				 */
+	__u32 skb_tcp_flags;	/* tcp_flags of the header.  It provides
+				 * an easy way to check for tcp_flags
+				 * without parsing skb_data.
+				 *
+				 * In particular, the skb_tcp_flags
+				 * will still be available in
+				 * BPF_SOCK_OPS_HDR_OPT_LEN even though
+				 * the outgoing header has not
+				 * been written yet.
+				 */
 };
=20
 /* Definitions for bpf_sock_ops_cb_flags */
@@ -4166,8 +4313,48 @@ enum {
 	BPF_SOCK_OPS_RETRANS_CB_FLAG	=3D (1<<1),
 	BPF_SOCK_OPS_STATE_CB_FLAG	=3D (1<<2),
 	BPF_SOCK_OPS_RTT_CB_FLAG	=3D (1<<3),
-	BPF_SOCK_OPS_PARSE_ALL_HDR_OPT_CB_FLAG  =3D (1<<4),
+	/* Call bpf for all received TCP headers.  The bpf prog will be
+	 * called under sock_ops->op =3D=3D BPF_SOCK_OPS_PARSE_HDR_OPT_CB
+	 *
+	 * Please refer to the comment in BPF_SOCK_OPS_PARSE_HDR_OPT_CB
+	 * for the header option related helpers that will be useful
+	 * to the bpf programs.
+	 *
+	 * It could be used at the client/active side (i.e. connect() side)
+	 * when the server told it that the server was in syncookie
+	 * mode and required the active side to resend the bpf-written
+	 * options.  The active side can keep writing the bpf-options until
+	 * it received a valid packet from the server side to confirm
+	 * the earlier packet (and options) has been received.  The later
+	 * example patch is using it like this at the active side when the
+	 * server is in syncookie mode.
+	 *
+	 * The bpf prog will usually turn this off in the common cases.
+	 */
+	BPF_SOCK_OPS_PARSE_ALL_HDR_OPT_CB_FLAG	=3D (1<<4),
+	/* Call bpf when kernel has received a header option that
+	 * the kernel cannot handle.  The bpf prog will be called under
+	 * sock_ops->op =3D=3D BPF_SOCK_OPS_PARSE_HDR_OPT_CB.
+	 *
+	 * Please refer to the comment in BPF_SOCK_OPS_PARSE_HDR_OPT_CB
+	 * for the header option related helpers that will be useful
+	 * to the bpf programs.
+	 */
 	BPF_SOCK_OPS_PARSE_UNKNOWN_HDR_OPT_CB_FLAG =3D (1<<5),
+	/* Call bpf when the kernel is writing header options for the
+	 * outgoing packet.  The bpf prog will first be called
+	 * to reserve space in a skb under
+	 * sock_ops->op =3D=3D BPF_SOCK_OPS_HDR_OPT_LEN_CB.  Then
+	 * the bpf prog will be called to write the header option(s)
+	 * under sock_ops->op =3D=3D BPF_SOCK_OPS_WRITE_HDR_OPT_CB.
+	 *
+	 * Please refer to the comment in BPF_SOCK_OPS_HDR_OPT_LEN_CB
+	 * and BPF_SOCK_OPS_WRITE_HDR_OPT_CB for the header option
+	 * related helpers that will be useful to the bpf programs.
+	 *
+	 * The kernel gets its chance to reserve space and write
+	 * options first before the BPF program does.
+	 */
 	BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG =3D (1<<6),
 /* Mask of all currently supported cb flags */
 	BPF_SOCK_OPS_ALL_CB_FLAGS       =3D 0x7F,
@@ -4226,6 +4413,63 @@ enum {
 					 */
 	BPF_SOCK_OPS_RTT_CB,		/* Called on every RTT.
 					 */
+	BPF_SOCK_OPS_PARSE_HDR_OPT_CB,	/* Parse the header option.
+					 * It will be called to handle
+					 * the packets received at
+					 * an already established
+					 * connection.
+					 *
+					 * sock_ops->skb_data:
+					 * Referring to the received skb.
+					 * It covers the TCP header only.
+					 *
+					 * bpf_load_hdr_opt() can also
+					 * be used to search for a
+					 * particular option.
+					 */
+	BPF_SOCK_OPS_HDR_OPT_LEN_CB,	/* Reserve space for writing the
+					 * header option later in
+					 * BPF_SOCK_OPS_WRITE_HDR_OPT_CB.
+					 * Arg1: bool want_cookie. (in
+					 *       writing SYNACK only)
+					 *
+					 * sock_ops->skb_data:
+					 * Not available because no header has
+					 * been	written yet.
+					 *
+					 * sock_ops->skb_tcp_flags:
+					 * The tcp_flags of the
+					 * outgoing skb. (e.g. SYN, ACK, FIN).
+					 *
+					 * bpf_reserve_hdr_opt() should
+					 * be used to reserve space.
+					 */
+	BPF_SOCK_OPS_WRITE_HDR_OPT_CB,	/* Write the header options
+					 * Arg1: bool want_cookie. (in
+					 *       writing SYNACK only)
+					 *
+					 * sock_ops->skb_data:
+					 * Referring to the outgoing skb.
+					 * It covers the TCP header
+					 * that has already been written
+					 * by the kernel and the
+					 * earlier bpf-progs.
+					 *
+					 * sock_ops->skb_tcp_flags:
+					 * The tcp_flags of the outgoing
+					 * skb. (e.g. SYN, ACK, FIN).
+					 *
+					 * bpf_store_hdr_opt() should
+					 * be used to write the
+					 * option.
+					 *
+					 * bpf_load_hdr_opt() can also
+					 * be used to search for a
+					 * particular option that
+					 * has already been written
+					 * by the kernel or the
+					 * earlier bpf-progs.
+					 */
 };
=20
 /* List of TCP states. There is a build check in net/ipv4/tcp.c to detec=
t
@@ -4255,6 +4499,60 @@ enum {
 	TCP_BPF_SNDCWND_CLAMP	=3D 1002,	/* Set sndcwnd_clamp */
 	TCP_BPF_DELACK_MAX	=3D 1003, /* Max delay ack in usecs */
 	TCP_BPF_RTO_MIN		=3D 1004, /* Min delay ack in usecs */
+	/* Copy the SYN pkt to optval
+	 *
+	 * BPF_PROG_TYPE_SOCK_OPS only.  It is similar to the
+	 * bpf_getsockopt(TCP_SAVED_SYN) but it does not limit
+	 * to only getting from the saved_syn.  It can either get the
+	 * syn packet from:
+	 *
+	 * 1. the just-received SYN packet (only available when writing the
+	 *    SYNACK).  It will be useful when it is not necessary to
+	 *    save the SYN packet for latter use.  It is also the only way
+	 *    to get the SYN during syncookie mode because the syn
+	 *    packet cannot be saved during syncookie.
+	 *
+	 * OR
+	 *
+	 * 2. the earlier saved syn which was done by
+	 *    bpf_setsockopt(TCP_SAVE_SYN).
+	 *
+	 * The bpf_getsockopt(TCP_BPF_SYN*) option will hide where the
+	 * SYN packet is obtained.
+	 *
+	 * If the bpf-prog does not need the IP[46] header,  the
+	 * bpf-prog can avoid parsing the IP header by using
+	 * TCP_BPF_SYN.  Otherwise, the bpf-prog can get both
+	 * IP[46] and TCP header by using TCP_BPF_SYN_IP.
+	 *
+	 *      >0: Total number of bytes copied
+	 * -ENOSPC: Not enough space in optval. Only optlen number of
+	 *          bytes is copied.
+	 * -ENOENT: The SYN skb is not available now and the earlier SYN pkt
+	 *	    is not saved by setsockopt(TCP_SAVE_SYN).
+	 */
+	TCP_BPF_SYN		=3D 1005, /* Copy the TCP header */
+	TCP_BPF_SYN_IP		=3D 1006, /* Copy the IP[46] and TCP header */
+};
+
+enum {
+	BPF_LOAD_HDR_OPT_TCP_SYN =3D (1ULL << 0),
+};
+
+/* args[0] value during BPF_SOCK_OPS_HDR_OPT_LEN_CB and
+ * BPF_SOCK_OPS_WRITE_HDR_OPT_CB.
+ */
+enum {
+	BPF_WRITE_HDR_TCP_CURRENT_MSS =3D 1,	/* Kernel is finding the
+						 * total option spaces
+						 * required for an established
+						 * sk in order to calculate the
+						 * MSS.  No skb is actually
+						 * sent.
+						 */
+	BPF_WRITE_HDR_TCP_SYNACK_COOKIE =3D 2,	/* Kernel is in syncookie mode
+						 * when sending a SYN.
+						 */
 };
=20
 struct bpf_perf_event_value {
--=20
2.24.1

