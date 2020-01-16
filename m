Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2740213DF79
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 17:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgAPQA7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 16 Jan 2020 11:00:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43582 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgAPQA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 11:00:59 -0500
Received: from c-67-160-6-8.hsd1.wa.comcast.net ([67.160.6.8] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1is7Zl-0004NP-P7; Thu, 16 Jan 2020 16:00:54 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id CF0AE630E4; Thu, 16 Jan 2020 08:00:51 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id C7E35AC1CC;
        Thu, 16 Jan 2020 08:00:51 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Maor Gottlieb <maorg@mellanox.com>
cc:     Andy Gospodarek <andy@greyhouse.net>,
        Jiri Pirko <jiri@resnulli.us>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Mark Zhang <markz@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: Re: Expose bond_xmit_hash function
In-reply-to: <8e90935b-7485-0969-6fe4-d802d259f778@mellanox.com>
References: <03a6dcfc-f3c7-925d-8ed8-3c42777fd03c@mellanox.com> <20200115094513.GS2131@nanopsycho> <80ad03a2-9926-bf75-d79c-be554c4afaaf@mellanox.com> <20200115141535.GT2131@nanopsycho> <20200116144256.GA87583@C02YVCJELVCG> <8e90935b-7485-0969-6fe4-d802d259f778@mellanox.com>
Comments: In-reply-to Maor Gottlieb <maorg@mellanox.com>
   message dated "Thu, 16 Jan 2020 15:55:50 +0000."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date:   Thu, 16 Jan 2020 08:00:51 -0800
Message-ID: <31666.1579190451@famine>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maor Gottlieb <maorg@mellanox.com> wrote:

>
>On 1/16/2020 4:42 PM, Andy Gospodarek wrote:
>> On Wed, Jan 15, 2020 at 03:15:35PM +0100, Jiri Pirko wrote:
>>> Wed, Jan 15, 2020 at 02:04:49PM CET, maorg@mellanox.com wrote:
>>>> On 1/15/2020 11:45 AM, Jiri Pirko wrote:
>>>>> Wed, Jan 15, 2020 at 09:01:43AM CET, maorg@mellanox.com wrote:
>>>>>> RDMA over Converged Ethernet (RoCE) is a standard protocol which enables
>>>>>> RDMA’s efficient data transfer over Ethernet networks allowing transport
>>>>>> offload with hardware RDMA engine implementation.
>>>>>> The RoCE v2 protocol exists on top of either the UDP/IPv4 or the
>>>>>> UDP/IPv6 protocol:
>>>>>>
>>>>>> --------------------------------------------------------------
>>>>>> | L2 | L3 | UDP |IB BTH | Payload| ICRC | FCS |
>>>>>> --------------------------------------------------------------
>>>>>>
>>>>>> When a bond LAG netdev is in use, we would like to have the same hash
>>>>>> result for RoCE packets as any other UDP packets, for this purpose we
>>>>>> need to expose the bond_xmit_hash function to external modules.
>>>>>> If no objection, I will push a patch that export this symbol.
>>>>> I don't think it is good idea to do it. It is an internal bond function.
>>>>> it even accepts "struct bonding *bond". Do you plan to push netdev
>>>>> struct as an arg instead? What about team? What about OVS bonding?
>>>> No, I am planning to pass the bond struct as an arg. Currently, team
>>> Hmm, that would be ofcourse wrong, as it is internal bonding driver
>>> structure.
>>>
>>>
>>>> bonding is not supported in RoCE LAG and I don't see how OVS is related.
>>> Should work for all. OVS is related in a sense that you can do bonding
>>> there too.
>>>
>>>
>>>>> Also, you don't really need a hash, you need a slave that is going to be
>>>>> used for a packet xmit.
>>>>>
>>>>> I think this could work in a generic way:
>>>>>
>>>>> struct net_device *master_xmit_slave_get(struct net_device *master_dev,
>>>>> 					 struct sk_buff *skb);
>>>> The suggestion is to put this function in the bond driver and call it
>>>> instead of bond_xmit_hash? is it still necessary if I have the bond pointer?
>>> No. This should be in a generic code. No direct calls down to bonding
>>> driver please. Or do you want to load bonding module every time your
>>> module loads?
>>>
>>> I thinks this can be implemented with ndo with "master_xmit_slave_get()"
>>> as a wrapper. Masters that support this would just implement the ndo.
>> In general I think this is a good idea (though maybe not with an skb as
>> an arg so we can use it easily within BPF), but I'm not sure if solves
>> the problem that Maor et al were setting out to solve.
>>
>> Maor, if you did export bond_xmit_hash() to be used by another driver,
>> you would presumably have a check in place so if the RoCE and UDP
>> packets had a different hash function output you would make a change and
>> be sure that the UDP frames would go out on the same device that the
>> RoCE traffic would normally use.  Is this correct?  Would you also send
>> the frames directly on the interface using dev_queue_xmit() and bypass
>> the bonding driver completely?
>
>RoCE packets are UDP. The idea is that the same UDP header (RoCE as 
>well) will get the same hash result so they will be transmitted from the 
>same port.
>The frames will be sent by using the RDMA send API and bypass the 
>bonding driver completely.
>Is it answer your question?

	If the RDMA send bypasses bonding, how will you insure that the
same hash result maps to the same underlying interface for both bonding
and RDMA?

	-J

>> I don't think I fundamentally have a problem with this, I just want to
>> make sure I understand your proposed code-flow.
>>
>> Thanks!
>>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
