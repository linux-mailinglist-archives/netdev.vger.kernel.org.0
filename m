Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6006CF406
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 22:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjC2UH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 16:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjC2UH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 16:07:56 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C280B2
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 13:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1680120476; x=1711656476;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BZq5puEFo2KMcZd/TQA6RBN+NYsfqkzNvTOe+4GnDuM=;
  b=J9XowR6UbeXeNeHpmlRv3Zdf4uyniINp7c83tagmHXJZ5Z0VrTQaxxoE
   iBq1+LbJV0Gn6onW5n5EoN7cldUeiq91DwssmGxOohX8zHgJisZasIIiM
   YMXUb4gohDfgwKaih6zB8Sw55xyqpi4ybGMYpfrt3gyxuz12lFjfloB0y
   w=;
X-IronPort-AV: E=Sophos;i="5.98,301,1673913600"; 
   d="scan'208";a="314758590"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 20:07:52 +0000
Received: from EX19MTAUWA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com (Postfix) with ESMTPS id 18A63C1727;
        Wed, 29 Mar 2023 20:07:51 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.22; Wed, 29 Mar 2023 20:07:41 +0000
Received: from 88665a182662.ant.amazon.com (10.106.101.9) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 29 Mar 2023 20:07:38 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <kuniyu@amazon.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>,
        <kerneljasonxing@gmail.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v2 net-next] tcp: Refine SYN handling for PAWS.
Date:   Wed, 29 Mar 2023 13:07:30 -0700
Message-ID: <20230329200730.78159-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230328184257.62219-1-kuniyu@amazon.com>
References: <20230328184257.62219-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.101.9]
X-ClientProxiedBy: EX19D042UWB004.ant.amazon.com (10.13.139.150) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Kuniyuki Iwashima <kuniyu@amazon.com>
Date:   Tue, 28 Mar 2023 11:42:57 -0700
> Our Network Load Balancer (NLB) [0] has multiple nodes with different
> IP addresses, and each node forwards TCP flows from clients to backend
> targets.  NLB has an option to preserve the client's source IP address
> and port when routing packets to backend targets. [1]
> 
> When a client connects to two different NLB nodes, they may select the
> same backend target.  Then, if the client has used the same source IP
> and port, the two flows at the backend side will have the same 4-tuple.
> 
> While testing around such cases, I saw these sequences on the backend
> target.
> 
> IP 10.0.0.215.60000 > 10.0.3.249.10000: Flags [S], seq 2819965599, win 62727, options [mss 8365,sackOK,TS val 1029816180 ecr 0,nop,wscale 7], length 0
> IP 10.0.3.249.10000 > 10.0.0.215.60000: Flags [S.], seq 3040695044, ack 2819965600, win 62643, options [mss 8961,sackOK,TS val 1224784076 ecr 1029816180,nop,wscale 7], length 0
> IP 10.0.0.215.60000 > 10.0.3.249.10000: Flags [.], ack 1, win 491, options [nop,nop,TS val 1029816181 ecr 1224784076], length 0
> IP 10.0.0.215.60000 > 10.0.3.249.10000: Flags [S], seq 2681819307, win 62727, options [mss 8365,sackOK,TS val 572088282 ecr 0,nop,wscale 7], length 0
> IP 10.0.3.249.10000 > 10.0.0.215.60000: Flags [.], ack 1, win 490, options [nop,nop,TS val 1224794914 ecr 1029816181,nop,nop,sack 1 {4156821004:4156821005}], length 0
> 
> It seems to be working correctly, but the last ACK was generated by
> tcp_send_dupack() and PAWSEstab was increased.  This is because the
> second connection has a smaller timestamp than the first one.
> 
> In this case, we should send a dup ACK in tcp_send_challenge_ack()
> to increase the correct counter and rate-limit it properly.
> 
> Let's check the SYN flag after the PAWS tests to avoid adding unnecessary
> overhead for most packets.
> 
> Link: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/introduction.html [0]
> Link: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-target-groups.html#client-ip-preservation [1]
> Fixes: 0c24604b68fc ("tcp: implement RFC 5961 4.2")

Sorry, I forgot to remove Fixes tag.
I'll post v3.
