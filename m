Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534B56AFA11
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 00:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjCGXJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 18:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjCGXJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 18:09:32 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4369699649;
        Tue,  7 Mar 2023 15:09:31 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1678230569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m8pW7z5PV1AAXwejM0PvLOkt1YjCY1d4qh5NVa41Pvc=;
        b=AQNQiE0N9rQ50MnK7Tu2C66Xwr9T2bUWAXOAjwZhEeMhph/Kn8cOHXtSTW3EdnkuE/nRBn
        NL+beVZIgTpkEUw/1JkO1dojfYVNOSEwOhM1a91oNKEyqrJs1OuZN04JA5Blt1aFKOv9dM
        SAFQs7L6S0JU5dFdELMLY7tPgmxmryOEVlLCH1klIr+zcJcIL7Z0ZcDN/5gIJLo0Fj5rPU
        mTaEs3/1lWjgu+9up2LOGFZL+ZhGCDw00ku8WMU7EiK5Io67rvcPxH9gcKENnhH1qDeFwS
        4wLPVofU/ZqLlRoVKhyf9dbjMTul8w7QA4p3dn2xnaWb2Mh2tVF4360xZMhRXw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1678230569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m8pW7z5PV1AAXwejM0PvLOkt1YjCY1d4qh5NVa41Pvc=;
        b=iSEh5BblsSell8Xhox9VODlRK0lIBBD5dPiuPStFtQWPzycMQQTa1dHqp96TzneKedTwGr
        8xY4lPC9BlGs1pBQ==
To:     Linus Torvalds <torvalds@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Wangyang Guo <wangyang.guo@intel.com>,
        Arjan van De Ven <arjan@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Arjan Van De Ven <arjan.van.de.ven@intel.com>
Subject: Re: [patch V2 4/4] net: dst: Switch to rcuref_t reference counting
In-Reply-To: <CAHk-=wjO15WdfF2Y=pROf2pid0zW5xfHnfJt3bH2QWQp6oWyGw@mail.gmail.com>
References: <20230307125358.772287565@linutronix.de>
 <20230307125538.989175656@linutronix.de>
 <CAHk-=wjO15WdfF2Y=pROf2pid0zW5xfHnfJt3bH2QWQp6oWyGw@mail.gmail.com>
Date:   Wed, 08 Mar 2023 01:00:16 +0200
Message-ID: <87356gb20v.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07 2023 at 09:55, Linus Torvalds wrote:
> On Tue, Mar 7, 2023 at 4:57=E2=80=AFAM Thomas Gleixner <tglx@linutronix.d=
e> wrote:
>>
>> -       atomic_t                __refcnt;       /* 64-bit offset 64 */
>> +       rcuref_t                __refcnt;       /* 64-bit offset 64 */
>
>> -       atomic_t                __refcnt;       /* 32-bit offset 64 */
>> +       rcuref_t                __refcnt;       /* 32-bit offset 64 */
>
> I assume any mis-use is caught by typechecking, but I'd be even
> happier if you changed the name of the member when you fundamentally
> change the use model for it (eg "__refcnt" -> "__rcuref" or
> something).
>
> Or was there some reason for not doing that?

Other than sheer laziness? No. You have a valid point and I should have
thought about that myself.

Thanks for calling me out on that.

       tglx
