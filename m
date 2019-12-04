Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 217A1113421
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 19:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730391AbfLDSFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 13:05:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24757 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730378AbfLDSFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 13:05:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575482726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lKfb9/eRiqw24+7Zyo6WRM1LW8GZP4NSgCpif6/rHYo=;
        b=NqArboQ7WtE859OdA8aL0E39m0A49dy9HAEGLCK5eBpONQkB6h7UaLWglx2FSllRe2rOs2
        Miny9HTB9COjUMH13eYjDpMLvfAjk+yLLaxtOpHuzXaF8KxSLN0BzEkdC78LT7Krjb4RCf
        +OG5dvqSI4OJob+sIX2/jsadyd+I+oM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-hsW09JfwM5eYTa3kVOAWWA-1; Wed, 04 Dec 2019 13:05:24 -0500
Received: by mail-wr1-f72.google.com with SMTP id 92so201554wro.14
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 10:05:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gIfKz59Tq5UN2ejK9rWp5KC29OZFliPl+5ZpdazqVZU=;
        b=NpNIWGqca4emqIk6an8kuuhcZPTGPKY6rM+XkBmQuRT439w4dzhqUOkCeOJ1qHKyPi
         T5BIFjYFpt21/QPJXtQnGSIaBAwV3dTyf8NuhMKq+X96V2UbLK8DYgYhjKyicgKpj3Pn
         v61x+7gdHLaR7dGEzozipW+el4uedqyV/deVSK6sQAVzPRS+jMQd1FIg4kUP48lG2ebO
         5Wp+rdVlfzQ9EJpuqqkE2uaY5pe9mkDRZvLaeKQzgEbGZw5uC6aBMIMgVq9p7RJiXtAO
         KCqH+9eLh9wU0X9kCJGFCVcfHFUnTY3DX/6GwOo/XJjeDDp8GWFdLUeiPit6pLWYfJaK
         vOug==
X-Gm-Message-State: APjAAAW2Rls/L8YhaKmF2LPR45wptJjuAFRMGaYegr1vYJT6/Kt/9F1B
        2Q3gbVM8qSOnBE4dlYupkzaI30Hfh5SLA4YMUrVrVVSbq6g8K4pah//qU98iaWGG8/TNlpZOaHb
        nz5EY4wtG5jOSlPn1
X-Received: by 2002:adf:f491:: with SMTP id l17mr5402920wro.149.1575482723489;
        Wed, 04 Dec 2019 10:05:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqyn+tm3S/TbapgxaMcrnLAaYeFmDmcazLlf3i8LZaET+9Pfvy7D6XXjZ9Ii/ZtaKDKZvthEzg==
X-Received: by 2002:adf:f491:: with SMTP id l17mr5402888wro.149.1575482723227;
        Wed, 04 Dec 2019 10:05:23 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id z6sm9663818wrw.36.2019.12.04.10.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 10:05:22 -0800 (PST)
Date:   Wed, 4 Dec 2019 19:05:20 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev <netdev@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH net] tcp: Avoid time_after32() underflow when handling
 syncookies
Message-ID: <20191204180520.GA4139@linux.home>
References: <2601e43617d707a28f60f2fe6927b1aaaa0a37f8.1574976866.git.gnault@redhat.com>
 <CANn89i+G0jCU=JtSit3X9w+SaExgbbo-d1x4UEkTEJRdypN3gQ@mail.gmail.com>
 <20191202215143.GA13231@linux.home>
 <CANn89i+k3+NN8=5fD9RN4BnPT5dei=iKJaps_0vmcMNQwC58mw@mail.gmail.com>
 <20191204004654.GA22999@linux.home>
 <d6b6e3c4-cae6-6127-7bda-235a00d351ef@gmail.com>
 <20191204143414.GA2358@linux.home>
 <192e1cb1-2cf1-22e8-999b-c74c74492113@gmail.com>
MIME-Version: 1.0
In-Reply-To: <192e1cb1-2cf1-22e8-999b-c74c74492113@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: hsW09JfwM5eYTa3kVOAWWA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 04, 2019 at 08:53:08AM -0800, Eric Dumazet wrote:
>=20
>=20
> On 12/4/19 6:34 AM, Guillaume Nault wrote:
> > On Tue, Dec 03, 2019 at 06:20:24PM -0800, Eric Dumazet wrote:
> >>
> >> Sorry I am completely lost with this amount of text.
> >>
> > No problem. I'll write a v2 and remork the problem description to make
> > it clearer.
> >=20
> >> Whatever solution you come up with, make sure it covers all the points
> >> that have been raised.
> >>
> > Will do.
> > Thanks.
> >=20
>=20
> Le me apologize for my last email.
>=20
> I should have slept first after my long day.
>=20
> Thanks a lot for working on this !
>=20
No problem :)

I'm preparing a small series, splitting the valid syncookie and stray
ACK cases.
I expect to have something ready later tonight.

