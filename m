Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D607DE97C
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 12:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbfJUKbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 06:31:36 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43197 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726725AbfJUKbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 06:31:36 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 46A9320A0E;
        Mon, 21 Oct 2019 06:31:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 21 Oct 2019 06:31:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=CYXABtpxxHxkOa8sx
        ojoEWlBiWI9jo3xJNQQzy0SJOc=; b=dWoTSBTdcRx+dIAPuOkRSnLeCtfH7IrY3
        rM1571GllJ/krpdHC4pqtfful6Jys6aztscEnzKY3fND0PgO0r5dvMr5Xws1jnCH
        /XbgjZfN5vp9XO+cnkzmQXPtqxofy391K6AUOloo5mIHD4grEO4fB5HIUCrtF+1c
        1pQRwbFYZfqMlTTM7WssajgODMX79LrbqjtaMd272ZJtXAfw2DNEynlHd3s4Tln3
        vTzSMNCi/qOv43QzwoJrh81H4mv++uT3cUHRAinhVmgmIIQflyr5sPxHHXlH48Ev
        Zs5ADiqoY00jXIDZQpOGf6Al/cMPDOxNxw3qDoMUxAsSu8m2XBqZw==
X-ME-Sender: <xms:BomtXVCoEez730HqT1B9VPOAVeW0Q7U8v6E8B_HEJwlPYASzPb3BLQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrkeehgdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucfkphepuddtledrieehrddvtddrvdegieenucfrrghrrghmpehmrghilh
    hfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigv
    pedt
X-ME-Proxy: <xmx:BomtXeSaqELaZ_8w9SadN9ZJcYWC1ppWZTjJHpzHf20OPlQud4W_sA>
    <xmx:BomtXfeaxWu3AFSRmxCIALuISh8xOZVJCYiACfhL59flafaNcqT0nw>
    <xmx:BomtXWg-WRbv3fNnk_4y8tZNlZHJZ1SRoCMbKOW17alG93cDksdXFg>
    <xmx:B4mtXa5g_koLSDyknd9i1bIokWQRlxTUj4-pLzuBHsXkBvqGp3VfsQ>
Received: from localhost.localdomain (bzq-109-65-20-246.red.bezeqint.net [109.65.20.246])
        by mail.messagingengine.com (Postfix) with ESMTPA id E1180D60065;
        Mon, 21 Oct 2019 06:31:32 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, vadimp@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/2] mlxsw: core: Extend QSFP EEPROM size
Date:   Mon, 21 Oct 2019 13:30:29 +0300
Message-Id: <20191021103031.32163-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Vadim says:

This patch set extends the size of QSFP EEPROM for the cable types
SSF-8436 and SFF-8636 from 256 bytes to 640 bytes. This allows ethtool
to show correct information for these cable types (more details below).

Patch #1 adds a macro that computes the EEPROM page number from the
provided offset specified in the request.

Patch #2 teaches the driver to access the information stored in the
upper pages of the QSFP memory map.

Details and examples:

SFF-8436 specification defines pages 0, 1, 2 and 3. Page 0 contains
lower memory page offsets (from 0x00 to 0x7f) and upper page offsets
(from 0x80 to 0xfe). Upper pages 1, 2 and 3 are optional and can be
empty.

Page 1 is provided if upper page 0 byte 0xc3 bit 6 is set.
Page 2 is provided if upper page 0 byte 0xc3 bit 7 is set.
Page 3 is provided if lower page 0 byte 0x02 bit 2 is cleared.
Offset 0xc3 for the upper page is provided as 0x43 = 0xc3 - 0x80.

As a result of exposing 256 bytes only, ethtool shows wrong information
for pages 1, 2 and 3. In the below hex dump from ethtool for a cable
compliant to SFF-8636 specification, it can be seen that EEPROM of this
device contains optical diagnostic page (lower page 0 byte 0x02 bit 2 is
cleared), but it is not exposed, as the length defined for this type is
256 bytes.

