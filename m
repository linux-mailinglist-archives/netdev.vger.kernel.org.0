Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05426EDEC0
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 11:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbjDYJIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 05:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbjDYJIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 05:08:40 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30AF10CE
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 02:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682413718; x=1713949718;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y5acF7eHUZbdBZif0FfnW3J6JP48plKAQ3gAe+3+ONI=;
  b=eTXVt142k13PtU07lKxSTJ9wtd84Kgq/2U29XIHYW/qoF8XUIw/6mOF4
   Tl6Hsz+yE65axUQ7aqwUqbMcXHhyfBFB7ikCKrLleS7DRDw51PfS2j48c
   1+JKr+a6D/YSg3oP3sY7jbkGaKPWzzIwhokHGetD8Xp4hC5Dz7nNMVNnq
   kUaKbrSF8mdaqr9VZmaNfKLuRfEy88YgANtAd6BCliACrle+hFjzliCHP
   QBfCaPUbdwIA7+fgLyNXZEuLYgmZuzFfMdQgkAURX+funVwKSxhtOoEOw
   f6SHqsVH9PX594yryAolu2ajWq9Ha2Cg6x2dGCPQ5dL14lf71Q//2nsfB
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="345460572"
X-IronPort-AV: E=Sophos;i="5.99,225,1677571200"; 
   d="scan'208";a="345460572"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 02:08:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="758030999"
X-IronPort-AV: E=Sophos;i="5.99,225,1677571200"; 
   d="scan'208";a="758030999"
Received: from gkomc17.igk.intel.com ([10.88.115.23])
  by fmsmga008.fm.intel.com with ESMTP; 25 Apr 2023 02:08:37 -0700
From:   Krzysztof Richert <krzysztof.richert@intel.com>
To:     jk@codeconstruct.com.au, matt@codeconstruct.com.au
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        krzysztof.richert@intel.com
Subject: [RFC PATCH v1 1/1] net: mctp: MCTP VDM extension
Date:   Tue, 25 Apr 2023 11:07:48 +0200
Message-Id: <20230425090748.2380222-2-krzysztof.richert@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230425090748.2380222-1-krzysztof.richert@intel.com>
References: <20230425090748.2380222-1-krzysztof.richert@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expand mctp subsystem to support vendor specific message.

Signed-off-by: Krzysztof Richert <krzysztof.richert@intel.com>
---
 include/net/mctp.h        |  24 ++++++++
 include/uapi/linux/mctp.h |  23 ++++++++
 net/mctp/af_mctp.c        | 114 +++++++++++++++++++++++++++++++++++++-
 net/mctp/route.c          |   9 +++
 4 files changed, 169 insertions(+), 1 deletion(-)

diff --git a/include/net/mctp.h b/include/net/mctp.h
index b18fc977330b..eb4f8e346e77 100644
--- a/include/net/mctp.h
+++ b/include/net/mctp.h
@@ -12,6 +12,7 @@
 #include <linux/bits.h>
 #include <linux/mctp.h>
 #include <linux/netdevice.h>
+#include <linux/pci_ids.h>
 #include <net/net_namespace.h>
 #include <net/sock.h>
 
@@ -63,6 +64,21 @@ static inline struct mctp_hdr *mctp_hdr(struct sk_buff *skb)
 	return (struct mctp_hdr *)skb_network_header(skb);
 }
 
