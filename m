Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E14211BF9B
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 23:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbfLKWG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 17:06:59 -0500
Received: from correo.us.es ([193.147.175.20]:35928 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726524AbfLKWG6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 17:06:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 738A1508CFF
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 23:06:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 65DE0DA70A
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 23:06:55 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5B789DA703; Wed, 11 Dec 2019 23:06:55 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5E3C7DA70C;
        Wed, 11 Dec 2019 23:06:53 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 11 Dec 2019 23:06:53 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 377154265A5A;
        Wed, 11 Dec 2019 23:06:53 +0100 (CET)
Date:   Wed, 11 Dec 2019 23:06:53 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH nf-next 3/7] netfilter: nft_tunnel: no need to call
 htons() when dumping ports
Message-ID: <20191211220653.skv5habd6fs6abqk@salvia>
References: <cover.1575779993.git.lucien.xin@gmail.com>
 <2c9abbd7ac3b89af9addb550bccb9169f47e39a2.1575779993.git.lucien.xin@gmail.com>
 <20191211215312.ratn33c52e5c4esz@salvia>
 <20191211220637.bsgevf3yx2zq7rcl@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211220637.bsgevf3yx2zq7rcl@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 11:06:37PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Dec 11, 2019 at 10:53:12PM +0100, Pablo Neira Ayuso wrote:
> > On Sun, Dec 08, 2019 at 12:41:33PM +0800, Xin Long wrote:
> > > info->key.tp_src and tp_dst are __be16, when using nla_put_be16()
> > > to dump them, htons() is not needed, so remove it in this patch.
> > > 
> > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > ---
> > >  net/netfilter/nft_tunnel.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
> > > index d9d6c0d..e1184fa 100644
> > > --- a/net/netfilter/nft_tunnel.c
> > > +++ b/net/netfilter/nft_tunnel.c
> > > @@ -502,8 +502,8 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
> > >  static int nft_tunnel_ports_dump(struct sk_buff *skb,
> > >  				 struct ip_tunnel_info *info)
> > >  {
> > > -	if (nla_put_be16(skb, NFTA_TUNNEL_KEY_SPORT, htons(info->key.tp_src)) < 0 ||
> > > -	    nla_put_be16(skb, NFTA_TUNNEL_KEY_DPORT, htons(info->key.tp_dst)) < 0)
> > > +	if (nla_put_be16(skb, NFTA_TUNNEL_KEY_SPORT, info->key.tp_src) < 0 ||
> > > +	    nla_put_be16(skb, NFTA_TUNNEL_KEY_DPORT, info->key.tp_dst) < 0)
> > 
> > info->key.tp_src is already in __be16 as you describe. So I would take
> > this as a consistency fix. I would take this as a fix.
> 
> I mean, I think this is worth fixing it indeed.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
