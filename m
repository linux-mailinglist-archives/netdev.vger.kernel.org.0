Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E284437F9EA
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 16:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234729AbhEMOqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 10:46:11 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:17908 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234687AbhEMOpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 10:45:15 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id D46F375F64;
        Thu, 13 May 2021 17:44:03 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1620917043;
        bh=tFmAcniccyqNgOFi0MN5JscuUSyBejT6xouP0xAeopg=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=vs2ir75w4YMO6RhoYKEG6SO0+3TS6ZRQv8eF3MI5CXFB0QP9+sEZx/hKu/HdN7NB7
         9/fnZokkvh+CsodzrbKCZGFHVf460IQ3l+KJNOWEKMeFQ8SbUx7hMSdBH/eQdzJfMw
         n+/ASGcbFxov3NfMfKtzFcaD8RVdX6fnv5s5pBJRvXWu4FoZ17AOmypZBMK3LVE0qr
         xca0zHZbJL5NbQJ4DhVR76TCpD+Lh5nvcBujmp/IrOpUNNjbIuwMxHLG2wjbRwc4gH
         TivRStWrp+bARKhWqA4B+CkJFsy51V8P4HIJpOavrdjs/hrs0NLrZ1kOXaLBYb7soe
         kBORMuV6LlWtQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 9130D75F30;
        Thu, 13 May 2021 17:44:03 +0300 (MSK)
Received: from [10.16.171.77] (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 13
 May 2021 17:44:03 +0300
Subject: Re: [RFC PATCH v9 14/19] virtio/vsock: enable SEQPACKET for transport
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
 <20210508163617.3432380-1-arseny.krasnov@kaspersky.com>
 <20210513124912.sw4rea75re7xwjdz@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <4af35e48-9ef0-2191-76d5-a5e2354ca0b9@kaspersky.com>
Date:   Thu, 13 May 2021 17:44:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210513124912.sw4rea75re7xwjdz@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
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


On 13.05.2021 15:49, Stefano Garzarella wrote:
> On Sat, May 08, 2021 at 07:36:14PM +0300, Arseny Krasnov wrote:
>> This adds
>> 1) SEQPACKET ops for virtio transport and 'seqpacket_allow()' callback.
>> 2) Handling of SEQPACKET bit: guest tries to negotiate it with vhost.
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> ---
>> v8 -> v9:
>> 1) Move 'seqpacket_allow' to 'struct virtio_vsock'.
>>
>> net/vmw_vsock/virtio_transport.c | 25 +++++++++++++++++++++++++
>> 1 file changed, 25 insertions(+)
>>
>> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>> index 2700a63ab095..f714c16af65d 100644
>> --- a/net/vmw_vsock/virtio_transport.c
>> +++ b/net/vmw_vsock/virtio_transport.c
>> @@ -62,6 +62,7 @@ struct virtio_vsock {
>> 	struct virtio_vsock_event event_list[8];
>>
>> 	u32 guest_cid;
>> +	bool seqpacket_allow;
>> };
>>
>> static u32 virtio_transport_get_local_cid(void)
>> @@ -443,6 +444,8 @@ static void virtio_vsock_rx_done(struct virtqueue *vq)
>> 	queue_work(virtio_vsock_workqueue, &vsock->rx_work);
>> }
>>
>> +static bool virtio_transport_seqpacket_allow(u32 remote_cid);
>> +
>> static struct virtio_transport virtio_transport = {
>> 	.transport = {
>> 		.module                   = THIS_MODULE,
>> @@ -469,6 +472,10 @@ static struct virtio_transport virtio_transport = {
>> 		.stream_is_active         = virtio_transport_stream_is_active,
>> 		.stream_allow             = virtio_transport_stream_allow,
>>
>> +		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
>> +		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
>> +		.seqpacket_allow          = virtio_transport_seqpacket_allow,
>> +
>> 		.notify_poll_in           = virtio_transport_notify_poll_in,
>> 		.notify_poll_out          = virtio_transport_notify_poll_out,
>> 		.notify_recv_init         = virtio_transport_notify_recv_init,
>> @@ -485,6 +492,19 @@ static struct virtio_transport virtio_transport = {
>> 	.send_pkt = virtio_transport_send_pkt,
>> };
>>
>> +static bool virtio_transport_seqpacket_allow(u32 remote_cid)
>> +{
>> +	struct virtio_vsock *vsock;
>> +	bool seqpacket_allow;
>> +
>> +	rcu_read_lock();
>> +	vsock = rcu_dereference(the_virtio_vsock);
>> +	seqpacket_allow = vsock->seqpacket_allow;
>> +	rcu_read_unlock();
>> +
>> +	return seqpacket_allow;
>> +}
>> +
>> static void virtio_transport_rx_work(struct work_struct *work)
>> {
>> 	struct virtio_vsock *vsock =
>> @@ -612,6 +632,10 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>> 	rcu_assign_pointer(the_virtio_vsock, vsock);
>>
>> 	mutex_unlock(&the_virtio_vsock_mutex);
>> +
>> +	if (vdev->features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))
> We should use virtio_has_feature() to check the device features.
>
>> +		vsock->seqpacket_allow = true;
> When we assign the_virtio_vsock pointer, we should already set all the 
> fields, so please move this code before the following block:
>
> 	# here
>
> 	vdev->priv = vsock;
> 	rcu_assign_pointer(the_virtio_vsock, vsock);
Ack
>
>
