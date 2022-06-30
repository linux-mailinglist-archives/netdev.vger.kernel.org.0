Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B92561F3C
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 17:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235292AbiF3P1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 11:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235827AbiF3P1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 11:27:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751313DDDB;
        Thu, 30 Jun 2022 08:27:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 136AEB82B69;
        Thu, 30 Jun 2022 15:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D28C341CC;
        Thu, 30 Jun 2022 15:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656602839;
        bh=wog1/sUvgmY6uDLVMsc5jUz7VQVMS6/q4IV5RQlSZxU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N50zFYdNUmPENViZz0U0yp1V2UcC3fjow4sbR8xUscYngRdaJ9pCG9MLm1ba2g2s6
         pc2Ued1VYTPwhJo4VNfeTs3SrVOiESQMSoG/q6QL91RPinHcyS4o9T1hftkNVQX/qI
         d75sseUHdJb2no6U21OozjMKelbaNAgV04x72FsYpPg6qZSuD/mgUE97p9EstCxiIy
         pJK1J34SqJ1cTGGK3uQ+IQ+Ld+jCJCP9EnkXA9iXn24P0liNlSmlq3m/sQ1xOaO34Y
         lP+n7ky5eR1QzvxMer0pJvUUbq8YmRPduT5lJ/4pXSGob3ByyfYXWlsIOdhjU0rgI2
         Tj4s4iA01vIjg==
Date:   Thu, 30 Jun 2022 08:27:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangyu Hua <hbh25y@gmail.com>, jmaloy@redhat.com,
        ying.xue@windriver.com
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        tung.q.nguyen@dektech.com.au, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: tipc: fix possible infoleak in tipc_mon_rcv()
Message-ID: <20220630082718.7df33430@kernel.org>
In-Reply-To: <665de056-6ec1-e4e1-adf9-4df3e35628b7@gmail.com>
References: <20220628083122.26942-1-hbh25y@gmail.com>
        <20220629203118.7bdcc87f@kernel.org>
        <665de056-6ec1-e4e1-adf9-4df3e35628b7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jun 2022 17:19:21 +0800 Hangyu Hua wrote:
> On 2022/6/30 11:31, Jakub Kicinski wrote:
> > On Tue, 28 Jun 2022 16:31:22 +0800 Hangyu Hua wrote:  
> >> dom_bef is use to cache current domain record only if current domain
> >> exists. But when current domain does not exist, dom_bef will still be used
> >> in mon_identify_lost_members. This may lead to an information leak.  
> > 
> > AFAICT applied_bef must be zero if peer->domain was 0, so I don't think
> > mon_identify_lost_members() will do anything.
> >   
> 
> void tipc_mon_rcv(struct net *net, void *data, u16 dlen, u32 addr,
> 		  struct tipc_mon_state *state, int bearer_id)
> {
> ...
> 	if (!dom || (dom->len < new_dlen)) {
> 		kfree(dom);
> 		dom = kmalloc(new_dlen, GFP_ATOMIC);	<--- [1]
> 		peer->domain = dom;
> 		if (!dom)
> 			goto exit;
> 	}
> ...
> }
> 
> peer->domain will be NULL when [1] fails. But there will not change 
> peer->applied to 0. In this case, if tipc_mon_rcv is called again then 
> an information leak will happen.

I see, good analysis! Jon, Xue - is there a reason domain gets wiped
on memory allocation failure? I'd think we should leave the previous
pointer in place instead of freeing it first.
