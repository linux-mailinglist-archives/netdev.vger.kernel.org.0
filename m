Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90638257A41
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 15:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgHaNSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 09:18:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55557 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726654AbgHaNS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 09:18:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598879905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q0o6bclwuKSh0fyVGfM/hWIeUd3ILyiWt6k5DL+CCfI=;
        b=glpJv92SWWEkntg5aIUjSJMQBKuYksAjMrevrBwfRUtwOnNZ/OtGnnLarFPpW/s8g7SCSd
        AUzDocaNpzZTkwmMH28Lzc/SxJ++0L4EnKBDlVl7M0z17nT214ZDlH50FhRONDVnWa/xpm
        ZJg4GfuXfrc4AokbbUEFz0FpHJzWdHI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-SZorX-3YPXyNFmO4BLCvPQ-1; Mon, 31 Aug 2020 09:18:21 -0400
X-MC-Unique: SZorX-3YPXyNFmO4BLCvPQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFE2C1074641;
        Mon, 31 Aug 2020 13:18:19 +0000 (UTC)
Received: from [10.40.193.137] (unknown [10.40.193.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C40B85C22D;
        Mon, 31 Aug 2020 13:18:17 +0000 (UTC)
Subject: Re: [PATCHv2 net-next] dropwatch: Support monitoring of dropped
 frames
To:     izabela.bakollari@gmail.com
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
References: <20200707171515.110818-1-izabela.bakollari@gmail.com>
 <20200804160908.46193-1-izabela.bakollari@gmail.com>
From:   Michal Schmidt <mschmidt@redhat.com>
Message-ID: <e971a990-4c92-9d64-8bc6-61516d874370@redhat.com>
Date:   Mon, 31 Aug 2020 15:18:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200804160908.46193-1-izabela.bakollari@gmail.com>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dne 04. 08. 20 v 18:09 izabela.bakollari@gmail.com napsala:
> From: Izabela Bakollari <izabela.bakollari@gmail.com>
> 
> Dropwatch is a utility that monitors dropped frames by having userspace
> record them over the dropwatch protocol over a file. This augument
> allows live monitoring of dropped frames using tools like tcpdump.
> 
> With this feature, dropwatch allows two additional commands (start and
> stop interface) which allows the assignment of a net_device to the
> dropwatch protocol. When assinged, dropwatch will clone dropped frames,
> and receive them on the assigned interface, allowing tools like tcpdump
> to monitor for them.
> 
> With this feature, create a dummy ethernet interface (ip link add dev
> dummy0 type dummy), assign it to the dropwatch kernel subsystem, by using
> these new commands, and then monitor dropped frames in real time by
> running tcpdump -i dummy0.
> 
> Signed-off-by: Izabela Bakollari <izabela.bakollari@gmail.com>
> ---
> Changes in v2:
> - protect the dummy ethernet interface from being changed by another
> thread/cpu
> ---
>   include/uapi/linux/net_dropmon.h |  3 ++
>   net/core/drop_monitor.c          | 84 ++++++++++++++++++++++++++++++++
>   2 files changed, 87 insertions(+)
[...]
> @@ -255,6 +259,21 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
>   
>   out:
>   	spin_unlock_irqrestore(&data->lock, flags);
> +	spin_lock_irqsave(&interface_lock, flags);
> +	if (interface && interface != skb->dev) {
> +		skb = skb_clone(skb, GFP_ATOMIC);

I suggest naming the cloned skb "nskb". Less potential for confusion 
that way.

> +		if (skb) {
> +			skb->dev = interface;
> +			spin_unlock_irqrestore(&interface_lock, flags);
> +			netif_receive_skb(skb);
> +		} else {
> +			spin_unlock_irqrestore(&interface_lock, flags);
> +			pr_err("dropwatch: Not enough memory to clone dropped skb\n");

Maybe avoid logging the error here. In NET_DM_ALERT_MODE_PACKET mode, 
drop monitor does not log about the skb_clone() failure either.
We don't want to open the possibility to flood the logs in case this 
somehow gets triggered by every packet.

A coding style suggestion - can you rearrange it so that the error path 
code is spelled out first? Then the regular path does not have to be 
indented further:

       nskb = skb_clone(skb, GFP_ATOMIC);
       if (!nskb) {
               spin_unlock_irqrestore(&interface_lock, flags);
               return;
       }

       /* ... implicit else ... Proceed normally ... */

> +			return;
> +		}
> +	} else {
> +		spin_unlock_irqrestore(&interface_lock, flags);
> +	}
>   }
>   
>   static void trace_kfree_skb_hit(void *ignore, struct sk_buff *skb, void *location)
> @@ -1315,6 +1334,53 @@ static int net_dm_cmd_trace(struct sk_buff *skb,
>   	return -EOPNOTSUPP;
>   }
>   
> +static int net_dm_interface_start(struct net *net, const char *ifname)
> +{
> +	struct net_device *nd = dev_get_by_name(net, ifname);
> +
> +	if (nd)
> +		interface = nd;
> +	else
> +		return -ENODEV;
> +
> +	return 0;

Similarly here, consider:

   if (!nd)
           return -ENODEV;

   interface = nd;
   return 0;

But maybe I'm nitpicking ...

> +}
> +
> +static int net_dm_interface_stop(struct net *net, const char *ifname)
> +{
> +	dev_put(interface);
> +	interface = NULL;
> +
> +	return 0;
> +}
> +
> +static int net_dm_cmd_ifc_trace(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct net *net = sock_net(skb->sk);
> +	char ifname[IFNAMSIZ];
> +
> +	if (net_dm_is_monitoring())
> +		return -EBUSY;
> +
> +	memset(ifname, 0, IFNAMSIZ);
> +	nla_strlcpy(ifname, info->attrs[NET_DM_ATTR_IFNAME], IFNAMSIZ - 1);
> +
> +	switch (info->genlhdr->cmd) {
> +	case NET_DM_CMD_START_IFC:
> +		if (!interface)
> +			return net_dm_interface_start(net, ifname);
> +		else
> +			return -EBUSY;
> +	case NET_DM_CMD_STOP_IFC:
> +		if (interface)
> +			return net_dm_interface_stop(net, interface->name);
> +		else
> +			return -ENODEV;

... and here too.

Best regards,
Michal

