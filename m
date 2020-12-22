Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB242E0D8E
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 17:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbgLVQuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 11:50:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726991AbgLVQuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 11:50:02 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0264C0613D3
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 08:49:21 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id w124so15386086oia.6
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 08:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XdgG1WYlGFQh7oAkl4DkQcz6hlLpZqAWeHr9FbR55mo=;
        b=dccxBeS9c8YgLFf92sptpjs8EBmeGZMVkVnMUw5hAp1PaxwQiO4sg9pX+VmkJCDBSy
         VafPcOcUntRA+nMLW9NpRFhkPs1YktWlvZLkYJ9CsZmVie69l99nKCWXG5tGJ/Lp3slV
         ljqY/ltvS+BYrDbPFAUut1fRDJMhRj/E0yImkjRVm5w/dZua98e+OXjA5wLaH6vz86kC
         vScioUiykzPsmMgg7cFkgAE8xO5thNG73Yi47SD9vitcZu/3ZnIxB/oV4fVlsYFC723i
         R2oUJ3MfU1P2jH70raVIi2Nm9X/pRmyg/ZICoTzEMjDGFKRWpwVgz1jDykf/oooN/82t
         exEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XdgG1WYlGFQh7oAkl4DkQcz6hlLpZqAWeHr9FbR55mo=;
        b=OeP9V2Fxu0RcWxKKHS1eYl+BpK/fIKMXGAGtLW6TET9dpCIUzB9coXQYv2Q3b9Fm5x
         mtgCU6LTwx2HH/HrDl4/kJm9Nbd+mpK18kVh8pZEbhtJ3dbRtoXOcaFVQBIFWxLSymJ2
         3p0BGGLayHOU5WFBDsukeiVhymEWBui9Kw1/PWoqWvNnZDjljEHXxXehrkV2sHp5BWGc
         b23R0BbeeN0xMNmDC3LQuWxTko9zpUX9NyI6K9vKxp2W4gVMxFOCxB5uhDf/26OOsy4d
         Eh/U7CjK9pdBq40O6JaB0S8tDhWTdn4dnsCh9N/G/ijQyDkok5XNKHMg8mhpHllWpIM8
         sA1Q==
X-Gm-Message-State: AOAM531SV3il4Ms+tt9BpiqRF9Qbm1lIK7mnymDllhyiRb85+vT/iDQ3
        0yRvFxa6iCDrzPz5SIKb6TY=
X-Google-Smtp-Source: ABdhPJxnWLuVxN2mwLH3om6FH4sA15320q8lMJT3AebkdPfDTbBZSAK8kRALX++U/sntF6qz+Hgfvw==
X-Received: by 2002:a54:400f:: with SMTP id x15mr14813001oie.38.1608655761342;
        Tue, 22 Dec 2020 08:49:21 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:84d8:b3da:d879:3ea8])
        by smtp.googlemail.com with ESMTPSA id t19sm4738508otp.36.2020.12.22.08.49.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Dec 2020 08:49:20 -0800 (PST)
Subject: Re: [PATCH 04/12 v2 RFC] skbuff: Push status and refcounts into
 sock_zerocopy_callback
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>
References: <20201222000926.1054993-1-jonathan.lemon@gmail.com>
 <20201222000926.1054993-5-jonathan.lemon@gmail.com>
 <CAF=yD-K7bWE-U-O2J2Bwwi3E0NrX+horDARRgmBUU8Pqh6pH3Q@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f21da0d8-fdad-f98a-62c6-6ab8a84b8e75@gmail.com>
Date:   Tue, 22 Dec 2020 09:49:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <CAF=yD-K7bWE-U-O2J2Bwwi3E0NrX+horDARRgmBUU8Pqh6pH3Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/22/20 7:43 AM, Willem de Bruijn wrote:
> 
>>  void sock_zerocopy_put(struct ubuf_info *uarg)
>>  {
>> -       if (uarg && refcount_dec_and_test(&uarg->refcnt))
>> +       if (uarg)
>>                 uarg->callback(uarg, uarg->zerocopy);
>>  }
>>  EXPORT_SYMBOL_GPL(sock_zerocopy_put);
> 
> This does increase the number of indirect function calls. Which are
> not cheap post spectre.
> 
> In the common case for msg_zerocopy we only have two clones, one sent
> out and one on the retransmit queue. So I guess the cost will be
> acceptable.
> 


sock_zerocopy_callback seems to be the only one at the moment - or the
most dominant if I goofed my search. Could use the INDIRECT_CALL macros
for it.
