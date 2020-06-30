Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C17F20EA27
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgF3AWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:22:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38244 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbgF3AWF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 20:22:05 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jq42B-002uXm-W3; Tue, 30 Jun 2020 02:21:59 +0200
Date:   Tue, 30 Jun 2020 02:21:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Adrian Pop <popadrian1996@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 1/2] mlxsw: core: Add ethtool support for
 QSFP-DD transceivers
Message-ID: <20200630002159.GA597495@lunn.ch>
References: <20200626144724.224372-1-idosch@idosch.org>
 <20200626144724.224372-2-idosch@idosch.org>
 <20200626151926.GE535869@lunn.ch>
 <CAL_jBfT93picGGoCNWQDY21pWmo3jffanhBzqVwm1kVbyEb4ow@mail.gmail.com>
 <20200626190716.GG535869@lunn.ch>
 <CAL_jBfQMQbMAFeHji2_Y_Y_gC20S_0QL33wjPgPBaKeVRLg1SQ@mail.gmail.com>
 <20200627191648.GA245256@shredder>
 <CAL_jBfTKW_T-Pf2_shLm7N-ve_eg3G=nTD+6Fc3ZN4aHncm9YQ@mail.gmail.com>
 <20200628115557.GA273881@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200628115557.GA273881@shredder>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Adrian,
> 
> Thanks for the detailed response. I don't think the kernel should pass
> fake pages only to make it easier for user space to parse the
> information. What you are describing is basic dissection and it's done
> all the time by wireshark / tcpdump.
> 
> Anyway, even we pass a fake page 03h, page 11h can still be at a
> variable offset. See table 8-28 [1], bits 1-0 at offset 142 in page 01h
> determine the size of pages 10h and 11h:
> 
> 0 - each page is 128 bytes in size
> 1 - each page is 256 bytes in size
> 2 - each page is 512 bytes in size
> 
> So a completely stable layout (unless I missed something) will entail
> the kernel sending 1664 bytes to user space each time. This looks
> unnecessarily rigid to me. The people who wrote the standard obviously
> took into account the fact that the page layout needs to be discoverable
> from the data and I think we should embrace it and only pass valid
> information to user space.

O.K. That makes things more complex. And i would say, Ido is correct,
we need to make use of the discoverable features.

I've no practice experience with modules other than plain old SFPs,
1G. And those have all sorts of errors, even basic things like the CRC
are systematically incorrect because they are not recalculated after
adding the serial number. We have had people trying to submit patches
to ethtool to make it ignore bits so that it dumps more information,
because the manufacturer failed to set the correct bits, etc.

Ido, Adrian, what is your experience with these QSFP-DD devices. Are
they generally of better quality, the EEPROM can be trusted? Is there
any form of compliance test.

If we go down the path of using the discovery information, it means we
have no way for user space to try to correct for when the information
is incorrect. It cannot request specific pages. So maybe we should
consider an alternative?

The netlink ethtool gives us more flexibility. How about we make a new
API where user space can request any pages it want, and specify the
size of the page. ethtool can start out by reading page 0. That should
allow it to identify the basic class of device. It can then request
additional pages as needed.

The nice thing about that is we don't need two parsers of the
discovery information, one in user and second in kernel space. We
don't need to guarantee these two parsers agree with each other, in
order to correctly decode what the kernel sent to user space. And user
space has the flexibility to work around known issues when
manufactures get their EEPROM wrong.

	     Andrew
