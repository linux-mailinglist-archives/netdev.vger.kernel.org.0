Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EADCE32B3EC
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1840301AbhCCEIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:08:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:50040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238559AbhCCBqU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 20:46:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4ADFE64E09;
        Wed,  3 Mar 2021 01:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614735892;
        bh=g/Nrxgq7YikSY+59ZmOOKQHBI/hl0QXI7oFzO2j9uJs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YKduP3w8uIpRVm556tUbXDazdOfdMRY3Cc81yBOQPNNk12qvGgmCFcNKOhiy7/97a
         c7t7cwqmXGyx4bONa5g3Jg63Ym1haHoDWoVukFsmtlpEdbVhg04Y9hIwKj8tqQ++IW
         qhgde0ww/oula6P6egArzOfgJIqwQ+5S7hOGeLBLPdlvvjjpiLCf8R6cdHutH7C8X+
         ehJBqOjKCNzjhVCOymsESrF9bbibYTBCyNHo8iI/WEsXNu0/KySPx1EirwwWco1NnR
         2LUmh+e9C6ep3YsQfleg/wDMbJS0CwxiDQ1LzmoC34YrFSCEWo5taOBbp8Fkk3Vm1q
         a68kOkgfuIizw==
Date:   Tue, 2 Mar 2021 17:44:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zbynek Michl <zbynek.michl@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [regression] Kernel panic on resume from sleep
Message-ID: <20210302174451.59341082@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAJH0kmzrf4MpubB1RdcP9mu1baLM0YcN-MXKY41ouFHxD8ndNg@mail.gmail.com>
References: <CAJH0kmzrf4MpubB1RdcP9mu1baLM0YcN-MXKY41ouFHxD8ndNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Mar 2021 23:11:05 +0100 Zbynek Michl wrote:
> Hello,
> 
> Can anybody help me with the following kernel issue?
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=983595
> 
> Do I understand it correctly that the kernel crashes due to the bug in
> the alx driver?

Order of calls on resume looks suspicious, can you give this a try?

diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 9b7f1af5f574..9e02f8864593 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1894,13 +1894,16 @@ static int alx_resume(struct device *dev)
 
        if (!netif_running(alx->dev))
                return 0;
-       netif_device_attach(alx->dev);
 
        rtnl_lock();
        err = __alx_open(alx, true);
        rtnl_unlock();
+       if (err)
+               return err;
 
-       return err;
+       netif_device_attach(alx->dev);
+
+       return 0;
 }
 
 static SIMPLE_DEV_PM_OPS(alx_pm_ops, alx_suspend, alx_resume);
