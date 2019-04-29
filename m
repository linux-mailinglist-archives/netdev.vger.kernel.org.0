Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA9CE539
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 16:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbfD2OsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 10:48:07 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:35776 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728320AbfD2OsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 10:48:07 -0400
Received: by mail-it1-f194.google.com with SMTP id w15so16783010itc.0
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 07:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ogNt8Qc8FZBEPxRolGPabZr/0z2nn731Ug6Yc3CHCaI=;
        b=e5+kt4K24mE9VJAGME0nzdI7Dx/UZeEPPjHB74ta6iGr/RkDe4NiTPuBk7EO7zB98K
         KEDrDVG89vYOFwYM3rQ3HtObyAknTwt+bFdgBwQXh4oulS8xmoZyhZKgiSztI3nSMMdr
         EYRhXioAGiWsVekEtJKpYTCl/MebLibFSI8OA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ogNt8Qc8FZBEPxRolGPabZr/0z2nn731Ug6Yc3CHCaI=;
        b=NOgtMhnTJPZm8OSHJofzT+DTslrDZlZQFF+rQRaM3R8CDoSvjt3CjQo+4MZt+zhIPQ
         7J14z5m3LG4ZEOsZgFv14dC+Rd2O1Srdp21eew8xx2+iJOmS7U2iWkqNyumpYhnfuvh5
         7gvVUJ7I0N5xOIwryw23CrlibD1lsLFQWkmcTOxV55oykjbrCJdd/EdD2d17V8/S7C/L
         LnfrVvpdFJPKa+cSYrwwaX7Q2o6MOvZmfIKkENeWcxRhjYyh6hUQX+eBwGGxgI593Xy3
         XOF4n3p7vVP9ii4I6m1fiqND+e8HRHq1zj/tqd1jMA/KiLFS7v1aLoiK6sbk0DKTWVfN
         2VoA==
X-Gm-Message-State: APjAAAWugwZ+XzkHK6wuf88oxOjyNJZDtdcNB5Dt3xvcWmMRkKOOOg4w
        7WyaDJ+Lx22KkoIcem/OA7lW2Q==
X-Google-Smtp-Source: APXvYqzjTZfH+IBIKICvHqEk5yG8sTH20SI/BjbUydIMb6S2Vgw6TKXZ2664ITjrgBgt76+9y+xIUQ==
X-Received: by 2002:a24:5311:: with SMTP id n17mr7021375itb.151.1556549286163;
        Mon, 29 Apr 2019 07:48:06 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:6497:134d:abc2:e6d0? ([2601:282:800:fd80:6497:134d:abc2:e6d0])
        by smtp.googlemail.com with ESMTPSA id q141sm49217itc.2.2019.04.29.07.48.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 07:48:05 -0700 (PDT)
Subject: Re: Why should we add duplicate rules without NLM_F_EXCL?
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org,
        Mateusz Bajorski <mateusz.bajorski@nokia.com>,
        Thomas Haller <thaller@redhat.com>
References: <20190428062137.GH18865@dhcp-12-139.nay.redhat.com>
From:   David Ahern <dsa@cumulusnetworks.com>
Message-ID: <d2a89996-2c73-be8c-a890-6d8543eda6ba@cumulusnetworks.com>
Date:   Mon, 29 Apr 2019 08:48:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190428062137.GH18865@dhcp-12-139.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/19 12:21 AM, Hangbin Liu wrote:
> Hi David, Mateusz,
> 
> Kernel commit 153380ec4b9b ("fib_rules: Added NLM_F_EXCL support to
> fib_nl_newrule") added a check and return -EEXIST if the rule is already
> exist. With it the ip rule works as expected now.
> 
> But without NLM_F_EXCL people still could add duplicate rules. the result
> looks like:
> 
> # ip rule
> 0:      from all lookup local
> 32766:  from all lookup main
> 32767:  from all lookup default
> 100000: from 192.168.7.5 lookup 5
> 100000: from 192.168.7.5 lookup 5
> 
> The two same rules looks unreasonable. Do you know if there is a use case
> that need this?

It does not make sense to me to allow multiple entries with the same
config; it only adds to the overhead of fib lookups.

> 
> So how about just return directly if user add a exactally same rule, as if
> we did an update, like:
> 
> diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
> index ffbb827723a2..c49b752ea7eb 100644
> --- a/net/core/fib_rules.c
> +++ b/net/core/fib_rules.c
> @@ -756,9 +756,9 @@ int fib_nl_newrule(struct sk_buff *skb, struct nlmsghdr *nlh,
>         if (err)
>                 goto errout;
> 
> -       if ((nlh->nlmsg_flags & NLM_F_EXCL) &&
> -           rule_exists(ops, frh, tb, rule)) {
> -               err = -EEXIST;
> +       if (rule_exists(ops, frh, tb, rule)) {
> +               if (nlh->nlmsg_flags & NLM_F_EXCL)
> +                       err = -EEXIST;
>                 goto errout_free;
>         }
> 
> 
> What do you think?

I'm not so sure about the failure and more from a consistency with other
RTM_NEW commands which cover updates to an existing entry. In the case
of rules if there is nothing to update and the rule already exists then
- for consistency - 0 is the right return code.


