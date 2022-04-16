Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1015034AA
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 09:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiDPHkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 03:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiDPHkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 03:40:09 -0400
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5F9E2F62;
        Sat, 16 Apr 2022 00:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=uNkcqohuYyDBM1uM8iaZqasZVYq+vCj2MnEBhaavjiY=;
  b=bOUyhMkbovFHP9ui92W3xjlOSSKS64CpFVNDtR89Nmez9b4juIshm7jM
   bAyEtarlAiappoWHYePSBzNVBnqw5DCwZR3eZH4PANIg+Jn37/dQjcT3e
   FnpCMCeSQ3EgRk62JPUxZH/B4NdzZ2OsN85Qra3OCLMiZKbNUraCR168V
   I=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=julia.lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.90,264,1643670000"; 
   d="scan'208";a="11683753"
Received: from 203.107.68.85.rev.sfr.net (HELO hadrien) ([85.68.107.203])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2022 09:37:34 +0200
Date:   Sat, 16 Apr 2022 09:37:33 +0200 (CEST)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: jll@hadrien
To:     Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
cc:     outreachy@lists.linux.dev, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ira.weiny@intel.com
Subject: Re: [PATCH] intel: igb: igb_ethtool.c: Convert kmap() to
 kmap_local_page()
In-Reply-To: <20220415205307.675650-1-eng.alaamohamedsoliman.am@gmail.com>
Message-ID: <alpine.DEB.2.22.394.2204160937120.3501@hadrien>
References: <20220415205307.675650-1-eng.alaamohamedsoliman.am@gmail.com>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Fri, 15 Apr 2022, Alaa Mohamed wrote:

> The use of kmap() is being deprecated in favor of kmap_local_page()
> where it is feasible.

And why is it feasible here?

julia

>
> With kmap_local_page(), the mapping is per thread, CPU local and not
> globally visible.
>
> Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
> ---
>  drivers/net/ethernet/intel/igb/igb_ethtool.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> index 2a5782063f4c..ba93aa4ae6a0 100644
> --- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
> +++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> @@ -1798,14 +1798,14 @@ static int igb_check_lbtest_frame(struct igb_rx_buffer *rx_buffer,
>
>  	frame_size >>= 1;
>
> -	data = kmap(rx_buffer->page);
> +	data = kmap_local_page(rx_buffer->page);
>
>  	if (data[3] != 0xFF ||
>  	    data[frame_size + 10] != 0xBE ||
>  	    data[frame_size + 12] != 0xAF)
>  		match = false;
>
> -	kunmap(rx_buffer->page);
> +	kunmap_local(rx_buffer->page);
>
>  	return match;
>  }
> --
> 2.35.2
>
>
>
