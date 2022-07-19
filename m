Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB8757989B
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 13:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237411AbiGSLgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 07:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiGSLgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 07:36:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88F11BE96;
        Tue, 19 Jul 2022 04:36:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7894D615BE;
        Tue, 19 Jul 2022 11:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630FAC341C6;
        Tue, 19 Jul 2022 11:36:52 +0000 (UTC)
Date:   Tue, 19 Jul 2022 13:36:49 +0200
From:   Greg KH <greg@kroah.com>
To:     =?utf-8?Q?=C5=81ukasz?= Spintzyk <lukasz.spintzyk@synaptics.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        oliver@neukum.org, kuba@kernel.org, ppd-posix@synaptics.com,
        Bernice.Chen@synaptics.com
Subject: Re: [PATCH v4 2/2] net/cdc_ncm: Increase NTB max RX/TX values to 64kb
Message-ID: <YtaXUZ2xzZgEUXAk@kroah.com>
References: <YtVw+6SC7rtKDzaw@kroah.com>
 <20220719062452.25507-1-lukasz.spintzyk@synaptics.com>
 <20220719062452.25507-2-lukasz.spintzyk@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220719062452.25507-2-lukasz.spintzyk@synaptics.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 08:24:52AM +0200, Łukasz Spintzyk wrote:
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
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> 
>  v4: Added Acked-by from link
>     https://lore.kernel.org/netdev/YtAKEyplVDC85EKV@kroah.com/#t
> 
>  Greg, Hopefully this is what you meant about missing "Reviewed-by".

Yes, but you forgot to list what changed from v1 and v2 here :(

thanks,

greg k-h
