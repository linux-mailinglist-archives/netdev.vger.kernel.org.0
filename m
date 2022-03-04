Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D614CCCC6
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 06:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236838AbiCDFGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 00:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiCDFGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 00:06:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D01416FDD5;
        Thu,  3 Mar 2022 21:05:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 316FDB82758;
        Fri,  4 Mar 2022 05:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9693EC340E9;
        Fri,  4 Mar 2022 05:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646370346;
        bh=4x65Fp7ObQMvsWCK/jjF9UZ9wVhjMToo0McU7yZbAB8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UOPsBaUoldwHegmZ9+2wxga8RV87CUfr9bstWRpPWCQFWuyfuh0d+e/n8sxsXyQFr
         lS4EdOsfJ5/mV/JlcbaQSuumz3m02f6267PCit8/jnPDWoAbPdsYrhrs4jyQD7mmsK
         i7niYPHvGEc8K8q+r5QDB6RCKY11vfUpCGFwAOi/wB+Y5oYQtEgxrkjzWuWwVkUpI5
         qoEb8lkS8AQo5AIoeWltX/Vt7pJ33fYiNlO5E2y2/ri5pHjk0B66ROfDNloHG+j7HN
         YsZ52/PwF2Z5rRLdT7MLf4oGzEOJBYKj2CBTmHmJA8rlkEpQ6xP4t/NJHYB7L/AAnp
         SDQXsmB1rbViA==
Date:   Thu, 3 Mar 2022 21:05:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexander Lobakin <alobakin@pm.me>, flyingpeng@tencent.com,
        Mengen Sun <mengensun@tencent.com>,
        Antoine Tenart <atenart@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Cong Wang <cong.wang@bytedance.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH net-next 1/7] net: dev: use kfree_skb_reason() for
 sch_handle_egress()
Message-ID: <20220303210544.5036cf7c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CADxym3ZC1kXYF2_YnY3xKYnRGzPimHnahR5eoAr4fkawkm5aSA@mail.gmail.com>
References: <20220303174707.40431-1-imagedong@tencent.com>
        <20220303174707.40431-2-imagedong@tencent.com>
        <20220303202539.17ac1dd5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CADxym3ZC1kXYF2_YnY3xKYnRGzPimHnahR5eoAr4fkawkm5aSA@mail.gmail.com>
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

On Fri, 4 Mar 2022 12:56:40 +0800 Menglong Dong wrote:
> You are right, I think I misunderstanded the concept of qdisc and tc before.
> and seems all 'QDISC' here should be 'TC'? which means:
> 
> QDISC_EGRESS -> TC_EGRESS
> QDISC_DROP -> TC_DROP

For this one QDISC is good, I think, it will mostly catch packets 
which went thru qdisc_drop(), right?

> QDISC_INGRESS -> TC_INGRESS
