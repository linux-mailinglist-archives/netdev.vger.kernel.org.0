Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 753296EBAEA
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 20:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjDVSy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 14:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDVSy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 14:54:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CDBC1BC2;
        Sat, 22 Apr 2023 11:54:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DBE260A6E;
        Sat, 22 Apr 2023 18:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DECC433EF;
        Sat, 22 Apr 2023 18:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682189664;
        bh=2I8zcE9sGSkzBmE0EsIR6e1vf/19wtIW0d35Vf48HvA=;
        h=From:To:Cc:Subject:Date:From;
        b=fcrU1kES9tjbE90J8CFz7L3fX/+tx7ZFJr7N47V23hJveLPHxtjejQOve+rOemCYQ
         PoRK1G1k3sezEuqjND5Qn7krmw63rIPSlqHVEYB0alILn3Jk4h9G8Q7rbP4zEsAkR5
         0Sb93piUX8kXVHNx5DPLtr1sSBUaOvAGgw1Zs8JwBATkt8yp4N0tfwDjnAYQSuriGU
         dFaQB1kxL1J38BfeOU7lR2sXif+l8Hn+pK1bMMSMBQNpGOWHKK7j4sBqqvZ83NV5QJ
         4spxoy3SgpvXK7S8lul3eInCizpk/h36QrciwzSSDlCrac5aB/QPDh0FpsOg2QfY0E
         3lmW9qOQkqHJw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hawk@kernel.org, john.fastabend@gmail.com,
        ast@kernel.org, daniel@iogearbox.net
Subject: [PATCH v2 net-next 0/2] add page_pool support for page recycling in veth driver
Date:   Sat, 22 Apr 2023 20:54:31 +0200
Message-Id: <cover.1682188837.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce page_pool support in veth driver in order to recycle pages in
veth_convert_skb_to_xdp_buff routine and avoid reallocating the skb through
the page allocator when we run a xdp program on the device and we receive
skbs from the stack.

Change since v1:
- remove page_pool checks in veth_convert_skb_to_xdp_buff() before allocating
  the pages
- recycle pages in the hot cache if build_skb fails in
  veth_convert_skb_to_xdp_buff()

Lorenzo Bianconi (2):
  net: veth: add page_pool for page recycling
  net: veth: add page_pool stats

 drivers/net/Kconfig |  2 ++
 drivers/net/veth.c  | 68 ++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 63 insertions(+), 7 deletions(-)

-- 
2.40.0

