Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0E6127F33
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 16:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727532AbfLTPX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 10:23:29 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:33153 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727435AbfLTPX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 10:23:29 -0500
Received: by mail-il1-f196.google.com with SMTP id v15so8274602iln.0
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 07:23:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SK5Yc+wiZfz8hPTRLpurDcgLGmgG0HrXKwSnWxtV3tU=;
        b=d/rvxzYZKMuuPzSXEu+dTM+wRKf1jP/0Q4nGQ2g361uabWBQZJbiy7vajFm7zj0NIY
         sh5Ot6+xXfPBsO+SCc7XrqBjWAoOO8I+iaYBIjLgRKKIq1lcpdpRgviq1roa+LqbAtC6
         V8xaw8pBynd4SQ9jQ3heih0Plvb3cMPsGRrX0eaSUiEojqHnAkPSrc4NC5t5YiHChOo6
         gf+z/icCzs48ZtCLVhI+eUZJxygyRRKyHPxgiL3Gk94amhU7pQqHAXzpuFPIgM1miRzE
         wDLrSj4DfXJrH9xx9l07WNGPseNAtONh2v/hWuL0waqjhPiIxGd1rpbI6IMWHYA+FK7I
         5yyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SK5Yc+wiZfz8hPTRLpurDcgLGmgG0HrXKwSnWxtV3tU=;
        b=k4h1U9AhuKRBHgygpyzBHBIQYwmJ+2wBwHTamwvRJsMTNLiT4HrSxFU0ilGqHNbFRr
         AYZPPlLEpHeyPs8je09ZVI3L7ykQc5CqtFDfmQLzMjIVjAYYl0xEhiJg80KMsRh4Zxok
         ZaMDi5QhWbrkxnRTFQzlCLCumTaQgV/0GHm2LJKkTuKGw9h7M1RSU8vw1jObErcdd34N
         hwaPW2REOu1ZIqRi9VcrqRnDU2o5lG2LnCuKedG7z3lDSXhsbray3h8tnOrvDv4t/sRQ
         mPZM/Ug/fqemn7t/wjanx2EmqiecxaO3t+4eD7b6TiIRJsnC+XjLleF/wWWZPBerbCeK
         oUaw==
X-Gm-Message-State: APjAAAU0J5FJxXIfd9Do+cdOXm+f2JQMZ6U8AgH4Oo8I77QW5U+X1TYH
        UY7sO84GlAsU7CvqfU7ovFj/YA==
X-Google-Smtp-Source: APXvYqyuR+SQhmDt+gmOwM2FvuSKtZyZVEH21ajCN6QqXcb/RsyY0yMqSsMQs1RO9BWckfwA1Cfs8g==
X-Received: by 2002:a92:1f16:: with SMTP id i22mr13267757ile.206.1576855408582;
        Fri, 20 Dec 2019 07:23:28 -0800 (PST)
Received: from [10.0.0.194] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id k20sm3424061iog.18.2019.12.20.07.23.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 07:23:27 -0800 (PST)
Subject: Re: [PATCH net 1/2] net/sched: cls_u32: fix refcount leak in the
 error path of u32_change()
To:     Davide Caratti <dcaratti@redhat.com>,
        Vlad Buslov <vladbu@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Roman Mashak <mrv@mojatatu.com>
References: <cover.1576623250.git.dcaratti@redhat.com>
 <ae83c6dc89f8642166dc32debc6ea7444eb3671d.1576623250.git.dcaratti@redhat.com>
 <bafb52ff-1ced-91a4-05d0-07d3fdc4f3e4@mojatatu.com>
 <5b4239e5-6533-9f23-7a38-0ee4f6acbfe9@mojatatu.com>
 <vbfr2102swb.fsf@mellanox.com>
 <63fe479d-51cd-eff4-eb13-f0211f694366@mojatatu.com>
 <vbfpngk2r9a.fsf@mellanox.com> <vbfo8w42qt2.fsf@mellanox.com>
 <b9b2261a-5a35-fdf7-79b5-9d644e3ed097@mojatatu.com>
 <548e3ae8-6db8-a45c-2d9c-0e4a09dc737b@mojatatu.com>
 <cc0a3849-48c0-384d-6dd5-29a6763695f2@mojatatu.com>
 <vbfa77n2iv8.fsf@mellanox.com>
 <02026181-9a29-2325-b906-7b4b2af883a2@mojatatu.com>
 <9a2cd9ea1abdd43d19f07aeb3f66765df74953d5.camel@redhat.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <e1873eb3-bdc0-a59c-b235-a84eb6018c85@mojatatu.com>
Date:   Fri, 20 Dec 2019 10:23:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <9a2cd9ea1abdd43d19f07aeb3f66765df74953d5.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-12-20 10:20 a.m., Davide Caratti wrote:

[..]
>
> ... ok, I can try to do a series that reverts the fix on cls_u32 and
> implements the check_delete_empty for cls_flower. You might find it above
> the christmas tree (*)?
> 

Thanks Davide. Please go for it..

cheers,
jamal
