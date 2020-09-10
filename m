Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9890B264508
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 13:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730624AbgIJLFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 07:05:01 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:39349 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730604AbgIJLCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 07:02:16 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id D1EBD580394;
        Thu, 10 Sep 2020 07:02:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 10 Sep 2020 07:02:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=HzDoPo7+KJgxBIptD7sAlOSeoOjOOzSCwAOPoNvpknI=; b=JXR9M1Uy
        /BlJ4blTpxgCdTTpWagqxaEWKJBwysqUvxPXXy03VgZ7jjKFQXskvCsXtFxPh0s4
        Iu8AzBKI4Js0wHJn0MMgeImOygt9jixUO16aNBYg1D0u7VN31SkJNa/haX+QNiYU
        0XE0uaku4fdPJQPWjmsMomP15jgOHzOvphQxNGvOk9uNjDAVFeFVVQ554KFuYOv4
        l9WrXO8EdKzdolJbrFYonKuRAeApHuHZ4HmIKFsOszM5lNnNcpMwmhXlyGldhMXb
        H+bTck4AxPUNPJDA2hxIUMlEsiGs8LrgXuE/UqI3Tv4UH7EBHXNFGuW7l5sIb8Gr
        0jyXlQb6VkQbNw==
X-ME-Sender: <xms:sgdaXzIal5fciOA5W_R3oGrBOCmRrOoqFfF8l2TaX0vGjo04qdjNUA>
    <xme:sgdaX3Iv7RbnFUnFyG7FtSx3XNdbWHj1hpuENwZynV3FtAy3C89tlRQHPa78iehoG
    LvjgK-vXlPRfKw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehjedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirddufedu
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:sgdaX7v3FWzabyMa95a_PFKGA1fxqpbRjrOWOjkzCcd_kCSyairsbw>
    <xmx:sgdaX8boM5FlWS0itVlUChf7Ccx4vo_Z8p-nUqvL7Cnfht5hi9QFhw>
    <xmx:sgdaX6bEB_0iviukm5ogYsEL4k4pKgtJdFBevm0Ejl_10bReYUHsHQ>
    <xmx:sgdaXwNF7jVbMQCJEVZgkjXPgC5UFHfcYD5IP536MbLywWlRQH9OLg>
Received: from shredder.mtl.com (igld-84-229-36-131.inter.net.il [84.229.36.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id 947823064688;
        Thu, 10 Sep 2020 07:02:08 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        nikolay@nvidia.com, roopa@nvidia.com,
        vasundhara-v.volam@broadcom.com, jtoppins@redhat.com,
        michael.chan@broadcom.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 1/2] net: Fix bridge enslavement failure
Date:   Thu, 10 Sep 2020 14:01:26 +0300
Message-Id: <20200910110127.3113683-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200910110127.3113683-1-idosch@idosch.org>
References: <20200910110127.3113683-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

When a netdev is enslaved to a bridge, its parent identifier is queried.
This is done so that packets that were already forwarded in hardware
will not be forwarded again by the bridge device between netdevs
belonging to the same hardware instance.

The operation fails when the netdev is an upper of netdevs with
different parent identifiers.

Instead of failing the enslavement, have dev_get_port_parent_id() return
'-EOPNOTSUPP' which will signal the bridge to skip the query operation.
Other callers of the function are not affected by this change.

Fixes: 7e1146e8c10c ("net: devlink: introduce devlink_compat_switch_id_get() helper")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reported-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 4086d335978c..266073e300b5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8647,7 +8647,7 @@ int dev_get_port_parent_id(struct net_device *dev,
 		if (!first.id_len)
 			first = *ppid;
 		else if (memcmp(&first, ppid, sizeof(*ppid)))
-			return -ENODATA;
+			return -EOPNOTSUPP;
 	}
 
 	return err;
-- 
2.26.2

