Return-Path: <netdev+bounces-5256-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B3CE710711
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 10:14:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FCE02814A0
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 08:14:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FAE5C2C1;
	Thu, 25 May 2023 08:14:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED599C137
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C45C433EF;
	Thu, 25 May 2023 08:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685002456;
	bh=fJ0ImxHlk5vtkSx7zFqdK3Q8pgeQQrfYrqrZBkpl6x0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HzV+IGBSfB2AJXqMxyOrPVN+YDwI7XBpRFUjLfKpt3I5I8iED76YS6HRXR2Pf1Piz
	 qiBd5AD/9Ic8ehfMgDhPsqd5tt1HuZB6DPM1RU4ykZHaaH96LxquxIPP1dKE/UQ/an
	 3AzFDZ7rg2rAWOlGwB0GtzPVy3PdBLlf73AreD+gREDQ6t8Iy8bVyvXV4ednlDpWUn
	 zATJSlFd0JzSDggonWR3+DWtOQmnY4DSxl47Pjy3UW49ww14oOedKKhbG4gtTczLVI
	 eNxm0Z9Cn2qS0wo9PUeV9XAcgYq8hWnNKq+QSV7vJ/pmWR6CCe0BZQi1tuAQV8eE2e
	 doJu8VbVukaJA==
Date: Thu, 25 May 2023 10:14:06 +0200
From: Lorenzo Pieralisi <lpieralisi@kernel.org>
To: Dexuan Cui <decui@microsoft.com>
Cc: bhelgaas@google.com, davem@davemloft.net, edumazet@google.com,
	haiyangz@microsoft.com, jakeo@microsoft.com, kuba@kernel.org,
	kw@linux.com, kys@microsoft.com, leon@kernel.org,
	linux-pci@vger.kernel.org, mikelley@microsoft.com,
	pabeni@redhat.com, robh@kernel.org, saeedm@nvidia.com,
	wei.liu@kernel.org, longli@microsoft.com, boqun.feng@gmail.com,
	ssengar@microsoft.com, helgaas@kernel.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
	josete@microsoft.com, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/6] PCI: hv: Fix a race condition bug in
 hv_pci_query_relations()
Message-ID: <ZG8YzuK/5+8iE8He@lpieralisi>
References: <20230420024037.5921-1-decui@microsoft.com>
 <20230420024037.5921-2-decui@microsoft.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420024037.5921-2-decui@microsoft.com>

On Wed, Apr 19, 2023 at 07:40:32PM -0700, Dexuan Cui wrote:
> Fix the longstanding race between hv_pci_query_relations() and
> survey_child_resources() by flushing the workqueue before we exit from
> hv_pci_query_relations().

"Fix the longstanding race" is vague. Please describe the race
succinctly at least to give an idea of what the problem is.

> Fixes: 4daace0d8ce8 ("PCI: hv: Add paravirtual PCI front-end for Microsoft Hyper-V VMs")
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> Cc: stable@vger.kernel.org
> ---
> 
> v2:
>   Removed the "debug code".
>   No change to the patch body.
>   Added Cc:stable
> 
> v3:
>   Added Michael's Reviewed-by.
> 
>  drivers/pci/controller/pci-hyperv.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
> index f33370b756283..b82c7cde19e66 100644
> --- a/drivers/pci/controller/pci-hyperv.c
> +++ b/drivers/pci/controller/pci-hyperv.c
> @@ -3308,6 +3308,19 @@ static int hv_pci_query_relations(struct hv_device *hdev)
>  	if (!ret)
>  		ret = wait_for_response(hdev, &comp);
>  
> +	/*
> +	 * In the case of fast device addition/removal, it's possible that
> +	 * vmbus_sendpacket() or wait_for_response() returns -ENODEV but we
> +	 * already got a PCI_BUS_RELATIONS* message from the host and the
> +	 * channel callback already scheduled a work to hbus->wq, which can be
> +	 * running survey_child_resources() -> complete(&hbus->survey_event),
> +	 * even after hv_pci_query_relations() exits and the stack variable
> +	 * 'comp' is no longer valid. This can cause a strange hang issue

"A strange hang" sounds like we don't understand what's happening, it
does not feel like it is a solid understanding of the issue.

I would remove it - given that you already explain that comp is no
longer valid - that is already a bug that needs fixing.

Acked-by: Lorenzo Pieralisi <lpieralisi@kernel.org>

> +	 * or sometimes a page fault. Flush hbus->wq before we exit from
> +	 * hv_pci_query_relations() to avoid the issues.
> +	 */
> +	flush_workqueue(hbus->wq);
> +
>  	return ret;
>  }
>  
> -- 
> 2.25.1
> 

