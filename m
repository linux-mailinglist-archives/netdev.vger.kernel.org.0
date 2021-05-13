Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2D337F9E3
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 16:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234647AbhEMOpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 10:45:03 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:14889 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234630AbhEMOoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 10:44:16 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id DD6D6521A48;
        Thu, 13 May 2021 17:42:59 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1620916980;
        bh=rrC7pB7ZvT9skg01jvxfGXAPzON2vylog2KME9ggwAg=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=3QmIv7jjqLWHvcOfz6Q/41DWnTUmZ9uSF0AatbmEyFstDkU19KygWZUgF1BAhYwYl
         nJ8Qa3E/8Ut21rTQd3bYVv6Rg2zn71ZBu3BPRSwEmFCljAVMU4pJU01IxRYfHRXYIe
         iZOcwjsRJoBT464miKHP/vztNreeXn1l5Ob0RRES6is43frG1VRcXsTn+yE1Ura0q6
         DdxTK2pFdmWoJ+g1F56rfFc5r+eAIAgTzWaVkSUxnRTijNIIic1ecMMCITiG/jCnU7
         F19d6SaG7wBrkyVLx1MVGNhxaekqPC7+/W6hhpf0oun89eXcXNwIm5u6Y9BLeYs30V
         8+ylbZ+el9s3w==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 44D5752196F;
        Thu, 13 May 2021 17:42:57 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 13
 May 2021 17:42:48 +0300
Subject: Re: [RFC PATCH v9 11/19] virtio/vsock: dequeue callback for
 SOCK_SEQPACKET
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
 <20210508163523.3431999-1-arseny.krasnov@kaspersky.com>
 <20210513115816.332nfej4jyra7vrh@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <ff5e7e54-e56a-6574-2654-4afc3f10a28c@kaspersky.com>
Date:   Thu, 13 May 2021 17:42:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210513115816.332nfej4jyra7vrh@steredhat>
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


On 13.05.2021 14:58, Stefano Garzarella wrote:
> On Sat, May 08, 2021 at 07:35:20PM +0300, Arseny Krasnov wrote:
>> This adds transport callback and it's logic for SEQPACKET dequeue.
>> Callback fetches RW packets from rx queue of socket until whole record
>> is copied(if user's buffer is full, user is not woken up). This is done
>> to not stall sender, because if we wake up user and it leaves syscall,
>> nobody will send credit update for rest of record, and sender will wait
>> for next enter of read syscall at receiver's side. So if user buffer is
>> full, we just send credit update and drop data.
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> ---
>> v8 -> v9:
>> 1) Check for RW packet type is removed from loop(all packet now
>>    considered RW).
>> 2) Locking in loop is fixed.
>> 3) cpu_to_le32()/le32_to_cpu() now used.
>> 4) MSG_TRUNC handling removed from transport.
>>
>> include/linux/virtio_vsock.h            |  5 ++
>> net/vmw_vsock/virtio_transport_common.c | 64 +++++++++++++++++++++++++
>> 2 files changed, 69 insertions(+)
>>
>> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>> index dc636b727179..02acf6e9ae04 100644
>> --- a/include/linux/virtio_vsock.h
>> +++ b/include/linux/virtio_vsock.h
>> @@ -80,6 +80,11 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
>> 			       struct msghdr *msg,
>> 			       size_t len, int flags);
>>
>> +ssize_t
>> +virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>> +				   struct msghdr *msg,
>> +				   int flags,
>> +				   bool *msg_ready);
>> s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
>> s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
>>
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index ad0d34d41444..f649a21dd23b 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -393,6 +393,58 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>> 	return err;
>> }
>>
>> +static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>> +						 struct msghdr *msg,
>> +						 int flags,
>> +						 bool *msg_ready)
>> +{
>> +	struct virtio_vsock_sock *vvs = vsk->trans;
>> +	struct virtio_vsock_pkt *pkt;
>> +	int err = 0;
>> +	size_t user_buf_len = msg->msg_iter.count;
>> +
>> +	*msg_ready = false;
>> +	spin_lock_bh(&vvs->rx_lock);
>> +
>> +	while (!*msg_ready && !list_empty(&vvs->rx_queue) && err >= 0) {
>> +		size_t bytes_to_copy;
>> +		size_t pkt_len;
>> +
>> +		pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
>> +		pkt_len = (size_t)le32_to_cpu(pkt->hdr.len);
>> +		bytes_to_copy = min(user_buf_len, pkt_len);
>> +
>> +		if (bytes_to_copy) {
>> +			/* sk_lock is held by caller so no one else can dequeue.
>> +			 * Unlock rx_lock since memcpy_to_msg() may sleep.
>> +			 */
>> +			spin_unlock_bh(&vvs->rx_lock);
>> +
>> +			if (memcpy_to_msg(msg, pkt->buf, bytes_to_copy)) 
>> {
>> +				err = -EINVAL;
>> +			} else {
>> +				err += pkt_len;
> If `bytes_to_copy == 0` we are not increasing the real length.
>
> Anyway is a bit confusing increase a variable called `err`, I think is 
> better to have another variable to store this information that we return 
> if there aren't errors.
Ack
>
>
