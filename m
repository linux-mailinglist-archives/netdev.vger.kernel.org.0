Return-Path: <netdev+bounces-7634-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B6F0720E33
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 08:53:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C2B8281B1D
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 06:53:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F8168F42;
	Sat,  3 Jun 2023 06:52:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3022F53
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 06:52:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7248C433D2;
	Sat,  3 Jun 2023 06:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685775176;
	bh=Dtp7yfw3yIgpqLiDkFokEpEEdCuCwpELzyb1JLQqmrw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TE06WsU3DCFbMrsqZlqF429AXurYRJfP/0Zv2ohSLs8375orVlB58ve3KTVMOKmbS
	 PiSGZynui9JnJg3B0/YZWpIZNRBhfGEOFp5rVJeK0fJRGDREg6nyecUN+4NutKmEQn
	 tWlwAcdAaynyHoVkcXLssxpGSI5ieYElOSfvkBonjBHaFxvZbisr8nwO2ZFMk+7oMs
	 IfxML+cV2NVqDTx8M9FPI+0b+YW1dc3EemFN7SKx7Npi+s7qViK6ohzl9PT3FJneS4
	 JB5fK5J42HHHgWuz4xmEC9Rh2kZXRiWuUndyPJqFmZ9i9kDnfl54QUS0S+KfKmOB+d
	 eVh/BEjikHwZA==
Date: Fri, 2 Jun 2023 23:52:54 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Justin Chen <justin.chen@broadcom.com>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 bcm-kernel-feedback-list@broadcom.com, florian.fainelli@broadcom.com,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
 opendmb@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
 linux@armlinux.org.uk, richardcochran@gmail.com, sumit.semwal@linaro.org,
 christian.koenig@amd.com, simon.horman@corigine.com
Subject: Re: [PATCH net-next v6 3/6] net: bcmasp: Add support for ASP2.0
 Ethernet controller
Message-ID: <20230602235254.61798d80@kernel.org>
In-Reply-To: <1685657551-38291-4-git-send-email-justin.chen@broadcom.com>
References: <1685657551-38291-1-git-send-email-justin.chen@broadcom.com>
	<1685657551-38291-4-git-send-email-justin.chen@broadcom.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  1 Jun 2023 15:12:28 -0700 Justin Chen wrote:
> +	ports_node = of_find_node_by_name(dev->of_node, "ethernet-ports");
> +	if (!ports_node) {
> +		dev_warn(dev, "No ports found\n");
> +		return 0;
> +	}
> +
> +	for_each_available_child_of_node(ports_node, intf_node) {
> +		of_property_read_u32(intf_node, "reg", &port);
> +		if (!bcmasp_is_port_valid(priv, port)) {
> +			dev_warn(dev, "%pOF: %d is an invalid port\n",
> +				 intf_node, port);
> +			continue;
> +		}
> +
> +		priv->intf_count++;
> +	}

I think that you're leaking ports_node,

/**
 * of_find_node_by_name - Find a node by its "name" property
 * @from:	The node to start searching from or NULL; the node
 *		you pass will not be searched, only the next one
 *		will. Typically, you pass what the previous call
 *		returned. of_node_put() will be called on @from.
 * @name:	The name string to match against
 *
 * Return: A node pointer with refcount incremented, use
 * of_node_put() on it when done.
 */

-- 
pw-bot: cr

