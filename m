Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E48F21EABE
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 11:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbfEOJNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 05:13:42 -0400
Received: from mail.us.es ([193.147.175.20]:56094 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfEOJNm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 05:13:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 550631031A0
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 11:13:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 37499DA799
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 11:13:37 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id ABB9FDA81D; Wed, 15 May 2019 11:13:29 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EE0E1DA708;
        Wed, 15 May 2019 11:13:26 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 15 May 2019 11:13:26 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8F52E4265A31;
        Wed, 15 May 2019 11:13:26 +0200 (CEST)
Date:   Wed, 15 May 2019 11:13:26 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, thomas.lendacky@amd.com,
        f.fainelli@gmail.com, ariel.elior@cavium.com,
        michael.chan@broadcom.com, santosh@chelsio.com,
        madalin.bucur@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        peppe.cavallaro@st.com, grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        julia.lawall@lip6.fr, john.fastabend@gmail.com
Subject: Re: [PATCH net-next,RFC 2/2] netfilter: nf_tables: add hardware
 offload support
Message-ID: <20190515091326.x5m6433gyznsgd45@salvia>
References: <20190509163954.13703-1-pablo@netfilter.org>
 <20190509163954.13703-3-pablo@netfilter.org>
 <20190514170108.GC2584@nanopsycho>
 <20190514230331.trlmwnfa2rcs7hjt@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514230331.trlmwnfa2rcs7hjt@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 15, 2019 at 01:03:31AM +0200, Pablo Neira Ayuso wrote:
> On Tue, May 14, 2019 at 07:01:08PM +0200, Jiri Pirko wrote:
> > Thu, May 09, 2019 at 06:39:51PM CEST, pablo@netfilter.org wrote:
> > >This patch adds hardware offload support for nftables through the
> > >existing netdev_ops->ndo_setup_tc() interface, the TC_SETUP_CLSFLOWER
> > >classifier and the flow rule API. This hardware offload support is
> > >available for the NFPROTO_NETDEV family and the ingress hook.
> > >
> > >Each nftables expression has a new ->offload interface, that is used to
> > >populate the flow rule object that is attached to the transaction
> > >object.
> > >
> > >There is a new per-table NFT_TABLE_F_HW flag, that is set on to offload
> > >an entire table, including all of its chains.
> > >
> > >This patch supports for basic metadata (layer 3 and 4 protocol numbers),
> > >5-tuple payload matching and the accept/drop actions; this also includes
> > >basechain hardware offload only.
> > >
> > >Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > [...]
> > 
> > >+static int nft_flow_offload_chain(struct nft_trans *trans,
> > >+				  enum flow_block_command cmd)
> > >+{
> > >+	struct nft_chain *chain = trans->ctx.chain;
> > >+	struct netlink_ext_ack extack = {};
> > >+	struct flow_block_offload bo = {};
> > >+	struct nft_base_chain *basechain;
> > >+	struct net_device *dev;
> > >+	int err;
> > >+
> > >+	if (!nft_is_base_chain(chain))
> > >+		return -EOPNOTSUPP;
> > >+
> > >+	basechain = nft_base_chain(chain);
> > >+	dev = basechain->ops.dev;
> > >+	if (!dev)
> > >+		return -EOPNOTSUPP;
> > >+
> > >+	bo.command = cmd;
> > >+	bo.binder_type = TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
> > >+	bo.block_index = (u32)trans->ctx.chain->handle;
> > >+	bo.extack = &extack;
> > >+	INIT_LIST_HEAD(&bo.cb_list);
> > >+
> > >+	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);
> > 
> > Okay, so you pretend to be clsact-ingress-flower. That looks fine.
> > But how do you ensure that the real one does not bind a block on the
> > same device too?
> 
> I could store the interface index in the block_cb object, then use the
> tuple [ cb, cb_ident, ifindex ] to check if the block is already bound
> by when flow_block_cb_alloc() is called.

Actually cb_ident would be sufficient. One possibility would be to
extend flow_block_cb_alloc() to check for an existing binding.

diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index cf984ef05609..44172014cebe 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -193,9 +193,15 @@ struct flow_block_cb *flow_block_cb_alloc(u32 block_index, tc_setup_cb_t *cb,
 {
        struct flow_block_cb *block_cb;
 
+       list_for_each_entry(block_cb, &flow_block_cb_list, list) {
+               if (block_cb->cb == cb &&
+                   block_cb->cb_ident == cb_ident)
+                       return ERR_PTR(-EBUSY);
+       }
+
        block_cb = kzalloc(sizeof(*block_cb), GFP_KERNEL);
        if (!block_cb)
-               return NULL;
+               return ERR_PTR(-ENOMEM);
 
        block_cb->cb = cb;
        block_cb->cb_ident = cb_ident;

Thanks.
