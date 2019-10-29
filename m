Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 310E6E9130
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 22:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbfJ2VDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 17:03:11 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35891 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726711AbfJ2VDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 17:03:11 -0400
Received: by mail-pl1-f195.google.com with SMTP id g9so7683006plp.3;
        Tue, 29 Oct 2019 14:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g2p2UomPud0WmT2AcKDqSrdNqtj5uGlkNFExAHANMTs=;
        b=gTxeBvety6PyostFgbk1f0nfM81NR6rTPqgcB1L68JhnzzQG8EFAjX8So0PTjaaT4K
         0GGCfxBR0obDBZxnbkjkF7RPNijqEOLe8lwG6fBZmW3mwCKLN67CGFH2WWT/jufefyNo
         qNWVkSjV4+lfQhl3/iTJ6EaC+KU9Y28L3tE/56SC5JX9GonnvHTKPiv0vbD3HEcKaxxt
         1Jj2j1NxqN6hXE9yqQa4mnEokBluydmfTUYwtolyPnMhH7S3fEYfB2WbeDKMb6pjG2M7
         +sB80Qj6wlgydkkLY4di7HhqI1RWxG7b23QDwJmGP/g9ZMUIIq3KmUKgXdW+Im8iCaMb
         FGxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g2p2UomPud0WmT2AcKDqSrdNqtj5uGlkNFExAHANMTs=;
        b=esvwrDU+QhIwWp9+mRVzIliFWQESLsb27R5c/92AW6Tb8/i7UzHlsmAqyFiBHPBIDt
         438mcp/lHC5EdZ5GsBDb5xUHBBG2Vt864Gn0wjZJPQQ+tcsYgu1cm2iXOyoWndHbzZ+k
         WtFGbNC+XDGX8HJFFi+8PkjxuTQZv4KpcbNETlwXM1J9QOQDrLcTzUwmy4w2mmZzfTee
         y4Dg338lmWu2ZoiXGXXz1SBDr+D7d4Gnd5iu9Nci+iYKulHPqGDkP+dERU9Fy8BIz24n
         kDV05yjj/SVY/yPj4y6qU2hnvEDB/+d6YTzUQ2O7tuHOJGopeFjchtE4Zrf8AkOM4fQy
         PmMA==
X-Gm-Message-State: APjAAAV0iu7kKsuirOCzCVjWyO1iJ+cH8vuatuRKxJSJkDe+hSznhZx7
        FLGZI20IpXwh2i4lYetJaV8m4hG1
X-Google-Smtp-Source: APXvYqwd+wri2SwMiryUSsJ//80fA74ecxBRjJaZ8TXlEk0AudxZ0x6W1gqXZ6cl9M03/i463Q3MSw==
X-Received: by 2002:a17:902:8606:: with SMTP id f6mr707876plo.226.1572382990163;
        Tue, 29 Oct 2019 14:03:10 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id f7sm17331pfa.150.2019.10.29.14.03.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Oct 2019 14:03:09 -0700 (PDT)
Subject: Re: [PATCH net-next v2 4/4] bonding: balance ICMP echoes in layer3+4
 mode
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Matteo Croce <mcroce@redhat.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Paul Blakey <paulb@mellanox.com>, linux-kernel@vger.kernel.org
References: <20191029135053.10055-1-mcroce@redhat.com>
 <20191029135053.10055-5-mcroce@redhat.com>
 <5be14e4e-807f-486d-d11a-3113901e72fe@cumulusnetworks.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <576a4a96-861b-6a86-b059-6621a22d191c@gmail.com>
Date:   Tue, 29 Oct 2019 14:03:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <5be14e4e-807f-486d-d11a-3113901e72fe@cumulusnetworks.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/29/19 11:35 AM, Nikolay Aleksandrov wrote:

> Hi Matteo,
> Wouldn't it be more useful and simpler to use some field to choose the slave (override the hash
> completely) in a deterministic way from user-space ?
> For example the mark can be interpreted as a slave id in the bonding (should be
> optional, to avoid breaking existing setups). ping already supports -m and
> anything else can set it, this way it can be used to do monitoring for a specific
> slave with any protocol and would be a much simpler change.
> User-space can then implement any logic for the monitoring case and as a minor bonus
> can monitor the slaves in parallel. And the opposite as well - if people don't want
> these balanced for some reason, they wouldn't enable it.
> 

I kind of agree giving user more control. But I do not believe we need to use the mark
(this might be already used by other layers)

TCP uses sk->sk_hash to feed skb->hash.

Anything using skb_set_owner_w() is also using sk->sk_hash if set.

So presumably we could add a generic SO_TXHASH socket option to let user space
read/set this field.

