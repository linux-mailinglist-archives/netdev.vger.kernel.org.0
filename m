Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6286B1FC01D
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 22:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729193AbgFPUij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 16:38:39 -0400
Received: from correo.us.es ([193.147.175.20]:42908 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725896AbgFPUii (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 16:38:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 28BF4F2586
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 22:38:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 18B45DA78F
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 22:38:37 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0DBF2DA78D; Tue, 16 Jun 2020 22:38:37 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BF5A4DA722;
        Tue, 16 Jun 2020 22:38:34 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 16 Jun 2020 22:38:34 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A1A25426CCB9;
        Tue, 16 Jun 2020 22:38:34 +0200 (CEST)
Date:   Tue, 16 Jun 2020 22:38:34 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     wenxu <wenxu@ucloud.cn>, netdev@vger.kernel.org,
        davem@davemloft.net, vladbu@mellanox.com
Subject: Re: [PATCH net v3 2/4] flow_offload: fix incorrect cb_priv check for
 flow_block_cb
Message-ID: <20200616203834.GA27394@salvia>
References: <1592277580-5524-1-git-send-email-wenxu@ucloud.cn>
 <1592277580-5524-3-git-send-email-wenxu@ucloud.cn>
 <20200616105123.GA21396@netronome.com>
 <aee3192c-7664-580b-1f37-9003c91f185b@ucloud.cn>
 <20200616143427.GA8084@netronome.com>
 <565dd609-1e20-16f4-f38d-8a0b15816f50@ucloud.cn>
 <20200616154716.GA16382@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200616154716.GA16382@netronome.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 05:47:17PM +0200, Simon Horman wrote:
> On Tue, Jun 16, 2020 at 11:18:16PM +0800, wenxu wrote:
> > 
> > 在 2020/6/16 22:34, Simon Horman 写道:
> > > On Tue, Jun 16, 2020 at 10:20:46PM +0800, wenxu wrote:
> > >> 在 2020/6/16 18:51, Simon Horman 写道:
> > >>> On Tue, Jun 16, 2020 at 11:19:38AM +0800, wenxu@ucloud.cn wrote:
> > >>>> From: wenxu <wenxu@ucloud.cn>
> > >>>>
> > >>>> In the function __flow_block_indr_cleanup, The match stataments
> > >>>> this->cb_priv == cb_priv is always false, the flow_block_cb->cb_priv
> > >>>> is totally different data with the flow_indr_dev->cb_priv.
> > >>>>
> > >>>> Store the representor cb_priv to the flow_block_cb->indr.cb_priv in
> > >>>> the driver.
> > >>>>
> > >>>> Fixes: 1fac52da5942 ("net: flow_offload: consolidate indirect flow_block infrastructure")
> > >>>> Signed-off-by: wenxu <wenxu@ucloud.cn>
> > >>> Hi Wenxu,
> > >>>
> > >>> I wonder if this can be resolved by using the cb_ident field of struct
> > >>> flow_block_cb.
> > >>>
> > >>> I observe that mlx5e_rep_indr_setup_block() seems to be the only call-site
> > >>> where the value of the cb_ident parameter of flow_block_cb_alloc() is
> > >>> per-block rather than per-device. So part of my proposal is to change
> > >>> that.
> > >> I check all the xxdriver_indr_setup_block. It seems all the cb_ident parameter of
> > >>
> > >> flow_block_cb_alloc is per-block. Both in the nfp_flower_setup_indr_tc_block
> > >>
> > >> and bnxt_tc_setup_indr_block.
> > >>
> > >>
> > >> nfp_flower_setup_indr_tc_block:
> > >>
> > >> struct nfp_flower_indr_block_cb_priv *cb_priv;
> > >>
> > >> block_cb = flow_block_cb_alloc(nfp_flower_setup_indr_block_cb,
> > >>                                                cb_priv, cb_priv,
> > >>                                                nfp_flower_setup_indr_tc_release);
> > >>
> > >>
> > >> bnxt_tc_setup_indr_block:
> > >>
> > >> struct bnxt_flower_indr_block_cb_priv *cb_priv;
> > >>
> > >> block_cb = flow_block_cb_alloc(bnxt_tc_setup_indr_block_cb,
> > >>                                                cb_priv, cb_priv,
> > >>                                                bnxt_tc_setup_indr_rel);
> > >>
> > >>
> > >> And the function flow_block_cb_is_busy called in most place. Pass the
> > >>
> > >> parameter as cb_priv but not cb_indent .
> > > Thanks, I see that now. But I still think it would be useful to understand
> > > the purpose of cb_ident. It feels like it would lead to a clean solution
> > > to the problem you have highlighted.
> > 
> > I think The cb_ident means identify.  It is used to identify the each flow block cb.
> > 
> > In the both flow_block_cb_is_busy and flow_block_cb_lookup function check
> > 
> > the block_cb->cb_ident == cb_ident.
> 
> Thanks, I think that I now see what you mean about the different scope of
> cb_ident and your proposal to allow cleanup by flow_indr_dev_unregister().
> 
> I do, however, still wonder if there is a nicer way than reaching into
> the structure and manually setting block_cb->indr.cb_priv
> at each call-site.
> 
> Perhaps a variant of flow_block_cb_alloc() for indirect blocks
> would be nicer?

A follow up patch to add this new variant would be good. Probably
__flow_block_indr_binding() can go away with this new variant to set
up the indirect flow block.
