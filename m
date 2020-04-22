Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31C91B4B4D
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 19:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgDVRH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 13:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgDVRH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 13:07:57 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E1DC03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 10:07:57 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id 19so3170129ioz.10
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 10:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DixKlBYF/MAE7mH9mJ/8BzlYxn9h+x7wGxKEhp+uRII=;
        b=uw1iCl+9b7hAF6k/3TTuMXNOqrz7lSaf5CFhewK0aoAMMlOtZxQE4hry3qbktdiACK
         uEX8n8A7TaWWvfMqosgqkLAHMTQC1zXKf3m2l6/1fn54SJjrECycHTgV3rm8kmbSxnS0
         7EG9Xkdo5WpX8T2+eq8W44W1i20QKpOVolZxMUHT/zrN8mzhDY58bfIDObiPFTDW3vUp
         XDYVQab5c9Y9obVW+obhxHo67gdSb8UeD0OG/9XxdnuNV57WmdfJrQ3ewHyt4XeJRuSd
         Ux2XR1qsbC1ZVgGta0Uzw1qQjlu74hypxu6VZ8I/vHEit8+TDfaJ7Wfm49068zho5fos
         fkmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DixKlBYF/MAE7mH9mJ/8BzlYxn9h+x7wGxKEhp+uRII=;
        b=teAWDxnVWhYl7founzNgwqXTnEH4h+gVg77J1Xh7Cd0MWk/Fxqgee9QCx3Qwl861fh
         CZ/7pZkFwpdYT77a3074XQXiUlndx3Inm14TCid/2jcSo9x6SW5H3QUkuJUrZTnLxgE7
         vAHMf6J2SKpQ5JWRP+STes/tq1ElrvzRWtcW6Qu7CQ3kHE7xtfYMb+JmcXpCzIRkkOlE
         P/txoQJJRGmQL0EHElq34qqcrpbxaqDnWwJsOd4myb7dExzwDMIXfGZlsbB8Rg31MNLp
         b/kctO8ITcowyPv9ac8SNqorfswity2w/2GY/n0PkIW9On+NBvNd0TC5RWdUWGrspOva
         Pwlg==
X-Gm-Message-State: AGi0PuZFshxF0cwiralUguu6fzMtZ5kb9yabmHQBHBVyVwacrfabryKI
        bj3kvEhToKaQgscxYIlDcGKlIA==
X-Google-Smtp-Source: APiQypKEEiHTgYN8lRx+Iv0z4s28l+Y8/74OmcxZ0SRJXdnnLedboMkwJxS91MGlYyz/06zXFO5ADQ==
X-Received: by 2002:a5d:9a94:: with SMTP id c20mr25953416iom.166.1587575276728;
        Wed, 22 Apr 2020 10:07:56 -0700 (PDT)
Received: from [192.168.0.105] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id t88sm2256588ild.30.2020.04.22.10.07.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 10:07:55 -0700 (PDT)
Subject: Re: [PATCH iproute2 v2 1/2] bpf: Fix segfault when custom pinning is
 used
To:     Dominique Martinet <asmadeus@codewreck.org>,
        Andrea Claudi <aclaudi@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        linux-netdev <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, daniel@iogearbox.net,
        Jamal Hadi Salim <hadi@mojatatu.com>
References: <20200422102808.9197-1-jhs@emojatatu.com>
 <20200422102808.9197-2-jhs@emojatatu.com>
 <CAPpH65zpv6xD08KK-Gjwx4LxNsViu6Jy2DXgQ+inUodoE5Uhgw@mail.gmail.com>
 <20200422144319.GA25914@nautica>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <a8fac40d-b46f-5c4f-f4c6-43d4c8a31ffe@mojatatu.com>
Date:   Wed, 22 Apr 2020 13:07:54 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200422144319.GA25914@nautica>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-04-22 10:43 a.m., Dominique Martinet wrote:

[...]
> I'm actually not sure snprintf can return < 0...

Man page says it can (quick grep on iproute2 code shows some
invocations can check for <=0)

> wide character
> formatting functions can but basic ones not really, there's hardly any
> snprintf return checking in iproute2 code...
> 
> 
> Anyway, with all that said this patch currently technically works for
> me, despite being not so clear, so can add my reviewed-by on whatever
> final version you take (check < 0 or >= PATH_MAX or none or both), if
> you'd like :)

  Will update the next chance i get to.

 >
 > Now I'm looking at this we're a bit inconsistent with return values in
 > this function, other error paths return negative value + errno set,
 > and this only returns -errno.
 >
 > Digging a bit into callers it looks like errno is the way to go, so
 > while you're modifying this it might be worth setting errno
 > to EINVALas
 > well here?
 >

Will do. I wanted to leave code that didnt affect me alone; but
granted it is reasonable for consistency..

 >
 > Cheers & sorry for nitpicking,
 >

No sweat - we havent yet entered the realm  where the color
of the bike shed  begins to matter ;->

cheers,
jamal
