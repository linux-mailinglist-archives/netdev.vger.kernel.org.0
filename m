Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7186B341068
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 23:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbhCRWgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 18:36:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35702 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230368AbhCRWgb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 18:36:31 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lN1Fh-00BlQX-Sy; Thu, 18 Mar 2021 23:36:25 +0100
Date:   Thu, 18 Mar 2021 23:36:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     Don Bollinger <don@thebollingers.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Jakub Kicinski' <kuba@kernel.org>,
        'Adrian Pop' <pop.adrian61@gmail.com>,
        'Michal Kubecek' <mkubecek@suse.cz>, netdev@vger.kernel.org,
        'Vladyslav Tarasiuk' <vladyslavt@nvidia.com>
Subject: Re: [RFC PATCH V3 net-next 1/5] ethtool: Allow network drivers to
 dump arbitrary EEPROM data
Message-ID: <YFPV6RLWoklMHVYz@lunn.ch>
References: <1615828363-464-1-git-send-email-moshe@nvidia.com>
 <1615828363-464-2-git-send-email-moshe@nvidia.com>
 <002201d719ea$e60d9350$b228b9f0$@thebollingers.org>
 <0a8beb69-972b-3b00-a67e-0e97f9fda8ea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a8beb69-972b-3b00-a67e-0e97f9fda8ea@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +static int eeprom_data_parse_request(struct ethnl_req_info *req_info,
> > > struct nlattr **tb,
> > > +                                  struct netlink_ext_ack *extack) {
> > > +     struct eeprom_data_req_info *request =
> > > EEPROM_DATA_REQINFO(req_info);
> > > +     struct net_device *dev = req_info->dev;
> > > +
> > > +     if (!tb[ETHTOOL_A_EEPROM_DATA_OFFSET] ||
> > > +         !tb[ETHTOOL_A_EEPROM_DATA_LENGTH] ||
> > > +         !tb[ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS])
> > > +             return -EINVAL;
> > Suggestion:  Consider using i2c address 0x50 as a default if none is given.
> > 0x50 is the first 256 bytes of SFP, and all of QSFP and CMIS EEPROM.  If
> > there is a page given on an SFP device, then you know i2c address is 0x51.
> > The only thing that REQUIRES 0x51 is legacy offset 256-511 on SFP.  Keep the
> > i2c address, but make it optional for the non-standard devices that Andrew
> > has mentioned, and for that one section of SFP data that requires it.  And
> > document it for the user.
> Agree, but thought to have that i2c address default set on userspace, so
> here we expect it.

I would make it mandatory. If you default it to 0x50, the current
message structure has no way of including this information in the
reply. So user space gets some data, but it has no idea from where?

       Andrew
