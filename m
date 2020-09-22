Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9976927450B
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 17:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgIVPNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 11:13:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726614AbgIVPNQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 11:13:16 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77EBB2399A;
        Tue, 22 Sep 2020 15:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600787595;
        bh=sDxOWSk3URShRW+jRtB7isZszFlwI8JcQsoggTQDudQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gBoxdX6yDF45Po2U9xlhRXEtDjWm9fj976FubzsnG2cNco7fWbOkfGLKBWo6uaMuC
         CkHnOXBbqAmM4DVDjiQfJ3hFnBE0IHOkWICQFpcPGToTUNEQv2ZoaG0lZiZgKD1mJJ
         ktpGi3dW6nDozoy12KChiuiOwYvFaDTO6kMt2XOw=
Date:   Tue, 22 Sep 2020 08:13:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stanislaw Kardach <skardach@marvell.com>
Cc:     <davem@davemloft.net>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>, <kda@semihalf.com>
Subject: Re: [PATCH net-next v2 3/3] octeontx2-af: add support for custom
 KPU entries
Message-ID: <20200922081313.6e7c8e3a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200922114014.rvdohzjwjvlukc3p@yoga>
References: <20200921175442.16789-1-skardach@marvell.com>
        <20200921175442.16789-4-skardach@marvell.com>
        <20200921162643.6a52361d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200922114014.rvdohzjwjvlukc3p@yoga>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Sep 2020 13:40:15 +0200 Stanislaw Kardach wrote:
> > So the driver loads the firmware contents, interprets them and programs
> > the device appropriately?
> > 
> > Real firmware files are not usually interpreted or parsed by the driver.  
> 
> Correct. I'm using the firmware file as a delivery method for a custom
> configuration. There are several reasons why I chose it:
> 
> 1. The parsing engine (KPU) has to be configured fully at RVU AF device
>    probe, before any networking part of that or other RVU devices is
>    configured. So I think this rules out devlink, ioctl or sysfs.
> 2. The configuration is rather extensive so cramping it into module
>    parameters doesn't seem right.
> 3. Adding it to Device Tree in form of custom nodes makes update process
>    risky to some users (as opposed to switching firmware file on a
>    filesystem).
> 4. The request_firmware API provides a nice abstraction for the blob data
>    source so I thought it might as well be used for fetching data of a
>    known structure. Especially that the full layout is visible in the
>    kernel and users might create those files themselves by hand.
> 
> That said all above might be because I'm unaware of a better interface to
> use in such situation. If there is, I would be obliged if you could point
> me in the right direction.

Sadly I don't think such interface exists today. You'd need to create
one. Parser configuration is something that has been coming up in
recent years but nobody done the work.

We try to push back on workarounds like this one to force people to
create proper abstract interfaces which can be used by multiple vendors.
