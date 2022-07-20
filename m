Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A195A57BBFE
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 18:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbiGTQxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 12:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiGTQxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 12:53:05 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2984912AA0
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 09:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1658335985; x=1689871985;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LQiUyjVcRwWtxfxcgeKfp0g2hJiGJHjATFRc8Fe6BAs=;
  b=uuHD2dgOSNfiDHWiIOzoTORBcL1ezd9zuQhJaDgqQsb/tL+TPeLy/5j6
   QcP8w4mrx0sD6z5fg32CD0bG1qrTKiYAqN5C7HdxBVIlrB1I5Ohzucwxq
   M463P/WBkkW9Q1Hd6QhjJNeSkbxH51Gf/qhrDKMNJn/xtE4QuEol9hF+f
   I=;
X-IronPort-AV: E=Sophos;i="5.92,286,1650931200"; 
   d="scan'208";a="110467557"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-a31e1d63.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 20 Jul 2022 16:50:54 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-a31e1d63.us-east-1.amazon.com (Postfix) with ESMTPS id 16F879569C;
        Wed, 20 Jul 2022 16:50:51 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 20 Jul 2022 16:50:51 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.159) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 20 Jul 2022 16:50:48 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 00/15] sysctl: Fix data-races around ipv4_net_table (Round 5).
Date:   Wed, 20 Jul 2022 09:50:11 -0700
Message-ID: <20220720165026.59712-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.159]
X-ClientProxiedBy: EX13D10UWA004.ant.amazon.com (10.43.160.64) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes data-races around 15 knobs after tcp_dsack in
ipv4_net_table.

tcp_tso_win_divisor was skipped because it already uses READ_ONCE().

So, the final round for ipv4_net_table will start with tcp_pacing_ss_ratio.


Kuniyuki Iwashima (15):
  tcp: Fix data-races around sysctl_tcp_dsack.
  tcp: Fix a data-race around sysctl_tcp_app_win.
  tcp: Fix a data-race around sysctl_tcp_adv_win_scale.
  tcp: Fix a data-race around sysctl_tcp_frto.
  tcp: Fix a data-race around sysctl_tcp_nometrics_save.
  tcp: Fix data-races around sysctl_tcp_no_ssthresh_metrics_save.
  tcp: Fix data-races around sysctl_tcp_moderate_rcvbuf.
  tcp: Fix data-races around sysctl_tcp_workaround_signed_windows.
  tcp: Fix a data-race around sysctl_tcp_limit_output_bytes.
  tcp: Fix a data-race around sysctl_tcp_challenge_ack_limit.
  tcp: Fix a data-race around sysctl_tcp_min_tso_segs.
  tcp: Fix a data-race around sysctl_tcp_tso_rtt_log.
  tcp: Fix a data-race around sysctl_tcp_min_rtt_wlen.
  tcp: Fix a data-race around sysctl_tcp_autocorking.
  tcp: Fix a data-race around sysctl_tcp_invalid_ratelimit.

 include/net/tcp.h      |  2 +-
 net/ipv4/tcp.c         |  2 +-
 net/ipv4/tcp_input.c   | 17 +++++++++--------
 net/ipv4/tcp_metrics.c | 10 +++++-----
 net/ipv4/tcp_output.c  | 10 +++++-----
 net/mptcp/options.c    |  2 +-
 net/mptcp/protocol.c   |  2 +-
 7 files changed, 23 insertions(+), 22 deletions(-)

-- 
2.30.2

