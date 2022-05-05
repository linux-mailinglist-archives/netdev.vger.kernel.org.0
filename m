Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6366851BCD0
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 12:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354882AbiEEKLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 06:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354912AbiEEKK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 06:10:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE8851309
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 03:07:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07FD5B8279B
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 10:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11519C385A8;
        Thu,  5 May 2022 10:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651745232;
        bh=e9FAmk5rPtyujnROXuLAD4ayXWHGQx5TxuduF8TZVDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NNqF4weMRzGSyI1KR8N8K2qtzTci38rlhkdS/YEFwF5XHBsxsfzhUTcsZuqid0+UB
         njGE1faeeGvdDcS33Qo25NlQj31p1VdSqKoOmSI6Vda9PXXDRxAM8frTAZpJjF1bEx
         OfRZyxsb9gihNJbLFeTCxzpBtLADZcx2AqIjGZJyO9V/+s34duvWX/oSAOJscahtDK
         nRQt+yh1xmMAnqk+sDV41JRcuuKC9yMMYgmW3TeDmWTb6BBAga1fZ3Yzby4xITj5bY
         sFlfEI2ZVZvG4duJQWqjY05T6bUvAzMM4/M3kVaWTBqYEdZVUfWqLI/tRNJc/gaPCv
         vcq98L3Iq6umg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH ipsec-next 6/8] netdevsim: rely on XFRM state direction instead of flags
Date:   Thu,  5 May 2022 13:06:43 +0300
Message-Id: <54be8183fb49a5486a8137627c204f00595e21af.1651743750.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1651743750.git.leonro@nvidia.com>
References: <cover.1651743750.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Make sure that netdevsim relies on direction and not on flags.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/netdevsim/ipsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/ipsec.c b/drivers/net/netdevsim/ipsec.c
index b80ed2ffd45e..386336a38f34 100644
--- a/drivers/net/netdevsim/ipsec.c
+++ b/drivers/net/netdevsim/ipsec.c
@@ -171,7 +171,7 @@ static int nsim_ipsec_add_sa(struct xfrm_state *xs)
 		return ret;
 	}
 
-	if (xs->xso.flags & XFRM_OFFLOAD_INBOUND) {
+	if (xs->xso.dir == XFRM_DEV_OFFLOAD_IN) {
 		sa.rx = true;
 
 		if (xs->props.family == AF_INET6)
-- 
2.35.1

