Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2AB156C08C
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238408AbiGHQmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 12:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238214AbiGHQmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 12:42:06 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664D85C9C0
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 09:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657298525; x=1688834525;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SqbX4dqq1Ory3L7jPKe783CtDWBwSZDzSkeE9jTX120=;
  b=WsQ1A9XlH8dicuwO1N89mOOLMH4xNEU2PC4Yz2GEHgtpJn7nhs8/fEu9
   W9BCNSjnKYw+kSelTgs3qIngtU4tMXyG6SgjXpmW3F96pVSCwo61wPerw
   DsFP8hdxBUWESpFcsEFMZSz0JHtH+F3fXz+fZalb102eDCcvUVbwLjePf
   M=;
X-IronPort-AV: E=Sophos;i="5.92,256,1650931200"; 
   d="scan'208";a="1032148002"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-1801e169.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 08 Jul 2022 16:41:49 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-1801e169.us-west-2.amazon.com (Postfix) with ESMTPS id 15CD2C08B6;
        Fri,  8 Jul 2022 16:41:49 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Fri, 8 Jul 2022 16:41:48 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.228) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Fri, 8 Jul 2022 16:41:46 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <ebiederm@xmission.com>,
        <eric.dumazet@gmail.com>, <kuba@kernel.org>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: [PATCH net] af_unix: fix unix_sysctl_register() error path
Date:   Fri, 8 Jul 2022 09:41:33 -0700
Message-ID: <20220708164133.66325-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220708162858.1955086-1-edumazet@google.com>
References: <20220708162858.1955086-1-edumazet@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.228]
X-ClientProxiedBy: EX13D47UWC001.ant.amazon.com (10.43.162.39) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Fri,  8 Jul 2022 16:28:58 +0000
> We want to kfree(table) if @table has been kmalloced,
> ie for non initial network namespace.
> 
> Fixes: 849d5aa3a1d8 ("af_unix: Do not call kmemdup() for init_net's sysctl table.")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Sorry for my carelessness and thank you for the fix!

Best regards,
Kuniyuki
