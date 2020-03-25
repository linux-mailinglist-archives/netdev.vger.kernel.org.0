Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE8E192DCD
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 17:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgCYQHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 12:07:31 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35116 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727439AbgCYQHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 12:07:31 -0400
Received: by mail-pl1-f194.google.com with SMTP id g6so978104plt.2
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 09:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=II3xqn0LyZ9WrlZeyyfwPmrjpu/j7KKDl5+jqkjlLKk=;
        b=AV9QoagsT6bK4vQQly5GdZpXAKMMY7OfJGWgTVqTIzrY13sY0axGtpWwfAmGz/aRVc
         W7YXRC5Xj3vsd6TJISTOo4SXWHNvRJH1VAJAEj8n6kDRrlN9UgUT4ywXHBdgpkfhOjXQ
         HQzEehx8z1LmXmxNJTThvcaoR0dfqFvZnNzq/bNhm8jCaZii5rilCgvRM1pDNaUuUj9c
         6G7Pa0v1bsTRkCgGnNppcflAkGSyD8yQl21NTaaNzsDn6B1XmFioQjo2F4bpueclkVYL
         vPqlr8awA7v3jkfttujOcS+vU+ut9qnBp5q55xmx22XtNTpAuZ8+z5H79s+TkxRHon1A
         AL5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=II3xqn0LyZ9WrlZeyyfwPmrjpu/j7KKDl5+jqkjlLKk=;
        b=e7mpVxn2axPuit6Lp4Z+jbo/iweRprY4Knakeri/Qfv+YYrY3kMCr8ck1UbfhAMk6g
         6FdYGxiV0rNoZ7pojcbA4+xWOOArvzbdfhYb0b/jhdM27Dje+Qez8g/nz5hzdCV6i8Nv
         qMMrjj20evTB6H3CHigCoElQHCR6kN74SbSnOIzA4moyBnx1PTN0jHHVRNh4ZZPYXDLq
         RIunMJLACsieaHl2F3tmjh4TVIlzKHm8boUgPgqmKJNgV/M4YiPwPv+lqJqUMiPn5L+L
         IK7wlCsUposXHr8Rz9ejvaNnd3fEE2ii/QmbS36NRakgXyoHKSdo5vFKf0PI+jZ+FfQZ
         CHcA==
X-Gm-Message-State: ANhLgQ3lPHb99F/V8OeD7kCGoPGd8mfDw7ouMcuKxtKwvvXNxvidcqvt
        501Phd6LhXHi4426INXbrP8=
X-Google-Smtp-Source: ADFU+vv/YWN6C2MqUF2kQvJq/2Lylxq/4IzHGlRBsQIV2MnliSvBZH6KoZPbSY/ZbnI0dKfnh7J7qg==
X-Received: by 2002:a17:90a:fa96:: with SMTP id cu22mr4309200pjb.187.1585152449898;
        Wed, 25 Mar 2020 09:07:29 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id g11sm18487233pfm.4.2020.03.25.09.07.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 09:07:28 -0700 (PDT)
Subject: Re: [PATCH net-next] net: use indirect call wrappers for
 skb_copy_datagram_iter()
To:     Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <20200325022321.21944-1-edumazet@google.com>
 <ace8e72488fbf2473efaed9fc0680886897939ab.camel@redhat.com>
 <CA+FuTSdO_WBhrRj5PNdXppywDNkMKJ4hLry+3oSvy8mavnxw0g@mail.gmail.com>
 <2b5f096a143f4dea9c9a2896913d8ca79688b00f.camel@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0f5c5e35-fc51-19c3-2ce3-c8ac17887c6c@gmail.com>
Date:   Wed, 25 Mar 2020 09:07:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <2b5f096a143f4dea9c9a2896913d8ca79688b00f.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/25/20 9:00 AM, Paolo Abeni wrote:

> 
> For the record, I have 2 others item on my list, I hope to have time to
> process some day: the ingress dst->input and the default ->enqueue  and
> ->dequeue

What is the default ->enqueue() and ->dequeue() ?

For us, this is FQ.

(Even if we do not select NET_SCH_DEFAULT and leave pfifo_fast as the 'default' qdisc)

