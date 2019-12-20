Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3B70128064
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 17:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbfLTQMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 11:12:00 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:45136 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfLTQMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 11:12:00 -0500
Received: by mail-io1-f65.google.com with SMTP id i11so9876682ioi.12
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 08:12:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CDfz3f0Tlr53S77GM6ZLIwrz178tJAbAckyewBuQbLc=;
        b=lwFWI8E6tifwTnkvmkyw8ItImdCC/+1b8TUilLQlO6bLa4MmskbH1gzARlQ7akLkpu
         NRBZ//KAio1BgemFIrLlU8+5xvPqWSUuFCYA01aIj9bnx9qusWArX/SSBhw92HISD8o/
         fObsDUE2CJhJWsBCgf0o2snHM/1z7A83zodwiwX97VvjTBzV3noC8hmILUP9sYxsEvxl
         s+fAluPSzaz62IAOpdkJoyThZfVMUCwTgPHuOoa7d6FTrvObeP+6b2zoibdYxBsCTFb9
         AaqmkGMUU6oUweckcXXDD6gMviHB6rW7A71LaNaEUj9xw0i+FJZec5NPMJbOPf5Z6OmS
         NZ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CDfz3f0Tlr53S77GM6ZLIwrz178tJAbAckyewBuQbLc=;
        b=NaStpIeuGMwRmmT1H9WU40rtF+3BSEUwI/jUlYGJEWabU0aDuGEJqmH/78yZpdbgN7
         2re8V0xY6OHqtHSTzS9fUiVKtmUX6Ec3nbv2sPF2t85RiKMQr10Ksxva0VW5p2noEm7E
         m8rMZxKTm+ATe8CIbuJGsywiO571mkOgLB5234FeoDqR8X/pr59vXjsEgmNmM9digEC4
         DTUAEatUMW1zW4PiOrHHGHQK2z7UJXFEQlBMg0LnwWLbeJFI5JE7mQo4/vUbu+uB81Td
         PuFDib/oJHY9Rs+6JlzwSj4JZMTa2JrwU2DXbgxMbVDISvBLUXwn+izWsE6WCvs98XIX
         QpPw==
X-Gm-Message-State: APjAAAVuRGPN5+ZGGRkGMDMXdGWlQTYDNOrnADdsP8MqyLE9CF8yx+ef
        2UyXfSTUjXyv7nrqzdjV1e0=
X-Google-Smtp-Source: APXvYqzhYWfzxZhsDhuoUWpWBJX8tdz6TLl488WoEDyWoQNJ10RpArf5qEo6qkQh0039/ISOK/91AA==
X-Received: by 2002:a6b:39d4:: with SMTP id g203mr461597ioa.100.1576858319777;
        Fri, 20 Dec 2019 08:11:59 -0800 (PST)
Received: from ?IPv6:2601:282:800:fd80:d462:ea64:486f:4002? ([2601:282:800:fd80:d462:ea64:486f:4002])
        by smtp.googlemail.com with ESMTPSA id u29sm4854918ill.62.2019.12.20.08.11.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 08:11:57 -0800 (PST)
Subject: Re: [RFC net-next 11/14] tun: run XDP program in tx path
To:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgense?= =?UTF-8?Q?n?= 
        <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
 <20191218081050.10170-12-prashantbhole.linux@gmail.com>
 <20191218110732.33494957@carbon> <87fthh6ehg.fsf@toke.dk>
 <20191218181944.3ws2oy72hpyxshhb@ast-mbp.dhcp.thefacebook.com>
 <35a07230-3184-40bf-69ff-852bdfaf03c6@gmail.com> <874kxw4o4r.fsf@toke.dk>
 <5eb791bf-1876-0b4b-f721-cb3c607f846c@gmail.com>
 <75228f98-338e-453c-3ace-b6d36b26c51c@redhat.com>
 <3654a205-b3fd-b531-80ac-42823e089b39@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3e7bbc36-256f-757b-d4e0-aeaae7009d6c@gmail.com>
Date:   Fri, 20 Dec 2019 09:11:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <3654a205-b3fd-b531-80ac-42823e089b39@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/19/19 9:46 PM, Prashant Bhole wrote:
> 
> "It can improve container networking where veth pair links the host and
> the container. Host can set ACL by setting tx path XDP to the veth
> iface."

Just to be clear, this is the use case of interest to me, not the
offloading. I want programs managed by and viewable by the host OS and
not necessarily viewable by the guest OS or container programs.
