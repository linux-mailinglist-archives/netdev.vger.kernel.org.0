Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC514DA969
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 05:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345951AbiCPEvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 00:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236687AbiCPEvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 00:51:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FAD55F8CA;
        Tue, 15 Mar 2022 21:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2C39B818CD;
        Wed, 16 Mar 2022 04:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B71C340E9;
        Wed, 16 Mar 2022 04:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647406214;
        bh=H3FPr19WST+m0fhj11hmPmJeZEAkG3aiYnTZNuLWcTo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gZrvBcKufmvKNkJtMY411s1aDlB7CGLMtTEQjmAbdpKjjPKgk826EB5nypP9cteee
         de7gY/ZVqAekBaJ2y15yWdd924CGCemJyF3ERIDJQgs3oXlVICMk/7i2DNh+d0SnHw
         VVCjXuseizfeEErsWoEzlOBCFUCZ2opGOzgp1YXC5DV47ZWXVJe0TGlGvXrDGGbSXx
         R73MNWtuR8GwU+xM0PpLBEDXdMo7O+03fcpfMEdbj4hYaUjl5x1Jy+k/SweO0IMEdd
         t2A41bA+EVAKQq70b7Q6U1aYVl0vjeDxEPoB2cLRPqKjUlQgMjAcZ7NnMzIoZHVlt6
         LLZVzquW3mmag==
Date:   Tue, 15 Mar 2022 21:50:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, xeb@mail.ru,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, Martin Lau <kafai@fb.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Hao Peng <flyingpeng@tencent.com>,
        Mengen Sun <mengensun@tencent.com>, dongli.zhang@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Biao Jiang <benbjiang@tencent.com>
Subject: Re: [PATCH net-next 1/3] net: gre_demux: add skb drop reasons to
 gre_rcv()
Message-ID: <20220315215012.464bc7d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CADxym3YQZHwYSvg-ikH8N2iH3tBwAxusCsLHDMtCUjQj2h_chg@mail.gmail.com>
References: <20220314133312.336653-1-imagedong@tencent.com>
        <20220314133312.336653-2-imagedong@tencent.com>
        <20220315200847.68c2efee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CADxym3YQZHwYSvg-ikH8N2iH3tBwAxusCsLHDMtCUjQj2h_chg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Mar 2022 12:41:45 +0800 Menglong Dong wrote:
> > On Mon, 14 Mar 2022 21:33:10 +0800 menglong8.dong@gmail.com wrote:  
> > > +     reason = SKB_DROP_REASON_NOT_SPECIFIED;
> > >       if (!pskb_may_pull(skb, 12))
> > >               goto drop;  
> >
> > REASON_HDR_TRUNC ?  
> 
> I'm still not sure about such a 'pskb_pull' failure, whose reasons may be
> complex, such as no memory or packet length too small. I see somewhere
> return a '-NOMEM' when skb pull fails.
> 
> So maybe such cases can be ignored? In my opinion, not all skb drops
> need a reason.

Ah, okay, I saw Dave's email as well. I wasn't sure if this omission
was intentional. But if it is, that's fine.
