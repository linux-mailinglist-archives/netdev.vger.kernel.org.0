Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70316250CA
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 03:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbiKKCh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 21:37:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232901AbiKKCgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 21:36:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F00467F5B;
        Thu, 10 Nov 2022 18:35:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40891B823DE;
        Fri, 11 Nov 2022 02:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AB2C4347C;
        Fri, 11 Nov 2022 02:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134145;
        bh=/pJnGSfo3aFrTKfjmiTmx/xSk9GfjJuJ2IbJHGCQSRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UvVh2NpWrUbakCreMUkLZm9fDHGk23W1TqlsBO7H8mc/KUTS1hRFB83GSWbWot4oA
         vVPVg0gPAZpduygyy6CNriMv64kF5KWJioakwIqOHXU+n9aBIdbzgRzSunkvvVsIjH
         WWZup8Jht+87t9TQULoId7JH7XmDjlpBNaQa6GvTJeO/dRcYGcgQ3QtDBy/8lZApeO
         0wy1FErpEkP9kHQPai7c27B3eBPKqzHMp6kgheyY+jq80+SNQmCPlipnZMTT96IncN
         Gff0sQ9ysjLbprLk8/C/sSyAPTsQyCU3+k20yZYY4/Og1l68+7b0m7F/HkwFae/1Cu
         d6RJDzXe7PEmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Tedd Ho-Jeong An <tedd.an@intel.com>,
        Sasha Levin <sashal@kernel.org>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 6/6] Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm
Date:   Thu, 10 Nov 2022 21:35:32 -0500
Message-Id: <20221111023532.227959-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111023532.227959-1-sashal@kernel.org>
References: <20221111023532.227959-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit f937b758a188d6fd328a81367087eddbb2fce50f ]

l2cap_global_chan_by_psm shall not return fixed channels as they are not
meant to be connected by (S)PSM.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Reviewed-by: Tedd Ho-Jeong An <tedd.an@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 83dd76e9196f..3e754238f78b 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1986,7 +1986,7 @@ static struct l2cap_chan *l2cap_global_chan_by_psm(int state, __le16 psm,
 		if (link_type == LE_LINK && c->src_type == BDADDR_BREDR)
 			continue;
 
-		if (c->psm == psm) {
+		if (c->chan_type != L2CAP_CHAN_FIXED && c->psm == psm) {
 			int src_match, dst_match;
 			int src_any, dst_any;
 
-- 
2.35.1

