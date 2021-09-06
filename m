Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E41401A9B
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 13:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241229AbhIFLc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 07:32:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43748 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240407AbhIFLcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 07:32:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630927879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ifh2AKn2IYRrBAFZpGRrv4Jn5qIpOvQyMh+sOZEw61k=;
        b=I0aDSYu6O8oj1Gm3ew8jOBv5gW7vTSPAv7VjdzjnIiheg1G0+WzJjC1C/tI39sRyJgfXCq
        cyMJXQv01f6bVpofLj+LUD9lP0tqVbZxAqTy9lmJP4ccdIHHXbk2z2DTKTepUMHo2to3aw
        +7Amyy4G/g+1b5O8WVY9hyWpxDXg/K0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-AnpIvmnqORCQGcMEXZHIyg-1; Mon, 06 Sep 2021 07:31:18 -0400
X-MC-Unique: AnpIvmnqORCQGcMEXZHIyg-1
Received: by mail-wm1-f72.google.com with SMTP id j33-20020a05600c48a100b002e879427915so2227163wmp.5
        for <netdev@vger.kernel.org>; Mon, 06 Sep 2021 04:31:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:cc:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ifh2AKn2IYRrBAFZpGRrv4Jn5qIpOvQyMh+sOZEw61k=;
        b=FOpjQ+AORKdYrz2JfsdtqRYmEB0g0mfQ+z7YKF8rjJ9FvHTyXiBe5NA6iPAMNawpGY
         RTXd9e5j8lCNQRXui13Q6UItCkqZmZ2JFjC5PLX7H0marsjUK1g74HCLQpxqs9B8ueLo
         G4Zt6TBzamQsiwllzz33/P+SXp5vD9mm7bsGznH36VHlQTEb8sYsCvxZVYNk3n76vxnt
         xkD+AkgBflCHiy7uSI2VevYEOCl3gx4A6GlU+IJRhDir7vX8vm80KK+DiskGZ73nFNtO
         LUScprz3pcOzbU2/BfRldGX9tWwJ/4jfBfd1l3nv6pUC/0VvyEc9g3GLDWH777YSyVv7
         h1ag==
X-Gm-Message-State: AOAM5323h9IslcZHoaVScDBEhX1x28uCNRv9ic1vAilEAkdAuw6szvu8
        TX88mlt1PO0zLIkSicwE83jEbcIzJkECQmjwkNK1KDFk/Vpj8LIBLRnsCsOfhC2TOxk0pzYYf3N
        lWNLXh0QSS3zUy+jZ
X-Received: by 2002:adf:eb4a:: with SMTP id u10mr12773349wrn.11.1630927877227;
        Mon, 06 Sep 2021 04:31:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwRDD+CFWqGasfoJ4bWw1zXPZwgO49ADZdpw61tpeyBjS5qkitLHCkPuytVwq/iV6MGXa+HdQ==
X-Received: by 2002:adf:eb4a:: with SMTP id u10mr12773300wrn.11.1630927876958;
        Mon, 06 Sep 2021 04:31:16 -0700 (PDT)
Received: from [192.168.42.238] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id u26sm7984094wrd.32.2021.09.06.04.31.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 04:31:16 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     brouer@redhat.com, duanxiongchun@bytedance.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhengqi.arch@bytedance.com, chenying.kernel@bytedance.com,
        intel-wired-lan@lists.osuosl.org, songmuchun@bytedance.com,
        bpf@vger.kernel.org, wangdongdong.6@bytedance.com,
        zhouchengming@bytedance.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, jeffrey.t.kirsher@intel.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: [External] Re: [Intel-wired-lan] [PATCH v2] ixgbe: Fix NULL
 pointer dereference in ixgbe_xdp_setup
To:     Feng Zhou <zhoufeng.zf@bytedance.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Jason Xing <xingwanli@kuaishou.com>
References: <20210903064013.9842-1-zhoufeng.zf@bytedance.com>
 <2ee172ab-836c-d464-be59-935030d01f4b@molgen.mpg.de>
 <8ce8de1c-14bf-20ad-00c0-9e0d8ff34b91@bytedance.com>
Message-ID: <318e7f75-287e-148a-cdb0-648b7c36e0a9@redhat.com>
Date:   Mon, 6 Sep 2021 13:31:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <8ce8de1c-14bf-20ad-00c0-9e0d8ff34b91@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Feng and Jason,

Please notice that you are both developing patches that change the ixgbe 
driver in related areas.

Jason's patch:
  Subject: [PATCH v7] ixgbe: let the xdpdrv work with more than 64 cpus
 
https://lore.kernel.org/all/20210901101206.50274-1-kerneljasonxing@gmail.com/

We might need both as this patch looks like a fix to a panic, and 
Jason's patch allows XDP on ixgbe to work on machines with more than 64 
CPUs.

-Jesper

