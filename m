Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0826D4545
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 15:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbjDCNI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 09:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbjDCNI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 09:08:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3938419F;
        Mon,  3 Apr 2023 06:08:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C44DBB81A07;
        Mon,  3 Apr 2023 13:08:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1AFC433EF;
        Mon,  3 Apr 2023 13:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680527303;
        bh=QQTxUTGdfl2Ztb60yGgvlUmp84/pVGnv/ILYlRedlkg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VQ3vON0MBmCCXGo7UbKnYyFIE6gWD+f0Ax644+6crn8Bz/mKqo2Em+FW03147iNqz
         ICHaq6ItTZf209FNa+jQEfYzlRuRHwPejz07/ONMnw0HQqtSAnUZUoNFClBKG5Eor6
         WrdTwIjpS+STtzcHyEY22UFioyiBqWcQRnCHUN2tflgv2FNUAZ05bIYhmWxisfFYzu
         q8Q/EpxkFnguSljFD/6Ch2kZU70ifovO0r6zQFJr3sV5u1vTQ+R6idfsDO46WXdQI3
         rVjJ7YsFu24lq0Ymrj5I5bbncv+EPUtIXOm48ionv7gajI2Hx6BgRkHGA6e6eCfATl
         vIpbsKaw1AaKg==
Date:   Mon, 3 Apr 2023 16:08:20 +0300
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
Message-ID: <20230403130820.GD176342@unreal>
References: <20230329170619.183064-1-saikrishnag@marvell.com>
 <20230329170619.183064-2-saikrishnag@marvell.com>
 <20230330055532.GK831478@unreal>
 <DM6PR18MB2602944D58392C6FB6576BB8CD8E9@DM6PR18MB2602.namprd18.prod.outlook.com>
 <20230330071622.GT831478@unreal>
 <DM6PR18MB26023C300BF91C6A57591252CD8F9@DM6PR18MB2602.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR18MB26023C300BF91C6A57591252CD8F9@DM6PR18MB2602.namprd18.prod.outlook.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 08:56:59AM +0000, Geethasowjanya Akula wrote:
> 
> 
> >-----Original Message-----
> >From: Leon Romanovsky <leon@kernel.org> 
> >Sent: Thursday, March 30, 2023 12:46 PM
> >To: Geethasowjanya Akula <gakula@marvell.com>
> >Cc: Sai Krishna Gajula <saikrishnag@marvell.com>; davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Sunil >Kovvuri Goutham <sgoutham@marvell.com>; richardcochran@gmail.com
> >Subject: Re: [EXT] Re: [net PATCH 1/7] octeontx2-af: Secure APR table update with the lock
> >
> >On Thu, Mar 30, 2023 at 06:56:54AM +0000, Geethasowjanya Akula wrote:
> >> 
> >> >-----Original Message-----
> >> >From: Leon Romanovsky <leon@kernel.org>
> >> >Sent: Thursday, March 30, 2023 11:26 AM
> >> >To: Sai Krishna Gajula <saikrishnag@marvell.com>
> >> >Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org; 
> >> >pabeni@redhat.com; netdev@vger.kernel.org; 
> >> >linux-kernel@vger.kernel.org; Sunil Kovvuri Goutham 
> >> ><sgoutham@marvell.com>; >richardcochran@gmail.com; Geethasowjanya 
> >> >Akula <gakula@marvell.com>
> >> >Subject: [EXT] Re: [net PATCH 1/7] octeontx2-af: Secure APR table 
> >> >update with the lock
> >> 
> >> >External Email
> >> 
> >> >---------------------------------------------------------------------
> >> >- On Wed, Mar 29, 2023 at 10:36:13PM +0530, Sai Krishna wrote:
> >> >> From: Geetha sowjanya <gakula@marvell.com>
> >> >> 
> >> >> APR table contains the lmtst base address of PF/VFs.
> >> >> These entries are updated by the PF/VF during the device probe. Due 
> >> >> to race condition while updating the entries are getting corrupted. 
> >> >> Hence secure the APR table update with the lock.
> >> 
> >> >However, I don't see rsrc_lock in probe path.
> >> >otx2_probe()
> >> >-> cn10k_lmtst_init()
> >> > -> lmt_base/lmstst is updated with and without mbox.lock.
> >> 
> >> >Where did you take rsrc_lock in probe flow?
> >> 
> >> rsrc_lock is initialized in AF driver. PF/VF driver in cn10k_lmtst_init() send a mbox request to AF to update the lmtst table. 
> >> mbox handler in AF takes rsrc_lock to update lmtst table.
> 
> >Can you please present the stack trace of such flow? What are the actual variables/struct rsrc_lock is protecting?
> 
> The lock tries to protect the request and response register at line#73 and line#83 in below function, from getting overwritten when
> Multiple PFs invokes rvu_get_lmtaddr() simultaneously. 
> For example, if PF1 submit the request at line#73 and got permitted before it reads the response at line#80.
> PF2 got scheduled submit the request then the response of PF1 is overwritten by the PF2 response.  
> When PF1 gets reschedule, it reads wrong data.

I see, thanks
