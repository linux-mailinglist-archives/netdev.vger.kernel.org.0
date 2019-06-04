Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5720834ECC
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfFDRaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:30:08 -0400
Received: from mail-lf1-f42.google.com ([209.85.167.42]:45175 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbfFDRaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:30:07 -0400
Received: by mail-lf1-f42.google.com with SMTP id u10so10030933lfm.12
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 10:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oxau3u5QK4TvlKE/fTKEZope6FWr7Z8C5aaECU4mUHM=;
        b=NTeprb30chfrVf7/Ou53/FdAiV+JXX/NTlL7fhuusJ0hOtlpY/hzAIsG+bdU0fIR5J
         1WhsMxHwVhcM4jNa0vk7Tpa2CKyGTcKUtwg3I/YhA9e+jp1pprGc40A4sjea1En0Ef/2
         Ma76LXYNh8GIRO/VLPkLQNIohpp+r0s9lXXek=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oxau3u5QK4TvlKE/fTKEZope6FWr7Z8C5aaECU4mUHM=;
        b=DalDBkRPzXTTfNdEr1SVcBxMkPVobcDtmtrJqeuyhFz/ZqAEZGeqqh/YW5qEGnu3se
         qmg1mRVGGcSG+1frDM+mmmWqWuRd+XoHsku+LceMUzVjVd5cK86MWulJO4tadFrBDjYP
         83jxsevZAlQgZu1i2OI1n/ZUDCUshD2LmAWayE7FlH7u5HXGiVU+pW4tl+thROiXZCpm
         AhvehCAmiuVIPbCqB7IEs3WE1ir8QNyfv2AoHz0A9AEHgb2tcXbRrkHieI5Ln4j0awyo
         E3SRPN65SBWrW0VOmzW6qBAinMezg6Ekm7Cx6Y7oV8uFW6r4nXe82+f81ax4rjNdP8e6
         Rl9w==
X-Gm-Message-State: APjAAAVOwXVxOEaQXL2MXLQHr6Nu95tZ1KScVnwB3h5StCi2xc8cUzUs
        0JJlQVD+3r7FqmYXCFMeUt1UK9FTETU=
X-Google-Smtp-Source: APXvYqz4S44wYIxHbcHQ526R29yhGBYXItJ5b1D78QJLX8VkCCfOqJXnpxjDZ2SH81vrySJTsjpkUA==
X-Received: by 2002:ac2:4156:: with SMTP id c22mr16884438lfi.12.1559669405654;
        Tue, 04 Jun 2019 10:30:05 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id q22sm1927274lje.75.2019.06.04.10.30.02
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:30:02 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id v29so9225926ljv.0
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 10:30:02 -0700 (PDT)
X-Received: by 2002:a2e:635d:: with SMTP id x90mr7932259ljb.140.1559669401822;
 Tue, 04 Jun 2019 10:30:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wgGnCw==uY8radrB+Tg_CEmzOtwzyjfMkuh7JmqFh+jzQ@mail.gmail.com>
 <Pine.LNX.4.44L0.1906041251210.1731-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1906041251210.1731-100000@iolanthe.rowland.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 4 Jun 2019 10:29:45 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjJdffKFrZUZny=N=Yt91_9En6d+nbHF2NXKeopM3TC+A@mail.gmail.com>
Message-ID: <CAHk-=wjJdffKFrZUZny=N=Yt91_9En6d+nbHF2NXKeopM3TC+A@mail.gmail.com>
Subject: Re: rcu_read_lock lost its compiler barrier
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        Luc Maranget <luc.maranget@inria.fr>,
        Jade Alglave <j.alglave@ucl.ac.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 4, 2019 at 10:00 AM Alan Stern <stern@rowland.harvard.edu> wrote:
>
> Which suggests asking whether these higher expectations should be
> reflected in the Linux Kernel Memory Model.  So far we have largely
> avoided doing that sort of thing, although there are a few exceptions.

I think they might be hard to describe - which in turn may be why the
standard leaves it open and only describes the simple cases.

Exactly that "we expect an assignment to be done as a single write" is
probably a good example. Yes, we do have that expectation for the
simple cases. But it's not an absolute rule, obviously, because it's
clearly violated by bitfield writes, and similarly it's obviously
violated for data that is bigger than the word size (ie a "u64"
assignment is obviously not a single write when you're on a 32-bit
target).

And while those cases are static and could be described separately,
the "oh, and we have _other_ accesses to the same variable nearby, and
we expect that the compiler might take those into account unless we
explicitly use WRITE_ONCE()" things make for much more hard to
describe issues.

Doing writes with speculative values is clearly bogus and garbage
(although compiler writers _have_ tried to do that too: "we then
overwrite it with the right value later, so it's ok"), and thankfully
even user space people complain about that due to threading and
signals. But eliding writes entirely by combining them with a later
one is clearly ok - and eliding them when there was an explcit earlier
read and value comparison (like in my example) sounds reasonable to me
too. Yet silently adding the elision that wasn't visible in the source
due to other accesses would be bad.

How do you say "sane and reasonable compiler" in a spec? You usually
don't - or  you make the rules so odd and complex than nobody really
understands them any more, and make it all moot ;)

                 Linus
