Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5CABF208
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 13:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbfIZLo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 07:44:27 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:53187 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726379AbfIZLo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 07:44:27 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8275121FE0;
        Thu, 26 Sep 2019 07:44:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 26 Sep 2019 07:44:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=TF6h/mo61lTQbbzWopZiFd1tNRs3q3m2I/WCdfr5Xwc=; b=uBRmB2OF
        8MX3RBraH/xWXZjKKaYonU6q9xOwrZAaZxThH5WTQmPe5qJ/dRzu5yg0rfKfL952
        TWsFNhJDdMXgczw3aTJOxEQzeaNcTlNFfg1iaCRx/+psL/aimStDxDITi8nLhcfL
        ZPwRoh/ye5XT+McG07ZJuTucoSdIKQVhesOoLAMh2BnjWAy4efobrgkYHdR+fiqU
        JYnXWIUFvNoivATkiCIBqoIVRCnfssQTPTMUue5SW7at7is1IrxiEhGikANp0aTZ
        I1XFOsIpjYZ5dx6Yjp5WZW6fLsCHs7sSlLARxCXrfaG069nsQ6Gt4i52uc14o/BK
        kYOzLppMFbA8CA==
X-ME-Sender: <xms:mqSMXRcu-bF41Hwhp7i--xA7nCjTionVwb38B2l8ZYSWYya1CU2N4Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrfeeggdegfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppeduleefrd
    egjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehi
    ughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:mqSMXcag7St0wlC8F2HdDr4vlC8bToU1LoiQK5EuNnXsrVEqri7CsQ>
    <xmx:mqSMXfDQ3hTfIhL_aB8zfjQID8LY3iNR0bEUUlhcZdYMI9ddU82vvg>
    <xmx:mqSMXXKdn-UKkLiwUyHRK0z5-oVSx7CjJbx-175x2Dm_01GpLmbeQg>
    <xmx:mqSMXRIGXObLy1T7cihTrlByVWab-MrE9LeaTgVewxxnvQ6orW0e5Q>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id A2A138005A;
        Thu, 26 Sep 2019 07:44:23 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, alexanderk@mellanox.com,
        mlxsw@mellanox.com, Danielle Ratson <danieller@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 3/3] mlxsw: spectrum_flower: Fail in case user specifies multiple mirror actions
Date:   Thu, 26 Sep 2019 14:43:40 +0300
Message-Id: <20190926114340.9483-4-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190926114340.9483-1-idosch@idosch.org>
References: <20190926114340.9483-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@mellanox.com>

The ASIC can only mirror a packet to one port, but when user is trying
to set more than one mirror action, it doesn't fail.

Add a check if more than one mirror action was specified per rule and if so,
fail for not being supported.

Fixes: d0d13c1858a11 ("mlxsw: spectrum_acl: Add support for mirror action")
Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 0ad1a24abfc6..b607919c8ad0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -21,6 +21,7 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 					 struct netlink_ext_ack *extack)
 {
 	const struct flow_action_entry *act;
+	int mirror_act_count = 0;
 	int err, i;
 
 	if (!flow_action_has_entries(flow_action))
@@ -105,6 +106,11 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 		case FLOW_ACTION_MIRRED: {
 			struct net_device *out_dev = act->dev;
 
+			if (mirror_act_count++) {
+				NL_SET_ERR_MSG_MOD(extack, "Multiple mirror actions per rule are not supported");
+				return -EOPNOTSUPP;
+			}
+
 			err = mlxsw_sp_acl_rulei_act_mirror(mlxsw_sp, rulei,
 							    block, out_dev,
 							    extack);
-- 
2.21.0

