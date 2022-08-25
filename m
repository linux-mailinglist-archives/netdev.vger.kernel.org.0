Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57BC5A0582
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 03:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbiHYBKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 21:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiHYBKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 21:10:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93DE6262;
        Wed, 24 Aug 2022 18:10:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64629B826C8;
        Thu, 25 Aug 2022 01:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730F8C433C1;
        Thu, 25 Aug 2022 01:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661389842;
        bh=eZ9Go/XQl2wAHzhKg+W8LOTDr4ufdLcry+Kq/lkNzUQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KfPUKgrzVARDDdQ+kYVWsucaMZd+BX0YulGPrcymaBMqNxMGRq/ikm9hNNEIs6UhE
         vcbvQU4EiiFy0M696BEvL90BV38fu+LbjEa5Tz/B3Ly+3T8CecDwaXm15p7IqvEygW
         H+FOCBCNtKjZSWSLhBKf/qWYmDFXo4/iaDPYgbfQfX8Gee1fvQQYc2Y1l+zi1Egjoq
         KeX1YjhbrO6H0/C+R3iNcTagMhYIVwyUAlLRmnKaPVjpATdE9nLSH82zM4zeTAwveN
         poZRNF/zVSHYEgrae48+Xtrev4QWy5O26liocbYUk/ky7Uj7bBlNmGNCIZ3sYnNWzc
         L0+wGovai6YAw==
Date:   Wed, 24 Aug 2022 18:10:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Menglong Dong <menglong8.dong@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        David Ahern <dsahern@kernel.org>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH net-next v4 2/3] net: skb: use auto-generation to
 convert skb drop reason to string
Message-ID: <20220824181040.57ec009e@kernel.org>
In-Reply-To: <CANn89i+bx0ybvE55iMYf5GJM48WwV1HNpdm9Q6t-HaEstqpCSA@mail.gmail.com>
References: <20220606022436.331005-1-imagedong@tencent.com>
        <20220606022436.331005-3-imagedong@tencent.com>
        <CANn89i+bx0ybvE55iMYf5GJM48WwV1HNpdm9Q6t-HaEstqpCSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Aug 2022 17:45:15 -0700 Eric Dumazet wrote:
> After this patch, I no longer have strings added after the reason: tag

Hm, using a kernel address (drop_reasons) as an argument to TP_printk()
definitely does not look right, but how to tickle whatever magic
__print_symbolic was providing I do not know :S

 	TP_printk("skbaddr=%p protocol=%u location=%p reason: %s",
 		  __entry->skbaddr, __entry->protocol, __entry->location,
-		  __print_symbolic(__entry->reason,
-				   TRACE_SKB_DROP_REASON))
+		  drop_reasons[__entry->reason])
