Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD6E112D81
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 15:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbfLDOeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 09:34:21 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49630 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727867AbfLDOeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 09:34:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575470060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mk6kH1hrBfI30rN/qWP90ibSmIBKwHNx6LbIwV0P+6o=;
        b=aB2G8w9i/ueZ8itV18wcCU1UOlvVX48p+m7uErRM1lofwPciF3SwnO44h6ZaVNTNZ0Pcmc
        Tsacz5n6x4BAaYnta/YKWyp+vSbB+XLrniwrjzQTCBkuEcrMmy8ifB4Nnkp+upYmVVVFjA
        kM1w5l1eRntFgdg0sUquSI/Lripr32w=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-kBMlleM3NP6pCU5ioJtsOw-1; Wed, 04 Dec 2019 09:34:18 -0500
Received: by mail-wm1-f72.google.com with SMTP id v8so2264921wml.4
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 06:34:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3fSpOmCmX5dHOVhu+rXkU7ZnFijnP9eH/etXf1iQhw0=;
        b=ooS52vK/LvVYqooAjm14xSpsX1QJe7uXdW1TSk87eTm9Z+gk6WZsPyFmvO5Fwk/mdm
         3dOcu5F8S91qbnNmtHbPCzehQTnTAhDQPAtMzI7c9vV4jgiCR5w+0oi/BNzqWcczta7U
         Z3smLVV3zjYtD3zNNPIOPnYzGOVlNUoBElluCr+Spuy1mq6UlswhHM9RlJZuDsLs4QPc
         OM/5jayt9UaGJED/koWjrkmJGijYjhHkwyagHUqjgqmJSfBCJjVofQGiQv6+nwYNkYcz
         Ajm2cYyWsxqljNzk4nYluouSZiE6Xfv8Mczk1wyl/STTuqlSCVLkoKyuGKSySqTISEwy
         zfnQ==
X-Gm-Message-State: APjAAAUUvzM+KEWVW7/9Ph2zuMepUPDobZp+XY8sx/BVau85247eR3SA
        Jz95jpxlLhxlDCIYDn22w8ixYHU/VfpMuKeu/68qr4G+/EvxDMWtnF4C5x16hr5ZGBl1EfB5ptL
        7Bsw0irWj26GTaCeD
X-Received: by 2002:a05:600c:224d:: with SMTP id a13mr7808511wmm.57.1575470057538;
        Wed, 04 Dec 2019 06:34:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqztrMqtygceCIJ/mpmpHOSprnkgWbjd4MJh4PGOIX2aolJ19K19vLDChPBOznCRdBOYlJXycw==
X-Received: by 2002:a05:600c:224d:: with SMTP id a13mr7808493wmm.57.1575470057376;
        Wed, 04 Dec 2019 06:34:17 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id c1sm8333663wrs.24.2019.12.04.06.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 06:34:16 -0800 (PST)
Date:   Wed, 4 Dec 2019 15:34:14 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev <netdev@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH net] tcp: Avoid time_after32() underflow when handling
 syncookies
Message-ID: <20191204143414.GA2358@linux.home>
References: <2601e43617d707a28f60f2fe6927b1aaaa0a37f8.1574976866.git.gnault@redhat.com>
 <CANn89i+G0jCU=JtSit3X9w+SaExgbbo-d1x4UEkTEJRdypN3gQ@mail.gmail.com>
 <20191202215143.GA13231@linux.home>
 <CANn89i+k3+NN8=5fD9RN4BnPT5dei=iKJaps_0vmcMNQwC58mw@mail.gmail.com>
 <20191204004654.GA22999@linux.home>
 <d6b6e3c4-cae6-6127-7bda-235a00d351ef@gmail.com>
MIME-Version: 1.0
In-Reply-To: <d6b6e3c4-cae6-6127-7bda-235a00d351ef@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: kBMlleM3NP6pCU5ioJtsOw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 03, 2019 at 06:20:24PM -0800, Eric Dumazet wrote:
>=20
> Sorry I am completely lost with this amount of text.
>=20
No problem. I'll write a v2 and remork the problem description to make
it clearer.

> Whatever solution you come up with, make sure it covers all the points
> that have been raised.
>=20
Will do.
Thanks.

