Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA15767DB75
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 02:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbjA0Bt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 20:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjA0BtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 20:49:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0678B74A54
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 17:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674784103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UdNReRsqkFMj+61fQ7QVmGJiJhm8D0MWz3RUXRqbpVA=;
        b=RVDZcEazRrXg68SHR0fkxov2zwas0eoNzSieqgc+rGRifGxx6mqf2PCPr1mf9jnGe8Hh4w
        0lCMTOqyX+ic1VqWM0fmqAuTusKuGxYlyVTWfK9r7IiOPBBNhk5kaQKkbqK8SLZYEPrr9D
        LK03Pt2yRzgxsIfzIRquMpc2QCKHc/w=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-617-6IUOcoTWPaOWT8JGk7eNlw-1; Thu, 26 Jan 2023 20:48:14 -0500
X-MC-Unique: 6IUOcoTWPaOWT8JGk7eNlw-1
Received: by mail-ed1-f69.google.com with SMTP id y2-20020a056402440200b0049e4d71f5dcso2606675eda.5
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 17:48:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UdNReRsqkFMj+61fQ7QVmGJiJhm8D0MWz3RUXRqbpVA=;
        b=ciqJAb8THs2DQicckC08K71jrUEw3tpJnpX0wU3NEYqNsb4WJISr64aAvUIg0U5aaW
         hS0gK6NP3mySYmYzhZPW/JwneoBODHsTd9OyF3YlrEe06Lx4q19Fn1ksPfG3dLGhz0Fr
         V5zKE8DYfVTLBl3Xt0rU9fyvaGV2xK4dvQeFqAZc1FWWC/KP5DcDxjxta44amXRnq6PV
         FZobsCWZqNvcjXig5+JnjPk2jy2UJXabRLBe/UAomwrUqE8r8tFZDzF7+rHPgu7UVrde
         67Ncjo0yo22TJDN5mGImZQDWz8sM1HLHTY7Gh6s4B82ccoESQutWpB8JyMcwlHrukqT+
         /8Ag==
X-Gm-Message-State: AFqh2kq5nSkPgGzlPd1Zh1+9Kv7C/oeyfwHJ37AbaI9Sf01NPwlj04xl
        WBmRcRpj9Dyz8B1lK/xSORIfM5DCmJP7ZDKBOI0zo1BspvQTLUv/yQdc/Pz7+cPLNWcaiPYze93
        sqv4HLefHFir0+Fx+R8lpGziAQohl7Fz2
X-Received: by 2002:a17:906:4988:b0:871:e963:1508 with SMTP id p8-20020a170906498800b00871e9631508mr6388973eju.185.1674784093960;
        Thu, 26 Jan 2023 17:48:13 -0800 (PST)
X-Google-Smtp-Source: AMrXdXt0rLnhMLRLq/D8RTL4zbjByx8IKkthjOspdHq+VArO1TyNIiLQIzO9qDLMJorz7BX7HORmEMkmfJsNzgzNv/U=
X-Received: by 2002:a17:906:4988:b0:871:e963:1508 with SMTP id
 p8-20020a170906498800b00871e9631508mr6388960eju.185.1674784093835; Thu, 26
 Jan 2023 17:48:13 -0800 (PST)
MIME-Version: 1.0
References: <20230125102923.135465-1-miquel.raynal@bootlin.com> <CAK-6q+jN1bnP1FdneGrfDJuw3r3b=depEdEP49g_t3PKQ-F=Lw@mail.gmail.com>
In-Reply-To: <CAK-6q+jN1bnP1FdneGrfDJuw3r3b=depEdEP49g_t3PKQ-F=Lw@mail.gmail.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Thu, 26 Jan 2023 20:48:02 -0500
Message-ID: <CAK-6q+hoquVswZTm+juLasQzUJpGdO+aQ7Q3PCRRwYagge5dTw@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 0/2] ieee802154: Beaconing support
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Jan 26, 2023 at 8:45 PM Alexander Aring <aahringo@redhat.com> wrote=
:
>
> Hi,
>
> On Wed, Jan 25, 2023 at 5:31 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Scanning being now supported, we can eg. play with hwsim to verify
> > everything works as soon as this series including beaconing support get=
s
> > merged.
> >
> > Thanks,
> > Miqu=C3=A8l
> >
> > Changes in v2:
> > * Clearly state in the commit log llsec is not supported yet.
> > * Do not use mlme transmission helpers because we don't really need to
> >   stop the queue when sending a beacon, as we don't expect any feedback
> >   from the PHY nor from the peers. However, we don't want to go through
> >   the whole net stack either, so we bypass it calling the subif helper
> >   directly.
> >

moment, we use the mlme helpers to stop tx but we use the
ieee802154_subif_start_xmit() because of the possibility to invoke
current 802.15.4 hooks like llsec? That's how I understand it.

- Alex

