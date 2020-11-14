Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6A82B2A17
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 01:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgKNAqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 19:46:39 -0500
Received: from www62.your-server.de ([213.133.104.62]:59310 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgKNAqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 19:46:39 -0500
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kdjhd-0007BR-MD; Sat, 14 Nov 2020 01:46:05 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kdjhd-000Q0i-FN; Sat, 14 Nov 2020 01:46:05 +0100
Subject: Re: [PATCH] ip_tunnels: Set tunnel option flag when tunnel metadata
 is present
To:     Jakub Kicinski <kuba@kernel.org>,
        Yi-Hung Wei <yihung.wei@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        pieter.jansenvanvuuren@netronome.com, netdev@vger.kernel.org,
        alexei.starovoitov@gmail.com
References: <1605053800-74072-1-git-send-email-yihung.wei@gmail.com>
 <20201113161359.77559aa2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <63d717ab-be9b-8b75-e4a0-7cac98facd14@iogearbox.net>
Date:   Sat, 14 Nov 2020 01:46:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201113161359.77559aa2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25987/Fri Nov 13 14:19:33 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/14/20 1:13 AM, Jakub Kicinski wrote:
> On Tue, 10 Nov 2020 16:16:40 -0800 Yi-Hung Wei wrote:
>> Currently, we may set the tunnel option flag when the size of metadata
>> is zero.  For example, we set TUNNEL_GENEVE_OPT in the receive function
>> no matter the geneve option is present or not.  As this may result in
>> issues on the tunnel flags consumers, this patch fixes the issue.
>>
>> Related discussion:
>> * https://lore.kernel.org/netdev/1604448694-19351-1-git-send-email-yihung.wei@gmail.com/T/#u
>>
>> Fixes: 256c87c17c53 ("net: check tunnel option type in tunnel flags")
>> Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>
> 
> Seems fine to me, however BPF (and maybe Netfilter?) can set options
> passed by user without checking if they are 0 length.
> 
> Daniel, Pablo, are you okay with this change or should we limit it to
> just fixing the GENEVE oddness?

Verifier will guarantee that buffer passed into helper is > 0, so seems
okay from BPF side.

Thanks,
Daniel
