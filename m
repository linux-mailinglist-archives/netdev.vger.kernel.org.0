Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0803E0AD3
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 01:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbhHDX3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 19:29:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhHDX3v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 19:29:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FCF7610A8;
        Wed,  4 Aug 2021 23:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628119778;
        bh=P7SfHN5MwK2Yea8Mc759NMWkYnjT904mx+vUrokN1a8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Q9U2DkxKEneNMWJ5Tmj9LPqrkqsO3wF4kpNF9J2nfUOLywTdYD/xGpi06VzymtoJm
         fM8XXIHtcJReWSwiMlKCDbUsLlfGrP9j2qq5R8wRJMCcYyTIMqICIBCUPgq73gdDGJ
         24aUqtu3ytmzevHZmLvot7PipvxVTPqse3CBUnlaZ/KKSQgzJHBcDWPS1am7Nbzcm1
         QhXkX7kLUkZnMW/byJH3F739Gsu2fVRRQ1aaeSVynQCbwGEtLluhYHzWZ/p2gHFYJt
         c+j55UAw2IjfQD0YpaDtkMXhe/v1MqWggvfee9tNlqG82X+HxBf8uxNz9/LnUSAM7T
         TB7fPwvci8PSg==
Date:   Wed, 4 Aug 2021 18:29:37 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     hch@infradead.org, kw@linux.com, logang@deltatee.com,
        leon@kernel.org, linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V7 5/9] PCI/IOV: Enable 10-Bit tag support for PCIe VF
 devices
Message-ID: <20210804232937.GA1691653@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1628084828-119542-6-git-send-email-liudongdong3@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 04, 2021 at 09:47:04PM +0800, Dongdong Liu wrote:
> Enable VF 10-Bit Tag Requester when it's upstream component support
> 10-bit Tag Completer.

s/it's/its/
s/support/supports/

I think "upstream component" here means the PF, doesn't it?  I don't
think the PF is really an *upstream* component; there's no routing
like with a switch.

> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/pci/iov.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> index dafdc65..0d0bed1 100644
> --- a/drivers/pci/iov.c
> +++ b/drivers/pci/iov.c
> @@ -634,6 +634,10 @@ static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
>  
>  	pci_iov_set_numvfs(dev, nr_virtfn);
>  	iov->ctrl |= PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE;
> +	if ((iov->cap & PCI_SRIOV_CAP_VF_10BIT_TAG_REQ) &&
> +	    dev->ext_10bit_tag)
> +		iov->ctrl |= PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN;
> +
>  	pci_cfg_access_lock(dev);
>  	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
>  	msleep(100);
> @@ -650,6 +654,8 @@ static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
>  
>  err_pcibios:
>  	iov->ctrl &= ~(PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE);
> +	if (iov->ctrl & PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN)
> +		iov->ctrl &= ~PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN;
>  	pci_cfg_access_lock(dev);
>  	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
>  	ssleep(1);
> @@ -682,6 +688,8 @@ static void sriov_disable(struct pci_dev *dev)
>  
>  	sriov_del_vfs(dev);
>  	iov->ctrl &= ~(PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE);
> +	if (iov->ctrl & PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN)
> +		iov->ctrl &= ~PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN;

You can just clear PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN unconditionally,
can't you?  I know it wouldn't change anything, but removing the "if"
makes the code prettier.  You could just add it in the existing
PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE mask.

>  	pci_cfg_access_lock(dev);
>  	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
>  	ssleep(1);
> -- 
> 2.7.4
> 
