Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4B75A8825
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 23:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbiHaVbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 17:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbiHaVbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 17:31:44 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4ABD7D23
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 14:31:42 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1661981500; bh=XN7Z4fABDivGI+T00B5f31YahtTRj3uHxK13bdVKafg=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=L8Ob7NIKlqS0fvPzBTcnWXCPR8pm6gnY6omxkbIIh1FpWQJuSnXZTFSMhWsynvzzP
         mCdibWmf1bZAvm1Bv2bP6F83iGACt3a3DQT2uAmZ9jgHcd9vi8QKDRze/n4XmQxD71
         L2MIsezqYqccvJLONpc8p+wVXueNBhmdcUt5UItjLKXbiqQ1I52wZmaIR2Pq22xobN
         +4w9ub8TfBke3+hUNyxYCZDMRz3KX7p48OtlGm8qG+WacY+16PkZeNb+hZty3m1zS9
         ELr/jksm9lXNQG0glCT/DW1c6uw3FA4/GdLIaWwMk1kz8dAbL8EhVKveMQ+l6rTcmU
         59hNXuewFpmeA==
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, cake@lists.bufferbloat.net,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net] sch_cake: Return __NET_XMIT_STOLEN when consuming
 enqueued skb
In-Reply-To: <CANn89iKiJ91D7fELw9iKB4yCLaDj-WEv27wRS4PtLqM7oK8m=w@mail.gmail.com>
References: <20220831092103.442868-1-toke@toke.dk>
 <CANn89iKiJ91D7fELw9iKB4yCLaDj-WEv27wRS4PtLqM7oK8m=w@mail.gmail.com>
Date:   Wed, 31 Aug 2022 23:31:38 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <875yi83xs5.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <edumazet@google.com> writes:

> On Wed, Aug 31, 2022 at 2:25 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@to=
ke.dk> wrote:
>>
>> When the GSO splitting feature of sch_cake is enabled, GSO superpackets
>> will be broken up and the resulting segments enqueued in place of the
>> original skb. In this case, CAKE calls consume_skb() on the original skb,
>> but still returns NET_XMIT_SUCCESS. This can confuse parent qdiscs into
>> assuming the original skb still exists, when it really has been freed. F=
ix
>> this by adding the __NET_XMIT_STOLEN flag to the return value in this ca=
se.
>>
>
> I think you forgot to give credits to the team who discovered this issue.
>
> Something like this
>
> Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-18231

Ah, right; apologies, will respin!

It also looks like fixing it this way will actually break other things
(most notably sch_cake as a child of sch_htb), so will send a different
patch as v2...

-Toke
