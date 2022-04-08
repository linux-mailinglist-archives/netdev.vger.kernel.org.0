Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 411D94F9CC0
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 20:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238746AbiDHSdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 14:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236224AbiDHSdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 14:33:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6382AED924
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 11:31:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07F706223B
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 18:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08780C385A3;
        Fri,  8 Apr 2022 18:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649442698;
        bh=TT+D0NVF6tK6iGQnRNjYqb56qSLq0jSEAZxiRR45/4k=;
        h=From:To:Cc:Subject:Date:From;
        b=YCLPUJtDwhaUqENzVR7EL7fIqmvpNoRMYxomwNeqHzPx8QZjv/vtBaWPjhVVI1s4B
         IK05uRIM9YyaMgYamVBm9XX3Ygmzze5VECjYCeP6q1xZb1e2Mg59u32S/zo3/5i5zr
         uAuY9gxR2JPMnDv9Kk1WlN3rjrq8lmp7djnK5nx4D0wdfkGgtZBacKpKFnI08705uz
         4GVCnJJ9Upkysa9fBilsE/2KzDG6EHgZuf6glc13C/GHSmOKVpzQUjUPbCBmGl3Uk2
         H4i3pUliLtiKJXDmgTlDSWYGep4GzrL3GMww9C9uX9T1+HHwNMQOolg6UvCMWtQZT3
         ZVWGZWRXIXWpA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 00/11] tls: rx: random refactoring part 2
Date:   Fri,  8 Apr 2022 11:31:23 -0700
Message-Id: <20220408183134.1054551-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
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

TLS Rx refactoring. Part 2 of 3. This one focusing on the main loop.
A couple of features to follow.

Jakub Kicinski (11):
  tls: rx: drop unnecessary arguments from tls_setup_from_iter()
  tls: rx: don't report text length from the bowels of decrypt
  tls: rx: wrap decryption arguments in a structure
  tls: rx: simplify async wait
  tls: rx: factor out writing ContentType to cmsg
  tls: rx: don't handle async in tls_sw_advance_skb()
  tls: rx: don't track the async count
  tls: rx: pull most of zc check out of the loop
  tls: rx: inline consuming the skb at the end of the loop
  tls: rx: clear ctx->recv_pkt earlier
  tls: rx: jump out for cases which need to leave skb on list

 include/net/tls.h |   1 -
 net/tls/tls_sw.c  | 264 ++++++++++++++++++----------------------------
 2 files changed, 104 insertions(+), 161 deletions(-)

-- 
2.34.1

