Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 205A859C675
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 20:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237545AbiHVSdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 14:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237505AbiHVScz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 14:32:55 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094C44AD45
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 11:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661193149; x=1692729149;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aK4MPOmSwHEbMjrlRR8e4yzRmp0rvHn1j9I0VnyhUWI=;
  b=lL/ttysTxR9Yr9dMHOFL9ABcwqs5cFxcjufn7PSDczj+NgFnkS3m34vB
   Xhr0/nBCbmZCEkFSvbGD8fKVua/xaDQUmBfFMcyVAw875rXjcu/gmPY3I
   eqCDxIQ6I6A6aJZIneg0HkyqOe5+6dbEmtGFBDjVWvS3O4rmH75Rq5467
   k=;
X-IronPort-AV: E=Sophos;i="5.93,255,1654560000"; 
   d="scan'208";a="236167820"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-4ba5c7da.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 18:32:17 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-4ba5c7da.us-east-1.amazon.com (Postfix) with ESMTPS id EE3AC8115E;
        Mon, 22 Aug 2022 18:32:15 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Mon, 22 Aug 2022 18:32:14 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.172) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Mon, 22 Aug 2022 18:32:12 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <kuba@kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v3 net 05/17] ratelimit: Fix data-races in ___ratelimit().
Date:   Mon, 22 Aug 2022 11:32:05 -0700
Message-ID: <20220822183205.19735-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220819170446.77eeb642@kernel.org>
References: <20220819170446.77eeb642@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.172]
X-ClientProxiedBy: EX13D08UWB004.ant.amazon.com (10.43.161.232) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Jakub Kicinski <kuba@kernel.org>
Date:   Fri, 19 Aug 2022 17:04:46 -0700
> On Thu, 18 Aug 2022 11:26:41 -0700 Kuniyuki Iwashima wrote:
> > +	int interval = READ_ONCE(rs->interval);
> > +	int burst = READ_ONCE(rs->burst);
> 
> Also feels a little bit like papering over an issue if we read 
> two values separately.

Exactly, we have to protect it with a single lock.
Considering ___ratelimit() can be called in many paths, it seems better
to add a spin lock in struct ratelimit_state.

Thank you.
