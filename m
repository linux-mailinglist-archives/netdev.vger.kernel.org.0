Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77AB66D1930
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbjCaIBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbjCaIBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:01:07 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424C0B743;
        Fri, 31 Mar 2023 01:00:49 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id A069F5FD37;
        Fri, 31 Mar 2023 11:00:47 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1680249647;
        bh=LrSavz6ZxpB+cGyjOWLRxU20+S4IOL/y4TU59q9/XlE=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=poU6mGAfk7nbEuTTIq2mMI71b3NM9BhoGdFZh2w3el1H8YLBkmlAAW8g/R6ddKZKi
         v8F6D5y0HbfDd7hgLJlFP+Nb+Osmtz2vhzpagU9a6ROzqJgAoaQn6BR6X4pTD4JGhJ
         glUIxr9nt+k+y/enFleOS9/ejoQml45u6npbizpxBwa2Wc9QSGM8dl1g84uh/O/xad
         ie2EtnuoiY6LsaSYxQ8to6cwashNHzv0pyGWSpRFeRoKqzB//jIcdOy1je/UrTZxKV
         QT8vc1COewVPvpmNrMKklkXXhkxa2fNqJjO/NtNH3h2yb+vkg2gHLegsY/YDgtThph
         1JjlUG68wLSdA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Fri, 31 Mar 2023 11:00:47 +0300 (MSK)
Message-ID: <69ae1718-0c99-a4a1-645f-5c87271d6bd6@sberdevices.ru>
Date:   Fri, 31 Mar 2023 10:57:21 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v3 2/4] vsock/vmci: convert VMCI error code to -ENOMEM
 on receive
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>,
        <pv-drivers@vmware.com>
References: <4d34fac8-7170-5a3e-5043-42a9f7e4b5b3@sberdevices.ru>
 <9fd06ca5-ace9-251d-34af-aca4db9c3ee0@sberdevices.ru>
 <7pypi573nxgwz7vrgd2cwcrtha4abijutlsgtnxrwcgaatdjbz@cwnq5dlurfhs>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <7pypi573nxgwz7vrgd2cwcrtha4abijutlsgtnxrwcgaatdjbz@cwnq5dlurfhs>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH02.sberdevices.ru (172.16.1.5) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/31 05:18:00 #21105108
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 31.03.2023 10:12, Stefano Garzarella wrote:
> On Thu, Mar 30, 2023 at 11:18:36PM +0300, Arseniy Krasnov wrote:
>>
>>
>> On 30.03.2023 23:13, Arseniy Krasnov wrote:
>>> This adds conversion of VMCI specific error code to general -ENOMEM. It
>>> is needed, because af_vsock.c passes error value returned from transport
>>> to the user, which does not expect to get VMCI_ERROR_* values.
>>
>> @Stefano, I have some doubts about this commit message, as it says "... af_vsock.c
>> passes error value returned from transport to the user ...", but this
>> behaviour is implemented only in the next patch. Is it ok, if both patches
>> are in a single patchset?
> 
> Yes indeed it is not clear. In my opinion we can do one of these 2
> things:
> 
> 1. Update the message, where we can say that this is a preparation patch
>    for the next changes where af_vsock.c will directly return transport
>    values to the user, so we need to return an errno.
> 
> 2. Merge this patch and patch 3 in a single patch.
> 
> Both are fine for my point of view, take your choice ;-)

Ok! Thanks for this!

Thanks, Arseniy

> 
> Thanks,
> Stefano
> 
