Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B595690DCC
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 17:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbjBIQDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 11:03:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbjBIQDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 11:03:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA7360B96
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 08:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675958544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EYcoTiBUvo5PZ/0hYDqUJR66lgNqp1qV/nbcAFRiJXg=;
        b=ClDmGOKIViWUDSyAy4V1NTkDUOc8sKKCWgv53Z/i3Y4n9uLap55XmEWcjs5r2xYSQXGi0T
        e/RiozBdmq4WqrOINo0xTDO4fi8niBfc3repgjFDFt2zVGeeMMjG+MzWodbvOwvdojjgZX
        IyRyXl7UlV/RZFQDrFu12dDVN7HM2oA=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-654-NRdw9MW0OfKeWgc1_5bbOQ-1; Thu, 09 Feb 2023 11:02:23 -0500
X-MC-Unique: NRdw9MW0OfKeWgc1_5bbOQ-1
Received: by mail-ot1-f71.google.com with SMTP id w9-20020a9d5a89000000b0068bc6c8621eso993633oth.9
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 08:02:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EYcoTiBUvo5PZ/0hYDqUJR66lgNqp1qV/nbcAFRiJXg=;
        b=Qr+nYb6vtxCuvzZGQDoli+qsott5nwRoZtSy21CmOq4qPziJJ8kBK5b1zq5RgWfUDk
         47xcTpKDjReWkytsKp/JAPXBl0e3YwkyG2iSsioAefxfLnZvBweRNC8lzIsVP5kasiWS
         V5XjywaV6D1eQ4K4xdJv4B/Uw8ZtDYJU5B1BBTcce12S+jOq1jRY9R73wzvDobacpcoq
         KzFmQ7S99uxvMQga7+hhyeNAlYetnbX7G98DS5QLSaelZWm2yS37N+4991nWoriZpbyj
         fYCx5NBCN9het03vLMdQhpdXnx+wu9OeFPUmYa//jqnMWa1FgB5g18mTIzsEn7WWyx5J
         cmbw==
X-Gm-Message-State: AO0yUKU4jQ6RQSpg3uQQMy5ToFRi4Z+haHiPl3L7ognUsaGXzTqwh+Vq
        Rbg0wujxKNhPq0RtaeEP5T4XuLgY3hRFMRmB1Xz+Jat+waDaPppexq8NJNSER3NKDULckC+sFgj
        YaLHAKRMq914tsSr/
X-Received: by 2002:a05:6870:2112:b0:163:758d:a6b7 with SMTP id f18-20020a056870211200b00163758da6b7mr6650415oae.1.1675958542322;
        Thu, 09 Feb 2023 08:02:22 -0800 (PST)
X-Google-Smtp-Source: AK7set+blLLlsB6bFiaBMqZWzXCqme34oZKf9rFsuym4TSOpJnIJKWUqQfU6P9F6S8dHgyQnjuoCMg==
X-Received: by 2002:a05:6870:2112:b0:163:758d:a6b7 with SMTP id f18-20020a056870211200b00163758da6b7mr6650386oae.1.1675958542047;
        Thu, 09 Feb 2023 08:02:22 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id s63-20020a37a942000000b0071c9eea2056sm1646563qke.14.2023.02.09.08.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 08:02:21 -0800 (PST)
Message-ID: <a793b8ae257e87fd58e6849f3529f3b886b68262.camel@redhat.com>
Subject: Re: [PATCH v3 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
From:   Paolo Abeni <pabeni@redhat.com>
To:     Chuck Lever III <chuck.lever@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>
Date:   Thu, 09 Feb 2023 17:02:12 +0100
In-Reply-To: <5D62859B-76AD-431C-AC93-C42A32EC2B69@oracle.com>
References: <167580444939.5328.5412964147692077675.stgit@91.116.238.104.host.secureserver.net>
         <167580607317.5328.2575913180270613320.stgit@91.116.238.104.host.secureserver.net>
         <20230208220025.0c3e6591@kernel.org>
         <5D62859B-76AD-431C-AC93-C42A32EC2B69@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-02-09 at 15:43 +0000, Chuck Lever III wrote:
> > On Feb 9, 2023, at 1:00 AM, Jakub Kicinski <kuba@kernel.org> wrote:
> >=20
> > On Tue, 07 Feb 2023 16:41:13 -0500 Chuck Lever wrote:
> > > diff --git a/tools/include/uapi/linux/netlink.h
> > > b/tools/include/uapi/linux/netlink.h
> > > index 0a4d73317759..a269d356f358 100644
> > > --- a/tools/include/uapi/linux/netlink.h
> > > +++ b/tools/include/uapi/linux/netlink.h
> > > @@ -29,6 +29,7 @@
> > > #define NETLINK_RDMA		20
> > > #define NETLINK_CRYPTO		21	/* Crypto layer */
> > > #define NETLINK_SMC		22	/* SMC monitoring */
> > > +#define NETLINK_HANDSHAKE	23	/* transport layer sec
> > > handshake requests */
> >=20
> > The extra indirection of genetlink introduces some complications?
>=20
> I don't think it does, necessarily. But neither does it seem
> to add any value (for this use case). <shrug>

To me it introduces a good separation between the handshake mechanism
itself and the current subject (sock).

IIRC the previous version allowed the user-space to create a socket of
the HANDSHAKE family which in turn accept()ed tcp sockets. That kind of
construct - assuming I interpreted it correctly - did not sound right
to me.

Back to these patches, they looks sane to me, even if the whole
architecture is a bit hard to follow, given the non trivial cross
references between the patches - I can likely have missed some relevant
point.=20

I'm wondering if this approach scales well enough with the number of
concurrent handshakes: the single list looks like a potential bottle-
neck.

Cheers,

Paolo

