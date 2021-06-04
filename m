Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC9D39B99B
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 15:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhFDNO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 09:14:57 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:33291 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbhFDNOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 09:14:55 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id ED1BB761E2;
        Fri,  4 Jun 2021 16:13:07 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1622812388;
        bh=EMYFH3ndXdjZGdotsLhxDD2V/SzrFGHmfG9CNeLWEIw=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=bNlpvX4unnJouviT8QEnul2T6XsZLRNiN5rVWYUVj6gx4wQilcXZ06JYm+di2pTri
         BLrflv27rdzPXoFhGxkW+i4o47ni5N3/ZHDFY/xC/aTS5eQ8nugf+JpnB6PYlfSGuT
         w8isPr7e0UAEcqLJds6yzqgfZ14YW4/a1sKlMQTRUZq3WHNv4XhUQ3ISM7ntQf+FrN
         1Z1wkgquOn0WtqX41jRo1L2rAsI1hMNsj6BrualK0GqjA+oeCyDm3axfkVYW6XcKD/
         piJNqlAPn+d0uZRLUYLguYNedjDSPHxjifG9Jj6dJ52nCr4n4roX7+JP85j4hO0wGh
         pfwOp+5dovnJw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id B50D2761DB;
        Fri,  4 Jun 2021 16:13:07 +0300 (MSK)
Received: from [10.16.171.77] (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Fri, 4
 Jun 2021 16:13:07 +0300
Subject: Re: [PATCH v10 15/18] vhost/vsock: support SEQPACKET for transport
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
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
 <20210520191916.1272540-1-arseny.krasnov@kaspersky.com>
 <20210603153459.4qncp25nssuby4vp@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <250f3836-7fb4-8c05-bfa1-e11fd37e6abe@kaspersky.com>
Date:   Fri, 4 Jun 2021 16:13:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210603153459.4qncp25nssuby4vp@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/04/2021 12:54:45
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164124 [Jun 04 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/04/2021 12:57:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 04.06.2021 12:18:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/06/04 11:48:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/06/04 08:54:00 #16699202
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 03.06.2021 18:34, Stefano Garzarella wrote:
> On Thu, May 20, 2021 at 10:19:13PM +0300, Arseny Krasnov wrote:
>
> Please describe better the changes included in this patch in the first 
> part of the commit message.
>
>> As vhost places data in buffers of guest's rx queue, keep SEQ_EOR
>> bit set only when last piece of data is copied. Otherwise we get
>> sequence packets for one socket in guest's rx queue with SEQ_EOR bit
>> set. Also remove ignore of non-stream type of packets, handle SEQPACKET
>> feature bit.
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> ---
>> v9 -> v10:
>> 1) Move 'restore_flag' handling to 'payload_len' calculation
>>    block.
>>
>> drivers/vhost/vsock.c | 44 +++++++++++++++++++++++++++++++++++++++----
>> 1 file changed, 40 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>> index 5e78fb719602..63d15beaad05 100644
>> --- a/drivers/vhost/vsock.c
>> +++ b/drivers/vhost/vsock.c
>> @@ -31,7 +31,8 @@
>>
>> enum {
>> 	VHOST_VSOCK_FEATURES = VHOST_FEATURES |
>> -			       (1ULL << VIRTIO_F_ACCESS_PLATFORM)
>> +			       (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
>> +			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET)
>> };
>>
>> enum {
>> @@ -56,6 +57,7 @@ struct vhost_vsock {
>> 	atomic_t queued_replies;
>>
>> 	u32 guest_cid;
>> +	bool seqpacket_allow;
>> };
>>
>> static u32 vhost_transport_get_local_cid(void)
>> @@ -112,6 +114,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>> 		size_t nbytes;
>> 		size_t iov_len, payload_len;
>> 		int head;
>> +		bool restore_flag = false;
>>
>> 		spin_lock_bh(&vsock->send_pkt_list_lock);
>> 		if (list_empty(&vsock->send_pkt_list)) {
>> @@ -168,9 +171,15 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>> 		/* If the packet is greater than the space available in the
>> 		 * buffer, we split it using multiple buffers.
>> 		 */
>> -		if (payload_len > iov_len - sizeof(pkt->hdr))
>> +		if (payload_len > iov_len - sizeof(pkt->hdr)) {
>> 			payload_len = iov_len - sizeof(pkt->hdr);
>>
> Please, add a comment here to explain why we need this.
>
>> +			if (le32_to_cpu(pkt->hdr.flags) & 
>> VIRTIO_VSOCK_SEQ_EOR) {
>> +				pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>> +				restore_flag = true;
>> +			}
>> +		}
>> +
>> 		/* Set the correct length in the header */
>> 		pkt->hdr.len = cpu_to_le32(payload_len);
>>
>> @@ -181,6 +190,9 @@ vhost_transport_do_send_pkt(struct vhost_vsock 
>> *vsock,
>> 			break;
>> 		}
>>
>> +		if (restore_flag)
>> +			pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>> +
> Maybe we can restore the flag only if we are queueing again the same 
> packet, I mean in the `if (pkt->off < pkt->len) {` branch below.
>
> What do you think?
Ack
>
>> 		nbytes = copy_to_iter(pkt->buf + pkt->off, payload_len,
>> 				      &iov_iter);
>> 		if (nbytes != payload_len) {
>> @@ -354,8 +366,7 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
>> 		return NULL;
>> 	}
>>
>> -	if (le16_to_cpu(pkt->hdr.type) == VIRTIO_VSOCK_TYPE_STREAM)
>> -		pkt->len = le32_to_cpu(pkt->hdr.len);
>> +	pkt->len = le32_to_cpu(pkt->hdr.len);
>>
>> 	/* No payload */
>> 	if (!pkt->len)
>> @@ -398,6 +409,8 @@ static bool vhost_vsock_more_replies(struct 
>> vhost_vsock *vsock)
>> 	return val < vq->num;
>> }
>>
>> +static bool vhost_transport_seqpacket_allow(u32 remote_cid);
>> +
>> static struct virtio_transport vhost_transport = {
>> 	.transport = {
>> 		.module                   = THIS_MODULE,
>> @@ -424,6 +437,10 @@ static struct virtio_transport vhost_transport = {
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
>> @@ -441,6 +458,22 @@ static struct virtio_transport vhost_transport = {
>> 	.send_pkt = vhost_transport_send_pkt,
>> };
>>
>> +static bool vhost_transport_seqpacket_allow(u32 remote_cid)
>> +{
>> +	struct vhost_vsock *vsock;
>> +	bool seqpacket_allow = false;
>> +
>> +	rcu_read_lock();
>> +	vsock = vhost_vsock_get(remote_cid);
>> +
>> +	if (vsock)
>> +		seqpacket_allow = vsock->seqpacket_allow;
>> +
>> +	rcu_read_unlock();
>> +
>> +	return seqpacket_allow;
>> +}
>> +
>> static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
>> {
>> 	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
>> @@ -785,6 +818,9 @@ static int vhost_vsock_set_features(struct vhost_vsock *vsock, u64 features)
>> 			goto err;
>> 	}
>>
>> +	if (features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))
>> +		vsock->seqpacket_allow = true;
>> +
>> 	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
>> 		vq = &vsock->vqs[i];
>> 		mutex_lock(&vq->mutex);
>> -- 
>> 2.25.1
>>
>
