Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10BB72C344A
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 00:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730157AbgKXXAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 18:00:35 -0500
Received: from www62.your-server.de ([213.133.104.62]:45190 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728404AbgKXXAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 18:00:35 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1khhIY-0004GY-0T; Wed, 25 Nov 2020 00:00:34 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1khhIX-000V7T-Pm; Wed, 25 Nov 2020 00:00:33 +0100
Subject: Re: [PATCH net-next 0/3] mvneta: access skb_shared_info only on last
 frag
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net,
        brouer@redhat.com, echaudro@redhat.com, john.fastabend@gmail.com,
        alexei.starovoitov@gmail.com
References: <cover.1605889258.git.lorenzo@kernel.org>
 <20201124122639.6fa91460@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201124221854.GA64351@lore-desk>
 <09034687-75d5-7102-8f9a-7dde69d04a63@iogearbox.net>
 <20201124143056.606fd5d0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ef387ff6-48e0-ba17-1143-6e9a88ea2367@iogearbox.net>
Date:   Wed, 25 Nov 2020 00:00:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201124143056.606fd5d0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25998/Tue Nov 24 14:16:50 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/24/20 11:30 PM, Jakub Kicinski wrote:
> On Tue, 24 Nov 2020 23:25:11 +0100 Daniel Borkmann wrote:
>> On 11/24/20 11:18 PM, Lorenzo Bianconi wrote:
>>>> On Fri, 20 Nov 2020 18:05:41 +0100 Lorenzo Bianconi wrote:
>>>>> Build skb_shared_info on mvneta_rx_swbm stack and sync it to xdp_buff
>>>>> skb_shared_info area only on the last fragment.
>>>>> Avoid avoid unnecessary xdp_buff initialization in mvneta_rx_swbm routine.
>>>>> This a preliminary series to complete xdp multi-buff in mvneta driver.
>>>>
>>>> Looks fine, but since you need this for XDP multi-buff it should
>>>> probably go via bpf-next, right?
>>>>
>>>> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
>>>
>>> Hi Jakub,
>>>
>>> thx for the review. Since the series changes networking-only bits I sent it for
>>> net-next, but I agree bpf-next is better.
>>>
>>> @Alexei, Daniel: is it fine to merge the series in bpf-next?
>>
>> Yeah totally fine, will take it into bpf-next in a bit.
> 
> FWIW watch out with the Link:s, it wasn't CCed to bpf@vger.

@Jakub, I think it's less hassle if you take the series in. Looking closer, net-next has
commit 9c79a8ab5f12 ("net: mvneta: fix possible memory leak in mvneta_swbm_add_rx_fragment")
which bpf-next is currently lacking, and this series here is touching the part of this
code, so it will create unnecessary merge conflicts. I'll likely flush out bpf-next PR
on Thurs/Fri at latest, so bpf-next will then have everything needed once we sync back
from net-next after merge.

Thanks,
Daniel
