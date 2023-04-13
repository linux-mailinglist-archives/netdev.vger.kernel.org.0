Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4FEE6E1253
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 18:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbjDMQbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 12:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjDMQbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 12:31:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8C6AF26;
        Thu, 13 Apr 2023 09:31:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF02F63FE7;
        Thu, 13 Apr 2023 16:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6576FC433D2;
        Thu, 13 Apr 2023 16:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681403464;
        bh=ixJOGebRoUo1BEyaLEPH8ePeNJnTnmpcCBkNUL7AClM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F2+T/f6dx5RhPROs62DbPztZ8KbufhYEmZXNWXLzHVV4t6kOsoMy4CUmGMeGqbaOk
         i/S+vNsURoC6GQZFbvwG/3KVlPNQz3Xq6y8rENPgul5rAk7fKq22ruQkpRdXutectA
         7X91fWt9+RL+LCSbB7JaV0N7tFLwSbRDlwk9REzzMyHWh8Mt7lhKjN03b9WEEh1/fM
         26mzi3zXv9q2QjxAGo+3TfcpAAuPBzd8Z7Q0gfCYE3TDY7tNZr1knaBzyvWI3HEo0e
         YzO5IyW6h23YFJ0dWTMLbfZH7ua5ZUR3h8fXIhM83UGV1g1j2X+DsNoChIJpKIId1G
         MyEsliI5pKLxA==
Date:   Thu, 13 Apr 2023 19:30:59 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Long Li <longli@microsoft.com>,
        "ssengar@linux.microsoft.com" <ssengar@linux.microsoft.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3,net-next, 2/4] net: mana: Refactor RX buffer
 allocation code to prepare for various MTU
Message-ID: <20230413163059.GS17993@unreal>
References: <1681334163-31084-1-git-send-email-haiyangz@microsoft.com>
 <1681334163-31084-3-git-send-email-haiyangz@microsoft.com>
 <20230413130428.GO17993@unreal>
 <PH7PR21MB3116194E8F7D56EB434B56A6CA989@PH7PR21MB3116.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR21MB3116194E8F7D56EB434B56A6CA989@PH7PR21MB3116.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 02:03:50PM +0000, Haiyang Zhang wrote:
> 
> 
> > -----Original Message-----
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Thursday, April 13, 2023 9:04 AM
> > To: Haiyang Zhang <haiyangz@microsoft.com>
> > Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; Dexuan Cui
> > <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>; Paul Rosswurm
> > <paulros@microsoft.com>; olaf@aepfle.de; vkuznets@redhat.com;
> > davem@davemloft.net; wei.liu@kernel.org; edumazet@google.com;
> > kuba@kernel.org; pabeni@redhat.com; Long Li <longli@microsoft.com>;
> > ssengar@linux.microsoft.com; linux-rdma@vger.kernel.org;
> > daniel@iogearbox.net; john.fastabend@gmail.com; bpf@vger.kernel.org;
> > ast@kernel.org; Ajay Sharma <sharmaajay@microsoft.com>;
> > hawk@kernel.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH V3,net-next, 2/4] net: mana: Refactor RX buffer allocation
> > code to prepare for various MTU
> > 
> > On Wed, Apr 12, 2023 at 02:16:01PM -0700, Haiyang Zhang wrote:
> > > Move out common buffer allocation code from mana_process_rx_cqe() and
> > > mana_alloc_rx_wqe() to helper functions.
> > > Refactor related variables so they can be changed in one place, and buffer
> > > sizes are in sync.
> > >
> > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> > > ---
> > > V3:
> > > Refectored to multiple patches for readability. Suggested by Jacob Keller.
> > >
> > > V2:
> > > Refectored to multiple patches for readability. Suggested by Yunsheng Lin.
> > >
> > > ---
> > >  drivers/net/ethernet/microsoft/mana/mana_en.c | 154 ++++++++++-------
> > -
> > >  include/net/mana/mana.h                       |   6 +-
> > >  2 files changed, 91 insertions(+), 69 deletions(-)
> > 
> > <...>
> > 
> > > +static void *mana_get_rxfrag(struct mana_rxq *rxq, struct device *dev,
> > > +			     dma_addr_t *da, bool is_napi)
> > > +{
> > > +	struct page *page;
> > > +	void *va;
> > > +
> > > +	/* Reuse XDP dropped page if available */
> > > +	if (rxq->xdp_save_va) {
> > > +		va = rxq->xdp_save_va;
> > > +		rxq->xdp_save_va = NULL;
> > > +	} else {
> > > +		page = dev_alloc_page();
> > 
> > Documentation/networking/page_pool.rst
> >    10 Basic use involves replacing alloc_pages() calls with the
> >    11 page_pool_alloc_pages() call.  Drivers should use
> > page_pool_dev_alloc_pages()
> >    12 replacing dev_alloc_pages().
> > 
> > General question, is this sentence applicable to all new code or only
> > for XDP related paths?
> 
> Quote from the context before that sentence --
> 
> =============
> Page Pool API
> =============
> The page_pool allocator is optimized for the XDP mode that uses one frame
> per-page, but it can fallback on the regular page allocator APIs.
> Basic use involves replacing alloc_pages() calls with the
> page_pool_alloc_pages() call.  Drivers should use page_pool_dev_alloc_pages()
> replacing dev_alloc_pages().
> 
> --unquote
> 
> So the page pool is optimized for the XDP, and that sentence is applicable to drivers
> that have set up page pool for XDP optimization.

"but it can fallback on the regular page allocator APIs."

> static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)  //need a pool been set up
> 
> Back to our mana driver, we don't have page pool setup yet. (will consider in the future)
> So we cannot call page_pool_dev_alloc_pages(pool) in this place yet.

ok, thanks

> 
> Thanks,
> - Haiyang
> 
