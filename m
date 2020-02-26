Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 943D317038C
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 16:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728874AbgBZP6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 10:58:52 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:38518 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728980AbgBZP6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 10:58:51 -0500
Received: by mail-qv1-f68.google.com with SMTP id g16so1306425qvz.5
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 07:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XTTJKk0pnHpZhwJgWnFrI+Uc2Ve8ii0+ddJv1cHHYiM=;
        b=SutoKEANL0zZ+/zB7MNgj30v5/B1S767w3rgoJuS0eqIvSecyB/iZE3EoiN9JUdeno
         2DSOVoMC7rCmomsu9xrsA6huzxuionNt2k/NzUuiqmif+QcYq9pZNmgAEclWG28pGRtu
         09br7AWvv0x3RWkqBK3I9S+cStxDrH4Dq7stA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XTTJKk0pnHpZhwJgWnFrI+Uc2Ve8ii0+ddJv1cHHYiM=;
        b=CkT4Pb3ndJ8H83qhg3H2UHs0T75HZwmzUYasPCKoRu6bhs8ML7rpYOv6aL5yK4wT3P
         +CtMLPwdS6dk6g91Kv7R1HyHcsUzUs978V8ipujt7B5I5g75sFhOnHF9Btky9U8Kqmyq
         0roKC1du8HuVrKysidwGx6ETilUSItd9sVZ9Ho6EpQKxgS98kUlXt9OnZ0I8HhxvP9fe
         XBHu5T+MdW9nhZsHGAhBNWTklcqaFrgUzzX9B77HUc8t0c2CoWTx0/2ZRNtcsaqi3P61
         uhW8GoAbUFwwlf2PFqXzM7bT8dP4c7LJ0PG45QgGbSzRZDorBsMx7uMBGOT2/F/SdkUl
         V79A==
X-Gm-Message-State: APjAAAWsGjhLduEeoM+UX5I6Mw+EqHaa6U9HEg857eaORUOrKEoSI/nm
        SRgg/3pOo4sjlxnAe3ALdI6Y+w==
X-Google-Smtp-Source: APXvYqwnPcHsphjaS8TOIDk3TWKt2KYOznsLBHITKWhtFnZLjfkI2mnrRZeN7AJDs3xphEyCE4bHuw==
X-Received: by 2002:a0c:f8c6:: with SMTP id h6mr5794398qvo.239.1582732729571;
        Wed, 26 Feb 2020 07:58:49 -0800 (PST)
Received: from [10.0.45.36] ([65.158.212.130])
        by smtp.gmail.com with ESMTPSA id f7sm1275884qtj.92.2020.02.26.07.58.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2020 07:58:48 -0800 (PST)
Subject: Re: [PATCH RFC net-next] virtio_net: Relax queue requirement for
 using XDP
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
References: <20200226005744.1623-1-dsahern@kernel.org>
 <23fe48b6-71d1-55a3-e0e8-ca4b3fac1f7f@redhat.com>
 <9a5391fb-1d80-43d1-5e88-902738cc2528@gmail.com> <87wo89zroe.fsf@toke.dk>
 <20200226032204-mutt-send-email-mst@kernel.org> <87r1yhzqz8.fsf@toke.dk>
From:   David Ahern <dahern@digitalocean.com>
Message-ID: <e6f6aaaa-664b-e80d-05fd-9821e6ae75ef@digitalocean.com>
Date:   Wed, 26 Feb 2020 08:58:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <87r1yhzqz8.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/26/20 1:34 AM, Toke Høiland-Jørgensen wrote:
>>
>> OK so basically there would be commands to configure which TX queue is
>> used by XDP. With enough resources default is to use dedicated queues.
>> With not enough resources default is to fail binding xdp program
>> unless queues are specified. Does this sound reasonable?
> 
> Yeah, that was the idea. See this talk from LPC last year for more
> details: https://linuxplumbersconf.org/event/4/contributions/462/

 Hopefully such a design is only required for a program doing a Tx path
(XDP_TX or XDP_REDIRECT). i.e., a program just doing basic ACL, NAT, or
even encap, decap, should not have to do anything with Tx queues to load
and run the program.
