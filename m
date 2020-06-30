Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A68D20F550
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 15:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387965AbgF3NAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 09:00:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39314 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387860AbgF3NAg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 09:00:36 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jqFsF-002z9d-JA; Tue, 30 Jun 2020 15:00:31 +0200
Date:   Tue, 30 Jun 2020 15:00:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     vadimp@mellanox.com, Adrian Pop <popadrian1996@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 1/2] mlxsw: core: Add ethtool support for
 QSFP-DD transceivers
Message-ID: <20200630130031.GH597495@lunn.ch>
References: <20200626144724.224372-2-idosch@idosch.org>
 <20200626151926.GE535869@lunn.ch>
 <CAL_jBfT93picGGoCNWQDY21pWmo3jffanhBzqVwm1kVbyEb4ow@mail.gmail.com>
 <20200626190716.GG535869@lunn.ch>
 <CAL_jBfQMQbMAFeHji2_Y_Y_gC20S_0QL33wjPgPBaKeVRLg1SQ@mail.gmail.com>
 <20200627191648.GA245256@shredder>
 <CAL_jBfTKW_T-Pf2_shLm7N-ve_eg3G=nTD+6Fc3ZN4aHncm9YQ@mail.gmail.com>
 <20200628115557.GA273881@shredder>
 <20200630002159.GA597495@lunn.ch>
 <20200630055945.GA378738@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630055945.GA378738@shredder>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Sounds sane to me... I know that in the past Vadim had to deal with
> various faulty modules. Vadim, is this something we can support? What
> happens if user space requests a page that does not exist? For example,
> in the case of QSFP-DD, lets say we do not provide page 03h but user
> space still wants it because it believes manufacturer did not set
> correct bits.

Hi Ido

I can see two scenarios.

This API is retrofitted to a firmware which only supports pre-defined
linear dumps. A page is requested which is not part of the
dump. EOPNOTSUPP seems like a good response.

The second is for a page which does not exist in the module. I would
just let the i2c bus master perform the transfer. Some might return
EIO, ENODEV if the SFP does not respond. Otherwise it might return
0xff from pullups, or random junk. Hopefully each page as a checksum,
and hopefully the vendor actually get the checksum correct? So let
userspace either deal with the error code, or whatever data is
provided.

The current code already to some extent handles missing data, it uses
the length to determine if the page is present or not. So it is not
too big a change to look error codes for individual pages.

    Andrew

