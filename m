Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6580B2C23FE
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 12:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732285AbgKXLSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 06:18:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48460 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726628AbgKXLSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 06:18:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606216714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FJj9wUGy3t2CupfEKAb1SmLb8c/nG6qQ851W9D9aMJM=;
        b=As3us+VEMe9XXLqzj38tzQ+ZfJ33YIFDBKGAvWCK7MCYSTh0XtBrDuiZTKRYWofc6xTVB4
        GH+my8zZF6gS68D/LPdgXD5DLfb0qT1/qyWqh47GpHvjs7YLqe/z4+19bCVLKSr2p/Fz7Z
        hGBo4sMZOgnLFsiDWGX78xPnY4aSasg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-EbMtq_aqP7S5FXve9TiIqA-1; Tue, 24 Nov 2020 06:18:30 -0500
X-MC-Unique: EbMtq_aqP7S5FXve9TiIqA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3411190A7A5;
        Tue, 24 Nov 2020 11:18:28 +0000 (UTC)
Received: from [10.36.113.14] (ovpn-113-14.ams2.redhat.com [10.36.113.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5475260873;
        Tue, 24 Nov 2020 11:18:27 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org,
        pshelar@ovn.org, bindiyakurle@gmail.com, i.maximets@ovn.org,
        mcroce@linux.microsoft.com
Subject: Re: [PATCH net] net: openvswitch: fix TTL decrement action netlink
 message format
Date:   Tue, 24 Nov 2020 12:18:25 +0100
Message-ID: <4829A14E-DA37-49F0-9FED-F69D8E6A3C54@redhat.com>
In-Reply-To: <20201120131228.489c3b52@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <160577663600.7755.4779460826621858224.stgit@wsfd-netdev64.ntdv.lab.eng.bos.redhat.com>
 <20201120131228.489c3b52@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20 Nov 2020, at 22:12, Jakub Kicinski wrote:

> On Thu, 19 Nov 2020 04:04:04 -0500 Eelco Chaudron wrote:
>> Currently, the openvswitch module is not accepting the correctly 
>> formated
>> netlink message for the TTL decrement action. For both setting and 
>> getting
>> the dec_ttl action, the actions should be nested in the
>> OVS_DEC_TTL_ATTR_ACTION attribute as mentioned in the openvswitch.h 
>> uapi.
>
> IOW this change will not break any known user space, correct?

It will not as there isn’t any yet. Unfortunately, the original patch 
was sent out without a userspace part. It was internally tested by the 
original authors and not properly reviewed to bring forward the issue. 
They did add some weird code to work around it.

> But existing OvS user space already expects it to work like you
> make it work now?
>
> What's the harm in leaving it as is?

Without this change, the different Datapaths in OVS behave differently, 
making the code to be datapath agnostic having to do all kinds of weird 
tricks to work around it.

But even worse, the patch in the current format could interpret 
additional options/attributes as actions, due to the actions not being 
encapsulated/nested within the actual attribute.

>> Fixes: 744676e77720 ("openvswitch: add TTL decrement action")
>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>
> Can we get a review from OvS folks? Matteo looks good to you (as the
> original author)?

See Matteo’s reply, looks like he is ok with this change.

>> -	err = __ovs_nla_copy_actions(net, attr, key, sfa, eth_type,
>> +	err = __ovs_nla_copy_actions(net, actions, key, sfa, eth_type,
>>  				     vlan_tci, mpls_label_count, log);
>>  	if (err)
>>  		return err;
>
> You're not canceling any nests on error, I assume this is normal.

Yes, on error the sfa actions are not used.

>> +	add_nested_action_end(*sfa, action_start);
>>  	add_nested_action_end(*sfa, start);
>>  	return 0;
>>  }

