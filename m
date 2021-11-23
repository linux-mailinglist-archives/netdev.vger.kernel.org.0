Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4D0459AEE
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 05:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbhKWEQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 23:16:03 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46896 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230018AbhKWEQC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 23:16:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=H92rqvyk1rd6DC1X2BlHwRhmAU3aWdL4gDetNR6UYCE=; b=Yu
        g/OmU6VIJcDQwIDWURwxEfRenbGeLy4KwS6BVDRoUb2nBWXw6/ijN9s4Esqc+4nQ1YN8y8OcZ1l/X
        XgUcQOBTjuUd3h9iPSUV/BoWDalkNVn2kSm0yvCIVZthl/RYiW7f0T0GxR6X8wTTpXWxCb49S2ctY
        yXM71yMxHsFFtIE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mpNAU-00EMZb-CN; Tue, 23 Nov 2021 05:12:30 +0100
Date:   Tue, 23 Nov 2021 05:12:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     zhuyinbo <zhuyinbo@loongson.cn>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, masahiroy@kernel.org,
        michal.lkml@markovi.net, ndesaulniers@google.com,
        netdev@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/2] modpost: file2alias: fixup mdio alias garbled
 code in modules.alias
Message-ID: <YZxqLi7/JDN9mQoK@lunn.ch>
References: <1637583298-20321-1-git-send-email-zhuyinbo@loongson.cn>
 <YZukJBsf3qMOOK+Y@lunn.ch>
 <5b561d5f-d7ac-4d90-e69e-5a80a73929e0@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5b561d5f-d7ac-4d90-e69e-5a80a73929e0@loongson.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 09:33:03AM +0800, zhuyinbo wrote:
> 
> 在 2021/11/22 下午10:07, Andrew Lunn 写道:
> 
>     On Mon, Nov 22, 2021 at 08:14:57PM +0800, Yinbo Zhu wrote:
> 
>         After module compilation, module alias mechanism will generate a ugly
>         mdio modules alias configure if ethernet phy was selected, this patch
>         is to fixup mdio alias garbled code.
> 
>         In addition, that ugly alias configure will cause ethernet phy module
>         doens't match udev, phy module auto-load is fail, but add this patch
>         that it is well mdio driver alias configure match phy device uevent.
> 
>     What PHY do you have problems with? What is the PHY id and which
>     driver should be loaded.
> 
>     This code has existed a long time, so suddenly saying it is wrong and
>     changing it needs a good explanation why it is wrong. Being ugly is
>     not a good reason.
> 
>         Andrew
> 
> Hi Andrew,
> 
>     Use default mdio configure, After module compilation, mdio alias configure
> is following and it doesn't match
> 
>     the match phy dev(mdio dev)  uevent, because the mdio alias configure 
> "0000000101000001000011111001????"  include "?" and

A PHY ID generally break up into 3 parts.

The OUI of the manufacture.
The device.
The revision

The ? means these bits don't matter. Those correspond to the
revision. Generally, a driver can driver any revision of the PHY,
which is why those bits don't matter.

So when a driver probes with the id 00000001010000010000111110010110
we expect user space to find the best match, performing wildcard
expansion. So the ? will match anything.

Since this is worked for a long time, do you have an example where it
is broken? If so, which PHY driver? If it is broken, no driver is
loaded, or the wrong driver is loaded, i expect it is a bug in a
specific driver. And we should fix that bug in the specific driver.

     Andrew
