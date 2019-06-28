Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64365593FC
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 08:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfF1GDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 02:03:39 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53484 "EHLO
        mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbfF1GDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 02:03:39 -0400
Received: from ALA-HCA.corp.ad.wrs.com ([147.11.189.40])
        by mail1.windriver.com (8.15.2/8.15.1) with ESMTPS id x5S63GbX015888
        (version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL);
        Thu, 27 Jun 2019 23:03:16 -0700 (PDT)
Received: from [128.224.162.221] (128.224.162.221) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.50) with Microsoft SMTP Server (TLS) id 14.3.439.0; Thu, 27 Jun
 2019 23:03:16 -0700
Subject: Re: [PATCH] netfilter: Fix remainder of pseudo-header protocol 0
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <kadlec@blackhole.kfki.hu>, <fw@strlen.de>, <davem@davemloft.net>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1561346258-272481-1-git-send-email-zhe.he@windriver.com>
 <20190627184903.atdcwk4wnfaayyer@salvia>
From:   He Zhe <zhe.he@windriver.com>
Message-ID: <aafd41fb-b58e-a402-c8fe-5eeffc7a7755@windriver.com>
Date:   Fri, 28 Jun 2019 14:03:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190627184903.atdcwk4wnfaayyer@salvia>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [128.224.162.221]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/28/19 2:49 AM, Pablo Neira Ayuso wrote:
> On Mon, Jun 24, 2019 at 11:17:38AM +0800, zhe.he@windriver.com wrote:
>> From: He Zhe <zhe.he@windriver.com>
>>
>> Since v5.1-rc1, some types of packets do not get unreachable reply with the
>> following iptables setting. Fox example,
>>
>> $ iptables -A INPUT -p icmp --icmp-type 8 -j REJECT
>> $ ping 127.0.0.1 -c 1
>> PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.
>> — 127.0.0.1 ping statistics —
>> 1 packets transmitted, 0 received, 100% packet loss, time 0ms
>>
>> We should have got the following reply from command line, but we did not.
>> From 127.0.0.1 icmp_seq=1 Destination Port Unreachable
>>
>> Yi Zhao reported it and narrowed it down to:
>> 7fc38225363d ("netfilter: reject: skip csum verification for protocols that don't support it"),
>>
>> This is because nf_ip_checksum still expects pseudo-header protocol type 0 for
>> packets that are of neither TCP or UDP, and thus ICMP packets are mistakenly
>> treated as TCP/UDP.
>>
>> This patch corrects the conditions in nf_ip_checksum and all other places that
>> still call it with protocol 0.
> Looking at 7fc38225363dd8f19e667ad7c77b63bc4a5c065d, I wonder this can
> be fixed while simplifying it...
>
> I think nf_reject_verify_csum() is useless?
>
> In your patch, now you explicitly check for IPPROTO_TCP and
> IPPROTO_UDP to validate the checksum.

Thanks for your review.

I suppose the two main points of 7fc38225363d are valid and I was trying to
align with them and fix them:
1) Skip csum verification for protocols that don't support it.
2) Remove the protocol 0 used to indicate non-TCP/UDP packets, and use actual
   types instead to be clear.

1) uses nf_reject_verify_csum to skip those that should be skipped and leaves
the protocols that support csum to the rest of the logic including
nf_ip_checksum. But 2) removes the "0" transition from the rest of the
logic and thus causes this issue. So I add the explicit check against TCP/UDP to
nf_ip_checksum. And nf_reject_verify_csum is still useful.

Zhe

>

