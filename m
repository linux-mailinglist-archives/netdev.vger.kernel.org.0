Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5444C4D99C7
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 11:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347686AbiCOK7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 06:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347675AbiCOK7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 06:59:53 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C173B3FC
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 03:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1647341922; x=1678877922;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=smMpCRo2Y+uYSJHpVNHKyVTKeO5k5BgB/afoGWNwwsI=;
  b=N+7Jb13roY/HLp6xW9vb2jas3nd7s8TziSrT/TLyWOpD0dDik97/cUZd
   KsBbQf0JKu91wtkCfUrhZl54ntaYd1h0hbyjcoSEB0UaJ4W87b2gtPek1
   bJHZ34vMcD8/Iold2Nj+Zo4y1h4OixdWijmaD6l/PLyWn8FPHpLArjcAM
   U=;
X-IronPort-AV: E=Sophos;i="5.90,183,1643673600"; 
   d="scan'208";a="202373997"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-35b1f9a2.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 15 Mar 2022 10:58:41 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-35b1f9a2.us-east-1.amazon.com (Postfix) with ESMTPS id ABF65201093;
        Tue, 15 Mar 2022 10:58:38 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Tue, 15 Mar 2022 10:58:37 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.69) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Tue, 15 Mar 2022 10:58:34 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kuniyu@amazon.co.jp>
CC:     <Rao.Shoaib@oracle.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net] af_unix: Support POLLPRI for OOB.
Date:   Tue, 15 Mar 2022 19:58:31 +0900
Message-ID: <20220315105831.77681-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220315054801.72035-1-kuniyu@amazon.co.jp>
References: <20220315054801.72035-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.69]
X-ClientProxiedBy: EX13D29UWA003.ant.amazon.com (10.43.160.253) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Date:   Tue, 15 Mar 2022 14:48:01 +0900
> The commit 314001f0bf92 ("af_unix: Add OOB support") introduced OOB for
> AF_UNIX, but it lacks some changes for POLLPRI.  Let's add the missing
> piece.
> 
> In the selftest, normal datagrams are sent followed by OOB data, so this
> commit replaces `POLLIN|POLLPRI` with just `POLLPRI` in the first test
> case.
> 
> v2:
>   - Add READ_ONCE() to avoid a race reported by KCSAN (Eric)
>   - Add IS_ENABLED(CONFIG_AF_UNIX_OOB) (Shoaib)
> 
> v1:
> https://lore.kernel.org/netdev/20220314052110.53634-1-kuniyu@amazon.co.jp/
> 
> Fixes: 314001f0bf92 ("af_unix: Add OOB support")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

Please ignore this version, I'm sorry for distraction.

I will post v3 later with proper annotations.
https://lore.kernel.org/netdev/20220315105246.77468-1-kuniyu@amazon.co.jp/

Best regards,
Kuniyuki
