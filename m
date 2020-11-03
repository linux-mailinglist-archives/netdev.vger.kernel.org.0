Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9E82A3EDE
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 09:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbgKCI1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 03:27:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25615 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725968AbgKCI1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 03:27:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604392026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2RDLlRjSajBk3/a/oVPzFYYT4Nd9yUHnU4bGNCKRxk0=;
        b=E/dOA3LrRKQrc16UQiGirMaoYbsvmk9p/OuQnKFs8GpYPYDRMhMY29FFgwsoW5tq6pvmrI
        BdBMyHvlmJgkG+6YXi2IF7DglZfcLjzFmBEvSRJ/guaiBe/RV4pwPNlDUVFHB46KY0bbs+
        AQKU062/dn6o1laW5raIAaWWSsKYGXE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-tjuOfqiHMfikRJ34jlVcWg-1; Tue, 03 Nov 2020 03:27:04 -0500
X-MC-Unique: tjuOfqiHMfikRJ34jlVcWg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D40B186840A;
        Tue,  3 Nov 2020 08:27:02 +0000 (UTC)
Received: from [10.36.112.7] (ovpn-112-7.ams2.redhat.com [10.36.112.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 543696E70B;
        Tue,  3 Nov 2020 08:27:01 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org
Subject: Re: [PATCH net] net: openvswitch: silence suspicious RCU usage
 warning
Date:   Tue, 03 Nov 2020 09:26:58 +0100
Message-ID: <5F7C333C-2862-4F93-B405-A7F2C271E812@redhat.com>
In-Reply-To: <20201102115123.0f7460cc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <160398318667.8898.856205445259063348.stgit@ebuild>
 <20201030142852.7d41eecc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <AFFC5913-5595-464B-9B1B-EB25E730C2E2@redhat.com>
 <20201102115123.0f7460cc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2 Nov 2020, at 20:51, Jakub Kicinski wrote:

> On Mon, 02 Nov 2020 09:52:19 +0100 Eelco Chaudron wrote:
>> On 30 Oct 2020, at 22:28, Jakub Kicinski wrote:
>>>> @@ -1695,6 +1695,9 @@ static int ovs_dp_cmd_new(struct sk_buff *skb,
>>>> struct genl_info *info)
>>>>  	if (err)
>>>>  		goto err_destroy_ports;
>>>>
>>>> +	/* So far only local changes have been made, now need the lock. */
>>>> +	ovs_lock();
>>>
>>> Should we move the lock below assignments to param?
>>>
>>> Looks a little strange to protect stack variables with a global lock.
>>
>> You are right, I should have moved it down after the assignment. I will
>> send out a v2.
>>
>>> Let's update the name of the label.
>>
>> Guess now it is, unlock and destroy meters, so what label are you
>> looking for?
>>
>> err_unlock_and_destroy_meters: which looks a bit long, or just
>> err_unlock:
>
> I feel like I saw some names like err_unlock_and_destroy_meters in OvS
> code, but can't find them in this file right now.
>
> I'd personally go for kist err_unlock, or maybe err_unlock_ovs as is
> used in other functions in this file.
>
> But as long as it starts with err_unlock it's fine by me :)

Ack, sent out a v2.

