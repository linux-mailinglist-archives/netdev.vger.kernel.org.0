Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D8F3D8C98
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 13:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234225AbhG1LUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 07:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbhG1LUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 07:20:04 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A9DC061764
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 04:20:02 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id y34so3217324lfa.8
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 04:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WRpAt4Qf30VQcI04z59j1Xhna4kVm3ZAFQjWCiFVzII=;
        b=ZITf0JJkY6siA6zuTWx/S+3I3pJ92j2lsEWHCAUrQgybgq2nu7vMyrV5yFzPnr0ASF
         zQnwOwgLaX1f2Ag8AdE3Zoi+yryD69qxehZj3Axp0G1SI8NHWpwdtRD/AWfB8hXTTU+w
         7JIntZBgXB7V3Bx+KAGMmd0eo1ehu7YXfBEGo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WRpAt4Qf30VQcI04z59j1Xhna4kVm3ZAFQjWCiFVzII=;
        b=A1/7DDBg64NeiR01lFra4R48rHo9kF1RmeM/zse46a+RLRXScLsMabt9vOwtQz0dHp
         QBw97sL6Qfh3IT6QzgZzbZW0iL8OV/PQ504zms2eq5iY9qoJ7kXjCIVpFwGgK3mAUeXn
         /j0p3p3+Fjq9lP+NdsHLG7BWGZ4DtUj6+eHUWKpupNSfBfUqdYItOcgd5k0IXkvSRegY
         xaULV+hNh0qq5hc+jU9QAAGGS5WCJ+ur05sdAHNIfmBJGXoP8uWxFziz+Gtjc8oVImB1
         dphC1K7pL+thRXWR7SguRkSauu46nkFBjWLNGp94u++2D0lWvp4SbcM9FW/gmSHMKTsR
         BtbA==
X-Gm-Message-State: AOAM532SYZHTRdUgEmwk5LrAymCiinW4GS57L7UBIF7oDfj6Nd77vr/h
        QJhgZP6BRpNYKCeXXxoi8oL7LQ==
X-Google-Smtp-Source: ABdhPJwtX9cWcqS+T2RXR4asd80U6YfWCrWHQPG0xseFJRRyUcQAZvx3wnyU+2xS6u5f7adx+ZAvkA==
X-Received: by 2002:a19:dc5e:: with SMTP id f30mr20474709lfj.318.1627471200888;
        Wed, 28 Jul 2021 04:20:00 -0700 (PDT)
Received: from [172.16.11.1] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id z4sm564853lfe.274.2021.07.28.04.19.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 04:20:00 -0700 (PDT)
Subject: Re: [PATCH 34/64] fortify: Detect struct member overflows in memcpy()
 at compile-time
To:     Kees Cook <keescook@chromium.org>, linux-hardening@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-35-keescook@chromium.org>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <d2f9f21c-4d6e-9458-5887-ca5166d07942@rasmusvillemoes.dk>
Date:   Wed, 28 Jul 2021 13:19:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210727205855.411487-35-keescook@chromium.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/07/2021 22.58, Kees Cook wrote:

> At its core, FORTIFY_SOURCE uses the compiler's __builtin_object_size()
> internal[0] to determine the available size at a target address based on
> the compile-time known structure layout details. It operates in two
> modes: outer bounds (0) and inner bounds (1). In mode 0, the size of the
> enclosing structure is used. In mode 1, the size of the specific field
> is used. For example:
> 
> 	struct object {
> 		u16 scalar1;	/* 2 bytes */
> 		char array[6];	/* 6 bytes */
> 		u64 scalar2;	/* 8 bytes */
> 		u32 scalar3;	/* 4 bytes */
> 	} instance;
> 
>
> __builtin_object_size(instance.array, 0) == 18, since the remaining size
> of the enclosing structure starting from "array" is 18 bytes (6 + 8 + 4).

I think the compiler would usually end up making that struct size 24,
with 4 bytes of trailing padding (at least when alignof(u64) is 8). In
that case, does __builtin_object_size(instance.array, 0) actually
evaluate to 18, or to 22? A quick test on x86-64 suggests the latter, so
the memcpy(, , 20) would not be a violation.

Perhaps it's better to base the example on something which doesn't have
potential trailing padding - so either add another 4 byte member, or
also make scalar2 u32.

Rasmus
