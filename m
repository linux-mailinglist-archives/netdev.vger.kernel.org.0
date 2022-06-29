Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45DCD56007B
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 14:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbiF2Mxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 08:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiF2Mxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 08:53:37 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E40917A8E;
        Wed, 29 Jun 2022 05:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656507217; x=1688043217;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=NBFLWofkDnaYU8CY8LB/55jv2/b16mClVdfs49+iIRA=;
  b=CHXuJrSoscC+u878y2OHeU9ILhyQoZkUfRWpQPHkp0efBS6Sh7Hjn/kw
   hVJXQWpoWSoS10L46WE3M6gO8Y3lr9nuqmKrH5de8zIKSx0qBq+oRwWyq
   ufGG34pDvLbGXaXpPPc3y+lGfr/t9G212GdrV7FnseKKNmLuuR8+A7O2R
   /Zt6CiCKDFwmlVe5GTumQSRFzjZ7s5Cw++cmqL8tn935uWkv4FPhK3gs3
   47iHI2+WFpLue0Xqdqc866Ybk/wdXitR8Xn3apZuYKPpgBQOcY2JwDxR5
   LYM1w4e5MgYqcNbp3HVjkj7bHiA/mPIcigI6eOSxejsH83zh70IsIvlpK
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="346014091"
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="346014091"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 05:53:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="588299334"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by orsmga007.jf.intel.com with ESMTP; 29 Jun 2022 05:53:35 -0700
Date:   Wed, 29 Jun 2022 14:53:34 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: Re: [PATCH bpf] xsk: mark napi_id on sendmsg()
Message-ID: <YrxLTiOIpD44JM7R@boxer>
References: <20220629105752.933839-1-maciej.fijalkowski@intel.com>
 <CAJ+HfNj0FU=DBNdwD3HODbevcP-btoaeCCGCfn2Y5eP2WoEXHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ+HfNj0FU=DBNdwD3HODbevcP-btoaeCCGCfn2Y5eP2WoEXHA@mail.gmail.com>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 02:45:11PM +0200, Björn Töpel wrote:
> On Wed, 29 Jun 2022 at 12:58, Maciej Fijalkowski
> <maciej.fijalkowski@intel.com> wrote:
> >
> > When application runs in zero copy busy poll mode and does not receive a
> > single packet but only sends them, it is currently impossible to get
> > into napi_busy_loop() as napi_id is only marked on Rx side in
> > xsk_rcv_check(). In there, napi_id is being taken from xdp_rxq_info
> > carried by xdp_buff. From Tx perspective, we do not have access to it.
> > What we have handy is the xsk pool.
> 
> The fact that the napi_id is not set unless set from the ingress side
> is actually "by design". It's CONFIG_NET_RX_BUSY_POLL after all. I
> followed the semantics of the regular busy-polling sockets. So, I
> wouldn't say it's a fix! The busy-polling in sendmsg is really just
> about "driving the RX busy-polling from another socket syscall".

I just felt that busy polling for txonly apps was broken, hence the
'fixing' flavour. I can send it just as improvement to bpf-next.

> 
> That being said, I definitely see that this is useful for AF_XDP
> sockets, but keep in mind that it sort of changes the behavior from
> regular sockets. And we'll get different behavior for
> copy-mode/zero-copy mode.
> 
> TL;DR, I think it's a good addition. One small nit below:
> 
> > +                       __sk_mark_napi_id_once(sk, xs->pool->heads[0].xdp.rxq->napi_id);
> 
> Please hide this hideous pointer chasing in something neater:
> xsk_pool_get_napi_id() or something.

Would it make sense to introduce napi_id to xsk_buff_pool then?
xp_set_rxq_info() could be setting it. We are sure that napi_id is the
same for whole pool (each xdp_buff_xsk's rxq info).

> 
> 
> Björn
