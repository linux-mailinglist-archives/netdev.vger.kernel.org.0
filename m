Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22DA93E31E3
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 00:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243975AbhHFWrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 18:47:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243453AbhHFWri (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 18:47:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFB9460230;
        Fri,  6 Aug 2021 22:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628290042;
        bh=2ZCjzZP23lwTAHNj52TXxDOVrAU5xHOJHulNNNEa89M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C5jsIV/moUULFm2R5qYzs/EW5D7s+F+zK0KVtBIWEZFs0hBrddkPoRpkxKqmcZi63
         /JnpEuJO5LIDpd4rI30j6OINlnb8oaC9vCBdj7wIysmW0yMZDr6iQWyClBojOi9pZt
         DLT+JyRE42jZqY3NKekdw0bSOh6h9kCc/7KvppG2PJLinh97ynJ/RVPvuiUfNY5Ifz
         7Bufdjqyq09CkkHDV/GssReQ1Tvtusx/eGRe1oAYA8zUFAjKNilZkJ3NJGoQJSDkFy
         UTW1P4K5MNkDCrofO/mYaZRVjKYU1aonxqo8iIA1G36b7hBXpKsJETaHy7HPPhbHQj
         Wn3lgVBR8sHjA==
Date:   Fri, 6 Aug 2021 15:47:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        ryazanov.s.a@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH net-next] net: wwan: mhi_wwan_ctrl: Fix possible
 deadlock
Message-ID: <20210806154721.0333f733@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1628246109-27425-1-git-send-email-loic.poulain@linaro.org>
References: <1628246109-27425-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Aug 2021 12:35:09 +0200 Loic Poulain wrote:
> Lockdep detected possible interrupt unsafe locking scenario:
> 
>         CPU0                    CPU1
>         ----                    ----
>    lock(&mhiwwan->rx_lock);
>                                local_irq_disable();
>                                lock(&mhi_cntrl->pm_lock);
>                                lock(&mhiwwan->rx_lock);
>    <Interrupt>
>      lock(&mhi_cntrl->pm_lock);
> 
>   *** DEADLOCK ***
> 
> To prevent this we need to disable the soft-interrupts when taking
> the rx_lock.
> 
> Cc: stable@vger.kernel.org
> Fixes: fa588eba632d ("net: Add Qcom WWAN control driver")
> Reported-by: Thomas Perrot <thomas.perrot@bootlin.com>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

This is for net, right? Despite it's subject annotation?
