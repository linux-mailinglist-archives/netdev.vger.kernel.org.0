Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 494A56DA7A5
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 04:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240485AbjDGCUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 22:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240579AbjDGCT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 22:19:59 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B160BF5;
        Thu,  6 Apr 2023 19:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1680833998; x=1712369998;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gu18fQBDefHfFBaWLLukFJTFMSx2LdNYMtkpPFB6n0w=;
  b=EyxQ8ZCm5nocHVeyA2+u2eYm77DZNh1nCbuWNPxBn5fLVHW2oNnEMf5V
   iSXMx/07gQMEedFhSEiDdqodHyKDo6PK5SjHhRWAVu6RvOiPAYGmFvVuH
   RyNsaZFNPD4QB96+GnJolT6VyZ5xBJL1UQpPkpmk/7o/fZdFI9R1vGhOu
   0=;
X-IronPort-AV: E=Sophos;i="5.98,324,1673913600"; 
   d="scan'208";a="315762380"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-0ec33b60.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2023 02:19:54 +0000
Received: from EX19MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-0ec33b60.us-west-2.amazon.com (Postfix) with ESMTPS id 9AC30A0AAC;
        Fri,  7 Apr 2023 02:19:52 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Fri, 7 Apr 2023 02:19:52 +0000
Received: from 88665a182662.ant.amazon.com (10.119.181.3) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 7 Apr 2023 02:19:49 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <kuba@kernel.org>
CC:     <corbet@lwn.net>, <davem@davemloft.net>, <dsahern@kernel.org>,
        <edumazet@google.com>, <kuniyu@amazon.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <yuehaibing@huawei.com>
Subject: Re: [PATCH net] tcp: restrict net.ipv4.tcp_app_win
Date:   Thu, 6 Apr 2023 19:19:41 -0700
Message-ID: <20230407021941.5401-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230406185926.7da74db2@kernel.org>
References: <20230406185926.7da74db2@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.119.181.3]
X-ClientProxiedBy: EX19D039UWB003.ant.amazon.com (10.13.138.93) To
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

From:   Jakub Kicinski <kuba@kernel.org>
Date:   Thu, 6 Apr 2023 18:59:26 -0700
> On Thu, 6 Apr 2023 14:34:50 +0800 YueHaibing wrote:
> > UBSAN: shift-out-of-bounds in net/ipv4/tcp_input.c:555:23
> > shift exponent 255 is too large for 32-bit type 'int'
> > CPU: 1 PID: 7907 Comm: ssh Not tainted 6.3.0-rc4-00161-g62bad54b26db-dirty #206
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> > Call Trace:
> >  <TASK>
> >  dump_stack_lvl+0x136/0x150
> >  __ubsan_handle_shift_out_of_bounds+0x21f/0x5a0
> >  tcp_init_transfer.cold+0x3a/0xb9
> >  tcp_finish_connect+0x1d0/0x620
> >  tcp_rcv_state_process+0xd78/0x4d60
> >  tcp_v4_do_rcv+0x33d/0x9d0
> >  __release_sock+0x133/0x3b0
> >  release_sock+0x58/0x1b0
> > 
> > 'maxwin' is int, shifting int for 32 or more bits is undefined behaviour.
> > 
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> 
> Fixes tag?

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

It's been broken since the beginning.
