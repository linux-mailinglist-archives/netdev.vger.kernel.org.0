Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF45F326DD3
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 17:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhB0QYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 11:24:53 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33140 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230010AbhB0QY2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Feb 2021 11:24:28 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lG2NQ-008lOw-KV; Sat, 27 Feb 2021 17:23:32 +0100
Date:   Sat, 27 Feb 2021 17:23:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Don Bollinger <don@thebollingers.org>
Cc:     arndb@arndb.de, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, brandon_chuang@edge-core.com,
        wally_wang@accton.com, aken_liu@edge-core.com, gulv@microsoft.com,
        jolevequ@microsoft.com, xinxliu@microsoft.com,
        'netdev' <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] eeprom/optoe: driver to read/write SFP/QSFP/CMIS
 EEPROMS
Message-ID: <YDpyBLFLD/E9D1OU@lunn.ch>
References: <20210215193821.3345-1-don@thebollingers.org>
 <YDl3f8MNWdZWeOBh@lunn.ch>
 <000901d70cb2$b2848420$178d8c60$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000901d70cb2$b2848420$178d8c60$@thebollingers.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I assume you have seen the work NVIDIA submitted last week? This idea of
> > linear pages is really restrictive and we are moving away from it.
> 
> No, I haven't seen it.  I can't seem to locate anything in the past month on
> LMKL from NVIDIA.  Please point me to it.

[RFC PATCH net-next 0/5] ethtool: Extend module EEPROM dump
Message-Id: <1614181274-28482-1-git-send-email-moshe@nvidia.com>

b4 should be able to fetch it for you, using that message id.

Clearly, we don't want two different kernel APIs for doing the same
thing. This new KAPI is still in its early days. You can contribute to
it, and make it work for your use case. If i understand correctly, you
are using Linux as a bootloader, and running the complete switch
driver in userspace, not making use of the Linux network stack. This
is not something the netdev community likes, but if you work within
the networking KAPI, rather than adding parallel KAPI, we can probably
work together. I think the biggest problem you have is identifiers.
Since you don't have the SFP associated to a netdev, the current IOCTL
interface which us the netdev name as an identifier does not work. But
the new code is netlink based. The identifier is just an attribute in
the message. See if you can use an alternative attribute which
directly identifies the SFP, not the netdev. It is O.K. to instantiate
an SFP device and then not make use of it in PHYLINK. So this should
work.

     Andrew
