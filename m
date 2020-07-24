Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193FD22BB0B
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 02:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgGXAeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 20:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbgGXAeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 20:34:17 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F25DC0619D3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 17:34:17 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id n5so4200852pgf.7
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 17:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bVtj66S5iw0ZWEVfJNsD/l0bs07hqOSeBsmcTWUWdEk=;
        b=lP9lvxvPtMTwIzLc1Em0hF5WUozlE4w/UewhgekQTtD3rOwgiZxxwkuKv7C+FRYHf5
         HAr0HmVOySjV2lhky73E7eRwnAkY+8dLTPcnK5RxLIj1RPiXiuuYSFLfQr3ZJu094++F
         KFXfq9t5kdk+VG1+tpgAHvusz1qk3UP92qyzNd2MVcTRYIlsk8RRfSePb+3I+V2JR3Zv
         tNMYaK3hYRdAfemU9mJvpcQZ18G9xaLt01CNHU4ni1qWCfhuFI6t4Rb0K5dx0Tyin1M5
         jfp/vF3iXJXVKUiVkuba6TVSR4gI34a779hK1LXpHbUeqhjnKjx4btSWZcZGo16/znGO
         kwwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bVtj66S5iw0ZWEVfJNsD/l0bs07hqOSeBsmcTWUWdEk=;
        b=WPdrJT+IOGZ1v2fqwMvqBFPdaUEkC4erjIHINkXGv79ynCtTnn+Ovoa/0VTlDL/3bf
         Df36lGYR2Oip3zmEC+MwU1EmYgzHdwKq7Xjf/S8KTcLnmrE1ONVtTCJ6HMZoxLpTTGtW
         FOZ8DCbxqTNjgAq/VwCCpEDnhmvbTmvkQ2Z8l00LuY/HMcPj/Z7kU0tJ22EbELoWlApO
         2IQ6eZmSPj0x2odukYQsDP/HQxNXVNR096YbMnQyETOxSb20blmSXlDw1s2CRdZYDZeh
         OtQBm2ibAuhKY3yVzGS+FxSQHUbWuYMvgv/XVq1tesBzqgbCEIVPuhu3mo3S3LdE5yEW
         8/7w==
X-Gm-Message-State: AOAM531Uih21LGphZ7HhIadkuq4SDP+tpXlm3Py4iFHxOWgHZM35wX0G
        LHPaO6hVqZzTFAmq/qRZKmw=
X-Google-Smtp-Source: ABdhPJx6hz6zBfzHQifU4rR6CptitU3J9QIHrjknLA713/WJup9EsW0zyyLk7GYzw70j9lbhTLRPbw==
X-Received: by 2002:a62:e217:: with SMTP id a23mr6544524pfi.257.1595550857000;
        Thu, 23 Jul 2020 17:34:17 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id bv12sm3772123pjb.6.2020.07.23.17.34.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2020 17:34:16 -0700 (PDT)
Subject: Re: PROBLEM: potential concurrency bug in rhashtable.h
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "Gong, Sishuai" <sishuai@purdue.edu>,
        "tgraf@suug.ch" <tgraf@suug.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Sousa da Fonseca, Pedro Jose" <pfonseca@purdue.edu>
References: <5964B1AB-3A3D-482C-A13B-4528C015E1ED@purdue.edu>
 <22d7b981-c105-ebee-46e9-241797769e06@gmail.com>
 <20200724000927.GA27290@gondor.apana.org.au>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a0b1aa08-b8dd-3b41-6c0c-7482e05a9986@gmail.com>
Date:   Thu, 23 Jul 2020 17:34:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200724000927.GA27290@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/23/20 5:09 PM, Herbert Xu wrote:
> On Thu, Jul 23, 2020 at 03:32:05PM -0700, Eric Dumazet wrote:
>>
>> Thanks for the report/analysis. 
> 
> Thanks indeed.
> 
>> READ_ONCE() should help here, can you test/submit an official patch ?
> 
> This is basically a hand-rolled RCU access.  So we should instead
> use proper RCU operators if possible.  Let me see what I can do.

Sure, but __rht_ptr() is used with different RCU checks,
I guess a that adding these lockdep conditions will make
a patch more invasive.


