Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB905E8F72
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 19:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731871AbfJ2Slz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 14:41:55 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36898 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731846AbfJ2Slz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 14:41:55 -0400
Received: by mail-lj1-f196.google.com with SMTP id v2so2165287lji.4
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 11:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7UdfhwQKek0cH5FgF1E74MWZWlb9IUQkDORwZcKXCak=;
        b=M3/bLectZcXwmLc34MYtf27awinWIl5Qzf98rPOu/TLfav+pBaCKwWmHcTtc8aky6d
         Jeq09Lwn6XuZzDKnzkz9C9bfvPmjBrRLUPiduFecaJmgxi+YCqLfbRW6DQf4OGZivfkh
         YFG7Guc2d+yWQ2Q4U/ASm4Ag/YxvomssgXHWs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7UdfhwQKek0cH5FgF1E74MWZWlb9IUQkDORwZcKXCak=;
        b=W3BB604K6AncrxlUj5BxaviWBq3lXKVuubn7LNJpLka/b920Armbk+aQSJcnCrs2pN
         VUlOTsTmnEY2sygTBwcmBqfM/DlfKmLIO9lTqCOTrUBXTamaoCwQVgijAfxXErXgWY9L
         uhtDwhJHBP+z/3BQByEQbGfyC1MVDKpnm3av/3zfjuLHJFBChNIzmxp7z1kH+WG1sSKq
         ugbHmbuFzm8dAL0lUlNVT9dg1TV/ZNJueg2YRsy8g4pLmeYUHMZcp1/wNKQbJdWS8SDB
         BPFD6b0DhRikjPW3nB1RQAXuRqHbMiyD31IleSJNgKg+KJRw9ybqr4szKfpqoEGHaWbl
         n9Gg==
X-Gm-Message-State: APjAAAWX0CBiIysbBSC2yOh2u+kpjEw2abWbqmnbUWpLKNJtrwdJQdWl
        aSTZCln7qqNCvwkbaD4wKQL/7A==
X-Google-Smtp-Source: APXvYqxv/l6+QjoCAAGlN8tI+iV+MdWR1cqqFj0hZduxO1wdtE+1ApYZf8XQE0iPbk4RvvEC+vWx1w==
X-Received: by 2002:a2e:80c1:: with SMTP id r1mr3696418ljg.195.1572374512118;
        Tue, 29 Oct 2019 11:41:52 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id b2sm10414295lfq.27.2019.10.29.11.41.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Oct 2019 11:41:51 -0700 (PDT)
Subject: Re: [PATCH net-next v2 4/4] bonding: balance ICMP echoes in layer3+4
 mode
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     Matteo Croce <mcroce@redhat.com>, netdev@vger.kernel.org
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
Message-ID: <a7ef0f1b-e7f5-229c-3087-6eaed9652185@cumulusnetworks.com>
Date:   Tue, 29 Oct 2019 20:41:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <5be14e4e-807f-486d-d11a-3113901e72fe@cumulusnetworks.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/10/2019 20:35, Nikolay Aleksandrov wrote:
> On 29/10/2019 15:50, Matteo Croce wrote:
>> The bonding uses the L4 ports to balance flows between slaves. As the ICMP
>> protocol has no ports, those packets are sent all to the same device:
>>
>>     # tcpdump -qltnni veth0 ip |sed 's/^/0: /' &
>>     # tcpdump -qltnni veth1 ip |sed 's/^/1: /' &
>>     # ping -qc1 192.168.0.2
>>     1: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 315, seq 1, length 64
>>     1: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 315, seq 1, length 64
>>     # ping -qc1 192.168.0.2
>>     1: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 316, seq 1, length 64
>>     1: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 316, seq 1, length 64
>>     # ping -qc1 192.168.0.2
>>     1: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 317, seq 1, length 64
>>     1: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 317, seq 1, length 64
>>
>> But some ICMP packets have an Identifier field which is
>> used to match packets within sessions, let's use this value in the hash
>> function to balance these packets between bond slaves:
>>
>>     # ping -qc1 192.168.0.2
>>     0: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 303, seq 1, length 64
>>     0: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 303, seq 1, length 64
>>     # ping -qc1 192.168.0.2
>>     1: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 304, seq 1, length 64
>>     1: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 304, seq 1, length 64
>>
>> Aso, let's use a flow_dissector_key which defines FLOW_DISSECTOR_KEY_ICMP,
> 
> Also ?
> 
>> so we can balance pings encapsulated in a tunnel when using mode encap3+4:
>>
>>     # ping -q 192.168.1.2 -c1
>>     0: IP 192.168.0.1 > 192.168.0.2: GREv0, length 102: IP 192.168.1.1 > 192.168.1.2: ICMP echo request, id 585, seq 1, length 64
>>     0: IP 192.168.0.2 > 192.168.0.1: GREv0, length 102: IP 192.168.1.2 > 192.168.1.1: ICMP echo reply, id 585, seq 1, length 64
>>     # ping -q 192.168.1.2 -c1
>>     1: IP 192.168.0.1 > 192.168.0.2: GREv0, length 102: IP 192.168.1.1 > 192.168.1.2: ICMP echo request, id 586, seq 1, length 64
>>     1: IP 192.168.0.2 > 192.168.0.1: GREv0, length 102: IP 192.168.1.2 > 192.168.1.1: ICMP echo reply, id 586, seq 1, length 64
>>
>> Signed-off-by: Matteo Croce <mcroce@redhat.com>
>> ---
>>  drivers/net/bonding/bond_main.c | 77 ++++++++++++++++++++++++++++++---
>>  1 file changed, 70 insertions(+), 7 deletions(-)
>>
> 
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

Ooh I just noticed you'd like to balance replies as well. Nevermind

> Or maybe I've misunderstood why this change is needed. :)
> It would actually be nice to include the use-case which brought this on
> in the commit message.
> 
> Cheers,
>  Nik
> 

