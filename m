Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8EC50943B
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 02:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383432AbiDUAfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 20:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383429AbiDUAfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 20:35:14 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44981CFCC
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 17:32:26 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d14so2232667qtw.5
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 17:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=INPtuxJX22cS5P5/4/bkkKQpHzU+PTHXyMFJSOykm7k=;
        b=aPXcCM79WKRijXcj0HsaHrJgwNLhMvtTZC6vzwz4uPNpVBSEPeR3Yz7tLfAnqrcX6s
         O03tSsEF7z9+mYdMPa22T+/1bQj29whTjQTkrbmu9kqs0A46sAH44rS+WVHsg4lUnK4z
         nzS1GpO7LdaLq9HK2f648EtofABul7Yd1Scl46IypIKIfzXMZ5MfqF6dTtd6L8oh912h
         zHXEVmFoVcNHeQ+z/YkonQ4B0JMt4LiHG5yxmK+sSv33xH0S3ynnwNZI6ErB4fcxVC/K
         sXR7OiOzL+8OKDNeU0O1WON9ptxO1Cr3bP5kuC8NVTLokIx2ruFEe287Xedm3TpEiDBF
         61Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=INPtuxJX22cS5P5/4/bkkKQpHzU+PTHXyMFJSOykm7k=;
        b=MpciuB93Z4Xi35YjJNZduKPHnpD/d7CVOMxm3uGX4DWA3wd/HY9Ky5w0NawxXupEtN
         ntX9wVDiPJ6JjZxA34QcYLnFoV/OrXoWPxT286hqBCdCrLpxob9JoqkmCxNpaxuHc7XX
         VaSHebtJosja78t0iaPXPoFZGZ5XI3/KZtRqlxhknEtdELRVVe8+yjhQf8YX5N77wkL1
         5rKz2L0AaWIx0FHQkhTER91ryIUwDLGw4WA4nEBUvcrSWUHLo+RNSCibnvnKpeu4BtAu
         lprJktf3ridjHN6Omz5p7XQIcgDT3CRQeFI1KbktLkfAGU951pIYd1aeKVL6stMJ6GZr
         3WpQ==
X-Gm-Message-State: AOAM532nEqu8EbyBbbVvOSCyamqClSJOn5lQbOJxz7KakA+NCh60iRW8
        882gna0WzwfLUUcpqruv27Ruwp4hqx177oyjCf1l9sCayjY=
X-Google-Smtp-Source: ABdhPJxAGelvXh6pH3XeMdNwrpZBQSULChzyTenEOImaceS5SnpT4QCkMs+yXS1raMUddYHVtzD0uHb64bff0RApOZw=
X-Received: by 2002:ac8:5d8a:0:b0:2e2:f0f:4308 with SMTP id
 d10-20020ac85d8a000000b002e20f0f4308mr15944627qtx.618.1650501146059; Wed, 20
 Apr 2022 17:32:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220420235659.830155EC021C@us226.sjc.aristanetworks.com> <CANn89iJjwV2gAKMc4iydUt_MqtnB-4_EKdVrqQO9q4Dt17Lf9w@mail.gmail.com>
In-Reply-To: <CANn89iJjwV2gAKMc4iydUt_MqtnB-4_EKdVrqQO9q4Dt17Lf9w@mail.gmail.com>
From:   Francesco Ruggeri <fruggeri@arista.com>
Date:   Wed, 20 Apr 2022 17:32:15 -0700
Message-ID: <CA+HUmGiGE9sp3fyfobU6kx73-4zKx=i3KeBHqcCyiru3Z+3jrQ@mail.gmail.com>
Subject: Re: [PATCH] tcp: md5: incorrect tcp_header_len for incoming connections
To:     Eric Dumazet <edumazet@google.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 5:20 PM Eric Dumazet <edumazet@google.com> wrote:
> On Wed, Apr 20, 2022 at 4:57 PM Francesco Ruggeri <fruggeri@arista.com> wrote:
> This seems like a day-0 bug, right ?
>
> Do you agree on adding
>
> Fixes: cfb6eeb4c860 ("[TCP]: MD5 Signature Option (RFC2385) support.")
>
> Thanks.
>
I also think it is a day-0 bug. Should I resubmit with "Fixes:" ?
