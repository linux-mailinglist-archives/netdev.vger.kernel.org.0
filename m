Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4594C20A5E5
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 21:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406468AbgFYTdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 15:33:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406116AbgFYTdK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 15:33:10 -0400
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0866220789;
        Thu, 25 Jun 2020 19:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593113590;
        bh=31Jpzoy5KajH8d9KdIP0kvSKP8VhfSqpxdYUFnOcTgk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=2HR/eBlpOoLWIlQ9phxxOpxbeIrkrf0rYBhzJw4Hd3H8wuH27zg2QbdO0y1NO37h6
         af13N+6CSnMrCFw4ohBtr5TJkJZZbpWa5WDbqeIk8YlVpjHVhn7216cNS41MATDc+1
         4V2NG82voh2OVT7B7N9248GoBTRIwmPjCHGGzbOw=
Received: by mail-oi1-f179.google.com with SMTP id h17so6009681oie.3;
        Thu, 25 Jun 2020 12:33:10 -0700 (PDT)
X-Gm-Message-State: AOAM5312NcjWtOgMTyEMopQ14bFHIiBF9EKhBCGg53/3cXkPfww+Pj3O
        p7RaaT168qWuboExpyuZmYYmYrkFUA0fTR8s/jQ=
X-Google-Smtp-Source: ABdhPJz3TuP2pVf3t2gzv49tcXAtlLVWQ7gNgGFM7drpUv84FtB0V1dReRPn4yxmFRmByhMVPA0mvBqvpw7jYH3KWvA=
X-Received: by 2002:aca:ba03:: with SMTP id k3mr3646839oif.33.1593113589409;
 Thu, 25 Jun 2020 12:33:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200625071816.1739528-1-ardb@kernel.org> <20200625.121605.1198833456036514480.davem@davemloft.net>
In-Reply-To: <20200625.121605.1198833456036514480.davem@davemloft.net>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 25 Jun 2020 21:32:57 +0200
X-Gmail-Original-Message-ID: <CAMj1kXG5MqCPJ3zG4P0NNzDC9qzwwCSOw09Bgi+SYm_0YFhmFg@mail.gmail.com>
Message-ID: <CAMj1kXG5MqCPJ3zG4P0NNzDC9qzwwCSOw09Bgi+SYm_0YFhmFg@mail.gmail.com>
Subject: Re: [PATCH v2] net: phy: mscc: avoid skcipher API for single block
 AES encryption
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jun 2020 at 21:16, David Miller <davem@davemloft.net> wrote:
>
> From: Ard Biesheuvel <ardb@kernel.org>
> Date: Thu, 25 Jun 2020 09:18:16 +0200
>
> > The skcipher API dynamically instantiates the transformation object
> > on request that implements the requested algorithm optimally on the
> > given platform. This notion of optimality only matters for cases like
> > bulk network or disk encryption, where performance can be a bottleneck,
> > or in cases where the algorithm itself is not known at compile time.
> >
> > In the mscc case, we are dealing with AES encryption of a single
> > block, and so neither concern applies, and we are better off using
> > the AES library interface, which is lightweight and safe for this
> > kind of use.
> >
> > Note that the scatterlist API does not permit references to buffers
> > that are located on the stack, so the existing code is incorrect in
> > any case, but avoiding the skcipher and scatterlist APIs entirely is
> > the most straight-forward approach to fixing this.
> >
> > Fixes: 28c5107aa904e ("net: phy: mscc: macsec support")
> > Reviewed-by: Eric Biggers <ebiggers@google.com>
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>
> Applied and queued up for -stable, thanks.
>
> Please never CC: stable for networking changes, I handle the submissions
> by hand.
>

Noted, thanks.
