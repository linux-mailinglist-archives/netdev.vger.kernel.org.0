Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1C958F03C
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 18:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbiHJQTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 12:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbiHJQTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 12:19:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16597D1D7;
        Wed, 10 Aug 2022 09:19:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BA4E61198;
        Wed, 10 Aug 2022 16:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B79AC433C1;
        Wed, 10 Aug 2022 16:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660148383;
        bh=mSFaj+NwiQylRGU1GkqPGJTjj0pD5iaBeP7XgeK+7/c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZY1o7ndkkJqLdKESA7qXprqqgsdOFbeZj6hdoew6R6Lk2SsUlDvvR/QtV3v8nIEz3
         +JYzt+49ABFHpC5VRUCBvutA+5Od1jCAhBx8jLaerDAvtD655TWuZRUBrjTzcNN6Vy
         WTSammJgiPWO73gkBSxDS968IugW9xgfbgaWAhuU=
Date:   Wed, 10 Aug 2022 18:19:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Manish Mandlik <mmandlik@google.com>
Cc:     Arend van Spriel <aspriel@gmail.com>, marcel@holtmann.org,
        luiz.dentz@gmail.com, Johannes Berg <johannes@sipsolutions.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        linux-bluetooth@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        chromeos-bluetooth-upstreaming@chromium.org,
        Won Chung <wonchung@google.com>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v5 3/5] Bluetooth: Add support for hci devcoredump
Message-ID: <YvPanELgAAbzGdE5@kroah.com>
References: <20220810085753.v5.1.I5622b2a92dca4d2703a0f747e24f3ef19303e6df@changeid>
 <20220810085753.v5.3.Iaf638bb9f885f5880ab1b4e7ae2f73dd53a54661@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810085753.v5.3.Iaf638bb9f885f5880ab1b4e7ae2f73dd53a54661@changeid>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 09:00:36AM -0700, Manish Mandlik wrote:
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -2510,14 +2510,23 @@ struct hci_dev *hci_alloc_dev_priv(int sizeof_priv)
>  	INIT_WORK(&hdev->tx_work, hci_tx_work);
>  	INIT_WORK(&hdev->power_on, hci_power_on);
>  	INIT_WORK(&hdev->error_reset, hci_error_reset);
> +#ifdef CONFIG_DEV_COREDUMP
> +	INIT_WORK(&hdev->dump.dump_rx, hci_devcoredump_rx);
> +#endif
>  
>  	hci_cmd_sync_init(hdev);
>  
>  	INIT_DELAYED_WORK(&hdev->power_off, hci_power_off);
> +#ifdef CONFIG_DEV_COREDUMP
> +	INIT_DELAYED_WORK(&hdev->dump.dump_timeout, hci_devcoredump_timeout);
> +#endif
>  
>  	skb_queue_head_init(&hdev->rx_q);
>  	skb_queue_head_init(&hdev->cmd_q);
>  	skb_queue_head_init(&hdev->raw_q);
> +#ifdef CONFIG_DEV_COREDUMP
> +	skb_queue_head_init(&hdev->dump.dump_q);
> +#endif

Putting #ifdef in .c files is messy, why not put all of this behind a
function that you properly handle in a .h file instead?

thanks,

greg k-h
