Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59EE020B90B
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 21:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbgFZTHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 15:07:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34470 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgFZTHV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 15:07:21 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jotgy-002PGE-3s; Fri, 26 Jun 2020 21:07:16 +0200
Date:   Fri, 26 Jun 2020 21:07:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Adrian Pop <popadrian1996@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 1/2] mlxsw: core: Add ethtool support for
 QSFP-DD transceivers
Message-ID: <20200626190716.GG535869@lunn.ch>
References: <20200626144724.224372-1-idosch@idosch.org>
 <20200626144724.224372-2-idosch@idosch.org>
 <20200626151926.GE535869@lunn.ch>
 <CAL_jBfT93picGGoCNWQDY21pWmo3jffanhBzqVwm1kVbyEb4ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_jBfT93picGGoCNWQDY21pWmo3jffanhBzqVwm1kVbyEb4ow@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 06:33:55PM +0100, Adrian Pop wrote:
> >
> > Is page 03h valid for a QSFP DD? Do we add pages 10h and 11h after
> > page 03h, or instead of? How do we indicate to user space what pages
> > of data have been passed to it?
> >
> >    Andrew
> 
> >From QSFP-DD CMIS Rev 4.0: "In particular, support of the Lower Memory
> and of Page 00h is required for all modules, including passive copper
> cables. These pages are therefore always implemented. Additional
> support for Pages 01h, 02h and bank 0 of Pages 10h and 11h is required
> for all paged memory modules."
> 
> According to the same document, page 0x03 contains "User EEPROM
> (NVRs)". Byte 142, bit 2, page 0x01 indicates if the user page 0x03
> was implemented. I did not find anything about page 0x02 (where the
> user EEPROM is stored) in the documentation for QSFP. I suppose it is
> always implemented? If we really want to have it so it is similar to
> QSFP, one could send 896 bytes (instead of 768) and just fill that
> portion with 0 in case it's not implemented. Note that this is just an
> idea, I'm not aware of best practices in cases like this.

It does seem common to only return a subset of the pages. This patch
for example. We need some clear rules to known what the kernel has
passed to user space, so we can both correctly interpret when a subset
has been passed, and also ensure all drivers are doing the same thing.

Currently we have:

 *       ----------   ----------   ---------    ------------
 *      | Upper    | | Upper    | | Upper    | | Upper      |
 *      | Page 00h | | Page 01h | | Page 02h | | Page 03h   |
 *      |          | |(Optional)| |(Optional)| | (Optional) |
 *      |          | |          | |          | |            |
 *      |          | |          | |          | |            |
 *      |    ID    | |   AST    | |  User    | |  For       |
 *      |  Fields  | |  Table   | | EEPROM   | |  Cable     |
 *      |          | |          | | Data     | | Assemblies |
 *      |          | |          | |          | |            |
 *      |          | |          | |          | |            |
 *      -----------  -----------   ----------  --------------

You are saying pages 00h, 01h and 02h are mandatory for QSPF-DD.  Page
03h is optional, but when present, it seems to contain what is page
02h above. Since the QSPF KAPI has it, QSPF-DD KAPI should also have
it. So i would suggest that pages 10h and 11h come after that.

If a driver wants to pass a subset, it can, but it must always trim
from the right, it cannot remove pages from the middle.

     Andrew
