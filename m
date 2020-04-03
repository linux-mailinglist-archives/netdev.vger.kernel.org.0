Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 314AA19D70E
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 15:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390863AbgDCNAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 09:00:40 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55727 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728117AbgDCNAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 09:00:40 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 44E5A5C037D;
        Fri,  3 Apr 2020 09:00:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 03 Apr 2020 09:00:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Wrlw4V/+PkxQRiQ2T
        cvCsjUeGg2ijs+K34QgKc/i3Y0=; b=w7lUEa3NGipmu2kuhB3ORXuN7jOQSmrED
        xbvJ8AYldIauyeYr/mliXGqL6ljpgjddbuy6FEjbkSJDSAxNoPG+86QBUZ1OrKhH
        Kn8WPTtExRYraeNHnr3RoMsumi1/st2H15SpzA23/USCYmCP1sitXhC0hlui9yuT
        fbOlIBA4K+kbHVpU93NFoatpXszytjnRAYKmQLL1eySn4RVatGFjpr+7HPXwjTMQ
        WOLTgKmau+iLV1cZ2rEJjKTygd7vRWhR3YB4yTRyLLXkeCXY7X9RG1X5TwXKMmph
        vnDSJ+Svr1yXhBW6YJCHhbBhM4OAOpB2Ghg9E4gRN8SIAZAtSDvGQ==
X-ME-Sender: <xms:djOHXpkYRFvWiYxLl5SgwR-FAxN3x-FhC_X-04S5qbFhvdQU1F6h-Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtdeigdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdr
    ohhrgh
X-ME-Proxy: <xmx:djOHXlYVFbWzpGmVNFTcH8v4BS-4WHaZRSbfb4YnqBzR9BhsbpmOiA>
    <xmx:djOHXoiID6PEyjdpmEQcN88TglqsiEPStlhqWEpgcE6g0rqmzoI5Iw>
    <xmx:djOHXjye8VfqCvKj5baJSEQlpeowR27QMABA7MMOaZZdW50oELliKA>
    <xmx:dzOHXjwoQBT5A7_u5cOeYL5ucVwUBOYpDPT2P0k_nvSpaDb6c4Xlug>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 111B03280069;
        Fri,  3 Apr 2020 09:00:36 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 0/2] mlxsw: spectrum_flower: Do not stop at FLOW_ACTION_{VLAN_MANGLE, PRIORITY}
Date:   Fri,  3 Apr 2020 16:00:08 +0300
Message-Id: <20200403130010.2471710-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Petr says:

The handlers for FLOW_ACTION_VLAN_MANGLE and FLOW_ACTION_PRIORITY end by
returning whatever the lower-level function that they call returns. If
there are more actions lined up after one of these actions, those are
never offloaded. Each of the two patches fixes one of those actions.

Petr Machata (2):
  mlxsw: spectrum_flower: Do not stop at FLOW_ACTION_PRIORITY
  mlxsw: spectrum_flower: Do not stop at FLOW_ACTION_VLAN_MANGLE

 .../ethernet/mellanox/mlxsw/spectrum_flower.c  | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

-- 
2.24.1

