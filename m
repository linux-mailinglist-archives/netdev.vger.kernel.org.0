Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE4C260936
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 06:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgIHEKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 00:10:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725801AbgIHEKP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 00:10:15 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C688321481;
        Tue,  8 Sep 2020 04:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599538215;
        bh=7odZQvUtuGLow8kJkUKxWanDGq/uvBKPEezxTaLB6tg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EGj9vMkJxWQ/GG1XSj4TGjIvY+XtIE0dCS3QGAwfwmNfJcmW89yve0qJd5DaYLzAt
         tv+4svBGxo9Qh28lbivrJmTi/pckrm/zPfaiIyGxdR5DhSLo06cgFOnVo62zVU6wSU
         LZOfETfJbpfw72Msdhd1VxcsEtGtvd9vXtR0jPWU=
Date:   Mon, 7 Sep 2020 21:10:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     wei.liu@kernel.org, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, davem@davemloft.net,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mikelley@microsoft.com
Subject: Re: [PATCH net v2] hv_netvsc: Fix hibernation for mlx5 VF driver
Message-ID: <20200907211013.0f1a6702@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200907071339.35677-1-decui@microsoft.com>
References: <20200907071339.35677-1-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  7 Sep 2020 00:13:39 -0700 Dexuan Cui wrote:
> mlx5_suspend()/resume() keep the network interface, so during hibernation
> netvsc_unregister_vf() and netvsc_register_vf() are not called, and hence
> netvsc_resume() should call netvsc_vf_changed() to switch the data path
> back to the VF after hibernation. Note: after we close and re-open the
> vmbus channel of the netvsc NIC in netvsc_suspend() and netvsc_resume(),
> the data path is implicitly switched to the netvsc NIC. Similarly,
> netvsc_suspend() should not call netvsc_unregister_vf(), otherwise the VF
> can no longer be used after hibernation.
> 
> For mlx4, since the VF network interafce is explicitly destroyed and
> re-created during hibernation (see mlx4_suspend()/resume()), hv_netvsc
> already explicitly switches the data path from and to the VF automatically
> via netvsc_register_vf() and netvsc_unregister_vf(), so mlx4 doesn't need
> this fix. Note: mlx4 can still work with the fix because in
> netvsc_suspend()/resume() ndev_ctx->vf_netdev is NULL for mlx4.
> 
> Fixes: 0efeea5fb153 ("hv_netvsc: Add the support of hibernation")
> Signed-off-by: Dexuan Cui <decui@microsoft.com>

Applied, thanks!
