Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351CE6132A8
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 10:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbiJaJYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 05:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbiJaJYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 05:24:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB419DEA1
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 02:23:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 625F0B81261
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 09:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA3BC433D6;
        Mon, 31 Oct 2022 09:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667208224;
        bh=OyjpAhK636yfS1L+Lziq81EBFNQK9zk6anCqCDernj8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HeCrqOmVSY+AtBT/KDQXGcLv70u2YOO2JA0sU3533UeXVGDhP5vLY5/qr5ypFSCCf
         47uwkohsRZ+hQsE/7kzUOAdH321AhMss/6A071H+q4UyF25ZmGfHJ/akKjCIQLjXIA
         Xx2c/L8D/5aVM4nxUiJVSDuLoc2u2HEbneFzbawGePLfe4vPgfMAnZ5TmF7ZNfVtnC
         G2QLitQm7xN8Ma+durJQdazFsSbX12Am2gBncRKnnHCa4OkCiT4UPnlrgcBLO7oaD7
         bSvtu9sNVV8D6jp4ygRFIgscf8X4VEajuakJ0qXUgTyHsnb8tMEYexL3gb/paqGzNq
         T83T3vNgieIRw==
Date:   Mon, 31 Oct 2022 11:23:40 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     bongsu.jeon@samsung.com, krzysztof.kozlowski@linaro.org,
        netdev@vger.kernel.org, syzkaller@googlegroups.com
Subject: Re: [PATCH] nfc: Allow to create multiple virtual nci devices
Message-ID: <Y1+UHKsFbg46UEvM@unreal>
References: <20221030142919.3196780-1-dvyukov@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221030142919.3196780-1-dvyukov@google.com>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 30, 2022 at 03:29:19PM +0100, Dmitry Vyukov wrote:
> The current virtual nci driver is great for testing and fuzzing.
> But it allows to create at most one "global" device which does not allow
> to run parallel tests and harms fuzzing isolation and reproducibility.
> Restructure the driver to allow creation of multiple independent devices.
> This should be backwards compatible for existing tests.
> 
> Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Cc: netdev@vger.kernel.org
> ---
>  drivers/nfc/virtual_ncidev.c | 143 ++++++++++++++++-------------------
>  1 file changed, 66 insertions(+), 77 deletions(-)

<...>

>  static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
>  {
> -	mutex_lock(&nci_mutex);
> -	if (state != virtual_ncidev_enabled) {
> -		mutex_unlock(&nci_mutex);
> -		kfree_skb(skb);
> -		return 0;
> -	}
> +	struct virtual_nci_dev *vdev = nci_get_drvdata(ndev);
>  
> -	if (send_buff) {
> -		mutex_unlock(&nci_mutex);
> +	mutex_lock(&vdev->mtx);
> +	if (vdev->send_buff) {
> +		mutex_unlock(&vdev->mtx);
>  		kfree_skb(skb);

You probably need to set vdev->send_buff to NULL here.

>  		return -1;
>  	}
> -	send_buff = skb_copy(skb, GFP_KERNEL);
> -	mutex_unlock(&nci_mutex);
> -	wake_up_interruptible(&wq);
> +	vdev->send_buff = skb_copy(skb, GFP_KERNEL);

You don't check return value of skb_copy(), it can fail, but
this function will return 0 (success). Do you do it deliberately?

If yes, please add a comment to the code, as it is not clear.

Thanks

> +	mutex_unlock(&vdev->mtx);
> +	wake_up_interruptible(&vdev->wq);
>  	consume_skb(skb);
>  
>  	return 0;
