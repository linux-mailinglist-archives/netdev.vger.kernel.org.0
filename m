Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09BB05ED1E9
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 02:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233062AbiI1AXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 20:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiI1AXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 20:23:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD351B8C8E
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 17:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664324594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/WvHZX3vORKM3AZXwoBk4WC1c7EJPNOs/eg0I0y98ZE=;
        b=FyFYEH6reKXZlxmE7Fs9uIiHVmB5XTwBoNdDVMgn8/1wmo1HMgwVhnN8jJstwXGlhdoEbv
        bvYyXXzTOsd1+ZS49o6edJ+qmWzSio5eXqP06XT7Jyi8CtYREWRx/YWkvu9GfAQbT3Bw/c
        IKQpN2OaZNV3tiwKz1sM9YSzDF5JP9g=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-113-kOf6XBdxONqoN8OcSqAL_Q-1; Tue, 27 Sep 2022 20:23:13 -0400
X-MC-Unique: kOf6XBdxONqoN8OcSqAL_Q-1
Received: by mail-wm1-f71.google.com with SMTP id r7-20020a1c4407000000b003b3309435a9so188926wma.6
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 17:23:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=/WvHZX3vORKM3AZXwoBk4WC1c7EJPNOs/eg0I0y98ZE=;
        b=b9kC0DUXTGoP80K01FxE5n9ikIJWnwir8GZPITbCA7mjO0D5WqQEEQWLC4E2rWgMqH
         PNYJ/lV22gHxuBt9GRToyjyI7H7WwHjAv+o+NTkk5QYMQa0TUtRLKFgUFJawSnROhyGL
         1vutXaVUwla8ZYgTgGhSa9s/cBb95Va19dRXyloZRzACHO04er+ZzVJgslA1Fghv/jep
         zM7S5l283+R8vpHBoFTXmaQOW3JXBm6SMRS1Ew5LbuggcHk9Q/T7HRrNTEkvvX0yfqX/
         G0rVFCkmgeK8G/zXHNX6Urktz0S3Tumff9iOCa0btkmtJKZb1U0yKrLk/Xnd8oCzwFzC
         ro6w==
X-Gm-Message-State: ACrzQf0e04xPdfK/cfwjwfVq2N9Ldj/XYhmZMC9YnXJ9WykdG5lj3uRk
        ol9D01zVLQUXnCjwS1XdGLZnpOGs2kqY4OwCSxgXQwr/YV1etHJDsoPbxdYQhTiYuZSttbu8kSg
        jloZlNMntXcOV2V2lM7xkYbUizQtJ+cvQ
X-Received: by 2002:a05:600c:4e15:b0:3b4:a621:b54e with SMTP id b21-20020a05600c4e1500b003b4a621b54emr4587137wmq.47.1664324592044;
        Tue, 27 Sep 2022 17:23:12 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5YHCNrvLJOy8eqC+HcgrpdhaJIcCjsonap7qDvTMZQTucKtFKi0zhHLuCM3I3aM1jj938k6vej60KBnNr3ctE=
X-Received: by 2002:a05:600c:4e15:b0:3b4:a621:b54e with SMTP id
 b21-20020a05600c4e1500b003b4a621b54emr4587121wmq.47.1664324591826; Tue, 27
 Sep 2022 17:23:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220905203412.1322947-1-miquel.raynal@bootlin.com>
 <20220905203412.1322947-9-miquel.raynal@bootlin.com> <CAK-6q+jB0HQsU_wzr2T-qdGj=YSdf08DTZ0WTmRvDQt0Px7+Rg@mail.gmail.com>
 <20220921175943.1f871b31@xps-13> <CAK-6q+h4KDNqWMX+NNg+d-J7Pmi9HdmXbUqfiGedmFsHOEtMcA@mail.gmail.com>
