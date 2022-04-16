Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C719503706
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 16:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbiDPOMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 10:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbiDPOMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 10:12:33 -0400
Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD234BC15;
        Sat, 16 Apr 2022 07:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=QXg79ITIMb+c/YfTxTorJco9Mt6LYRevJ11/hq3FBHM=;
  b=fmJwVTpLkxQYJ84reDMPtf2kdPCy1MxrwZogdslFhrQhcidTftQca1zB
   VDQQHeuEtFCSO4nHYtOSPVwEae3uCetGHZTbhmQlZ770ZtDBtQjqUDskl
   Uvs9Xz7l5HY7zTbYbVLzjJRxg/3NQdnvRz3VJaSidouSlW2874zxBStNj
   4=;
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=julia.lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.90,264,1643670000"; 
   d="scan'208";a="32016200"
Received: from 203.107.68.85.rev.sfr.net (HELO hadrien) ([85.68.107.203])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2022 16:09:58 +0200
Date:   Sat, 16 Apr 2022 16:09:58 +0200 (CEST)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: jll@hadrien
To:     Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
cc:     Julia Lawall <julia.lawall@inria.fr>, outreachy@lists.linux.dev,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ira.weiny@intel.com
Subject: Re: [PATCH v3] intel: igb: igb_ethtool.c: Convert kmap() to
 kmap_local_page()
In-Reply-To: <857a2d22-5d0f-99d6-6686-98d50e4491d5@gmail.com>
Message-ID: <alpine.DEB.2.22.394.2204161608230.3501@hadrien>
References: <20220416111457.5868-1-eng.alaamohamedsoliman.am@gmail.com> <alpine.DEB.2.22.394.2204161331080.3501@hadrien> <857a2d22-5d0f-99d6-6686-98d50e4491d5@gmail.com>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-848588355-1650118198=:3501"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-848588355-1650118198=:3501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Sat, 16 Apr 2022, Alaa Mohamed wrote:

>
> On ١٦/٤/٢٠٢٢ ١٣:٣١, Julia Lawall wrote:
> >
> > On Sat, 16 Apr 2022, Alaa Mohamed wrote:
> >
> > > Convert kmap() to kmap_local_page()
> > >
> > > With kmap_local_page(), the mapping is per thread, CPU local and not
> > > globally visible.
> > It's not clearer.
> I mean this " fix kunmap_local path value to take address of the mapped page"
> be more clearer
> > This is a general statement about the function.  You
> > need to explain why it is appropriate to use it here.  Unless it is the
> > case that all calls to kmap should be converted to call kmap_local_page.
> It's required to convert all calls kmap to kmap_local_page. So, I don't what
> should the commit message be?

If all calls should be changed then you can also say that.

I thought that a previous commit on the outreachy list made some arguments
about how the affacted value was just allocated and thus could not yet be
shared.

julia

>
> Is this will be good :
>
> "kmap_local_page() was recently developed as a replacement for kmap().  The
> kmap_local_page() creates a mapping which is restricted to local use by a
> single thread of execution. "
> >
> > julia
> >
> > > Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
> > > ---
> > > changes in V2:
> > > 	fix kunmap_local path value to take address of the mapped page.
> > > ---
> > > changes in V3:
> > > 	edit commit message to be clearer
> > > ---
> > >   drivers/net/ethernet/intel/igb/igb_ethtool.c | 4 ++--
> > >   1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c
> > > b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> > > index 2a5782063f4c..c14fc871dd41 100644
> > > --- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
> > > +++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> > > @@ -1798,14 +1798,14 @@ static int igb_check_lbtest_frame(struct
> > > igb_rx_buffer *rx_buffer,
> > >
> > >   	frame_size >>= 1;
> > >
> > > -	data = kmap(rx_buffer->page);
> > > +	data = kmap_local_page(rx_buffer->page);
> > >
> > >   	if (data[3] != 0xFF ||
> > >   	    data[frame_size + 10] != 0xBE ||
> > >   	    data[frame_size + 12] != 0xAF)
> > >   		match = false;
> > >
> > > -	kunmap(rx_buffer->page);
> > > +	kunmap_local(data);
> > >
> > >   	return match;
> > >   }
> > > --
> > > 2.35.2
> > >
> > >
> > >
>
--8323329-848588355-1650118198=:3501--
