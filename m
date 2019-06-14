Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE2F45397
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 06:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbfFNE2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 00:28:25 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35628 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbfFNE2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 00:28:24 -0400
Received: by mail-pf1-f195.google.com with SMTP id d126so607899pfd.2;
        Thu, 13 Jun 2019 21:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MynhCFGpqGZRdy/9WKV4HLYAsGzpq7c+1tDJnUMvrZU=;
        b=J+8uMKYNoOLsfTiXqiLyLoLc/SKcQPM9blclrSKHTa0mZt/o49S/fk3/09YAF0ROEa
         5Fv4UtfTdD83CaoDMEDg28fReb4uBw4/f12GFNABPDwG3oIERxrH1z3ULZh3CJMJwNdc
         wuLzQhDgAtBx6RXjVnrZZ988vY5Nw/duo20whUJ7ylu9nMGXnT31WWcCdffxG4P5292L
         fo8iPsU42wHFZbIKukXN1Gbk3siox/m6nCcpXRwwJLTQuedQMw+lNnOaJBR5gtYhnTGL
         QKQiq96f0gyj/c0Ox3mBO1fKNPCWw9PeG5rKydU9F+azg1wu2+jv65NguR+3AzuXOmAL
         ouYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MynhCFGpqGZRdy/9WKV4HLYAsGzpq7c+1tDJnUMvrZU=;
        b=guoR9syc+U2MPGIlXIBHuS6ctgWVotrOGzSv8cKKHU9N2BvW/ludaXMkiq02cVaYCI
         t4Ji89My9Mg+YCnKRQODMZuqk/0/gRP/pd7p0c5dx+L0RV6QerhNrg93uuUsNiaIjrz2
         KOrb8dL/i5Vx4telc3i8Az1soEWidpcfTCQxZUAhVr3U3/qcOR2xUksb/UWviteHFPqL
         vhGndzVZ7aX8Gk80HpZhYB/SPHtSk2aD6H749kfl1OFu0LWn1CqiA8DorUJ+RwT+h/De
         rsJHHFGaxovy0AwABlbCJmANBhId8y+7LHkkcoGZzg1OC1D3VyXdqq6cykGtTjh5Ncrn
         T3wQ==
X-Gm-Message-State: APjAAAVjrNSIKX93pnIA6DxgBUqjUq3YRtZ7SzMrHSzuGfxvuEmiWiCV
        YcMP+xkwuso4FKcbp2ffbGCcqoh6
X-Google-Smtp-Source: APXvYqw+BQOi0FiBUnJ45W4DRoySNDYogOjvGRoUpm9jvDMkGgZVHjWDY/OaqrJs1zI9Ok5sN774OQ==
X-Received: by 2002:a17:90a:30e4:: with SMTP id h91mr8614183pjb.37.1560486503596;
        Thu, 13 Jun 2019 21:28:23 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id s7sm1287340pgm.8.2019.06.13.21.28.22
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 21:28:22 -0700 (PDT)
Subject: Re: [PATCH net v2] tcp: avoid creating multiple req socks with the
 same tuples
To:     maowenan <maowenan@huawei.com>, Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20190612035715.166676-1-maowenan@huawei.com>
 <CANn89iJH6ZBH774SNrd2sUd_A5OBniiUVX=HBq6H4PXEW4cjwQ@mail.gmail.com>
 <6de5d6d8-e481-8235-193e-b12e7f511030@huawei.com>
 <a674e90e-d06f-cb67-604f-30cb736d7c72@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6aa69ab5-ed81-6a7f-2b2b-214e44ff0ada@gmail.com>
Date:   Thu, 13 Jun 2019 21:28:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <a674e90e-d06f-cb67-604f-30cb736d7c72@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/13/19 9:19 PM, maowenan wrote:
> 
> 
> @Eric, for this issue I only want to check TCP_NEW_SYN_RECV sk, is it OK like below?
>  +       if (!osk && sk->sk_state == TCP_NEW_SYN_RECV)
>  +               reqsk = __inet_lookup_established(sock_net(sk), &tcp_hashinfo,
>  +                                                       sk->sk_daddr, sk->sk_dport,
>  +                                                       sk->sk_rcv_saddr, sk->sk_num,
>  +                                                       sk->sk_bound_dev_if, sk->sk_bound_dev_if);
>  +       if (unlikely(reqsk)) {
> 

Not enough.

If we have many cpus here, there is a chance another cpu has inserted a request socket, then
replaced it by an ESTABLISH socket for the same 4-tuple.

We need to take the per bucket spinlock much sooner.

And this is fine, all what matters is that we do no longer grab the listener spinlock.
