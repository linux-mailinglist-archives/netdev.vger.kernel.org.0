Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24447494C8
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbfFQWJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:09:16 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:33679 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727633AbfFQWJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 18:09:16 -0400
Received: by mail-yb1-f194.google.com with SMTP id h17so5179389ybm.0
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 15:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VUedwG7q1HcxF8RaUiGfQxLHb9vHac7c8/AVVop+fYE=;
        b=uQLU12ABbnpYpgy9TCYXPsolDveLu2bvjkOPQXDYHYnXFT5QTU9RJbmO7SA8fMrvY4
         cbLbLNwbquAARFhXLOwbJMFWrRDPoBazAOZCr/dNUoxQbiIh73EdSpcQFQTNX5QKLBfn
         SMUonM8cCIWGbYi6HqwhPAIipIXRzYmNiwLhWrdX4xlKpMrmGtvXhvupoGZGSO0mfUtd
         i2v+Sdyzytejl0gYm+PqLK74JQfXnL8w/soK2zNkIEDjeCbnMhdYdoOuoyuaTWARe67N
         kFLpzwH9ndAilHs/esgztLn/02cECoA/Lct+X3lMVlceom1bTOT45bLiuhHj4tSFf2at
         fWNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VUedwG7q1HcxF8RaUiGfQxLHb9vHac7c8/AVVop+fYE=;
        b=NdHniYL6Y+Uslyz25+1FUOvhJn+gpNNm/WA2Z2KBukzAwBaMmBDCPnf+LTGGxYZ3KG
         Twfbc4ZjZHas095mzVbpkrCkWYT9J+68U+K3I6KtlOPFoe+wQ6tbc2D1sVpwiwtXfqh+
         HcZbIHOu/Q9FqcD2skvcVqz9fSxV4jVGEW5sw2pCG0NfHj4cbcjZQ2XIZ3KDPS8PLK2P
         7JF5DnSYf3GsuXEoHIxbA3X2FWOx02n8Z/CfJm3WbclaSsxTTwzDKQYZEcnBxsrkMmYN
         vlAU0RmN4MtsbsDZTk/pbloxLbvpk7HjCUWA997ViWdiVM1H14GrbvR5+9NDQQ2bh4jm
         5gjA==
X-Gm-Message-State: APjAAAVgQRcWf2hKoWLOT2DmtGIowJzEtWjH25Sssx1v9KdN8TkXBYrs
        80wbRbpmM4QdnFBD7Euo/MMtQXXQIiikBX+Q+nC5tA==
X-Google-Smtp-Source: APXvYqwziMEAxQCXH78EJr9kr/kMAcBobQUNpI30yZoNqr0Z7+/0VaKwrz4dYQvEzjvq+w1R8vLCo9zxMRxuOgzChZU=
X-Received: by 2002:a5b:c01:: with SMTP id f1mr55916841ybq.518.1560809355108;
 Mon, 17 Jun 2019 15:09:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190617080933.32152-1-ard.biesheuvel@linaro.org>
 <e1c4c9b6-3668-106a-69ef-7ef6c016a5f6@gmail.com> <20190617.135712.1886619234506210997.davem@davemloft.net>
In-Reply-To: <20190617.135712.1886619234506210997.davem@davemloft.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 17 Jun 2019 15:09:03 -0700
Message-ID: <CANn89iJnJchyZr9LSjQT4+MB9nQ88-RFoAGZg8Ugg8NVX=b5Gw@mail.gmail.com>
Subject: Re: [PATCH v3] net: ipv4: move tcp_fastopen server side code to
 SipHash library
To:     David Miller <davem@davemloft.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        netdev <netdev@vger.kernel.org>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, ebiggers@kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jason Baron <jbaron@akamai.com>,
        Christoph Paasch <cpaasch@apple.com>,
        David Laight <David.Laight@aculab.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 1:57 PM David Miller <davem@davemloft.net> wrote:
>
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Mon, 17 Jun 2019 10:00:28 -0700
>
> > All our fastopen packetdrill tests pass (after I changed all the cookie values in them)
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
>
> I'm going to apply this to net-next, I want it to sit there for a
> while.

Yes, the patch only applies cleanly on net-next anyway :)

Thanks.
