Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA3C0116455
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 01:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfLIAZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Dec 2019 19:25:32 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41942 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbfLIAZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Dec 2019 19:25:32 -0500
Received: by mail-pg1-f196.google.com with SMTP id x8so6210943pgk.8;
        Sun, 08 Dec 2019 16:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=54pMROPZSZfXX7jRTCLEYndLEfmz7nGR8IgouL3KZTc=;
        b=BSJaBm2ePbXg4/8QJEoez2M+93ZFU9CFwMm/wY/y3fH5J2FICxXg8f4R5L+w9xefYo
         PTGQ5sPuVVu1AV7xJKYeCg6mPH6PVz6KvEF8AbZ9eS+0NQxwvSeZoSJ0gsdnjh5e3mZd
         4OV2ibZ7dlTjDdmWZs9VKt9th1QoncUz5eCiV15AFzTuuUzDIycxQz83ZjnnSyOHTLvG
         gNhSKdu3VCuezUFhphqXSBBClXUtu5jz8Eox0dKJp7rCb00Jjm9tpLfrC1ESWJfUKiB3
         fcljUfI7jtssvTxptrRqIjOtU4i3FJLBvy518UbNZPY3iY5ZWRC+AEUvH9qqTosHGlXb
         ywvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=54pMROPZSZfXX7jRTCLEYndLEfmz7nGR8IgouL3KZTc=;
        b=M4qZJMGBLAnZK3DV3sxFcCNkkGHLtwOUI2pW5dT88oJ/mcxRL3STrtzhlLNcbFxUMl
         CSYCkbDmlPeOKl/IO/y9Auj0C4RRMNWu2I1tsvtCCwqWn+mL6Ko/vBExFF4CI+94RpL6
         ueEPeTFt6nkO+3286CfZFIJ/+5V1Pv9RR2mBqduo14u9a7mfJLdA87fmYjK0+uzNT8sO
         ajpC5PVGnlnYIfWsf1tsOzJ/fg1aTIj4GqJKQXAxLzsAa5g54zHJ2hy7ri6P2RqP60TZ
         w3Ac9iHulHyHd+ytTEC2GHt6RvH2JExSQH1vQHkrWXNkAirnxieIrelut9PJMNPn1UNu
         P9jQ==
X-Gm-Message-State: APjAAAX5l3MCJV7agHSWhnMyp/xJluuxgCHqzQc3ANa3LRRSeQm0Dmz0
        ssa+pcmvF/lYX0uvXVjRyJ1JhzHG
X-Google-Smtp-Source: APXvYqyLOx/NbgYchmoB1mb0Ueb/tUuLtaKFry8cwej7RBw1g78+6E329FnE4TSyZJDGD6IMKOF7vQ==
X-Received: by 2002:a62:6381:: with SMTP id x123mr26519913pfb.75.1575851131060;
        Sun, 08 Dec 2019 16:25:31 -0800 (PST)
Received: from [172.20.20.156] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id o3sm9802750pju.13.2019.12.08.16.25.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Dec 2019 16:25:30 -0800 (PST)
Subject: Re: [RFC net-next 07/18] tun: set offloaded xdp program
To:     Jason Wang <jasowang@redhat.com>, David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
 <20191126100744.5083-8-prashantbhole.linux@gmail.com>
 <3ff23a11-c979-32ed-b55d-9213c2c64bc4@gmail.com>
 <8d575940-ba31-8780-ae4d-6edbe1b2b15a@redhat.com>
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
Message-ID: <ba0c0d5f-fbb4-ff92-c7d8-403dbb757758@gmail.com>
Date:   Mon, 9 Dec 2019 09:24:34 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <8d575940-ba31-8780-ae4d-6edbe1b2b15a@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/2/19 11:47 AM, Jason Wang wrote:
> 
> On 2019/12/2 上午12:45, David Ahern wrote:
>> On 11/26/19 4:07 AM, Prashant Bhole wrote:
>>> From: Jason Wang <jasowang@redhat.com>
>>>
>>> This patch introduces an ioctl way to set an offloaded XDP program
>>> to tun driver. This ioctl will be used by qemu to offload XDP program
>>> from virtio_net in the guest.
>>>
>> Seems like you need to set / reset the SOCK_XDP flag on tfile->sk since
>> this is an XDP program.
>>
>> Also, why not add this program using netlink instead of ioctl? e.g., as
>> part of a generic XDP in the egress path like I am looking into for the
>> host side.
> 
> 
> Maybe both, otherwise, qemu may need netlink as a dependency.
> 
> Thanks
> 

Thank you all for reviewing. We will continue to improve this set.

If we split this work, Tx path XDP is one of the necessary part
which can be developed first. As suggested by David Ahern it will be
a netlink way but we will still need ioctl way for tap. I will try
to come up with Tx path XDP set next time.

Thanks.
