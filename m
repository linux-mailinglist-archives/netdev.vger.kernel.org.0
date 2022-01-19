Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA16E49330C
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 03:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351043AbiASCkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 21:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351063AbiASCko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 21:40:44 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A177C061753
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 18:40:41 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id i82so1087232ioa.8
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 18:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=sY67Z5XQqbQyDcJui1UIVqRGECFNH/xvxysFzlV46z0=;
        b=E154x0JKulWRHRqEKbPWLeT6TA5dNwXvNAj1SOoevlMAHDxggw1WAILwuwTw0/TQV7
         y1l5gsGIapyM2s6Z8mBBXk8WPBMwQ9LH1JB9N5H6X1cZKC60w/xxvIo3hoFadFoSWHC4
         j04evi5e+IYrz2l+wVGmGeXrNwlDYAstoCvyfeiTAx7ljn3+aCdKKoWnKIa29nYjIiH8
         KFRUNiLM0j2hGsHGjwz2/XBPa/PP8aUJK5V4OYjzeg7y8fZgTlCGoEEXbEiAtfuN079S
         W/reVgPI9ocuT34ev6up0GXEt9jSL12+PAfhjBCPr+bn9/UtXg1M2PCZU1fPTf3uHWrv
         dRfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sY67Z5XQqbQyDcJui1UIVqRGECFNH/xvxysFzlV46z0=;
        b=v7q8m7u7+hyOdl2kLoTuqkmOSyasgAl+ysrV+wxLb/s7Mpss52bK5ccRO8/PIQ3EfU
         uQ/W0NFQBGJPcEdMWxKknGRcXhCXGS37ZKbkrtNV+uwa0HfrXhOzeATwia8YXU42HteD
         RBdaNPNgicmtsQXeMSQtWDtSbeZiyfRjitFdq1PMxBpx2WCYCX04rQ+QM5jVTjSwJm7+
         T9xIVKuNrTohwfPJFGEqG/HGdCveYHiCH8xtExbv1txVotT3ovceWW/yL/nGEH0M5Fc7
         f6puOqNE/fJlBxKbAxXzHejtQjRo2rgs/QVbQc7oTyA80fVuxPf2RN8MiMkqZgT4JkfE
         Rkbw==
X-Gm-Message-State: AOAM530hxC5vVm8s3g4vCBUZxqAQRXEnE8UiDmAu71oja9Sfu0mxWPGb
        hHgO97mzrCsCRdblP8xld+o=
X-Google-Smtp-Source: ABdhPJz9UVnjS1wI8OWZYKnPuiOruqdnhH1iP8ol4fYkUyqCT165STV35FH9oY8b1wLDLxyYYdD2aQ==
X-Received: by 2002:a5d:9ec2:: with SMTP id a2mr14674359ioe.44.1642560040779;
        Tue, 18 Jan 2022 18:40:40 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.58])
        by smtp.googlemail.com with ESMTPSA id l17sm11560206ilt.29.2022.01.18.18.40.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 18:40:40 -0800 (PST)
Message-ID: <7afac629-e1fd-db4c-5538-d88e74b0ae0b@gmail.com>
Date:   Tue, 18 Jan 2022 19:40:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH net 1/2] ipv4: avoid quadratic behavior in netns dismantle
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <20220118204646.3977185-1-eric.dumazet@gmail.com>
 <20220118204646.3977185-2-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220118204646.3977185-2-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/22 1:46 PM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> net/ipv4/fib_semantics.c uses an hash table of 256 slots,
> keyed by device ifindexes: fib_info_devhash[DEVINDEX_HASHSIZE]
> 
> Problem is that with network namespaces, devices tend
> to use the same ifindex.
> 
> lo device for instance has a fixed ifindex of one,
> for all network namespaces.
> 
> This means that hosts with thousands of netns spend
> a lot of time looking at some hash buckets with thousands
> of elements, notably at netns dismantle.
> 
> Simply add a per netns perturbation (net_hash_mix())
> to spread elements more uniformely.
> 
> Also change fib_devindex_hashfn() to use more entropy.
> 
> Fixes: aa79e66eee5d ("net: Make ifindex generation per-net namespace")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/ipv4/fib_semantics.c | 36 +++++++++++++++++-------------------
>  1 file changed, 17 insertions(+), 19 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


