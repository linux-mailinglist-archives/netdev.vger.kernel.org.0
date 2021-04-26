Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB16C36B6CB
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 18:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234328AbhDZQaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 12:30:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234279AbhDZQaT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 12:30:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1447E6105A;
        Mon, 26 Apr 2021 16:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619454577;
        bh=Cquhmqik9ZysR59oMnqYiSZZcisukRD4cL4cTrK+l9c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DsXIp/lPu4XvLKuHmQB0qqmZGM+4vNrbqwaS/nN9CZ/uJbxAcW0kHe61GIfLACaNZ
         q18xWMI6/UQvyeV8ZNx89BGPhffGirfoTlIfAwYTP9QOjh8TQBNvITxpk21vHK90AI
         FKwc7E8gj/2Kn9RYAx5OQOPhGrX7Gm0e3Jn1d9tQfLapfIwE54lAyyW1U91GDDxJtE
         xmKLfrUy5GslXorr9K65n/UyAe1pzNRm7Hu9HEXODR9Qk/MeMC3qgmv+dg9c7rQyDu
         YdqCeD7Q5TLPq7tiCj23xCe0fid0hba8CQ5bnoAt+8+g3sBg7KR6tkokUDFMf2KXhZ
         +l+HnUPe2mBqQ==
Date:   Mon, 26 Apr 2021 09:29:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, gospo@broadcom.com
Subject: Re: [PATCH net-next v2 10/10] bnxt_en: Implement
 .ndo_features_check().
Message-ID: <20210426092935.728fda80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1619372727-19187-11-git-send-email-michael.chan@broadcom.com>
References: <1619372727-19187-1-git-send-email-michael.chan@broadcom.com>
        <1619372727-19187-11-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 25 Apr 2021 13:45:27 -0400 Michael Chan wrote:
> +	if (l4_proto != IPPROTO_UDP)
> +		return features;

This should have been "features & ~(CSUM | GSO)" if you actually
accepted my feedback. I mentioned extension headers as an example, 
v2 looks like a minor refactoring, no functional changes :/

> +	bp = netdev_priv(dev);
> +	/* For UDP, we can only handle 1 Vxlan port and 1 Geneve port. */
> +	udp_port = udp_hdr(skb)->dest;
> +	if (udp_port == bp->vxlan_port || udp_port == bp->nge_port)
> +		return features;
> +	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
