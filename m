Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A0869126F
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 22:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjBIVHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 16:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjBIVH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 16:07:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94809126E3;
        Thu,  9 Feb 2023 13:07:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AA8561BC4;
        Thu,  9 Feb 2023 21:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4F5C433EF;
        Thu,  9 Feb 2023 21:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675976846;
        bh=nsi480PlcD00mwg5QfuePBBj8Wm6UTsQSTwHbxCv7Wk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ly/6qMUTeSFNLsXWM0M2oRUJWR3SDKfteXE6KmGqdOclpazZA/NQkwIf/ZclksJ7o
         VXjWtiXyxnKl7whL10l0yx31HHis0IeMAHOD9oA0bIITJAvXeHdFJCNi5Gt19dV7Lm
         Cqo+gDlri3nQRRinXQut+MD4YlughcecTmDi7+mMYNnYuousoEQ9XBrGHXorjh1Wg1
         6fL5k5D/OV42rsEWxj/B5j39riwcZ0Q4+RxOZoGHt09WKbD8x1a76/9XxfkQB4XsN9
         jV7BLd3rnG2dn9WZh/gMwmxLBSj106eHM2wrcdDwmwdUeMmTdoeBJal0yc9CuJ9a11
         qX8ulHvdg6jGw==
Date:   Thu, 9 Feb 2023 13:07:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <Ajay.Kathat@microchip.com>
Cc:     <heiko.thiery@gmail.com>, <Claudiu.Beznea@microchip.com>,
        <kvalo@kernel.org>, <linux-wireless@vger.kernel.org>,
        <michael@walle.cc>, <netdev@vger.kernel.org>,
        <Amisha.Patel@microchip.com>
Subject: Re: wilc1000 MAC address is 00:00:00:00:00:00
Message-ID: <20230209130725.0b04a424@kernel.org>
In-Reply-To: <51134d12-1b06-6d6f-e798-7dd681a8f3ae@microchip.com>
References: <CAEyMn7aV-B4OEhHR4Ad0LM3sKCz1-nDqSb9uZNmRWR-hMZ=z+A@mail.gmail.com>
        <e027bfcf-1977-f2fa-a362-8faed91a19f9@microchip.com>
        <20230209094825.49f59208@kernel.org>
        <51134d12-1b06-6d6f-e798-7dd681a8f3ae@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Feb 2023 18:51:58 +0000 Ajay.Kathat@microchip.com wrote:
> > netdev should be created with a valid lladdr, is there something
> > wifi-specific here that'd prevalent that? The canonical flow is
> > to this before registering the netdev:
> 
> Here it's the timing in wilc1000 by when the MAC address is available to
> read from NV. NV read is available in "mac_open" net_device_ops instead
> of bus probe function. I think, mostly the operations on netdev which
> make use of mac address are performed after the "mac_open" (I may be
> missing something).
> 
> Does it make sense to assign a random address in probe and later read
> back from NV in mac_open to make use of stored value?

Hard to say, I'd suspect that may be even more confusing than
starting with zeroes. There aren't any hard rules around the
addresses AFAIK, but addrs are visible to user space. So user
space will likely make assumptions based on the most commonly 
observed sequence (reading real addr at probe).
