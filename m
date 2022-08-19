Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7B5F599A4C
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 13:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348466AbiHSLAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 07:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348493AbiHSLAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 07:00:48 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4881F4395
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 04:00:46 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id w3so5213138edc.2
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 04:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=NTuYtz45OTzgfZ+x+Aj19aUxf6nI/Yc+IgIaRJUK9zA=;
        b=oU8gmSHLps+7FnU9SKDLmHwA9hzuMm0IvWlK4oK0Q/rGs/ENxFWUpPPbTS0FpOHeR/
         ChQnkfMCFR0vCUwnlUUraTHcOR+H96g1zbnoeFuBN7GSPonPtozlRpxDSQurAakYP7y0
         cW28DI8ZcXeJBSNDmhjmrwWmW6DZijWXyFT/7k3sY6ypoXCYEJgLao/1Pxcz8dq6cfwG
         x/zRr7tm2ZM6ykcHTH6YfxOZCc86mzHqEJMChKnLS07fI9nJrhimOFZHC/k6v8ydQNEp
         uXyHBIHFT2xD5rfmLYCozT5z2MGwLmzFg8ZwKUQAZv58Q4ukGXnCgKzaAptkgMWzHzxL
         rPzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=NTuYtz45OTzgfZ+x+Aj19aUxf6nI/Yc+IgIaRJUK9zA=;
        b=JG7z51Wq++fJRzSEfnBg9OVcaV08uPOh6+srCnKbrmQh0G+v0ayDiXJeoes1442RkE
         HYuz/GwyqGWcuG/EjanB9+FNs+0XUJ9a3hfJ/+r84jaj/GtZwj1KaCOMX5J0/oub5Vgq
         OZScmfxCVwKCvW1KsylO3OzWuDk8ABZZ1TQROJsW8ltktsO+gXjXFbKUsoTnAgsuudDF
         +dzt934RYYUMH7Hvo+l29JI9t8EcDTew6k+ZsPRqpjHp/Gt84IzlNLPXNrakzZvSttwK
         gjHbasomOmvxaXq1jDHsa7Th9W4Nc13a80yzL5wqPLrymdsJDL92eluG3pv3cNqcItGb
         o9pA==
X-Gm-Message-State: ACgBeo08KDgcWvAX5ScUVHlY6WxEDHr07aPk6fMfO0q5FDv2slpfU7RW
        W/DULyrEOlh17EScoI/M7N5BVqeF6VE=
X-Google-Smtp-Source: AA6agR5F4r6aLxbranfG1Z9fEGA7ru2BpBOCegZ+lELjxaALmIhb0gL41V3Vc54NPKbp2skJPmwGWA==
X-Received: by 2002:a05:6402:43c8:b0:445:d773:c1ac with SMTP id p8-20020a05640243c800b00445d773c1acmr5821576edc.309.1660906845145;
        Fri, 19 Aug 2022 04:00:45 -0700 (PDT)
Received: from skbuf ([188.25.231.48])
        by smtp.gmail.com with ESMTPSA id s15-20020a056402164f00b0043d1a9f6e4asm2903533edx.9.2022.08.19.04.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 04:00:43 -0700 (PDT)
Date:   Fri, 19 Aug 2022 14:00:41 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 2/2] net: moxa: prevent double-mapping of DMA areas
Message-ID: <20220819110041.l3ww5xlxjx7bqx7d@skbuf>
References: <20220818182948.931712-1-saproj@gmail.com>
 <20220818182948.931712-2-saproj@gmail.com>
 <Yv6SiQgzKSRL1Zy6@lunn.ch>
 <CABikg9zym9rzcP+uabijRwuWa9NC5pQPp+bMbPFZFBSsVOX2Lg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABikg9zym9rzcP+uabijRwuWa9NC5pQPp+bMbPFZFBSsVOX2Lg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 11:12:11AM +0300, Sergei Antonov wrote:
> On Thu, 18 Aug 2022 at 22:27, Andrew Lunn <andrew@lunn.ch> wrote:
> > > Unmap RX memory areas in moxart_mac_stop(), so that moxart_mac_open()
> > > will map them anew instead of double-mapping. To avoid code duplication,
> > > create a new function moxart_mac_unmap_rx(). Nullify unmapped pointers to
> > > prevent double-unmapping (ex: moxart_mac_stop(), then moxart_remove()).
> >
> > This makes the code symmetric, which is good.
> >
> > However, moxart_mac_free_memory() will also free the descriptors,
> > which is not required. moxart_remove() should undo what the probe did,
> > nothing more.
> 
> Having considered your comments, I now think I should make another
> patch, which fixes two problems at once. To unmap DMA areas only in
> moxart_mac_stop() and not in moxart_remove(). It will fix error
> unwinding during probe and double-mapping on link down, link up. It
> will be correct if Linux always calls moxart_mac_stop() before calling
> moxart_remove().

The way this is supposed to work is that from moxart_remove() you call
unregister_netdev(), and this calls dev_close[_many]() internally. The
dev_close() method calls your ndo_stop callback.
