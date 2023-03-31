Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B4E6D237A
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 17:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232979AbjCaPEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 11:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233006AbjCaPED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 11:04:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FFCCA38
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 08:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680274997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lhlF87/o7UkqZcPQh1sySISQjrn7d+nfBFInrxnFwFc=;
        b=Gv3KQBFVanHez8zzMyLnmIi2Bt1uvQM6dTrZ+SGMDbaD8lFk1TMgEBWOAZcWvPvy+VpJhz
        O9wtcnw74vL5Qlx6HAqsQvA9/LV9jpTjqVznWpzH6QE2R/Oe9oYD8O9RtrJxHJiET4wGtu
        i2q9NW9JbGsKA835yx8X4Z3PubJr850=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-qftW_ADpO-eMsBjUO8S_yA-1; Fri, 31 Mar 2023 11:03:11 -0400
X-MC-Unique: qftW_ADpO-eMsBjUO8S_yA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C8BA185A78B;
        Fri, 31 Mar 2023 15:03:08 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95E35492C3E;
        Fri, 31 Mar 2023 15:03:07 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id EFA2C30736C72;
        Fri, 31 Mar 2023 17:03:06 +0200 (CEST)
Subject: [PATCH bpf V4 1/5] xdp: rss hash types representation
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        anthony.l.nguyen@intel.com, yoong.siang.song@intel.com,
        boon.leong.ong@intel.com, intel-wired-lan@lists.osuosl.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com, kuba@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, hawk@kernel.org,
        davem@davemloft.net, tariqt@nvidia.com
Date:   Fri, 31 Mar 2023 17:03:06 +0200
Message-ID: <168027498690.3941176.99100635661990098.stgit@firesoul>
In-Reply-To: <168027495947.3941176.6690238098903275241.stgit@firesoul>
References: <168027495947.3941176.6690238098903275241.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RSS hash type specifies what portion of packet data NIC hardware used
when calculating RSS hash value. The RSS types are focused on Internet
traffic protocols at OSI layers L3 and L4. L2 (e.g. ARP) often get hash
value zero and no RSS type. For L3 focused on IPv4 vs. IPv6, and L4
primarily TCP vs UDP, but some hardware supports SCTP.

Hardware RSS types are differently encoded for each hardware NIC. Most
hardware represent RSS hash type as a number. Determining L3 vs L4 often
requires a mapping table as there often isn't a pattern or sorting
according to ISO layer.

The patch introduce a XDP RSS hash type (enum xdp_rss_hash_type) that
contain combinations to be used by drivers, which gets build up with bits
from enum xdp_rss_type_bits. Both enum xdp_rss_type_bits and
xdp_rss_hash_type get exposed to BPF via BTF, and it is up to the
BPF-programmer to match using these defines.

This proposal change the kfunc API bpf_xdp_metadata_rx_hash() adding
a pointer value argument for provide the RSS hash type.

