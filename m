Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A25249D399
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 21:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbiAZUgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 15:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbiAZUgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 15:36:44 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C58C061748
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 12:36:44 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id s127so1949287oig.2
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 12:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=35S8tgpHULFJ/y//jy/TOoDZpSuHmOCLjl+35Yer560=;
        b=WWSCzjpvWMd5OOMCWLD29GJ5f+62TLAfl0w6H7UmnXw34kLbg+7AZEKyZYvjTSHgC+
         CjdoKp3Q6yc6FCqSreQe4pn/68HTNUEl32tbpIp2Ao5PNMkTGNhEaPyoYGsEV61z8GHI
         ZzhMUomswwsuRFpGB38eSS4QoGI0QFQaXGLNGuhxyjbDnOZWopEa6RshvZAluWpFKTM2
         COKsnLyu9F4PNtybA7urdFyOx9Z4kfRNZUoLegT36axmPXQcoQsazSKrBdLU5mNuow18
         swSdyMmVfadFHbcNPhdxDuJnflXPyDymmJZKylfzexlgAAne66sfuVx6u2Y4jcHPiI4t
         kzYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=35S8tgpHULFJ/y//jy/TOoDZpSuHmOCLjl+35Yer560=;
        b=3aw7BUGAqnAZ7Dvpvc1j7Nm/tMIXRbuqTi88WlMmZfXyHOw4Ux7l1OGNCrmoUtFttW
         4jzcjE4+i0bpeM0ddRhBzAMCXuQd1hL3TxamBNgY1KWbq4gVJhSyaLcOrUIPaCLZeB16
         88JC9Z0N5CehsruNK5vmS/saLxOOiOTr9JhSYLktXLxhf3vMCrkXV2NXvCb57+c5okk9
         6gHI6BI750fT/p0UExBt3QnXFIGTT1bsylAdre2JOoQnzHC3EkKQdqPdR3CzHZup122R
         h8+6a78imvkllqRiMa8dxfcN/xEOHE0+JZa/ZBhEhZ5RfcLXUxK5LBRTqyzvJqFEti0G
         4/rA==
X-Gm-Message-State: AOAM530YQxqJ73wpm1cD3iwqK2MnYpiNH5ZbTH0/Hbrlc2NeyfMh1Y8N
        BZqRqsydii8o42+VFaquY9A=
X-Google-Smtp-Source: ABdhPJwzUvx8Bk7X8lM697yS0dm7+Q3+WPBuq4RB3ofUPNi+RoBtlcNl77wYugYDo5is91fVSxyeyQ==
X-Received: by 2002:a05:6808:13cb:: with SMTP id d11mr230510oiw.25.1643229403586;
        Wed, 26 Jan 2022 12:36:43 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:1502:2fac:6dee:881? ([2601:282:800:dc80:1502:2fac:6dee:881])
        by smtp.googlemail.com with ESMTPSA id d65sm3443971otb.17.2022.01.26.12.36.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 12:36:43 -0800 (PST)
Message-ID: <9ebf3ddb-4247-d4a2-2354-6ca955f0b1cf@gmail.com>
Date:   Wed, 26 Jan 2022 13:36:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net 2/2] ipv4: avoid using shared IP generator for
 connected sockets
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Ray Che <xijiache@gmail.com>, Willy Tarreau <w@1wt.eu>
References: <20220126200518.990670-1-eric.dumazet@gmail.com>
 <20220126200518.990670-3-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220126200518.990670-3-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/22 1:05 PM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> ip_select_ident_segs() has been very conservative about using
> the connected socket private generator only for packets with IP_DF
> set, claiming it was needed for some VJ compression implementations.
> 
> As mentioned in this referenced document, this can be abused.
> (Ref: Off-Path TCP Exploits of the Mixed IPID Assignment)
> 
> Before switching to pure random IPID generation and possibly hurt
> some workloads, lets use the private inet socket generator.
> 
> Not only this will remove one vulnerability, this will also
> improve performance of TCP flows using pmtudisc==IP_PMTUDISC_DONT
> 
> Fixes: 73f156a6e8c1 ("inetpeer: get rid of ip_id_count")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Ray Che <xijiache@gmail.com>
> Cc: Willy Tarreau <w@1wt.eu>
> ---
>  include/net/ip.h | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

