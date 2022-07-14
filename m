Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39D385741E6
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 05:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbiGNDdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 23:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232253AbiGNDdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 23:33:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2039625EA1
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 20:33:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AED5CB82282
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:33:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D57C34114;
        Thu, 14 Jul 2022 03:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657769597;
        bh=HgTKT6Ffu0cTjGo++aJRX2GO+H409VPtzq7LAfilhA4=;
        h=From:To:Cc:Subject:Date:From;
        b=rY2vtwt1xtKSVlU0K0em7edURePTZwTlwu5wTrD/hA8FhDEUFBL5Jkp/UvUjHU1Ss
         W2583lwJveZl3o/CWWVgFXpmwL4BLhcXMfidyio/mcTLMo5BnDXuoDHpm13K3/3hA+
         pYTWcyB5Bh3eQ88XRWc314RufRQ4/4Tg5Tijxvf9+CM2yUa85qWn18UTcgLFZZF1Cn
         hyZgY5Ty+Ew79OrNe6jWj/PB51EQWOKi18gkSqkVgx9mr5jwtjxxYY1lyisr4RyYS5
         VzwhxTynJMMAgtFXgYX5ZfQEtzAZkYKqi4IoTEqjrjECw/T7iPXalAetdGJFKixJIv
         OiyqmtlY0Nu0w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 00/11] tls: rx: avoid skb_cow_data()
Date:   Wed, 13 Jul 2022 20:32:59 -0700
Message-Id: <20220714033310.1273288-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
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

TLS calls skb_cow_data() on the skb it received from strparser
whenever it needs to hold onto the skb with the decrypted data.
(The alternative being decrypting directly to a user space buffer
in whic case the input skb doesn't get modified or used after.)
TLS needs the decrypted skb:
 - almost always with TLS 1.3 (unless the new NoPad is enabled);
 - when user space buffer is too small to fit the record;
 - when BPF sockmap is enabled.

Most of the time the skb we get out of strparser is a clone of
a 64kB data unit coalsced by GRO. To make things worse skb_cow_data()
tries to output a linear skb and allocates it with GFP_ATOMIC.
This occasionally fails even under moderate memory pressure.

This patch set rejigs the TLS Rx so that we don't expect decryption
in place. The decryption handlers return an skb which may or may not
be the skb from strparser. For TLS 1.3 this results in a 20-30%
performance improvement without NoPad enabled.

Jakub Kicinski (11):
  tls: rx: allow only one reader at a time
  tls: rx: don't try to keep the skbs always on the list
  tls: rx: don't keep decrypted skbs on ctx->recv_pkt
  tls: rx: remove the message decrypted tracking
  tls: rx: factor out device darg update
  tls: rx: read the input skb from ctx->recv_pkt
  tls: rx: return the decrypted skb via darg
  tls: rx: async: adjust record geometry immediately
  tls: rx: async: hold onto the input skb
  tls: rx: async: don't put async zc on the list
  tls: rx: decrypt into a fresh skb

 include/net/strparser.h |   1 -
 include/net/tls.h       |   4 +
 net/tls/Makefile        |   2 +-
 net/tls/tls.h           |  20 +-
 net/tls/tls_device.c    |  25 ++-
 net/tls/tls_strp.c      |  17 ++
 net/tls/tls_sw.c        | 458 ++++++++++++++++++++++++----------------
 7 files changed, 333 insertions(+), 194 deletions(-)
 create mode 100644 net/tls/tls_strp.c

-- 
2.36.1

