Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07C12F040A
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 18:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389405AbfKERZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 12:25:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:50852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730895AbfKERZv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 12:25:51 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94142214B2;
        Tue,  5 Nov 2019 17:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572974750;
        bh=N7w8Age/S1L622Rz8RbBU6vyXF/UF4h5r5mKG0dYiRw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mmaPqWoH4jiRDUyASGcNfkVGttSk8WUcOyPKfY7xVkHVe5IAH+7tS/bqC5do51a8X
         ZZ1XKVaauQ085Uh/kEDH88NpgJxEQiRPV+D44L/IWDc11U6kwQbxsrNcEDerfn4Awj
         dJRm04jMaKluVkZ5IW9+mtbEQtTCSo5h0qj7+L6k=
Date:   Tue, 5 Nov 2019 18:25:25 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] rfkill: allocate static minor
Message-ID: <20191105172525.GA2851576@kroah.com>
References: <20191024174042.19851-1-marcel@holtmann.org>
 <20191024184408.GA260560@kroah.com>
 <B457050C-18F5-4171-A8A1-4CE95D908FAA@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B457050C-18F5-4171-A8A1-4CE95D908FAA@holtmann.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 10:23:57PM +0200, Marcel Holtmann wrote:
> Hi Greg,
> 
> >> udev has a feature of creating /dev/<node> device-nodes if it finds
> >> a devnode:<node> modalias. This allows for auto-loading of modules that
> >> provide the node. This requires to use a statically allocated minor
> >> number for misc character devices.
> >> 
> >> However, rfkill uses dynamic minor numbers and prevents auto-loading
> >> of the module. So allocate the next static misc minor number and use
> >> it for rfkill.
> > 
> > As rfkill has been around for a long time, what new use case is needing
> > to auto-load this based on a major number?
> 
> we have bug reports from iwd users where it fails opening /dev/rfkill. Since iwd can be actually started before the WiFi hardware is fully probed and all its drivers are loaded, we have a race-condition here if rfkill is not capable of auto-loading.
> 
> The difference is really that iwd is a fully self-contained WiFi daemon compared to wpa_supplicant which is just some sort of helper. iwd is fully hot plug capable as well compared to wpa_supplicant. It looks like this is exposing the race condition for our users. Frankly, we should have fixed rfkill a long time ago when we fixed uinput, uhid etc, but seems we forgot it. I assume mainly because it magically got loaded in time by some module dependencies.

You need a better email client, one with \n characters...

Anyway, this sounds reasonable, I'll go queue this up for 5.5.

thanks,

greg k-h
