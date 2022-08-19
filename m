Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F04599E68
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 17:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349773AbiHSPcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 11:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349756AbiHSPcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 11:32:52 -0400
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA218101C72;
        Fri, 19 Aug 2022 08:32:49 -0700 (PDT)
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 27JFLw53006284;
        Fri, 19 Aug 2022 10:21:58 -0500
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 27JFLvQc006283;
        Fri, 19 Aug 2022 10:21:57 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Fri, 19 Aug 2022 10:21:57 -0500
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>, kuba@kernel.org,
        miguel.ojeda.sandonis@gmail.com, ojeda@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        asml.silence@gmail.com, imagedong@tencent.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        jk@codeconstruct.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel test robot <lkp@intel.com>,
        linux-toolchains <linux-toolchains@vger.kernel.org>
Subject: Re: [PATCH net-next v4] net: skb: prevent the split of kfree_skb_reason() by gcc
Message-ID: <20220819152157.GO25951@gate.crashing.org>
References: <20220816032846.2579217-1-imagedong@tencent.com> <CAKwvOd=accNK7t_SOmybo3e4UcBKoZ6TBPjCHT3eSSpSUouzEA@mail.gmail.com> <CADxym3Yxq0k_W43kVjrofjNoUUag3qwmpRGLLAQL1Emot3irPQ@mail.gmail.com> <20220818165838.GM25951@gate.crashing.org> <CADxym3YEfSASDg9ppRKtZ16NLh_NhH253frd5LXZLGTObsVQ9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADxym3YEfSASDg9ppRKtZ16NLh_NhH253frd5LXZLGTObsVQ9g@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

On Fri, Aug 19, 2022 at 10:55:42PM +0800, Menglong Dong wrote:
> Thanks for your explanation about the usage of 'noinline' and 'no_icf'!
> I think 'noclone' seems enough in this case? As the function
> 'kfree_skb_reason' we talk about is a global function, I think that the
> compiler has no reason to make it inline, or be merged with another
> function.

Whether something is inlined is decided per instance (except for
always_inline and noinline functions).  Of course the function body has
to be available for anything to be inlined, so barring LTO this can only
happen for function uses in the same source file.  Not very likely
indeed, but not entirely impossible either.

A function can be merged if there is another function that does exactly
the same thing.  This is unlikely with functions that do some serious
work of course, but it is likely with stub-like functions.

gl;hf,


Segher
