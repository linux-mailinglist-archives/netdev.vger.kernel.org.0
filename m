Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E1A52202F
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346367AbiEJP6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347672AbiEJP55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:57:57 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEDA37A8E
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 08:50:51 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id c9so16408784plh.2
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 08:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HPEV8t7jSxF/R5wTa8pBC5XtbUyCWP3bZNNHdlQWnUs=;
        b=mPax2Elz/ydEtyd6iMyTyMpV7MjOnqrmn0tJyEuV7p8EwcqHHocAkg5aJC6Be4rkXM
         CGesdkXTN7ozO1xNN/gixirXA3OEw1iTlRvxlj7Y/cr+3EJ2X3CWnbwC4Q2fTW07S+7c
         8SsqtqT9vF9l67g+AiD+hOwoYFSxj3+I4cdhc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HPEV8t7jSxF/R5wTa8pBC5XtbUyCWP3bZNNHdlQWnUs=;
        b=n5mTIv4bUWfCT2mK3WwTa+hlLy908OJOAewuldyWnaoM+1k4BzWBvg0HVS1anKubuE
         gK0WjFG/mSk7XIgrCNIOaLAwEkVh3lNy2RhWv/lLrTLS5eTPXIptMyZ9AThnRkPXoiaM
         uXMTazCwV6E253GMuyq6uIqGCMQAORh/wfgZpQVmbmXZcZ51tR0XgARgOdN7NDlgNf6Q
         kWZrCtgz/q7ERBJR8iqnKpWCTXkDeQR98WKjj2PiVdI9SfXHf2/FC2OnSU1fT7KmimAX
         16J7N/5juQ39cHKUnVbL5YTWnIF3jg6d4kmePDtD0x+5ed6qySDcXqQ2ldZzcm8w3+mK
         9uoQ==
X-Gm-Message-State: AOAM532gnkklsgeq+ZB6DDXGspERuydofVu33LYWqQGHVuct8oP2qpk1
        ysxwvbNL9BW2LVAriWJqU+ZkMA==
X-Google-Smtp-Source: ABdhPJzJ61GrS1rxWQD481NZXRytu8/Kix6yH+jgxvnppV/676fdcePFo/cIUerrTCnluyiEXgcWpA==
X-Received: by 2002:a17:903:213:b0:15f:4ea:cd63 with SMTP id r19-20020a170903021300b0015f04eacd63mr13256429plh.68.1652197848816;
        Tue, 10 May 2022 08:50:48 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id v22-20020a636116000000b003c14af505fdsm10713363pgb.21.2022.05.10.08.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 08:50:48 -0700 (PDT)
Date:   Tue, 10 May 2022 08:50:47 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
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
Message-ID: <202205100849.58D2C81@keescook>
References: <20220509222334.3544344-1-keescook@chromium.org>
 <YnoT+cBTNnPzzg8H@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnoT+cBTNnPzzg8H@infradead.org>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 12:27:53AM -0700, Christoph Hellwig wrote:
> On Mon, May 09, 2022 at 03:23:33PM -0700, Kees Cook wrote:
> > The randstruct GCC plugin gets upset when it sees struct addresspace
> > (which is randomized) being assigned to a struct page (which is not
> > randomized):
> 
> Well, the right fix here is to remove this abuse from the driver, not
> to legitimize it as part of a "driver" patch touching a core mm header

Right, I didn't expect anyone to like the new "overloaded" member.
Mainly I'd just like to understand how niu _should_ be fixed. Is using
the "private" member the correct thing here?

> that doesn't even cc the mm list.

Oops, yes, sorry.

-- 
Kees Cook
