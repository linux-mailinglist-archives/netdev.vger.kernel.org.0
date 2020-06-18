Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8351FF95A
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731820AbgFRQg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 12:36:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726928AbgFRQg2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 12:36:28 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BBE72075E;
        Thu, 18 Jun 2020 16:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592498187;
        bh=c0ESmgnjyT2o2BajemPzFEwP6MSXFqyQkhQ55eBEloU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N9hdCVHC5Zwne19wqnXRF0eJ0oe0YkW8D3Qvs5QuKquIiDgSFZLuDQS86CTBdFP/z
         PnyBiF00nulKYTRyg5kQtZICXvt9Y6DiChq5X+Q/I0/RbChLyqUWv8Z4bwvBUlDNI1
         kFUGItxiW2/DEXLIrPUe1V/Nh2RVCFf3OoZ+BjIA=
Date:   Thu, 18 Jun 2020 09:36:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH net] selftests/net: report etf errors correctly
Message-ID: <20200618093625.0bb5ac61@kicinski-fedora-PC1C0HJN>
In-Reply-To: <CA+FuTSeLneTOB10Vd+wO2LFmU9eY_zQJJ0QvX7JbCW9C1ef=ew@mail.gmail.com>
References: <20200618145549.37937-1-willemdebruijn.kernel@gmail.com>
        <20200618085416.48b44e51@kicinski-fedora-PC1C0HJN>
        <CA+FuTSeLneTOB10Vd+wO2LFmU9eY_zQJJ0QvX7JbCW9C1ef=ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Jun 2020 12:18:01 -0400 Willem de Bruijn wrote:
> On Thu, Jun 18, 2020 at 11:54 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu, 18 Jun 2020 10:55:49 -0400 Willem de Bruijn wrote:  
> > > +             switch (err->ee_errno) {
> > > +             case ECANCELED:
> > > +                     if (err->ee_code != SO_EE_CODE_TXTIME_MISSED)
> > > +                             error(1, 0, "errqueue: unknown ECANCELED %u\n",
> > > +                                         err->ee_code);
> > > +                     reason = "missed txtime";
> > > +             break;
> > > +             case EINVAL:
> > > +                     if (err->ee_code != SO_EE_CODE_TXTIME_INVALID_PARAM)
> > > +                             error(1, 0, "errqueue: unknown EINVAL %u\n",
> > > +                                         err->ee_code);
> > > +                     reason = "invalid txtime";
> > > +             break;
> > > +             default:
> > > +                     error(1, 0, "errqueue: errno %u code %u\n",
> > > +                           err->ee_errno, err->ee_code);
> > > +             };
> > >
> > >               tstamp = ((int64_t) err->ee_data) << 32 | err->ee_info;
> > >               tstamp -= (int64_t) glob_tstart;
> > >               tstamp /= 1000 * 1000;
> > > -             fprintf(stderr, "send: pkt %c at %" PRId64 "ms dropped\n",
> > > -                             data[ret - 1], tstamp);
> > > +             fprintf(stderr, "send: pkt %c at %" PRId64 "ms dropped: %s\n",
> > > +                             data[ret - 1], tstamp, reason);  
> >
> > Hi Willem! Checkpatch is grumpy about some misalignment here:
> >
> > CHECK: Alignment should match open parenthesis
> > #67: FILE: tools/testing/selftests/net/so_txtime.c:187:
> > +                               error(1, 0, "errqueue: unknown ECANCELED %u\n",
> > +                                           err->ee_code);
> >
> > CHECK: Alignment should match open parenthesis
> > #73: FILE: tools/testing/selftests/net/so_txtime.c:193:
> > +                               error(1, 0, "errqueue: unknown EINVAL %u\n",
> > +                                           err->ee_code);
> >
> > CHECK: Alignment should match open parenthesis
> > #87: FILE: tools/testing/selftests/net/so_txtime.c:205:
> > +               fprintf(stderr, "send: pkt %c at %" PRId64 "ms dropped: %s\n",
> > +                               data[ret - 1], tstamp, reason);  
> 
> Thanks for the heads-up, Jakub.
> 
> I decided to follow the convention in the file, which is to align with
> the start of the string.

Ack, I remember the selftest was added with a larger series so I didn't
want to complain about minutia :)

> Given that, do you want me to resubmit with the revised offset? I'm
> fine either way, of course.

No strong feelings, perhaps it's fine if the rest of the file is
like that already.

> Also, which incantation of checkpatch do you use? I did run
> checkpatch, without extra args, and it did not warn me about this.

I run with --strict, and pick the warnings which make sense.
