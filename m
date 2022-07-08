Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6D4756AF9F
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 03:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236789AbiGHBDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 21:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236735AbiGHBD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 21:03:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662AA38AD
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 18:03:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12227B824BD
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 01:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BA3C3411E;
        Fri,  8 Jul 2022 01:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657242205;
        bh=1pJkOYBDqQ87kvQ/0vzGH1IQm7fyIHh4FAewV2z9H5c=;
        h=From:To:Cc:Subject:Date:From;
        b=o9/1hD4hBuqtsHi8/gXWw//tlJLrzmnhduRswLn4Yek2G1Z819UH46lvYOeaBfnxP
         hgEgaLw927hS4P/UzwYCvOSUP7SJ0L3UYxcZXbdx76XnWXw3Flc7ELNteIvSonaIdQ
         iD9VeVUSfazmgLY09k1P6iMz9w31HiFx9LoCaGPh869qSDX876ktLokNhKhl6yqERD
         UVmagToBrnV1lu55RaOB66enwderY1sHTJ0xMbWdNqX0CLN2Hi2QL7Z1I/0JO4s5I6
         /euBfmo6IAHo25qmTuWxpQzjDqhGByP0qm2A1CNZnUzdKa+yjwlOI0ZKpNK2x8JjZv
         lVBygyVFxYrDg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/6] tls: pad strparser, internal header, decrypt_ctx etc.
Date:   Thu,  7 Jul 2022 18:03:08 -0700
Message-Id: <20220708010314.1451462-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A grab bag of non-functional refactoring to make the series
which will let us decrypt into a fresh skb smaller.

Patches in this series are not strictly required to get the
decryption into a fresh skb going, they are more in the "things
which had been annoying me for a while" category.

v2: fix build (patch 5)

Jakub Kicinski (6):
  strparser: pad sk_skb_cb to avoid straddling cachelines
  tls: rx: always allocate max possible aad size for decrypt
  tls: rx: wrap decrypt params in a struct
  tls: rx: coalesce exit paths in tls_decrypt_sg()
  tls: create an internal header
  tls: rx: make tls_wait_data() return an recvmsg retcode

 include/net/strparser.h       |  12 +-
 include/net/tls.h             | 278 +-------------------------------
 net/strparser/strparser.c     |   3 +
 net/tls/tls.h                 | 290 ++++++++++++++++++++++++++++++++++
 net/tls/tls_device.c          |   3 +-
 net/tls/tls_device_fallback.c |   2 +
 net/tls/tls_main.c            |  23 ++-
 net/tls/tls_proc.c            |   2 +
 net/tls/tls_sw.c              | 162 ++++++++++---------
 net/tls/tls_toe.c             |   2 +
 10 files changed, 418 insertions(+), 359 deletions(-)
 create mode 100644 net/tls/tls.h

-- 
2.36.1

