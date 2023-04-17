Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA5EA6E4DB4
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbjDQPxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjDQPxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:53:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47E692
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 08:53:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F39C61943
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 15:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98992C433D2;
        Mon, 17 Apr 2023 15:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681746831;
        bh=fWGCF00r96QqpPW8ekcdSsqCsbZY4g9y6HOVo28v17s=;
        h=From:To:Cc:Subject:Date:From;
        b=aL5s4/YyH5wiE/9ZqgSvSTqbvMfsmMqDZsZaDpAaetpN88zbFhhJLU4ZWn/0I9mQq
         R3T4RwGiqGlgkN8CP+w8jvkoHMv7VJHWWq/aVI1FjWsCsvuDKppYA5DCiNQva2Rh19
         kSXmMzYojZm+gSpheyj1N1FTW+71Ghy03juxjBAu24buC+HKqF/ZbTJEQvbyLyIKub
         pq4yZvNm4nCnn3CSEEVWqHTwbpQKWBHeu6hXR+5IehbPGoUjONR+VBczlbYqMbEq+A
         d0MLsoexPVcT7lmYmRSVELZXWtMJl4WhNRB3P4HxthorQ1iy1nTELiBw5v8veHVrbv
         GQPcpHCSrbowQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/5] net: skbuff: hide some bitfield members
Date:   Mon, 17 Apr 2023 08:53:45 -0700
Message-Id: <20230417155350.337873-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a number of protocol or subsystem specific fields
in struct sk_buff which are only accessed by one subsystem.
We can wrap them in ifdefs with minimal code impact.

This gives us a better chance to save a 2B and a 4B holes
resulting with the following savings (assuming a lucky
kernel config):

-	/* size: 232, cachelines: 4, members: 28 */
-	/* sum members: 227, holes: 1, sum holes: 4 */
-	/* sum bitfield members: 8 bits (1 bytes) */
+	/* size: 224, cachelines: 4, members: 28 */
 	/* forced alignments: 2 */
-	/* last cacheline: 40 bytes */
+	/* last cacheline: 32 bytes */

I think that the changes shouldn't be too controversial.
The only one I'm not 100% sure of is the SCTP one,
12 extra LoC for one bit.. But it did fit squarely
in the "this bit has only one user" category.

v2:
 - use IS_ENABLED() for nf_trace
v1: https://lore.kernel.org/all/20230414160105.172125-1-kuba@kernel.org/

Jakub Kicinski (5):
  net: skbuff: hide wifi_acked when CONFIG_WIRELESS not set
  net: skbuff: hide csum_not_inet when CONFIG_IP_SCTP not set
  net: skbuff: move alloc_cpu into a potential hole
  net: skbuff: push nf_trace down the bitfield
  net: skbuff: hide nf_trace and ipvs_property

 include/linux/skbuff.h | 38 ++++++++++++++++++++++++++++++++++----
 include/net/sock.h     |  2 +-
 net/core/dev.c         |  3 +--
 net/core/skbuff.c      |  2 ++
 net/sched/act_csum.c   |  3 +--
 net/socket.c           |  2 ++
 6 files changed, 41 insertions(+), 9 deletions(-)

-- 
2.39.2

