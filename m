Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969BA2CD3A9
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 11:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388763AbgLCKdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 05:33:12 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:46215 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388710AbgLCKdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 05:33:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606991591; x=1638527591;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=MkLKoEPtrcqpFOmSp5XznQZBCynrr05VpZJ0X7x4A+o=;
  b=fSavh3FjWVDATlBaJCP7Cl5HRaPLVLThwQ3y1A/XP2jpD7J33kU3poEj
   viBy3PbwcW5dhpCj3/GqNF7lQrFr2scwwY29uX2x7eZMMxKZDtkaI341l
   YzW0G/n8arb2UZ7eNRZR1Xa7OWhhV/SHp8Ve8fkmCmZ1mo/YG7xEIqMKF
   w=;
X-IronPort-AV: E=Sophos;i="5.78,389,1599523200"; 
   d="scan'208";a="68866415"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-2225282c.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 03 Dec 2020 10:32:24 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-2225282c.us-west-2.amazon.com (Postfix) with ESMTPS id E2C12A06D0;
        Thu,  3 Dec 2020 10:32:22 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.229) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 3 Dec 2020 10:32:17 +0000
Subject: Re: [PATCH net-next v1 1/3] vm_sockets: Include flag field in the
 vsock address data structure
To:     Stefan Hajnoczi <stefanha@redhat.com>
CC:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Duncan <davdunc@amazon.com>,
        Dexuan Cui <decui@microsoft.com>,
        Alexander Graf <graf@amazon.de>,
        Jorgen Hansen <jhansen@vmware.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20201201152505.19445-1-andraprs@amazon.com>
 <20201201152505.19445-2-andraprs@amazon.com>
 <20201203092155.GB687169@stefanha-x1.localdomain>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <8fcc1daa-4f03-0240-1dda-4daf2e1f7c44@amazon.com>
Date:   Thu, 3 Dec 2020 12:32:08 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201203092155.GB687169@stefanha-x1.localdomain>
Content-Language: en-US
X-Originating-IP: [10.43.160.229]
X-ClientProxiedBy: EX13D13UWA004.ant.amazon.com (10.43.160.251) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 03/12/2020 11:21, Stefan Hajnoczi wrote:
> On Tue, Dec 01, 2020 at 05:25:03PM +0200, Andra Paraschiv wrote:
>> vsock enables communication between virtual machines and the host they
>> are running on. With the multi transport support (guest->host and
>> host->guest), nested VMs can also use vsock channels for communication.
>>
>> In addition to this, by default, all the vsock packets are forwarded to
>> the host, if no host->guest transport is loaded. This behavior can be
>> implicitly used for enabling vsock communication between sibling VMs.
>>
>> Add a flag field in the vsock address data structure that can be used to
>> explicitly mark the vsock connection as being targeted for a certain
>> type of communication. This way, can distinguish between nested VMs and
>> sibling VMs use cases and can also setup them at the same time. Till
>> now, could either have nested VMs or sibling VMs at a time using the
>> vsock communication stack.
>>
>> Use the already available "svm_reserved1" field and mark it as a flag
>> field instead. This flag can be set when initializing the vsock address
>> variable used for the connect() call.
>>
>> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>> ---
>>   include/uapi/linux/vm_sockets.h | 18 +++++++++++++++++-
>>   1 file changed, 17 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_soc=
kets.h
>> index fd0ed7221645d..58da5a91413ac 100644
>> --- a/include/uapi/linux/vm_sockets.h
>> +++ b/include/uapi/linux/vm_sockets.h
>> @@ -114,6 +114,22 @@
>>   =

>>   #define VMADDR_CID_HOST 2
>>   =

>> +/* This sockaddr_vm flag value covers the current default use case:
>> + * local vsock communication between guest and host and nested VMs setu=
p.
>> + * In addition to this, implicitly, the vsock packets are forwarded to =
the host
>> + * if no host->guest vsock transport is set.
>> + */
>> +#define VMADDR_FLAG_DEFAULT_COMMUNICATION	0x0000
>> +
>> +/* Set this flag value in the sockaddr_vm corresponding field if the vs=
ock
>> + * channel needs to be setup between two sibling VMs running on the sam=
e host.
>> + * This way can explicitly distinguish between vsock channels created f=
or nested
>> + * VMs (or local communication between guest and host) and the ones cre=
ated for
>> + * sibling VMs. And vsock channels for multiple use cases (nested / sib=
ling VMs)
>> + * can be setup at the same time.
>> + */
>> +#define VMADDR_FLAG_SIBLING_VMS_COMMUNICATION	0x0001
> vsock has the h2g and g2h concept. It would be more general to call this
> flag VMADDR_FLAG_G2H or less cryptically VMADDR_FLAG_TO_HOST.

Thanks for the feedback, Stefan.

I can update the naming to be more general, such as=A0 "_TO_HOST", and =

keep the use cases (e.g. guest <-> host / nested / sibling VMs =

communication) mention in the comments so that would relate more to the =

motivation behind it.

Andra

>
> That way it just tells the driver in which direction to send packets
> without implying that sibling communication is possible (it's not
> allowed by default on any transport).
>
> I don't have a strong opinion on this but wanted to suggest the idea.
>
> Stefan




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar=
 Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in R=
omania. Registration number J22/2621/2005.

