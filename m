Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF4A571C05
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 16:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbiGLOPC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 12 Jul 2022 10:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiGLOPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 10:15:01 -0400
Received: from relay4.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5178360681
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 07:15:00 -0700 (PDT)
Received: from omf10.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay09.hostedemail.com (Postfix) with ESMTP id 8EFD83349B;
        Tue, 12 Jul 2022 14:14:58 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf10.hostedemail.com (Postfix) with ESMTPA id 0F8743D;
        Tue, 12 Jul 2022 14:14:55 +0000 (UTC)
Message-ID: <1d6fd2b271dfa0514ccb914c032e362bc4f669fa.camel@perches.com>
Subject: Re: [PATCH v3] staging: qlge: Fix indentation issue under long for
 loop
From:   Joe Perches <joe@perches.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Binyi Han <dantengknight@gmail.com>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Date:   Tue, 12 Jul 2022 07:14:55 -0700
In-Reply-To: <20220712134610.GO2338@kadam>
References: <20220710210418.GA148412@cloud-MacBookPro>
         <20220712134610.GO2338@kadam>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Stat-Signature: xgmszzrqg6ctunmgjqypab8cmkczqtxe
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: 0F8743D
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/Igx7O1NfTBE3jWpvwAE+8H153v3blsy4=
X-HE-Tag: 1657635295-347823
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-07-12 at 16:46 +0300, Dan Carpenter wrote:
> On Sun, Jul 10, 2022 at 02:04:18PM -0700, Binyi Han wrote:
> > Fix indentation issue to adhere to Linux kernel coding style,
> > Issue found by checkpatch. Change the long for loop into 3 lines. And
> > optimize by avoiding the multiplication.
> 
> There is no possible way this optimization helps benchmarks.  Better to
> focus on readability.

I think removing the multiply _improves_ readability.

> > diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
[]
> > @@ -3007,10 +3007,12 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
> >  		tmp = (u64)rx_ring->lbq.base_dma;
> >  		base_indirect_ptr = rx_ring->lbq.base_indirect;
> >  
> > -		for (page_entries = 0; page_entries <
> > -			MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); page_entries++)
> > -				base_indirect_ptr[page_entries] =
> > -					cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
> > +		for (page_entries = 0;
> > +		     page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN);
> > +		     page_entries++) {
> > +			base_indirect_ptr[page_entries] = cpu_to_le64(tmp);
> > +			tmp += DB_PAGE_SIZE;
> 
> I've previously said that using "int i;" is clearer here.  You would
> kind of expect "page_entries" to be the number of entries, so it's kind
> of misleading.  In other words, it's not just harmless wordiness and
> needless exposition, it's actively bad.

Likely true.

> I would probably just put it on one line:
> 
> 		for (i = 0; i MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); i++)
> 			base_indirect_ptr[i] = cpu_to_le64(tmp + (i * DB_PAGE_SIZE));
> 
> But if you want to break it up you could do:
> 
> 		for (i = 0; i MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); i++)
> 			base_indirect_ptr[i] = cpu_to_le64(tmp +
> 							   (i * DB_PAGE_SIZE));
> 
> "tmp" is kind of a bad name.  Also "base_indirect_ptr" would be better
> as "base_indirect".

tmp is a poor name here.  Maybe dma would be better.

MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN) is also a poorly named macro
where all the existing uses are QLGE_BQ_LEN.

And there's base_indirect_ptr and base_indirect_dma in the struct
so just base_indirect might not be the best.

		tmp = (u64)rx_ring->lbq.base_dma;
		base_indirect_ptr = rx_ring->lbq.base_indirect;

And clarity is good.
Though here, clarity to value for effort though is dubious.

btw: this code got moved to staging 3 years ago.

Maybe it's getting closer to removal time.