Fixes: 3d76a4d3d4e5 ("bpf: XDP metadata RX kfuncs")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/netdevice.h |    3 ++-
 include/net/xdp.h         |   45 +++++++++++++++++++++++++++++++++++++++++++++
 net/core/xdp.c            |   10 +++++++++-
 3 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 470085b121d3..c35f04f636f1 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1624,7 +1624,8 @@ struct net_device_ops {
 
 struct xdp_metadata_ops {
 	int	(*xmo_rx_timestamp)(const struct xdp_md *ctx, u64 *timestamp);
-	int	(*xmo_rx_hash)(const struct xdp_md *ctx, u32 *hash);
+	int	(*xmo_rx_hash)(const struct xdp_md *ctx, u32 *hash,
+			       enum xdp_rss_hash_type *rss_type);
 };
 
 /**
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 41c57b8b1671..216e910da1cf 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -8,6 +8,7 @@
 
 #include <linux/skbuff.h> /* skb_shared_info */
 #include <uapi/linux/netdev.h>
+#include <linux/bitfield.h>
 
 /**
  * DOC: XDP RX-queue information
@@ -425,6 +426,50 @@ XDP_METADATA_KFUNC_xxx
 MAX_XDP_METADATA_KFUNC,
 };
 
+enum xdp_rss_hash_type {
+	/* First part: Individual bits for L3/L4 types */
+	XDP_RSS_L3_IPV4		= BIT(0),
+	XDP_RSS_L3_IPV6		= BIT(1),
+
+	/* The fixed (L3) IPv4 and IPv6 headers can both be followed by
+	 * variable/dynamic headers, IPv4 called Options and IPv6 called
+	 * Extension Headers. HW RSS type can contain this info.
+	 */
+	XDP_RSS_L3_DYNHDR	= BIT(2),
+
+	/* When RSS hash covers L4 then drivers MUST set XDP_RSS_L4 bit in
+	 * addition to the protocol specific bit.  This ease interaction with
+	 * SKBs and avoids reserving a fixed mask for future L4 protocol bits.
+	 */
+	XDP_RSS_L4		= BIT(3), /* L4 based hash, proto can be unknown */
+	XDP_RSS_L4_TCP		= BIT(4),
+	XDP_RSS_L4_UDP		= BIT(5),
+	XDP_RSS_L4_SCTP		= BIT(6),
+	XDP_RSS_L4_IPSEC	= BIT(7), /* L4 based hash include IPSEC SPI */
+
+	/* Second part: RSS hash type combinations used for driver HW mapping */
+	XDP_RSS_TYPE_NONE            = 0,
+	XDP_RSS_TYPE_L2              = XDP_RSS_TYPE_NONE,
+
+	XDP_RSS_TYPE_L3_IPV4         = XDP_RSS_L3_IPV4,
+	XDP_RSS_TYPE_L3_IPV6         = XDP_RSS_L3_IPV6,
+	XDP_RSS_TYPE_L3_IPV4_OPT     = XDP_RSS_L3_IPV4 | XDP_RSS_L3_DYNHDR,
+	XDP_RSS_TYPE_L3_IPV6_EX      = XDP_RSS_L3_IPV6 | XDP_RSS_L3_DYNHDR,
+
+	XDP_RSS_TYPE_L4_ANY          = XDP_RSS_L4,
+	XDP_RSS_TYPE_L4_IPV4_TCP     = XDP_RSS_L3_IPV4 | XDP_RSS_L4 | XDP_RSS_L4_TCP,
+	XDP_RSS_TYPE_L4_IPV4_UDP     = XDP_RSS_L3_IPV4 | XDP_RSS_L4 | XDP_RSS_L4_UDP,
+	XDP_RSS_TYPE_L4_IPV4_SCTP    = XDP_RSS_L3_IPV4 | XDP_RSS_L4 | XDP_RSS_L4_SCTP,
+
+	XDP_RSS_TYPE_L4_IPV6_TCP     = XDP_RSS_L3_IPV6 | XDP_RSS_L4 | XDP_RSS_L4_TCP,
+	XDP_RSS_TYPE_L4_IPV6_UDP     = XDP_RSS_L3_IPV6 | XDP_RSS_L4 | XDP_RSS_L4_UDP,
+	XDP_RSS_TYPE_L4_IPV6_SCTP    = XDP_RSS_L3_IPV6 | XDP_RSS_L4 | XDP_RSS_L4_SCTP,
+
+	XDP_RSS_TYPE_L4_IPV6_TCP_EX  = XDP_RSS_TYPE_L4_IPV6_TCP |XDP_RSS_L3_DYNHDR,
+	XDP_RSS_TYPE_L4_IPV6_UDP_EX  = XDP_RSS_TYPE_L4_IPV6_UDP |XDP_RSS_L3_DYNHDR,
+	XDP_RSS_TYPE_L4_IPV6_SCTP_EX = XDP_RSS_TYPE_L4_IPV6_SCTP|XDP_RSS_L3_DYNHDR,
+};
+
 #ifdef CONFIG_NET
 u32 bpf_xdp_metadata_kfunc_id(int id);
 bool bpf_dev_bound_kfunc_id(u32 btf_id);
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 528d4b37983d..fb85aca81961 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -734,13 +734,21 @@ __bpf_kfunc int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx, u64 *tim
  * bpf_xdp_metadata_rx_hash - Read XDP frame RX hash.
  * @ctx: XDP context pointer.
  * @hash: Return value pointer.
+ * @rss_type: Return value pointer for RSS type.
+ *
+ * The RSS hash type (@rss_type) specifies what portion of packet headers NIC
+ * hardware used when calculating RSS hash value.  The RSS type can be decoded
+ * via &enum xdp_rss_hash_type either matching on individual L3/L4 bits
+ * ``XDP_RSS_L*`` or by combined traditional *RSS Hashing Types*
+ * ``XDP_RSS_TYPE_L*``.
  *
  * Return:
  * * Returns 0 on success or ``-errno`` on error.
  * * ``-EOPNOTSUPP`` : means device driver doesn't implement kfunc
  * * ``-ENODATA``    : means no RX-hash available for this frame
  */
-__bpf_kfunc int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, u32 *hash)
+__bpf_kfunc int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, u32 *hash,
+					 enum xdp_rss_hash_type *rss_type)
 {
 	return -EOPNOTSUPP;
 }


