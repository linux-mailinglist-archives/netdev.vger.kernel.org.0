Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18FD22B88E2
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 01:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgKSACl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 19:02:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:47204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726304AbgKSACl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 19:02:41 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88B6C246E0;
        Thu, 19 Nov 2020 00:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605744160;
        bh=GF5dPzOIifvQCldVIgGATj1Bm6sA+YL8hKFsuU7Re6U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2hxgpihhSzNB7MKqsQcCqqJtBgIkv00sAyXJinWiGRyGLkX+LvTyoNHhJPsqBaUcn
         xdobKTbXeiSSH2D6uiOH60zaPeX8YTpRjZp6CCn1eWJVgL7qOPVOWUUsGWQ3Nch9sL
         McA6X/7oaUHv+nyqsk/a2P31Afrd92xfjaegr/qw=
Date:   Wed, 18 Nov 2020 16:02:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>
Subject: Re: [PATCH net-next 0/2] TLS TX HW offload for Bond
Message-ID: <20201118160239.78871842@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201115134251.4272-1-tariqt@nvidia.com>
References: <20201115134251.4272-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Nov 2020 15:42:49 +0200 Tariq Toukan wrote:
> This series opens TLS TX HW offload for bond interfaces.
> This allows bond interfaces to benefit from capable slave devices.
> 
> The first patch adds real_dev field in TLS context structure, and aligns
> usages in TLS module and supporting drivers.
> The second patch opens the offload for bond interfaces.
> 
> For the configuration above, SW kTLS keeps picking the same slave
> To keep simple track of the HW and SW TLS contexts, we bind each socket to
> a specific slave for the socket's whole lifetime. This is logically valid
> (and similar to the SW kTLS behavior) in the following bond configuration, 
> so we restrict the offload support to it:
> 
> ((mode == balance-xor) or (mode == 802.3ad))
> and xmit_hash_policy == layer3+4.

This does not feel extremely clean, maybe you can convince me otherwise.

Can we extend netdev_get_xmit_slave() and figure out the output dev
(and if it's "stable") in a more generic way? And just feed that dev
into TLS handling? All non-crypto upper SW devs should be safe to cross
with .decrypted = 1 skbs, right?
