Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 935976A6B66
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 12:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjCALJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 06:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjCALJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 06:09:48 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D454C1554F;
        Wed,  1 Mar 2023 03:09:46 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1677668984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DDmcH3vpdG8t16J4lZS4RgAS5+xck9hqT5eR2siX/do=;
        b=u9yZ9HmFB9OI9iNsUUl07BWnSLlAZZh6UapAfeHg/Oq1aShdOH7EM04f6rIU52wf29cUHt
        dNnoFKTHxY/DYOWKsofnScXuel8emuHLkxYV29sMQkNHDDY6uxYxmk/PD/1qlgJZdR3thf
        +1hMAldT1pWl4HpX7p3UCTHMlAQkunNOiXd7ATRTsgCbTu9nXwJSaFXKrsJfoP9jpfQp6Q
        lu4OICEBWtYdzxcXZoQ76McLXNeSTmCbZCzhnigjzQ3Wm12xZiLtT1Ixf+Tk2enq/pa+hX
        0yRG/YYKPFnXWEbP4kf2r5pBgVFY2WReiOKCSUAGLAc05M/nqXW2DA7ETTYJHg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1677668984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DDmcH3vpdG8t16J4lZS4RgAS5+xck9hqT5eR2siX/do=;
        b=Q+P85H//Wd5esL/W6IUnHt1E+WAfvha2sSwqh5DIdDMjj6rL3D6yJ98h5QCfxB1iMPpAij
        94RLnjf1Rs255xDw==
To:     Linus Torvalds <torvalds@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Wangyang Guo <wangyang.guo@intel.com>,
        Arjan Van De Ven <arjan.van.de.ven@intel.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [patch 2/3] atomics: Provide rcuref - scalable reference counting
In-Reply-To: <CAHk-=wjeMbHK61Ee+Ug4w8AGHCSDx94GuLs5bPXhHNhA_+RjzA@mail.gmail.com>
References: <20230228132118.978145284@linutronix.de>
 <20230228132910.991359171@linutronix.de>
 <CAHk-=wjeMbHK61Ee+Ug4w8AGHCSDx94GuLs5bPXhHNhA_+RjzA@mail.gmail.com>
Date:   Wed, 01 Mar 2023 12:09:42 +0100
Message-ID: <87pm9slocp.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28 2023 at 16:42, Linus Torvalds wrote:
> On Tue, Feb 28, 2023 at 6:33=E2=80=AFAM Thomas Gleixner <tglx@linutronix.=
de> wrote:
> This may seem like nit-picking, but I absolutely *HATE* our current
> refcount interface for how absolutely horrid the code generation ends
> up being. It's gotten better, but it's still not great.
>
> So if we're introducing yet another refcount interface, and it's done
> in the name of efficiency, I would *really* want it to actually be
> exactly that: efficient. Not some half-way thing.
>
> And yes, that may mean that it should have some architecture-specific
> code (with fallback defaults for the generic case).

Let me stare at that some more.

Thanks,

        tglx
