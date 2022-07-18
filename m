Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD125785A5
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 16:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbiGROlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 10:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiGROlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 10:41:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1924237F6;
        Mon, 18 Jul 2022 07:41:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 951DFB81623;
        Mon, 18 Jul 2022 14:41:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF01C341C0;
        Mon, 18 Jul 2022 14:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658155263;
        bh=8tc1N2UaCa03NAQ44mBmGgTtgQCN458qWyRecZIxzac=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jbndizt7yi/YEVRkCghv7AjcSS3viAOPpAegG/oD2iIjSwPapS9Zx3IgSliSzbvbW
         esozsnUDoW36IMe22YA/VShQ5NVw5B4MOPR/rWKL3UXGBPBnuNd53xZucU6EfGOCq7
         BIRlrhRBrSNbm1emjsbLWMpKQwE51RydpA8H08YI=
Date:   Mon, 18 Jul 2022 16:40:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?utf-8?Q?=C5=81ukasz?= Spintzyk <lukasz.spintzyk@synaptics.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        oliver@neukum.org, kuba@kernel.org, ppd-posix@synaptics.com,
        Bernice.Chen@synaptics.com
Subject: Re: [PATCH v3 2/2] net/cdc_ncm: Increase NTB max RX/TX values to 64kb
Message-ID: <YtVw+6SC7rtKDzaw@kroah.com>
References: <YtAJ2KleMpkeFfQq@kroah.com>
 <20220718123618.7410-1-lukasz.spintzyk@synaptics.com>
 <20220718123618.7410-2-lukasz.spintzyk@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220718123618.7410-2-lukasz.spintzyk@synaptics.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 02:36:18PM +0200, Łukasz Spintzyk wrote:
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
>  v3: No new changes to v2 2/2.
>  It is just rebase on top of changed v3 1/2 patch

Any reason you dropped my reviewed-by?

