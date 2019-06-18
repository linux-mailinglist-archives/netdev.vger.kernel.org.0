Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78618497DC
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 05:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbfFRDyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 23:54:10 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39418 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfFRDyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 23:54:09 -0400
Received: by mail-pl1-f196.google.com with SMTP id b7so5102104pls.6
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 20:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ztkLyoGRVUqRESWqX1aCWG0UYS2XqmIT8N4VCvREBig=;
        b=MzY6coiNcfeQdrIPDCDdU/uehfathmTsVS8KWnMyfPLl49iuwvXRZEyT8ZbIlVRGdA
         ei96kDYNIaM8vinqmU73hH9dDEKPMvzL366nrMyARgrW/dWcuRIxzS6/NPnK7+0zWeaU
         tfsM7WRjBlNQ2lZUDZwAEUhQQACDd8VumyJB1bhAcKQfCOZn4Jjpsl2WD06Bl/cnTLrk
         DfurbDfj8eUe4RrpXFX8Tvu2MW3TZbQi0BE5ANGkojtllaCUkqxbfEoe5/117AAMORcx
         Uc5E9AELzB/oeaksLeak56GUBHdBSr4/XKS4iydf07qRWpqaHga+2g5ijpbdrMoJtiNg
         LhzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ztkLyoGRVUqRESWqX1aCWG0UYS2XqmIT8N4VCvREBig=;
        b=hOA0xRTRnlvI8Lht90vkKdRVZ0As+nRqKDM5XVKkndrlSJwbe4y45QrTPiJnGTs6Pk
         tq2WtkuBJyDUZB9rxDjviJbsUj70kNQ/6dMIyy2FqXzWA6b3KvEsjKj7crp4j380hNOa
         +pKs8kjz22PT4U3SdMtBBjWdjziPcPd1D8nreIpNrSzCdVehQ576oPfi2Fr4iIsKWs9G
         7/tBwXijYfkmmkukbfootrfEPc7mY2cvWfTKQAV0/MVSGeLY6wztjQZ538SObBFkjugz
         z5gAZuDFewfaOzRtRQ36HA9/h29OcxBH++xnS/TjGScRWgP57Yk+j9jSbnVxh30N4WDo
         ycsg==
X-Gm-Message-State: APjAAAWsh/9R17vd5QNmBEg8lC46y+DUxiM8tlDqyKFLE2ks41g4NhEs
        oOOJUHRrW6ggWRtV2gS5+VeCjPz2lY4QHazu0Io=
X-Google-Smtp-Source: APXvYqx4k3bWWZbXF3P9VJmjoVNrGqrUOfS3Vz9ypC2cp6A/5DLfUKzIuZe4akQJ80iBQ7qPiUl5meOiDqJPWFFC4Ys=
X-Received: by 2002:a17:902:9897:: with SMTP id s23mr44338978plp.47.1560830048996;
 Mon, 17 Jun 2019 20:54:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190617170354.37770-1-edumazet@google.com> <20190617170354.37770-3-edumazet@google.com>
 <CALMXkpYVRxgeqarp4gnmX7GqYh1sWOAt6UaRFqYBOaaNFfZ5sw@mail.gmail.com>
 <03cbcfdf-58a4-dbca-45b1-8b17f229fa1d@gmail.com> <CALMXkpZ4isoXpFp_5=nVUcWrt5TofYVhpdAjv7LkCH7RFW1tYw@mail.gmail.com>
 <aa0af451-5e7c-7d83-ef25-095a67cd23a1@gmail.com>
In-Reply-To: <aa0af451-5e7c-7d83-ef25-095a67cd23a1@gmail.com>
From:   Christoph Paasch <christoph.paasch@gmail.com>
Date:   Mon, 17 Jun 2019 20:53:58 -0700
Message-ID: <CALMXkpYs8KN0DmXV+37grbS0Y4Q-DAM-_GVZy+qWi2dtV+cDPA@mail.gmail.com>
Subject: Re: [PATCH net 2/4] tcp: tcp_fragment() should apply sane memory limits
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Looney <jtl@netflix.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Yuchung Cheng <ycheng@google.com>,
        Bruce Curtis <brucec@netflix.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dustin Marquess <dmarquess@apple.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 8:44 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 6/17/19 8:19 PM, Christoph Paasch wrote:
> >
> > Yes, this does the trick for my packetdrill-test.
> >
> > I wonder, is there a way we could end up in a situation where we can't
> > retransmit anymore?
> > For example, sk_wmem_queued has grown so much that the new test fails.
> > Then, if we legitimately need to fragment in __tcp_retransmit_skb() we
> > won't be able to do so. So we will never retransmit. And if no ACK
> > comes back in to make some room we are stuck, no?
>
> Well, RTO will eventually fire.

But even the RTO would have to go through __tcp_retransmit_skb(), and
let's say the MTU of the interface changed and thus we need to
fragment. tcp_fragment() would keep on failing then, no? Sure,
eventually we will ETIMEOUT but that's a long way to go.

> Really TCP can not work well with tiny sndbuf limits.
>
> There is really no point trying to be nice.

Sure, fair enough :-)


Christoph

>
> There is precedent in TCP stack where we always allow one packet in RX or TX queue
> even with tiny rcv/sndbuf limits (or global memory pressure)
>
> We only need to make sure to allow having at least one packet in rtx queue as well.
