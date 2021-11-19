Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7657456D5D
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 11:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234690AbhKSKe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 05:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbhKSKe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 05:34:26 -0500
X-Greylist: delayed 72 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 19 Nov 2021 02:31:24 PST
Received: from forwardcorp1p.mail.yandex.net (forwardcorp1p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b6:217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3420C061574;
        Fri, 19 Nov 2021 02:31:24 -0800 (PST)
Received: from sas1-4cbebe29391b.qloud-c.yandex.net (sas1-4cbebe29391b.qloud-c.yandex.net [IPv6:2a02:6b8:c08:789:0:640:4cbe:be29])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 8F0A52E1222;
        Fri, 19 Nov 2021 13:30:10 +0300 (MSK)
Received: from sas1-9d43635d01d6.qloud-c.yandex.net (sas1-9d43635d01d6.qloud-c.yandex.net [2a02:6b8:c08:793:0:640:9d43:635d])
        by sas1-4cbebe29391b.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id EejncC0C2w-U9sCrFN0;
        Fri, 19 Nov 2021 13:30:10 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1637317810; bh=CNR77mGI9FuNfZekh4RolAJbxG4n6U7nwPjjApEGXe4=;
        h=In-Reply-To:References:Date:From:To:Subject:Message-ID:Cc;
        b=FNSMwvuoYXQN72nKlA+NAc23WzZu6xJUqgNhivqVxd9jFZNjJNFRevj7xBmOPiOuz
         42UQqvGH02Aoo0deWCrQfC+ZwJPkhx07oR37CZmseBQ720OtzP/01gVpZSfBuBJ/RR
         UKHc6wCpF5aIvQ4kOKQ4D3x6OWUvXuYeRWZiyIKc=
Authentication-Results: sas1-4cbebe29391b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.com
Received: from [IPv6:2a02:6b8:0:107:3e85:844d:5b1d:60a] (dynamic-red3.dhcp.yndx.net [2a02:6b8:0:107:3e85:844d:5b1d:60a])
        by sas1-9d43635d01d6.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id DHYuf2dk7S-U8xOn5TV;
        Fri, 19 Nov 2021 13:30:09 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
Subject: Re: [PATCH 2/6] vhost_net: get rid of vhost_net_flush_vq() and extra
 flush calls
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211115153003.9140-1-arbn@yandex-team.com>
 <20211115153003.9140-2-arbn@yandex-team.com>
 <20211116143354.exgqcjfbmmbaahs4@steredhat>
From:   Andrey Ryabinin <arbn@yandex-team.com>
Message-ID: <4f85faf1-a900-addc-ced6-75375931e660@yandex-team.com>
Date:   Fri, 19 Nov 2021 13:31:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211116143354.exgqcjfbmmbaahs4@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/16/21 5:33 PM, Stefano Garzarella wrote:
> On Mon, Nov 15, 2021 at 06:29:59PM +0300, Andrey Ryabinin wrote:

>> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
>> index 638bb640d6b4..ecbaa5c6005f 100644
>> --- a/drivers/vhost/vhost.h
>> +++ b/drivers/vhost/vhost.h
>> @@ -15,6 +15,7 @@
>> #include <linux/vhost_iotlb.h>
>> #include <linux/irqbypass.h>
>>
>> +struct vhost_dev;
> 
> Is this change needed?
> 

Looks like not. Will remove.
