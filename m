Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DCD2EA440
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 05:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbhAEEHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 23:07:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30624 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726571AbhAEEHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 23:07:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609819577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FknucuoRBtp08a5KMu1lf/hlB/0GtImhroWC39pwzVI=;
        b=S8r3hXaDVGGcFiCWzmXfP6TybGOqtr1nTC1zF74hRoJHJBr60NTvNMGb31zulRh3HmXDWa
        3jPI/etOZw/uDVwf7Yebb6XhxgHKSi1fwFTAgwA9L8fnebMbR9lU7ySYJ9MkotADk1u1Vs
        uPZv2OgJ/su82TaRnscDkwO1F+0k3WE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-38jVJWLiNc6Ysmr-ZHgCvg-1; Mon, 04 Jan 2021 23:06:16 -0500
X-MC-Unique: 38jVJWLiNc6Ysmr-ZHgCvg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BE44192D785;
        Tue,  5 Jan 2021 04:06:13 +0000 (UTC)
Received: from [10.72.13.192] (ovpn-13-192.pek2.redhat.com [10.72.13.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A7E295D9C6;
        Tue,  5 Jan 2021 04:06:08 +0000 (UTC)
Subject: Re: [PATCH linux-next v2 7/7] vdpa_sim_net: Add support for user
 supported devices
To:     Parav Pandit <parav@nvidia.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Cc:     "mst@redhat.com" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20201112064005.349268-1-parav@nvidia.com>
 <20210104033141.105876-1-parav@nvidia.com>
 <20210104033141.105876-8-parav@nvidia.com>
 <ea07c16e-6bc5-0371-4b53-4bf4c75d5af8@redhat.com>
 <BY5PR12MB43227F9431227959051B90B1DCD20@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2e052c52-44e2-a066-3872-0e20805760f2@redhat.com>
Date:   Tue, 5 Jan 2021 12:06:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB43227F9431227959051B90B1DCD20@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/4 下午3:21, Parav Pandit wrote:
>
>> From: Jason Wang <jasowang@redhat.com>
>> Sent: Monday, January 4, 2021 12:35 PM
>>
>> On 2021/1/4 上午11:31, Parav Pandit wrote:
>>>    static int __init vdpasim_net_init(void)
>>>    {
>>>    	int ret = 0;
>>> @@ -176,6 +264,8 @@ static int __init vdpasim_net_init(void)
>>>
>>>    	if (default_device)
>>>    		ret = vdpasim_net_default_dev_register();
>>> +	else
>>> +		ret = vdpasim_net_mgmtdev_init();
>>>    	return ret;
>>>    }
>>>
>>> @@ -183,6 +273,8 @@ static void __exit vdpasim_net_exit(void)
>>>    {
>>>    	if (default_device)
>>>    		vdpasim_net_default_dev_unregister();
>>> +	else
>>> +		vdpasim_net_mgmtdev_cleanup();
>>>    }
>>>
>>>    module_init(vdpasim_net_init);
>>> -- 2.26.2
>>
>> I wonder what's the value of keeping the default device that is out of the
>> control of management API.
> I think we can remove it like how I did in the v1 version. And actual vendor drivers like mlx5_vdpa will likely should do only user created devices.
> I added only for backward compatibility purpose, but we can remove the default simulated vdpa net device.
> What do you recommend?


I think we'd better mandate this management API. This can avoid vendor 
specific configuration that may complex management layer.

Thanks


