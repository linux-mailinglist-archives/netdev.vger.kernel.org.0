Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5664D512848
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 02:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238053AbiD1AtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 20:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbiD1AtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 20:49:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E1E2E0BB;
        Wed, 27 Apr 2022 17:45:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB12EB8292A;
        Thu, 28 Apr 2022 00:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BC0C385A9;
        Thu, 28 Apr 2022 00:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651106750;
        bh=re40Afczn6J1X4TFhRwHoNvSCLaNmMLS9fa1aNRkctk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ldXmpVmf/o3JjPW4Tus8b9X8DiAiNQCrJ8xfKVnMlcRRlmpk6p/QqjiUkGT6kkrhT
         vwkNmO3XZAMqFMbkqW8KoS75r+SZUp+6g/6Jq5Ua9EjEM9zjWQHxX9nNehZaYcqMUb
         usDYDNbuhOUDB1hs8AMXJVChJzx3kaRvRxJdOzTMQKYZST4gU/VGJjcgdIY34/5uLt
         2yUWI+BlNNEaA4rOfzKwDHGmhhvSE136bRphpUVmlHaWgV/kcabkCBiCWlyeOcmL3f
         ny/zUQfw0WzRVXd75Y/xWF/t+pEakHbbrVW0GSvd4xIueWfN0vVgkWlwbCVse5COh6
         8xxDYQ/EGd0Wg==
Date:   Wed, 27 Apr 2022 17:45:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     krzysztof.kozlowski@linaro.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, alexander.deucher@amd.com,
        akpm@linux-foundation.org, broonie@kernel.org,
        netdev@vger.kernel.org, linma@zju.edu.cn
Subject: Re: [PATCH net v4] nfc: nfcmrvl: main: reorder destructive
 operations in nfcmrvl_nci_unregister_dev to avoid bugs
Message-ID: <20220427174548.2ae53b84@kernel.org>
In-Reply-To: <20220427011438.110582-1-duoming@zju.edu.cn>
References: <20220427011438.110582-1-duoming@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Apr 2022 09:14:38 +0800 Duoming Zhou wrote:
> diff --git a/net/nfc/core.c b/net/nfc/core.c
> index dc7a2404efd..1d91334ee86 100644
> --- a/net/nfc/core.c
> +++ b/net/nfc/core.c
> @@ -25,6 +25,8 @@
>  #define NFC_CHECK_PRES_FREQ_MS	2000
>  
>  int nfc_devlist_generation;
> +/* nfc_download: used to judge whether nfc firmware download could start */
> +static bool nfc_download;
>  DEFINE_MUTEX(nfc_devlist_mutex);
>  
>  /* NFC device ID bitmap */
> @@ -38,7 +40,7 @@ int nfc_fw_download(struct nfc_dev *dev, const char *firmware_name)
>  
>  	device_lock(&dev->dev);
>  
> -	if (!device_is_registered(&dev->dev)) {
> +	if (!device_is_registered(&dev->dev) || !nfc_download) {
>  		rc = -ENODEV;
>  		goto error;
>  	}
> @@ -1134,6 +1136,7 @@ int nfc_register_device(struct nfc_dev *dev)
>  			dev->rfkill = NULL;
>  		}
>  	}
> +	nfc_download = true;
>  	device_unlock(&dev->dev);
>  
>  	rc = nfc_genl_device_added(dev);
> @@ -1166,6 +1169,7 @@ void nfc_unregister_device(struct nfc_dev *dev)
>  		rfkill_unregister(dev->rfkill);
>  		rfkill_destroy(dev->rfkill);
>  	}
> +	nfc_download = false;
>  	device_unlock(&dev->dev);
>  
>  	if (dev->ops->check_presence) {

You can't use a single global variable, there can be many devices 
each with their own lock.

Paolo suggested adding a lock, if spin lock doesn't fit the bill
why not add a mutex?
