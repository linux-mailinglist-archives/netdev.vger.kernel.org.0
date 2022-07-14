Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9512574D51
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 14:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238847AbiGNMUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 08:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiGNMUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 08:20:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB7B1FCC8;
        Thu, 14 Jul 2022 05:20:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9FE061D7E;
        Thu, 14 Jul 2022 12:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4B1C34114;
        Thu, 14 Jul 2022 12:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657801238;
        bh=T0bWZ1+6aus86wkYhIjKgAyY3BntT8gojmXQ4imG/vo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tE0H5AjGN1273iOr9NHnQr7kjHz5tu052JUoUYS+gsNc8dL4dRf1XxIlP58Jgi9fb
         7qS8UKDUrVnOdpf1JwRsfkaipQ5Z1MqAC50jYXugdmr1zIf1BrIJp9xsz2NQBDc3hf
         DUdFPSKvIrjX2Ku7Scxc7GjNkPboQsULgdckFQiA=
Date:   Thu, 14 Jul 2022 14:20:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?utf-8?Q?=C5=81ukasz?= Spintzyk <lukasz.spintzyk@synaptics.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        oliver@neukum.org, kuba@kernel.org, ppd-posix@synaptics.com
Subject: Re: [PATCH v2 2/2] net/cdc_ncm: Increase NTB max RX/TX values to 64kb
Message-ID: <YtAKEyplVDC85EKV@kroah.com>
References: <20220714120217.18635-1-lukasz.spintzyk@synaptics.com>
 <20220714120217.18635-2-lukasz.spintzyk@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220714120217.18635-2-lukasz.spintzyk@synaptics.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 14, 2022 at 02:02:17PM +0200, Łukasz Spintzyk wrote:
> DisplayLink ethernet devices require NTB buffers larger then 32kb
> in order to run with highest performance.
> 
> This patch is changing upper limit of the rx and tx buffers.
> Those buffers are initialized with CDC_NCM_NTB_DEF_SIZE_RX and
> CDC_NCM_NTB_DEF_SIZE_TX which is 16kb so by default no device is
> affected by increased limit.
> 
> Rx and tx buffer is increased under two conditions:
>  - Device need to advertise that it supports higher buffer size in
>    dwNtbMaxInMaxSize and dwNtbMaxOutMaxSize.
>  - cdc_ncm/rx_max and cdc_ncm/tx_max driver parameters must be adjusted
>    with udev rule or ethtool.
> 
> Summary of testing and performance results:
> Tests were performed on following devices:
>  - DisplayLink DL-3xxx family device
>  - DisplayLink DL-6xxx family device
>  - ASUS USB-C2500 2.5G USB3 ethernet adapter
>  - Plugable USB3 1G USB3 ethernet adapter
>  - EDIMAX EU-4307 USB-C ethernet adapter
>  - Dell DBQBCBC064 USB-C ethernet adapter
> 
> Performance measurements were done with:
>  - iperf3 between two linux boxes
>  - http://openspeedtest.com/ instance running on local test machine
> 
> Insights from tests results:
>  - All except one from third party usb adapters were not affected by
>    increased buffer size to their advertised dwNtbOutMaxSize and
>    dwNtbInMaxSize.
>    Devices were generally reaching 912-940Mbps both download and upload.
> 
>    Only EDIMAX adapter experienced decreased download size from
>    929Mbps to 827Mbps with iper3, with openspeedtest decrease was from
>    968Mbps to 886Mbps.
> 
>  - DisplayLink DL-3xxx family devices experienced performance increase
>    with iperf3 download from 300Mbps to 870Mbps and
>    upload from 782Mbps to 844Mbps.
>    With openspeedtest download increased from 556Mbps to 873Mbps
>    and upload from 727Mbps to 973Mbps
> 
>  - DiplayLink DL-6xxx family devices are not affected by
>    increased buffer size.
> 
> Signed-off-by: Łukasz Spintzyk <lukasz.spintzyk@synaptics.com>
> ---
> 
> v2:
>  - Information how to change tx,rx buffer size
>  - Added performance tests results to the commit description.
> 
> 
>  include/linux/usb/cdc_ncm.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/usb/cdc_ncm.h b/include/linux/usb/cdc_ncm.h
> index f7cb3ddce7fb..2d207cb4837d 100644
> --- a/include/linux/usb/cdc_ncm.h
> +++ b/include/linux/usb/cdc_ncm.h
> @@ -53,8 +53,8 @@
>  #define USB_CDC_NCM_NDP32_LENGTH_MIN		0x20
>  
>  /* Maximum NTB length */
> -#define	CDC_NCM_NTB_MAX_SIZE_TX			32768	/* bytes */
> -#define	CDC_NCM_NTB_MAX_SIZE_RX			32768	/* bytes */
> +#define	CDC_NCM_NTB_MAX_SIZE_TX			65536	/* bytes */
> +#define	CDC_NCM_NTB_MAX_SIZE_RX			65536	/* bytes */
>  
>  /* Initial NTB length */
>  #define	CDC_NCM_NTB_DEF_SIZE_TX			16384	/* bytes */
> -- 
> 2.36.1
> 

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks for the additional information in the changelog text.
