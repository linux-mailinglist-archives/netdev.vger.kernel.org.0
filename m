Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBF0B4A4E6
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 17:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729613AbfFRPNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 11:13:39 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45535 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729594AbfFRPNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 11:13:38 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6054722468;
        Tue, 18 Jun 2019 11:13:38 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 18 Jun 2019 11:13:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=7qmm9GkQ0/VlwFaHIIyeiz/rD+KaeDTqZ7aNCD2RHtE=; b=B7TvZJjl
        IyJSVVXUOS3iRqkgccnuAcdzF/QGXTO15uG+VAGq5PYNgm07frl6yimhIzexlJNJ
        ttL+tmqG4YV91FsWosmIHZgrUeC6z++cbP3uNlz9VXUtS2lB9P8zuhnnr6JPTbjs
        T6zjj40d8SeqqUHo87Jh80EfQzQlTSt2S0fVNdgg2q+/PKn++Dg2nrTU58qYR7WY
        90/RQZTgULWs4IcCFTzCY2QfmkxstibOyUGN9sojSHKMVir4D+EYtNfUNSb+Xle1
        mOSUg4Dwxv4+NqSELebUzy4/5RBbUkqoKtAdlWGuXBkt6yk7M/2zXFesoqwhUxKf
        ZQlA0/jyz2akDg==
X-ME-Sender: <xms:ov8IXdTYw4A23diF-rYodT2QsacRYfMfUL18EdgIidiBQQZ-CCmxyg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddtgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepie
X-ME-Proxy: <xmx:ov8IXbC_xiR7zcVnUpNwFnE7gMPPMxg9Joog-sJi3I6DdmKWkykaZA>
    <xmx:ov8IXd2qwlBMqeN3Xug8x5IfjTpHICEoEceFvw9401BtNajmN88V1Q>
    <xmx:ov8IXZVXIIHIHG597GjjO1eE70GS0Rxt5BDK0cOOG2dMLqMyBjnglw>
    <xmx:ov8IXch0GR_5mFHIFwM6DM6t-zjJDtAH8YCRsMYW1Ss27t-RI85Mbw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id DA71F380087;
        Tue, 18 Jun 2019 11:13:36 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 07/16] ipv6: Add IPv6 multipath notification for route delete
Date:   Tue, 18 Jun 2019 18:12:49 +0300
Message-Id: <20190618151258.23023-8-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618151258.23023-1-idosch@idosch.org>
References: <20190618151258.23023-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

If all the nexthops of a multipath route are being deleted, send one
notification for the entire route, instead of one per-nexthop.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 net/ipv6/route.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index da504d36ce54..c4d285fe0adc 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3718,6 +3718,12 @@ static int __ip6_del_rt_siblings(struct fib6_info *rt, struct fib6_config *cfg)
 				info->skip_notify = 1;
 		}
 
+		info->skip_notify_kernel = 1;
+		call_fib6_multipath_entry_notifiers(net,
+						    FIB_EVENT_ENTRY_DEL,
+						    rt,
+						    rt->fib6_nsiblings,
+						    NULL);
 		list_for_each_entry_safe(sibling, next_sibling,
 					 &rt->fib6_siblings,
 					 fib6_siblings) {
-- 
2.20.1

