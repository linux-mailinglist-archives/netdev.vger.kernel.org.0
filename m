Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F76A52523B
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 18:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351417AbiELQN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 12:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344868AbiELQN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 12:13:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17F86540C;
        Thu, 12 May 2022 09:13:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58576B8290E;
        Thu, 12 May 2022 16:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A94C34100;
        Thu, 12 May 2022 16:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652372005;
        bh=MPzmk8Ez+RWMMvLvJxCn5facByiVmYr+47jsFzQGqyA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CvG0YLi0J1Qeo0hGbIlTmLG776x3fAxE4+RkACwyc3s0ud17gB/odgY/DhTNbM4lM
         DGU6IE0sLr0HKsLVbkxPsJnYZSroEqSKKb3V+KfSbodZ2qtJEciNMM/Fh/5VIhZ5bg
         DK12VC9NnrlJDjJWleNbVpKzvQIgTjcxmp0ardQGylJnpAsOlUUx5X0BnnqjzO6MEF
         PKHdY5tllulePKaHJfboKPNsrVVyPYYbDKeVLTU2npkIwW7HUMtznF/5xUS+uSwH+L
         GUPu170udw1Yu/zbvIPZg/+XKcSVLHui+/ZGhgwWjPSXsFiH7tGjJk2WiQkx3xOgRg
         +JAeoSxS+LwOQ==
Date:   Thu, 12 May 2022 09:13:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        Martin Lau <kafai@fb.com>, Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>, asml.silence@gmail.com,
        Willem de Bruijn <willemb@google.com>,
        vasily.averin@linux.dev,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] net: skb: check the boundrary of skb drop
 reason
Message-ID: <20220512091323.63ea232c@kernel.org>
In-Reply-To: <CADxym3Zqe=9TA_JBYCEX2tqeVxLN_LbH_F_zQuoXBG4XK=mc7g@mail.gmail.com>
References: <20220512062629.10286-1-imagedong@tencent.com>
        <CADxym3Zqe=9TA_JBYCEX2tqeVxLN_LbH_F_zQuoXBG4XK=mc7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 May 2022 20:31:14 +0800 Menglong Dong wrote:
> On Thu, May 12, 2022 at 2:26 PM <menglong8.dong@gmail.com> wrote:
> >
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > In the commit 1330b6ef3313 ("skb: make drop reason booleanable"),
> > SKB_NOT_DROPPED_YET is added to the enum skb_drop_reason, which makes
> > the invalid drop reason SKB_NOT_DROPPED_YET can leak to the kfree_skb
> > tracepoint. Once this happen (it happened, as 4th patch says), it can
> > cause NULL pointer in drop monitor and result in kernel panic.
> >
> > Therefore, check the boundrary of drop reason in both kfree_skb_reason
> > (2th patch) and drop monitor (1th patch).
> >
> > Meanwhile, fix the invalid drop reason passed to kfree_skb_reason() in
> > tcp_v4_rcv().
> >  
> 
> tcp_v6_rcv() is forgeted, I'll send a V2 :/

Please don't repost stuff within 24h:

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#i-have-received-review-feedback-when-should-i-post-a-revised-version-of-the-patches

I could have given you the same exact feedback on v1 as v2...
