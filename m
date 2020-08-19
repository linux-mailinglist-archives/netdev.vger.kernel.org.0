Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7953C249EF0
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 15:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbgHSNDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 09:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728529AbgHSNCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 09:02:02 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325E3C061345
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 06:01:00 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id j13so1083838pjd.4
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 06:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qNJVZUa8vOnjh3Y4FbI7cu96rnOZczrpWszoc4OM35E=;
        b=ZtDUAentzHDOfXLt1WNpX0PqLZgZi3vnfEc6anllVjv7Z89UoKoCCMUiljAdsTAGBL
         DEVHOWuWzMZeIuJcHwUlptWZjkCaOp1ZUKAoSs/2jyyTPejnx1zCbjPUY7C9na+Ftk+x
         wpw/pPjI4UYNDosNdy4j7LcDWUJhwNxLapyy4W7f1U00+fT6jVYw1uO8CMpHCStxGd8w
         JLOisGYqnJmeY5ie8I+x4A4vKZtwoQ6PsaOc8UAPD7eTAFlJwORflpx8o8EPJZR8cuSG
         1j977OWh0YEI5r2DXie/ItwJ0iuosRobp25OObO0Ld6mXVix+wRg8r73enQ5lMOcXAoG
         tjpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qNJVZUa8vOnjh3Y4FbI7cu96rnOZczrpWszoc4OM35E=;
        b=IbU2He7TKP3iinjE173cPynvfAb0vyhbb788Ivn7sA1YNbFuCue73eNdGwKyEZwy0a
         Wcf8AvkJ8LOYemkhKs6PsIHvGRMcmh8MwNHuRKqyridB4iGmjsBBsV5EaFekCgiHZC05
         mpo9TgvGwQnUQ1zCERh7nbeKxf5USo6CkmB+Dmd39Q47/nvOFDb5W7HKgSuDIYkCbg6z
         SbTo8HAomxGV4k5mnuDcjZ/yYWzrSoW99QMAc0yHPl+AxO+mPA6Tv/lktZ8UsaqW2naj
         FJzRX7CCKUO43CknW+3PogMsLxnGTmJKRbE9qCW1nwykeFj8LItIc2cccYAma0OFfOor
         NNdg==
X-Gm-Message-State: AOAM533nkXCV+U4ls7jQqwvyJwDzyVSk/oVEuPdxwWrDJ2Ydr4haFsdd
        te6Zw1sLjnETODF1T2JbLAbRyw==
X-Google-Smtp-Source: ABdhPJwcWyLwqgVIDq5QVfeKWIJZ1zweeStVncOtMpfxCFFFEuEh0sSa6pW/Ah5NefbMm4I9GwEzLw==
X-Received: by 2002:a17:90b:285:: with SMTP id az5mr3983315pjb.118.1597842058708;
        Wed, 19 Aug 2020 06:00:58 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id d23sm20502027pgm.11.2020.08.19.06.00.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2020 06:00:58 -0700 (PDT)
Subject: Re: [PATCH] block: convert tasklets to use new tasklet_setup() API
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Kees Cook <keescook@chromium.org>
Cc:     Allen Pais <allen.cryptic@gmail.com>, jdike@addtoit.com,
        richard@nod.at, anton.ivanov@cambridgegreys.com, 3chas3@gmail.com,
        stefanr@s5r6.in-berlin.de, airlied@linux.ie, daniel@ffwll.ch,
        sre@kernel.org, kys@microsoft.com, deller@gmx.de,
        dmitry.torokhov@gmail.com, jassisinghbrar@gmail.com,
        shawnguo@kernel.org, s.hauer@pengutronix.de,
        maximlevitsky@gmail.com, oakad@yahoo.com, ulf.hansson@linaro.org,
        mporter@kernel.crashing.org, alex.bou9@gmail.com,
        broonie@kernel.org, martyn@welchs.me.uk, manohar.vanga@gmail.com,
        mitch@sfgoth.com, davem@davemloft.net, kuba@kernel.org,
        linux-um@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-block@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        openipmi-developer@lists.sourceforge.net,
        linux1394-devel@lists.sourceforge.net,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-hyperv@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-input@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-s390@vger.kernel.org,
        linux-spi@vger.kernel.org, devel@driverdev.osuosl.org,
        Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
