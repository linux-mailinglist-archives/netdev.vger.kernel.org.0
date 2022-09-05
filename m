Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D62115AD547
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 16:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238547AbiIEOk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 10:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238536AbiIEOj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 10:39:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432FB5D12D;
        Mon,  5 Sep 2022 07:37:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B1BCB81148;
        Mon,  5 Sep 2022 14:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D51EC433D6;
        Mon,  5 Sep 2022 14:37:31 +0000 (UTC)
Date:   Mon, 5 Sep 2022 10:38:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Menglong Dong <menglong8.dong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Menglong Dong <imagedong@tencent.com>,
        David Ahern <dsahern@kernel.org>,
        Hao Peng <flyingpeng@tencent.com>,
        Dongli Zhang <dongli.zhang@oracle.com>, robh@kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Vasily Averin <vasily.averin@linux.dev>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: skb: export skb drop reaons to user by
 TRACE_DEFINE_ENUM
Message-ID: <20220905103808.434f6909@gandalf.local.home>
In-Reply-To: <CANn89iK7Mm4aPpr1-VM5OgicuHrHjo9nm9P9bYgOKKH9yczFzg@mail.gmail.com>
References: <20220902141715.1038615-1-imagedong@tencent.com>
        <CANn89iK7Mm4aPpr1-VM5OgicuHrHjo9nm9P9bYgOKKH9yczFzg@mail.gmail.com>
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

On Fri, 2 Sep 2022 08:43:07 -0700
Eric Dumazet <edumazet@google.com> wrote:

> > ---
> > v2:
> > - undef FN/FNe after use it (Jakub Kicinski)  
> 
> I would love some feedback from Steven :)

The undef should be fine. I usually do not, but that's more of a preference
than a rule.

As long as the undef is done after the C portion of where the macro is used:

+#undef FN
+#define FN(reason)	TRACE_DEFINE_ENUM(SKB_DROP_REASON_##reason);
+DEFINE_DROP_REASON(FN, FN) <<<--- C portion

+#undef FN
+#undef FNe
+#define FN(reason)	{ SKB_DROP_REASON_##reason, #reason },
+#define FNe(reason)	{ SKB_DROP_REASON_##reason, #reason }
+
 /*
  * Tracepoint for free an sk_buff:
  */
@@ -35,9 +44,13 @@ TRACE_EVENT(kfree_skb,
 
 	TP_printk("skbaddr=%p protocol=%u location=%p reason: %s",
 		  __entry->skbaddr, __entry->protocol, __entry->location,
-		  drop_reasons[__entry->reason])
+		  __print_symbolic(__entry->reason,
+				   DEFINE_DROP_REASON(FN, FNe)))  <<<--- C portion
 );
 
+#undef FN
+#undef FNe

So for this part: Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
