Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1234DE83A
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 14:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243093AbiCSN7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 09:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241986AbiCSN7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 09:59:06 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1D840E74
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 06:57:45 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id k125so8782126qkf.0
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 06:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rac/T1uCgRkKdVo18Y1asxDHBvA6nYHko+ROAHe2fSM=;
        b=U7q84Tbf4G3V8V++ECB85fFy8IR3FJ/HYRcJOeRqDuJWWAs+O60IvqQnZ006w6S7W2
         pssocQszERkhx3B8tEh/j1alr9DydBSqcZKoNH0zHralT6o+oCtBo1Ms4hA0uPIhAmtW
         OZNtlXP/JUP4r/S0MvBzyfNH/98lokgy3JQ6I1Nmd2I+i7C0yYGo5LBuAPpWW13ezmND
         eFNthG6p0Ws9ZGCFXXnelH+x2RHiz38wkv1fUtTgUxe5QE/zam3nTxHeh25ZQ2Feertk
         sGG5TQqdp3y8eT9wEWK/pkAd39JBRuHaDk4/AYz0khCBbLSV3PFtQJynL2JAi0GrefnE
         cInQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rac/T1uCgRkKdVo18Y1asxDHBvA6nYHko+ROAHe2fSM=;
        b=tXZi6oRS+EZZF2b6rSXRVuBe6RugvITZ+b6SrnuljX2YCbSel16kePpPWMcWbiIaeG
         U67uBo/RRXZZHOgL094Yanhy5W7PClQHckH+UGd7wz10lzghez7i4av/5JsxIkOvhtRd
         MTQUgAyUOt6XOyzpxcKZ8aeBEhli9V3LmS25Xz/HGsn1/mh/96uProprF2/oEH8JKsaD
         mDjYJkf8QmdYR0SZKytzyHM/3PXg06GQ51LjZ+XpN/4Gz4j7NtRtT3nI8pY0dsLD27zP
         7as2Y17fnf07pRCGM5Ka4sIamqg75ovSgnpcdrfw2VBQsUZo7uoZga87Fpp2q27oH4Gb
         Qd0A==
X-Gm-Message-State: AOAM530jg8t51zDS52o7npqDMFPDLV5OmuaJGFMt9nAb5bmVzpJUk5gv
        S8Q5iMhQw+6TcvGNcOyAfZeJuMS2U+gLu7cxmFIkpQ==
X-Google-Smtp-Source: ABdhPJwbCAq+lROdobsvSfxS5ilKi5RtnW3rDdKcN5MoX0ol9W11mVMTJX6h9MiMLfOc6jKANvyIVTY4A3Xe3k5UOxs=
X-Received: by 2002:a05:620a:288a:b0:67b:3250:ada2 with SMTP id
 j10-20020a05620a288a00b0067b3250ada2mr8367002qkp.358.1647698264502; Sat, 19
 Mar 2022 06:57:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220319110422.8261-1-zhouzhouyi@gmail.com> <CANn89iK46rw910CUJV3Kgf=M=HA32_ctd0xragwcRnHCV_VhmQ@mail.gmail.com>
 <CAABZP2yK2vCJcReJ_VvcqbkuEekvBpBJCyZ2geG=f83fv_RC=Q@mail.gmail.com>
