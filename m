Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B19D1E2D1A
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 21:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404433AbgEZTT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 15:19:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:52018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392425AbgEZTTX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 15:19:23 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 686A520776;
        Tue, 26 May 2020 19:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520762;
        bh=MQNO4uxBdI9JV0RIQyWryaMm2XR7e2VAk4Nob3P9YIQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nDtYg/JJmx6d9kEUeZBZY/r4Gz/dPR1cIHNFBYez+q5UnxlyLLFDFUZ2WJWTHOS9W
         bG8a/2iDQItD/JVqDMsSQ24NnqHD2ijp9PknjbF44QIiRGzkIOzmHlJv6yHUldorJ/
         qut32l7W+3WBlXes0pmtXuG5acgftT2MEjgA3Pis=
Date:   Tue, 26 May 2020 12:19:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eli Cohen <eli@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>
Subject: Re: [net-next 07/10] net/mlx5e: Add support for hw encapsulation of
 MPLS over UDP
Message-ID: <20200526121920.7f5836e6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200522235148.28987-8-saeedm@mellanox.com>
References: <20200522235148.28987-1-saeedm@mellanox.com>
        <20200522235148.28987-8-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 May 2020 16:51:45 -0700 Saeed Mahameed wrote:
> +static inline __be32 mpls_label_id_field(__be32 label, u8 tos, u8 ttl)
> +{
> +	u32 res;
> +
> +	/* mpls label is 32 bits long and construction as follows:
> +	 * 20 bits label
> +	 * 3 bits tos
> +	 * 1 bit bottom of stack. Since we support only one label, this bit is
> +	 *       always set.
> +	 * 8 bits TTL
> +	 */
> +	res = be32_to_cpu(label) << 12 | 1 << 8 | (tos & 7) <<  9 | ttl;
> +	return cpu_to_be32(res);
> +}

No static inlines in C source, please. Besides this belongs in the mpls
header, it's a generic helper.
