Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3A4F19E99C
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 08:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgDEGuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 02:50:54 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:53835 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726307AbgDEGux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 02:50:53 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id BB0BE5C017E;
        Sun,  5 Apr 2020 02:50:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 05 Apr 2020 02:50:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=7muQb6lngjlg+ssBZ
        /GglkWHs8kdMpVJyjhsC+/7Heg=; b=B06La6hh5KTrrPYq82P5ikWOINqfYhm+P
        k8TS+DhQPlybrRTxA88qNFpgkPsd2SQPlsaIjFWTKGW47QwvvcgFR0WQXyPxuin1
        d9pLmrK+8AwRSkdq36Esdosq1kuSy15aKSjoF2+pIsnogMUOfFHsH70chARx6yB9
        HFKHxKjze2njRw3bEELiw0t+QjVO2OKcqCRnpiTg+dPovm+sHQGWpSsouEGTuh/a
        OZNyJrz5EHqtYQ9Cm7dCZGCIdHxccVGqXeg7xuTVw/rNO8Z6egpHyWGEgzJdS+06
        xGywojJzCngCW0s+W5XWXElAOKZEYxIVrMJWJibNRrgnolHQZO4WA==
X-ME-Sender: <xms:zH-JXpLvkIUUSZR-xcumKxo3XRaXSBuX4oH-7Qu70kZsSZT873V_Hg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddtgddujecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdr
    ohhrgh
X-ME-Proxy: <xmx:zH-JXtmHTtXw6y9G_zbvkQgRkgn_36JyhTYXRb7QOwPl2Z7O87RsHA>
    <xmx:zH-JXiI9dq6xEO7FGa7ZWx_sjVUHEoN-wURYmofMl_izaXDlePDYYg>
    <xmx:zH-JXq5iEsHiYvQYvh1Dvz8EjuPjvy9i2dIrefWM_CVIaONwftFs1A>
    <xmx:zH-JXi8kVczzO1_iPe3crTlE8OVVohowoRCsNBUWiF3XOcif6Q1CVg>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 53C1D306D20E;
        Sun,  5 Apr 2020 02:50:51 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net v2 0/2] mlxsw: spectrum_flower: Do not stop at FLOW_ACTION_{VLAN_MANGLE, PRIORITY}
Date:   Sun,  5 Apr 2020 09:50:20 +0300
Message-Id: <20200405065022.2578662-1-idosch@idosch.org>
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

v2:
* Patch #1: Use valid SHA1 ID in Fixes line (Dave)

Petr Machata (2):
  mlxsw: spectrum_flower: Do not stop at FLOW_ACTION_PRIORITY
  mlxsw: spectrum_flower: Do not stop at FLOW_ACTION_VLAN_MANGLE

 .../ethernet/mellanox/mlxsw/spectrum_flower.c  | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

-- 
2.24.1

