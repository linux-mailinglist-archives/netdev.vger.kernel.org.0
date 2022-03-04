Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F40AC4CCC89
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 05:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237895AbiCDE0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 23:26:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbiCDE0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 23:26:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7590F13DE3B;
        Thu,  3 Mar 2022 20:25:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D26D7CE293F;
        Fri,  4 Mar 2022 04:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27004C340E9;
        Fri,  4 Mar 2022 04:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646367942;
        bh=4RR/ZwR4k6fIylucFqMIbynVgTF5anFR10HQXEhVa7M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qG6dbDEzgIksQYhfOxv9kFJpnNMNmkQ2bhH2XkOtzOtubCofr9d3dfluIfmCUyrU3
         TkHmbWh9COBrdgZHxbARwESNgwKS7Zsgz54nKGd3EWwVnisw6fmnjhOqyNCWofJoux
         y5YPP+BKMkbglWANaeiQLeraURBUHZ4Sy42EXKvm4DztmuEFnnOAziDr2tqGGKOwL5
         R7VDmoVvThnnezQIpvwJLd85vb+BTxFgnZV8ASbq8fdeNJ8YBeCq84PnSNFPbzj+zp
         JCOZYNDErdQWPGXVmGcj3KokzOLwSsoDrU/OxXXXTV3crAa0NK+lTqRIPMlVRap7yJ
         dBotRRumSt0PA==
Date:   Thu, 3 Mar 2022 20:25:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     dsahern@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, imagedong@tencent.com,
        edumazet@google.com, talalahmad@google.com, keescook@chromium.org,
        ilias.apalodimas@linaro.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com, atenart@kernel.org,
        bigeasy@linutronix.de, memxor@gmail.com, arnd@arndb.de,
        pabeni@redhat.com, willemb@google.com, vvs@virtuozzo.com,
        cong.wang@bytedance.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next 1/7] net: dev: use kfree_skb_reason() for
 sch_handle_egress()
Message-ID: <20220303202539.17ac1dd5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220303174707.40431-2-imagedong@tencent.com>
References: <20220303174707.40431-1-imagedong@tencent.com>
        <20220303174707.40431-2-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Mar 2022 01:47:01 +0800 menglong8.dong@gmail.com wrote:
> Replace kfree_skb() used in sch_handle_egress() with kfree_skb_reason().
> The drop reason SKB_DROP_REASON_QDISC_EGRESS is introduced. Considering
> the code path of qdisc egerss, we make it distinct with the drop reason
> of SKB_DROP_REASON_QDISC_DROP in the next commit.

I don't think this has much to do with Qdiscs, this is the TC
egress hook, it's more for filtering. Classful Qdisc like HTB 
will run its own classification. I think.

Maybe TC_EGRESS?
