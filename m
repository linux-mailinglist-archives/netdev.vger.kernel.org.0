Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8EDF6A1226
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 22:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjBWVhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 16:37:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjBWVhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 16:37:53 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7A759C1
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 13:37:52 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id d30so6194693eda.4
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 13:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VAVWbTZhOahgbeoCVeCI3EwYDSoKydef03wO7/5d2JU=;
        b=EqmoPqeQbjoafMObEf2fTe/r9LkSJInAKED/5JXgQjuokPaocNnxoYXIZxa7+0u47G
         Iq8CMCkdmxpQmovC/3sbC8DBEkIaUWeV3emMIwGiCvdSW0vvXje7Y3y5mm7ukDXLAyFU
         AFnhyHNojJDRIrxezCs45dDWnqoYhhXvMGcPI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VAVWbTZhOahgbeoCVeCI3EwYDSoKydef03wO7/5d2JU=;
        b=rh8AEQjyCFvg0f+DHpfjwm/HNaiBVcTCm7aT74eJvJnH/berYlCVB+74EQ0BEGw9sO
         VlDbkkB/jxAXIMSDo5tMFegIAN/CRYxSoUnfPuH5qrjPrtKJB6cM0gN59x6jpLjx/JQo
         /rB6nzcizyd0fScfZVRGg6bUj/T/lDBkVo4VCswc/tguh0yKz4FFPjT6XRGNuiEw8Zho
         IdgA02cufxkK27F4sQOouIbF8tjhvW8CwhPAoGPRhZDBqaFblRpRwFQz19ha+Lai0/mc
         84OJZ4NBjqJ3DpyUQvQ5BVIh7m1UGAr65fsalaYGRUgd7TArjZ0AK/BJtYbUArnrnh+S
         vyDg==
X-Gm-Message-State: AO0yUKUGzVNNdG/G2EcbDFH05MYpTvqaZJBnTs1Tw16F1MBTjhRJRQf6
        Ne+jcOr9tQsleaYu+xsdtHBP/PCp7sffBZkDCAIc8g==
X-Google-Smtp-Source: AK7set9AmA2ETnNgK7cEaNTUDlgDlGXt0OwraoHu1e16J0B5Ya4pgHnekFpzQgCxkv+C2shr7sLnXw==
X-Received: by 2002:aa7:c643:0:b0:4ac:c39b:8450 with SMTP id z3-20020aa7c643000000b004acc39b8450mr11677051edr.8.1677188270373;
        Thu, 23 Feb 2023 13:37:50 -0800 (PST)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id s21-20020a50d495000000b004aee548b3e2sm5391272edi.69.2023.02.23.13.37.48
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 13:37:49 -0800 (PST)
Received: by mail-ed1-f41.google.com with SMTP id h16so47572343edz.10
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 13:37:48 -0800 (PST)
X-Received: by 2002:a17:906:b55:b0:8f1:4cc5:f14c with SMTP id
 v21-20020a1709060b5500b008f14cc5f14cmr933485ejg.0.1677188268445; Thu, 23 Feb
 2023 13:37:48 -0800 (PST)
MIME-Version: 1.0
References: <20230221233808.1565509-1-kuba@kernel.org> <CAHk-=wjTMgB0=PQt8synf1MRTfetVXAWWLOibnMKvv1ETn_1uw@mail.gmail.com>
 <87pma02odj.fsf@kernel.org>
In-Reply-To: <87pma02odj.fsf@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 23 Feb 2023 13:37:31 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgOmTXMxm=ouCEKu0Agd5q-u3mrQ8=ne8412ciG2b-eJA@mail.gmail.com>
Message-ID: <CAHk-=wgOmTXMxm=ouCEKu0Agd5q-u3mrQ8=ne8412ciG2b-eJA@mail.gmail.com>
Subject: Re: [PULL] Networking for v6.3
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pabeni@redhat.com, bpf@vger.kernel.org, ast@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023 at 11:06 AM Kalle Valo <kvalo@kernel.org> wrote:
>
> So that we can file a bug report about use of Wireless Extensions, what
> process is ThreadPoolForeg?

It is, as you already seem to have googled, just a sub-thread of google-chrome.

> The warning was applied over a month ago, I'm surprised nobody
> else has reported anything.

Honestly, I'm not sure how many people actually _run_ a real desktop
on linux-next. Getting merged into mainline really ends up resulting
in a lot more testing (outside of the test robots that don't tend to
really run desktop loads).

I see it on my desktop too, but I actually noticed it on my laptop
first, because it - once again - has started falling off the wireless
network regularly and I was looking if there were any messages about
it.

(That ath driver really is flaky, and I've never figured out what the
trigger is, it just sometimes goes dead and you have to disable and
re-enable wireless. But that's not a new problem, it's just a "that's
why I noticed")

                 Linus
