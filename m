Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BADB046DF7
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 05:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbfFODNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 23:13:44 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:35298 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbfFODNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 23:13:44 -0400
Received: by mail-io1-f66.google.com with SMTP id m24so10088861ioo.2
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 20:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f4sXM58DKnNf826Di3SXz5Jpk0bzAH8QU2j1bWDkbhk=;
        b=HeeQDIsSmQPbNzah1AzK71vDRgSU0nYQcd7zO6YrMewPH3Xy5S8eBzswHHPNmoAPQZ
         wQ/bd5cSRB+f4Bs2A7C+cINLMyC0ZLknzN/Tk0sWZGbddF63ybIu6RgxOIoOeCGcmQIr
         C1kDpS6JLVtMxZVwHcEHfmSni6P4EI61+20VFBnr1fkjXaFzVcqynI8h6Tm8mRDYhf2o
         KWR5cnAtJPL9Partv3vscSvdIfbLPNiYKfiUtTCBib/DBbZQ4UMiOV1QwMJjwWHBvruJ
         Cfdgt58s6byLwWQly4cp4F+anF0Qu38kcOAycDxs91yx9uFdZy163Cpfj9/g2jQ08VcN
         hJbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f4sXM58DKnNf826Di3SXz5Jpk0bzAH8QU2j1bWDkbhk=;
        b=ns7dYuqyaXvNxQ+hkPipWcvsdHlanYY1hfI3wEh7iqCAigi8RS08XOBYnof7eAwuec
         tFW9j5Eo8LlXXZHfVi5+N8JeBcWUSXVOZ4PDChQViRGQohvtw8UPZZCTidtXoXXMyZC6
         UGpqm3TeS0tXxDnl02IGW/m/slOaP4Wb7SJGmty0LrteFvnZevE1zCnO5psSzFi/dwFf
         bP9BQVk9jzRUhFDVHsrIqth/ILXJ98mNZw4noE2omB++MpoU9s94xaVypyEURDMIb2J1
         JbT09Q79/ai5zodaq2m5of+iNts+cPdacuWmlrD6sagPu2YyYfzE5D508cMoWfYnyD2c
         tv2Q==
X-Gm-Message-State: APjAAAVAxpy5uRvyjnunU9LPyAHNSfzbkOqfCPHS/A7eTPy9uYQfmlBX
        u+witg9v8+QZZ8sjQ0GbY8q0Th1zzLE=
X-Google-Smtp-Source: APXvYqyi1vUtrcxvFzW0kq28dr0wyLJrLjIwam25eDA+mM1M/Nf7RU4R/8XE7Dk/RLTA14qeHprnGQ==
X-Received: by 2002:a02:8a:: with SMTP id 132mr26687485jaa.89.1560568423087;
        Fri, 14 Jun 2019 20:13:43 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:6878:c29b:781:b371? ([2601:282:800:fd80:6878:c29b:781:b371])
        by smtp.googlemail.com with ESMTPSA id v26sm3162567iom.88.2019.06.14.20.13.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 20:13:42 -0700 (PDT)
Subject: Re: [PATCH net v4 2/8] ipv4: Honour NLM_F_MATCH, make semantics of
 NETLINK_GET_STRICT_CHK consistent
To:     Stefano Brivio <sbrivio@redhat.com>,
        David Miller <davem@davemloft.net>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
References: <cover.1560561432.git.sbrivio@redhat.com>
 <58865c4c143d0da40cd417b5b87b49d292d8129d.1560561432.git.sbrivio@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9abeefb6-81a7-dc0a-30f4-f15ccf4edc86@gmail.com>
Date:   Fri, 14 Jun 2019 21:13:38 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <58865c4c143d0da40cd417b5b87b49d292d8129d.1560561432.git.sbrivio@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/14/19 7:32 PM, Stefano Brivio wrote:
> Socket option NETLINK_GET_STRICT_CHK, quoting from commit 89d35528d17d
> ("netlink: Add new socket option to enable strict checking on dumps"),
> is used to "request strict checking of headers and attributes on dump
> requests".
> 
> If some attributes are set (including flags), setting this option causes
> dump functions to filter results according to these attributes, via the
> filter_set flag. However, if strict checking is requested, this should
> imply that we also filter results based on flags that are *not* set.

I don't agree with that comment. If a request does not specify a bit or
specify an attribute on the request, it is a wildcard in the sense of
nothing to be considered when matching records to be returned.


> 
> This is currently not the case, at least for IPv4 FIB dumps: if the
> RTM_F_CLONED flag is not set, and strict checking is required, we should
> not return routes with the RTM_F_CLONED flag set.

IPv4 currently ignores the CLONED flag and just returns - regardless of
whether strict checking is enabled. This is the original short cut added
many years ago.

> 
> Set the filter_set flag whenever strict checking is requested, limiting
> the scope to IPv4 FIB dumps for the moment being, as other users of the
> flag might not present this inconsistency.
> 
> Note that this partially duplicates the semantics of NLM_F_MATCH as
> described by RFC 3549, par. 3.1.1. Instead of setting a filter based on
> the size of the netlink message, properly support NLM_F_MATCH, by
> setting a filter via ip_filter_fib_dump_req() and setting the filter_set
> flag.
> 

your commit description is very confusing given the end goal. can you
explain again?
