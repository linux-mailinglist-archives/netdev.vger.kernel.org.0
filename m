Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BABA6974FD
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 04:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbjBODoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 22:44:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbjBODoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 22:44:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF0631E0E
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 19:44:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D692B81FA8
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 03:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07E0C433D2;
        Wed, 15 Feb 2023 03:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676432643;
        bh=vglZul10lufbDaMus3bXmGDv32Rth95TsYmnQtWtg7E=;
        h=From:To:Cc:Subject:Date:From;
        b=eeAH3fdx/LDEnYQMGnhaAUnIKyCH5Z4VxUhE0dIb0Hbk+WJs57gq4cZee15Ms3kOd
         MVFK/C3b42Vgh56ThcdpLUf8D8l4aArg0LjN4ANdSsGlp3+s9zMfZTcJmic7fp7ZT4
         xmsDz3bllfX2iVRrdk21vq2FRF0XtRlvicyvxfH9kNbJH/xTtKNi48/A8Gj0l4B39t
         qmU7TsrEIy5sB2QLV5OkLCaySNx3U6R6zB/0IyeBL6oVbjYq0WL424jJrgmKKw2Klu
         08T+wpBN+QSsl/uclLs6wE/J258SXsDBR+4rqdYwXdHN2yvstlHm50x6ADHqJxVhm1
         5U7lqmlXxztYg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        willemb@google.com, fw@strlen.de, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/3] net: skbuff: cache one skb_ext for use by GRO
Date:   Tue, 14 Feb 2023 19:43:52 -0800
Message-Id: <20230215034355.481925-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New offload features may require attaching skb_ext to every packet.
PSP support adds fields to the skb in the patches published by Google:
  https://github.com/google/psp
Since PSP is designed to be stateless on the device we need to carry
metadata thru the stack and perform validation at the socket layer.

Upstream we'll likely try to use skb_ext to place such metadata.

Lower the cost of allocation of skb_ext by caching a single object
per core.

Obviously the PSP support isn't upstream yet, but I think that this
should also help the TC fallback, and any other skb_ext uses people
may come up with in the meantime.

Jakub Kicinski (3):
  net: skb: carve the allocation out of skb_ext_add()
  net: skbuff: cache one skb_ext for use by GRO
  net: create and use NAPI version of tc_skb_ext_alloc()

 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   2 +-
 include/linux/skbuff.h                        |   1 +
 include/net/pkt_cls.h                         |   9 ++
 net/core/skbuff.c                             | 131 ++++++++++++++----
 5 files changed, 117 insertions(+), 28 deletions(-)

-- 
2.39.1