In-Reply-To: <CAABZP2yK2vCJcReJ_VvcqbkuEekvBpBJCyZ2geG=f83fv_RC=Q@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Sat, 19 Mar 2022 09:57:28 -0400
Message-ID: <CADVnQy=shHKbvf4OZjX5-3CnFPOm3zyexbaH9XTLZBMk6pxeew@mail.gmail.com>
Subject: Re: [PATCH v2] net:ipv4: send an ack when seg.ack > snd.nxt
To:     Zhouyi Zhou <zhouzhouyi@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        David Miller <davem@davemloft.net>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Wei Xu <xuweihf@ustc.edu.cn>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 19, 2022 at 7:34 AM Zhouyi Zhou <zhouzhouyi@gmail.com> wrote:
>
> Thanks for reviewing my patch
>
> On Sat, Mar 19, 2022 at 7:14 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Sat, Mar 19, 2022 at 4:04 AM <zhouzhouyi@gmail.com> wrote:
> > >
> > > From: Zhouyi Zhou <zhouzhouyi@gmail.com>
> > >
> > > In RFC 793, page 72: "If the ACK acks something not yet sent
> > > (SEG.ACK > SND.NXT) then send an ACK, drop the segment,
> > > and return."
> > >
> > > Fix Linux's behavior according to RFC 793.
> > >
> > > Reported-by: Wei Xu <xuweihf@ustc.edu.cn>
> > > Signed-off-by: Wei Xu <xuweihf@ustc.edu.cn>
> > > Signed-off-by: Zhouyi Zhou <zhouzhouyi@gmail.com>
> > > ---
> > > Thank Florian Westphal for pointing out
> > > the potential duplicated ack bug in patch version 1.
> >
> > I am travelling this week, but I think your patch is not necessary and
> > might actually be bad.
> >
> > Please provide more details of why nobody complained of this until today.
> >
> > Also I doubt you actually fully tested this patch, sending a V2 30
> > minutes after V1.
> >
> > If yes, please provide a packetdrill test.
> I am a beginner to TCP, although I have submitted once a patch to
> netdev in 2013 (aaa0c23cb90141309f5076ba5e3bfbd39544b985), this is
> first time I learned packetdrill test.
> I think I should do the packetdrill test in the coming days, and
> provide more details of how this (RFC793 related) can happen.

In addition to a packetdrill test and a more detailed analysis of how
this can happen, and the implications, I think there are at least a
few other issues that need to be considered:

(1) AFAICT, adding an unconditional ACK if (after(ack, tp->snd_nxt))
seems to open the potential for attackers to cause DoS attacks with
something like the following:

 (a) attacker injects one data packet in the A->B direction and one
data packet in the B->A direction

 (b) endpoint A sends an ACK for the forged data sent to it, which
will have an ACK beyond B's snd_nxt

 (c) endpoint B sends an ACK for the forged data sent to it, which
will have an ACK beyond A's snd_nxt

 (d) endpoint B receives the ACK sent by A, causing B to send another
ACK beyond A's snd_nxt

 (e) endpoint A receives the ACK sent by B, causing A to send another
ACK beyond B's snd_nxt

 (f) repeat (d) and (e) ad infinitum

So AFAICT an attacker could send two data packets with 1 byte of data
and cause the two endpoints to use up an unbounded amount of CPU and
bandwidth sending ACKs in an "infinite loop".

To avoid this "infinite loop" of packets, if we really need to add an
ACK in this case then the code should use the tcp_oow_rate_limited()
helper to ensure that such ACKs are rate-limited. For more context on
tcp_oow_rate_limited(), see:

f06535c599354 Merge branch 'tcp_ack_loops'
4fb17a6091674 tcp: mitigate ACK loops for connections as tcp_timewait_sock
f2b2c582e8242 tcp: mitigate ACK loops for connections as tcp_sock
a9b2c06dbef48 tcp: mitigate ACK loops for connections as tcp_request_sock
032ee4236954e tcp: helpers to mitigate ACK loops by rate-limiting
out-of-window dupacks

Note that f06535c599354 in particular mentions the case discussed in this patch:

    (2) RFC 793 (section 3.9, page 72) says: "If the ACK acknowledges
        something not yet sent (SEG.ACK > SND.NXT) then send an ACK".

(2) Please consider the potential that adding a new ACK in this
scenario may introduce new, unanticipated side channels. For more on
side channels, see:

  https://lwn.net/Articles/696868/
  The TCP "challenge ACK" side channel

  Principled Unearthing of TCP Side Channel Vulnerabilities
  https://dl.acm.org/doi/10.1145/3319535.3354250

best regards,
neal
