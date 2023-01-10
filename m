Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D45A6640E8
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 13:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238490AbjAJMu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 07:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238474AbjAJMuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 07:50:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81764FD77
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 04:49:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673354976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LtmIDGWw27oWIDOH8I1+LwSysyCQMzRcxJv1yEQeQLc=;
        b=ibbdBW9Fn2D7egH/+N4xhDhh1enjDLBViC+xbpeBBew1OmfOh6q5GAoxYlAjICOMoW3dm5
        z9nGj8UJmdo9CWTVrLj7S4NAELZHiN6R/y25T44mX2df1B+Rm3iYkVXUe9j+7BKgOMx01H
        RbsBskozWqGcsjrNTTYiBTCC0S2ajto=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-426-L8y1_4PWNH2MdSiRkP9Wgg-1; Tue, 10 Jan 2023 07:49:34 -0500
X-MC-Unique: L8y1_4PWNH2MdSiRkP9Wgg-1
Received: by mail-qk1-f199.google.com with SMTP id bi3-20020a05620a318300b00702545f73d5so8598064qkb.8
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 04:49:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LtmIDGWw27oWIDOH8I1+LwSysyCQMzRcxJv1yEQeQLc=;
        b=zRk2xBtUNIN0pQHXECuXWUGXbOYuJ6sBM7d+MaYuZJuvo3Va+OxFJGtBMkFn7hF4YB
         d8xDKNJ7g8cIyqiHPs0ACb9FEJkiedJkpYrIcbIVoenSGXk13R9+CodyrOyXZOGTX0DP
         bZAGCWtympFXHmcfKPEvsD6lRsRbjVpOhuMe2V7+JMB1BeiDBvavgB9kGWbLDnFwM0FC
         hiD4uofEuu5zVOw2griGyYwnahgQUKIMIp/UEP6WnqOfz1qpfAm2nkqHrOusWlL5Uwib
         6lzh1/kUclPJf4eiE5/kLnbwShKB1plFV+apoDh0Nc498xEPQ83s1eUBgap2Z5R3pB15
         O31w==
X-Gm-Message-State: AFqh2kq7gG/vdK1p5b2WfX4WNbU6s2lQgygt66XodRU/OsvprNtRi3BA
        cOmJG4JAkyTtYe3bk1+Fzy4SfR2JF9dHs0hpwMYjYex5kaRMGsmLLkOPHrpqfXelTWNk3S77RgA
        eT1W75T+BCHB003KJ
X-Received: by 2002:ac8:5ed4:0:b0:39c:efc8:b2a8 with SMTP id s20-20020ac85ed4000000b0039cefc8b2a8mr3571958qtx.27.1673354974185;
        Tue, 10 Jan 2023 04:49:34 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuapLeanbK2mF2tkISFRRR7kbnBi3E797VRZF+bY3EPqOw88qp4xilDlE2/BCG9bCjL8KEtBw==
X-Received: by 2002:ac8:5ed4:0:b0:39c:efc8:b2a8 with SMTP id s20-20020ac85ed4000000b0039cefc8b2a8mr3571931qtx.27.1673354973900;
        Tue, 10 Jan 2023 04:49:33 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-128.dyn.eolo.it. [146.241.120.128])
        by smtp.gmail.com with ESMTPSA id g19-20020a05620a40d300b006cec8001bf4sm7232697qko.26.2023.01.10.04.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 04:49:33 -0800 (PST)
Message-ID: <161fdffccb78fca2f16f1f5c78390420f60817b3.camel@redhat.com>
Subject: Re: [PATCH net-next v3 01/11] net: mdio: Add dedicated C45 API to
 MDIO bus drivers
From:   Paolo Abeni <pabeni@redhat.com>
To:     Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Date:   Tue, 10 Jan 2023 13:49:28 +0100
In-Reply-To: <5bd7ee34ead313785951defbf3069b64d4338a45.camel@redhat.com>
References: <20221227-v6-2-rc1-c45-seperation-v3-0-ade1deb438da@walle.cc>
         <20221227-v6-2-rc1-c45-seperation-v3-1-ade1deb438da@walle.cc>
         <5bd7ee34ead313785951defbf3069b64d4338a45.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-01-10 at 12:16 +0100, Paolo Abeni wrote:
> On Mon, 2023-01-09 at 16:30 +0100, Michael Walle wrote:
> > diff --git a/include/linux/phy.h b/include/linux/phy.h
> > index 6378c997ded5..65844f0a7fb3 100644
> > --- a/include/linux/phy.h
> > +++ b/include/linux/phy.h
> > @@ -364,6 +364,11 @@ struct mii_bus {
> >  	int (*read)(struct mii_bus *bus, int addr, int regnum);
> >  	/** @write: Perform a write transfer on the bus */
> >  	int (*write)(struct mii_bus *bus, int addr, int regnum, u16 val);
> > +	/** @read: Perform a C45 read transfer on the bus */
> 
> Minor nit: s/@read/@read_c45/ 
> 
> > +	int (*read_c45)(struct mii_bus *bus, int addr, int devnum, int regnum);
> > +	/** @write: Perform a C45 write transfer on the bus */
> 
> Mutatis mutandis, same thing here.

Otherwise the series LGTM. I think it would be preferable avoiding
reposting a largish series like this for such a minor change. I think
the series can be merged as-is and the above can be addressed with a
follow-up patch.

Cheers,

Paolo

