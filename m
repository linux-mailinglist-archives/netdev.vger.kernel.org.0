Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3E33949E5
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 03:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhE2B7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 21:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhE2B7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 21:59:10 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F885C061574
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 18:57:33 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id a13so712760oid.9
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 18:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bN5T9UJA2W/AXLDc5/SRR9kIwOvMumXZzHyNftS/k4M=;
        b=CMAFXNzDrnfP2muO8F4DLmAQHm4SSf7bQ8ZVsbA9WKd+WmjT0ua91PHKh67Sh0vY3W
         Kj1jG9KVrIPK3VsLBRc0+3TBrTlZ+1aLeMUxEDV05b3/vYKaZlADc7hky2D5xFkiKtSH
         Iz2E0tnozxTaiFA3kwD9ozdXskLP0/5ratkx0ePuphOFXhPAPi7a0cUBH+vSx8w10foC
         1RNGDsQXfzlLlW13np8WqFi2WAfh5FaaCzUBaKI2gxoboueL+LrX7+dyYgO1Ev5n11KA
         7T6tuMkz2tMccbsoowIhP/QHlFkphIcVHHQwzoaa4FdM/94xVVyIjsT+W+h1heEYSddL
         9q7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bN5T9UJA2W/AXLDc5/SRR9kIwOvMumXZzHyNftS/k4M=;
        b=tUHvE3NO1OC92UsT7dRJGTX0Rm9ej5l3I47FAyRYZRt5b7pwTJK6o0vy4hsOCq+cUV
         UbHgC1CxaFHdGG/7GjnxxOp37CRZq633DZ2LdE00rht9BME/5WwUlox3iMmqzqcNaGDr
         8OC1MYbIut5bzl5WURBilJNOTI6sqO5dpE49nvmOWh6mq4lTohIuI+EODqdbb1LNK+bS
         zapLleCxOeYx+Fu3n3+tbemUtUaaQDR7iPuRKHmL0R5DE6ViuoiM9ImxgF98o/Tgywgv
         8uJhqH5EtUD6cwNy90IgxennconCsjU/cuWMAezJzRwdPezM3j3zckzPDB96WBoyL875
         LRTA==
X-Gm-Message-State: AOAM530rTuMh9UCUrJ/jc9p2oC2vNPwCnrGRHtsWCirtXMHSHwW+eFIR
        8bSgqS2J9Ap5R00p26J78+o=
X-Google-Smtp-Source: ABdhPJz95tFbo6TEMrzqt93Lp5HZxuuW+Yazw/xfCGjR8ly7t00RdBP5aAberjTVixiCmvGk2gOCgg==
X-Received: by 2002:aca:1718:: with SMTP id j24mr10921308oii.81.1622253452496;
        Fri, 28 May 2021 18:57:32 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id l12sm27699otr.16.2021.05.28.18.57.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 May 2021 18:57:32 -0700 (PDT)
Subject: Re: [PATCH net] udp: fix the len check in udp_lib_getsockopt
To:     Xin Long <lucien.xin@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <04cb0c7f6884224c99fbf656579250896af82d5b.1622142759.git.lucien.xin@gmail.com>
 <CADvbK_e0PkKBYAUyg6iYyUwUp+owpv1r9_cnS7pbkLSjwX+VWg@mail.gmail.com>
 <20210528153911.4f67a691@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CADvbK_dvj2ywH5nQGcsjAWOKb5hdLfoVnjKNmLsstk3R1j7MyA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <54cb4e46-28f9-b6db-85ec-f67df1e6bacf@gmail.com>
Date:   Fri, 28 May 2021 19:57:30 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <CADvbK_dvj2ywH5nQGcsjAWOKb5hdLfoVnjKNmLsstk3R1j7MyA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/21 7:47 PM, Xin Long wrote:
> The partial byte(or even 0) of the value returned due to passing a wrong
> optlen should be considered as an error. "On error, -1 is returned, and
> errno is set appropriately.". Success returned in that case only confuses
> the user.

It is feasible that some app could use bool or u8 for options that have
0 or 1 values and that code has so far worked. This change would break that.
