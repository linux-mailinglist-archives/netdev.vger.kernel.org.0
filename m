Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60AE35DC25
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 12:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241770AbhDMKHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 06:07:08 -0400
Received: from mail.pr-group.ru ([178.18.215.3]:64337 "EHLO mail.pr-group.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229815AbhDMKHH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 06:07:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-type:in-reply-to:
         references;
        bh=HEf7VqC2Wss6FYGxSqP/7RNfedhszWUGw4BQrDP1tyg=;
        b=VPYYSctHSk/nphLEpmM+D6Sq1rQQAuOB8ga0qbgQoY4DYn0KzZBx2DUSD7u9Zxf78aeXZWgYlO/jg
         vq9RtT5ZTmZX7yUG3xHHLI9weQL53gP204ndj9FvsZ/qdGOXiTzmq8Rq0Q7oWYUFv+xytAuVLhHgF1
         QlmE2zs6haMam5K7v9zwUJtBqSKVaRc51uV+iYXLXHpVWaQTkW9CIbLWfsDItrGeP/qZ0OLzFB9ml8
         l//BQkCWLcvIZmn8d5zGzOeqPdgrKrOcbDdtvXVP15k+QFyLzD7JagOsdYeMpLKorxu1jNDgoPX0uL
         UD2a8VFEaoBlvecWoeBU0GTKYbC3a4Q==
X-Spam-Status: No, hits=0.0 required=3.4
        tests=AWL: 0.000, BAYES_00: -1.665, CUSTOM_RULE_FROM: ALLOW,
        TOTAL_SCORE: -1.665,autolearn=ham
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from dhcp-179.ddg ([85.143.252.66])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Tue, 13 Apr 2021 13:06:31 +0300
Date:   Tue, 13 Apr 2021 13:06:23 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, system@metrotek.ru,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: phy: marvell-88x2222: check that link
 is operational
Message-ID: <20210413100623.4shge3pwq3vbpxhn@dhcp-179.ddg>
References: <cover.1618227910.git.i.bornyakov@metrotek.ru>
 <614b534f1661ecf1fff419e2f36eddfb0e6f066d.1618227910.git.i.bornyakov@metrotek.ru>
 <YHTacMwlsR8Wl5q/@lunn.ch>
 <20210413071930.52vfjkewkufl7hrb@dhcp-179.ddg>
 <20210413092348.GM1463@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210413092348.GM1463@shell.armlinux.org.uk>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 10:23:48AM +0100, Russell King - ARM Linux admin wrote:
> On Tue, Apr 13, 2021 at 10:19:30AM +0300, Ivan Bornyakov wrote:
> > On Tue, Apr 13, 2021 at 01:40:32AM +0200, Andrew Lunn wrote:
> > > On Mon, Apr 12, 2021 at 03:16:59PM +0300, Ivan Bornyakov wrote:
> > > > Some SFP modules uses RX_LOS for link indication. In such cases link
> > > > will be always up, even without cable connected. RX_LOS changes will
> > > > trigger link_up()/link_down() upstream operations. Thus, check that SFP
> > > > link is operational before actual read link status.
> > > 
> > > Sorry, but this is not making much sense to me.
> > > 
> > > LOS just indicates some sort of light is coming into the device. You
> > > have no idea what sort of light. The transceiver might be able to
> > > decode that light and get sync, it might not. It is important that
> > > mv2222_read_status() returns the line side status. Has it been able to
> > > achieve sync? That should be independent of LOS. Or are you saying the
> > > transceiver is reporting sync, despite no light coming in?
> > > 
> > > 	Andrew
> > 
> > Yes, with some SFP modules transceiver is reporting sync despite no
> > light coming in. So, the idea is to check that link is somewhat
> > operational before determing line-side status. 
> 
> Indeed - it should be a logical and operation - there is light present
> _and_ the PHY recognises the signal. This is what the commit achieves,
> although (iirc) doesn't cater for the case where there is no SFP cage
> attached.
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Correct, it does not, I only have HW with SFP cage attached.

