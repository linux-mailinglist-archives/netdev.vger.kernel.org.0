Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5162FE935F
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 00:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbfJ2XO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 19:14:57 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42501 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbfJ2XO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 19:14:57 -0400
Received: by mail-pf1-f194.google.com with SMTP id 21so162756pfj.9;
        Tue, 29 Oct 2019 16:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cNf83NnNiEQaptaaQtZTsCSxkoGYXCfoPhU1qsXNh1E=;
        b=WU91IHHa23NiyWbVDPmz5S50/QKJVxyI2kbJCk+U7KNuQ9voAnKim4zFE1IxLq8l5a
         ltppbnOv6e4KZ3sAQ8sOcyJb1QSsE8L2alNptysAoYaURDgGJkc9Qdp2BsLrz4DwgoU0
         L9exA0AbsD5vX5Dl8feIZDNAjJoAn2ppma0jW7NrJHz7HIuM+TOTcLJuCsWncy9ME0a/
         iJ/jDdbWkAcU+6nCNx0kRkrBi/0GKE0Tioop0lMlS9fSvFvzilQPmyhz1WcmFM+hrXx1
         fsEVGbzxyqcYqqIuMwOqn/fdn2tmgKREYpmKKrHHhQpENvRdiSBKMMW+mK11OYWPxlDF
         Ftyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cNf83NnNiEQaptaaQtZTsCSxkoGYXCfoPhU1qsXNh1E=;
        b=prH9ALJ7n53H9pZn5JQmzhHqLDX9eK1SKQd4fqKrPwn6aYjkOHhyP4vB/MOuU25KfO
         +fNCs+7FeOTNrrXLZ6NwlWrpVs/dkN9I9/PHA4XW5UZ0h+w32RLzJAMf5rjrdU2gtX9c
         jDrZoCBYg0M3f/7oA7LLqXTqL/bbH53EWIGWdBvXanqObXXUAK5r82qfFCGXYmzEptZt
         hnzuZCTMiM9ACHcj0g4q7eRdjXvcAxw3l5P6fa38MunWEGsgPSRuiyw6bZsK+Zhw8Bw8
         wUeYExuzHGLdw5wwGJrSMCgN34cpFChr/5M2VVSvTOpfWZ9AmIWyGEakZlterH7auHhI
         iR5A==
X-Gm-Message-State: APjAAAWYoBs5HKv/U/IWOLSyyfALPNMcaF8f9YZyuY319sKdgMhIjwJ1
        uEsFwaDJwUASKzYtD3rg3vtCbR69
X-Google-Smtp-Source: APXvYqzNJIGA0r4K54EVKGwk62Ohw2MQKmWPvml8Y+FI0Ihkp5/YQgDUx7InyZVW9DVPaMUZMq4yNA==
X-Received: by 2002:a63:5417:: with SMTP id i23mr30987471pgb.305.1572390896122;
        Tue, 29 Oct 2019 16:14:56 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id z11sm192717pfg.117.2019.10.29.16.14.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Oct 2019 16:14:55 -0700 (PDT)
Subject: Re: [PATCH net-next v2 4/4] bonding: balance ICMP echoes in layer3+4
 mode
To:     Matteo Croce <mcroce@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <20191029135053.10055-1-mcroce@redhat.com>
 <20191029135053.10055-5-mcroce@redhat.com>
 <5be14e4e-807f-486d-d11a-3113901e72fe@cumulusnetworks.com>
 <576a4a96-861b-6a86-b059-6621a22d191c@gmail.com>
 <CAGnkfhzEgaH1-YNWw1_HzB5FOhZHjKewLD9NP+rnTP21Htxnjw@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <43abab53-1425-0bff-9f79-50bd47567605@gmail.com>
Date:   Tue, 29 Oct 2019 16:14:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAGnkfhzEgaH1-YNWw1_HzB5FOhZHjKewLD9NP+rnTP21Htxnjw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/29/19 4:03 PM, Matteo Croce wrote:

> Hi Eric,
> 
> this would work for locally generated echoes, but what about forwarded packets?
> The point behind my changeset is to provide consistent results within
> a session by using the same path for request and response,
> but avoid all sessions flowing to the same path.
> This should resemble what happens with TCP and UDP: different
> connections, different port, probably a different path. And by doing
> this in the flow dissector, other applications could benefit it.

In principle it is fine, but I was not sure of overall impact of your change
on performance for 99.9% of packets that are not ICMP :)

