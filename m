Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 607494F3DD2
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 22:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379160AbiDEUEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389238AbiDEPVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 11:21:12 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B9ECD32F;
        Tue,  5 Apr 2022 06:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649165747; x=1680701747;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fVWz4U1ex/01xYxGZqkQetlyIcjnp+/OvGi5CvLhVO0=;
  b=Jfkjv9YjOLK19xOFnu94DHjUnxoc4bHe9Fpv7G1PKod/gHJMYoifTWJd
   16AeIRhUG8P+tks8RZcPhmmlfHTdYsEO1SeMgXKgiSzKzgh68+rq4HN5v
   sfHKM83p6xlghNhQ5Y54ftSLj44dRrf5jklfU/qY/Sfr6YUg7jVoDbIxW
   Oek53bHYaty11vP1YhQFwuZpuSOQmrjl1DCeHEPqGBPo+4YMV8sZP5vRP
   DnBzkdOkiyiCFtIdxVr2J/mYv6MweOD9410tRi+0diwl8Y8CaP9r5nk20
   s9G2cpLJBR2ElsutBPw17c3nP2IQcwA8dfvoxsePtqxWeKbJbLtcYtoWU
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="241335999"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="241335999"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 06:35:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="556522499"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by fmsmga007.fm.intel.com with ESMTP; 05 Apr 2022 06:35:44 -0700
Date:   Tue, 5 Apr 2022 15:35:44 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        magnus.karlsson@intel.com, bjorn@kernel.org, brouer@redhat.com,
        netdev@vger.kernel.org, maximmi@nvidia.com,
        alexandr.lobakin@intel.com
Subject: Re: [PATCH bpf-next 02/10] xsk: diversify return codes in
 xsk_rcv_check()
Message-ID: <YkxFsMvj1PL2V/II@boxer>
References: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
 <20220405110631.404427-3-maciej.fijalkowski@intel.com>
 <fdc503fa-9ecb-113f-4dd6-774765c3b2ba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fdc503fa-9ecb-113f-4dd6-774765c3b2ba@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 03:00:25PM +0200, Jesper Dangaard Brouer wrote:
> 
> 
> On 05/04/2022 13.06, Maciej Fijalkowski wrote:
> > Inspired by patch that made xdp_do_redirect() return values for XSKMAP
> > more meaningful, return -ENXIO instead of -EINVAL for socket being
> > unbound in xsk_rcv_check() as this is the usual value that is returned
> > for such event. In turn, it is now possible to easily distinguish what
> > went wrong, which is a bit harder when for both cases checked, -EINVAL
> > was returned.
> 
> I like this as it makes it easier to troubleshoot.
> Could you update the description to explain how to debug this easily.
> E.g. via this bpftrace one liner:
> 
> 
>  bpftrace -e 'tracepoint:xdp:xdp_redirect* {@err[-args->err] = count();}'

Nice one! I'll include this in the commit message of v2.

> 
> 
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> 
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> 
> >   net/xdp/xsk.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > index f75e121073e7..040c73345b7c 100644
> > --- a/net/xdp/xsk.c
> > +++ b/net/xdp/xsk.c
> > @@ -217,7 +217,7 @@ static bool xsk_is_bound(struct xdp_sock *xs)
> >   static int xsk_rcv_check(struct xdp_sock *xs, struct xdp_buff *xdp)
> >   {
> >   	if (!xsk_is_bound(xs))
> > -		return -EINVAL;
> > +		return -ENXIO;
> >   	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index)
> >   		return -EINVAL;
> > 
> 
