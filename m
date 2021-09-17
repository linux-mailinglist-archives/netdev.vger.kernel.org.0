Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8FC84101C7
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 01:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245065AbhIQXfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 19:35:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:37385 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237255AbhIQXey (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 19:34:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10110"; a="210130348"
X-IronPort-AV: E=Sophos;i="5.85,302,1624345200"; 
   d="scan'208";a="210130348"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 16:33:30 -0700
X-IronPort-AV: E=Sophos;i="5.85,302,1624345200"; 
   d="scan'208";a="483228559"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.205.24])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 16:33:30 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/5] mptcp: add MPTCP_TCPINFO getsockopt support
Date:   Fri, 17 Sep 2021 16:33:20 -0700
Message-Id: <20210917233322.271789-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210917233322.271789-1-mathew.j.martineau@linux.intel.com>
References: <20210917233322.271789-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Allow users to retrieve TCP_INFO data of all subflows.

Users need to pre-initialize a meta header that has to be
prepended to the data buffer that will be filled with the tcp info data.

The meta header looks like this:

struct mptcp_subflow_data {
 __u32 size_subflow_data;/* size of this structure in userspace */
 __u32 num_subflows;	/* must be 0, set by kernel */
 __u32 size_kernel;	/* must be 0, set by kernel */
 __u32 size_user;	/* size of one element in data[] */
} __attribute__((aligned(8)));

size_subflow_data has to be set to 'sizeof(struct mptcp_subflow_data)'.
This allows to extend mptcp_subflow_data structure later on without
breaking backwards compatibility.

If the structure is extended later on, kernel knows where the
userspace-provided meta header ends, even if userspace uses an older
(smaller) version of the structure.

num_subflows must be set to 0. If the getsockopt request succeeds (return
value is 0), it will be updated to contain the number of active subflows
for the given logical connection.

size_kernel must be set to 0. If the getsockopt request is successful,
it will contain the size of the 'struct tcp_info' as known by the kernel.
This is informational only.

size_user must be set to 'sizeof(struct tcp_info)'.

This allows the kernel to only fill in the space reserved/expected by
userspace.

Example:

struct my_tcp_info {
  struct mptcp_subflow_data d;
  struct tcp_info ti[2];
};
struct my_tcp_info ti;
socklen_t olen;

memset(&ti, 0, sizeof(ti));

ti.d.size_subflow_data = sizeof(struct mptcp_subflow_data);
ti.d.size_user = sizeof(struct tcp_info);
olen = sizeof(ti);

ret = getsockopt(fd, SOL_MPTCP, MPTCP_TCPINFO, &ti, &olen);
if (ret < 0)
	die_perror("getsockopt MPTCP_TCPINFO");

mptcp_subflow_data.num_subflows is populated with the number of
subflows that exist on the kernel side for the logical mptcp connection.

This allows userspace to re-try with a larger tcp_info array if the number
of subflows was larger than the available space in the ti[] array.

olen has to be set to the number of bytes that userspace has allocated to
receive the kernel data.  It will be updated to contain the real number
bytes that have been copied to by the kernel.

In the above example, if the number if subflows was 1, olen is equal to
'sizeof(struct mptcp_subflow_data) + sizeof(struct tcp_info).
For 2 or more subflows olen is equal to 'sizeof(struct my_tcp_info)'.

If there was more data that could not be copied due to lack of space
in the option buffer, userspace can detect this by checking
mptcp_subflow_data->num_subflows.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/uapi/linux/mptcp.h |  10 +++-
 net/mptcp/sockopt.c        | 115 +++++++++++++++++++++++++++++++++++++
 2 files changed, 124 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/mptcp.h b/include/uapi/linux/mptcp.h
