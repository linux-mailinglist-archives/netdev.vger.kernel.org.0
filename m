Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C4C59EE75
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 23:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiHWVw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 17:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbiHWVwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 17:52:21 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BBC89CDC;
        Tue, 23 Aug 2022 14:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661291540; x=1692827540;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ok9Bwerm1vYuPSiFSWe7B24oIGvWnmZ4p82SyuNe9OI=;
  b=Iza/TxITl2n+ilqslR6HFpGg3f+/R5upoeCdqVCjYDrx9v/OlBLCYcZ/
   zi050Uf4PzObfnHJs74F/6emkc88wNyIBikVrx8VMrI9R0u79BZ5GYIhU
   diJhESfRWPv9qQlQ/SF6g2xxNvvBJmG9E0eMkIhUOeL6AQOe9rPHD8Qe4
   0=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-7d84505d.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 21:52:09 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-7d84505d.us-west-2.amazon.com (Postfix) with ESMTPS id 508DF91082;
        Tue, 23 Aug 2022 21:52:08 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 23 Aug 2022 21:52:07 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.191) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 23 Aug 2022 21:52:05 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <bpf@vger.kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 bpf] bpf: Fix a data-race around bpf_jit_limit.
Date:   Tue, 23 Aug 2022 14:51:56 -0700
Message-ID: <20220823215156.1623-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <311e4686-a514-b210-080b-849d8d0ad5d3@iogearbox.net>
References: <311e4686-a514-b210-080b-849d8d0ad5d3@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.191]
X-ClientProxiedBy: EX13D24UWA003.ant.amazon.com (10.43.160.195) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Daniel Borkmann <daniel@iogearbox.net>
Date:   Tue, 23 Aug 2022 23:20:29 +0200
> On 8/23/22 8:12 PM, Kuniyuki Iwashima wrote:
> > While reading bpf_jit_limit, it can be changed concurrently.
> > Thus, we need to add READ_ONCE() to its reader.
> 
> For sake of a better/clearer commit message, please also provide data about the
> WRITE_ONCE() pairing that this READ_ONCE() targets. This seems to be the case in
> __do_proc_doulongvec_minmax() as far as I can see. For your 2nd sentence above
> please also include load-tearing as main motivation for your fix.

I'll add better description.
Thank you!

> 
> > Fixes: ede95a63b5e8 ("bpf: add bpf_jit_limit knob to restrict unpriv allocations")
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> > v2:
> >    * Drop other 3 patches (No change for this patch)
> > 
> > v1: https://lore.kernel.org/bpf/20220818042339.82992-1-kuniyu@amazon.com/
> > ---
> >   kernel/bpf/core.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index c1e10d088dbb..3d9eb3ae334c 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
> > @@ -971,7 +971,7 @@ pure_initcall(bpf_jit_charge_init);
> >   
> >   int bpf_jit_charge_modmem(u32 size)
> >   {
> > -	if (atomic_long_add_return(size, &bpf_jit_current) > bpf_jit_limit) {
> > +	if (atomic_long_add_return(size, &bpf_jit_current) > READ_ONCE(bpf_jit_limit)) {
> >   		if (!bpf_capable()) {
> >   			atomic_long_sub(size, &bpf_jit_current);
> >   			return -EPERM;
> > 
