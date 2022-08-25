Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5545A1D07
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 01:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244214AbiHYXUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 19:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244163AbiHYXU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 19:20:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01FD33A23
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 16:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661469626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NsyNVP005GqHR+ZDAjrOhFy3KuxEEcYrhlufP12Pz6w=;
        b=Jw7qjORmbKYmoL7asXKvm9mHBiFFr48c3iYfHID6iOm0tID6A/we/8Eapvb7qjSGt3cdL0
        b8yFm91FqxOZf6WpBsRcQrOqVpTclceC5wpjeWJs5Xyw8uBoGqMr4rmHtK0ZaCAePTXAuw
        jRm3x+4rI95FtvH6bFYVXbqVBvZhF9w=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-374-NTu5-EpFNdaythgciDXoBg-1; Thu, 25 Aug 2022 19:20:25 -0400
X-MC-Unique: NTu5-EpFNdaythgciDXoBg-1
Received: by mail-wr1-f70.google.com with SMTP id r23-20020adfa157000000b00225660d47b7so1821547wrr.6
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 16:20:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=NsyNVP005GqHR+ZDAjrOhFy3KuxEEcYrhlufP12Pz6w=;
        b=lCVP4ebonu/YhAbZ85ML5+PNR5usxunxBkASHVqNBr8ZDjOFPaubZd1klifyyPq3K4
         BnOWwN30/KqCCo8Jon8DbTFc2H6s+UiroslEnBaRacFGgJqrObc1CdowODim4zLYnIGu
         VnYdLb61P5Qo/1qLMitYW40DM4PKWUkbm3e0TtCM1cdliVTpwiUry4R3fPUxvoq+LWBM
         HRzthaipxz7TM6WED3W8tXvS6ovwtYorTPE3scdP74XzF+h7E6eOYf7rbnH8WrbmWE5k
         XBBkM7CLcX87fxUV+GdUtgSEzZYX3eMctcKx0RWo7h3yiuMMdYkpee32jW26IDJddXis
         91og==
X-Gm-Message-State: ACgBeo2P9YreBsPo2ZgQv0BSBufag9h0/dk1qeuJsgiVAe9KUbXh0IZn
        OBfqwInL4+1Rxz/YKmk37F0kid/SQQeZS0G0lju7IrPm0zhvjfYKmlwJmJQCiCbpevxXHDN+CTD
        ig+2bcF4Jg8U15VTL
X-Received: by 2002:a05:600c:1405:b0:3a6:1ac5:3952 with SMTP id g5-20020a05600c140500b003a61ac53952mr9087515wmi.99.1661469624698;
        Thu, 25 Aug 2022 16:20:24 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5AytvKf7xbC2sZlQpqwvcTIQgNvxwTgOAfWrmpDj0dTzVZcxhtvVKkkE9gF29ELMvMSP5Yyg==
X-Received: by 2002:a05:600c:1405:b0:3a6:1ac5:3952 with SMTP id g5-20020a05600c140500b003a61ac53952mr9087508wmi.99.1661469624509;
        Thu, 25 Aug 2022 16:20:24 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id by6-20020a056000098600b0021f15514e7fsm604309wrb.0.2022.08.25.16.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 16:20:24 -0700 (PDT)
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
Subject: Re: [PATCH v3 6/9] sched/core: Merge
 cpumask_andnot()+for_each_cpu() into for_each_cpu_andnot()
In-Reply-To: <YwfmqT70LsZmCiiG@yury-laptop>
References: <20220825181210.284283-1-vschneid@redhat.com>
 <20220825181210.284283-7-vschneid@redhat.com>
 <YwfmqT70LsZmCiiG@yury-laptop>
Date:   Fri, 26 Aug 2022 00:20:22 +0100
Message-ID: <xhsmhmtbrgbbd.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/08/22 14:16, Yury Norov wrote:
> On Thu, Aug 25, 2022 at 07:12:07PM +0100, Valentin Schneider wrote:
>> This removes the second use of the sched_core_mask temporary mask.
>>
>> Signed-off-by: Valentin Schneider <vschneid@redhat.com>
>
> Suggested-by: Yury Norov <yury.norov@gmail.com>
>

Indeed, forgot that one, sorry!

