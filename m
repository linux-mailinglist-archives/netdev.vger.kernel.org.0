Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13F884B02C9
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 03:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbiBJB7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 20:59:33 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:33154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233651AbiBJB7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 20:59:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248E02AB;
        Wed,  9 Feb 2022 17:56:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B47F616D2;
        Thu, 10 Feb 2022 00:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596DFC340E7;
        Thu, 10 Feb 2022 00:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644453413;
        bh=Nqx9UqIwQAq/YChOaq2hfeu2SItd1xNMbZqtwE17fJ4=;
        h=From:To:Cc:Subject:Date:From;
        b=RiTwFsZL3FlFooeHoNRq56XjCIfLAFSm2C2s1/QcaO1uKDSPnSLPVT/Hhp/kugU1M
         9rSMIoM84F6e7PrBinSbU7RLpyuMEifqukUo7WS+6U5msXXN0pz53RH/A7GvQZWxyQ
         7ChvMvCACs2ebgrOn2GXEBF2B+pPbQC7UGcThDB/1+5fuBlytrPpEwz/rShq9X8UBz
         +6Odg+tf8UKWeQqw2r0kYp9jwK8YMMtdsBrWn8MXbYEOoiP9b+ugftN4+w8h7ZuVCX
         CT7G+/w/Y4DHYw8sg9nA1JdlaUehlC2s0Z/EzBKNePazfvNSGDjVS3w0BxCDbgLLIT
         PapWjsBJ6nvBg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, lorenzo@google.com,
        maze@google.com, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 00/11] net: ping6: support basic socket cmsgs
Date:   Wed,  9 Feb 2022 16:36:38 -0800
Message-Id: <20220210003649.3120861-1-kuba@kernel.org>
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

Add support for common SOL_SOCKET cmsgs in ICMPv6 sockets.
Extend the cmsg tests to cover more cmsgs and socket types.

SOL_IPV6 cmsgs to follow.

Jakub Kicinski (11):
  net: ping6: remove a pr_debug() statement
  net: ping6: support packet timestamping
  net: ping6: support setting socket options via cmsg
  selftests: net: rename cmsg_so_mark
  selftests: net: make cmsg_so_mark ready for more options
  selftests: net: cmsg_sender: support icmp and raw sockets
  selftests: net: cmsg_so_mark: test ICMP and RAW sockets
  selftests: net: cmsg_so_mark: test with SO_MARK set by setsockopt
  selftests: net: cmsg_sender: support setting SO_TXTIME
  selftests: net: cmsg_sender: support Tx timestamping
  selftests: net: test standard socket cmsgs across UDP and ICMP sockets

 net/ipv6/ping.c                             |  14 +-
 tools/testing/selftests/net/.gitignore      |   2 +-
 tools/testing/selftests/net/Makefile        |   3 +-
 tools/testing/selftests/net/cmsg_sender.c   | 380 ++++++++++++++++++++
 tools/testing/selftests/net/cmsg_so_mark.c  |  67 ----
 tools/testing/selftests/net/cmsg_so_mark.sh |  32 +-
 tools/testing/selftests/net/cmsg_time.sh    |  83 +++++
 7 files changed, 499 insertions(+), 82 deletions(-)
 create mode 100644 tools/testing/selftests/net/cmsg_sender.c
 delete mode 100644 tools/testing/selftests/net/cmsg_so_mark.c
 create mode 100755 tools/testing/selftests/net/cmsg_time.sh

-- 
2.34.1

