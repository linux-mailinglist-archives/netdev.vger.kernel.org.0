Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67C7522993
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 04:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbiEKCWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 22:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiEKCWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 22:22:30 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FCA14C749;
        Tue, 10 May 2022 19:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1652235748; x=1683771748;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zmwvbfSvqDsGXUYgLhWD8/wDkuM1DY3RQ9mlmoV5r/g=;
  b=Wj6AIuwHdE9QHgT1dFhlK4+4pkKda06F/3PlqjufySnSGzhWBnx8yip7
   uMCQEbGEANDqE1esysTjPke1ADraA13hHeljstZ6dTLlbJSLx5vOPJ0td
   vCXBS4+3CugIfJxp2cf5gsZ2z3UET0nCyeXNeaDLvYTnXrX+6x+BjYqpq
   A=;
X-IronPort-AV: E=Sophos;i="5.91,215,1647302400"; 
   d="scan'208";a="87272036"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-1f9d5b26.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 11 May 2022 02:22:27 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-1f9d5b26.us-west-2.amazon.com (Postfix) with ESMTPS id 8319541C5A;
        Wed, 11 May 2022 02:22:27 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Wed, 11 May 2022 02:22:26 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.22) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Wed, 11 May 2022 02:22:23 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <keescook@chromium.org>
CC:     <ast@kernel.org>, <cong.wang@bytedance.com>, <davem@davemloft.net>,
        <hch@infradead.org>, <kuba@kernel.org>, <kuniyu@amazon.co.jp>,
        <linux-hardening@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] af_unix: Silence randstruct GCC plugin warning
Date:   Wed, 11 May 2022 11:22:17 +0900
Message-ID: <20220511022217.58586-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220511000109.3628404-1-keescook@chromium.org>
References: <20220511000109.3628404-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.22]
X-ClientProxiedBy: EX13D15UWB004.ant.amazon.com (10.43.161.61) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Kees Cook <keescook@chromium.org>
Date:   Tue, 10 May 2022 17:01:09 -0700
> While preparing for Clang randstruct support (which duplicated many of
> the warnings the randstruct GCC plugin warned about), one strange one
> remained only for the randstruct GCC plugin. Eliminating this rids
> the plugin of the last exception.
> 
> It seems the plugin is happy to dereference individual members of
> a cross-struct cast, but it is upset about casting to a whole object
> pointer. This only manifests in one place in the kernel, so just replace
> the variable with individual member accesses. There is no change in
> executable instruction output.
> 
> Drop the last exception from the randstruct GCC plugin.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Cong Wang <cong.wang@bytedance.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: netdev@vger.kernel.org
> Cc: linux-hardening@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

LGTM, thank you.

Acked-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
