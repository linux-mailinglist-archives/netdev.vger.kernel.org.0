Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7AE672A8
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 17:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfGLPpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 11:45:05 -0400
Received: from www62.your-server.de ([213.133.104.62]:52524 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbfGLPpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 11:45:05 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlxjG-0001zc-Uu; Fri, 12 Jul 2019 17:44:58 +0200
Received: from [2a02:1205:5069:fce0:c5f9:cd68:79d4:446d] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlxjG-000QQa-OT; Fri, 12 Jul 2019 17:44:58 +0200
Subject: Re: [PATCH bpf-next] net: Don't uninstall an XDP program when none is
 installed
To:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
References: <20190612161405.24064-1-maximmi@mellanox.com>
 <3124b473-1322-e98e-d5ab-60e584e74200@mellanox.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5b123e9a-095f-1db4-da6e-5af6552430e1@iogearbox.net>
Date:   Fri, 12 Jul 2019 17:44:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <3124b473-1322-e98e-d5ab-60e584e74200@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25508/Fri Jul 12 10:10:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/10/2019 01:16 PM, Maxim Mikityanskiy wrote:
> On 2019-06-12 19:14, Maxim Mikityanskiy wrote:
>> dev_change_xdp_fd doesn't perform any checks in case it uninstalls an
>> XDP program. It means that the driver's ndo_bpf can be called with
>> XDP_SETUP_PROG asking to set it to NULL even if it's already NULL. This
>> case happens if the user runs `ip link set eth0 xdp off` when there is
>> no XDP program attached.
>>
>> The drivers typically perform some heavy operations on XDP_SETUP_PROG,
>> so they all have to handle this case internally to return early if it
>> happens. This patch puts this check into the kernel code, so that all
>> drivers will benefit from it.
>>
>> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
>> ---
>> Björn, please take a look at this, Saeed told me you were doing
>> something related, but I couldn't find it. If this fix is already
>> covered by your work, please tell about that.
>>
>>   net/core/dev.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 66f7508825bd..68b3e3320ceb 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -8089,6 +8089,9 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
>>   			bpf_prog_put(prog);
>>   			return -EINVAL;
>>   		}
>> +	} else {
>> +		if (!__dev_xdp_query(dev, bpf_op, query))
>> +			return 0;
>>   	}
>>   
>>   	err = dev_xdp_install(dev, bpf_op, extack, flags, prog);
>>
> 
> Alexei, so what about this patch? It's marked as "Changed Requested" in 
> patchwork, but Jakub's point looks resolved - I don't see any changes 
> required from my side.

I believe part of Jakub's feedback was that if we make this generic that this
does not generally address the case where both prog pointers are equal (whether
NULL or non-NULL).

Thanks,
Daniel
