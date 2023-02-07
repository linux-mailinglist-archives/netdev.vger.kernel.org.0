Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37BB168D747
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 13:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbjBGM4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 07:56:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjBGM4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 07:56:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A5A39CC7
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 04:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675774562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ebCQhrFO4rUSItANYHJYHADJAL09wzpJMWM7Xf+Yqpc=;
        b=I4dH0tGZ1FVAJdbthtyutsMjzE1ND3VLyHLKo3J00rhH0vSN7b8HS4/2r/vtae1pJw9/BK
        gTEQP63CqnnWm6o6ialKhQQeW2gE+/ve4Qx04a9LGhpppKKNu8KBI8kFl3NDdOBXxD+WBC
        KJKn8auqyO4blgtnGxS3/cJxt9EdCDw=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-330-sB5ANZ6bO4qWoXJYZh2zpQ-1; Tue, 07 Feb 2023 07:55:51 -0500
X-MC-Unique: sB5ANZ6bO4qWoXJYZh2zpQ-1
Received: by mail-ej1-f69.google.com with SMTP id wu9-20020a170906eec900b0088e1bbefaeeso11158045ejb.12
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 04:55:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ebCQhrFO4rUSItANYHJYHADJAL09wzpJMWM7Xf+Yqpc=;
        b=L6C9ISaHoLBxtVPEfrR/8V2+BL2UqxBiPvmQXRurDfWyOk+9OlVNwcmSHlL8HPuzKz
         xy6fHfVLCpKqJizejyVRHyfAPEH+XqFpFJvBLSS8BhCzUY/9WirT+yvgXE/9eyxJuNBL
         3oktOvhJ8AKNYWXwg4RaxWZquBqV5VJrk3tKmQKp+HeOQMX8c055qdmJj+v+xFGAKoSE
         Pnqp2bwTIV2xG3dLXu5VrwR3hBON+f2Ovo9NefsaaN8k9qxSiskDRaIDsn/yy6nzK3a9
         VeWq3sDfVAzrW8Wg7BXVSpP+LH9oZWLbJD1/OOVmkBvpS1zBhfzFgp63wh3Tbjk21p1P
         rHTA==
X-Gm-Message-State: AO0yUKUwHCbOn788aUVjinXBXYsuPSue9S/UCnkI0w2bVgwhakMOieeO
        3sNIgOnbqZumFi/e6guwTP0gUkQodIoy0Eb7nD/RV8ed/klq+UdfL5dJERXIyGvVKF/GvrrzKvF
        XLNW1A64BB9eQh8jgM1YS33wmOAJU8ISt
X-Received: by 2002:a50:d683:0:b0:49d:ec5e:1e99 with SMTP id r3-20020a50d683000000b0049dec5e1e99mr585484edi.6.1675774550323;
        Tue, 07 Feb 2023 04:55:50 -0800 (PST)
X-Google-Smtp-Source: AK7set9/W0Gx1ebZy5AGWViZ/Z8xBLnNtx+tJnvwRegdqsWm+EKaGINkg6KDXBD+ifv7olopkx0aP0FnWHlcl5CxrLE=
X-Received: by 2002:a50:d683:0:b0:49d:ec5e:1e99 with SMTP id
 r3-20020a50d683000000b0049dec5e1e99mr585471edi.6.1675774550138; Tue, 07 Feb
 2023 04:55:50 -0800 (PST)
MIME-Version: 1.0
References: <20221129160046.538864-1-miquel.raynal@bootlin.com>
 <20221129160046.538864-2-miquel.raynal@bootlin.com> <CAK-6q+iwqVx+6qQ-ctynykdrbN+SHxzk91gQCSdYCUD-FornZA@mail.gmail.com>
 <20230206101235.0371da87@xps-13> <CAK-6q+jav4yJD3MsOssyBobg1zGqKC5sm-xCRYX1SCkH9GhmHw@mail.gmail.com>
In-Reply-To: <CAK-6q+jav4yJD3MsOssyBobg1zGqKC5sm-xCRYX1SCkH9GhmHw@mail.gmail.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Tue, 7 Feb 2023 07:55:38 -0500
Message-ID: <CAK-6q+jbcMZK16pfZTb5v8-jvhmvk9-USr6hZE34H1MOrpF=JQ@mail.gmail.com>
Subject: Re: [PATCH wpan-next 1/6] ieee802154: Add support for user scanning requests
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

