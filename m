Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02CAC4C9FEC
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 09:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240234AbiCBIyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 03:54:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234861AbiCBIyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 03:54:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202475FF04;
        Wed,  2 Mar 2022 00:53:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B81296124D;
        Wed,  2 Mar 2022 08:53:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED9BC004E1;
        Wed,  2 Mar 2022 08:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646211218;
        bh=G74+aJfG6CYsfJpqACXBWrfFsPqguSBtGOY3haphRKI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lf1K83pfZJ0TAdTTKhvpqcbQIDZD5zpio0iBwWG6ZCzkz3KPJA1kvmZmAVsctBLfS
         Vm/KMgJJXcNO8HI5RLO7oaBZc5SsnNw44K6jocTDFr9ltgAMntutPJ6qif0Mvg+iUY
         7zvswMwmD7/toHQhBSpxgyY8lwJ4X41mdyVEdjmo=
Date:   Wed, 2 Mar 2022 09:53:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Jann Horn <jannh@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] random: provide notifier for VM fork
Message-ID: <Yh8wjrf7HVf56Anw@kroah.com>
References: <20220301231038.530897-1-Jason@zx2c4.com>
 <20220301231038.530897-3-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301231038.530897-3-Jason@zx2c4.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 12:10:37AM +0100, Jason A. Donenfeld wrote:
> Drivers such as WireGuard need to learn when VMs fork in order to clear
> sessions. This commit provides a simple notifier_block for that, with a
> register and unregister function. When no VM fork detection is compiled
> in, this turns into a no-op, similar to how the power notifier works.
> 
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  drivers/char/random.c  | 15 +++++++++++++++
>  include/linux/random.h |  5 +++++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 6bd1bbab7392..483fd2dc2057 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -1141,6 +1141,8 @@ void add_bootloader_randomness(const void *buf, size_t size)
>  EXPORT_SYMBOL_GPL(add_bootloader_randomness);
>  
>  #if IS_ENABLED(CONFIG_VMGENID)
> +static BLOCKING_NOTIFIER_HEAD(vmfork_notifier);
> +
>  /*
>   * Handle a new unique VM ID, which is unique, not secret, so we
>   * don't credit it, but we do immediately force a reseed after so
> @@ -1152,11 +1154,24 @@ void add_vmfork_randomness(const void *unique_vm_id, size_t size)
>  	if (crng_ready()) {
>  		crng_reseed(true);
>  		pr_notice("crng reseeded due to virtual machine fork\n");
> +		blocking_notifier_call_chain(&vmfork_notifier, 0, NULL);
>  	}
>  }
>  #if IS_MODULE(CONFIG_VMGENID)
>  EXPORT_SYMBOL_GPL(add_vmfork_randomness);
>  #endif
> +
> +int register_random_vmfork_notifier(struct notifier_block *nb)
> +{
> +	return blocking_notifier_chain_register(&vmfork_notifier, nb);
> +}
> +EXPORT_SYMBOL_GPL(register_random_vmfork_notifier);
> +
> +int unregister_random_vmfork_notifier(struct notifier_block *nb)
> +{
> +	return blocking_notifier_chain_unregister(&vmfork_notifier, nb);
> +}
> +EXPORT_SYMBOL_GPL(unregister_random_vmfork_notifier);
>  #endif
>  
>  struct fast_pool {
> diff --git a/include/linux/random.h b/include/linux/random.h
> index e84b6fa27435..7fccbc7e5a75 100644
> --- a/include/linux/random.h
> +++ b/include/linux/random.h
> @@ -31,6 +31,11 @@ extern void add_hwgenerator_randomness(const void *buffer, size_t count,
>  				       size_t entropy);
>  #if IS_ENABLED(CONFIG_VMGENID)
>  extern void add_vmfork_randomness(const void *unique_vm_id, size_t size);
> +extern int register_random_vmfork_notifier(struct notifier_block *nb);
> +extern int unregister_random_vmfork_notifier(struct notifier_block *nb);
> +#else
> +static inline int register_random_vmfork_notifier(struct notifier_block *nb) { return 0; }
> +static inline int unregister_random_vmfork_notifier(struct notifier_block *nb) { return 0; }
>  #endif
>  
>  extern void get_random_bytes(void *buf, size_t nbytes);
> -- 
> 2.35.1
> 

It seems crazy that the "we just were spawned as a new vm" notifier is
based in the random driver, but sure, put it here for now!  :)

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
