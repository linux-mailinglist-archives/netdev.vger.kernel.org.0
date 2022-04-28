Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2E74512E08
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 10:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343744AbiD1ITz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 04:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235364AbiD1ITy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 04:19:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B00C13CED;
        Thu, 28 Apr 2022 01:16:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4DF761F49;
        Thu, 28 Apr 2022 08:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614B5C385A9;
        Thu, 28 Apr 2022 08:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651133800;
        bh=uyaBsEuphXYiLhzlz1YbrzEAdzSDc6RcP79zk/xCzZw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zliC0CRx9pxFc1IgS706nqaw5DQ2lD6VWxky2vE0ZwcKEns0jPOwg7PWn3l0ljN9A
         h9i1h78elkEKXX0vfZYJUK5OJeH9LP5GbgwJ/VD0n67bYyprgLXTaHmJsuY1jLU011
         Oamp4pIcvzeVdXlZIiPNQZbBZVG5PrO0IuvivIQg=
Date:   Thu, 28 Apr 2022 10:16:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Duoming Zhou <duoming@zju.edu.cn>,
        krzysztof.kozlowski@linaro.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        alexander.deucher@amd.com, akpm@linux-foundation.org,
        broonie@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v4] nfc: ... device_is_registered() is data race-able
Message-ID: <YmpNZOaJ1+vWdccK@kroah.com>
References: <20220427011438.110582-1-duoming@zju.edu.cn>
 <20220427174548.2ae53b84@kernel.org>
 <38929d91.237b.1806f05f467.Coremail.linma@zju.edu.cn>
 <YmpEZQ7EnOIWlsy8@kroah.com>
 <2d7c9164.2b1f.1806f2a8ed9.Coremail.linma@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d7c9164.2b1f.1806f2a8ed9.Coremail.linma@zju.edu.cn>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 03:55:01PM +0800, Lin Ma wrote:
> Hello Greg,
> 
> 
> > 
> > You should not be making these types of checks outside of the driver
> > core.
> > 
> > > This is by no means matching our expectations as one of our previous patch relies on the device_is_registered code.
> > 
> > Please do not do that.
> > 
> > > 
> > > -> the patch: 3e3b5dfcd16a ("NFC: reorder the logic in nfc_{un,}register_device")
> > > 
> > <...>
> > > 
> > > In another word, the device_del -> kobject_del -> __kobject_del is not protected by the device_lock.
> > 
> > Nor should it be.
> > 
> 
> I may have mistakenly presented my point. In fact, there is nothing wrong with the device core, nothing to do with the internal of device_del and device_is_registered implementation. And, of course, we will not add any code or do any modification to the device/driver base code.
> 
> The point is the combination of device_is_registered + device_del, which is used in NFC core, is not safe.

It shouldn't be, if you are using it properly :)

> That is to say, even the device_is_registered can return True even the device_del is executing in another thread.

Yes, you should almost never use that call.  Seems the nfc subsystem is
the most common user of it for some reason :(

> (By debugging we think this is true, correct me if it is not)
> 
> Hence we want to add additional state in nfc_dev object to fix that, not going to add any state in device/driver core.

What state are you trying to track here exactly?

thanks,

greg k-h
