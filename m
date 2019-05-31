Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5066331095
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 16:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfEaOuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 10:50:11 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40166 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbfEaOuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 10:50:11 -0400
Received: by mail-pg1-f194.google.com with SMTP id d30so4172036pgm.7;
        Fri, 31 May 2019 07:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=niGDWjkeGkPu2SHMJnT3bwHQ2nofloA1S2IY3FiAU04=;
        b=CRSXQ0UBsES/yVHCiqTo1JV5y5KcGsVpzHC6c6NnPN8JB62r0ABfBgiKYIOn4UmX2Z
         9WmFt2fv4kL+72pT4N7ArkgjspHBttXu/Sl+HRhWZT0yxcyrtqyrbGVaVRqjipSY3MwP
         ehN5TLQbKKFIAqkTUVuSwU5JXWGt0hfdZiMo/U8MPkPgs85CkUqolx94bbfGbgG8WL7t
         /PMC43Cuze/kZJwxatBlkDurfGFckdoErjJ6HeZM+alW0PpZWrYNPAiMlaiCmIp0/B7+
         uloXCv3lsT4fgFXuLEX7efW3xBZ850qUFdn1zPJzYN1o9c8maigW8L4SkOEW5ve1akIH
         amyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=niGDWjkeGkPu2SHMJnT3bwHQ2nofloA1S2IY3FiAU04=;
        b=Pvb67oihLF2nQOeISBzmlRij+CslU6DF2WuDdn+ncD3KG2MEMSFRrwB8vUeIBsSeLQ
         NkhKBjayhQBTQyiA4RaJj1mbBfENu1UDrY7eBKhGECiTyEKNa9NEmDuwIOU5i1Zqjaes
         0Qi81CoCDJZBRBsvo8UKHVphAc9ZufkgC1aMe4ufCBZy2IuYlm70KW9lVGXeJk4dI34S
         cF+huGt0ES9iKrs5b6dYsSQm+lGdXNe4sd3qvLmFhXf/uL7ERhLgS5634aD7X1cB9mUH
         isEixvdBf99bzlLImnG0zIoKvPWaDASAYD8OYusL0M+jR9wkHPHp+aSd8HrfkRhOjNyu
         phSQ==
X-Gm-Message-State: APjAAAXh569SLXgvfP3USpZNLs/KCypb4Jzdqz0nS7rOBY/WnfgwjftJ
        ALigFZdyPn6SzhkbDspTn+Q=
X-Google-Smtp-Source: APXvYqx0tsvlILBu4wmyozGovBzJJ5R8FK9B9FFznZhDPyBkP0km6SbpswFoucbjo245x2pIsmenaQ==
X-Received: by 2002:a65:638e:: with SMTP id h14mr8599983pgv.209.1559314210512;
        Fri, 31 May 2019 07:50:10 -0700 (PDT)
Received: from [192.168.84.42] ([107.241.92.149])
        by smtp.gmail.com with ESMTPSA id h3sm14861588pfq.66.2019.05.31.07.50.08
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 07:50:09 -0700 (PDT)
Subject: Re: [PATCH] ipv6: Prevent overrun when parsing v6 header options
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Young Xiao <92siuyang@gmail.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
References: <1559230098-1543-1-git-send-email-92siuyang@gmail.com>
 <c83f8777-f6be-029b-980d-9f974b4e28ce@gmail.com>
 <20190531062911.c6jusfbzgozqk2cu@gondor.apana.org.au>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <727c4b18-0d7b-b3c6-e0bb-41b3fe5902d3@gmail.com>
Date:   Fri, 31 May 2019 07:50:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190531062911.c6jusfbzgozqk2cu@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/30/19 11:29 PM, Herbert Xu wrote:
> On Thu, May 30, 2019 at 10:17:04AM -0700, Eric Dumazet wrote:
>>
>> xfrm6_transport_output() seems buggy as well,
>> unless the skbs are linearized before entering these functions ?
> 
> The headers that it's moving should be linearised.  Is there
> something else I'm missing?
> 

What do you mean by should ?

Are they currently already linearized before the function is called,
or is it missing and a bug needs to be fixed ?


