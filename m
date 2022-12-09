Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22016648A9A
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 23:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbiLIWJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 17:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiLIWIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 17:08:54 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF046F48B;
        Fri,  9 Dec 2022 14:08:03 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id bg10so942784wmb.1;
        Fri, 09 Dec 2022 14:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mzj3qyQItGAAsYBfHeM0+6Yfzhg3iJO8a7fLkUF6aMs=;
        b=DaP4ldgMJxXb/dfYJd0Y9dqxOlLP7qkZu525rINlFJBN9QZx+vMCeMFlGyq6gdiNPk
         dJGvnJtAZZlmtfTkjymrNhWMJtfswE7bql0dARpwxCyjB0RIXpFXG+dnmoqQRHqCmyjV
         a5b8Pu5io0gBTRrk9Pv5NIDhnJ6IM02hT++MNYW826f/hHUgDE1jmiZweMoEimDV7w9m
         CmacaVdJomfeBUBrBu/xY5fRlTi+NCT0Cxz6Au4joV6/LTa6QrvemzbCL+SaTJ1qdX5s
         bZkAtfNGrtVCoQSIlRIP3q5RJ8emD4tyF6fhjr1Fd1U406JgxdT3wR7T7MZ8XE1yuSwe
         Wj/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mzj3qyQItGAAsYBfHeM0+6Yfzhg3iJO8a7fLkUF6aMs=;
        b=YLIGScBrljHkRFXdbISw623Wi9ba1tD/Tw1rcWjOE1tPvDcvJJo9I/kenYDULAy+TO
         kPszKnyWVBcARcboQPv9CSQF3NNI4u4QZaDto1DwadSOa7TtV6TNm1hA/2yn4cmmugJU
         e4IjCUCopCXVuA9obnXUcCF3oNTcfGqRkiV1AvxIqwWvLIXyX4oG1yXGrWIcKEQlvOKk
         vUUoIxTSp1jx6cOCp4/MgYFVVxW9vWJFO4n/nUZVslMmXwkgzzrqYsnMwn0KdvaN5Tvk
         oAErKYwmgvB9pZooy8+BZf4aNPlRLn6cQm9KkjexGLkmnkVRpBAwWzy0R2wo/rSqjLuX
         GFtw==
X-Gm-Message-State: ANoB5pkDDautHybN2U5nCYsmh9/Zv7WTbwCmFJRr5hZjveX1eSfEughI
        if4kK9AoLTLRK4/e5SgmLUo=
X-Google-Smtp-Source: AA0mqf6qAxahS5L+cAQNa13hQaEO7gVqjYPrnk9VazYoGp7dU4ZDGVFwPmQSibSaljrfVil0S0L0uA==
X-Received: by 2002:a05:600c:1c25:b0:3d0:a768:a702 with SMTP id j37-20020a05600c1c2500b003d0a768a702mr6043289wms.19.1670623681499;
        Fri, 09 Dec 2022 14:08:01 -0800 (PST)
Received: from skbuf ([188.27.185.190])
        by smtp.gmail.com with ESMTPSA id i28-20020a1709067a5c00b007b4bc423b41sm345341ejo.190.2022.12.09.14.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 14:08:01 -0800 (PST)
Date:   Sat, 10 Dec 2022 00:07:59 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Uladzislau Koshchanka <koshchanka@gmail.com>
Cc:     Dan Carpenter <error27@gmail.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] lib: packing: fix shift wrapping in bit_reverse()
Message-ID: <20221209220759.ilbmtf5htncyhiwq@skbuf>
References: <Y5B3sAcS6qKSt+lS@kili>
 <CAHktU2C00J7wY5uDbbScxwb0fD2kwUH+-=hgS5o_Timemh0Auw@mail.gmail.com>
 <20221209143024.ad4cckonv4c3yhxd@skbuf>
 <CAHktU2A2MQ4hW0WYcLDXuCuMsN84OmfrnrhTiOKqvHB_oFaVwg@mail.gmail.com>
 <20221209220651.i43mxhz5aczhhjgs@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209220651.i43mxhz5aczhhjgs@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 10, 2022 at 12:06:51AM +0200, Vladimir Oltean wrote:
> On Sat, Dec 10, 2022 at 12:01:28AM +0300, Uladzislau Koshchanka wrote:
> > Hi Vladimir,
> > 
> > > The problem I see with bitrev8 is that the byte_rev_table[] can
> > > seemingly be built as a module (the BITREVERSE Kconfig knob is tristate,
> > > and btw your patch doesn't make PACKING select BITREVERSE). But PACKING
> > > is bool. IIRC, I got comments during review that it's not worth making
> > > packing a module, but I may remember wrong.
> > 
> > Do you really think it's a problem? I personally would just select
> > BITREVERSE with/without making PACKING tristate. BITREVERSE is already
> > selected by CRC32 which defaults to y, so just adding a select isn't a
> > change in the default. Can't think of a practical point in avoiding
> > linking against 256 bytes here.
> > 
> > In any case, it just doesn't look right to have multiple bit-reverse
> > implementations only because of Kconfig relations.
> 
> Ok, let's use BITREVERSE then. Could you submit your patch formally please?

Also, none of that 'while at it, do XYZ unrelated stuff'. One patch per
logical change please.
