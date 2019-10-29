Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4BAE81D4
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 08:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfJ2HHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 03:07:31 -0400
Received: from mail-40135.protonmail.ch ([185.70.40.135]:18259 "EHLO
        mail-40135.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbfJ2HHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 03:07:31 -0400
Date:   Tue, 29 Oct 2019 07:07:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1572332847;
        bh=lzslNfoQy5A3F9GFrflY74Vht4v+kR9A89ajHdqUSIg=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=fkwvOb/7kIziopeqhY1tj1QMpO4c5biLshgq0ectjit/aD65fK1vrjDz/xjT9CMvn
         glF+6GzHR1tF1UpYfXEGtstt2IAYh8FmiMWwse7aNa5gUC6lMASgb37yML2fqcOpgv
         Df8a4aCoMkrfz6oTrZyhh4Xh1pBnxfer7Oocvxqc=
To:     Alexander Duyck <alexander.duyck@gmail.com>
From:   Ttttabcd <ttttabcd@protonmail.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        Netdev <netdev@vger.kernel.org>,
        "lartc@vger.kernel.org" <lartc@vger.kernel.org>
Reply-To: Ttttabcd <ttttabcd@protonmail.com>
Subject: Re: Commit 0ddcf43d5d4a causes the local table to conflict with the main table
Message-ID: <vQHKO4hEjMsPEg58jVn-H9jQMjxIANbP2DLKgZBdlkgqJHd6p_rMnz-o5QhonUL8cJG_AwXhVwse0e5941mXjN-9LCbtdSVGDYK4OEv3hhM=@protonmail.com>
In-Reply-To: <CAKgT0Uc5Ba3Vno39KqdBRSXGYpyuGHeyef9=CkthoVkWipLS7g@mail.gmail.com>
References: <YWOrt002RdCqkBeUL04N1MVxcsjRvmCb4iqMW67EmAQIG5erLlSntgQWmSYiHXAT8kgFTceURhTaP8dAp9nPD9q3lquhb0MTIRlP4Vy5k3Y=@protonmail.com>
 <CAKgT0Uc5Ba3Vno39KqdBRSXGYpyuGHeyef9=CkthoVkWipLS7g@mail.gmail.com>
Feedback-ID: EvWK9os_-weOBrycfL_HEFp-ixys9sxnciOqqctCHB9kjCM4ip8VR9shOcMQZgeZ7RCnmNC4HYjcUKNMz31NBA==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_REPLYTO
        autolearn=no autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I am dropping all of the above. The fact is commit 0ddcf43d5d4a
> ("ipv4: FIB Local/MAIN table collapse") has been in the kernel for
> over 4 and a half years so hopefully by now most of the network
> developers are aware that the tables are merged, and become unmerged
> when custom rules are added.

First of all, we can't assume that all developers already know this, even i=
f this feature has been added to the kernel for more than 4 years, because =
this does not appear in the "ip route" or "ip rule" man page.

> I would argue that adding routes to the local table is a very "geek"
> thing to do. Normally people aren't going to be adding routes there in
> the first place. Normally routes are added to main as the assumption
> is you are attempting to route traffic out to some external entity.
> The local table normally only consists of the localhost route and a
> set of /32 addresses as I mentioned earlier.

You are right, most people in the world will not do this, I am doing this t=
o test the local route in the transparent proxy.

> I would disagree. There is a significant performance gain to be had
> from this commit. What it is basically doing is taking advantage of
> the fact that normally your local trie is going to consist of /32
> routes and localhost. In the vast majority of cases there will never
> be a clash as you have pointed out.

> If anything what I would suggest, assuming the priority inversion
> issue you have pointed out needs to be addressed, would be to look at
> adding a special case for the addition of non /32 non-localhost routes
> to local so that we could unmerge the table on such an addition. The
> instance of non-/32 routes being added to local has apparently been
> low enough that this hasn't been an issue up until now, and if we are
> wanting to focus on the correctness of the fib lookup then this would
> be the easiest way to sort it out while maintaining both the
> performance and correctness.

If you have done experiments that can bring a lot of performance improvemen=
ts, then please keep the function of merging the main and local tables.

However, please add an explanation of this merge in the man pages of "ip ro=
ute" and "ip rule", and explain that the route table will be re-segmented a=
fter adding the policy route.

As you have described, re-segmenting the local route table when a route oth=
er than /32 is added to the local route table is also a very good solution.=
 This fully complies with the priority of the local table and the main tabl=
e.
