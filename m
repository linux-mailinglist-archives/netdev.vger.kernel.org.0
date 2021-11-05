Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07BAF445F97
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 07:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhKEGMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 02:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhKEGMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 02:12:17 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28013C061714;
        Thu,  4 Nov 2021 23:09:38 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id m14so28753265edd.0;
        Thu, 04 Nov 2021 23:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SvWkC8sIKWk2uTn2LDUiYL203o6lBq4o2a+zBxr/B5Q=;
        b=B+q8GpPZ2cb+9OPUWfZXV2d5lT3UQD6tMtTtx1xWRb7EIYU3qTVwn8hxOL84Mmzg0y
         TUiocdG10Fx/oUBWLx2Rtsm8gjKaKNiSsXPs0M8NRXdKD52fSV2pg6jYG/i2JHMOvwjp
         EYmg7ezoB6VZ26Zvg4AUOVOczRUkMzwRCHuTtVOMfmT29PtvlFIEt8aXbz/QXVKc+KU6
         0+RDP7RKfG82xinKbkDztyGVFdWeDHgmojvy4erx1cWwRtoAJWY2bs9jBcV+KEaPPbK3
         C+JClIXAMpRV8USbz57JOiPf7jbredFdrlDq7mXO8czv4WfNGYeZkVglALBloL7wFYSS
         vMQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SvWkC8sIKWk2uTn2LDUiYL203o6lBq4o2a+zBxr/B5Q=;
        b=6ekBzmcnqIgnM1js00gfpDiY1B70bWKipt6Pe2t67IgNunnp4WAf5f10zt43C3lYw6
         PFrh7bNalAR/lorpOicgjeqcbQNuat0O308fnp7oUyPJl8A1/elRBGGRK1OMKp5wfyGg
         0NFXarvfpIDg1KwoN4p5FI2EUPG76Xf8//qELLzxtBgkJx7jI/K8VM/be5Qq4+s53N8U
         UdODtHNYWuEku7M0qgOtP6veTtV0lK8/h8VW5QDMkXy5HJ0WsiY0yUE9NxlgHgZKrzo3
         gbgE6S4YGCQmJum77FyerpwI7KfW+z8X1CtpwUY6af3X/DvM5tHnlUOrFDl/lHPTpc3r
         QFQA==
X-Gm-Message-State: AOAM531/WsI4AHajb/mnp4L6p6e/7myh80C14mLfmKQ24UswHgcX3gPR
        mJyzJ6dFFQKzxB2zUMCOkNM=
X-Google-Smtp-Source: ABdhPJwtvbbfo9zOG7xG6Cdi38/mJvqwzFVPhDpSIVTOSnl1Ru3HfTXQ4/dpBy02gnyFBHNbdtjv3A==
X-Received: by 2002:a17:906:6acd:: with SMTP id q13mr19642510ejs.426.1636092576664;
        Thu, 04 Nov 2021 23:09:36 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3800:fafc:6a7c:c046:18f4? ([2a04:241e:501:3800:fafc:6a7c:c046:18f4])
        by smtp.gmail.com with ESMTPSA id i13sm3417479edc.62.2021.11.04.23.09.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 23:09:36 -0700 (PDT)
Subject: Re: [PATCH v2 06/25] tcp: authopt: Compute packet signatures
To:     Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
References: <cover.1635784253.git.cdleonard@gmail.com>
 <5245f35901015acc6a41d1da92deb96f3e593b7c.1635784253.git.cdleonard@gmail.com>
 <7a32f18e-aa92-8fd8-4f53-72b4ef8b0ffc@gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <a115cbfa-b68a-422c-d6c2-034c77496823@gmail.com>
Date:   Fri, 5 Nov 2021 08:09:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <7a32f18e-aa92-8fd8-4f53-72b4ef8b0ffc@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/21 4:08 AM, Dmitry Safonov wrote:
> On 11/1/21 16:34, Leonard Crestez wrote:
> [..]
>> +/* Find TCP_AUTHOPT in header.
>> + *
>> + * Returns pointer to TCP_AUTHOPT or NULL if not found.
>> + */
>> +static u8 *tcp_authopt_find_option(struct tcphdr *th)
>> +{
>> +	int length = (th->doff << 2) - sizeof(*th);
>> +	u8 *ptr = (u8 *)(th + 1);
>> +
>> +	while (length >= 2) {
>> +		int opcode = *ptr++;
>> +		int opsize;
>> +
>> +		switch (opcode) {
>> +		case TCPOPT_EOL:
>> +			return NULL;
>> +		case TCPOPT_NOP:
>> +			length--;
>> +			continue;
>> +		default:
>> +			if (length < 2)
>> +				return NULL;
> 
> ^ never true, as checked by the loop condition
> 
>> +			opsize = *ptr++;
>> +			if (opsize < 2)
>> +				return NULL;
>> +			if (opsize > length)
>> +				return NULL;
>> +			if (opcode == TCPOPT_AUTHOPT)
>> +				return ptr - 2;
>> +		}
>> +		ptr += opsize - 2;
>> +		length -= opsize;
>> +	}
>> +	return NULL;
>> +}
> 
> Why copy'n'pasting tcp_parse_md5sig_option(), rather than adding a new
> argument to the function?

No good reason.

There is a requirement in RFC5925 that packets with both AO and MD5 
signatures be dropped. This currently works but the implementation is 
convoluted: after an AO signature is found an error is returned if MD5 
is also present.

A better solution would be to do a single scan for both options up 
front, for example in tcp_{v4,v6}_auth_inbound_check

--
Regards,
Leonard
