Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20919264EB4
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgIJTXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:23:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38098 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726680AbgIJTXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:23:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599765784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aO5Uccl5Oi5KJ41E3z0pO/LdRmt1WMvp7bc2MBKi/rk=;
        b=ZZqpL93AbPRIzzo3emmeJlta8cDiRmNqZB1cdATFeS0dmVqA5c1M4ShSoW5vMZGuJAjWOu
        8ckpronCt2lRCHcDLT3RfnwfLR+wrByMRpP3FrA8FQu2c/Gw50JS+BiAhu6U/ud7gAPC3D
        Atq1dIHPCxeqZ1XRFV564GTACMmIBPM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-nH1tbEipMPOnT8j1YMvhfA-1; Thu, 10 Sep 2020 15:23:00 -0400
X-MC-Unique: nH1tbEipMPOnT8j1YMvhfA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 271FC1008550;
        Thu, 10 Sep 2020 19:22:58 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-5.gru2.redhat.com [10.97.112.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CA28360BF4;
        Thu, 10 Sep 2020 19:22:54 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 2E4E541853FD; Thu, 10 Sep 2020 16:22:08 -0300 (-03)
Date:   Thu, 10 Sep 2020 16:22:08 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, frederic@kernel.org,
        sassmann@redhat.com, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jerinj@marvell.com, mathias.nyman@intel.com, jiri@nvidia.com
Subject: Re: [RFC][Patch v1 3/3] PCI: Limit pci_alloc_irq_vectors as per
 housekeeping CPUs
Message-ID: <20200910192208.GA24845@fuller.cnet>
References: <20200909150818.313699-1-nitesh@redhat.com>
 <20200909150818.313699-4-nitesh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909150818.313699-4-nitesh@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 09, 2020 at 11:08:18AM -0400, Nitesh Narayan Lal wrote:
> This patch limits the pci_alloc_irq_vectors max vectors that is passed on
> by the caller based on the available housekeeping CPUs by only using the
> minimum of the two.
> 
> A minimum of the max_vecs passed and available housekeeping CPUs is
> derived to ensure that we don't create excess vectors which can be
> problematic specifically in an RT environment. This is because for an RT
> environment unwanted IRQs are moved to the housekeeping CPUs from
> isolated CPUs to keep the latency overhead to a minimum. If the number of
> housekeeping CPUs are significantly lower than that of the isolated CPUs
> we can run into failures while moving these IRQs to housekeeping due to
> per CPU vector limit.
> 
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>  include/linux/pci.h | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 835530605c0d..750ba927d963 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -38,6 +38,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
>  #include <linux/resource_ext.h>
> +#include <linux/sched/isolation.h>
>  #include <uapi/linux/pci.h>
>  
>  #include <linux/pci_ids.h>
> @@ -1797,6 +1798,21 @@ static inline int
>  pci_alloc_irq_vectors(struct pci_dev *dev, unsigned int min_vecs,
>  		      unsigned int max_vecs, unsigned int flags)
>  {
> +	unsigned int num_housekeeping = num_housekeeping_cpus();
> +	unsigned int num_online = num_online_cpus();
> +
> +	/*
> +	 * Try to be conservative and at max only ask for the same number of
> +	 * vectors as there are housekeeping CPUs. However, skip any
> +	 * modification to the of max vectors in two conditions:
> +	 * 1. If the min_vecs requested are higher than that of the
> +	 *    housekeeping CPUs as we don't want to prevent the initialization
> +	 *    of a device.
> +	 * 2. If there are no isolated CPUs as in this case the driver should
> +	 *    already have taken online CPUs into consideration.
> +	 */
> +	if (min_vecs < num_housekeeping && num_housekeeping != num_online)
> +		max_vecs = min_t(int, max_vecs, num_housekeeping);
>  	return pci_alloc_irq_vectors_affinity(dev, min_vecs, max_vecs, flags,
>  					      NULL);
>  }

If min_vecs > num_housekeeping, for example:

/* PCI MSI/MSIx support */
#define XGBE_MSI_BASE_COUNT     4
#define XGBE_MSI_MIN_COUNT      (XGBE_MSI_BASE_COUNT + 1)

Then the protection fails.

How about reducing max_vecs down to min_vecs, if min_vecs >
num_housekeeping ?


