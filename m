Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9A120066
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 09:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbfEPHg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 03:36:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33142 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726277AbfEPHg6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 03:36:58 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2F0C085376;
        Thu, 16 May 2019 07:36:58 +0000 (UTC)
Received: from [10.72.12.129] (ovpn-12-129.pek2.redhat.com [10.72.12.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 35C9C60BE5;
        Thu, 16 May 2019 07:36:53 +0000 (UTC)
Subject: Re: [RFC 1/2] netvsc: invoke xdp_generic from VF frame handler
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, davem@davemloft.net,
        netdev@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>
References: <20190515080319.15514-1-sthemmin@microsoft.com>
 <20190515080319.15514-2-sthemmin@microsoft.com>
 <096b0f82-707c-fd35-e3ce-3c266a606af5@redhat.com>
 <20190515082356.21a837b2@xps13.lan>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8549f28f-00d8-f729-71f8-c4fbdbc5127d@redhat.com>
Date:   Thu, 16 May 2019 15:36:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190515082356.21a837b2@xps13.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Thu, 16 May 2019 07:36:58 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/15 下午11:23, Stephen Hemminger wrote:
> On Wed, 15 May 2019 16:12:42 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>
>> On 2019/5/15 下午4:03, Stephen Hemminger wrote:
>>> XDP generic does not work correctly with the Hyper-V/Azure netvsc
>>> device because of packet processing order. Only packets on the
>>> synthetic path get seen by the XDP program. The VF device packets
>>> are not seen.
>>>
>>> By the time the packets that arrive on the VF are handled by
>>> netvsc after the first pass of XDP generic (on the VF) has already
>>> been done.
>>>
>>> A fix for the netvsc device is to do this in the VF packet handler.
>>> by directly calling do_xdp_generic() if XDP program is present
>>> on the parent device.
>>>
>>> A riskier but maybe better alternative would be to do this netdev core
>>> code after the receive handler is invoked (if RX_HANDLER_ANOTHER
>>> is returned).
>>
>> Something like what I propose at
>> https://lore.kernel.org/patchwork/patch/973819/ ?
>>
>> It belongs to a series that try to make XDP (both native and generic)
>> work for stacked device. But for some reason (probably performance), the
>> maintainer seems not like the idea.
>>
>> Maybe it's time to reconsider that?
>>
>> Thanks
>
> I like your generic solution but it introduces a change in semantics.
> Netvsc always changes device when returning a ANOTHER but do all devices?
> If some other stacked device did this then there a chance that using
> XDP on that device would see same packet twice.


Good point.  Can we simply add a check and call XDP only if dev is 
changed in this case?

Thanks

