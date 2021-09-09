Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5953440423E
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 02:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348655AbhIIAXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 20:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348562AbhIIAXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 20:23:06 -0400
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00ECAC0613C1
        for <netdev@vger.kernel.org>; Wed,  8 Sep 2021 17:21:57 -0700 (PDT)
Received: by mail-oo1-xc2a.google.com with SMTP id y47-20020a4a9832000000b00290fb9f6d3fso1210ooi.3
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 17:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=KrKQVNDq3/5gBSCRZh6fTEr0lGsTWylg4ncaoymesVE=;
        b=l2zLirahIdKfjSNP4/FhmOaIxi6RGKTtg2W5yfzqga9z8DM7mF8KKLqdVBbe3EVQU8
         B2mAb8Kiyg3jGUGCmKchEE2FUCQe8mgtNYWYqjHacr6zdJiQlA/FSaPoBXi+Hveldzji
         yG8fvl3sD+03w4y0+gHlZYwwEFTawa1SZd9SM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=KrKQVNDq3/5gBSCRZh6fTEr0lGsTWylg4ncaoymesVE=;
        b=EDcWaQSYbYPMY3t9br1T/aYFfX0jYPySjRUtvwAy6jG3v7CUEv8cITmYp8O/9A8mq9
         aCHG/QCvMZs8yTBC9m4pxr/4mNNxM7f7QKl0v7xOBpCcyv2aCm308wnkqLMQmBaOZ5Ia
         4IlZzkE0nZefwNnX6/tQx3YnmeDYx2dQJriVzxkFp+wXqHII/5P5V43FFp7n1A0O9HTc
         8D8s2m8Z6U2Rl3XakjaEDaHOYDd8kaMHHdvUJnfyE01TJ2IYiz1727YLHfGCC6Kt/h27
         mcD2FU2NoafyT6ede5ar8pkZq+t4Oa3knV6OpsDxmbeu/U1VdXwFcqtIIxCysRdI+XHm
         QFow==
X-Gm-Message-State: AOAM530QNiLqztJ5c4U/d/tVdf7i4JmLHOFp2iIr655CRhPbGcBENlsN
        3p7/WDZPDIACKc6pzWmLCpGjBZoE1y/WqED93K1DCg==
X-Google-Smtp-Source: ABdhPJxgF39MsLPy0LWbZeXGBUy3CFp7gIIfxNlCUhObTVORlW5XPn7pdgoxLbPwwQ0fUMnQfRUlseqsLjVZ7A4RYec=
X-Received: by 2002:a4a:9211:: with SMTP id f17mr259723ooh.25.1631146917250;
 Wed, 08 Sep 2021 17:21:57 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 8 Sep 2021 17:21:56 -0700
MIME-Version: 1.0
In-Reply-To: <CACTWRwsRLrKHRWVoHHyrU2DEc_VkhqSi66tdD2OBWs_y8J2LPw@mail.gmail.com>
References: <20210905210400.1157870-1-swboyd@chromium.org> <YTe+a0Gu7O6MEy2d@google.com>
 <CAE-0n52d_GBh70pSDXTrVkD5S6akP4O9YcE4tVRKZcvLtLZSmg@mail.gmail.com> <CACTWRwsRLrKHRWVoHHyrU2DEc_VkhqSi66tdD2OBWs_y8J2LPw@mail.gmail.com>
From:   Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.9.1
Date:   Wed, 8 Sep 2021 17:21:56 -0700
Message-ID: <CAE-0n50RUGTA8sfK52YWXRkoi31XYnJkahy_MydRZ0zM1QXRQg@mail.gmail.com>
Subject: Re: [PATCH] ath10k: Don't always treat modem stop events as crashes
To:     Abhishek Kumar <kuabhs@chromium.org>
Cc:     Matthias Kaehlcke <mka@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Youghandhar Chintala <youghand@codeaurora.org>,
        Rakesh Pillai <pillair@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Abhishek Kumar (2021-09-08 15:37:07)
>
> Overall this change should fix the issue, additionally I have one
> comment below and would like other reviewers views.
>
> >  #include <linux/regulator/consumer.h>
> > +#include <linux/remoteproc/qcom_rproc.h>
> >  #include <linux/of_address.h>
> We are adding an external dependency here but since this is added in
> snoc.c (which is for integrated solution only), I can expect if SNOC
> is enabled, remote proc will be enabled as well, so it should be fine.

There are stubs so that if it isn't enabled it won't do anything. But as
you say SNOC relies on the modem to boot, so maybe CONFIG_ATH10K_SNOC
should depend on some remoteproc config anyway? I'm not clear how probe
ordering works but I think we'll want to make sure that we only register
the notifier once the remoteproc driver for the modem adds itself to the
list of available strings to look for.
