Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876F743D7A9
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 01:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbhJ0Xnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 19:43:51 -0400
Received: from ale.deltatee.com ([204.191.154.188]:33208 "EHLO
        ale.deltatee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbhJ0Xnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 19:43:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:content-disposition;
        bh=ymf1DDMEr6x5YUzHDwlxlOA2t7d2RVDPeGl51n7EakU=; b=eyi52UDn5dqKBhdS7ygg9G4AnX
        JBCYf82oVrxuLjffQ223orxroZMYACAzc771GvAqpIAQBjYHkJkfIIXSXu13GTv9Ch1GeGqoz2i1X
        KUD3O1BhvEprrPdpOG3RcX7Q5gagqV96FRF8vd2BVemvQCib33PFkUU8/V0FsJVZJaDJWLFekhIwH
        J5oYD5BM50miP+ru6RavbaY0cxNIanP8H4++QtqtDsV4sU2ftTf+8A4W/uewnhfwrNDkazJRRdLXK
        an7U7lxmm8hIvSygVFpndkHxi6k2WOtgMrudE7M6QZ4NTeyiYkUHsavPw2MroKxvDfOyZkdEANRYP
        OdyvWRjg==;
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1mfsXe-000p3N-RQ; Wed, 27 Oct 2021 17:41:12 -0600
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Dongdong Liu <liudongdong3@huawei.com>
Cc:     hch@infradead.org, kw@linux.com, leon@kernel.org,
        linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
References: <20211027231134.GA258571@bhelgaas>
From:   Logan Gunthorpe <logang@deltatee.com>
Message-ID: <136155cc-d28c-ef36-c69b-557f7af456be@deltatee.com>
Date:   Wed, 27 Oct 2021 17:41:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211027231134.GA258571@bhelgaas>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: netdev@vger.kernel.org, linux-media@vger.kernel.org, hverkuil-cisco@xs4all.nl, rajur@chelsio.com, linux-pci@vger.kernel.org, leon@kernel.org, kw@linux.com, hch@infradead.org, liudongdong3@huawei.com, helgaas@kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on ale.deltatee.com
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A autolearn=ham autolearn_force=no version=3.4.6
Subject: Re: [PATCH V10 6/8] PCI/P2PDMA: Add a 10-Bit Tag check in P2PDMA
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-10-27 5:11 p.m., Bjorn Helgaas wrote:
>> @@ -532,6 +577,9 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
>>  		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
>>  	}
>>  done:
>> +	if (pci_10bit_tags_unsupported(client, provider, verbose))
>> +		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
> 
> I need to be convinced that this check is in the right spot to catch
> all potential P2PDMA situations.  The pci_p2pmem_find() and
> pci_p2pdma_distance() interfaces eventually call
> calc_map_type_and_dist().  But those interfaces don't actually produce
> DMA bus addresses, and I'm not convinced that all P2PDMA users use
> them.
> 
> nvme *does* use them, but infiniband (rdma_rw_map_sg()) does not, and
> it calls pci_p2pdma_map_sg().

The rules of the current code is that calc_map_type_and_dist() must be
called before pci_p2pdma_map_sg(). The calc function caches the mapping
type in an xarray. If it was not called ahead of time,
pci_p2pdma_map_type() will return PCI_P2PDMA_MAP_NOT_SUPPORTED, and the
WARN_ON_ONCE will be hit in
pci_p2pdma_map_sg_attrs().

Both NVMe and RDMA (only used in the nvme fabrics code) do the correct
thing here and we can be sure calc_map_type_and_dist() is called before
any pages are mapped.

The patch set I'm currently working on will ensure that
calc_map_type_and_dist() is called before anyone maps a PCI P2PDMA page
with dma_map_sg*().

> amdgpu_dma_buf_attach() calls pci_p2pdma_distance_many() but I don't
> know where it sets up P2PDMA transactions.

The amdgpu driver hacked this in before proper support was done, but at
least it's using pci_p2pdma_distance_many() presumably before trying any
transfer. Though it's likely broken as it doesn't take into account the
mapping type and thus I think it always assumes traffic goes through the
host bridge (seeing it doesn't use pci_p2pdma_map_sg()).

> cxgb4 and qed mention "peer2peer", but I don't know whether they are
> related; they don't seem to use any pci_p2p.* interfaces.

I'm really not sure what these drivers are doing at all. However, I
think this is unrelated based on this old patch description[1]:

  Open MPI, Intel MPI and other applications don't support the iWARP
  requirement that the client side send the first RDMA message. This
  class of application connection setup is called peer-2-peer. Typically
  once the connection is setup, _both_ sides want to send data.

  This patch enables supporting peer-2-peer over the chelsio rnic by
  enforcing this iWARP requirement in the driver itself as part of RDMA
  connection setup.

Logan

[1] http://lkml.iu.edu/hypermail/linux/kernel/0804.3/1416.html
