Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDA6561FB8
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 17:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236197AbiF3Pw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 11:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiF3Pwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 11:52:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E311393F4;
        Thu, 30 Jun 2022 08:52:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DAF561EDC;
        Thu, 30 Jun 2022 15:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379BEC34115;
        Thu, 30 Jun 2022 15:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656604373;
        bh=3Xebw/jjie/lQtBZVCHkIWVT9AugKulNmXEthxuX/iQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C33igR/ZdLo1+RPlbeYWq4UG6ugew31y62+EfFfkOM7nn/pBEV+UopA5dfUMSuDGx
         CPKJ3fEAK1P8Whq31L3Es5YnJVuFbPp1gnvA5clNxNu1dbBKn1gf9ibNQLAQ3wWMoF
         Yv307UlFM9vkB356x1qPNDDRc6/XpsKRU2HdvT1BK3fekVnr94w4J0yuEvHv5sCwC2
         sdVB6Tqx50kBvMVNuViKqCn4kHgsCEDRE2ESLEn9D4o1vd7d0gzxtl7jDyyv7J41N5
         Lwe6TUf8K4E/XjHTOfzZdKVwFbezBKjk6NOp0bjs4fI5tEpvZSnRfiQ2j9NMb+ILcO
         z8VtU1PXTSBvg==
Date:   Thu, 30 Jun 2022 08:52:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: Re: [PATCH bpf] xsk: mark napi_id on sendmsg()
Message-ID: <20220630085252.51e29049@kernel.org>
In-Reply-To: <Yr2Op9m1xt5gW7Pw@boxer>
References: <20220629105752.933839-1-maciej.fijalkowski@intel.com>
        <CAJ+HfNj0FU=DBNdwD3HODbevcP-btoaeCCGCfn2Y5eP2WoEXHA@mail.gmail.com>
        <YrxLTiOIpD44JM7R@boxer>
        <20220629091629.1c241c21@kernel.org>
        <20220629091707.20d66524@kernel.org>
        <Yr2Op9m1xt5gW7Pw@boxer>
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

On Thu, 30 Jun 2022 13:53:11 +0200 Maciej Fijalkowski wrote:
> > > Would it be possible to move the marking to when the queue is getting
> > > bound instead of the recv/send paths?   
> > 
> > I mean when socket is getting bound.  
> 
> So Bjorn said that it was the design choice to follow the standard
> sockets' approach. I'm including a dirty diff for a discussion which
> allows me to get napi_id at bind() time. But, this works for ice as this
> driver during the XDP prog/XSK pool load only disables the NAPI, so we are
> sure that napi_id stays the same. That might not be the case for other
> AF_XDP ZC enabled drivers though, they might delete the NAPI and this
> approach wouldn't work...or am I missing something?

Possible, but IDK if we're changing anything substantially in that
regard. The existing code already uses sk_mark_napi_id_once() so
if the NAPI ID changes during the lifetime of the socket the user
will be out of luck already. But no strong feelings.

> I'd prefer the diff below though as it simplifies the data path, but I
> can't say if it's safe to do so. We would have to be sure about drivers
> keeping their NAPI struct. This would also allow us to drop napi_id from
> xdp_rxq_info.

