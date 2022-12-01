Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C37463FC1F
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 00:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbiLAXgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 18:36:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbiLAXgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 18:36:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2929DA47F3;
        Thu,  1 Dec 2022 15:36:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F831621B6;
        Thu,  1 Dec 2022 23:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708CAC433C1;
        Thu,  1 Dec 2022 23:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669937767;
        bh=kOpV5F3H9zw7ssEkXlo5P1Ww9ety3cKYMPUvZSRKm6Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MO2j/fxKH28EN5OqO4OeTxj5264wLoyst7kgLjm99wbYQTeXPcMkhwYRXxNdbb9Vo
         qsuw+y4eC0C1YnVYJSOd++UqtV1cc/NUODzYuquUOQ0eEjEdX3uRsUbx2ZeSHddo4H
         lg9hCgRGYbMJoa66K3HbSo3qyfKiKdR4ASBl6e6E7Iqj7FLLNSXayJccAZiTVKEM6o
         kWqSgJ+85TI7vuKD5M1OrPEBj+WWE4CeBcoeMzArjpieybOfH+mA1ve3BXas6sGcug
         UcgrbxBXKUrHWItNVP9SmbnxxmeinAuPBXT5F1/uom7wxANVCMYsI1E9pOQmhBXxft
         0CTWORuM8+5Ug==
Date:   Thu, 1 Dec 2022 15:36:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH v6 1/5] jump_label: Prevent key->enabled int overflow
Message-ID: <20221201153605.58c2382d@kernel.org>
In-Reply-To: <CAJwJo6Z9sTDgOFFrpbrXT6eagtmbB5mhfudG0Osp75J4ipNSqQ@mail.gmail.com>
References: <20221123173859.473629-1-dima@arista.com>
        <20221123173859.473629-2-dima@arista.com>
        <Y4B17nBArWS1Iywo@hirez.programming.kicks-ass.net>
        <2081d2ac-b2b5-9299-7239-dc4348ec0d0a@arista.com>
        <20221201143134.6bb285d8@kernel.org>
        <CAJwJo6Z9sTDgOFFrpbrXT6eagtmbB5mhfudG0Osp75J4ipNSqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 1 Dec 2022 23:17:11 +0000 Dmitry Safonov wrote:
> On Thu, 1 Dec 2022 at 22:31, Jakub Kicinski <kuba@kernel.org> wrote:
> > > I initially thought it has to go through tip trees because of the
> > > dependence, but as you say it's just one patch.
> > >
> > > I was also asked by Jakub on v4 to wait for Eric's Ack/Review, so once I
> > > get a go from him, I will send all 6 patches for inclusion into -net
> > > tree, if that will be in time before the merge window.  
> >
> > Looks like we're all set on the networking side (thanks Eric!!)  
> 
> Thanks!
> 
> > Should I pull Peter's branch? Or you want to just resent a patch Peter
> > already queued. A bit of an unusual situation..  
> 
> Either way would work for me.
> I can send it in a couple of hours if you prefer instead of pulling the branch.

I prefer to pull, seems safer in case Peter does get another patch.

It's this one, right?

https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/log/?h=locking/core

I'll pulled, I'll push out once the build is done.
