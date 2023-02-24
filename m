Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C79F6A23E4
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 22:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjBXVjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 16:39:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBXVjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 16:39:53 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38722580FD
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 13:39:52 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id oe18-20020a17090b395200b00236a0d55d3aso610170pjb.3
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 13:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/0U15SCPfIqC0m6RYPP1r/3VMkd/wkwS9VeVBVrqXrU=;
        b=lVbsh+JAQm9KLX22cboY+0x5+SxBfp+DmxmNW3BfdqOSRuS2TIEvatRUELvE4EL4bP
         LY7t8B+z/ivHwgQsshtk9bzikpNyM/CujqYRsPbTMekP9q1HKWSMBI4W0xkZnYVceEmT
         mWK6KqjqO6rb1tvHumq1YRMawzyPayHjp9YMs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/0U15SCPfIqC0m6RYPP1r/3VMkd/wkwS9VeVBVrqXrU=;
        b=rSDMmiuG0gcPx1swiVk2BlkUuK2mXAlzSgY6qTsMk4IjcirIKe2o10kKu+DqS/k3dk
         PV5ocpS2hy1FKk2SOug2wvwIxl+sny2gHU/JTdbhNBxiDPdkl1VS2njihyG8MPH6OdI0
         MRhxQEHejqlNTzoG0c5jD/y1doea7hzHYW0f5ofeA3ChImzS4Ew7MtM7G3L3aRxRMJ1L
         6EaCWhqhaswCvxdfwLiaAKqRdOKex6ngAVQewMhfhvUJ51yikkeD4IcCBSI/u/MHFQ4s
         qhow9wGOF3i4g8E4XaA+jPotEsmAntw6Mrbefp9pUUtIykXZ8929i9yurxNxL8+Hsg8I
         64TA==
X-Gm-Message-State: AO0yUKWpvwZ5h9EoooQvhj7Ak8QmMzY8UGPKIwNNm9oVnmWolg26LrJT
        R+iJOtCxstFMFS1a8nWq/16fnQ==
X-Google-Smtp-Source: AK7set9BbuYHHXnFHfMPPUgDVlsItcAL3sZ8dyfXgjAcXKnlZht64MAY/RK1Wp7HeHbkHd7PGJS6fA==
X-Received: by 2002:a05:6a21:6da2:b0:c7:8779:4167 with SMTP id wl34-20020a056a216da200b000c787794167mr19752281pzb.30.1677274791410;
        Fri, 24 Feb 2023 13:39:51 -0800 (PST)
Received: from google.com ([2620:15c:9d:2:b4b7:a941:f40c:bd01])
        by smtp.gmail.com with ESMTPSA id p18-20020a62ab12000000b005ae02dc6285sm5825pff.203.2023.02.24.13.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 13:39:50 -0800 (PST)
Date:   Fri, 24 Feb 2023 13:39:48 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     Zheng Hacker <hackerzheng666@gmail.com>
Cc:     Zheng Wang <zyytlz.wz@163.com>, ganapathi017@gmail.com,
        alex000young@gmail.com, amitkarwar@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mwifiex: Fix use-after-free bug due to race condition
 between main thread thread and timer thread
Message-ID: <Y/kupIIGBHQ2rQIZ@google.com>
References: <20230218075956.1563118-1-zyytlz.wz@163.com>
 <Y/U+w7aMc+BttZwl@google.com>
 <CAJedcCzmnZCR=XF+zKHiJ+8PNK88sXFDm5n=RnwcTnJfO0ihOw@mail.gmail.com>
 <Y/aHHSkUOsOsU+Kq@google.com>
 <CAJedcCykky7E_uyeU=Pj1HR0rcpUTF1tKJ-2UmmM33bweDg=yw@mail.gmail.com>
 <CAJedcCztEkE=EB2GmH=BpTvD=r_bwGXk3RYDM2FU=f_SvEaJHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJedcCztEkE=EB2GmH=BpTvD=r_bwGXk3RYDM2FU=f_SvEaJHA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 02:17:59PM +0800, Zheng Hacker wrote:
> This email is broken for the statement is too long, Here is the newest email.

It still wraps a bit weird, but it's good enough I suppose.

>               retn -EINPROGRESS in mwifiex_init_fw
>               mwifiex_free_adapter when in error

These two statements don't connect. _mwifiex_fw_dpc() only treats -1 as
a true error; -EINPROGRESS is treated as success, such that we continue
to wait for the command response. Now, we might hang here if that
response doesn't come, but that's a different problem...

I'm sure there are true bugs in here somewhere, but I've spent enough
time reading your incorrect reports and don't plan to spend more. (If
you're lucky, maybe you can pique my curiosity again, but don't count on
it.)

Regards,
Brian