In-Reply-To: <CAK-6q+h4KDNqWMX+NNg+d-J7Pmi9HdmXbUqfiGedmFsHOEtMcA@mail.gmail.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Tue, 27 Sep 2022 20:23:00 -0400
Message-ID: <CAK-6q+ge6JFKbOwemyc=XL52c637gmc6XBWuPELgcOErSWZ3jg@mail.gmail.com>
Subject: Re: [PATCH wpan/next v3 8/9] net: mac802154: Ensure proper general
 purpose frame filtering
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
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, Sep 25, 2022 at 6:27 PM Alexander Aring <aahringo@redhat.com> wrote:
>
> Hi,
>
> On Wed, Sep 21, 2022 at 11:59 AM Miquel Raynal
> <miquel.raynal@bootlin.com> wrote:
> >
> > Hi Alexander,
> >
> > aahringo@redhat.com wrote on Thu, 8 Sep 2022 21:00:37 -0400:
> >
> > > Hi,
> > >
> > > On Mon, Sep 5, 2022 at 4:35 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > >
> > > > Most of the PHYs seem to cope with the standard filtering rules by
> > > > default. Some of them might not, like hwsim which is only software, and
> > >
> > > yes, as I said before hwsim should pretend to be like all other
> > > hardware we have.
> > >
> > > > in this case advertises its real filtering level with the new
> > > > "filtering" internal value.
> > > >
> > > > The core then needs to check what is expected by looking at the PHY
> > > > requested filtering level and possibly apply additional filtering
> > > > rules.
> > > >
> > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > ---
> > > >  include/net/ieee802154_netdev.h |  8 ++++
> > > >  net/mac802154/rx.c              | 78 +++++++++++++++++++++++++++++++++
> > > >  2 files changed, 86 insertions(+)
> > > >
> > > > diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_netdev.h
> > > > index d0d188c3294b..1b82bbafe8c7 100644
> > > > --- a/include/net/ieee802154_netdev.h
> > > > +++ b/include/net/ieee802154_netdev.h
> > > > @@ -69,6 +69,14 @@ struct ieee802154_hdr_fc {
> > > >  #endif
> > > >  };
> > > >
> > > > +enum ieee802154_frame_version {
> > > > +       IEEE802154_2003_STD,
> > > > +       IEEE802154_2006_STD,
> > > > +       IEEE802154_STD,
> > > > +       IEEE802154_RESERVED_STD,
> > > > +       IEEE802154_MULTIPURPOSE_STD = IEEE802154_2003_STD,
> > > > +};
> > > > +
> > > >  struct ieee802154_hdr {
> > > >         struct ieee802154_hdr_fc fc;
> > > >         u8 seq;
> > > > diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
> > > > index c43289c0fdd7..bc46e4a7669d 100644
> > > > --- a/net/mac802154/rx.c
> > > > +++ b/net/mac802154/rx.c
> > > > @@ -52,6 +52,84 @@ ieee802154_subif_frame(struct ieee802154_sub_if_data *sdata,
> > > >                                 mac_cb(skb)->type);
> > > >                         goto fail;
> > > >                 }
> > > > +       } else if (sdata->required_filtering == IEEE802154_FILTERING_4_FRAME_FIELDS &&
> > >
> > > We switch here from determine that receive path, means way we are
> > > going from interface type to the required filtering value. Sure there
> > > is currently a 1:1 mapping for them now but I don't know why we are
> > > doing that and this is in my opinion wrong. The receive path should
> > > depend on interface type as it was before and for scanning there is
> > > some early check like:
> >
> > Maybe on this one I am not fully convinced yet.
> >
> > In your opinion (I try to rephrase so that we align on what you told
> > me) the total lack of filtering is only something that is reserved to
> > monitor interfaces, so you make an implicit link between interface type
> > and filtering level.
>
> it always depends on the use case, but in the sense of filtering-level
> in "normal" operating mode and calling netif_skb_deliver_foo(), yes.
>
> The use case for e.g. scan is different and mac802154 takes control of it.
>
> >
> > I would argue that this is true today, but as the "no filtering at all"
> > level is defined in the spec, I assumed it was a possible level that
> > one would want to achieve some day (not sure for what purpose yet). So
> > I assumed it would be more relevant to only work with the
> > expected filtering level in the receive path rather than on the
> > interface type, it makes more sense IMHO. In practice I agree it should
> > be the same filtering-wise, but from a conceptual point of view I find
> > the current logic partially satisfying.
> >
>
> I don't quite follow here. I would say we currently only support to
> tell the hardware the whole filtering level (with AACK support) or the
> non-filtering level. With both we should somehow able to support
> interface types which requires
>
> > Would you agree with me only using "expected filtering levels" rather
> > than:
> > - sometimes the interface type
> > - sometimes the mac state (scan)
> > - otherwise, by default, the highest filtering level
> > ?
>
> I think so, yes? I don't know what "otherwise, by default, the highest
> filtering level" means, it is the interface type which declares what
> it's actually needs at netif_skb_deliver_foo(), e.g. monitors will
> call netif_skb_deliver_foo() even without AACK support... because
> that's how they working. They also don't have an address in the

they don't have an address -> the hardware filter is set to invalid
destination address setting and this should always be set when
switching to a mode which disables address filter. In case of your
scan command it should be then switched back.

- Alex

