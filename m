Return-Path: <netdev+bounces-250-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 476556F65F9
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 09:42:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34CC11C20F65
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 07:42:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99ECA1879;
	Thu,  4 May 2023 07:42:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D5510EC
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 07:42:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28755C433EF;
	Thu,  4 May 2023 07:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683186173;
	bh=2L0zac44MHXgdKJc/66VqwktsCPML/CsGW911MW1XYg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m1YTpRgH+RWLsvTSR7Zea7RmFJpCkVIlHEhFJsCTEaBnvZKFaLKoQNSETcYqHHsJM
	 3PZyEoF18NDKzA0bnRF7WrQFuQIGpUVpg/kiy7sbTHAqxsytTim3vEfgpwgo97JSbR
	 xGu0dGX9lTQXR2BxRKO1+01xVWyqx8pyZLz16FyPzk9S+/KegRGeJuMWXJMlNXW+oG
	 l5fBMRf+Md2hJ77cKy9EZprLSgA1ASTki7HL+D2qLtlaywj2+LcPJQDzHOxcYSLAJu
	 SDVJ0ZqBL7B7c6N7NnLhF3wgQ0BmTSPBlstdnszRroFuq+ruHAWblSAJ0snuAGZTtQ
	 yO8ti+fd9+BBQ==
Date: Thu, 4 May 2023 10:42:49 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, netdev@vger.kernel.org,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Sujai Buvaneswaran <Sujai.Buvaneswaran@intel.com>,
	George Kuruvinakunnel <george.kuruvinakunnel@intel.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net] ice: block LAN in case of VF to VF offload
Message-ID: <20230504074249.GQ525452@unreal>
References: <20230503153935.2372898-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230503153935.2372898-1-anthony.l.nguyen@intel.com>

On Wed, May 03, 2023 at 08:39:35AM -0700, Tony Nguyen wrote:
> From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> 
> VF to VF traffic shouldn't go outside. To enforce it, set only the loopback
> enable bit in case of all ingress type rules added via the tc tool.
> 
> Fixes: 0d08a441fb1a ("ice: ndo_setup_tc implementation for PF")
> Reported-by: Sujai Buvaneswaran <Sujai.Buvaneswaran@intel.com>
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_tc_lib.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
> index 76f29a5bf8d7..d1a31f236d26 100644
> --- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
> @@ -693,17 +693,18 @@ ice_eswitch_add_tc_fltr(struct ice_vsi *vsi, struct ice_tc_flower_fltr *fltr)
>  	 * results into order of switch rule evaluation.
>  	 */
>  	rule_info.priority = 7;
> +	rule_info.flags_info.act_valid = true;

Do you still have path where rule_info.flags_info.act_valid = false?

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

