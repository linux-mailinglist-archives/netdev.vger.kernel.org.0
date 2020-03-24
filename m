Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD3161918B1
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 19:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgCXSND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 14:13:03 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:60547 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727672AbgCXSND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 14:13:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585073581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZwgFlf8SmgzS3eZf8uGiBYaH3LLMRZ43TQ+/Om7KIBM=;
        b=ZqzeMUPFNnGI5iVkN3vTBLQayO/odheAEyJCROIlLERdTERBMOZQE6KsHEmdtTDs/0i3A9
        5++rzKWpQeB2v8QTA0VtXHfY1nb5idfTFJgZmCnPfs/E8G6rXOrjLiqFpLTywooAOY5J/4
        8R2Wqn4vmuH3AX50NntKE2XUdjukDNA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-tIVV5lQBOtWFqBCspJkv6Q-1; Tue, 24 Mar 2020 14:12:59 -0400
X-MC-Unique: tIVV5lQBOtWFqBCspJkv6Q-1
Received: by mail-wr1-f72.google.com with SMTP id i18so9561143wrx.17
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 11:12:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ZwgFlf8SmgzS3eZf8uGiBYaH3LLMRZ43TQ+/Om7KIBM=;
        b=OqZwlGR2nN+9nDMKrFF3ZVE+y/vDrSgp86p9Sr06JuQDX0JxVPYZc8vGLljn/XYu7B
         3FVLU4SpFRjmOLQiB25hsOrLa71glvcrV+1BlDx3Gw90PCsmPQH7xugtJmYzVRIQCjYF
         0KliDpJrJTi1F1k5o1PakJsEdj6pM+K4qDSQX8eDHavHq9CLfYWjoMYT+CeN+Q0l78XE
         1B2bIU/OXYyIyy29gwNAEDpMolbd5xSglmUiLoX7PIhp3rn0xd82r1HMRBpDGb6N2SWU
         6F6K8O+3l05Aupj+DLLhXfnxs1BCiALQAdxVmUPmCJa7XDaX2YqO4KHQyHNf6qxgsBAu
         7oQQ==
X-Gm-Message-State: ANhLgQ2fHk/k14+5JrL6S5/AWTr6YaSo5Flujk9Jfumwqk6qFZ1ZYoq2
        Ft0YzWNCdqhiazKUf+y1fCotMMafppup+8yvBZGCDCQosFrBwqmYPDFv/dnfRCBigrAJinci/PB
        rG8OIeoGhyMHLZK9o
X-Received: by 2002:a1c:4e0c:: with SMTP id g12mr6590595wmh.184.1585073575711;
        Tue, 24 Mar 2020 11:12:55 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vs+MkE/Jy+J6xtzoMv9lqYUhpruQAUHWW304dSwJf2sDqtsPlK2cAV9D0bDI8Hefgxcamszhg==
X-Received: by 2002:a1c:4e0c:: with SMTP id g12mr6590492wmh.184.1585073574494;
        Tue, 24 Mar 2020 11:12:54 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id o4sm29529044wrp.84.2020.03.24.11.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 11:12:53 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 324FB18158C; Tue, 24 Mar 2020 19:12:53 +0100 (CET)
Subject: [PATCH bpf-next v3 1/4] xdp: Support specifying expected existing
 program when attaching XDP
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Andrey Ignatov <rdna@fb.com>
Date:   Tue, 24 Mar 2020 19:12:53 +0100
Message-ID: <158507357313.6925.9859587430926258691.stgit@toke.dk>
In-Reply-To: <158507357205.6925.17804771242752938867.stgit@toke.dk>
References: <158507357205.6925.17804771242752938867.stgit@toke.dk>
User-Agent: StGit/0.22
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

While it is currently possible for userspace to specify that an existing
XDP program should not be replaced when attaching to an interface, there is
no mechanism to safely replace a specific XDP program with another.

This patch adds a new netlink attribute, IFLA_XDP_EXPECTED_ID, which can be
set along with IFLA_XDP_FD. If set, the kernel will check that the program
currently loaded on the interface matches the expected one, and fail the
operation if it does not. This corresponds to a 'cmpxchg' memory operation.
Setting the new attribute with a negative value means that no program is
expected to be attached, which corresponds to setting the UPDATE_IF_NOEXIST
flag.

A new companion flag, XDP_FLAGS_EXPECT_ID, is also added to explicitly
request checking of the EXPECTED_ID attribute. This is needed for userspace
to discover whether the kernel supports the new attribute.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/netdevice.h    |    2 +-
 include/uapi/linux/if_link.h |    4 +++-
 net/core/dev.c               |   14 +++++++++-----
 net/core/rtnetlink.c         |   13 +++++++++++++
 4 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 654808bfad83..a14199ea9501 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3768,7 +3768,7 @@ struct sk_buff *dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
