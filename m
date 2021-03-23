Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2CF345540
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 03:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbhCWCEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 22:04:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42030 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229472AbhCWCEN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 22:04:13 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lOWOi-00CVqE-Ps; Tue, 23 Mar 2021 03:03:56 +0100
Date:   Tue, 23 Mar 2021 03:03:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Don Bollinger <don@thebollingers.org>
Cc:     'Moshe Shemesh' <moshe@nvidia.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Jakub Kicinski' <kuba@kernel.org>,
        'Adrian Pop' <pop.adrian61@gmail.com>,
        'Michal Kubecek' <mkubecek@suse.cz>, netdev@vger.kernel.org,
        'Vladyslav Tarasiuk' <vladyslavt@nvidia.com>
Subject: Re: [RFC PATCH V4 net-next 1/5] ethtool: Allow network drivers to
 dump arbitrary EEPROM data
Message-ID: <YFlMjO4ZMBCcJqQ7@lunn.ch>
References: <1616433075-27051-1-git-send-email-moshe@nvidia.com>
 <1616433075-27051-2-git-send-email-moshe@nvidia.com>
 <006801d71f47$a61f09b0$f25d1d10$@thebollingers.org>
 <YFk13y19yMC0rr04@lunn.ch>
 <007b01d71f83$2e0538f0$8a0faad0$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <007b01d71f83$2e0538f0$8a0faad0$@thebollingers.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I don't even see a need for this. The offset should be within one 1/2
> page, of
> > one bank. So offset >= 0 and <= 127. Length is also > 0 and
> > <- 127. And offset+length is <= 127.
> 
> I like the clean approach, but...   How do you request low memory?

Duh!

I got my conditions wrong. Too focused on 1/2 pages to think that two
of them makes one page!

Lets try again:

offset < 256
0 < len < 128

if (offset < 128)
   offset + len < 128
else
   offset + len < 256

Does that look better?

Reading bytes from the lower 1/2 of page 0 should give the same data
as reading data from the lower 1/2 of page 42. So we can allow that,
but don't be too surprised when an SFP gets it wrong and gives you
rubbish. I would suggest ethtool(1) never actually does read from the
lower 1/2 of any page other than 0.

And i agree about documentation. I would suggest a comment in
ethtool_netlink.h, and the RST documentation.

		   Andrew