References: <20200817091617.28119-1-allen.cryptic@gmail.com>
 <20200817091617.28119-2-allen.cryptic@gmail.com>
 <b5508ca4-0641-7265-2939-5f03cbfab2e2@kernel.dk>
 <202008171228.29E6B3BB@keescook>
 <161b75f1-4e88-dcdf-42e8-b22504d7525c@kernel.dk>
 <202008171246.80287CDCA@keescook>
 <df645c06-c30b-eafa-4d23-826b84f2ff48@kernel.dk>
 <1597780833.3978.3.camel@HansenPartnership.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f3312928-430c-25f3-7112-76f2754df080@kernel.dk>
Date:   Wed, 19 Aug 2020 07:00:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1597780833.3978.3.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/18/20 1:00 PM, James Bottomley wrote:
> On Mon, 2020-08-17 at 13:02 -0700, Jens Axboe wrote:
>> On 8/17/20 12:48 PM, Kees Cook wrote:
>>> On Mon, Aug 17, 2020 at 12:44:34PM -0700, Jens Axboe wrote:
>>>> On 8/17/20 12:29 PM, Kees Cook wrote:
>>>>> On Mon, Aug 17, 2020 at 06:56:47AM -0700, Jens Axboe wrote:
>>>>>> On 8/17/20 2:15 AM, Allen Pais wrote:
>>>>>>> From: Allen Pais <allen.lkml@gmail.com>
>>>>>>>
>>>>>>> In preparation for unconditionally passing the
>>>>>>> struct tasklet_struct pointer to all tasklet
>>>>>>> callbacks, switch to using the new tasklet_setup()
>>>>>>> and from_tasklet() to pass the tasklet pointer explicitly.
>>>>>>
>>>>>> Who came up with the idea to add a macro 'from_tasklet' that
>>>>>> is just container_of? container_of in the code would be
>>>>>> _much_ more readable, and not leave anyone guessing wtf
>>>>>> from_tasklet is doing.
>>>>>>
>>>>>> I'd fix that up now before everything else goes in...
>>>>>
>>>>> As I mentioned in the other thread, I think this makes things
>>>>> much more readable. It's the same thing that the timer_struct
>>>>> conversion did (added a container_of wrapper) to avoid the
>>>>> ever-repeating use of typeof(), long lines, etc.
>>>>
>>>> But then it should use a generic name, instead of each sub-system 
>>>> using some random name that makes people look up exactly what it
>>>> does. I'm not huge fan of the container_of() redundancy, but
>>>> adding private variants of this doesn't seem like the best way
>>>> forward. Let's have a generic helper that does this, and use it
>>>> everywhere.
>>>
>>> I'm open to suggestions, but as things stand, these kinds of
>>> treewide
>>
>> On naming? Implementation is just as it stands, from_tasklet() is
>> totally generic which is why I objected to it. from_member()? Not
>> great with naming... But I can see this going further and then we'll
>> suddenly have tons of these. It's not good for readability.
> 
> Since both threads seem to have petered out, let me suggest in
> kernel.h:
> 
> #define cast_out(ptr, container, member) \
> 	container_of(ptr, typeof(*container), member)
> 
> It does what you want, the argument order is the same as container_of
> with the only difference being you name the containing structure
> instead of having to specify its type.

Not to incessantly bike shed on the naming, but I don't like cast_out,
it's not very descriptive. And it has connotations of getting rid of
something, which isn't really true.

FWIW, I like the from_ part of the original naming, as it has some clues
as to what is being done here. Why not just from_container()? That
should immediately tell people what it does without having to look up
the implementation, even before this becomes a part of the accepted
coding norm.

-- 
Jens Axboe

