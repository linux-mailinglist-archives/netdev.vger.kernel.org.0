Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3206A37FA02
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 16:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234746AbhEMOwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 10:52:09 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:19770 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234753AbhEMOuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 10:50:02 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 5809F76A1D;
        Thu, 13 May 2021 17:48:21 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1620917301;
        bh=XxHliHWgEr2ee/dBneY3bSyKZrgkkLf+nC60MASuIN8=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=i73Hx8Y9hh7lOEoBXxlwpjY6Lt3QDh5/xsAfhO2kSMOqI3cSf7qPx9xpKTkRMJsKJ
         BE6qasNE4Aga1gd547L9xiCX7F7HJvP8xfFbZ9lXVJSON8R83NBi/XSUOl6eKLZUQ2
         YeV8ES2CPkzP8eA2FIzGHnD23eTGhCUV8xaio63Bh7hleXAXrsA+vGr67Z0sOQ1nBz
         9dn/6USFtCXQCqMAunxQvS26K7YVApTm/VLwQsd0uj0yWconhSfpMcBaMykOi7Z8dd
         T8dxsDoID0acndKUuR7JTqy9oG14JczGcOJ3y3Zs5X/G5lWpb5SvdnZ17WuY47a8RL
         L6jlEDtEclcyA==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 1640076902;
        Thu, 13 May 2021 17:48:21 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 13
 May 2021 17:48:20 +0300
Subject: Re: [RFC PATCH v9 19/19] af_vsock: serialize writes to shared socket
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
 <20210508163738.3432975-1-arseny.krasnov@kaspersky.com>
 <20210513140150.ugw6foy742fxan4w@steredhat>
 <20210513144653.ogzfvypqpjsz2iga@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <a0cd1806-22d1-8197-50dc-b63a43f33807@kaspersky.com>
Date:   Thu, 13 May 2021 17:48:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210513144653.ogzfvypqpjsz2iga@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 05/13/2021 14:30:02
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 163644 [May 13 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 445 445 d5f7ae5578b0f01c45f955a2a751ac25953290c9
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 05/13/2021 14:33:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 13.05.2021 13:39:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/05/13 13:03:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/05/13 10:44:00 #16575454
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 13.05.2021 17:46, Stefano Garzarella wrote:
> On Thu, May 13, 2021 at 04:01:50PM +0200, Stefano Garzarella wrote:
>> On Sat, May 08, 2021 at 07:37:35PM +0300, Arseny Krasnov wrote:
>>> This add logic, that serializes write access to single socket
>>> by multiple threads. It is implemented be adding field with TID
>>> of current writer. When writer tries to send something, it checks
>>> that field is -1(free), else it sleep in the same way as waiting
>>> for free space at peers' side.
>>>
>>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>>> ---
>>> include/net/af_vsock.h   |  1 +
>>> net/vmw_vsock/af_vsock.c | 10 +++++++++-
>>> 2 files changed, 10 insertions(+), 1 deletion(-)
>> I think you forgot to move this patch at the beginning of the series.
>> It's important because in this way we can backport to stable branches 
>> easily.
>>
>> About the implementation, can't we just add a mutex that we hold until 
>> we have sent all the payload?
> Re-thinking, I guess we can't because we have the timeout to deal 
> with...
Yes, i forgot about why i've implemented it using 'tid_owner' :)
>
>> I need to check other implementations like TCP.
>>
> Thanks,
> Stefano
>
>
