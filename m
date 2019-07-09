Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5640C62DED
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 04:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfGICKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 22:10:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:58058 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725941AbfGICKT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 22:10:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5512FAFF2;
        Tue,  9 Jul 2019 02:10:18 +0000 (UTC)
Date:   Tue, 9 Jul 2019 11:10:11 +0900
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Manish Chopra <manishc@marvell.com>
Cc:     GR-Linux-NIC-Dev <GR-Linux-NIC-Dev@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] [PATCH net-next 07/16] qlge: Deduplicate rx buffer queue
 management
Message-ID: <20190709021011.GA23419@f1>
References: <20190617074858.32467-1-bpoirier@suse.com>
 <20190617074858.32467-7-bpoirier@suse.com>
 <DM6PR18MB2697AC678152A26AC676A1B2ABFD0@DM6PR18MB2697.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR18MB2697AC678152A26AC676A1B2ABFD0@DM6PR18MB2697.namprd18.prod.outlook.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/06/27 10:02, Manish Chopra wrote:
> >  	while (curr_idx != clean_idx) {
> > -		lbq_desc = &rx_ring->lbq[curr_idx];
> > +		struct qlge_bq_desc *lbq_desc = &rx_ring-
> > >lbq.queue[curr_idx];
> > 
> >  		if (lbq_desc->p.pg_chunk.offset == last_offset)
> > -			pci_unmap_page(qdev->pdev, lbq_desc-
> > >p.pg_chunk.map,
> > +			pci_unmap_page(qdev->pdev, lbq_desc->dma_addr,
> >  				       ql_lbq_block_size(qdev),
> >  				       PCI_DMA_FROMDEVICE);
> 
> In this patch, lbq_desc->dma_addr points to offset in the page. So unmapping is broken within this patch.
> Would have been nicer to fix this in the same patch although it might have been taken care in next patches probably.
> 

Indeed, thanks. The same applies in ql_get_curr_lchunk().
Replaced with the following for v2:
+			pci_unmap_page(qdev->pdev, lbq_desc->dma_addr -
+				       last_offset, ql_lbq_block_size(qdev),