index 3e9caeddda7e..3f013a513770 100644
--- a/include/uapi/linux/mptcp.h
+++ b/include/uapi/linux/mptcp.h
@@ -193,7 +193,15 @@ enum mptcp_event_attr {
 #define MPTCP_RST_EBADPERF	5
 #define MPTCP_RST_EMIDDLEBOX	6
 
+struct mptcp_subflow_data {
+	__u32		size_subflow_data;		/* size of this structure in userspace */
+	__u32		num_subflows;			/* must be 0, set by kernel */
+	__u32		size_kernel;			/* must be 0, set by kernel */
+	__u32		size_user;			/* size of one element in data[] */
+} __attribute__((aligned(8)));
+
 /* MPTCP socket options */
-#define MPTCP_INFO 1
+#define MPTCP_INFO		1
+#define MPTCP_TCPINFO		2
 
 #endif /* _UAPI_MPTCP_H */
diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index f7683c22911f..eb2905bfa089 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -14,6 +14,8 @@
 #include <net/mptcp.h>
 #include "protocol.h"
 
+#define MIN_INFO_OPTLEN_SIZE	16
+
 static struct sock *__mptcp_tcp_fallback(struct mptcp_sock *msk)
 {
 	sock_owned_by_me((const struct sock *)msk);
@@ -727,6 +729,117 @@ static int mptcp_getsockopt_info(struct mptcp_sock *msk, char __user *optval, in
 	return 0;
 }
 
+static int mptcp_put_subflow_data(struct mptcp_subflow_data *sfd,
+				  char __user *optval,
+				  u32 copied,
+				  int __user *optlen)
+{
+	u32 copylen = min_t(u32, sfd->size_subflow_data, sizeof(*sfd));
+
+	if (copied)
+		copied += sfd->size_subflow_data;
+	else
+		copied = copylen;
+
+	if (put_user(copied, optlen))
+		return -EFAULT;
+
+	if (copy_to_user(optval, sfd, copylen))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int mptcp_get_subflow_data(struct mptcp_subflow_data *sfd,
+				  char __user *optval, int __user *optlen)
+{
+	int len, copylen;
+
+	if (get_user(len, optlen))
+		return -EFAULT;
+
+	/* if mptcp_subflow_data size is changed, need to adjust
+	 * this function to deal with programs using old version.
+	 */
+	BUILD_BUG_ON(sizeof(*sfd) != MIN_INFO_OPTLEN_SIZE);
+
+	if (len < MIN_INFO_OPTLEN_SIZE)
+		return -EINVAL;
+
+	memset(sfd, 0, sizeof(*sfd));
+
+	copylen = min_t(unsigned int, len, sizeof(*sfd));
+	if (copy_from_user(sfd, optval, copylen))
+		return -EFAULT;
+
+	/* size_subflow_data is u32, but len is signed */
+	if (sfd->size_subflow_data > INT_MAX ||
+	    sfd->size_user > INT_MAX)
+		return -EINVAL;
+
+	if (sfd->size_subflow_data < MIN_INFO_OPTLEN_SIZE ||
+	    sfd->size_subflow_data > len)
+		return -EINVAL;
+
+	if (sfd->num_subflows || sfd->size_kernel)
+		return -EINVAL;
+
+	return len - sfd->size_subflow_data;
+}
+
+static int mptcp_getsockopt_tcpinfo(struct mptcp_sock *msk, char __user *optval,
+				    int __user *optlen)
+{
+	struct mptcp_subflow_context *subflow;
+	struct sock *sk = &msk->sk.icsk_inet.sk;
+	unsigned int sfcount = 0, copied = 0;
+	struct mptcp_subflow_data sfd;
+	char __user *infoptr;
+	int len;
+
+	len = mptcp_get_subflow_data(&sfd, optval, optlen);
+	if (len < 0)
+		return len;
+
+	sfd.size_kernel = sizeof(struct tcp_info);
+	sfd.size_user = min_t(unsigned int, sfd.size_user,
+			      sizeof(struct tcp_info));
+
+	infoptr = optval + sfd.size_subflow_data;
+
+	lock_sock(sk);
+
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+
+		++sfcount;
+
+		if (len && len >= sfd.size_user) {
+			struct tcp_info info;
+
+			tcp_get_info(ssk, &info);
+
+			if (copy_to_user(infoptr, &info, sfd.size_user)) {
+				release_sock(sk);
+				return -EFAULT;
+			}
+
+			infoptr += sfd.size_user;
+			copied += sfd.size_user;
+			len -= sfd.size_user;
+		}
+	}
+
+	release_sock(sk);
+
+	sfd.num_subflows = sfcount;
+
+	if (mptcp_put_subflow_data(&sfd, optval, copied, optlen))
+		return -EFAULT;
+
+	return 0;
+}
+
 static int mptcp_getsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 				    char __user *optval, int __user *optlen)
 {
@@ -747,6 +860,8 @@ static int mptcp_getsockopt_sol_mptcp(struct mptcp_sock *msk, int optname,
 	switch (optname) {
 	case MPTCP_INFO:
 		return mptcp_getsockopt_info(msk, optval, optlen);
+	case MPTCP_TCPINFO:
+		return mptcp_getsockopt_tcpinfo(msk, optval, optlen);
 	}
 
 	return -EOPNOTSUPP;
-- 
2.33.0

