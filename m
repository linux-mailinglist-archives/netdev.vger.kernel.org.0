Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50FA05B2B47
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 03:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiIIBCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 21:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiIIBCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 21:02:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3DCFE7FB1
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 18:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662685362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q2d3x4Dkk5GcLF+MUMfDEfqQERDFnAItNweZdV/7zYI=;
        b=SIOLTO6U7xjwbCfamYmqMfGtn8PGW6Ra96Kv31HYz57+0zkvRyMcyHGbRIqRmGlVmGfQL5
        0kI+yIE0R0Mn8FM+f5OigqtZyPRNlrqewC8wkT5n52F+11m8sLbsQyDmk2C8Yh4Wsdjr3a
        jyct33QmDoiDwREj5rFIfjVPUqrphsI=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-395-IBVi4fvDMGqNcnSPfsqaQQ-1; Thu, 08 Sep 2022 21:02:41 -0400
X-MC-Unique: IBVi4fvDMGqNcnSPfsqaQQ-1
Received: by mail-io1-f70.google.com with SMTP id bh11-20020a056602370b00b00688c8a2b56cso291313iob.13
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 18:02:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=q2d3x4Dkk5GcLF+MUMfDEfqQERDFnAItNweZdV/7zYI=;
        b=VO9oKpsEhg+1WoeYLTjbuT1HXFXoHQyg/v38G+caM1W8LHzioTVLGMdP4iWv46JocE
         omGux4/pLJzkYUAb50wqzFvUvzSqILgovhY/SuosFEChup9iWmSvVMIKnBkhX23VxAY/
         fqS8Y1GnocWd9+m5U8SxPkkZzST3NgICfkCITmO9bycl5uwlPFF+/qv1u3HRQcm+uKSM
         4NDhbrdXLUoEgt+7On+UDGGSozh/3eAoE0RM+p+mo53VLiyuc0jJXTzYS0Q7lPEgspC5
         4srdZxpaXIKvOWoW4IuEv2mirAhYLY8PN2QNYpIpZzH8EQU2W0yOeq/dGqnA9r9ldLNg
         fK/w==
X-Gm-Message-State: ACgBeo2sPl/Wlf/MnAPi49M1Vmdtb1CnlJm4kshHOd2xr+4Vc3oOelIC
        LR12rGBTmPX3ztlMbTZAV24/xbKsFRoJIY5bmDo0ZW0fJ14xQQohJHqnZGVmsQ53VOm3vbPgNIy
        bdrqylxv/gPRUwfxIHz4hB+InqIm6LCMX
X-Received: by 2002:a05:6638:1492:b0:34c:d42:ac2f with SMTP id j18-20020a056638149200b0034c0d42ac2fmr6215625jak.305.1662685360469;
        Thu, 08 Sep 2022 18:02:40 -0700 (PDT)
X-Google-Smtp-Source: AA6agR62dyumc5VIw/U1Eq33JEOqNluH1vr9meRl5SSu5X8hz16B1yL4d4EP8X7GmqQ43clxoWwpT3zufS9SSRaedZk=
X-Received: by 2002:a05:6638:1492:b0:34c:d42:ac2f with SMTP id
 j18-20020a056638149200b0034c0d42ac2fmr6215619jak.305.1662685360286; Thu, 08
 Sep 2022 18:02:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220905203412.1322947-1-miquel.raynal@bootlin.com>
 <20220905203412.1322947-9-miquel.raynal@bootlin.com> <CAK-6q+jB0HQsU_wzr2T-qdGj=YSdf08DTZ0WTmRvDQt0Px7+Rg@mail.gmail.com>
In-Reply-To: <CAK-6q+jB0HQsU_wzr2T-qdGj=YSdf08DTZ0WTmRvDQt0Px7+Rg@mail.gmail.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Thu, 8 Sep 2022 21:02:29 -0400
Message-ID: <CAK-6q+g4xhqY-5HOBdYc_s4sHgZxtpZjfoN0_wXeDTKC6LmBPQ@mail.gmail.com>
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
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Sep 8, 2022 at 9:00 PM Alexander Aring <aahringo@redhat.com> wrote:
>
> Hi,
>
> On Mon, Sep 5, 2022 at 4:35 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > Most of the PHYs seem to cope with the standard filtering rules by
> > default. Some of them might not, like hwsim which is only software, and
>
> yes, as I said before hwsim should pretend to be like all other
> hardware we have.
>
> > in this case advertises its real filtering level with the new
> > "filtering" internal value.
> >
> > The core then needs to check what is expected by looking at the PHY
> > requested filtering level and possibly apply additional filtering
> > rules.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  include/net/ieee802154_netdev.h |  8 ++++
> >  net/mac802154/rx.c              | 78 +++++++++++++++++++++++++++++++++
> >  2 files changed, 86 insertions(+)
> >
> > diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_netdev.h
> > index d0d188c3294b..1b82bbafe8c7 100644
> > --- a/include/net/ieee802154_netdev.h
> > +++ b/include/net/ieee802154_netdev.h
> > @@ -69,6 +69,14 @@ struct ieee802154_hdr_fc {
> >  #endif
> >  };
> >
> > +enum ieee802154_frame_version {
> > +       IEEE802154_2003_STD,
> > +       IEEE802154_2006_STD,
> > +       IEEE802154_STD,
> > +       IEEE802154_RESERVED_STD,
> > +       IEEE802154_MULTIPURPOSE_STD = IEEE802154_2003_STD,
> > +};
> > +
> >  struct ieee802154_hdr {
> >         struct ieee802154_hdr_fc fc;
> >         u8 seq;
> > diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
> > index c43289c0fdd7..bc46e4a7669d 100644
> > --- a/net/mac802154/rx.c
> > +++ b/net/mac802154/rx.c
> > @@ -52,6 +52,84 @@ ieee802154_subif_frame(struct ieee802154_sub_if_data *sdata,
> >                                 mac_cb(skb)->type);
> >                         goto fail;
> >                 }
> > +       } else if (sdata->required_filtering == IEEE802154_FILTERING_4_FRAME_FIELDS &&
>
> We switch here from determine that receive path, means way we are

- way

> going from interface type to the required filtering value. Sure there
> is currently a 1:1 mapping for them now but I don't know why we are
> doing that and this is in my opinion wrong. The receive path should
> depend on interface type as it was before and for scanning there is
> some early check like:
>
> if (wpan_phy_is_in_scan_mode_state(local)) {
>      do_receive_scanning(...)
>      /* don't do any other delivery because they provide it to upper layer */

In the assumption we know if the condition above is true we have
address filtering disabled.

- Alex

