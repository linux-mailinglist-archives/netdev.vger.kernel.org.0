Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57DD2367DDD
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 11:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbhDVJk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 05:40:58 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:36141 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbhDVJk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 05:40:57 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 9DBD25219A0;
        Thu, 22 Apr 2021 12:40:20 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1619084420;
        bh=grePwXi7crrlM6+Hn5lGfxZJrOzcrxE7eMkw/ki7RsE=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=5ODqkmRav/7IYTP0TTODcImsToRzLp6RRTDUFEEoHiLwosKOf0DdIk5KdjQRvTSOe
         YKuuvewKliaZ3zZghnx6qtC61cI+BXI5CYiDEbZLDat0FBqoelp5EJPGzDQU+bF/6v
         o0c+hOcL8PSOgiydXOIvOUxujPXMq3CEdQx/vhrp1MA5ZxuP5pTfEqTQCQUujNFsYk
         4Fxcx9AIVl+OeHP8ngofLjCAP6sARWKn/ppaWtzVcTxxQQBXs7sYOK01HXm3+AoynJ
         ssjWVekCWRgWLPA92v95QDnda29aKdapPnS2kq4fr7uw/uFTXK1h0LkOldjlXzwWAu
         Ty8k195fDjt4w==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 55CDB521998;
        Thu, 22 Apr 2021 12:40:19 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 22
 Apr 2021 12:40:18 +0300
Subject: Re: [RFC PATCH v8 00/19] virtio/vsock: introduce SOCK_SEQPACKET
 support
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Alexander Popov <alex.popov@linux.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
 <20210421095213.25hnfi2th7gzyzt2@steredhat>
 <2c3d0749-0f41-e064-0153-b6130268add2@kaspersky.com>
 <20210422084638.bvblk33b4oi6cec6@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <bfefdd94-a84f-8bed-331e-274654a7426f@kaspersky.com>
Date:   Thu, 22 Apr 2021 12:40:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210422084638.bvblk33b4oi6cec6@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/22/2021 09:22:21
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 163278 [Apr 22 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 442 442 b985cb57763b61d2a20abb585d5d4cc10c315b09
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: kaspersky.com:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/22/2021 09:24:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 22.04.2021 7:02:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/04/22 05:13:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/04/22 07:02:00 #16598851
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 22.04.2021 11:46, Stefano Garzarella wrote:
> On Wed, Apr 21, 2021 at 06:06:28PM +0300, Arseny Krasnov wrote:
>> On 21.04.2021 12:52, Stefano Garzarella wrote:
>>> On Tue, Apr 13, 2021 at 03:39:51PM +0300, Arseny Krasnov wrote:
>>>> v7 -> v8:
>>>> General changelog:
>>>> - whole idea is simplified: channel now considered reliable,
>>>>   so SEQ_BEGIN, SEQ_END, 'msg_len' and 'msg_id' were removed.
>>>>   Only thing that is used to mark end of message is bit in
>>>>   'flags' field of packet header: VIRTIO_VSOCK_SEQ_EOR. Packet
>>>>   with such bit set to 1 means, that this is last packet of
>>>>   message.
>>>>
>>>> - POSIX MSG_EOR support is removed, as there is no exact
>>>>   description how it works.
>>> It would be nice to support it, I'll try to see if I can find anything.
>>>
>>> I just reviewed the series. I think the most important things to fix are
>>> the `seqpacket_allow` stored in the struct virtio_transport that is
>>> wrong IMHO, and use cpu_to_le32()/le32_to_cpu() to access the flags.
>> Thank You, i'll prepare next version. Main question is: does this
>> approach(no SEQ_BEGIN, SEQ_END, 'msg_len' and 'msg_id') considered
>> good? In this case it will be easier to prepare final version, because 
>> is smaller and more simple than previous logic. Also patch to spec
>> will be smaller.
> Yes, it's definitely much better than before.
>
> The only problem I see is that we add some overhead per fragment 
> (header). We could solve that with the mergeable buffers that Jiang is 
> considering for DGRAM.

If we are talking about receive, i think, i can reuse merge logic for

stream sockets, the only difference is that buffers are mergeable

until previous EOR(e.g. previous message) bit is found in rx queue.

>
> If we have that support, I think we could reuse it here as well, but it 
> might be a next step.
>
> Thanks,
> Stefano
>
>
