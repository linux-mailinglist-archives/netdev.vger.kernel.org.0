Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49EE96E31D3
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 16:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjDOO2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 10:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjDOO2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 10:28:12 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFDB4C22
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 07:28:11 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-50506111a6eso3188453a12.1
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 07:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681568889; x=1684160889;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vxAM7sdziQBIzfdXio0xWsHujF8VruNjyE9GZK7xqOg=;
        b=Lxk6wo1rKyHop754DYaXCMGO5MiUNDVFIxJrtuFhqA0jsYNc3K+sRm3+3bAd7I/t7p
         7LE5WDiqM9YwTlPmO2uo+nNQrV+l5e6XFI+9XxrMpp+6etQdGiTYp9UP8NwAQ/Etu8cK
         21Hqzc2m5giolLPePSE4vY8se8K6fDdx3xn6niI7ApsWFfY24DQ15pD7wV14fkU8y7ko
         BDhzVuy6wH3Hwg0CG519KJsWzv00vyxhNZtHi7CcyOmIrOfyEWB8RuV6pYNS3NDIBfGJ
         o48c7tcdjwkx/w59Zy5xv7vU7J/nHA1nn8OTkqD7MfULMZB5k3u+h5kjXfYYcA2wGLzZ
         cSVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681568889; x=1684160889;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vxAM7sdziQBIzfdXio0xWsHujF8VruNjyE9GZK7xqOg=;
        b=C4YbFx4tW6kvmYKK3J5cnzXLQLLmwXK+oukKoVa7VxRqdZJLp0aSMGjWzrGD5VUmCI
         DaxmY4W9fZPK+uFAFbcmJ/1lUn7gyoDY90T7jaf1hmb/yi4QaciDnbOQjj0dDBbJq5Ho
         d08JVngXRBmOHdRgxS73PdWcoS/DNlPOhHsymVJL568D3hD4TMjrP5OzRZeHqFisd7Tu
         GYGA/Hr/Po58nv9mI7lqSK2VD4jYQ30n5+mFTqEPZCLt6tK7H9QH1hp55aHWf54o96hE
         EuoOeEx5zG+ClhTsTgIUgObwW8AtKoP3QHYPVl/ReZTmsU7+JKbcuMi6g3/OVMbfLYXX
         A/AQ==
X-Gm-Message-State: AAQBX9fZ/Fcwo4f0JACMOa5xJASm7oP3pnvWdNY5G2JtQtGcSVIDuwlH
        Fj2lJIjmdsWTWg/oiuLUIIw=
X-Google-Smtp-Source: AKy350beA4/Apy5WIX5/ycVPVwc9UDYdiKnhLW/7ssLWP+sh3qPB5EnrYAQfyi5HV4KATj6aaG5aoQ==
X-Received: by 2002:a05:6402:748:b0:504:b01c:cc53 with SMTP id p8-20020a056402074800b00504b01ccc53mr8298213edy.1.1681568889442;
        Sat, 15 Apr 2023 07:28:09 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id 23-20020a508e17000000b0050692cfc24asm732703edw.16.2023.04.15.07.28.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 07:28:09 -0700 (PDT)
Date:   Sat, 15 Apr 2023 17:28:07 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
        Thibaut <hacks@slashdirt.org>
Subject: Re: mt7530: dsa_switch_parse_of() fails, causes probe code to run
 twice
Message-ID: <20230415142807.uzgznv7cklwbeyg7@skbuf>
References: <5e10f823-88f1-053a-d691-6bc900bd85a6@arinc9.com>
 <ZDn1QabUsyZj6J0M@makrotopia.org>
 <01fe9c85-f1e0-107a-6fb7-e643fb76544e@arinc9.com>
 <ZDqb9zrxaZywP5QZ@makrotopia.org>
 <9284c5c0-3295-92a5-eccc-a7b3080f8915@arinc9.com>
 <20230415133813.d4et4oet53ifg2gi@skbuf>
 <5f7d58ba-60c8-f635-a06d-a041588f64da@arinc9.com>
 <20230415134604.2mw3iodnrd2savs3@skbuf>
 <ZDquYkt_5Ku2ysSA@makrotopia.org>
 <20230415142014.katsq5axop6gov3i@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230415142014.katsq5axop6gov3i@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 15, 2023 at 05:20:14PM +0300, Vladimir Oltean wrote:
> On Sat, Apr 15, 2023 at 03:02:10PM +0100, Daniel Golle wrote:
> > As the PHYs are accessed over the MDIO bus which is exposed by the mt7530.c
> > DSA driver the only middle ground would possibly be to introduce a MFD
> > driver taking care of creating the bus access regmap (MDIO vs. MDIO) and
> > expose the mt7530-controlled MDIO bus.
> 
> Which is something I had already mentioned as a possible way forward in
> the other thread. One would need to take care of ensuring a reasonable
> migration path in terms of device tree compatibility though.

You mention the PHYs because you seem to suggest that the PHY muxing
code should go there. I think it would also be possible to just put it
in this new MFD parent driver of the DSA switch, which is in fact what
I had originally suggested.