-		      int fd, u32 flags);
+		      int fd, u32 expected_id, u32 flags);
 u32 __dev_xdp_query(struct net_device *dev, bpf_op_t xdp_op,
 		    enum bpf_netdev_command cmd);
 int xdp_umem_query(struct net_device *dev, u16 queue_id);
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 61e0801c82df..7182569773f9 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -972,11 +972,12 @@ enum {
 #define XDP_FLAGS_SKB_MODE		(1U << 1)
 #define XDP_FLAGS_DRV_MODE		(1U << 2)
 #define XDP_FLAGS_HW_MODE		(1U << 3)
+#define XDP_FLAGS_EXPECT_ID		(1U << 4)
 #define XDP_FLAGS_MODES			(XDP_FLAGS_SKB_MODE | \
 					 XDP_FLAGS_DRV_MODE | \
 					 XDP_FLAGS_HW_MODE)
 #define XDP_FLAGS_MASK			(XDP_FLAGS_UPDATE_IF_NOEXIST | \
-					 XDP_FLAGS_MODES)
+					 XDP_FLAGS_MODES | XDP_FLAGS_EXPECT_ID)
 
 /* These are stored into IFLA_XDP_ATTACHED on dump. */
 enum {
@@ -996,6 +997,7 @@ enum {
 	IFLA_XDP_DRV_PROG_ID,
 	IFLA_XDP_SKB_PROG_ID,
 	IFLA_XDP_HW_PROG_ID,
+	IFLA_XDP_EXPECTED_ID,
 	__IFLA_XDP_MAX,
 };
 
diff --git a/net/core/dev.c b/net/core/dev.c
index d84541c24446..37db06d8074f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8655,18 +8655,20 @@ static void dev_xdp_uninstall(struct net_device *dev)
  *	@dev: device
  *	@extack: netlink extended ack
  *	@fd: new program fd or negative value to clear
+ *	@expected_id: ID of old program that userspace expects to replace or clear
  *	@flags: xdp-related flags
  *
  *	Set or clear a bpf program for a device
  */
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
-		      int fd, u32 flags)
+		      int fd, u32 expected_id, u32 flags)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 	enum bpf_netdev_command query;
 	struct bpf_prog *prog = NULL;
 	bpf_op_t bpf_op, bpf_chk;
 	bool offload;
+	u32 prog_id;
 	int err;
 
 	ASSERT_RTNL();
@@ -8684,15 +8686,17 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 	if (bpf_op == bpf_chk)
 		bpf_chk = generic_xdp_install;
 
+	prog_id = __dev_xdp_query(dev, bpf_op, query);
+	if (flags & XDP_FLAGS_EXPECT_ID && prog_id != expected_id) {
+		NL_SET_ERR_MSG(extack, "Active program does not match expected");
+		return -EEXIST;
+	}
 	if (fd >= 0) {
-		u32 prog_id;
-
 		if (!offload && __dev_xdp_query(dev, bpf_chk, XDP_QUERY_PROG)) {
 			NL_SET_ERR_MSG(extack, "native and generic XDP can't be active at the same time");
 			return -EEXIST;
 		}
 
-		prog_id = __dev_xdp_query(dev, bpf_op, query);
 		if ((flags & XDP_FLAGS_UPDATE_IF_NOEXIST) && prog_id) {
 			NL_SET_ERR_MSG(extack, "XDP program already attached");
 			return -EBUSY;
@@ -8715,7 +8719,7 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 			return 0;
 		}
 	} else {
-		if (!__dev_xdp_query(dev, bpf_op, query))
+		if (!prog_id)
 			return 0;
 	}
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 14e6ea21c378..dd6d4d85b284 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1872,7 +1872,9 @@ static const struct nla_policy ifla_port_policy[IFLA_PORT_MAX+1] = {
 };
 
 static const struct nla_policy ifla_xdp_policy[IFLA_XDP_MAX + 1] = {
+	[IFLA_XDP_UNSPEC]	= { .strict_start_type = IFLA_XDP_EXPECTED_ID },
 	[IFLA_XDP_FD]		= { .type = NLA_S32 },
+	[IFLA_XDP_EXPECTED_ID]	= { .type = NLA_U32 },
 	[IFLA_XDP_ATTACHED]	= { .type = NLA_U8 },
 	[IFLA_XDP_FLAGS]	= { .type = NLA_U32 },
 	[IFLA_XDP_PROG_ID]	= { .type = NLA_U32 },
@@ -2799,8 +2801,19 @@ static int do_setlink(const struct sk_buff *skb,
 		}
 
 		if (xdp[IFLA_XDP_FD]) {
+			u32 expected_id = 0;
+
+			if (xdp_flags & XDP_FLAGS_EXPECT_ID) {
+				if (!xdp[IFLA_XDP_EXPECTED_ID]) {
+					err = -EINVAL;
+					goto errout;
+				}
+				expected_id = nla_get_u32(xdp[IFLA_XDP_EXPECTED_ID]);
+			}
+
 			err = dev_change_xdp_fd(dev, extack,
 						nla_get_s32(xdp[IFLA_XDP_FD]),
+						expected_id,
 						xdp_flags);
 			if (err)
 				goto errout;

