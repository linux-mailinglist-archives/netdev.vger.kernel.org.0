Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28931218717
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 14:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbgGHMTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 08:19:44 -0400
Received: from verein.lst.de ([213.95.11.211]:35029 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728723AbgGHMTo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 08:19:44 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id B235068AFE; Wed,  8 Jul 2020 14:19:40 +0200 (CEST)
Date:   Wed, 8 Jul 2020 14:19:40 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "maximmi@mellanox.com" <maximmi@mellanox.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>
Subject: Re: [PATCH net] xsk: remove cheap_dma optimization
Message-ID: <20200708121940.GA19619@lst.de>
References: <20200626134358.90122-1-bjorn.topel@gmail.com> <c60dfb5a-2bf3-20bd-74b3-6b5e215f73f8@iogearbox.net> <20200627070406.GB11854@lst.de> <88d27e1b-dbda-301c-64ba-2391092e3236@intel.com> <878626a2-6663-0d75-6339-7b3608aa4e42@arm.com> <20200708065014.GA5694@lst.de> <B926444035E5E2439431908E3842AFD255E99A@DGGEMI525-MBS.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B926444035E5E2439431908E3842AFD255E99A@DGGEMI525-MBS.china.huawei.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 08, 2020 at 07:57:23AM +0000, Song Bao Hua (Barry Song) wrote:
> > int dma_map_batch_start(struct device *dev, size_t rounded_len,
> > 	enum dma_data_direction dir, unsigned long attrs, dma_addr_t *addr);
> > int dma_map_batch_add(struct device *dev, dma_addr_t *addr, struct page
> > *page,
> > 		unsigned long offset, size_t size);
> > int dma_map_batch_end(struct device *dev, int ret, dma_addr_t start_addr);
> > 
> 
> Hello Christoph,
> 
> What is the different between dma_map_batch_add() and adding the buffer to sg of dma_map_sg()?

There is not struct scatterlist involved in this API, avoiding the
overhead to allocate it (which is kinda the point).
