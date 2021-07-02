Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF793BA2BA
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 17:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbhGBP00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 11:26:26 -0400
Received: from www259.your-server.de ([188.40.28.39]:58460 "EHLO
        www259.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231713AbhGBP00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 11:26:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=waldheinz.de; s=default1911; h=MIME-Version:Content-Type:In-Reply-To:
        References:Subject:Cc:To:From:Message-ID:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=nStVgpcXzlVWGkURbYzlX5z+OlAH+yU/bYPxKNcizSQ=; b=H/Y1jYf6G5nA8OEJo3cje4A4pV
        LyYjEka5hvSkxEPg6jKhR38Ho1c/1Ml3wNIvZDZhcK2tevn7aF57FTACEZxj2QflKzrCGpHxZYckK
        XxN4t2SKpEjPQvUcWH8x+C1Y6zDCLqg9DGyuqxFQc/47CS0Kr4IBR54tlWv5K6aSKS62qzlz0+6+u
        LRZgQWCiB4TNzy7S3Zv/mLvCDTGzICNYXifAN0yGNubAkWYHBW2Hd6xb6/VxsKWNxNkndJa+8CCJx
        Kiqs8Tx7/9kaWlzYRVDhQM2PbXgD6DS08YLnBNE8XmXRM2/Ygp8lJHD/FU+wXg1WhSmDvXkSSlEeJ
        uIaaXnvQ==;
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www259.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <mt@waldheinz.de>)
        id 1lzL18-0000YY-3j; Fri, 02 Jul 2021 17:23:46 +0200
Received: from [192.168.0.32] (helo=mail.your-server.de)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-CHACHA20-POLY1305:256)
        (Exim 4.92)
        (envelope-from <mt@waldheinz.de>)
        id 1lzL17-000JWo-S4; Fri, 02 Jul 2021 17:23:45 +0200
Received: from ip4d1584d2.dynamic.kabel-deutschland.de
 (ip4d1584d2.dynamic.kabel-deutschland.de [77.21.132.210]) by
 mail.your-server.de (Horde Framework) with HTTPS; Fri, 02 Jul 2021 17:23:45
 +0200
Date:   Fri, 02 Jul 2021 17:23:45 +0200
Message-ID: <20210702172345.Horde.VhYvsDcOcRfOxOFrUo9F1Ge@mail.your-server.de>
From:   Matthias Treydte <mt@waldheinz.de>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@gmail.com>, stable@vger.kernel.org,
        netdev@vger.kernel.org, regressions@lists.linux.dev,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org
Subject: Re: [regression] UDP recv data corruption
References: <20210701124732.Horde.HT4urccbfqv0Nr1Aayuy0BM@mail.your-server.de>
 <38ddc0e8-ba27-279b-8b76-4062db6719c6@gmail.com>
 <CA+FuTSc3POcZo0En3JBqRwq2+eF645_Cs4U-4nBmTs9FvjoVkg@mail.gmail.com>
 <20210702143642.Horde.PFbG3LFNTZ3wp0TYiBRGsCM@mail.your-server.de>
 <6c6eee2832c658d689895aa9585fd30f54ab3ed9.camel@redhat.com>
 <d8061b19ec2a8123d7cf69dad03f1250a5b03220.camel@redhat.com>
In-Reply-To: <d8061b19ec2a8123d7cf69dad03f1250a5b03220.camel@redhat.com>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
X-Authenticated-Sender: mt@waldheinz.de
X-Virus-Scanned: Clear (ClamAV 0.103.2/26219/Fri Jul  2 13:06:52 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Quoting Paolo Abeni <pabeni@redhat.com>:

> ---
> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> index 54e06b88af69..458c888337a5 100644
> --- a/net/ipv4/udp_offload.c
> +++ b/net/ipv4/udp_offload.c
> @@ -526,6 +526,8 @@ struct sk_buff *udp_gro_receive(struct list_head  
> *head, struct sk_buff *skb,
>                 if ((!sk && (skb->dev->features & NETIF_F_GRO_UDP_FWD)) ||
>                     (sk && udp_sk(sk)->gro_enabled) ||  
> NAPI_GRO_CB(skb)->is_flist)
>                         pp =  
> call_gro_receive(udp_gro_receive_segment, head, skb);
> +               else
> +                       goto out;
>                 return pp;
>         }

Impressive! This patch, applied to 5.13, fixes the problem. What I  
like even more is that it again confirms my suspicion that an "if"  
without an "else" is always a code smell. :-)

With this and the reproducer in my previous mail, is there still value  
in doing the "perf" stuff?


Thanks,
-Matthias

