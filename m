Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2A93FF1B3
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 18:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346353AbhIBQmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 12:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234436AbhIBQmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 12:42:36 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCC6C061575;
        Thu,  2 Sep 2021 09:41:38 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id s29so2098089pfw.5;
        Thu, 02 Sep 2021 09:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VleJPFXhbF8WRqOsaBBQPjzgoQ2bIzoPQ5j5gsdJ/N4=;
        b=Cz8RabjQzuMJtB8RAsceldQG5nNB5DV0r/TRNB6W4SHV0C7nj2fupVpn1nAt6PO5F0
         jOppsn8OM5ApPZjPQVVAl7sLfx+B8ktsABfi/5YeAX9HMb5XP7e0PI3MfqBAxnJ4PVi0
         b9u07dUzUxkDHikaB2qwGUKzV1HSRSGOHGoy3VXOBmgfz2OUBx8nKqkhfGJvEH1Kfue/
         IsPXFKGhsyrcSigiBUFGazrK0ySWJhF38AcwqaHjUk87HCr7ghGUjWGCkywXVrezq+VR
         c/SWbHlMAHii1BbzBCAUMg3Zq7WnFh7jpKvwN4CKmpJru5haf74WfBjqPeEMWzgvITd4
         icOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VleJPFXhbF8WRqOsaBBQPjzgoQ2bIzoPQ5j5gsdJ/N4=;
        b=INbrfIJpOfz+oxEMYiOma98ZveTxR3N+ioigcPM9HEhxTl/qiQiWl0J51ghXdVkBel
         0QlRtrF07NCtLOGahIz/tBvzlpXSvVbzeMm17s8xGIoBgP29lOj3sCAOf5V2O1CZWALb
         eGdrLNXvtde/m6TANsBFYulpD5WOytR7OfZphwOTnW/SYLG9XEBU2/UueA1TzaGQJMAG
         tU96Zz0PQSLo6dbYuN6Ol2NRnZ+zbflDZrcEYFK2UnfFIPdMWhTWaAcUUmYch606+zi+
         OCcw7zaPOOHkqwCBaH8pjQAoF38EGZ4hjXjevPEbisyL+fQH5UR5+KHAK3sewep9+iy0
         YA3g==
X-Gm-Message-State: AOAM533zxADhpB/4Vw3ovHydkIINdgXhBm7gDquvwB+rMUHhnikprlqB
        /1VaF/Khhge+6Ytf2qrx06wGEsAASo4=
X-Google-Smtp-Source: ABdhPJxlf/isZnGLzzFeBV8SO4M3XZMMNeLyhuVmrTumSc21EOHaCoUVi6IYD/XkO0BebwVR7FBubw==
X-Received: by 2002:a63:34c6:: with SMTP id b189mr3964133pga.122.1630600897300;
        Thu, 02 Sep 2021 09:41:37 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.119])
        by smtp.googlemail.com with ESMTPSA id v8sm2774059pjh.24.2021.09.02.09.41.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 09:41:36 -0700 (PDT)
Subject: Re: [PATCH linux-next] ipv4: Fix NULL deference in
 fnhe_remove_oldest()
To:     Eric Dumazet <edumazet@google.com>,
        Tim Gardner <tim.gardner@canonical.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20210902163205.17164-1-tim.gardner@canonical.com>
 <CANn89i+ey++b=dBXUZjXYyVessr49yZJBagVJxP-mpcreYyjCA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9a1962e2-fa9f-f423-c16d-8ba529a931eb@gmail.com>
Date:   Thu, 2 Sep 2021 09:41:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CANn89i+ey++b=dBXUZjXYyVessr49yZJBagVJxP-mpcreYyjCA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/2/21 9:38 AM, Eric Dumazet wrote:
> On Thu, Sep 2, 2021 at 9:32 AM Tim Gardner <tim.gardner@canonical.com> wrote:
>>
>> Coverity complains that linux-next commit 67d6d681e15b5 ("ipv4: make
>> exception cache less predictible") neglected to check for NULL before
>> dereferencing 'oldest'. It appears to be possible to fall through the for
>> loop without ever setting 'oldest'.
> 
> Coverity is wrong.
> 
>  fnhe_remove_oldest() is only called when there are at least 6 items
> in the list.
> 
> There is no way oldest could be NULL, or that oldest_p could contain garbage.
> 

+1
