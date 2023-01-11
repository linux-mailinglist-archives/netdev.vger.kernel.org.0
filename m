Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C33E76652AF
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 05:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235077AbjAKEML convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 10 Jan 2023 23:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbjAKEMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 23:12:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BC712AE3;
        Tue, 10 Jan 2023 20:12:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11A40B81AAE;
        Wed, 11 Jan 2023 04:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32B2C433D2;
        Wed, 11 Jan 2023 04:12:02 +0000 (UTC)
Date:   Tue, 10 Jan 2023 23:12:01 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     =?UTF-8?B?6L+Q6L6J5bSU?= <cuiyunhui@bytedance.com>
Cc:     Eric Dumazet <edumazet@google.com>, mhiramat@kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        kuniyu@amazon.com, xiyou.wangcong@gmail.com,
        duanxiongchun@bytedance.com, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, netdev@vger.kernel.org,
        dust.li@linux.alibaba.com
Subject: Re: [External] Re: [PATCH v5] sock: add tracepoint for send recv
 length
Message-ID: <20230110231201.5eddb889@gandalf.local.home>
In-Reply-To: <CAEEQ3w=aU3siD-ubhPB3+Wv10ARfUeR=cUHmvdEp2q+y105vAw@mail.gmail.com>
References: <20230110091356.1524-1-cuiyunhui@bytedance.com>
        <CANn89i+Wh2krOy4YFWvBsEx-s_JgQ0HixHAVJwGw18dVPeyiqw@mail.gmail.com>
        <20230110104419.67294691@gandalf.local.home>
        <CAEEQ3w=aU3siD-ubhPB3+Wv10ARfUeR=cUHmvdEp2q+y105vAw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Jan 2023 11:53:24 +0800
运辉崔 <cuiyunhui@bytedance.com> wrote:

> Hi Steve, Based on your suggestion, can we use the following code
> instead of using DEFINE_EVENT_PRINT ？

I only suggested it because you didn't have that logic for the
sock_send_length trace event. But if you don't care about that one, then
sure, use it for both.

-- Steve


> 
> DECLARE_EVENT_CLASS(sock_msg_length,
> 
>         TP_PROTO(struct sock *sk, int ret, int flags),
> 
>         TP_ARGS(sk, ret, flags),
> 
>         TP_STRUCT__entry(
>                 __field(void *, sk)
>                 __field(__u16, family)
>                 __field(__u16, protocol)
>                 __field(int, ret)
>                 __field(int, flags)
>         ),
> 
>         TP_fast_assign(
>                 __entry->sk = sk;
>                 __entry->family = sk->sk_family;
>                 __entry->protocol = sk->sk_protocol;
>                 __entry->ret = ret;
>                 __entry->flags = flags;
>         ),
> 
>         TP_printk("sk address = %p, family = %s protocol = %s, length
> = %d, error = %d, flags = 0x%x",
>                   __entry->sk, show_family_name(__entry->family),
>                   show_inet_protocol_name(__entry->protocol),
>                   !(__entry->flags & MSG_PEEK) ?
>                   (__entry->ret > 0 ? __entry->ret : 0) : 0,
>                   __entry->ret < 0 ? __entry->ret : 0,
>                   __entry->flags)
> );

