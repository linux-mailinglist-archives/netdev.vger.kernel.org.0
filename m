Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B28D64E6C4
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 05:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiLPEli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 23:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiLPElg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 23:41:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A032124B
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 20:41:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0246C61FD1
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 04:41:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04285C433D2;
        Fri, 16 Dec 2022 04:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671165693;
        bh=yH6jFCvdnFeMsoGPfPhE08LzJej7HFYdsByCEglYsB8=;
        h=From:To:Cc:Subject:Date:From;
        b=EjM+X3e5fPX1AO7dEVHB1y2BQdcZvbnl00FVBbexNQKng+IfcToZ85cWUsZLS1Lm3
         au5MkIGtmazphMLHMBOrx8sA+A5nTsRVziPNOI5VAaZN98yzgX+iGsJTB7rv3fCgQd
         9Hcdfg6MThsgDAsxuzUnGZf737cI6K528Y5MhIx3mOKLMDnc2xnlih3025zzzXToJ1
         kbcxCxw/raxj0aiIePPErwAaov07unKBDl3HcMFIezQnjEuGI0pel5JMIIDW7gns3F
         jqogXmWNrpHIxFi5C4Uy15CRrG51gW4wlOEwOksNkLfE8z1Fq9OX5gyWi/1gZ02Q00
         Y9lDTWb1v3ebg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, Jakub Kicinski <kuba@kernel.org>,
        jiri@nvidia.com, moshe@mellanox.com
Subject: [PATCH net] devlink: protect devlink dump by the instance lock
Date:   Thu, 15 Dec 2022 20:41:22 -0800
Message-Id: <20221216044122.1863550-1-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Take the instance lock around devlink_nl_fill() when dumping,
doit takes it already.

We are only dumping basic info so in the worst case we were risking
data races around the reload statistics. Also note that the reloads
themselves had not been under the instance lock until recently, so
the selection of the Fixes tag is inherently questionable.

Fixes: a254c264267e ("devlink: Add reload stats")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jiri@nvidia.com
CC: moshe@mellanox.com
---
 net/core/devlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index d2df30829083..032d6d0a5ce6 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1648,10 +1648,13 @@ static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
 			continue;
 		}
 
+		devl_lock(devlink);
 		err = devlink_nl_fill(msg, devlink, DEVLINK_CMD_NEW,
 				      NETLINK_CB(cb->skb).portid,
 				      cb->nlh->nlmsg_seq, NLM_F_MULTI);
+		devl_unlock(devlink);
 		devlink_put(devlink);
+
 		if (err)
 			goto out;
 		idx++;
-- 
2.38.1

