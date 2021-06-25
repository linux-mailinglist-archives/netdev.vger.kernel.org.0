Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725533B4756
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 18:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhFYQXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 12:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhFYQXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 12:23:17 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51E6C061574;
        Fri, 25 Jun 2021 09:20:56 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id w15so3430404pgk.13;
        Fri, 25 Jun 2021 09:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=htPvWVA6EXYwx6R2EmjwW/HIupnQLxRcccuBJ1K1BUQ=;
        b=pgl5ycF5C72kQhDibUaNGeo3MuVrVtWtIYy1n9IibrZuK0hqLbLP1CQPe+iPX7hVDQ
         59fLD8VvB7ApA+mszVcRGMXITVz09Q6Ka6ll+DI+we9H86wHIH9w8sNEXs9ix6o6PKch
         +f2S9W+Yedqs6sPtonDT1QEq6hJh5EjXiRQYoWpAbjCkCGNyIwlXE3qEqH3FU6AAwzC7
         uIowu7jgusE7Tx2gmrgIxAs+YcP9D7wnehTpHH0t2xsdTh5bUTJCO3RdqEI+lMl5PHJp
         XwYjgYT4YWV0MB+omO91dseF3WJhR9DkfxGsHY526Uk+dvQObgQ863j/uwTqY8s20xZz
         neLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=htPvWVA6EXYwx6R2EmjwW/HIupnQLxRcccuBJ1K1BUQ=;
        b=ZAVEPywrZc18TyCcwDc6gPpRtUBQfwItzhI5uYoFchhk8+DZ5sQhwQLkUGCEyIfzph
         IsdY3fNxRC2aMhUPbGQAnfXXihAOydK7mQ8GyjbHCeAlvRsLnk6VHm3hpquo+oMV1FMe
         JpYkCplCEZbYF+wikGciZRh80Fa/HTJhg41m0anWnYb9womQXqF+SVfVo+pJghwsz9Tm
         KynQLsvnXcmm33AAHRpdGTS0Vu1yNZjNpkRzpzIR9IwUvdxF3YJ7SSgFpNFO0vVIl6BG
         FaSSy1ph/dvhhIs1MfKYvedlSFu0WbswbUyIsjwS2pLfIIKsG7FsrMvUm/mCl2Dzk3Tk
         j2uQ==
X-Gm-Message-State: AOAM531tzXsABmNdn30o2xmHJhYqxhyEggCvbzTumZiw6ByQnqhvt3tJ
        zshp9FS8fdOj+iyxZJavqjay3Dh7Oi8=
X-Google-Smtp-Source: ABdhPJyi+AxRDC20KKsil/43KorI+swZT/lmdRIzXGDbpplfV+4BkdOrTZb9otumPBX3nRJCi3oenA==
X-Received: by 2002:a63:e703:: with SMTP id b3mr4553858pgi.369.1624638056483;
        Fri, 25 Jun 2021 09:20:56 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id c14sm5786603pgv.86.2021.06.25.09.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 09:20:55 -0700 (PDT)
Date:   Fri, 25 Jun 2021 09:20:53 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Min Li <min.li.xe@renesas.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 1/2] ptp: idt82p33: optimize idt82p33_adjtime
Message-ID: <20210625162053.GA2017@hoboy.vegasvil.org>
References: <1624459585-31233-1-git-send-email-min.li.xe@renesas.com>
 <20210624034026.GA6853@hoboy.vegasvil.org>
 <OS3PR01MB6593D3DCF7CE756E260548B3BA079@OS3PR01MB6593.jpnprd01.prod.outlook.com>
 <20210624162029.GE15473@hoboy.vegasvil.org>
 <OS3PR01MB6593FC9D6C4C6FE67205DC69BA069@OS3PR01MB6593.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OS3PR01MB6593FC9D6C4C6FE67205DC69BA069@OS3PR01MB6593.jpnprd01.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 25, 2021 at 02:24:24PM +0000, Min Li wrote:
> How would you suggest to implement the change that make the new driver behavior optional?

I would say, module parameter or debugfs knob.

Thanks,
Richard
