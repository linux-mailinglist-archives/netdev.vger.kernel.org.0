Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30E3D619A97
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 15:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbiKDOyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 10:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiKDOyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 10:54:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20DEE2B1AC;
        Fri,  4 Nov 2022 07:54:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC66C6222C;
        Fri,  4 Nov 2022 14:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A907C433D6;
        Fri,  4 Nov 2022 14:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667573641;
        bh=tzDa8YTj03bBk4FG2ZfMhfLiDD3T3czNHsssXCWXQho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hU/+8B+4FbxX6sG0iga4XA1p9d/+KLolv85RWkuRtoobJEM3Mv6lV/PoHz/ZjEH2e
         Spz80r3K+5RS0Zq7aHTB7Eje4zMy1vQusEYvOsPgin2ZzUH+GzuVRJTeaGn66XbZxe
         AmAiPkicLjlEJCPB9xBkDF1pe9GAutsx9GO91L1c=
Date:   Fri, 4 Nov 2022 15:53:57 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH net-next 0/14] pull-request: can-next 2022-10-31
Message-ID: <Y2UnhZf5/HkY6vwm@kroah.com>
References: <20221031154406.259857-1-mkl@pengutronix.de>
 <20221031202714.1eada551@kernel.org>
 <Y2CpRfuto8wFrXX+@kroah.com>
 <20221104130857.amzwa2mzmwhbljmk@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104130857.amzwa2mzmwhbljmk@pengutronix.de>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 02:08:57PM +0100, Marc Kleine-Budde wrote:
> On 01.11.2022 06:06:13, Greg Kroah-Hartman wrote:
> > Also, the line:
> > 
> > +	.attrs	= (struct attribute **)peak_usb_sysfs_attrs,
> > 
> > Is odd, there should never be a need to cast anything like this if you
> > are doing things properly.
> 
> After marking the struct attribute not as const, we can remove the cast:
> 
> | --- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> | +++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> | @@ -64,14 +64,14 @@ static ssize_t user_devid_show(struct device *dev, struct device_attribute *attr
> |  }
> |  static DEVICE_ATTR_RO(user_devid);
> |  
> | -static const struct attribute *peak_usb_sysfs_attrs[] = {
> | +static struct attribute *peak_usb_sysfs_attrs[] = {

Ah.  Yeah, I would love to make this a const pointer, but people do some
pretty crazy dynamic stuff with attribute groups at times, so that it
will not always work.

I have a long series of patches I'm working on that add more const
markings to the kobject and then the driver core apis, I'll add this
type of thing to the idea list as what to work on next.

thanks,

greg k-h
