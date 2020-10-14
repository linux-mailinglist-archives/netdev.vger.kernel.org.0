Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D3228E8FB
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 01:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729010AbgJNXAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 19:00:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726513AbgJNXAB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 19:00:01 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4293420776;
        Wed, 14 Oct 2020 23:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602716400;
        bh=qUBUKi9Uhs8lwmVMgMRaCqfD9agAtCwndy7lYGBk0yU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fgN6ZvZYNVWAQiqZrNS9uUImAjj6mzR5LbgtovtEqMUMFtkfG1qqut3r6Tf05xKLL
         feG1uoZaCrWOsFy2kzvfGYHLCaXRULH7DQGNDtE6K8whEkEfWTksRpxsaVoJY3zAPw
         YOUnMIoYH4dSKrS6J/nAmipv7jfckZntPP/3vrm8=
Date:   Wed, 14 Oct 2020 15:59:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
Cc:     <davem@davemloft.net>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v5 05/10] bridge: cfm: Kernel space
 implementation of CFM. CCM frame TX added.
Message-ID: <20201014155958.12e38308@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201012140428.2549163-6-henrik.bjoernlund@microchip.com>
References: <20201012140428.2549163-1-henrik.bjoernlund@microchip.com>
        <20201012140428.2549163-6-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 14:04:23 +0000 Henrik Bjoernlund wrote:
> +	skb = dev_alloc_skb(CFM_CCM_MAX_FRAME_LENGTH);
> +	if (!skb)
> +		return NULL;
> +
> +	rcu_read_lock();
> +	b_port = rcu_dereference(mep->b_port);
> +	if (!b_port) {
> +		rcu_read_unlock();
> +		return NULL;
> +	}

At a quick scan I noticed you appear to be leaking the skb here.
So let me point out some more nit picks.
