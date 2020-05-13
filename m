Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11551D20E1
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 23:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbgEMVXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 17:23:18 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:35838 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728786AbgEMVXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 17:23:16 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1589404995; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=kO0IqobLOJP7uxcQjGF7XV6F4ee3pL/rl3JY9Zx3Zis=;
 b=vuEIiszIh41BJR5H1GTP0l4hu25GwtX1wc7Y9O7plCrrWVfZtHdZxawXekAlFuyfUBvBFV8x
 UIBsxcAbrGP/Q2o2QRVaXHBEsV04oMcIFBBPmNHaKJcRxippUK9T1shr2JkO1A20aKW1HwMw
 pIH9v4R1Wx/xfsMy/n7WWWNpw8o=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5ebc6532.7fecceed9e30-smtp-out-n03;
 Wed, 13 May 2020 21:22:58 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7BD67C432C2; Wed, 13 May 2020 21:22:58 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: rmanohar)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 102F0C433F2;
        Wed, 13 May 2020 21:22:58 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 13 May 2020 14:22:58 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     kvalo@codeaurora.org, davem@davemloft.net, pradeepc@codeaurora.org,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH] ath11k: Fix some resource leaks in error path in
 'ath11k_thermal_register()'
In-Reply-To: <20200513201454.258111-1-christophe.jaillet@wanadoo.fr>
References: <20200513201454.258111-1-christophe.jaillet@wanadoo.fr>
Message-ID: <8ee716c797a547165132c179c1909404@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-13 13:14, Christophe JAILLET wrote:
> If 'thermal_cooling_device_register()' fails, we must undo what has 
> been
> allocated so far. So we must go to 'err_thermal_destroy' instead of
> returning directly
> 
> In case of error in 'ath11k_thermal_register()', the previous
> 'thermal_cooling_device_register()' call must also be undone. Move the
> 'ar->thermal.cdev = cdev' a few lines above in order for this to be 
> done
> in 'ath11k_thermal_unregister()' which is called in the error handling
> path.
> 
> Fixes: 2a63bbca06b2 ("ath11k: add thermal cooling device support")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> I'm not 100% confident with this patch.
> 
> - When calling 'ath11k_thermal_unregister()', we try to release some
>   resources that have not been allocated yet. I don't know if it can be 
> an
>   issue or not.
> - I think that we should propagate the error code, instead of forcing
>   -EINVAL.
> 
Good catch.

-Rajkumar
