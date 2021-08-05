Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B23D3E1B05
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 20:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241011AbhHESMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 14:12:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239013AbhHESMt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 14:12:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABF7F60F43;
        Thu,  5 Aug 2021 18:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628187155;
        bh=p3jgh7jK/C4VhYgj51TWN+4tV+Kpxd+e+Euwt7iJ+8k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Nbmy1Htd7+FJpa8uHUgsDo+M1Af0j7Fje1ddfPZtMi8xZPbWlR26yCjP4t1ZSU0np
         8TDne6zs6Ot06VDPAG9moGXfQPynyaFQHZvsGX9Y55vjwqRQHqEwzGloXcYMkqcVwa
         eLvgh0xGENrwHEGKoi3DzB3mjA1Z1ZZeBoRjqIk2sA3l2tIy0+NKG3vf1APMFPG9UM
         6iYQgew/I+11rS8uceDG96MhLFK2emEaZ9ie5SdPnNih/hJ64smxkIifIAKMZn+6z2
         bc9khRePRPwp1KErIDIltAfd3JIbNjnZUkTlXdGcDk1J1IhangNPnKXiFRZ8IhLRhr
         skBVsncaskgUg==
Date:   Thu, 5 Aug 2021 13:12:33 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     hch@infradead.org, kw@linux.com, logang@deltatee.com,
        leon@kernel.org, linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V7 9/9] PCI/P2PDMA: Add a 10-Bit Tag check in P2PDMA
Message-ID: <20210805181233.GA1765293@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1628084828-119542-10-git-send-email-liudongdong3@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 04, 2021 at 09:47:08PM +0800, Dongdong Liu wrote:
> Add a 10-Bit Tag check in the P2PDMA code to ensure that a device with
> 10-Bit Tag Requester doesn't interact with a device that does not
> support 10-BIT Tag Completer. Before that happens, the kernel should
> emit a warning. "echo 0 > /sys/bus/pci/devices/.../10bit_tag" to
> disable 10-BIT Tag Requester for PF device.
> "echo 0 > /sys/bus/pci/devices/.../sriov_vf_10bit_tag_ctl" to disable
> 10-BIT Tag Requester for VF device.

s/10-BIT/10-Bit/ several times.

Add blank lines between paragraphs.

> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
> ---
>  drivers/pci/p2pdma.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index 50cdde3..948f2be 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -19,6 +19,7 @@
>  #include <linux/random.h>
>  #include <linux/seq_buf.h>
>  #include <linux/xarray.h>
> +#include "pci.h"
>  
>  enum pci_p2pdma_map_type {
>  	PCI_P2PDMA_MAP_UNKNOWN = 0,
> @@ -410,6 +411,41 @@ static unsigned long map_types_idx(struct pci_dev *client)
>  		(client->bus->number << 8) | client->devfn;
>  }
>  
> +static bool check_10bit_tags_vaild(struct pci_dev *a, struct pci_dev *b,

s/vaild/valid/

Or maybe s/valid/safe/ or s/valid/supported/, since "valid" isn't
quite the right word here.  We want to know whether the source is
enabled to generate 10-bit tags, and if so, whether the destination
can handle them.

"if (check_10bit_tags_valid())" does not make sense because
"check_10bit_tags_valid()" is not a question with a yes/no answer.

"10bit_tags_valid()" *might* be, because "if (10bit_tags_valid())"
makes sense.  But I don't think you can start with a digit.

Or maybe you want to invert the sense, e.g.,
"10bit_tags_unsupported()", since that avoids negation at the caller:

  if (10bit_tags_unsupported(a, b) ||
      10bit_tags_unsupported(b, a))
        map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;

Doesn't this patch need to be at the very beginning, before you start
enabling 10-bit tags?  Otherwise there's a hole in the middle where we
enable them and P2P DMA might break.

> +				   bool verbose)
> +{
> +	bool req;
> +	bool comp;
> +	u16 ctl2;
> +
> +	if (a->is_virtfn) {
> +#ifdef CONFIG_PCI_IOV
> +		req = !!(a->physfn->sriov->ctrl &
> +			 PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN);
> +#endif
> +	} else {
> +		pcie_capability_read_word(a, PCI_EXP_DEVCTL2, &ctl2);
> +		req = !!(ctl2 & PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
> +	}
> +
> +	comp = !!(b->pcie_devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_COMP);
> +	if (req && (!comp)) {
> +		if (verbose) {
> +			pci_warn(a, "cannot be used for peer-to-peer DMA as 10-Bit Tag Requester enable is set in device (%s), but peer device (%s) does not support the 10-Bit Tag Completer\n",
> +				 pci_name(a), pci_name(b));

No point in printing pci_name(a) twice.  pci_warn() prints it already;
that should be enough.

I think you can simplify this a little, e.g.,

  if (!req)           /* 10-bit tags not enabled on requester */
    return true;

  if (comp)           /* completer can handle anything */
    return true;

  /* error case */
  if (!verbose)
    return false;

  pci_warn(...);
  return false;

> +			if (a->is_virtfn)
> +				pci_warn(a, "to disable 10-Bit Tag Requester for this device, echo 0 > /sys/bus/pci/devices/%s/sriov_vf_10bit_tag_ctl\n",
> +					 pci_name(a));
> +			else
> +				pci_warn(a, "to disable 10-Bit Tag Requester for this device, echo 0 > /sys/bus/pci/devices/%s/10bit_tag\n",
> +					 pci_name(a));
> +		}
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
>  /*
>   * Calculate the P2PDMA mapping type and distance between two PCI devices.
>   *
> @@ -532,6 +568,10 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
>  		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
>  	}
>  done:
> +	if (!check_10bit_tags_vaild(client, provider, verbose) ||
> +	    !check_10bit_tags_vaild(provider, client, verbose))
> +		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
> +
>  	rcu_read_lock();
>  	p2pdma = rcu_dereference(provider->p2pdma);
>  	if (p2pdma)
> -- 
> 2.7.4
> 
