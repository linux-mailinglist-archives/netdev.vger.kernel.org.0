Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2DB920B459
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 17:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbgFZPT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 11:19:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34000 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFZPT2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 11:19:28 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1joq8U-002NjP-Jg; Fri, 26 Jun 2020 17:19:26 +0200
Date:   Fri, 26 Jun 2020 17:19:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, vadimp@mellanox.com, popadrian1996@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 1/2] mlxsw: core: Add ethtool support for
 QSFP-DD transceivers
Message-ID: <20200626151926.GE535869@lunn.ch>
References: <20200626144724.224372-1-idosch@idosch.org>
 <20200626144724.224372-2-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626144724.224372-2-idosch@idosch.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	case MLXSW_REG_MCIA_EEPROM_MODULE_INFO_ID_QSFP_DD:
> +		/* Use SFF_8636 as base type. ethtool should recognize specific
> +		 * type through the identifier value.
> +		 */
> +		modinfo->type       = ETH_MODULE_SFF_8636;
> +		/* Verify if module EEPROM is a flat memory. In case of flat
> +		 * memory only page 00h (0-255 bytes) can be read. Otherwise
> +		 * upper pages 01h and 02h can also be read. Upper pages 10h
> +		 * and 11h are currently not supported by the driver.
> +		 */
> +		if (module_info[MLXSW_REG_MCIA_EEPROM_MODULE_INFO_TYPE_ID] &
> +		    MLXSW_REG_MCIA_EEPROM_CMIS_FLAT_MEMORY)
> +			modinfo->eeprom_len = ETH_MODULE_SFF_8636_LEN;
> +		else
> +			modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN;
> +		break;

Although the upper pages 10h and 11h are not supported now, we
probably think about how they would be supported, to make sure we are
not going into a dead end.

From ethtool qsfp.c

/*
 *      Description:
 *      a) The register/memory layout is up to 5 128 byte pages defined by
 *              a "pages valid" register and switched via a "page select"
 *              register. Memory of 256 bytes can be memory mapped at a time
 *              according to SFF 8636.
 *      b) SFF 8636 based 640 bytes memory layout is presented for parser
 *
 *           SFF 8636 based QSFP Memory Map
 *
 *           2-Wire Serial Address: 1010000x
 *
 *           Lower Page 00h (128 bytes)
 *           ======================
 *           |                     |
 *           |Page Select Byte(127)|
 *           ======================
 *                    |
 *                    V
 *           ----------------------------------------
 *          |             |            |             |
 *          V             V            V             V
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
 *
 *
 **/

Is page 03h valid for a QSFP DD? Do we add pages 10h and 11h after
page 03h, or instead of? How do we indicate to user space what pages
of data have been passed to it?

   Andrew
