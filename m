Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2442441CC19
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 20:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346321AbhI2Stc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 14:49:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346287AbhI2Stb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 14:49:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA9F061504;
        Wed, 29 Sep 2021 18:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632941270;
        bh=Kl5vETRwKZ9cABUEUhLbAd0/LQ63+r3ju9xKNwV63RA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q00tMlZk0b60MRf8WkqwNpGByhdalK00jSFzCWy1jYTP8pyyl7a9Zct8rmsLG49HW
         vF39x+dH63l4vys9RMSKUQtxZdlq2vkcB4WNEwzw9Ne+CCCs/376Gk2V+jma3ahqhO
         jIsN5zl0pxey3E4USiudFQTJtqAd6wDvJKZejrzYOxyCeNDBv53qgwYYRoESNK6pLj
         OnOTf3siVAa02oWPBw6Ji7xp5HW/5lU58dqgC5Oxf45JAUQJNfnIDG/Fx03oz3BENP
         ZabwoAvnKejJmI8hpE6HI1wZ+S0odYGkwPjmFU6Y+kFFHkfiAblwenpoMklXib50rw
         MUQMn696G157g==
Date:   Wed, 29 Sep 2021 11:47:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yu Xiao <yu.xiao@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?= 
        <niklas.soderlund@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH net] nfp: bpf: Add an MTU check before offloading BPF
Message-ID: <20210929114748.545f7328@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210929152421.5232-1-simon.horman@corigine.com>
References: <20210929152421.5232-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Sep 2021 17:24:21 +0200 Simon Horman wrote:
> From: Yu Xiao <yu.xiao@corigine.com>
> 
> There is a bug during xdpoffloading. When MTU is bigger than the
> max MTU of BFP (1888), it can still be added xdpoffloading.
> 
> Therefore, add an MTU check to ensure that xdpoffloading cannot be
> loaded when MTU is larger than a max MTU of 1888.

There is a check in nfp_net_bpf_load(). TC or XDP, doesn't matter,
we can't offload either with large MTU since the FW helper (used to be) 
able to only access CTM. So the check is on the generic path, adding
an XDP-specific check seems wrong.
