Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F08656AF8C
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 03:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236096AbiGHAoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 20:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236059AbiGHAoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 20:44:38 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3056570E64;
        Thu,  7 Jul 2022 17:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657241078; x=1688777078;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q5Q31E4e8BGfyXOcW48hfgOajzfQiY6E9eCjWzJyRNw=;
  b=VlrkmY2QQGPi44yxxYJwupA/gtXJvt9cCwug36eKfxEP7fIcggoJB4hJ
   dcjNOQmHd5rKNtwELAwUiabO0vTN8sMIv3l4JQMhNnm9L14zYcwL+8zb8
   5ZIw05W20OXGz3JCHdrZAqZDLqXOfjIU68z/IvomezeD5vYvLl73ra4ae
   A=;
X-IronPort-AV: E=Sophos;i="5.92,253,1650931200"; 
   d="scan'208";a="236013863"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-a264e6fe.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 08 Jul 2022 00:44:23 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-a264e6fe.us-west-2.amazon.com (Postfix) with ESMTPS id 9B32043DFD;
        Fri,  8 Jul 2022 00:44:22 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Fri, 8 Jul 2022 00:44:20 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.50) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Fri, 8 Jul 2022 00:44:17 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <kuba@kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>,
        <keescook@chromium.org>, <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <linux-kernel@vger.kernel.org>, <mcgrof@kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <paul@paul-moore.com>, <yzaikin@google.com>
Subject: Re: [PATCH v2 net 10/12] cipso: Fix data-races around sysctl.
Date:   Thu, 7 Jul 2022 17:44:08 -0700
Message-ID: <20220708004408.37060-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220707172424.2b280154@kernel.org>
References: <20220707172424.2b280154@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.50]
X-ClientProxiedBy: EX13D49UWB002.ant.amazon.com (10.43.163.68) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Jakub Kicinski <kuba@kernel.org>
Date:   Thu, 7 Jul 2022 17:24:24 -0700
> On Thu, 7 Jul 2022 15:15:37 -0700 Kuniyuki Iwashima wrote:
> > I was wondering if both CC and Acked-by should stay in each commit, but
> > will do so in the next time.
> 
> For Paul only, don't take that as general advice.

...got it, thanks :)
