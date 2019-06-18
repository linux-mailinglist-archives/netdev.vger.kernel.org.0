Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD614AB93
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 22:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730560AbfFRUWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 16:22:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729961AbfFRUWv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 16:22:51 -0400
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3FB521479;
        Tue, 18 Jun 2019 20:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560889370;
        bh=wxfkFUvlWwSzclJIifv04kWQfo423I3PSoSFued6BFE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rQnmLx4oyLJFzI2gHXYZzEZ+dyifC/qB1Z/Z6A3eL09zfcZvlAgQDpmv48INK3DTl
         HravmwwoY2CzeLr9Yi2mwo53TfQy7n7QV14K1hgad85qYd0j8zhAz/rPYNUK6tHm4H
         aGq/JVZNVvLYSeGFQmYe/uez4rl2P7vzWOL3YhKQ=
Received: by mail-qt1-f169.google.com with SMTP id w17so10674016qto.10;
        Tue, 18 Jun 2019 13:22:49 -0700 (PDT)
X-Gm-Message-State: APjAAAUgfZ9O/i5N02LqW1GNfjoAdLeg8k0UNCd1T9i6LORT+hM+kLk6
        BeI078isJmrMn52BDFWvG1JJ+iVjSDTKZbDVOg==
X-Google-Smtp-Source: APXvYqyaYZdyU75vrLYz7F8KjcRIk4qbW7GNvaf0PzyOfAyduE/UQs47mo5PrsLrH1gZEyRv1TI7g3FSh5Ik+wsow4w=
X-Received: by 2002:ac8:3908:: with SMTP id s8mr100915416qtb.224.1560889369080;
 Tue, 18 Jun 2019 13:22:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190524162229.9185-1-linus.walleij@linaro.org>
 <CAL_Jsq+bZsJ+SBiJa2hzXU9RkTNBhDk_Uv_Fk6V6DqRGh-xPRg@mail.gmail.com> <CACRpkdbkwTtS2ofpxkZLERW-b+4=d7m9qiPXGT+iMemn9zZE1A@mail.gmail.com>
In-Reply-To: <CACRpkdbkwTtS2ofpxkZLERW-b+4=d7m9qiPXGT+iMemn9zZE1A@mail.gmail.com>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 18 Jun 2019 14:22:36 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+qwmA1hHRj73B1uf0WY76waK7M96Ndj1RSKHuAi1v=Cw@mail.gmail.com>
Message-ID: <CAL_Jsq+qwmA1hHRj73B1uf0WY76waK7M96Ndj1RSKHuAi1v=Cw@mail.gmail.com>
Subject: Re: [PATCH 7/8] net: ethernet: ixp4xx: Add DT bindings
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof Halasa <khalasa@piap.pl>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 1:44 PM Linus Walleij <linus.walleij@linaro.org> wrote:
>
> On Fri, May 24, 2019 at 9:41 PM Rob Herring <robh@kernel.org> wrote:
>
> > > +  reg:
> > > +    maxItems: 1
> > > +    description: Ethernet MMIO address range
> > > +
> > > +  queue-rx:
> > > +    $ref: '/schemas/types.yaml#/definitions/phandle-array'
> > > +    maxItems: 1
> >
> > This doesn't actually do what you think it is doing. A $ref plus
> > additional constraints need to be under an 'allOf' list.
> >
> > > +    description: phandle to the RX queue on the NPE
> >
> > But this is a phandle plus 1 cell, right?
> >
> > - allOf:
> >     - $ref: '/schemas/types.yaml#/definitions/phandle-array'
> >     - items:
> >         - items:
> >             - description: phandle to the RX queue on the NPE
> >             - description: whatever the cell contains
> >               enum: [ 1, 2, 3, 4 ] # any constraints you can put on the cell
> >
> > This implicitly says you have 1 of a phandle + 1 cell.
> >
> > I need to add this to example-schema.yaml...
>
> I just can't get this right :(
>
> I have this:
>
>   queue-rx:
>     - allOf:

Properties take a schema/object/dict or boolean. You are making
queue-rx a list. Drop the '-'.

>       - $ref: '/schemas/types.yaml#/definitions/phandle-array'
>       - items:
>         - items:
>           - description: phandle to the RX queue on the NPE
>           - description: index of the NPE engine RX queue to use
>             enum: [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]
>
> I get this from dt_binding_check:
>
>   CHKDT   Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml
> Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml:
> properties:queue-rx: [{'allOf': [{'$ref':
> '/schemas/types.yaml#/definitions/phandle-array'}, {'items':
> [{'items': [{'description': 'phandle to the RX queue on the NPE'},
> {'description': 'index of the NPE engine RX queue to use', 'enum': [0,
> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]}]}]}]}] is not of type 'object',
> 'boolean'
> make[3]: *** [../Documentation/devicetree/bindings/Makefile:12:
> Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.example.dts]
> Error 1
>
> Hm .... I just can't figure out what this recursive parsing thingie means...
> I tried to update the pip3 repo but no cigar.

What do you mean pip didn't work?

Rob
