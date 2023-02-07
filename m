Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A152C68DF97
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 19:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjBGSIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 13:08:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjBGSIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 13:08:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8ED53929E
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 10:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675793242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S4x5qKj4mZKoGvyjVYSHB2H2PnDfOerrf3LVzTj3YME=;
        b=gaU9Fbf1W4LEBDUhHwza78QdJ8gvH7ilPxliiHoEN9TH51MmcOR/uG8tD8fvkh/xhG5pm3
        6iTdFmjY9m1NKXSR+jin9BCuACPiNs+//EZVr4QvGtn6rJVEChDAPnB2uMg2keDkfszAHQ
        MsvAXLlFs68qnp+qkZKOEw5POLHrFg8=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-510-w10ul10UMBOFRxiRbJm7xg-1; Tue, 07 Feb 2023 13:07:20 -0500
X-MC-Unique: w10ul10UMBOFRxiRbJm7xg-1
Received: by mail-qt1-f197.google.com with SMTP id x16-20020ac87ed0000000b003b82d873b38so9117833qtj.13
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 10:07:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S4x5qKj4mZKoGvyjVYSHB2H2PnDfOerrf3LVzTj3YME=;
        b=f9zG95iBwgeIsgDspV73JJ4La5EsY9qrUz3WID6XUz3AO2q2I5s0ufEwXi04WWe3lm
         O4l20kbzoIk+MEEWvhHBveBtL8QAus1TeSp+cJPwI+8XEVPbCNSiVuqFJNN9SDsrquPF
         xKMQcGLI7i9hZAc1CrGIqsMUgjQGIZ1wLbJVp6w/AcTafe+a1OeXlxc93OZreKsoj1YK
         zSBPwCs3ma+FmTfWQ0KFK6rvpoI6a+xxKzjiYGhJ295OwNYrYFRMv06By6fbTEbryvCO
         60VdZM3NR3jDurB0m4u8LNyYs+tYaue6SyT9l01OYw4Rb3s8OtahO4Rlg9Qsi3IPS78V
         bZXw==
X-Gm-Message-State: AO0yUKVg4imCqYqQOFgisD9rlKMw3aZRD1vSJLGMJDcFHqcKQ5EHxauQ
        me7BAwAlVBi9nn3ZnqK6TRlC86eQDevFK5c6uWKyEXFqdjb562jfX5RM78j+yZ9pcXwP6Ra+0c+
        +mgWad6adZDgV/Z9q
X-Received: by 2002:a05:622a:112:b0:3b8:68df:fc72 with SMTP id u18-20020a05622a011200b003b868dffc72mr7825065qtw.2.1675793240263;
        Tue, 07 Feb 2023 10:07:20 -0800 (PST)
X-Google-Smtp-Source: AK7set8cjC27SSuAC4+6fF6WgMSxS73grqiRMo482W5gZoUazjLcTL2TOyKMixk5mjoE5yE6VOcJ8w==
X-Received: by 2002:a05:622a:112:b0:3b8:68df:fc72 with SMTP id u18-20020a05622a011200b003b868dffc72mr7825024qtw.2.1675793239958;
        Tue, 07 Feb 2023 10:07:19 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id cr17-20020a05622a429100b003b63238615fsm9781225qtb.46.2023.02.07.10.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 10:07:19 -0800 (PST)
Message-ID: <056934c443a57293f925d8f18f603b6ec76b91db.camel@redhat.com>
Subject: Re: [PATCH net] net: dsa: mt7530: don't change PVC_EG_TAG when CPU
 port becomes VLAN-aware
From:   Paolo Abeni <pabeni@redhat.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     =?UTF-8?Q?Ar=C4=B1n=C3=A7_=C3=9CNAL?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, richard@routerhints.com
Date:   Tue, 07 Feb 2023 19:07:14 +0100
In-Reply-To: <20230207123952.r2r7tnama3vcr7vt@skbuf>
References: <20230205140713.1609281-1-vladimir.oltean@nxp.com>
         <3649b6f9-a028-8eaf-ac89-c4d0fce412da@arinc9.com>
         <20230205203906.i3jci4pxd6mw74in@skbuf>
         <b055e42f-ff0f-d05a-d462-961694b035c1@arinc9.com>
         <20230205235053.g5cttegcdsvh7uk3@skbuf>
         <116ff532-4ebc-4422-6599-1d5872ff9eb8@arinc9.com>
         <20230206174627.mv4ljr4gtkpr7w55@skbuf>
         <c4c90e6576f1bc4ef9d634edda5862c5f003ae3c.camel@redhat.com>
         <20230207123952.r2r7tnama3vcr7vt@skbuf>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-02-07 at 14:39 +0200, Vladimir Oltean wrote:
> On Tue, Feb 07, 2023 at 11:56:13AM +0100, Paolo Abeni wrote:
> > Thank you Vladimir for the quick turn-around!=20
> >=20
> > For future case, please avoid replying with new patches - tag area
> > included - to existing patch/thread, as it confuses tag propagation,
> > thanks!
>=20
> Ah, yes, I see (and thanks for fixing it up).
>=20
> Although I need to ask, since I think I made legitimate use of the tools
> given to me. What should I have done instead? Post an RFC patch (even
> though I didn't know whether it worked or not) in a thread separate to
> the debugging session? I didn't want to diverge from the thread reporting
> the issue. Maybe we should have started a new thread, decoupled from the
> patch?

Here what specifically confused the bot were the additional tags
present in the debug patch. One possible alternative would have been
posting - in the same thread - the code of the tentative patch without
the formal commit message/tag area.

That option is quite convenient toome, as writing the changelog takes
me a measurable amount of time and I could spend that effort only when
the patch is finalize/tested.

Please let me know if the above makes sense to you.

Cheers,

Paolo

