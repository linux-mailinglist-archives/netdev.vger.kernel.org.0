Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2144744E005
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 02:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbhKLB5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 20:57:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:42626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229908AbhKLB5v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 20:57:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A17E60C4D;
        Fri, 12 Nov 2021 01:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636682101;
        bh=ON2ojmkv6yXL8pNdAAUIaWTtcae03Y5Nnk1xacIWpbs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hKrM3ghwLe7pUDN+LRvHmHkcudA11kFUEVk9SpGKwxuvqFvcljhDZ00L38LE141OD
         wl+SSEINPiJ+sGMF1Qq98VNa9tw/VTKHozRKsEO5RI4fU38WS4KS7oJnEGysknEZeY
         +G6dOxrOthPNybOeD82iBkXjtMxpNG/ZN0lwnkfzQpieXml9BX5VrOOGJjBZGXp5pV
         MTyk4eawCd+x7i69Li9WA4KjwX4r7w3/PtBBKRbm1KpwGoyR5LYY5xNlN/jEtsqMGb
         h3MKVAaB5P2maVKDzEd65Gtic3Xh1uR/lsSzyLxEOD9UDjFtgX9rgEqSYaxgttFsP6
         7AUi3PMa06NRA==
Date:   Thu, 11 Nov 2021 17:55:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jirislaby@kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] hamradio: remove needs_free_netdev to avoid UAF
Message-ID: <20211111175500.2f67e18a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211111141402.7551-1-linma@zju.edu.cn>
References: <20211111141402.7551-1-linma@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Nov 2021 22:14:02 +0800 Lin Ma wrote:
> The former patch "defer 6pack kfree after unregister_netdev" reorders
> the kfree of two buffer after the unregister_netdev to prevent the race
> condition. It also adds free_netdev() function in sixpack_close(), which
> is a direct copy from the similar code in mkiss_close().
> 
> However, in sixpack driver, the flag needs_free_netdev is set to true in
> sp_setup(), hence the unregister_netdev() will free the netdev
> automatically. Therefore, as the sp is netdev_priv, use-after-free
> occurs.
> 
> This patch removes the needs_free_netdev = true and just let the
> free_netdev to finish this deallocation task.
> 
> Signed-off-by: Lin Ma <linma@zju.edu.cn>

Fixes: 0b9111922b1f ("hamradio: defer 6pack kfree after unregister_netdev")
