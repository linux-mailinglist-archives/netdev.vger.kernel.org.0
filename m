Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F328F7A6C0
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 13:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbfG3LTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 07:19:52 -0400
Received: from correo.us.es ([193.147.175.20]:53880 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728967AbfG3LTw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 07:19:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3AA3AB60C5
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 13:19:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2B3B41150CB
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 13:19:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 21AE818539; Tue, 30 Jul 2019 13:19:50 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 21ACEC15D;
        Tue, 30 Jul 2019 13:19:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 30 Jul 2019 13:19:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [47.60.32.83])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id BC4A54265A32;
        Tue, 30 Jul 2019 13:19:47 +0200 (CEST)
Date:   Tue, 30 Jul 2019 13:19:44 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     wenxu@ucloud.cn, jiri@resnulli.us, marcelo.leitner@gmail.com,
        saeedm@mellanox.com, gerlitz.or@gmail.com, paulb@mellanox.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: map basechain priority to
 hardware priority
Message-ID: <20190730111944.fwztgrmcf26bz5lv@salvia>
References: <20190730105417.14538-1-pablo@netfilter.org>
 <20190730111800.yhtd5pgd32wyfilt@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730111800.yhtd5pgd32wyfilt@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 01:18:00PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Jul 30, 2019 at 12:54:17PM +0200, Pablo Neira Ayuso wrote:
> [...]
> > @@ -180,6 +181,29 @@ static int nft_setup_cb_call(struct nft_base_chain *basechain,
> >  	return 0;
> >  }
> >  
> > +/* Available priorities for hardware offload range: -8192..8191 */
> > +#define NFT_BASECHAIN_OFFLOAD_PRIO_MAX		(SHRT_MAX / 4)
> > +#define NFT_BASECHAIN_OFFLOAD_PRIO_MIN		(SHRT_MIN / 4)
> > +#define NFT_BASECHAIN_OFFLOAD_PRIO_RANGE	(USHRT_MAX / 4)
> > +/* tcf_auto_prio() uses 0xC000 as base, then subtract one for each new chain. */
> > +#define NFT_BASECHAIN_OFFLOAD_HW_PRIO_BASE	(0xC000 + 1)
> > +
> > +u16 nft_chain_offload_priority(struct nft_base_chain *basechain)
> > +{
> > +	u16 prio;
> > +
> > +	if (basechain->ops.priority < NFT_BASECHAIN_OFFLOAD_PRIO_MIN ||
> > +	    basechain->ops.priority > NFT_BASECHAIN_OFFLOAD_PRIO_MAX)
> > +		return 0;
> > +
> > +	/* map netfilter chain priority to hardware priority. */
> > +	prio = basechain->ops.priority +
> > +		NFT_BASECHAIN_OFFLOAD_PRIO_MAX +
> > +			NFT_BASECHAIN_OFFLOAD_HW_PRIO_BASE;
> > +
> > +	return prio;
> 
> This function should actually return:
> 
>         return prio << 16;

Better shift it from here:

static void nft_flow_offload_common_init(struct flow_cls_common_offload *common,
                                         __be16 proto, int priority,
                                         struct netlink_ext_ack *extack)
{
        common->protocol = proto;
        common->prio = priority << 16;
        common->extack = extack;
}

Drivers assume tc handle format.