On 06/09/2021 09.49, Feng Zhou wrote:
> 
> 在 2021/9/6 下午2:37, Paul Menzel 写道:
>> Dear Feng,
>>
>>
>> Am 03.09.21 um 08:40 schrieb Feng zhou:
>>
>> (If you care, in your email client, your last name does not start with 
>> a capital letter.)
>>
>>> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>>>
>>> The ixgbe driver currently generates a NULL pointer dereference with
>>> some machine (online cpus < 63). This is due to the fact that the
>>> maximum value of num_xdp_queues is nr_cpu_ids. Code is in
>>> "ixgbe_set_rss_queues"".
>>>
>>> Here's how the problem repeats itself:
>>> Some machine (online cpus < 63), And user set num_queues to 63 through
>>> ethtool. Code is in the "ixgbe_set_channels",
>>> adapter->ring_feature[RING_F_FDIR].limit = count;
>>
>> For better legibility, you might want to indent code (blocks) by four 
>> spaces and add blank lines around it (also below).
>>
>>> It becames 63.
>>
>> becomes
>>
>>> When user use xdp, "ixgbe_set_rss_queues" will set queues num.
>>> adapter->num_rx_queues = rss_i;
>>> adapter->num_tx_queues = rss_i;
>>> adapter->num_xdp_queues = ixgbe_xdp_queues(adapter);
>>> And rss_i's value is from
>>> f = &adapter->ring_feature[RING_F_FDIR];
>>> rss_i = f->indices = f->limit;
>>> So "num_rx_queues" > "num_xdp_queues", when run to "ixgbe_xdp_setup",
>>> for (i = 0; i < adapter->num_rx_queues; i++)
>>>     if (adapter->xdp_ring[i]->xsk_umem)
>>> lead to panic.
>>
>> lead*s*?
>>
>>> Call trace:
>>> [exception RIP: ixgbe_xdp+368]
>>> RIP: ffffffffc02a76a0  RSP: ffff9fe16202f8d0  RFLAGS: 00010297
>>> RAX: 0000000000000000  RBX: 0000000000000020  RCX: 0000000000000000
>>> RDX: 0000000000000000  RSI: 000000000000001c  RDI: ffffffffa94ead90
>>> RBP: ffff92f8f24c0c18   R8: 0000000000000000   R9: 0000000000000000
>>> R10: ffff9fe16202f830  R11: 0000000000000000  R12: ffff92f8f24c0000
>>> R13: ffff9fe16202fc01  R14: 000000000000000a  R15: ffffffffc02a7530
>>> ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>>>   7 [ffff9fe16202f8f0] dev_xdp_install at ffffffffa89fbbcc
>>>   8 [ffff9fe16202f920] dev_change_xdp_fd at ffffffffa8a08808
>>>   9 [ffff9fe16202f960] do_setlink at ffffffffa8a20235
>>> 10 [ffff9fe16202fa88] rtnl_setlink at ffffffffa8a20384
>>> 11 [ffff9fe16202fc78] rtnetlink_rcv_msg at ffffffffa8a1a8dd
>>> 12 [ffff9fe16202fcf0] netlink_rcv_skb at ffffffffa8a717eb
>>> 13 [ffff9fe16202fd40] netlink_unicast at ffffffffa8a70f88
>>> 14 [ffff9fe16202fd80] netlink_sendmsg at ffffffffa8a71319
>>> 15 [ffff9fe16202fdf0] sock_sendmsg at ffffffffa89df290
>>> 16 [ffff9fe16202fe08] __sys_sendto at ffffffffa89e19c8
>>> 17 [ffff9fe16202ff30] __x64_sys_sendto at ffffffffa89e1a64
>>> 18 [ffff9fe16202ff38] do_syscall_64 at ffffffffa84042b9
>>> 19 [ffff9fe16202ff50] entry_SYSCALL_64_after_hwframe at ffffffffa8c0008c
>>
>> Please describe the fix in the commit message.
>>
>>> Fixes: 4a9b32f30f80 ("ixgbe: fix potential RX buffer starvation for
>>> AF_XDP")
>>> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
>>> ---
>>> Updates since v1:
>>> - Fix "ixgbe_max_channels" callback so that it will not allow a 
>>> setting of
>>> queues to be higher than the num_online_cpus().
>>> more details can be seen from here:
>>> https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20210817075407.11961-1-zhoufeng.zf@bytedance.com/ 
>>>
>>> Thanks to Maciej Fijalkowski for your advice.
>>>
>>>   drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c | 2 +-
>>>   drivers/net/ethernet/intel/ixgbe/ixgbe_main.c    | 8 ++++++--
>>>   2 files changed, 7 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c 
>>> b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
>>> index 4ceaca0f6ce3..21321d164708 100644
>>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
>>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
>>> @@ -3204,7 +3204,7 @@ static unsigned int ixgbe_max_channels(struct 
>>> ixgbe_adapter *adapter)
>>>           max_combined = ixgbe_max_rss_indices(adapter);
>>>       }
>>>   -    return max_combined;
>>> +    return min_t(int, max_combined, num_online_cpus());
>>>   }
>>>     static void ixgbe_get_channels(struct net_device *dev,
>>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c 
>>> b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
>>> index 14aea40da50f..5db496cc5070 100644
>>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
>>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
>>> @@ -10112,6 +10112,7 @@ static int ixgbe_xdp_setup(struct net_device 
>>> *dev, struct bpf_prog *prog)
>>>       struct ixgbe_adapter *adapter = netdev_priv(dev);
>>>       struct bpf_prog *old_prog;
>>>       bool need_reset;
>>> +    int num_queues;
>>>         if (adapter->flags & IXGBE_FLAG_SRIOV_ENABLED)
>>>           return -EINVAL;
>>> @@ -10161,11 +10162,14 @@ static int ixgbe_xdp_setup(struct 
>>> net_device *dev, struct bpf_prog *prog)
>>>       /* Kick start the NAPI context if there is an AF_XDP socket open
>>>        * on that queue id. This so that receiving will start.
>>>        */
>>> -    if (need_reset && prog)
>>> -        for (i = 0; i < adapter->num_rx_queues; i++)
>>> +    if (need_reset && prog) {
>>> +        num_queues = min_t(int, adapter->num_rx_queues,
>>> +            adapter->num_xdp_queues);
>>> +        for (i = 0; i < num_queues; i++)
>>>               if (adapter->xdp_ring[i]->xsk_pool)
>>>                   (void)ixgbe_xsk_wakeup(adapter->netdev, i,
>>>                                  XDP_WAKEUP_RX);
>>> +    }
>>>         return 0;
>>>   }
>>>
> Thanks for your advice. I will modify the commit message in v3
> 

