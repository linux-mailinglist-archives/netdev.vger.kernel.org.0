Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8B352AFBA
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 03:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbiERBPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 21:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiERBPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 21:15:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0A651E4C;
        Tue, 17 May 2022 18:15:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BDB4B81BE3;
        Wed, 18 May 2022 01:15:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8505C385B8;
        Wed, 18 May 2022 01:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652836499;
        bh=1FAGE2F5QluYFDYsSaQPr26HXYE6L0gi0jyOY35c6uM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fceAip9tgfCYolvMzQ45mOd5P7VrLMRoiDAtJu51yZGz2G7GsjS46D3hHDyJbJmjb
         TF6eGE9MbKzs3AGaUJg1ZGwUvkWL5IH2zmaXmiUvAj3F1MlUe4TCpjdCrFa+lpwu+6
         hV4ntKOWewTW/LaM4V1pgPWEqp49UwoPDeEk28VQTAoktoHx6Jmi6onYaSD1zsMBjI
         l6+Gy3nsL8eteN5Oczi2zM9XYLkj/S8U2l/FZytk393Qrjdx95pVyco71FiKQiNr7y
         sNZgsqQtPZLD/7yE2d0z9An0/plmN/+ElsCwwy1i3BmcZ82xqnN8X778b7wVbN209X
         ceqcTNH1DWP+A==
Date:   Tue, 17 May 2022 18:14:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     edumazet@google.com, rostedt@goodmis.org, mingo@redhat.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        pabeni@redhat.com, imagedong@tencent.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jiang Biao <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
Subject: Re: [PATCH net-next v2 1/9] net: skb: introduce
 __DEFINE_SKB_DROP_REASON() to simply the code
Message-ID: <20220517181457.04c37147@kernel.org>
In-Reply-To: <20220517081008.294325-2-imagedong@tencent.com>
References: <20220517081008.294325-1-imagedong@tencent.com>
        <20220517081008.294325-2-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 May 2022 16:10:00 +0800 menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> It is annoying to add new skb drop reasons to 'enum skb_drop_reason'
> and TRACE_SKB_DROP_REASON in trace/event/skb.h, and it's easy to forget
> to add the new reasons we added to TRACE_SKB_DROP_REASON.
> 
> TRACE_SKB_DROP_REASON is used to convert drop reason of type number
> to string. For now, the string we passed to user space is exactly the
> same as the name in 'enum skb_drop_reason' with a 'SKB_DROP_REASON_'
> prefix. So why not make them togather by define a macro?
> 
> Therefore, introduce __DEFINE_SKB_DROP_REASON() and use it for 'enum
> skb_drop_reason' definition and string converting.
> 
> Now, what should we with the document for the reasons? How about follow
> __BPF_FUNC_MAPPER() and make these document togather?

Hi, I know BPF does this but I really find the definition-by-macro 
counter productive :(

kdoc will no longer work right because the parser will not see 
the real values. cscope and other code indexers will struggle 
to find definitions.

Did you investigate using auto-generation? Kernel already generates 
a handful of headers. Maybe with a little script we could convert 
the enum into the string thing at build time?

Also let's use this opportunity to move the enum to a standalone
header, it's getting huge.

Probably worth keeping this rework separate from the TCP patches.
Up to you which one you'd like to get done first.