On Mon, Feb 6, 2023 at 7:33 PM Alexander Aring <aahringo@redhat.com> wrote:
>
> Hi,
>
> On Mon, Feb 6, 2023 at 4:13 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > Hi Alexander,
> >
> > aahringo@redhat.com wrote on Sun, 5 Feb 2023 20:39:32 -0500:
> >
> > > Hi,
> > >
> > > On Tue, Nov 29, 2022 at 11:02 AM Miquel Raynal
> > > <miquel.raynal@bootlin.com> wrote:
> > > >
> > > > The ieee802154 layer should be able to scan a set of channels in order
> > > > to look for beacons advertizing PANs. Supporting this involves adding
> > > > two user commands: triggering scans and aborting scans. The user should
> > > > also be notified when a new beacon is received and also upon scan
> > > > termination.
> > > >
> > > > A scan request structure is created to list the requirements and to be
> > > > accessed asynchronously when changing channels or receiving beacons.
> > > >
> > > > Mac layers may now implement the ->trigger_scan() and ->abort_scan()
> > > > hooks.
> > > >
> > > > Co-developed-by: David Girault <david.girault@qorvo.com>
> > > > Signed-off-by: David Girault <david.girault@qorvo.com>
> > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > ---
> > > >  include/linux/ieee802154.h |   3 +
> > > >  include/net/cfg802154.h    |  25 +++++
> > > >  include/net/nl802154.h     |  49 +++++++++
> > > >  net/ieee802154/nl802154.c  | 215 +++++++++++++++++++++++++++++++++++++
> > > >  net/ieee802154/nl802154.h  |   3 +
> > > >  net/ieee802154/rdev-ops.h  |  28 +++++
> > > >  net/ieee802154/trace.h     |  40 +++++++
> > > >  7 files changed, 363 insertions(+)
> > > >
> > > > diff --git a/include/linux/ieee802154.h b/include/linux/ieee802154.h
> > > > index 0303eb84d596..b22e4147d334 100644
> > > > --- a/include/linux/ieee802154.h
> > > > +++ b/include/linux/ieee802154.h
> > > > @@ -44,6 +44,9 @@
> > > >  #define IEEE802154_SHORT_ADDR_LEN      2
> > > >  #define IEEE802154_PAN_ID_LEN          2
> > > >
> > > > +/* Duration in superframe order */
> > > > +#define IEEE802154_MAX_SCAN_DURATION   14
> > > > +#define IEEE802154_ACTIVE_SCAN_DURATION        15
> > > >  #define IEEE802154_LIFS_PERIOD         40
> > > >  #define IEEE802154_SIFS_PERIOD         12
> > > >  #define IEEE802154_MAX_SIFS_FRAME_SIZE 18
> > > > diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> > > > index d09c393d229f..76d4f95e9974 100644
> > > > --- a/include/net/cfg802154.h
> > > > +++ b/include/net/cfg802154.h
> > > > @@ -18,6 +18,7 @@
> > > >
> > > >  struct wpan_phy;
> > > >  struct wpan_phy_cca;
> > > > +struct cfg802154_scan_request;
> > > >
> > > >  #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
> > > >  struct ieee802154_llsec_device_key;
> > > > @@ -67,6 +68,10 @@ struct cfg802154_ops {
> > > >                                 struct wpan_dev *wpan_dev, bool mode);
> > > >         int     (*set_ackreq_default)(struct wpan_phy *wpan_phy,
> > > >                                       struct wpan_dev *wpan_dev, bool ackreq);
> > > > +       int     (*trigger_scan)(struct wpan_phy *wpan_phy,
> > > > +                               struct cfg802154_scan_request *request);
> > > > +       int     (*abort_scan)(struct wpan_phy *wpan_phy,
> > > > +                             struct wpan_dev *wpan_dev);
> > > >  #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
> > > >         void    (*get_llsec_table)(struct wpan_phy *wpan_phy,
> > > >                                    struct wpan_dev *wpan_dev,
> > > > @@ -278,6 +283,26 @@ struct ieee802154_coord_desc {
> > > >         bool gts_permit;
> > > >  };
> > > >
> > > > +/**
> > > > + * struct cfg802154_scan_request - Scan request
> > > > + *
> > > > + * @type: type of scan to be performed
> > > > + * @page: page on which to perform the scan
> > > > + * @channels: channels in te %page to be scanned
> > > > + * @duration: time spent on each channel, calculated with:
> > > > + *            aBaseSuperframeDuration * (2 ^ duration + 1)
> > > > + * @wpan_dev: the wpan device on which to perform the scan
> > > > + * @wpan_phy: the wpan phy on which to perform the scan
> > > > + */
> > > > +struct cfg802154_scan_request {
> > > > +       enum nl802154_scan_types type;
> > > > +       u8 page;
> > > > +       u32 channels;
> > > > +       u8 duration;
> > > > +       struct wpan_dev *wpan_dev;
> > > > +       struct wpan_phy *wpan_phy;
> > > > +};
> > > > +
> > > >  struct ieee802154_llsec_key_id {
> > > >         u8 mode;
> > > >         u8 id;
> > > > diff --git a/include/net/nl802154.h b/include/net/nl802154.h
> > > > index b79a89d5207c..79fbd820b25a 100644
> > > > --- a/include/net/nl802154.h
> > > > +++ b/include/net/nl802154.h
> > > > @@ -73,6 +73,9 @@ enum nl802154_commands {
> > > >         NL802154_CMD_DEL_SEC_LEVEL,
> > > >
> > > >         NL802154_CMD_SCAN_EVENT,
> > > > +       NL802154_CMD_TRIGGER_SCAN,
> > > > +       NL802154_CMD_ABORT_SCAN,
> > > > +       NL802154_CMD_SCAN_DONE,
> > > >
> > > >         /* add new commands above here */
> > > >
> > > > @@ -134,6 +137,12 @@ enum nl802154_attrs {
> > > >         NL802154_ATTR_NETNS_FD,
> > > >
> > > >         NL802154_ATTR_COORDINATOR,
> > > > +       NL802154_ATTR_SCAN_TYPE,
> > > > +       NL802154_ATTR_SCAN_FLAGS,
> > > > +       NL802154_ATTR_SCAN_CHANNELS,
> > > > +       NL802154_ATTR_SCAN_PREAMBLE_CODES,
> > > > +       NL802154_ATTR_SCAN_MEAN_PRF,
> > > > +       NL802154_ATTR_SCAN_DURATION,
> > > >
> > > >         /* add attributes here, update the policy in nl802154.c */
> > > >
> > > > @@ -259,6 +268,46 @@ enum nl802154_coord {
> > > >         NL802154_COORD_MAX,
> > > >  };
> > > >
> > > > +/**
> > > > + * enum nl802154_scan_types - Scan types
> > > > + *
> > > > + * @__NL802154_SCAN_INVALID: scan type number 0 is reserved
> > > > + * @NL802154_SCAN_ED: An ED scan allows a device to obtain a measure of the peak
> > > > + *     energy in each requested channel
> > > > + * @NL802154_SCAN_ACTIVE: Locate any coordinator transmitting Beacon frames using
> > > > + *     a Beacon Request command
> > > > + * @NL802154_SCAN_PASSIVE: Locate any coordinator transmitting Beacon frames
> > > > + * @NL802154_SCAN_ORPHAN: Relocate coordinator following a loss of synchronisation
> > > > + * @NL802154_SCAN_ENHANCED_ACTIVE: Same as Active using Enhanced Beacon Request
> > > > + *     command instead of Beacon Request command
> > > > + * @NL802154_SCAN_RIT_PASSIVE: Passive scan for RIT Data Request command frames
> > > > + *     instead of Beacon frames
> > > > + * @NL802154_SCAN_ATTR_MAX: Maximum SCAN attribute number
> > > > + */
> > > > +enum nl802154_scan_types {
> > > > +       __NL802154_SCAN_INVALID,
> > > > +       NL802154_SCAN_ED,
> > > > +       NL802154_SCAN_ACTIVE,
> > > > +       NL802154_SCAN_PASSIVE,
> > > > +       NL802154_SCAN_ORPHAN,
> > > > +       NL802154_SCAN_ENHANCED_ACTIVE,
> > > > +       NL802154_SCAN_RIT_PASSIVE,
> > > > +
> > > > +       /* keep last */
> > > > +       NL802154_SCAN_ATTR_MAX,
> > > > +};
> > > > +
> > > > +/**
> > > > + * enum nl802154_scan_flags - Scan request control flags
> > > > + *
> > > > + * @NL802154_SCAN_FLAG_RANDOM_ADDR: use a random MAC address for this scan (ie.
> > > > + *     a different one for every scan iteration). When the flag is set, full
> > > > + *     randomisation is assumed.
> > > > + */
> > > > +enum nl802154_scan_flags {
> > > > +       NL802154_SCAN_FLAG_RANDOM_ADDR = BIT(0),
> > > > +};
> > > > +
> > > >  /**
> > > >   * enum nl802154_cca_modes - cca modes
> > > >   *
> > > > diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> > > > index 80dc73182785..c497ffd8e897 100644
> > > > --- a/net/ieee802154/nl802154.c
> > > > +++ b/net/ieee802154/nl802154.c
> > > > @@ -221,6 +221,12 @@ static const struct nla_policy nl802154_policy[NL802154_ATTR_MAX+1] = {
> > > >
> > > >         [NL802154_ATTR_COORDINATOR] = { .type = NLA_NESTED },
> > > >
> > > > +       [NL802154_ATTR_SCAN_TYPE] = { .type = NLA_U8 },
> > > > +       [NL802154_ATTR_SCAN_CHANNELS] = { .type = NLA_U32 },
> > > > +       [NL802154_ATTR_SCAN_PREAMBLE_CODES] = { .type = NLA_U64 },
> > > > +       [NL802154_ATTR_SCAN_MEAN_PRF] = { .type = NLA_U8 },
> > > > +       [NL802154_ATTR_SCAN_DURATION] = { .type = NLA_U8 },
> > > > +
> > > >  #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
> > > >         [NL802154_ATTR_SEC_ENABLED] = { .type = NLA_U8, },
> > > >         [NL802154_ATTR_SEC_OUT_LEVEL] = { .type = NLA_U32, },
> > > > @@ -1384,6 +1390,199 @@ int nl802154_scan_event(struct wpan_phy *wpan_phy, struct wpan_dev *wpan_dev,
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(nl802154_scan_event);
> > > >
> > > > +static int nl802154_trigger_scan(struct sk_buff *skb, struct genl_info *info)
> > > > +{
> > > > +       struct cfg802154_registered_device *rdev = info->user_ptr[0];
> > > > +       struct net_device *dev = info->user_ptr[1];
> > > > +       struct wpan_dev *wpan_dev = dev->ieee802154_ptr;
> > > > +       struct wpan_phy *wpan_phy = &rdev->wpan_phy;
> > > > +       struct cfg802154_scan_request *request;
> > > > +       u8 type;
> > > > +       int err;
> > > > +
> > > > +       /* Monitors are not allowed to perform scans */
> > > > +       if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
> > > > +               return -EPERM;
> > >
> > > btw: why are monitors not allowed?
> >
> > I guess I had the "active scan" use case in mind which of course does
> > not work with monitors. Maybe I can relax this a little bit indeed,
> > right now I don't remember why I strongly refused scans on monitors.
>
> Isn't it that scans really work close to phy level? Means in this case
> we disable mostly everything of MAC filtering on the transceiver side.
> Then I don't see any reasons why even monitors can't do anything, they
> also can send something. But they really don't have any specific
> source address set, so long addresses are none for source addresses, I
> don't see any problem here. They also don't have AACK handling, but
> it's not required for scan anyway...
>
> If this gets too complicated right now, then I am also fine with
> returning an error here, we can enable it later but would it be better
> to use ENOTSUPP or something like that in this case? EPERM sounds like
> you can do that, but you don't have the permissions.
>

For me a scan should also be possible from iwpan phy $PHY scan (or
whatever the scan command is, or just enable beacon)... to go over the
dev is just a shortcut for "I mean whatever the phy is under this dev"
?

- Alex

