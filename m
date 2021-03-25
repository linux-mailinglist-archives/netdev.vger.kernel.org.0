Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610C7349663
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 17:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbhCYQFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 12:05:17 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:37244 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbhCYQE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 12:04:57 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 0288877588;
        Thu, 25 Mar 2021 19:04:55 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1616688295;
        bh=DJ7GiyTew++J90qV1Gfa/LTSfJ0LcIYCC/eHcrRH4ig=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=eWMqYEilOnMEkmu5owDDSz1QrSJ1S6Jef1+Twiz/DJ5mONaqcJDmwCRITlVDicg79
         yPlESp/mBXalWygX7kh3oBoqEX86x479hES9unR39IAfYgXFxo4lYXVbR203IzseoZ
         3dRHN490yF2MYMBiL9YUCn8LR9GphPehrAYqFR4abSIn0CUnMly2YY6M6i+IquQxnQ
         R54aQ8iU+iOluuQdvtKTCWtre9LiS/Hggjr820bxCLWOiAzQ3WwikSXTphj0j4yJpU
         9GCM5vihrzfcxT4QHcoDqnQxBF3k3Ys/JGnpdsPdYfDLVJBxtPAsNCrt/E0D8CKPqE
         m6TFvlKPE+vog==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id B6EE27758B;
        Thu, 25 Mar 2021 19:04:54 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 25
 Mar 2021 19:04:53 +0300
Subject: Re: [RFC PATCH v7 17/22] vhost/vsock: setup SEQPACKET ops for
 transport
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Jeff Vander Stoep <jeffv@google.com>,
        Alexander Popov <alex.popov@linux.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
 <20210323131421.2461760-1-arseny.krasnov@kaspersky.com>
 <20210325104205.y5z6qjv5g2kzvj3m@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <ff9ac529-e44a-9f68-f2d2-cc37a2eab938@kaspersky.com>
Date:   Thu, 25 Mar 2021 19:04:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210325104205.y5z6qjv5g2kzvj3m@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 03/25/2021 15:37:01
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 162675 [Mar 25 2021]
X-KSE-AntiSpam-Info: LuaCore: 438 438 e169a60cee0e977a975a890ed8ef829a2851344a
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 03/25/2021 15:40:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 25.03.2021 15:18:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/03/25 14:47:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/03/25 13:43:00 #16496755
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 25.03.2021 13:42, Stefano Garzarella wrote:
> On Tue, Mar 23, 2021 at 04:14:18PM +0300, Arseny Krasnov wrote:
>> This also removes ignore of non-stream type of packets and adds
>> 'seqpacket_allow()' callback.
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> ---
>> drivers/vhost/vsock.c | 15 +++++++++++++--
>> 1 file changed, 13 insertions(+), 2 deletions(-)
> Same thing for this transporter too, maybe we can merge with the patch 
> "vhost/vsock: SEQPACKET feature bit support".
Ok, no problem
>
> Stefano
>
>> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>> index 5e78fb719602..5af141772068 100644
>> --- a/drivers/vhost/vsock.c
>> +++ b/drivers/vhost/vsock.c
>> @@ -354,8 +354,7 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
>> 		return NULL;
>> 	}
>>
>> -	if (le16_to_cpu(pkt->hdr.type) == VIRTIO_VSOCK_TYPE_STREAM)
>> -		pkt->len = le32_to_cpu(pkt->hdr.len);
>> +	pkt->len = le32_to_cpu(pkt->hdr.len);
>>
>> 	/* No payload */
>> 	if (!pkt->len)
>> @@ -398,6 +397,8 @@ static bool vhost_vsock_more_replies(struct vhost_vsock *vsock)
>> 	return val < vq->num;
>> }
>>
>> +static bool vhost_transport_seqpacket_allow(void);
>> +
>> static struct virtio_transport vhost_transport = {
>> 	.transport = {
>> 		.module                   = THIS_MODULE,
>> @@ -424,6 +425,10 @@ static struct virtio_transport vhost_transport = {
>> 		.stream_is_active         = virtio_transport_stream_is_active,
>> 		.stream_allow             = virtio_transport_stream_allow,
>>
>> +		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
>> +		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
>> +		.seqpacket_allow          = vhost_transport_seqpacket_allow,
>> +
>> 		.notify_poll_in           = virtio_transport_notify_poll_in,
>> 		.notify_poll_out          = virtio_transport_notify_poll_out,
>> 		.notify_recv_init         = virtio_transport_notify_recv_init,
>> @@ -439,8 +444,14 @@ static struct virtio_transport vhost_transport = {
>> 	},
>>
>> 	.send_pkt = vhost_transport_send_pkt,
>> +	.seqpacket_allow = false
>> };
>>
>> +static bool vhost_transport_seqpacket_allow(void)
>> +{
>> +	return vhost_transport.seqpacket_allow;
>> +}
>> +
>> static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
>> {
>> 	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
>> -- 
>> 2.25.1
>>
>
