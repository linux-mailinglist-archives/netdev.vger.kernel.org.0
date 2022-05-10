Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B79AD52255A
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 22:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbiEJUVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 16:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbiEJUUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 16:20:53 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A95208234
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 13:20:49 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id n10so218400pjh.5
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 13:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VPY+BPFQANz3gDy7cqE3RCNN6lWRUXJ8ern2JoTstfU=;
        b=jXJ6JFzMblllvK795NI3FvQqpQcwPkVl0bVhyMK3o6LmyhiyVnc9pM+SKsWNtbwkrb
         vXm0gGlSLp7eTZ8a3YevY+oHmXKB8W/ilZrxw5RUlRCGLC2N3HG9SVP/c97aedgjRwhp
         wWaIxviwceQPsCLv0sWmrBE0Tj9PqDc3LgbWs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VPY+BPFQANz3gDy7cqE3RCNN6lWRUXJ8ern2JoTstfU=;
        b=FrGD+GAuwnJeSfC0DOTitm790hr0PtSTD3q0PZ8WSAqjhsbGNZKU5rGedOlvSHWQLK
         VNZJquJeF1plHP3EnX5dCFOVtmgBgjefOd/oNegFyuvxAXE5ndmxdI9Nq8zlxDLxcsK+
         sM3WOzcdmNwy/FXCEZcUmYM4GNx8RaUsDr1tN/DXL/IqDPTzfKkD9UIbq2ipxlMnU/6Q
         ME5A1IyB6Yw/Od7FGGZARFzN96TbqblDu3LBYmI3V5PE3LACQ99j4owhB3+Vycatnqq8
         RozL/KQJaUvKyTNr7xVSgcRSQtHyI4o3bTVn15005NozY+d0PMom0HngcLxjzCehyM75
         VY5Q==
X-Gm-Message-State: AOAM53327KI7B469ksLapEtodoiqnCV1t2p+B7Mm2sHjfHof6u7IObh4
        wwxjRX+XWJ1AFmLa5GfZai+OUQ==
X-Google-Smtp-Source: ABdhPJxDdK9krQAGRnUj2ALxtk0356084bzaUSCApoi5YQd/8+Z41ynrHVmWGvv4Q3NHHnQBRhfzLA==
X-Received: by 2002:a17:90b:4b01:b0:1dc:7405:dd62 with SMTP id lx1-20020a17090b4b0100b001dc7405dd62mr1604206pjb.160.1652214049398;
        Tue, 10 May 2022 13:20:49 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y11-20020a17090a644b00b001d95cdb62d4sm2256217pjm.33.2022.05.10.13.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 13:20:48 -0700 (PDT)
Date:   Tue, 10 May 2022 13:20:48 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Du Cheng <ducheng2@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Vlastimil Babka <vbabka@suse.cz>,
        William Kucharski <william.kucharski@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] niu: Add "overloaded" struct page union member
Message-ID: <202205101318.4980180F9@keescook>
References: <20220509222334.3544344-1-keescook@chromium.org>
 <YnoT+cBTNnPzzg8H@infradead.org>
 <202205100849.58D2C81@keescook>
 <YnqgjVoMDu5v9PNG@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnqgjVoMDu5v9PNG@casper.infradead.org>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 06:27:41PM +0100, Matthew Wilcox wrote:
> On Tue, May 10, 2022 at 08:50:47AM -0700, Kees Cook wrote:
> > On Tue, May 10, 2022 at 12:27:53AM -0700, Christoph Hellwig wrote:
> > > On Mon, May 09, 2022 at 03:23:33PM -0700, Kees Cook wrote:
> > > > The randstruct GCC plugin gets upset when it sees struct addresspace
> > > > (which is randomized) being assigned to a struct page (which is not
> > > > randomized):
> > > 
> > > Well, the right fix here is to remove this abuse from the driver, not
> > > to legitimize it as part of a "driver" patch touching a core mm header
> > 
> > Right, I didn't expect anyone to like the new "overloaded" member.
> > Mainly I'd just like to understand how niu _should_ be fixed. Is using
> > the "private" member the correct thing here?
> 
> Well ... no.  We're not entirely set up yet to go to the good answer
> that means we don't have to touch this driver again, and yet we're also
> in a situation where we'll need to touch this driver at some point in
> order to get rid of the way it abuses struct page before we can get to
> our good place.
> 
> The eventual good answer is that we declare a driver-private memdesc
> variant that has a ->link, ->base ->refcount and ->pfn (maybe it has more
> than that; I'd have to really understand this driver to be completely
> certain about what it needs).  Or perhaps there's a better way to handle
> driver-allocated memory for this kind of networking card that this driver
> should be converted to use.
> 
> I haven't looked into this case deeply enough to have strong thoughts
> about how we should handle it, both now and in the glorious future.

Okay, in the meantime, I'll just add a casting wrapper with a big
comment to explain what I understand about it with some pointers back to
this and prior threads. :)

Thanks!

-- 
Kees Cook
