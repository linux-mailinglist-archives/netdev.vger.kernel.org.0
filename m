Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D88FE3D1D
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 22:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfJXUYA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 24 Oct 2019 16:24:00 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:52701 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727394AbfJXUX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 16:23:59 -0400
Received: from marcel-macpro.fritz.box (p4FEFC197.dip0.t-ipconnect.de [79.239.193.151])
        by mail.holtmann.org (Postfix) with ESMTPSA id 865C3CECF6;
        Thu, 24 Oct 2019 22:32:58 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3594.4.19\))
Subject: Re: [PATCH] rfkill: allocate static minor
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20191024184408.GA260560@kroah.com>
Date:   Thu, 24 Oct 2019 22:23:57 +0200
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B457050C-18F5-4171-A8A1-4CE95D908FAA@holtmann.org>
References: <20191024174042.19851-1-marcel@holtmann.org>
 <20191024184408.GA260560@kroah.com>
To:     Greg KH <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3594.4.19)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

>> udev has a feature of creating /dev/<node> device-nodes if it finds
>> a devnode:<node> modalias. This allows for auto-loading of modules that
>> provide the node. This requires to use a statically allocated minor
>> number for misc character devices.
>> 
>> However, rfkill uses dynamic minor numbers and prevents auto-loading
>> of the module. So allocate the next static misc minor number and use
>> it for rfkill.
> 
> As rfkill has been around for a long time, what new use case is needing
> to auto-load this based on a major number?

we have bug reports from iwd users where it fails opening /dev/rfkill. Since iwd can be actually started before the WiFi hardware is fully probed and all its drivers are loaded, we have a race-condition here if rfkill is not capable of auto-loading.

The difference is really that iwd is a fully self-contained WiFi daemon compared to wpa_supplicant which is just some sort of helper. iwd is fully hot plug capable as well compared to wpa_supplicant. It looks like this is exposing the race condition for our users. Frankly, we should have fixed rfkill a long time ago when we fixed uinput, uhid etc, but seems we forgot it. I assume mainly because it magically got loaded in time by some module dependencies.

Regards

Marcel

