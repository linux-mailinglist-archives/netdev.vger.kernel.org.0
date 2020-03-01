Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFBF4174B23
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 06:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgCAFUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 00:20:37 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38646 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgCAFUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 00:20:37 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 535F815BD8502;
        Sat, 29 Feb 2020 21:20:36 -0800 (PST)
Date:   Sat, 29 Feb 2020 21:20:35 -0800 (PST)
Message-Id: <20200229.212035.1001013376740500991.davem@davemloft.net>
To:     vicamo@gmail.com
Cc:     grundler@chromium.org, hayeswang@realtek.com,
        kai.heng.feng@canonical.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, pmalani@chromium.org,
        vicamo.yang@canonical.com
Subject: Re: [PATCH v2] r8152: check disconnect status after long sleep
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200226153710.239838-1-vicamo@gmail.com>
References: <20200224.144714.329725174070305071.davem@davemloft.net>
        <20200226153710.239838-1-vicamo@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Feb 2020 21:20:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: You-Sheng Yang <vicamo@gmail.com>
Date: Wed, 26 Feb 2020 23:37:10 +0800

> From: You-Sheng Yang <vicamo.yang@canonical.com>
> 
> Dell USB Type C docking WD19/WD19DC attaches additional peripherals as:
> 
>   /: Bus 02.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/6p, 5000M
>       |__ Port 1: Dev 11, If 0, Class=Hub, Driver=hub/4p, 5000M
>           |__ Port 3: Dev 12, If 0, Class=Hub, Driver=hub/4p, 5000M
>           |__ Port 4: Dev 13, If 0, Class=Vendor Specific Class,
>               Driver=r8152, 5000M
> 
> where usb 2-1-3 is a hub connecting all USB Type-A/C ports on the dock.
> 
> When hotplugging such dock with additional usb devices already attached on
> it, the probing process may reset usb 2.1 port, therefore r8152 ethernet
> device is also reset. However, during r8152 device init there are several
> for-loops that, when it's unable to retrieve hardware registers due to
> being disconnected from USB, may take up to 14 seconds each in practice,
> and that has to be completed before USB may re-enumerate devices on the
> bus. As a result, devices attached to the dock will only be available
> after nearly 1 minute after the dock was plugged in:
 ...
> To solve this long latency another test to RTL8152_UNPLUG flag should be
> added after those 20ms sleep to skip unnecessary loops, so that the device
> probe can complete early and proceed to parent port reset/reprobe process.
> 
> This can be reproduced on all kernel versions up to latest v5.6-rc2, but
> after v5.5-rc7 the reproduce rate is dramatically lowered to 1/30 or less
> while it was around 1/2.
> 
> Signed-off-by: You-Sheng Yang <vicamo.yang@canonical.com>

Applied, thank you.
