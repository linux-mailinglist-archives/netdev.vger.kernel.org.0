Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3834D240E
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 23:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350629AbiCHWPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 17:15:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345557AbiCHWPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 17:15:08 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FEF4C43C;
        Tue,  8 Mar 2022 14:14:11 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: aratiu)
        with ESMTPSA id 769851F44332
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1646777649;
        bh=oH9umuyNaE5/U4zhMjdsDxOXvye3XmzP5z4EoQRHZWk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=DjssUUiC8YUIrd9O+MeyiYKjRux86b4SDaOCG60RS5oPKGznX7Q8bA+NxxisCugxY
         TJNghTwbXGz4K5GcOuufZX+w0KFjzm4O4/3E4WckLww/C2gZiF0uO4w/k2gOOlBUrz
         ibMLHh6s1evlK46ar22OEjUsNN6VY8eF55GH0tu/7bT5p1L0qbd1564PBQEnkSA9fx
         W+7FJkIhc1BlcO3T9kxQr1zGUvieubbQO0PiotBzNWFtcEtULDWxMuvAzmrUSnHGBj
         NLWlRUa1erDiqJS46MGYexhaBwXGT8Q8BNubpSwENaWjSHVzlz2qLtOEgxa4M5taEr
         Z3ReoAe7OhMlw==
From:   Adrian Ratiu <adrian.ratiu@collabora.com>
To:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kernel@collabora.com,
        linux-kernel@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Manoj Gupta <manojgupta@chromium.com>,
        Nathan Chancellor <nathan@kernel.org>, bpf@vger.kernel.org
Subject: Re: [PATCH bpf v2] tools: fix unavoidable GCC call in Clang builds
In-Reply-To: <6e82ffbb-ebc8-30e8-2326-95712578ee07@iogearbox.net>
References: <20220308121428.81735-1-adrian.ratiu@collabora.com>
 <6e82ffbb-ebc8-30e8-2326-95712578ee07@iogearbox.net>
Date:   Wed, 09 Mar 2022 00:14:06 +0200
Message-ID: <87fsnsrt1t.fsf@ryzen9.i-did-not-set--mail-host-address--so-tickle-me>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Daniel,

On Tue, 08 Mar 2022, Daniel Borkmann <daniel@iogearbox.net> wrote:
> On 3/8/22 1:14 PM, Adrian Ratiu wrote: 
>> In ChromeOS and Gentoo we catch any unwanted mixed Clang/LLVM 
>> and GCC/binutils usage via toolchain wrappers which fail 
>> builds.  This has revealed that GCC is called unconditionally 
>> in Clang configured builds to populate GCC_TOOLCHAIN_DIR. 
>> Allow the user to override CLANG_CROSS_FLAGS to avoid the GCC 
>> call - in our case we set the var directly in the ebuild 
>> recipe.   In theory Clang could be able to autodetect these 
>> settings so this logic could be removed entirely, but in 
>> practice as the commit cebdb7374577 ("tools: Help 
>> cross-building with clang") mentions, this does not always 
>> work, so giving distributions more control to specify their 
>> flags & sysroot is beneficial.   Suggested-by: Manoj Gupta 
>> <manojgupta@chromium.com> Suggested-by: Nathan Chancellor 
>> <nathan@kernel.org> Acked-by: Nathan Chancellor 
>> <nathan@kernel.org> Signed-off-by: Adrian Ratiu 
>> <adrian.ratiu@collabora.com> --- Changes in v2: 
>>    * Replaced variable override GCC_TOOLCHAIN_DIR -> 
>>    CLANG_CROSS_FLAGS 
> 
> As I understand it from [0] and given we're late in the cycle, 
> this is targeted for bpf-next not bpf, right? 
>

Yes, let's target this for bpf-next. The issue was introduced in 
the 5.17 cycle but indeed it's late. I can do a stable backport to 
5.17 after it releases.

Thanks,
Adrian

> Thanks,
> Daniel
>
>    [0] https://lore.kernel.org/lkml/87czjk4osi.fsf@ryzen9.i-did-not-set--mail-host-address--so-tickle-me/
