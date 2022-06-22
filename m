Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C0C554BC4
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 15:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357456AbiFVNuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 09:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357564AbiFVNui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 09:50:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 91EC42FE7D
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 06:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655905836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YA6sKptcmrpC8zQUFl925QdKkaMW9muIiahiR3ucojo=;
        b=fd3Wrv0i+swPlefUQl9Yyig5ct50QNbo8MtDO8v5nmM7MyxyOUfMu/caKYVXYswTNpfJAp
        xg18UaytQfA/qj5i8n21fD9V9iXlf68oL9jpkw5ti92qNoHzILBvothPMtxhgTXcSs19QU
        E17zrOIfI9/4fehr/HTeo6oTPq3e66Q=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-xCBDDNylMme2dEQWByhl_A-1; Wed, 22 Jun 2022 09:50:35 -0400
X-MC-Unique: xCBDDNylMme2dEQWByhl_A-1
Received: by mail-wm1-f71.google.com with SMTP id l3-20020a05600c1d0300b0039c7efa2526so7875288wms.3
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 06:50:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=YA6sKptcmrpC8zQUFl925QdKkaMW9muIiahiR3ucojo=;
        b=fqVWQe8YbCzpPrgi1GiDIo0XwPTSyVDN4c9jBKHdA7ogu7NJ0bWCl36IiNVo0mHKwc
         R0W0mVWvWNZ+aDC6cBqk/YlDLXMHAGefUg+KIS6LoaeubfrJoEXrQa7U4P+2JGsUACvB
         wzVZ0yKZN4JSlSSO99Y1RYv6m7vabBVuLXcSY9CEBcWERlCVmUbJeSEC/lWkR1tyBF+3
         eN17GbETGkERdJ+YFqUIBrHVX+NFB2CEsGPNBP3xgj2bHzv1qbh6+TmGP9ZYk7AkxBLz
         q3D6peGWzML0l2WU9+3yrmTVkOMMO85rusq1enmHULUqile3oGYlzeEkRuahogizqrHV
         cQqg==
X-Gm-Message-State: AJIora/wPi53lkXCEJ4X9AaeCHU2+IxKLPX5IiLtlXUt+dlI0Pu7lxH5
        QQOpA/ZhTQNbYQ0Omu39PZZ3NmqCf6i4iqGLMyfNF5Uc+SOZSMsvTE1+FejRGBlZoMgbmwH689j
        kz/UXKKUH+SKzNCTD
X-Received: by 2002:a05:6000:2c8:b0:218:4982:7f90 with SMTP id o8-20020a05600002c800b0021849827f90mr3486033wry.64.1655905834025;
        Wed, 22 Jun 2022 06:50:34 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1saeeQ0wFdzlhaEBC839nxiwwfiHfW5MXqPmW9PEONuADB7+ttIHYERQD/a7QuYIzw1nTG4Xg==
X-Received: by 2002:a05:6000:2c8:b0:218:4982:7f90 with SMTP id o8-20020a05600002c800b0021849827f90mr3486019wry.64.1655905833824;
        Wed, 22 Jun 2022 06:50:33 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-113-202.dyn.eolo.it. [146.241.113.202])
        by smtp.gmail.com with ESMTPSA id g16-20020a05600c4ed000b003974860e15esm30442635wmq.40.2022.06.22.06.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 06:50:33 -0700 (PDT)
Message-ID: <b9ce4f5611a99091fa02666835a19ac028e0913d.camel@redhat.com>
Subject: Re: [PATCH net-next] net: pcs: xpcs: depends on PHYLINK in Kconfig
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Date:   Wed, 22 Jun 2022 15:50:31 +0200
In-Reply-To: <20220621125045.7e0a78c2@kernel.org>
References: <6959a6a51582e8bc2343824d0cee56f1db246e23.1655797997.git.pabeni@redhat.com>
         <20220621125045.7e0a78c2@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-06-21 at 12:50 -0700, Jakub Kicinski wrote:
> On Tue, 21 Jun 2022 09:55:35 +0200 Paolo Abeni wrote:
> > This is another attempt at fixing:
> > 
> > > > ERROR: modpost: "phylink_mii_c22_pcs_encode_advertisement" [drivers/net/pcs/pcs_xpcs.ko] undefined!
> > > > ERROR: modpost: "phylink_mii_c22_pcs_decode_state" [drivers/net/pcs/pcs_xpcs.ko] undefined!  
> > 
> > We can't select PHYLINK, or that will trigger a circular dependency
> > PHYLINK already selects PHYLIB, which in turn selects MDIO_DEVICE:
> > replacing the MDIO_DEVICE dependency with PHYLINK will pull all the
> > required configs.
> 
> We can't use depends with PHYLINK, AFAIU, because PHYLINK is not 
> a user-visible knob. Its always "select"ed and does not show up
> in {x,n,menu}config.

So I guess we should resort to 'select'ing all the needed dependencies
(we can't mix select and depend on, as per kconfig documentation)

I'll give it another shot before surrender

Thanks!

Paolo

