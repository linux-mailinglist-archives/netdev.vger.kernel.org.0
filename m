Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0A1560597
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 18:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbiF2QQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 12:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232986AbiF2QQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 12:16:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE222FFCB;
        Wed, 29 Jun 2022 09:16:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1843F61C16;
        Wed, 29 Jun 2022 16:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF41C34114;
        Wed, 29 Jun 2022 16:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656519391;
        bh=QHsA81pBDUHzvuOvAqN+uRYkZTWtxw10l0dJ3X9plf8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OzhMK4Q9EOfxzb5clqI2W+RIiztwmDuyBSdfP6q6wStI2ixwegAZVAJkU5SMOsi65
         zOWhnOnG4YiMFmZLtuBi8C46Fged/kXfpCr0tkG3ACZ0DV0X2WOaz96RBjvf2jNSjA
         aPbe+J6eqAM5OFRRdGQgrX8SE6CaaA+opucArTjP+csxDDoJX0M14B1ScWA78gDNSe
         eq+Fi7bh761AZbr+SGpOtGKhUZGxDzb2driAra/g7s22gA70m/FQPeLfqPJ0k5lJnm
         HwMq7GwsULXwZhohd35X9yuDYWS2QagN63xfVH0P98eE6vXgln+ewbur4ynKoN2HRh
         EKDc3dLi5Y4Gg==
Date:   Wed, 29 Jun 2022 09:16:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: Re: [PATCH bpf] xsk: mark napi_id on sendmsg()
Message-ID: <20220629091629.1c241c21@kernel.org>
In-Reply-To: <YrxLTiOIpD44JM7R@boxer>
References: <20220629105752.933839-1-maciej.fijalkowski@intel.com>
        <CAJ+HfNj0FU=DBNdwD3HODbevcP-btoaeCCGCfn2Y5eP2WoEXHA@mail.gmail.com>
        <YrxLTiOIpD44JM7R@boxer>
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

On Wed, 29 Jun 2022 14:53:34 +0200 Maciej Fijalkowski wrote:
> > > +                       __sk_mark_napi_id_once(sk, xs->pool->heads[0].xdp.rxq->napi_id);  
> > 
> > Please hide this hideous pointer chasing in something neater:
> > xsk_pool_get_napi_id() or something.  
> 
> Would it make sense to introduce napi_id to xsk_buff_pool then?
> xp_set_rxq_info() could be setting it. We are sure that napi_id is the
> same for whole pool (each xdp_buff_xsk's rxq info).

Would it be possible to move the marking to when the queue is getting
bound instead of the recv/send paths? 
