Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1DB216770
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 18:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfEGQG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 12:06:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:39596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726799AbfEGQG5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 12:06:57 -0400
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C92720C01;
        Tue,  7 May 2019 16:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557245215;
        bh=txyb9Y+CIwA4enBc2YCDCF+N4hSkRF7C1dUEQSU+8ps=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=1J42lltBRC2h71CY4Ic717tbQN1Xvz1Ps7lzeZwtLowbxoYAUY6AN0qduLcIc/+y8
         Y8Uu4SXHVXkfeXYxUnhaEuMQc9zLAvpFb3DEcu1j1f5Kv/SmCB7faGdE+CY8WVoU4x
         0TqhJ1TLKpgTARHYQNJgI0Xlhi5lKs2UsXwDEM1U=
Received: by mail-qt1-f173.google.com with SMTP id i31so19618674qti.13;
        Tue, 07 May 2019 09:06:55 -0700 (PDT)
X-Gm-Message-State: APjAAAXMVKItBO4RfUc7Xj8ZUXnF4EKs42v14VM4r4YgeDOEL3YszJyt
        Kv7PYxbSMO/ukspusRxlFdJ/TPwni6i6s4bntg==
X-Google-Smtp-Source: APXvYqzRisZ+NY+n+aLjSLgDhm39bZicoTuSyfmVwu2JgfiQOEZmLX/TkvP/ZUbPjlIhWr/N5rZYuaWBd0G4e1VyjHY=
X-Received: by 2002:aed:2471:: with SMTP id s46mr6955104qtc.144.1557245214590;
 Tue, 07 May 2019 09:06:54 -0700 (PDT)
MIME-Version: 1.0
References: <1556456002-13430-1-git-send-email-ynezz@true.cz>
 <1556456002-13430-2-git-send-email-ynezz@true.cz> <20190501201925.GA15495@bogus>
 <20190502090538.GD346@meh.true.cz>
In-Reply-To: <20190502090538.GD346@meh.true.cz>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 7 May 2019 11:06:43 -0500
X-Gmail-Original-Message-ID: <CAL_JsqKLgEjgDOHaNHbu7Bqw1gYCBMRcdO_S98nASnCxtinZ=g@mail.gmail.com>
Message-ID: <CAL_JsqKLgEjgDOHaNHbu7Bqw1gYCBMRcdO_S98nASnCxtinZ=g@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] of_net: Add NVMEM support to of_get_mac_address
To:     =?UTF-8?Q?Petr_=C5=A0tetiar?= <ynezz@true.cz>
Cc:     netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Alban Bedel <albeu@free.fr>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 2, 2019 at 4:05 AM Petr =C5=A0tetiar <ynezz@true.cz> wrote:
>
> Rob Herring <robh@kernel.org> [2019-05-01 15:19:25]:
>
> Hi Rob,
>
> > > +   struct property *pp;
>
> ...
>
> > > +   pp =3D kzalloc(sizeof(*pp), GFP_KERNEL);
> > > +   if (!pp)
> > > +           return NULL;
> > > +
> > > +   pp->name =3D "nvmem-mac-address";
> > > +   pp->length =3D ETH_ALEN;
> > > +   pp->value =3D kmemdup(mac, ETH_ALEN, GFP_KERNEL);
> > > +   if (!pp->value || of_add_property(np, pp))
> > > +           goto free;
> >
> > Why add this to the DT?
>
> I've just carried it over from v1 ("of_net: add mtd-mac-address support t=
o
> of_get_mac_address()")[1] as nobody objected about this so far.

That's not really a reason...

> Honestly I don't know if it's necessary to have it, but so far address,
> mac-address and local-mac-address properties provide this DT nodes, so I'=
ve
> simply thought, that it would be good to have it for MAC address from NVM=
EM as
> well in order to stay consistent.

If you want to be consistent, then fill in 'local-mac-address' with
the value from nvmem. We don't need the same thing with a new name
added to DT. (TBC, I'm not suggesting you do that here.)

But really, my point with using devm_kzalloc() is just return the
data, not store in DT and free it when the driver unbinds. Allocating
it with devm_kzalloc AND adding it to DT as you've done in v4 leads to
2 entities refcounting the allocation. If the driver unbinds, the
buffer is freed, but DT code is still referencing that memory.

Also, what happens the 2 time a driver binds? The property would
already be in the DT.

>
> Just FYI, my testing ar9331_8dev_carambola2.dts[2] currently produces
> following runtime DT content:
>
>  root@OpenWrt:/# find /sys/firmware/devicetree/ -name *nvmem* -o -name *a=
ddr@*
>  /sys/firmware/devicetree/base/ahb/spi@1f000000/flash@0/partitions/partit=
ion@ff0000/nvmem-cells
>  /sys/firmware/devicetree/base/ahb/spi@1f000000/flash@0/partitions/partit=
ion@ff0000/nvmem-cells/eth-mac-addr@0
>  /sys/firmware/devicetree/base/ahb/spi@1f000000/flash@0/partitions/partit=
ion@ff0000/nvmem-cells/eth-mac-addr@6
>  /sys/firmware/devicetree/base/ahb/spi@1f000000/flash@0/partitions/partit=
ion@ff0000/nvmem-cells/wifi-mac-addr@1002
>  /sys/firmware/devicetree/base/ahb/wmac@18100000/nvmem-cells
>  /sys/firmware/devicetree/base/ahb/wmac@18100000/nvmem-mac-address
>  /sys/firmware/devicetree/base/ahb/wmac@18100000/nvmem-cell-names
>  /sys/firmware/devicetree/base/ahb/eth@1a000000/nvmem-cells
>  /sys/firmware/devicetree/base/ahb/eth@1a000000/nvmem-mac-address
>  /sys/firmware/devicetree/base/ahb/eth@1a000000/nvmem-cell-names
>  /sys/firmware/devicetree/base/ahb/eth@19000000/nvmem-cells
>  /sys/firmware/devicetree/base/ahb/eth@19000000/nvmem-mac-address
>  /sys/firmware/devicetree/base/ahb/eth@19000000/nvmem-cell-names

'nvmem-mac-address' is not a documented property. That would need to
be documented before using upstream. Though, for reasons above, I
don't think it should be.

Rob
