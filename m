Return-Path: <netdev+bounces-9941-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F29A72B359
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 19:54:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2FDC281175
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 17:54:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05C2EFBFA;
	Sun, 11 Jun 2023 17:54:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A85523E
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 17:54:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7E4C433D2;
	Sun, 11 Jun 2023 17:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686506073;
	bh=FIK+5wsUU9t3BFkKsm/5vZ/HOghaKtyHKTjK0WuleKk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=skCsgF7vKz/EFpanb7Kdrf58lstCDyFr7VNrPVSa+XdUhYnOiOGfL4S9LviFtkFH+
	 ZDxxJSWEYbLwpRPKo+yKk8wWoKDdiq5dUV+YsA2B4sJqQG1O7c2OHzvQUOUNwxaJOo
	 Nw8jJfv5fqwO27mWiHCqJ4WPy46vTQCNc/I+9qquUx/T4j4wa8TQZkMuJP/E7YEi4n
	 kWDkgjufYe9bAKRjD2fY7pD7d8EPrt/DQzBWU+W9jhZRiRqxXeWGyEwRV3uS90GWKp
	 Wu4xsP3m/gjLG19Y/D/2Sw6Ip7ld3JcTvsKK0iMJU4TxTykYSr+yJIshIJLKaCyonv
	 vABiuN7TEqsvg==
Date: Sun, 11 Jun 2023 20:54:29 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
	kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
	netdev@vger.kernel.org, Phani Burra <phani.r.burra@intel.com>,
	pavan.kumar.linga@intel.com, emil.s.tantilov@intel.com,
	sridhar.samudrala@intel.com, shiraz.saleem@intel.com,
	sindhu.devale@intel.com, willemb@google.com, decot@google.com,
	andrew@lunn.ch, simon.horman@corigine.com, shannon.nelson@amd.com,
	stephen@networkplumber.org, Alan Brady <alan.brady@intel.com>,
	Madhu Chittim <madhu.chittim@intel.com>,
	Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>,
	Krishneil Singh <krishneil.k.singh@intel.com>
Subject: Re: [PATCH net-next 02/15] idpf: add module register and probe
 functionality
Message-ID: <20230611175429.GH12152@unreal>
References: <20230530234501.2680230-1-anthony.l.nguyen@intel.com>
 <20230530234501.2680230-3-anthony.l.nguyen@intel.com>
 <20230531015711-mutt-send-email-mst@kernel.org>
 <95b50b5a-4c76-ac02-37ae-afa176b4ea62@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95b50b5a-4c76-ac02-37ae-afa176b4ea62@intel.com>

On Wed, May 31, 2023 at 11:34:23AM -0700, Jesse Brandeburg wrote:
> On 5/30/2023 11:05 PM, Michael S. Tsirkin wrote:
> > On Tue, May 30, 2023 at 04:44:48PM -0700, Tony Nguyen wrote:
> >> From: Phani Burra <phani.r.burra@intel.com>
> ...
> 
> >> diff --git a/drivers/net/ethernet/intel/idpf/idpf_main.c b/drivers/net/ethernet/intel/idpf/idpf_main.c
> >> new file mode 100644
> >> index 000000000000..e290f560ce14
> >> --- /dev/null
> >> +++ b/drivers/net/ethernet/intel/idpf/idpf_main.c
> >> @@ -0,0 +1,136 @@
> >> +// SPDX-License-Identifier: GPL-2.0-only
> >> +/* Copyright (C) 2023 Intel Corporation */
> >> +
> >> +#include "idpf.h"
> >> +#include "idpf_devids.h"
> >> +
> >> +#define DRV_SUMMARY	"Infrastructure Data Path Function Linux Driver"
> > 
> > Do you want to stick Intel(R) here as well?
> 
> That would be ok with me, we'll discuss internally.
> 
> > And did you say you wanted to add a version?
> 
> In-kernel drivers use the kernel version for the MODULE_VERSION field.
> 
> > The point being making it possible to distinguish
> > between this one and the one we'll hopefully have down
> > the road binding to the IDPF class/prog ifc.
> > 
> >> +
> >> +MODULE_DESCRIPTION(DRV_SUMMARY);
> >> +MODULE_LICENSE("GPL");
> Just noticed that we appear to have missed the MODULE_AUTHOR("Intel
> Corporation")

I'm not a lawyer, but company can't be author. It holds copyright to the work.

Thanks

> 
> 
> 

