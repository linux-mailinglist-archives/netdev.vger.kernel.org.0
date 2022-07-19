Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2E757AA43
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 01:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239946AbiGSXLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 19:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiGSXLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 19:11:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79086545C6
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 16:11:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14CCA60EF0
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 23:11:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DEB1C341C6;
        Tue, 19 Jul 2022 23:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658272297;
        bh=xXqsq7BYT5m/Gt/dOCHD+sdNYH1rb4tnp33YjKOqh7s=;
        h=From:To:Cc:Subject:Date:From;
        b=qZyW2ZCc37uSXRWAw7q1Mx+MGI7mv49XTDBxQRD5aF3Zihhx1X7o6MfPaGVVHiIxF
         Hjkt0R8k1koqfAeaqdqYDcTMyX+BlGX5r69HvSVz9EUdMldMsgMWRC6TU0nW95FKjY
         JHLlqC0XRmMEdvKfMvpQwrqMyo1FZKPTz/ovSfkVUZNwKr+UiQaNMbXSRze62Iykmr
         wlrCiPfoHEqMdgsQqs14DYoh7TELLilQx67HMtMDFS/wubH9QT1paip+EnNu/By7Nc
         hsQeT2h6f7wnpD8iOEbtJ++pEeJ/Rn0GMJ/f5hrvQjUe0wQjlgtlS3XYCSufReOmwl
         HwiwapX+pMHbQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/7] tls: rx: decrypt from the TCP queue
Date:   Tue, 19 Jul 2022 16:11:22 -0700
Message-Id: <20220719231129.1870776-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the final part of my TLS Rx rework. It switches from
strparser to decrypting data from skbs queued in TCP. We don't
need the full strparser for TLS, its needs are very basic.
This set gives us a small but measurable (6%) performance
improvement (continuous stream).

v2: drop the __exit marking for the unroll path

Jakub Kicinski (7):
  tls: rx: wrap recv_pkt accesses in helpers
  tls: rx: factor SW handling out of tls_rx_one_record()
  tls: rx: don't free the output in case of zero-copy
  tls: rx: device: keep the zero copy status with offload
  tcp: allow tls to decrypt directly from the tcp rcv queue
  tls: rx: device: add input CoW helper
  tls: rx: do not use the standard strparser

 include/net/tcp.h    |   2 +
 include/net/tls.h    |  19 +-
 net/ipv4/tcp.c       |  44 +++-
 net/tls/tls.h        |  29 ++-
 net/tls/tls_device.c |  19 +-
 net/tls/tls_main.c   |  20 +-
 net/tls/tls_strp.c   | 488 ++++++++++++++++++++++++++++++++++++++++++-
 net/tls/tls_sw.c     | 228 +++++++++++---------
 8 files changed, 725 insertions(+), 124 deletions(-)

-- 
2.36.1

