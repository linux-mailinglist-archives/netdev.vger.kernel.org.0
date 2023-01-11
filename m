Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC1B6662C9
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 19:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234785AbjAKS33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 13:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236094AbjAKS2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 13:28:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE961BCAE;
        Wed, 11 Jan 2023 10:28:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB26CB81BDC;
        Wed, 11 Jan 2023 18:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F09C433EF;
        Wed, 11 Jan 2023 18:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673461729;
        bh=SEVadaaZ7nAyP60UPoBxxqnNElyp72turpT4z9GLOgY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m85A0ufJDBXb1Inco40yvIDQ6syjaqa2qJNvkraRufme1NPFfmkrc2yP1g8IIwYoj
         8rz2fJymIGpMd0JU0P/YxWFMV9OU8pyOREFqkvZLywcbXyqn+tHXHGyBa3eBqHTBtl
         Jzzr1Oa+oEE7Q+90PDiH28vBpInizMmr0UFWsZ8sxjzWxrDj3CtFXGzm5k/9qShacS
         9XAff7LW6mN77xfgxFRb07WIdrZgMH9I1T5vKVdFbsi2HJr3rSJmuRlB7SvzUts/pJ
         vmfa1RylFItRdURplCvZY+ftCtggDjwIQQxC5LAdqJWNSEojhB1kHaQfr34nmBY1xb
         MY5VhmTgsnCiw==
Date:   Wed, 11 Jan 2023 10:28:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Esina Ekaterina <eesina@astralinux.ru>
Cc:     Zhao Qiang <qiang.zhao@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH v3]   net: wan: Add checks for NULL for utdm in
 undo_uhdlc_init and unmap_si_regs
Message-ID: <20230111102848.44863b9c@kernel.org>
In-Reply-To: <20230111090504.66434-1-eesina@astralinux.ru>
References: <20230110204418.79f43f45@kernel.org>
        <20230111090504.66434-1-eesina@astralinux.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Jan 2023 12:05:03 +0300 Esina Ekaterina wrote:
> Subject: [PATCH v3]   net: wan: Add checks for NULL for utdm in undo_uhdlc_init and unmap_si_regs

net: wan: prevent null-deref on error path for non-tdm case

>   If uhdlc_priv_tsa != 1 then utdm is not initialized.
>   And if ret != NULL then goto undo_uhdlc_init, where
>   utdm is dereferenced. Same if dev == NULL.
> 
>   Found by Linux Verification Center (linuxtesting.org) with SVACE.

I did the indentation to make the content stand out in the email, 
there should be no indentation in the actual msg, sorry.

> --- a/drivers/net/wan/fsl_ucc_hdlc.c
> +++ b/drivers/net/wan/fsl_ucc_hdlc.c
> @@ -1243,9 +1243,11 @@ static int ucc_hdlc_probe(struct platform_device *pdev)
>  free_dev:
>  	free_netdev(dev);
>  undo_uhdlc_init:
> -	iounmap(utdm->siram);
> +	if (utdm != NULL)

and here just:

	if (utdm)

comparing to NULL or zero is less idiomatic in kernel C.

> +		iounmap(utdm->siram);
>  unmap_si_regs:
> -	iounmap(utdm->si_regs);
> +	if (utdm != NULL)
> +		iounmap(utdm->si_regs);
