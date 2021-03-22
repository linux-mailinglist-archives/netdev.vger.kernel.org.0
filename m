Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2633446CA
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 15:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhCVOKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 10:10:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230411AbhCVOJp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 10:09:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77B6461920;
        Mon, 22 Mar 2021 14:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616422185;
        bh=uoFKba5rFprgXKSWlOIaz7B++kFkS6xpe6ODVO8W+/M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gY1iK40yFTCigHqXvjMFTyFVvVMbzF17hT60KCmOSH498JPDtevwiTFr3LPpxotKs
         XwYpC7DT0+0P76hUL6zoXrNdjbp1cvwdMCU8rSWbLZxBv7PTWIbFQF6zzdpYTyL8Ca
         M7hDn3+P8/24IjjVFFCcQr1jedilIV+V1Yx5uNKHIBtJ0V15dvvNrvIaXOvjUf82bu
         L+qaCKRfeDWSZIJN8j9yMCMMk/qimdO93jEX5VBasAKJVk+eWTnNKx/6BTP0UIxAQk
         nOtitNQ9sUj2Nom+A5PJBebWnaFcNI2YGTsFYK0uDVBhYFuCB4VIAWjKwqGv3hTY3N
         TSd2dTepWdDcA==
Date:   Mon, 22 Mar 2021 16:09:41 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Mahesh Bandewar <maheshb@google.com>,
        Nikolay Aleksandrov <nikolay@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net] bonding: Work around lockdep_is_held false
 positives
Message-ID: <YFilJZOraCqD0mVj@unreal>
References: <20210322123846.3024549-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322123846.3024549-1-maximmi@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 02:38:46PM +0200, Maxim Mikityanskiy wrote:
> After lockdep gets triggered for the first time, it gets disabled, and
> lockdep_enabled() will return false. It will affect lockdep_is_held(),
> which will start returning true all the time. Normally, it just disables
> checks that expect a lock to be held. However, the bonding code checks
> that a lock is NOT held, which triggers a false positive in WARN_ON.
> 
> This commit addresses the issue by replacing lockdep_is_held with
> spin_is_locked, which should have the same effect, but without suffering
> from disabling lockdep.
> 
> Fixes: ee6377147409 ("bonding: Simplify the xmit function for modes that use xmit_hash")
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> ---
> While this patch works around the issue, I would like to discuss better
> options. Another straightforward approach is to extend lockdep API with
> lockdep_is_not_held(), which will be basically !lockdep_is_held() when
> lockdep is enabled, but will return true when !lockdep_enabled().

lockdep_assert_not_held() was added in this cycle to tip: locking/core
https://yhbt.net/lore/all/161475935945.20312.2870945278690244669.tip-bot2@tip-bot2/
https://yhbt.net/lore/all/878s779s9f.fsf@codeaurora.org/

Thanks
