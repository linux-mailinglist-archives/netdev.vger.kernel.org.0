Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93FA13125F
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfEaQ3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:29:55 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45371 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfEaQ3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 12:29:54 -0400
Received: by mail-wr1-f67.google.com with SMTP id b18so6886178wrq.12
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 09:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=snJ/aiipUWHYAukpTuHmyUR0949JmdgOyqNQh/Ho730=;
        b=OfhF4bDi5CETHDqmFyZssWa0nOfyA7fOFJZw2YnBOjZiP4g6WiTJqK4ufYlQzfe5vv
         xSpZDl+7wSjcGj9GQoydoyV9Qj0SDOQVCbgWuUe4r0D5/TjQ8jSMtGU6UpvaTBI4Txhj
         6cAvjGxPrf7We+FwMvnojvjV/qqklqlsZqhFM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=snJ/aiipUWHYAukpTuHmyUR0949JmdgOyqNQh/Ho730=;
        b=tQTMtNyDlqnHth7wo2T8+Nv94nDF/VNZnWnyHBaLc+8nVw4gKwc4GRIIE/htF2sDvw
         V/Rz2uZAZkMMyIF7ldjC/GZHrPDYLPEYfiQTfmhLPtGV1/yP8KzjhiJkGi01UGX6h6IL
         y45pBwt3pRvdCzQqzSVA9EEAGzH1Hfr8rA+vlWdAevDEEln2h2cs6XZgrIiiRL58ZYcn
         4ylOef5CSSqHTtFo8JwQR2Vv6OqupuWiEWpVuXosJDMOYz5IX43Vf84jzTj3gv1HY+zL
         fl7Bb667dfrJnK1M3Q8NwDSQOlRb9wGpal5ICR02t8GrNp0r8xI41UxcfxHJ+tYucBf7
         6Q6A==
X-Gm-Message-State: APjAAAXaojwdJrmyGzTVYG9bjXx/iCIb3p2eUzgZdTbQ1Rodmm2JDwKO
        dDv525CnIXKHteE1cNpqDxETUw==
X-Google-Smtp-Source: APXvYqx1Gh23iVqRLLkpqHW5D6ewYI5DlftxxfB2CqwbOKHWAFh76m2Z50O2hXeV4EmpkHzDuKvRsQ==
X-Received: by 2002:adf:e909:: with SMTP id f9mr7470430wrm.231.1559320193309;
        Fri, 31 May 2019 09:29:53 -0700 (PDT)
Received: from andrea (86.100.broadband17.iol.cz. [109.80.100.86])
        by smtp.gmail.com with ESMTPSA id b8sm4294059wrr.88.2019.05.31.09.29.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 09:29:52 -0700 (PDT)
Date:   Fri, 31 May 2019 18:29:45 +0200
From:   Andrea Parri <andrea.parri@amarulasolutions.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH] inet: frags: Remove unnecessary
 smp_store_release/READ_ONCE
Message-ID: <20190531162945.GA600@andrea>
References: <20190524160340.169521-12-edumazet@google.com>
 <20190528063403.ukfh37igryq4u2u6@gondor.apana.org.au>
 <CANn89i+NfFLHDthLC-=+vWV6fFSqddVqhnAWE_+mHRD9nQsNyw@mail.gmail.com>
 <20190529054026.fwcyhzt33dshma4h@gondor.apana.org.au>
 <CACT4Y+Y39u9VL+C27PVpfVZbNP_U8yFG35yLy6_KaxK2+Z9Gyw@mail.gmail.com>
 <20190529054759.qrw7h73g62mnbica@gondor.apana.org.au>
 <CACT4Y+ZuHhAwNZ31+W2Hth90qA9mDk7YmZFq49DmjXCUa_gF1g@mail.gmail.com>
 <20190531144549.uiyht5hcy7lfgoge@gondor.apana.org.au>
 <4e2f7f20-5b7f-131f-4d8b-09cfc6e087d4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e2f7f20-5b7f-131f-4d8b-09cfc6e087d4@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 08:45:47AM -0700, Eric Dumazet wrote:
> On 5/31/19 7:45 AM, Herbert Xu wrote:

> > In this case the code doesn't need them because an implicit
> > barrier() (which is *stronger* than READ_ONCE/WRITE_ONCE) already
> > exists in both places.


> I have already explained that the READ_ONCE() was a leftover of the first version
> of the patch, that I refined later, adding correct (and slightly more complex) RCU
> barriers and rules.

AFAICT, neither barrier() nor RCU synchronization can be used as
a replacement for {READ,WRITE}_ONCE() here (and in tons of other
different situations).  IOW, you might want to try harder.  ;-)

Thanks,
  Andrea
