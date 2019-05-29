Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 757FF2D728
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 10:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbfE2IAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 04:00:04 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45541 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726005AbfE2IAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 04:00:03 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 84AAA22429;
        Wed, 29 May 2019 04:00:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 29 May 2019 04:00:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=bn6fwbC5Z9ZLYKA9wkpqfzJvwrDax4FqYBJkZDxxjWc=; b=VGBiFsN8
        ZgTSuySsXv4iTUutMG2obksaPoOex8SQbFsBanIqDcjfpVN/lLg3sb5s4o2J1EaO
        1onAK4g9W8FRKM9OqLHXKnwNe++jOccwtx9rZjX5CKC2nq69SkTmRRnc64AMx2rQ
        bk+IZflsUhedXx87MAcT9Uo1K+9fWdI1won9dg0wdk8QHRySTJ77FDFTD7f/+rzh
        yK5X+gw6qFtFPHIYZTCfgLY7aVdb6ncrFuV9aRJwvIZ+p3RVNPrcxyteqd9HqY4/
        GrqyVBo+LcTBBYywe4coAzlrUQe+m5XrLfzKzxYX4rYVe/6LM9IY7IbqqsKcP9Hc
        wNikNYjKzI4VQw==
X-ME-Sender: <xms:AjzuXAsTO46TbYgNNsCeOzKeoAuFmo9HH731FujMwk0yi0xY1x_aKA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddviedguddvjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgeptd
X-ME-Proxy: <xmx:AjzuXGwY8eTzKjzXRN_ycm-Z41Gkrd_1KN9sPWyoWdRqGTDGrfkOSw>
    <xmx:AjzuXIItbkJa8iWIlQ4MpDM34OJNSlVdlhuzPiemogplQ3gPDAWR1w>
    <xmx:AjzuXKxMbJEOCgwbVFfKM1LY4nFI2uoHtN3iOndQXRW1dxacO3Y45Q>
    <xmx:AjzuXCqLtiaelYPoV-0TT-veNCGrRcK-FtO6gJOeFdlJjWfdYzy6WQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id DBC4B38008C;
        Wed, 29 May 2019 04:00:00 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 1/2] mlxsw: spectrum_acl: Avoid warning after identical rules insertion
Date:   Wed, 29 May 2019 10:59:44 +0300
Message-Id: <20190529075945.20050-2-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190529075945.20050-1-idosch@idosch.org>
References: <20190529075945.20050-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

When identical rules are inserted, the latter one goes to C-TCAM. For
that, a second eRP with the same mask is created. These 2 eRPs by the
nature cannot be merged and also one cannot be parent of another.
Teach mlxsw_sp_acl_erp_delta_fill() about this possibility and handle it
gracefully.

Reported-by: Alex Kushnarov <alexanderk@mellanox.com>
Fixes: c22291f7cf45 ("mlxsw: spectrum: acl: Implement delta for ERP")
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_acl_erp.c    | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_erp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_erp.c
index c1a9cc9a3292..4c98950380d5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_erp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_erp.c
@@ -1171,13 +1171,12 @@ mlxsw_sp_acl_erp_delta_fill(const struct mlxsw_sp_acl_erp_key *parent_key,
 			return -EINVAL;
 	}
 	if (si == -1) {
-		/* The masks are the same, this cannot happen.
-		 * That means the caller is broken.
+		/* The masks are the same, this can happen in case eRPs with
+		 * the same mask were created in both A-TCAM and C-TCAM.
+		 * The only possible condition under which this can happen
+		 * is identical rule insertion. Delta is not possible here.
 		 */
-		WARN_ON(1);
-		*delta_start = 0;
-		*delta_mask = 0;
-		return 0;
+		return -EINVAL;
 	}
 	pmask = (unsigned char) parent_key->mask[__MASK_IDX(si)];
 	mask = (unsigned char) key->mask[__MASK_IDX(si)];
-- 
2.20.1

