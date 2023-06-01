Return-Path: <netdev+bounces-7015-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DF1C71931C
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:22:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B50BC28160B
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 06:22:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7D25BA46;
	Thu,  1 Jun 2023 06:22:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E842916
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 06:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A27C433D2;
	Thu,  1 Jun 2023 06:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685600561;
	bh=t/kfDGqhvcdG8HbF79I+XToz9/TXvkv5rToe/njpNMw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=n3G3ocVrbERzhQz9AvfuZi0PxH/ARsdsrlVoENb9viHVswd9e8xLyvIcey63mBsDk
	 6WkzTHetgMWlbCGq8WZxGUEy7wOueNOW92n1IfNt0TcIJwe85x+UGy+oZ2Xo+djg6M
	 +7J2G+6erhl9vJpntxKkuD7qQVhqfVlUWao82sfV/BwzN2Pxj4Eh81Q7i6h13FXVxB
	 qpIkilqNKYJIvbq+zDzL4wQuH/67e+O4U6IMlVkYh9DLinhpPzsEjTjZ4E6JQsJhJv
	 whleYNgPz4WA9lHxf61VmFX9xMe3qyvWX+yI42ox4NB0lty3792YJj3ZgP14mgFRmi
	 JXM9grfSuol1w==
Date: Wed, 31 May 2023 23:22:39 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 netdev@vger.kernel.org, Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
 emil.s.tantilov@intel.com, jesse.brandeburg@intel.com,
 sridhar.samudrala@intel.com, shiraz.saleem@intel.com,
 sindhu.devale@intel.com, willemb@google.com, decot@google.com,
 andrew@lunn.ch, leon@kernel.org, mst@redhat.com, simon.horman@corigine.com,
 shannon.nelson@amd.com, stephen@networkplumber.org, Alan Brady
 <alan.brady@intel.com>, Joshua Hay <joshua.a.hay@intel.com>, Madhu Chittim
 <madhu.chittim@intel.com>, Phani Burra <phani.r.burra@intel.com>,
 Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>, Krishneil Singh
 <krishneil.k.singh@intel.com>
Subject: Re: [PATCH net-next 05/15] idpf: add create vport and netdev
 configuration
Message-ID: <20230531232239.5db93c09@kernel.org>
In-Reply-To: <20230530234501.2680230-6-anthony.l.nguyen@intel.com>
References: <20230530234501.2680230-1-anthony.l.nguyen@intel.com>
	<20230530234501.2680230-6-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 30 May 2023 16:44:51 -0700 Tony Nguyen wrote:
> @@ -137,8 +210,12 @@ static int idpf_set_msg_pending_bit(struct idpf_adapter *adapter,
>  	 * previous message.
>  	 */
>  	while (retries) {
> -		if (!test_and_set_bit(IDPF_VC_MSG_PENDING, adapter->flags))
> +		if ((vport && !test_and_set_bit(IDPF_VPORT_VC_MSG_PENDING,
> +						vport->flags)) ||
> +		    (!vport && !test_and_set_bit(IDPF_VC_MSG_PENDING,
> +						 adapter->flags)))
>  			break;
> +
>  		msleep(20);
>  		retries--;
>  	}

Please use locks. Every single Intel driver comes with gazillion flags
and endless bugs when the flags go out of sync.
-- 
pw-bot: cr

