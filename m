Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12350C9429
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 00:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbfJBWNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 18:13:16 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34111 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbfJBWNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 18:13:16 -0400
Received: by mail-pl1-f194.google.com with SMTP id k7so513094pll.1
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 15:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c2rDtSIE23TakyIVQEj8MifrPjajW5vXmHoqcTKl2C0=;
        b=vQbrhh8IIx19FIrVcjlsQw+tLkiPQoAyX53DHMnf5vhsmcI1LbWcfYVHM8TmYxa/1q
         DAHWAidET39yIp4pp77J/ems/DACp6DY2AaTEHy8K0T8EcDF4ckJbzX8QmUcLq+WegwT
         28zx3QHs0HKvYbQSexXr2hMJuAD17Tp3ZKKXZnE2+Yn1TvOwdSMbwZeqG58dmwQNMoJJ
         G0NigCmj00pRNZr0q6rj9Ba0lfzYWs6R2HsSBgQcz3OazGpAEphruTRWPL1fs7Nf3ShF
         6fY/a06HqO7+8gG2nYbkZGIYndxNexRK8vfBhANvKYu64X5iqVUjgBXZzlK2fnH3fVqm
         V8hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c2rDtSIE23TakyIVQEj8MifrPjajW5vXmHoqcTKl2C0=;
        b=Qyq4Xdkl0Xe2fJCWhVo4D6jEq2knXlOj5AkkOYI7mPjlv3g+Xwo+oodlKQhFreOtBl
         7tvHk3QhPcoQojtX1Z/Sy68X68rIw2nCe87lzT8Klb5mhJ5LPMNlbct8jog7RGXV1Jtk
         RhCd1bSKQ9QJZlkPyHNGURqIRgBsQHn/MCf7HpefsOvuCH/BeqDtCqi7ujRrUdWOSYZr
         aD2T5Zk2ZORB46v2BMGpgk1MAex1DcAHSyWhXfvrX4sgjGuRct5eHJpdDp5iYSNzf6ZQ
         eUQ+Oh74mf+vSOmVFTBFM93axQ9xQhzt8cSHUSXq59yWsCYg1jWOsfmU9zoOlVZPg/kk
         2JDA==
X-Gm-Message-State: APjAAAWbP9sJD+qjuZpU0z4N/l3OdFZQKTE748azqtC7Tadmkuv5zxMf
        +nEXA3qeijxlXUdQHm0B2xs=
X-Google-Smtp-Source: APXvYqwGppR/3NBlFMCTP0hfPHmpdYitZV4gQjiBZNjlqLLdhqusib20RQKwAtNV8JqjX0W9+/wsDA==
X-Received: by 2002:a17:902:7c83:: with SMTP id y3mr6142319pll.21.1570054395084;
        Wed, 02 Oct 2019 15:13:15 -0700 (PDT)
Received: from dahern-DO-MB.local (c-73-169-115-106.hsd1.co.comcast.net. [73.169.115.106])
        by smtp.googlemail.com with ESMTPSA id w10sm419486pfi.137.2019.10.02.15.13.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 15:13:13 -0700 (PDT)
Subject: Re: [PATCH net v2] ipv6: Handle race in addrconf_dad_work
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, rajendra.dendukuri@broadcom.com
References: <20191001032834.5330-1-dsahern@kernel.org>
 <1ab3e0d0-fb37-d367-fd5f-c6b3262b6583@gmail.com>
 <18c18892-3f1c-6eb8-abbb-00fd6c9c64d3@gmail.com>
 <146a2f8a-8ee9-65f3-1013-ef60a96aa27b@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8d13d82c-6a91-1434-f1af-a2f39ecadbfb@gmail.com>
Date:   Wed, 2 Oct 2019 16:13:12 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <146a2f8a-8ee9-65f3-1013-ef60a96aa27b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/2/19 3:23 PM, Eric Dumazet wrote:
> 
> 
> On 10/2/19 2:08 PM, Eric Dumazet wrote:
>>
>>
>> On 10/1/19 11:18 AM, Eric Dumazet wrote:
>>>
>>>
>>> On 9/30/19 8:28 PM, David Ahern wrote:
>>>> From: David Ahern <dsahern@gmail.com>
>>>>
>>>> Rajendra reported a kernel panic when a link was taken down:
>>>>
>>>> [ 6870.263084] BUG: unable to handle kernel NULL pointer dereference at 00000000000000a8
>>>> [ 6870.271856] IP: [<ffffffff8efc5764>] __ipv6_ifa_notify+0x154/0x290
>>>>
>>>> <snip>
>>>>
>>>
>>> Reviewed-by: Eric Dumazet <edumazet@google.com>
>>>
>>> Thanks !
>>>
>>
>> Apparently this patch causes problems. I yet have to make an analysis.

Ugh. I presume syzbot? can you forward the stack trace?

> 
> It seems we need to allow the code to do some changes if IF_READY is not set.
> 
> WDYT ?
> 
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index dd3be06d5a066e494617d4917c757eae19340d4d..e8181a3700213b9574ea25130689c9218236245d 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -4035,7 +4035,7 @@ static void addrconf_dad_work(struct work_struct *w)
>         /* check if device was taken down before this delayed work
>          * function could be canceled
>          */
> -       if (idev->dead || !(idev->if_flags & IF_READY))
> +       if (idev->dead)
>                 goto out;
>  
>         spin_lock_bh(&ifp->lock);
> @@ -4083,6 +4083,11 @@ static void addrconf_dad_work(struct work_struct *w)
>                 goto out;
>  
>         write_lock_bh(&idev->lock);
> +       if (!(idev->if_flags & IF_READY)) {
> +               write_unlock_bh(&idev->lock);
> +               goto out;
> +       }

That restores the original BUG() - ie., the reason for this patch.

The IF_READY flag needs to be checked before the call to addrconf_dad_begin.

> +
>         spin_lock(&ifp->lock);
>         if (ifp->state == INET6_IFADDR_STATE_DEAD) {
>                 spin_unlock(&ifp->lock);
> 

