Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA91567AF8
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 01:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbiGEX7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 19:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiGEX7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 19:59:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C20183AD;
        Tue,  5 Jul 2022 16:59:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AFA361166;
        Tue,  5 Jul 2022 23:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C70C341C7;
        Tue,  5 Jul 2022 23:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657065574;
        bh=HzhDq3jCkMDG8lfPENyfnzpgHn8+yFzo4Tfu3sukxNo=;
        h=From:To:Cc:Subject:Date:From;
        b=lcHGipXRRJR0GMiQuzfsXd/gg82wZLvlsYwHXrt4JzXByGMutRRhnxB8j7wbmJzER
         HLGW42UDdRicAZhfOyEPgn857KJbX8i9sH41IGpnjTfu1oxoHwSyP9wZg1uP3P01sG
         ZMI/sS47niOweAKZScXCkxOuAhbmjKbMqJECkQNvJ2eE3nPm0ZYoQJz8ZN0drcpaPd
         TIg3SEpwJ/C8ihehgdvBJD8wU9dR/jLtwyOY4p5D5wpRbNF1m8nc+RnVqrhHg58uUg
         TINmb1/T0RNvsLV8LGZEngXuInBWmkWtP9LCnjdySDcgdj8orUzPMPLjUqa/DE8rny
         SvhjkQRvUPPIg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        john.fastabend@gmail.com, borisp@nvidia.com,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        maximmi@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/5] tls: rx: nopad and backlog flushing
Date:   Tue,  5 Jul 2022 16:59:21 -0700
Message-Id: <20220705235926.1035407-1-kuba@kernel.org>
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

This small series contains the two changes I've been working
towards in the previous ~50 patches a couple of months ago.

The first major change is the optional "nopad" optimization.
Currently TLS 1.3 Rx performs quite poorly because it does
not support the "zero-copy" or rather direct decrypt to a user
space buffer. Because of TLS 1.3 record padding we don't
know if a record contains data or a control message until
we decrypt it. Most records will contain data, tho, so the
optimization is to try the decryption hoping its data and
retry if it wasn't.

The performance gain from doing that is significant (~40%)
but if I'm completely honest the major reason is that we
call skb_cow_data() on the non-"zc" path. The next series
will remove the CoW, dropping the gain to only ~10%.

The second change is to flush the backlog every 128kB.

Jakub Kicinski (5):
  tls: rx: don't include tail size in data_len
  tls: rx: support optimistic decrypt to user buffer with TLS 1.3
  tls: rx: add sockopt for enabling optimistic decrypt with TLS 1.3
  selftests: tls: add selftest variant for pad
  tls: rx: periodically flush socket backlog

 Documentation/networking/tls.rst  | 18 +++++++
 include/linux/sockptr.h           |  8 +++
 include/net/tls.h                 |  3 ++
 include/uapi/linux/snmp.h         |  1 +
 include/uapi/linux/tls.h          |  2 +
 net/core/sock.c                   |  1 +
 net/tls/tls_main.c                | 75 +++++++++++++++++++++++++++
 net/tls/tls_proc.c                |  1 +
 net/tls/tls_sw.c                  | 84 ++++++++++++++++++++++++-------
 tools/testing/selftests/net/tls.c | 15 ++++++
 10 files changed, 191 insertions(+), 17 deletions(-)

-- 
2.36.1

