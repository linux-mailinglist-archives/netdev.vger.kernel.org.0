Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2483C4D38D6
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 19:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234864AbiCISaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 13:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233077AbiCISaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 13:30:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357DFDBD0F
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 10:29:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E382AB8232D
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 18:29:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1F8C340F6;
        Wed,  9 Mar 2022 18:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646850558;
        bh=8G1ZAXlFnZuDBIGD1fFA/9rZTmEElXfqrpLQ/goDKW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r7VilYNn24bN7NVGGLf2bTTV/46mCBPE7ihlHfK6ZWtvD5i4jTDwvYIWRiYWRVEnp
         OHHS4C5JzjxATtBr/ufg74JTTA0WtVRUpMTKoIBShHfhEXZ+/gWfQR7vBzmdMruLQO
         KYT1YxGzP++h/dvQbmLhyzt/1BxllC6BnnRlSo712IS/y9tl5Sc1bTo29CNcaZ6v9z
         F3ZIyOQUuesUjO8kaQkbxGC7IixJdR5QeYZKS13Ti2fsRVJPkLoCeP2PlTufV3agnM
         9EMEcxJTLxp/4I/z00xSlb2uzLTvEeBZ+Vl9egdP2Djh8wh8Eo4q8PavokfLPXiTt8
         JYxA+u96yXmjw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>,
        George Shuklin <george.shuklin@gmail.com>
Subject: [PATCH net-next 2/2] net: limit altnames to 64k total
Date:   Wed,  9 Mar 2022 10:29:14 -0800
Message-Id: <20220309182914.423834-3-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309182914.423834-1-kuba@kernel.org>
References: <20220309182914.423834-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Property list (altname is a link "property") is wrapped
in a nlattr. nlattrs length is 16bit so practically
speaking the list of properties can't be longer than
that, otherwise user space would have to interpret
broken netlink messages.

Prevent the problem from occurring by checking the length
of the property list before adding new entries.

Reported-by: George Shuklin <george.shuklin@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/rtnetlink.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index aa05e89cc47c..159c9c61e6af 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3652,12 +3652,23 @@ static int rtnl_alt_ifname(int cmd, struct net_device *dev, struct nlattr *attr,
 			   bool *changed, struct netlink_ext_ack *extack)
 {
 	char *alt_ifname;
+	size_t size;
 	int err;
 
 	err = nla_validate(attr, attr->nla_len, IFLA_MAX, ifla_policy, extack);
 	if (err)
 		return err;
 
+	if (cmd == RTM_NEWLINKPROP) {
+		size = rtnl_prop_list_size(dev);
+		size += nla_total_size(ALTIFNAMSIZ);
+		if (size >= U16_MAX) {
+			NL_SET_ERR_MSG(extack,
+				       "effective property list too long");
+			return -EINVAL;
+		}
+	}
+
 	alt_ifname = nla_strdup(attr, GFP_KERNEL_ACCOUNT);
 	if (!alt_ifname)
 		return -ENOMEM;
-- 
2.34.1

