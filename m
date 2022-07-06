Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B5C568933
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 15:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233743AbiGFNRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 09:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233726AbiGFNRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 09:17:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE6022297;
        Wed,  6 Jul 2022 06:17:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 99F92CE1EA1;
        Wed,  6 Jul 2022 13:17:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918DCC3411C;
        Wed,  6 Jul 2022 13:17:09 +0000 (UTC)
Date:   Wed, 6 Jul 2022 09:17:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [PATCH v1 net 11/16] net: Fix a data-race around sysctl_mem.
Message-ID: <20220706091707.07251fd9@gandalf.local.home>
In-Reply-To: <20220706052130.16368-12-kuniyu@amazon.com>
References: <20220706052130.16368-1-kuniyu@amazon.com>
        <20220706052130.16368-12-kuniyu@amazon.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Jul 2022 22:21:25 -0700
Kuniyuki Iwashima <kuniyu@amazon.com> wrote:

> --- a/include/trace/events/sock.h
> +++ b/include/trace/events/sock.h
> @@ -122,9 +122,9 @@ TRACE_EVENT(sock_exceed_buf_limit,
>  
>  	TP_printk("proto:%s sysctl_mem=%ld,%ld,%ld allocated=%ld sysctl_rmem=%d rmem_alloc=%d sysctl_wmem=%d wmem_alloc=%d wmem_queued=%d kind=%s",
>  		__entry->name,
> -		__entry->sysctl_mem[0],
> -		__entry->sysctl_mem[1],
> -		__entry->sysctl_mem[2],
> +		READ_ONCE(__entry->sysctl_mem[0]),
> +		READ_ONCE(__entry->sysctl_mem[1]),
> +		READ_ONCE(__entry->sysctl_mem[2]),

This is not reading anything to do with sysctl. It's reading the content of
what was recorded in the ring buffer.

That is, the READ_ONCE() here is not necessary, and if anything will break
user space parsing, as this is exported to user space to tell it how to
read the binary format in the ring buffer.

-- Steve


>  		__entry->allocated,
>  		__entry->sysctl_rmem,
>  		__entry->rmem_alloc,
