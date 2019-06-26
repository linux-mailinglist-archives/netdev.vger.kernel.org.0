Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B32D566C5
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 12:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfFZK3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 06:29:41 -0400
Received: from mail.us.es ([193.147.175.20]:51190 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbfFZK3l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 06:29:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8771F11EF4F
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 12:29:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 724EF114D9A
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 12:29:38 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6137E1021B2; Wed, 26 Jun 2019 12:29:38 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D4AC6DA4D1;
        Wed, 26 Jun 2019 12:29:35 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 26 Jun 2019 12:29:35 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B299C4265A2F;
        Wed, 26 Jun 2019 12:29:35 +0200 (CEST)
Date:   Wed, 26 Jun 2019 12:29:35 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf-next v2 2/2] netfilter: nft_meta: Add
 NFT_META_BRI_VLAN support
Message-ID: <20190626102935.ztxcfb3kysvohzi3@salvia>
References: <1560993460-25569-1-git-send-email-wenxu@ucloud.cn>
 <1560993460-25569-2-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="4v7mmcfs7bzhusmw"
Content-Disposition: inline
In-Reply-To: <1560993460-25569-2-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4v7mmcfs7bzhusmw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Could you add a NFT_META_BRI_VLAN_PROTO? Similar to patch 1/2, to
retrieve p->br->vlan_proto.

Then, add a generic way to set the vlan metadata. I'm attaching an
incomplete patch, so there is something like:

        meta vlan set 0x88a8:20

to set q-in-q.

we could also add a shortcut for simple vlan case (no q-in-q), ie.
assuming protocol is 0x8100:

        meta vlan set 20

Does this make sense to you?

And we have a way to set the meta vlan information from ingress to
then, which is something I also need here.

Thanks.

--4v7mmcfs7bzhusmw
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 8859535031e2..6ef2cc42924c 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -796,6 +796,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_IIFKIND: packet input interface kind name (dev->rtnl_link_ops->kind)
  * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
  * @NFT_META_BRI_PVID: packet input bridge port pvid
+ * @NFT_META_VLAN: packet vlan metadata
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -827,6 +828,7 @@ enum nft_meta_keys {
 	NFT_META_IIFKIND,
 	NFT_META_OIFKIND,
 	NFT_META_BRI_PVID,
+	NFT_META_VLAN,
 };
 
 /**
@@ -893,12 +895,14 @@ enum nft_hash_attributes {
  * @NFTA_META_DREG: destination register (NLA_U32)
  * @NFTA_META_KEY: meta data item to load (NLA_U32: nft_meta_keys)
  * @NFTA_META_SREG: source register (NLA_U32)
+ * @NFTA_META_SREG2: source register (NLA_U32)
  */
 enum nft_meta_attributes {
 	NFTA_META_UNSPEC,
 	NFTA_META_DREG,
 	NFTA_META_KEY,
 	NFTA_META_SREG,
+	NFTA_META_SREG2,
 	__NFTA_META_MAX
 };
 #define NFTA_META_MAX		(__NFTA_META_MAX - 1)
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 4f8116de70f8..dbbad7319183 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -28,7 +28,10 @@ struct nft_meta {
 	enum nft_meta_keys	key:8;
 	union {
 		enum nft_registers	dreg:8;
-		enum nft_registers	sreg:8;
+		struct {
+			enum nft_registers	sreg:8;
+			enum nft_registers	sreg2:8;
+		};
 	};
 };
 
@@ -304,6 +307,17 @@ static void nft_meta_set_eval(const struct nft_expr *expr,
 		skb->secmark = value;
 		break;
 #endif
+	case NFT_META_VLAN: {
+		u32 *sreg2 = &regs->data[meta->sreg2];
+		__be16 vlan_proto;
+		u16 vlan_tci;
+
+		vlan_tci = nft_reg_load16(sreg);
+		vlan_proto = nft_reg_load16(sreg2);
+
+		__vlan_hwaccel_put_tag(skb, vlan_proto, vlan_tci);
+		break;
+	}
 	default:
 		WARN_ON(1);
 	}
@@ -474,6 +488,13 @@ static int nft_meta_set_init(const struct nft_ctx *ctx,
 	case NFT_META_PKTTYPE:
 		len = sizeof(u8);
 		break;
+	case NFT_META_VLAN:
+		len = sizeof(u16);
+		priv->sreg2 = nft_parse_register(tb[NFTA_META_SREG2]);
+		err = nft_validate_register_load(priv->sreg2, len);
+		if (err < 0)
+			return err;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}

--4v7mmcfs7bzhusmw--
