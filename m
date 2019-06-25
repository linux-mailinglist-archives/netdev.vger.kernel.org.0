Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA824528AC
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 11:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731792AbfFYJye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 05:54:34 -0400
Received: from mail.us.es ([193.147.175.20]:37640 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729450AbfFYJye (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 05:54:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6B0A76964D
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 11:54:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 54C451150DF
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 11:54:30 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4A7361150CB; Tue, 25 Jun 2019 11:54:30 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3877FDA801;
        Tue, 25 Jun 2019 11:54:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 25 Jun 2019 11:54:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0756F4265A31;
        Tue, 25 Jun 2019 11:54:27 +0200 (CEST)
Date:   Tue, 25 Jun 2019 11:54:27 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu <wenxu@ucloud.cn>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf-next v2 1/2] netfilter: nft_meta: add
 NFT_META_BRI_PVID support
Message-ID: <20190625095427.rjarc6fourai47wn@salvia>
References: <1560993460-25569-1-git-send-email-wenxu@ucloud.cn>
 <5d8a5ac6-88d4-3a32-ca9b-7fb21077be57@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d8a5ac6-88d4-3a32-ca9b-7fb21077be57@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 05:23:02PM +0800, wenxu wrote:
> Hi pablo,
> 
> Any idea about these two patches?

Plan is to include them in the next batch.

> On 6/20/2019 9:17 AM, wenxu@ucloud.cn wrote:
> > From: wenxu <wenxu@ucloud.cn>
> >
> > nft add table bridge firewall
> > nft add chain bridge firewall zones { type filter hook prerouting priority - 300 \; }
> > nft add rule bridge firewall zones counter ct zone set vlan id map { 100 : 1, 200 : 2 }
> >
> > As above set the bridge port with pvid, the received packet don't contain
> > the vlan tag which means the packet should belong to vlan 200 through pvid.
> > With this pacth user can get the pvid of bridge ports.
> >
> > So add the following rule for as the first rule in the chain of zones.
> >
> > nft add rule bridge firewall zones counter meta brvlan set meta brpvid
> >
> > Signed-off-by: wenxu <wenxu@ucloud.cn>
> > ---
> >  include/uapi/linux/netfilter/nf_tables.h |  2 ++
> >  net/netfilter/nft_meta.c                 | 13 +++++++++++++
> >  2 files changed, 15 insertions(+)
> >
> > diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> > index 31a6b8f..4a16124 100644
> > --- a/include/uapi/linux/netfilter/nf_tables.h
> > +++ b/include/uapi/linux/netfilter/nf_tables.h
> > @@ -793,6 +793,7 @@ enum nft_exthdr_attributes {
> >   * @NFT_META_SECPATH: boolean, secpath_exists (!!skb->sp)
> >   * @NFT_META_IIFKIND: packet input interface kind name (dev->rtnl_link_ops->kind)
> >   * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
> > + * @NFT_META_BRI_PVID: packet input bridge port pvid
> >   */
> >  enum nft_meta_keys {
> >  	NFT_META_LEN,
> > @@ -823,6 +824,7 @@ enum nft_meta_keys {
> >  	NFT_META_SECPATH,
> >  	NFT_META_IIFKIND,
> >  	NFT_META_OIFKIND,
> > +	NFT_META_BRI_PVID,
> >  };
> >  
> >  /**
> > diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
> > index 987d2d6..cb877e01 100644
> > --- a/net/netfilter/nft_meta.c
> > +++ b/net/netfilter/nft_meta.c
> > @@ -243,6 +243,14 @@ void nft_meta_get_eval(const struct nft_expr *expr,
> >  			goto err;
> >  		strncpy((char *)dest, p->br->dev->name, IFNAMSIZ);
> >  		return;
> > +	case NFT_META_BRI_PVID:
> > +		if (in == NULL || (p = br_port_get_rtnl_rcu(in)) == NULL)
> > +			goto err;
> > +		if (br_opt_get(p->br, BROPT_VLAN_ENABLED)) {
> > +			nft_reg_store16(dest, br_get_pvid(nbp_vlan_group_rcu(p)));
> > +			return;
> > +		}
> > +		goto err;
> >  #endif
> >  	case NFT_META_IIFKIND:
> >  		if (in == NULL || in->rtnl_link_ops == NULL)
> > @@ -370,6 +378,11 @@ static int nft_meta_get_init(const struct nft_ctx *ctx,
> >  			return -EOPNOTSUPP;
> >  		len = IFNAMSIZ;
> >  		break;
> > +	case NFT_META_BRI_PVID:
> > +		if (ctx->family != NFPROTO_BRIDGE)
> > +			return -EOPNOTSUPP;
> > +		len = sizeof(u16);
> > +		break;
> >  #endif
> >  	default:
> >  		return -EOPNOTSUPP;
