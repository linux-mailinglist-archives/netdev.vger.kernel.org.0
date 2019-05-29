Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 362402D5F2
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 09:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbfE2HKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 03:10:31 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41971 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfE2HKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 03:10:31 -0400
Received: by mail-lj1-f194.google.com with SMTP id q16so1325384ljj.8
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 00:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oCm8Y9CgNepG6g0PNIAXw/Q9kiFx+mN3iMtsmm7yvVg=;
        b=Ze7/wIfMtB0W9w3oHLnb9BeoHj43htO/5DUZctKg18hVyw0vt9WaVfEi77vaNwJfeo
         xkF73hnch6Zw8ZFVysrZIKJYBYETsQGQ7IcSWXFAqI5UBsNCS3viCeWfR2ZAWXDWDDN7
         3okZ0356qaFOVFxJYF2syP2z3i4aGtRItM7kA/3hx1UcUaMTrLoxfUX+T31jNsKMMgQe
         hNmWTe8ay2acIc9Q7m287TxgjaQH2v7iOg1neoCKnFLTS5lnmQsk5XT950jV2ceCeKQn
         K0e5w3qOco2Zgz2iAfwjyDKN++KAt3hmjNioOleFl+fRJ99D54yKJoqhTseL5KAfttIB
         fRww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oCm8Y9CgNepG6g0PNIAXw/Q9kiFx+mN3iMtsmm7yvVg=;
        b=X28luB7AZ5/dcH5qE2mFf1t9mRSqRXoSG2SeBLjnmArZRtY/bovh0h2wo2kYPCsyrN
         TA5dGWQW85Dp3UdUOZj6OOY3gVZ8ADnOyA3S1eb36DqBt0qctMwuXfU2jIsPnKOUckEX
         6Eq0MTJIRExTEAIMQsHxZEpNmNezd4z/1HcunbJDr4CVVu1mDXo3zSUspd/g7oCH+B5J
         gPgd8FjjDYKl67m3pdteR1Fch2IUKBF/NeoovD3g7VaOuGQWASb0et79Geov0aBDg6NJ
         P9HHi1BKht5VAbNdmWhFDyMK1pRaK9QA0ZCGztSq7ja6cJ5SO1i4AwaLA99H/iokMbgO
         QHDA==
X-Gm-Message-State: APjAAAUlDxNTP/ZkEQ2/8b16FsR976BZNcEjeFyz+O3HAA8fxAdHAFWC
        v520PqkN3G7EU5OebYRXZOWiBt/aUnODeW4NSjwivg==
X-Google-Smtp-Source: APXvYqyYeffPdKPqzgRR3g7SFdkixCN5zZGPhLa2YhyNbgZD1U10WGpljM2CffnFXUNWo4Awt0X+4uvwpBx00IFle1g=
X-Received: by 2002:a2e:a0ca:: with SMTP id f10mr527152ljm.113.1559113829244;
 Wed, 29 May 2019 00:10:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190524162023.9115-1-linus.walleij@linaro.org>
 <20190524162023.9115-2-linus.walleij@linaro.org> <20190524194636.GN21208@lunn.ch>
In-Reply-To: <20190524194636.GN21208@lunn.ch>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 29 May 2019 09:10:17 +0200
Message-ID: <CACRpkdaqm3qhHmymOTn_KqrspQzMT85y8c14cda724edUqxAWw@mail.gmail.com>
Subject: Re: [PATCH 1/8] net: ethernet: ixp4xx: Standard module init
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof Halasa <khalasa@piap.pl>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 9:46 PM Andrew Lunn <andrew@lunn.ch> wrote:

> What is the address space like? Could the mdio driver be pull out into
> a standalone driver?

The IXP4xx actually has a peculiar structure.

Both the MDIO and ethernet goes out through the NPE (network
processing engine) and MDIO in particular is just talking to some
mailbox on the NPE. The ethernet has dedicated registers but appear
as dependent on the NPE.

Only NPE B (second) has MDIO.

I guess I should try to make the MDIO a child of the NPE.
I try to improve the legacy code little by little.

Yours,
Linus Walleij