+static inline bool mctp_vdm(u8 type)
+{
+	return (type == 0x7e || type == 0x7f);
+}
+
+static inline bool mctp_pci_vdm(u8 type)
+{
+	return (type == 0x7e);
+}
+
+static inline bool mctp_iana_vdm(u8 type)
+{
+	return (type == 0x7f);
+}
+
 /* socket implementation */
 struct mctp_sock {
 	struct sock	sk;
@@ -71,10 +87,14 @@ struct mctp_sock {
 	unsigned int	bind_net;
 	mctp_eid_t	bind_addr;
 	__u8		bind_type;
+	u8		bind_vendor_type;
 
 	/* sendmsg()/recvmsg() uses struct sockaddr_mctp_ext */
 	bool		addr_ext;
 
+	/* sendmsg()/recvmsg() uses struct sockaddr_mctp_vendor_ext */
+	bool		vendor_specific_ext;
+
 	/* list of mctp_sk_key, for incoming tag lookup. updates protected
 	 * by sk->net->keys_lock
 	 */
@@ -290,6 +310,10 @@ int mctp_neigh_lookup(struct mctp_dev *dev, mctp_eid_t eid,
 		      void *ret_hwaddr);
 void mctp_neigh_remove_dev(struct mctp_dev *mdev);
 
+int mctp_vendor_define_message_decode(struct sk_buff *skb, u8 type,
+				      struct mctp_vdm_data *vdm_data,
+				      u8 *vendorlen);
+
 int mctp_routes_init(void);
 void mctp_routes_exit(void);
 
diff --git a/include/uapi/linux/mctp.h b/include/uapi/linux/mctp.h
index 154ab56651f1..64431a07053d 100644
--- a/include/uapi/linux/mctp.h
+++ b/include/uapi/linux/mctp.h
@@ -19,6 +19,23 @@ struct mctp_addr {
 	mctp_eid_t		s_addr;
 };
 
+union mctp_vendor_id {
+	struct {
+		__u32		resvd	: 16,
+				data	: 16;
+	} pci_vendor_id;
+
+	struct {
+		__u32		data;
+	} iana_number;
+};
+
+struct mctp_vdm_data {
+	union mctp_vendor_id		smctp_vendor;
+	__u32		__smctp_pad0;
+	__u64		smctp_sub_type;
+};
+
 struct sockaddr_mctp {
 	__kernel_sa_family_t	smctp_family;
 	__u16			__smctp_pad0;
@@ -37,6 +54,11 @@ struct sockaddr_mctp_ext {
 	__u8			smctp_haddr[MAX_ADDR_LEN];
 };
 
+struct sockaddr_mctp_vendor_ext {
+	struct sockaddr_mctp_ext	smctp_ext;
+	struct mctp_vdm_data		smctp_vdm_data;
+};
+
 #define MCTP_NET_ANY		0x0
 
 #define MCTP_ADDR_NULL		0x00
@@ -47,6 +69,7 @@ struct sockaddr_mctp_ext {
 #define MCTP_TAG_PREALLOC	0x10
 
 #define MCTP_OPT_ADDR_EXT	1
+#define MCTP_OPT_VENDOR_EXT	2
 
 #define SIOCMCTPALLOCTAG	(SIOCPROTOPRIVATE + 0)
 #define SIOCMCTPDROPTAG		(SIOCPROTOPRIVATE + 1)
diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index e22b0cbb2f35..b85e5dcbb2d3 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -49,11 +49,66 @@ static bool mctp_sockaddr_ext_is_ok(const struct sockaddr_mctp_ext *addr)
 	       !addr->__smctp_pad0[2];
 }
 
+static bool mctp_sockaddr_vendor_ext_is_ok(const struct sockaddr_mctp_vendor_ext *addr)
+{
+	return !addr->smctp_vdm_data.__smctp_pad0;
+}
+
+int mctp_vendor_define_message_decode(struct sk_buff *skb, u8 type,
+				      struct mctp_vdm_data *vdm_data, u8 *vendorlen)
+{
+	union mctp_vendor_id vendorid;
+	u8 len = 0;
+	int rc = 0;
+
+	if (mctp_pci_vdm(type)) {
+		vendorid.pci_vendor_id.data = ntohs(*((u16 *)((u8 *)skb->data + 1)));
+		len = 2;
+		switch (vendorid.pci_vendor_id.data) {
+		case PCI_VENDOR_ID_INTEL:
+			vdm_data->smctp_sub_type = *((u8 *)skb->data + 4);
+			break;
+		default:
+			rc = -EPERM;
+		}
+	} else if (mctp_iana_vdm(type)) {
+		vendorid.iana_number.data = ntohl(*((u32 *)((u8 *)skb->data + 1)));
+		len = 4;
+		/* TODO: no VDM based on IANA support - add if needed for specific vendor */
+		rc = -EPERM;
+	} else {
+		rc = -EINVAL;
+	}
+
+	if (rc == 0) {
+		vdm_data->smctp_vendor = vendorid;
+
+		if (vendorlen)
+			*vendorlen = len;
+	}
+
+	return rc;
+}
+
+static int mctp_vendor_define_message_encode(struct sk_buff *skb, u8 type,
+					     struct mctp_vdm_data *vdm_data)
+{
+	if (mctp_pci_vdm(type))
+		*(u16 *)skb_put(skb, 2) = htons(vdm_data->smctp_vendor.pci_vendor_id.data);
+	else if (mctp_iana_vdm(type))
+		*(u32 *)skb_put(skb, 4) = htonl(vdm_data->smctp_vendor.iana_number.data);
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
 static int mctp_bind(struct socket *sock, struct sockaddr *addr, int addrlen)
 {
 	struct sock *sk = sock->sk;
 	struct mctp_sock *msk = container_of(sk, struct mctp_sock, sk);
 	struct sockaddr_mctp *smctp;
+	struct sockaddr_mctp_vendor_ext *smctp_vendor_ext;
 	int rc;
 
 	if (addrlen < sizeof(*smctp))
@@ -82,6 +137,14 @@ static int mctp_bind(struct socket *sock, struct sockaddr *addr, int addrlen)
 	msk->bind_addr = smctp->smctp_addr.s_addr;
 	msk->bind_type = smctp->smctp_type & 0x7f; /* ignore the IC bit */
 
+	if (msk->vendor_specific_ext && mctp_vdm(msk->bind_type) &&
+	    addrlen >= sizeof(struct sockaddr_mctp_vendor_ext)) {
+	    smctp_vendor_ext = (struct sockaddr_mctp_vendor_ext *)smctp;
+	    msk->bind_vendor_type = smctp_vendor_ext->smctp_vdm_data.smctp_sub_type;
+	} else {
+		msk->bind_vendor_type = 0;
+	}
+
 	rc = sk->sk_prot->hash(sk);
 
 out_release:
@@ -167,6 +230,21 @@ static int mctp_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	/* set type as fist byte in payload */
 	*(u8 *)skb_put(skb, 1) = addr->smctp_type;
 
+	if (msk->vendor_specific_ext && addrlen >= sizeof(struct sockaddr_mctp_vendor_ext)) {
+		DECLARE_SOCKADDR(struct sockaddr_mctp_vendor_ext *,
+				 extvendor, msg->msg_name);
+
+		if (!mctp_sockaddr_vendor_ext_is_ok(extvendor)) {
+			rc = -EINVAL;
+			goto err_free;
+		}
+
+		rc = mctp_vendor_define_message_encode(skb, addr->smctp_type,
+						       &extvendor->smctp_vdm_data);
+		if (rc < 0)
+			goto err_free;
+	}
+
 	rc = memcpy_from_msg((void *)skb_put(skb, len), msg, len);
 	if (rc < 0)
 		goto err_free;
@@ -212,6 +290,7 @@ static int mctp_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	size_t msglen;
 	u8 type;
 	int rc;
+	u8 vendorlen = 0;
 
 	if (flags & ~(MSG_DONTWAIT | MSG_TRUNC | MSG_PEEK))
 		return -EOPNOTSUPP;
@@ -229,12 +308,27 @@ static int mctp_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	type = *((u8 *)skb->data);
 	msglen = skb->len - 1;
 
+	/* extract vendor_id and subcode, remove from data */
+	if (msk->vendor_specific_ext) {
+		DECLARE_SOCKADDR(struct sockaddr_mctp_vendor_ext *,
+				 extvendor, msg->msg_name);
+
+		if (extvendor) {
+			rc = mctp_vendor_define_message_decode(skb, type,
+							       &extvendor->smctp_vdm_data,
+							       &vendorlen);
+			if (rc < 0)
+				goto out_free;
+			msglen = msglen - vendorlen;
+		}
+	}
+
 	if (len < msglen)
 		msg->msg_flags |= MSG_TRUNC;
 	else
 		len = msglen;
 
-	rc = skb_copy_datagram_msg(skb, 1, msg, len);
+	rc = skb_copy_datagram_msg(skb, vendorlen + 1, msg, len);
 	if (rc < 0)
 		goto out_free;
 
@@ -322,6 +416,15 @@ static int mctp_setsockopt(struct socket *sock, int level, int optname,
 		return 0;
 	}
 
+	if (optname == MCTP_OPT_VENDOR_EXT) {
+		if (optlen != sizeof(int))
+			return -EINVAL;
+		if (copy_from_sockptr(&val, optval, sizeof(int)))
+			return -EFAULT;
+		msk->vendor_specific_ext = val;
+		return 0;
+	}
+
 	return -ENOPROTOOPT;
 }
 
@@ -346,6 +449,15 @@ static int mctp_getsockopt(struct socket *sock, int level, int optname,
 		return 0;
 	}
 
+	if (optname == MCTP_OPT_VENDOR_EXT) {
+		if (len != sizeof(int))
+			return -EINVAL;
+		val = !!msk->vendor_specific_ext;
+		if (copy_to_user(optval, &val, len))
+			return -EFAULT;
+		return 0;
+	}
+
 	return -EINVAL;
 }
 
diff --git a/net/mctp/route.c b/net/mctp/route.c
index 50c976574b11..dd2830ba3534 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -44,6 +44,8 @@ static struct mctp_sock *mctp_lookup_bind(struct net *net, struct sk_buff *skb)
 	struct mctp_hdr *mh;
 	struct sock *sk;
 	u8 type;
+	struct mctp_vdm_data vdm_data;
+	int ret = -EINVAL;
 
 	WARN_ON(!rcu_read_lock_held());
 
@@ -55,6 +57,9 @@ static struct mctp_sock *mctp_lookup_bind(struct net *net, struct sk_buff *skb)
 
 	type = (*(u8 *)skb->data) & 0x7f;
 
+	if (mctp_vdm(type))
+		ret = mctp_vendor_define_message_decode(skb, type, &vdm_data, NULL);
+
 	sk_for_each_rcu(sk, &net->mctp.binds) {
 		struct mctp_sock *msk = container_of(sk, struct mctp_sock, sk);
 
@@ -64,6 +69,10 @@ static struct mctp_sock *mctp_lookup_bind(struct net *net, struct sk_buff *skb)
 		if (msk->bind_type != type)
 			continue;
 
+		if (msk->vendor_specific_ext &&
+		    (ret != 0 || msk->bind_vendor_type != vdm_data.smctp_sub_type))
+			continue;
+
 		if (!mctp_address_matches(msk->bind_addr, mh->dest))
 			continue;
 
-- 
2.25.1

