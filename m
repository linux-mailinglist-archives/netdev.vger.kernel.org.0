Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 034A8512FC1
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 11:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbiD1JuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 05:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346370AbiD1JXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 05:23:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EA266AC1;
        Thu, 28 Apr 2022 02:20:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84252B82C2E;
        Thu, 28 Apr 2022 09:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710E8C385A0;
        Thu, 28 Apr 2022 09:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651137620;
        bh=Q7vFbwSdATDdmBQ77Ls81g7uq+u+zq/6xZ7xLxpPF+s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tUZodW9PLFvBQeKzJaZhscsSdsKDQNJ+bDGCTtj2VGeMT+2qJ85y/xqX552x8YoQo
         8vunNlVmV7Cm5FhjvTqiKC1JC4e0YexVDBzFNHj2UjjKUyx3RAJKTdNHdDFRUuN9sl
         Hlv6lmRc8osGT/AaKlexFc8D7mJD5m42GL5Su/Go=
Date:   Thu, 28 Apr 2022 11:20:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Duoming Zhou <duoming@zju.edu.cn>,
        krzysztof.kozlowski@linaro.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        alexander.deucher@amd.com, akpm@linux-foundation.org,
        broonie@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v4] nfc: ... device_is_registered() is data race-able
Message-ID: <YmpcUNf7O+OK6/Ax@kroah.com>
References: <20220427011438.110582-1-duoming@zju.edu.cn>
 <20220427174548.2ae53b84@kernel.org>
 <38929d91.237b.1806f05f467.Coremail.linma@zju.edu.cn>
 <YmpEZQ7EnOIWlsy8@kroah.com>
 <2d7c9164.2b1f.1806f2a8ed9.Coremail.linma@zju.edu.cn>
 <YmpNZOaJ1+vWdccK@kroah.com>
 <15d09db2.2f76.1806f5c4187.Coremail.linma@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15d09db2.2f76.1806f5c4187.Coremail.linma@zju.edu.cn>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 04:49:18PM +0800, Lin Ma wrote:
> Hello Greg,
> 
> > 
> > It shouldn't be, if you are using it properly :)
> > 
> > [...]
> > 
> > Yes, you should almost never use that call.  Seems the nfc subsystem is
> > the most common user of it for some reason :(
> 
> Cool, and I believe that the current nfc core code does not use it properly. :(
> 
> > 
> > What state are you trying to track here exactly?
> > 
> 
> Forget about the firmware downloading race that raised by Duoming in this channel,
> all the netlink handler code in net/nfc/core.c depends on the device_is_registered
> macro.
> 
> My idea is to introduce a patch like below:
> 
>  include/net/nfc/nfc.h |  1 +
>  net/nfc/core.c        | 26 ++++++++++++++------------
>  2 files changed, 15 insertions(+), 12 deletions(-)
> 
> diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
> index 5dee575fbe86..d84e53802b06 100644
> --- a/include/net/nfc/nfc.h
> +++ b/include/net/nfc/nfc.h
> @@ -168,6 +168,7 @@ struct nfc_dev {
>  	int targets_generation;
>  	struct device dev;
>  	bool dev_up;
> +	bool dev_register;
>  	bool fw_download_in_progress;
>  	u8 rf_mode;
>  	bool polling;
> diff --git a/net/nfc/core.c b/net/nfc/core.c
> index dc7a2404efdf..208e6bb0804e 100644
> --- a/net/nfc/core.c
> +++ b/net/nfc/core.c
> @@ -38,7 +38,7 @@ int nfc_fw_download(struct nfc_dev *dev, const char *firmware_name)
>  
>  	device_lock(&dev->dev);
>  
> -	if (!device_is_registered(&dev->dev)) {
> +	if (!dev->dev_register) {
>  		rc = -ENODEV;
>  		goto error;
>  	}
> @@ -94,7 +94,7 @@ int nfc_dev_up(struct nfc_dev *dev)
>  
>  	device_lock(&dev->dev);
>  
> -	if (!device_is_registered(&dev->dev)) {
> +	if (!dev->dev_register) {
>  		rc = -ENODEV;
>  		goto error;
>  	}
> 
> [...]
> 
> @@ -1134,6 +1134,7 @@ int nfc_register_device(struct nfc_dev *dev)
>  			dev->rfkill = NULL;
>  		}
>  	}
> +	dev->dev_register = true;
>  	device_unlock(&dev->dev);
>  
>  	rc = nfc_genl_device_added(dev);
> @@ -1162,6 +1163,7 @@ void nfc_unregister_device(struct nfc_dev *dev)
>  			 "was removed\n", dev_name(&dev->dev));
>  
>  	device_lock(&dev->dev);
> +	dev->dev_register = false;
>  	if (dev->rfkill) {
>  		rfkill_unregister(dev->rfkill);
>  		rfkill_destroy(dev->rfkill);
> -- 
> 2.35.1
> 
> The added dev_register variable can function like the original device_is_registered and does not race-able
> because of the protection of device_lock.

Yes, that looks better, but what is the root problem here that you are
trying to solve?  Why does NFC need this when no other subsystem does?

thansk,

greg k-h
