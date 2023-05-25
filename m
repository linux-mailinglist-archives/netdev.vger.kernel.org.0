Return-Path: <netdev+bounces-5221-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A160F71046D
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 06:53:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4200428129E
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 04:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9646C199;
	Thu, 25 May 2023 04:53:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8205231
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 04:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FCAEC433D2;
	Thu, 25 May 2023 04:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684990383;
	bh=08OG7+ZOPN3/hTST2AmqG8lpKu/ihy7EGEgZ23Qf0vg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PraZnmgMWimcVEz1+c2vcTykPjcmFVcemHyrSMf9vae1ybEhnvEINmuxh/k0rpSEs
	 dIq84ZzKWKg6+wbQDtRcPLV5wQap7qA+UH8wi4MrdfPkrLjlCM0I4XDVSdSGE5nuQf
	 DhsijO9NqdBkKnXn5ipeUcJraLJqj/lCqToM9K9G8YBEYkM0KiWAdPh6XnRnm2LUdH
	 vp/AO27UkHvARdwB1g/DoK4aYpRmxaamuhDY85Q63wRNn428jUQiGPJYsAeS2CkL9/
	 +kgAIXJDt/GRNqbfupRyCkFlsWLtP0YmV/sTXTM1euoIbeV+sSTM3umdZfv4QPcJge
	 6aCm8DRh8u3ew==
Date: Wed, 24 May 2023 21:53:01 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, leon@kernel.org, saeedm@nvidia.com, moshe@nvidia.com,
 jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com, tariqt@nvidia.com,
 idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
 ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
 michal.wilczynski@intel.com, jacob.e.keller@intel.com
Subject: Re: [patch net-next 05/15] devlink: move port_split/unsplit() ops
 into devlink_port_ops
Message-ID: <20230524215301.02ae701e@kernel.org>
In-Reply-To: <20230524121836.2070879-6-jiri@resnulli.us>
References: <20230524121836.2070879-1-jiri@resnulli.us>
	<20230524121836.2070879-6-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 May 2023 14:18:26 +0200 Jiri Pirko wrote:
>  /**
>   * struct devlink_port_ops - Port operations
> + * @port_split: Callback used to split the port into multiple ones.
> + * @port_unsplit: Callback used to unsplit the port group back into
> + *		  a single port.
>   */
>  struct devlink_port_ops {
> +	int (*port_split)(struct devlink *devlink, struct devlink_port *port,
> +			  unsigned int count, struct netlink_ext_ack *extack);
> +	int (*port_unsplit)(struct devlink *devlink, struct devlink_port *port,
> +			    struct netlink_ext_ack *extack);
>  };

Two random take it or leave it comments: (1) since these are port ops
now do they need the port_* prefix? (2) I've become partial to adding
the kdoc inline in op structs:

/**
 * struct x - it is the X struct
 */
struct x {
	/** @an_op: its an op */
	int (*an_op)(int arg);
};

I think it's because every time I look at struct net_device_ops 
a little part of me gives up.

