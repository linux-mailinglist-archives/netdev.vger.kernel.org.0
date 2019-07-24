Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3415472C7B
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 12:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfGXKop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 06:44:45 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40299 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbfGXKoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 06:44:44 -0400
Received: by mail-wr1-f68.google.com with SMTP id r1so46413480wrl.7;
        Wed, 24 Jul 2019 03:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=VSyy1S/fbTjJgED/rizgeHH0wlDygBVpXbt87CoVbz8=;
        b=FwoT2uMjqovfPMxfybogj6bljs2dJd6Sxf97lq1CI3Mh5MZ00uC8omSpb4BdqKQuc0
         878597O4AbPRNnDMU/X9FzYlnISdPcEhwN5/+WwlLhC2I4UtRU64V70dLiXfJENtEIpj
         ppRUoPi8YXE9zN8B3CoeAK/gQ15rUqkJwj0R/JXnMLJmt25zNcRwmmCJuFFU4J0ctSqo
         SX0ekSwZhmXPCAWSdZ5DmWmQ/lAaTgzLJfSwJS4IBmIybs5jnehcF/2Oh5mI2xoKH/fh
         UO222WQ8zwXmaKM/gRqecmB9jj/cfas9iI8o1oaIt/GMTWioO8AD6OHjL352LNIe3qSV
         dvLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VSyy1S/fbTjJgED/rizgeHH0wlDygBVpXbt87CoVbz8=;
        b=sPWsbfE/ag/6kaQgB9yMDopDAtAbD21IlNcV0+2RbNK1aDLeTqS4BPWZLQ8PnpOJUP
         OnREu0K8ORuL5+SKCLt/GSbYZ4HP6SCNf5wJ+81ZjWWJRNM725Tc1VRVJYyT/HPIA++k
         XPd/FW9096GW4ns1Pp+PHSyhQIvsmhJMMwsjnbar5H74amkOI9PHx3l5sV0KUoknJ95O
         q1TpGBoU2XnTUdGeEzKqbFL2SzgUkrEL7MCNMZ0su4twRhHbW8Zlqofsex3rrhCer9YY
         QdYdh34j0iTGmHu8BqZzbmQS6bz3TClTT6My22m81rbIR2WHhFFJZOYmr/uO8XNEvA9k
         4D1A==
X-Gm-Message-State: APjAAAX3s748WS3pMuZNgGtgJIz6M7AiaflOqNrK+zhq1U29+vfFc3l1
        cjNJ0JBAp2YuWS5H3+GepX2rYyb5
X-Google-Smtp-Source: APXvYqxXXNMN+FRll/IVvThY400TUGFN0IKK5+L+rww2fQyr5h8Zu0qzrUwKJjy+kWc6heDBbZHI4Q==
X-Received: by 2002:adf:f206:: with SMTP id p6mr14542181wro.216.1563965082957;
        Wed, 24 Jul 2019 03:44:42 -0700 (PDT)
Received: from [192.168.8.147] (200.150.22.93.rev.sfr.net. [93.22.150.200])
        by smtp.gmail.com with ESMTPSA id k17sm51932217wrq.83.2019.07.24.03.44.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 03:44:42 -0700 (PDT)
Subject: Re: [PATCH 4.4 stable net] net: tcp: Fix use-after-free in
 tcp_write_xmit
To:     maowenan <maowenan@huawei.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190724091715.137033-1-maowenan@huawei.com>
 <badce2b6-b75e-db01-39c8-d68a0161c101@gmail.com>
 <8e02f190-ec3a-6308-8c59-e5ae9ca39f5d@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2e56c0bf-556c-c16f-c767-ea1d49acb19c@gmail.com>
Date:   Wed, 24 Jul 2019 12:44:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <8e02f190-ec3a-6308-8c59-e5ae9ca39f5d@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/24/19 12:36 PM, maowenan wrote:
> Actually, I have tested 4.4.184, UAF still happen.
> 
>

Thanks for testing.

Acked-by: Eric Dumazet <edumazet@google.com>