$ ethtool -m sfp42 hex on
Offset          Values
------          ------
0x0000:         11 07 00 ff 00 ff 00 00 00 55 55 00 00 00 00 00
0x0010:         00 00 00 00 00 00 2a 90 00 00 82 ae 00 00 00 00
0x0020:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0030:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0040:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0050:         00 00 00 00 00 00 00 00 00 00 00 00 00 01 00 00
0x0060:         00 00 ff 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0070:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0080:         11 8c 0c 80 00 00 00 00 00 00 00 05 ff 00 00 23
0x0090:         00 00 32 00 4d 65 6c 6c 61 6e 6f 78 20 20 20 20
0x00a0:         20 20 20 20 00 00 02 c9 4d 4d 41 31 42 30 30 2d
0x00b0:         53 53 31 20 20 20 20 20 41 32 42 68 0b b8 46 05
0x00c0:         02 07 f5 9e 4d 54 31 38 33 34 46 54 30 33 38 34
0x00d0:         36 20 20 20 31 38 30 37 30 33 00 00 0c 10 67 c2
0x00e0:         38 32 36 46 4d 41 32 32 36 49 30 31 31 35 20 20
0x00f0:         00 00 00 00 00 00 00 00 00 00 01 00 0e 00 00 00

After changing the length returned by get_module_info() callback from
256 bytes to 640 bytes, the upper pages 1, 2 and 3 are exposed by
ethtool. In the below hex dump from the same cable it can be seen that
the optical diagnostic page (page 3, from offset 0x0200) has non-zero
data.

$ ethtool -m sfp42 hex on
Offset          Values
------          ------
0x0000:         11 07 00 ff 00 ff 00 00 00 55 55 00 00 00 00 00
0x0010:         00 00 00 00 00 00 27 79 00 00 82 c5 00 00 00 00
0x0020:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0030:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0040:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0050:         00 00 00 00 00 00 00 00 00 00 00 00 00 01 00 00
0x0060:         00 00 ff 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0070:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0080:         11 8c 0c 80 00 00 00 00 00 00 00 05 ff 00 00 23
0x0090:         00 00 32 00 4d 65 6c 6c 61 6e 6f 78 20 20 20 20
0x00a0:         20 20 20 20 00 00 02 c9 4d 4d 41 31 42 30 30 2d
0x00b0:         53 53 31 20 20 20 20 20 41 32 42 68 0b b8 46 05
0x00c0:         02 07 f5 9e 4d 54 31 38 33 34 46 54 30 33 38 34
0x00d0:         36 20 20 20 31 38 30 37 30 33 00 00 0c 10 67 c2
0x00e0:         38 32 36 46 4d 41 32 32 36 49 30 31 31 35 20 20
0x00f0:         00 00 00 00 00 00 00 00 00 00 01 00 0e 00 00 00
0x0100:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0110:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0120:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0130:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0140:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0150:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0160:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0170:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0180:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0190:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x01a0:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x01b0:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x01c0:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x01d0:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x01e0:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x01f0:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0200:         50 00 f6 00 46 00 00 00 00 00 00 00 00 00 00 00
0x0210:         88 b8 79 18 87 5a 7a 76 00 00 00 00 00 00 00 00
0x0220:         00 00 00 00 00 00 00 00 00 00 18 30 0e 61 60 b7
0x0230:         87 71 01 d3 43 e2 03 a5 10 9a 0a ba 0f a0 0b b8
0x0240:         87 71 02 d4 43 e2 05 a5 00 00 00 00 00 00 00 00
0x0250:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0260:         a7 03 00 00 00 00 00 00 00 00 44 44 22 22 11 11
0x0270:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

And 'ethtool -m sfp42' shows the real values for the below fields, while
before it exposed zeros for these fields:

Laser bias current high alarm threshold   : 8.500 mA
Laser bias current low alarm threshold    : 5.492 mA
Laser bias current high warning threshold : 8.000 mA
Laser bias current low warning threshold  : 6.000 mA
Laser output power high alarm threshold   : 3.4673 mW / 5.40 dBm
Laser output power low alarm threshold    : 0.0724 mW / -11.40 dBm
Laser output power high warning threshold : 1.7378 mW / 2.40 dBm
Laser output power low warning threshold  : 0.1445 mW / -8.40 dBm
Module temperature high alarm threshold   : 80.00 degrees C / 176.00 F
Module temperature low alarm threshold    : -10.00 degrees C / 14.00 F
Module temperature high warning threshold : 70.00 degrees C / 158.00 F
Module temperature low warning threshold  : 0.00 degrees C / 32.00 F
Module voltage high alarm threshold       : 3.5000 V
Module voltage low alarm threshold        : 3.1000 V

Vadim Pasternak (2):
  mlxsw: reg: Add macro for getting QSFP module EEPROM page number
  mlxsw: core: Extend QSFP EEPROM size for ethtool

 .../net/ethernet/mellanox/mlxsw/core_env.c    | 23 ++++++++++++++-----
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  9 ++++++++
 2 files changed, 26 insertions(+), 6 deletions(-)

-- 
2.21.0

