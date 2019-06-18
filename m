Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5FE4979F
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 04:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbfFRCvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 22:51:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:43168 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725870AbfFRCvM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 22:51:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 08077AE3F;
        Tue, 18 Jun 2019 02:51:11 +0000 (UTC)
Date:   Tue, 18 Jun 2019 11:51:05 +0900
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Manish Chopra <manishc@marvell.com>
Cc:     GR-Linux-NIC-Dev <GR-Linux-NIC-Dev@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] [PATCH net-next 06/16] qlge: Remove useless dma
 synchronization calls
Message-ID: <20190618025105.GA13209@f1>
References: <20190617074858.32467-1-bpoirier@suse.com>
 <20190617074858.32467-6-bpoirier@suse.com>
 <BYAPR18MB2696CEF6D42DAE1E467582ABABEB0@BYAPR18MB2696.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR18MB2696CEF6D42DAE1E467582ABABEB0@BYAPR18MB2696.namprd18.prod.outlook.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/06/17 09:44, Manish Chopra wrote:
[...]
> > --- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
> > +++ b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
> > @@ -1110,9 +1110,6 @@ static void ql_update_lbq(struct ql_adapter *qdev,
> > struct rx_ring *rx_ring)
> >  			dma_unmap_addr_set(lbq_desc, mapaddr, map);
> >  			*lbq_desc->addr = cpu_to_le64(map);
> > 
> > -			pci_dma_sync_single_for_device(qdev->pdev, map,
> > -						       qdev->lbq_buf_size,
> > -						       PCI_DMA_FROMDEVICE);
> >  			clean_idx++;
> >  			if (clean_idx == rx_ring->lbq_len)
> >  				clean_idx = 0;
> > @@ -1598,10 +1595,6 @@ static void ql_process_mac_rx_skb(struct
> > ql_adapter *qdev,
> > 
> >  	skb_put_data(new_skb, skb->data, length);
> > 
> > -	pci_dma_sync_single_for_device(qdev->pdev,
> > -				       dma_unmap_addr(sbq_desc, mapaddr),
> > -				       SMALL_BUF_MAP_SIZE,
> > -				       PCI_DMA_FROMDEVICE);
> 
> This was introduced in commit 2c9a266afefe ("qlge: Fix receive packets drop").
> So hoping that it is fine, the buffer shouldn't be synced for the device back after the synced for CPU call in context of any ownership etc. ?

No, dma_sync_*_for_cpu() and dma_sync_*_for_device() calls don't have to
be paired; they are not like lock acquire and release calls.

In the cases the current patch is concerned with, the cpu does not write
any data for the device in the rx buffers. Therefore, there is no need
for those pci_dma_sync_single_for_device() calls.
