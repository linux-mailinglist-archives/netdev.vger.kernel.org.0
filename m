Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A32E6CFC86
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 09:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbjC3HQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 03:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjC3HQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 03:16:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB99D1728;
        Thu, 30 Mar 2023 00:16:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5366261F1C;
        Thu, 30 Mar 2023 07:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35ECFC433D2;
        Thu, 30 Mar 2023 07:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680160586;
        bh=oojLgiaVcfuAYZRU9pqmGjZf1M3QVgXBqhbyZ95UcsE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uFIr5remErCNZgbhvRNujMBycdwb9ygbHx7J5Wt7yI3xW5slKa5DhSGgU2LuSsL+A
         qFw5y3dpTA3S3sXkyzbbHzdGpA/VVHPVW001dau3ms0gbQexu+lsWTBGxYBHmWOkvI
         +fIWA2d67to4wpJRWv9t9WT6xqMUAG35yfkNmyjv5YAxP9NWlt9f4lHSlKBfX4AP08
         xJLzhOiyeRNmhBwcUuzRucY/yieZh/SMukWd6p05ph5cS5GBUvRRV6Twq1gmnkdilp
         kAlMa8DTDMM8YX2qzTzp9uC5NrwCQhV3ezvMPvRgU6KXBP0MxFW4Np6iPP6Snq5UAc
         QiLXE4clz3Aiw==
Date:   Thu, 30 Mar 2023 10:16:22 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Geethasowjanya Akula <gakula@marvell.com>
Cc:     Sai Krishna Gajula <saikrishnag@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
Subject: Re: [EXT] Re: [net PATCH 1/7] octeontx2-af: Secure APR table update
 with the lock
Message-ID: <20230330071622.GT831478@unreal>
References: <20230329170619.183064-1-saikrishnag@marvell.com>
 <20230329170619.183064-2-saikrishnag@marvell.com>
 <20230330055532.GK831478@unreal>
 <DM6PR18MB2602944D58392C6FB6576BB8CD8E9@DM6PR18MB2602.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR18MB2602944D58392C6FB6576BB8CD8E9@DM6PR18MB2602.namprd18.prod.outlook.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 06:56:54AM +0000, Geethasowjanya Akula wrote:
> 
> >-----Original Message-----
> >From: Leon Romanovsky <leon@kernel.org> 
> >Sent: Thursday, March 30, 2023 11:26 AM
> >To: Sai Krishna Gajula <saikrishnag@marvell.com>
> >Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Sunil Kovvuri Goutham <sgoutham@marvell.com>; >richardcochran@gmail.com; Geethasowjanya Akula <gakula@marvell.com>
> >Subject: [EXT] Re: [net PATCH 1/7] octeontx2-af: Secure APR table update with the lock
> 
> >External Email
> 
> >----------------------------------------------------------------------
> >On Wed, Mar 29, 2023 at 10:36:13PM +0530, Sai Krishna wrote:
> >> From: Geetha sowjanya <gakula@marvell.com>
> >> 
> >> APR table contains the lmtst base address of PF/VFs.
> >> These entries are updated by the PF/VF during the device probe. Due to 
> >> race condition while updating the entries are getting corrupted. Hence 
> >> secure the APR table update with the lock.
> 
> >However, I don't see rsrc_lock in probe path.
> >otx2_probe()
> >-> cn10k_lmtst_init()
> > -> lmt_base/lmstst is updated with and without mbox.lock.
> 
> >Where did you take rsrc_lock in probe flow?
> 
> rsrc_lock is initialized in AF driver. PF/VF driver in cn10k_lmtst_init() send a mbox request to AF to update the lmtst table. 
> mbox handler in AF takes rsrc_lock to update lmtst table.

Can you please present the stack trace of such flow? What are the actual variables/struct rsrc_lock
is protecting?

Thanks

> 
> Thanks,
> Geetha.
> 
> >Thanks
> 
> >> 
> >> Fixes: 893ae97214c3 ("octeontx2-af: cn10k: Support configurable LMTST 
> >> regions")
> >> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> >> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> >> Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
> >> ---
> >>  drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c | 8 +++++---
> >>  1 file changed, 5 insertions(+), 3 deletions(-)
> >> 
> >> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c 
> >> b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
> >> index 4ad9ff025c96..8530250f6fba 100644
> >> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
> >> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
> >> @@ -142,16 +142,17 @@ int rvu_mbox_handler_lmtst_tbl_setup(struct rvu *rvu,
> >>  	 * region, if so, convert that IOVA to physical address and
> >>  	 * populate LMT table with that address
> >>  	 */
> >> +	mutex_lock(&rvu->rsrc_lock);
> >>  	if (req->use_local_lmt_region) {
> >>  		err = rvu_get_lmtaddr(rvu, req->hdr.pcifunc,
> >>  				      req->lmt_iova, &lmt_addr);
> >>  		if (err < 0)
> >> -			return err;
> >> +			goto error;
> >>  
> >>  		/* Update the lmt addr for this PFFUNC in the LMT table */
> >>  		err = rvu_update_lmtaddr(rvu, req->hdr.pcifunc, lmt_addr);
> >>  		if (err)
> >> -			return err;
> >> +			goto error;
> >>  	}
> >>  
> >>  	/* Reconfiguring lmtst map table in lmt region shared mode i.e. make 
> >> @@ -181,7 +182,7 @@ int rvu_mbox_handler_lmtst_tbl_setup(struct rvu *rvu,
> >>  		 */
> >>  		err = rvu_update_lmtaddr(rvu, req->hdr.pcifunc, val);
> >>  		if (err)
> >> -			return err;
> >> +			goto error;
> >>  	}
> >>  
> >>  	/* This mailbox can also be used to update word1 of 
> >> APR_LMT_MAP_ENTRY_S @@ -230,6 +231,7 @@ int rvu_mbox_handler_lmtst_tbl_setup(struct rvu *rvu,
> >>  	}
> >>  
> >>  error:
> >> +	mutex_unlock(&rvu->rsrc_lock);
> >>  	return err;
> >>  }
> >>  
> >> --
> >> 2.25.1
> >> 
