Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5EB5E7EF9
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiIWPvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiIWPvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:51:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F4C11BCF4
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 08:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663948260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sIY1eBZsBzz38sEKJdEiK7k2L4IYric1woaCS3V87Qo=;
        b=ZhSE0WBNKgJvXRHPCIhnkM5KqHFsvXIupDjAr/jJNGfYOsDq4xhL5ulF1MREhvzS9Bz7bL
        o51mX1Nyk3u9et8U0QhPG+fLc4CQIvvo4yJXjKJY/wBdi9+rIwtDcYse55/81zKzvTqgB1
        asW1SRhGx9SyFWBtoVQkjnS7K7yHOkE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-2-_JJAbnfLMKaERX5CuQ6_DA-1; Fri, 23 Sep 2022 11:49:35 -0400
X-MC-Unique: _JJAbnfLMKaERX5CuQ6_DA-1
Received: by mail-wr1-f70.google.com with SMTP id e18-20020adfa452000000b00228a420c389so101917wra.16
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 08:49:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=sIY1eBZsBzz38sEKJdEiK7k2L4IYric1woaCS3V87Qo=;
        b=pe4wRbcYVODBdN0R2yFHBcIZcteDYNi07AToEjQ+IqfYJb7DWF6TdLNLGTycoSPjZf
         f83kbUB7OEtnWTR5lWNLBh8LeSmccu+BmC0nBOntjbDkwg78YUJLL5bC/C5H1aswpL29
         5ZE48dXW2XFp9PCceXMz6ncfnD6jwO85QshG6mQ+WF4sGzOfuW2wf8ExJaqgMadp7jCh
         F0CxzWeCPhCiGdp/yQIOU8NhDWhlfUKProMoLBgeCauVjsnp/DyoS5UeyEZpMEaGo7OT
         8hw3p8aYwCTmm25jnFOeipzi+tXpl1BW+Be9vQFQXyRPMw+vjo1gf21Da4PNeeU4vQg0
         7rCQ==
X-Gm-Message-State: ACrzQf3ik3LX9AuNRet1vVkkwMjQ92zSvbXIhKdjehWk+qJkxXxmNboV
        sItXK0Mqh33uBJk5LEBl7bI8nSqOn7Y1rUn2YE6YtjL5VnV7jyPSKBG26DCI6I92eGmNbhCvoeH
        EdNUqx44lL5VxHLQu
X-Received: by 2002:a05:600c:3511:b0:3b4:bb85:f1dd with SMTP id h17-20020a05600c351100b003b4bb85f1ddmr6454475wmq.42.1663948173921;
        Fri, 23 Sep 2022 08:49:33 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5EwlrxtrnxSx8Q8kPS8TBsY7xJXhkXVvbmyinO8Tsf5qvESW6LDIgdQTJC4yP+lKasW6ZmBw==
X-Received: by 2002:a05:600c:3511:b0:3b4:bb85:f1dd with SMTP id h17-20020a05600c351100b003b4bb85f1ddmr6454455wmq.42.1663948173744;
        Fri, 23 Sep 2022 08:49:33 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id l8-20020a5d5268000000b0022a839d053csm7796856wrc.98.2022.09.23.08.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 08:49:33 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v4 0/7] sched, net: NUMA-aware CPU spreading interface
In-Reply-To: <Yy3UYPU3noB7UtGX@yury-laptop>
References: <20220923132527.1001870-1-vschneid@redhat.com>
 <Yy3UYPU3noB7UtGX@yury-laptop>
Date:   Fri, 23 Sep 2022 16:49:32 +0100
Message-ID: <xhsmhtu4y146r.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/09/22 08:44, Yury Norov wrote:
> On Fri, Sep 23, 2022 at 02:25:20PM +0100, Valentin Schneider wrote:
>> Hi folks,
>
> Hi,
>
> I received only 1st patch of the series. Can you give me a link for
> the full series so that I'll see how the new API is used?
>

Sigh, I got this when sending these out:

  4.3.0 Temporary System Problem.  Try again later (10)

I'm going to re-send the missing ones and *hopefully* have them thread
properly. Sorry about that.

