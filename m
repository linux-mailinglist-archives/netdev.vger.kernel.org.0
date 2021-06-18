Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66C23ACE3E
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 17:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbhFRPHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 11:07:05 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:20032 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhFRPGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 11:06:51 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 1211B520D88;
        Fri, 18 Jun 2021 18:04:40 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1624028680;
        bh=g/rPtPEzU0G4B9BPMKh1kLMhW/DS69qDieLK9SruPSE=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=mDrQG1BAiDeBNY2KYTn1J5P2+1K50oXMtG28MZQn+kMNCF0WUbXHzql2t2VzNJaVN
         3EPzBFIz3JEGFwirGBxKUdb1s9zmT0sPWNYwfh1lD83kKMkREZ/6+CYtTbGweKDxe+
         6760zJ4CDlBFLBAF12NdUEB48cnywzpiiXXdIOB4zTR2PFqGkkurBMuR4E8tM8BDGa
         POpzi8jnNzlxm3VVonellRgyhwnKyBUStocPcQqpaavHRilQmUx1k8cUGoHihEgZme
         2aoOWdEAr7jTMJPGA6AnXmcNfTwhxnhKRQDxnBDcwqn6H8+bY0pY/3koywN55BJImo
         1fZXGMhW8ruIA==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 6ECD9520D8A;
        Fri, 18 Jun 2021 18:04:39 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Fri, 18
 Jun 2021 18:04:38 +0300
Subject: Re: [PATCH v11 11/18] virtio/vsock: dequeue callback for
 SOCK_SEQPACKET
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
 <20210611111241.3652274-1-arseny.krasnov@kaspersky.com>
 <20210618134423.mksgnbmchmow4sgh@steredhat.lan>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <bb323125-f802-1d16-7530-6e4f4abb00a6@kaspersky.com>
Date:   Fri, 18 Jun 2021 18:04:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210618134423.mksgnbmchmow4sgh@steredhat.lan>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/18/2021 14:47:59
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164482 [Jun 18 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;kaspersky.com:7.1.1;lore.kernel.org:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/18/2021 14:50:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 18.06.2021 12:17:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/06/18 13:10:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/06/18 12:17:00 #16756757
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 18.06.2021 16:44, Stefano Garzarella wrote:
> Hi Arseny,
> the series looks great, I have just a question below about 
> seqpacket_dequeue.
>
> I also sent a couple a simple fixes, it would be great if you can review 
> them: 
> https://lore.kernel.org/netdev/20210618133526.300347-1-sgarzare@redhat.com/
>
>
> On Fri, Jun 11, 2021 at 02:12:38PM +0300, Arseny Krasnov wrote:
>> Callback fetches RW packets from rx queue of socket until whole record
>> is copied(if user's buffer is full, user is not woken up). This is done
>> to not stall sender, because if we wake up user and it leaves syscall,
>> nobody will send credit update for rest of record, and sender will wait
>> for next enter of read syscall at receiver's side. So if user buffer is
>> full, we just send credit update and drop data.
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> ---
>> v10 -> v11:
>> 1) 'msg_count' field added to count current number of EORs.
>> 2) 'msg_ready' argument removed from callback.
>> 3) If 'memcpy_to_msg()' failed during copy loop, there will be
>>    no next attempts to copy data, rest of record will be freed.
>>
>> include/linux/virtio_vsock.h            |  5 ++
>> net/vmw_vsock/virtio_transport_common.c | 84 +++++++++++++++++++++++++
>> 2 files changed, 89 insertions(+)
>>
>> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>> index dc636b727179..1d9a302cb91d 100644
>> --- a/include/linux/virtio_vsock.h
>> +++ b/include/linux/virtio_vsock.h
>> @@ -36,6 +36,7 @@ struct virtio_vsock_sock {
>> 	u32 rx_bytes;
>> 	u32 buf_alloc;
>> 	struct list_head rx_queue;
>> +	u32 msg_count;
>> };
>>
>> struct virtio_vsock_pkt {
>> @@ -80,6 +81,10 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
>> 			       struct msghdr *msg,
>> 			       size_t len, int flags);
>>
>> +ssize_t
>> +virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>> +				   struct msghdr *msg,
>> +				   int flags);
>> s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
>> s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
>>
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index ad0d34d41444..1e1df19ec164 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -393,6 +393,78 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>> 	return err;
>> }
>>
>> +static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>> +						 struct msghdr *msg,
>> +						 int flags)
>> +{
>> +	struct virtio_vsock_sock *vvs = vsk->trans;
>> +	struct virtio_vsock_pkt *pkt;
>> +	int dequeued_len = 0;
>> +	size_t user_buf_len = msg_data_left(msg);
>> +	bool copy_failed = false;
>> +	bool msg_ready = false;
>> +
>> +	spin_lock_bh(&vvs->rx_lock);
>> +
>> +	if (vvs->msg_count == 0) {
>> +		spin_unlock_bh(&vvs->rx_lock);
>> +		return 0;
>> +	}
>> +
>> +	while (!msg_ready) {
>> +		pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
>> +
>> +		if (!copy_failed) {
>> +			size_t pkt_len;
>> +			size_t bytes_to_copy;
>> +
>> +			pkt_len = (size_t)le32_to_cpu(pkt->hdr.len);
>> +			bytes_to_copy = min(user_buf_len, pkt_len);
>> +
>> +			if (bytes_to_copy) {
>> +				int err;
>> +
>> +				/* sk_lock is held by caller so no one else can dequeue.
>> +				 * Unlock rx_lock since memcpy_to_msg() may sleep.
>> +				 */
>> +				spin_unlock_bh(&vvs->rx_lock);
>> +
>> +				err = memcpy_to_msg(msg, pkt->buf, bytes_to_copy);
>> +				if (err) {
>> +					/* Copy of message failed, set flag to skip
>> +					 * copy path for rest of fragments. Rest of
>> +					 * fragments will be freed without copy.
>> +					 */
>> +					copy_failed = true;
>> +					dequeued_len = err;
> If we fail to copy the message we will discard the entire packet.
> Is it acceptable for the user point of view, or we should leave the 
> packet in the queue and the user can retry, maybe with a different 
> buffer?
>
> Then we can remove the packets only when we successfully copied all the 
> fragments.
>
> I'm not sure make sense, maybe better to check also other 
> implementations :-)
>
> Thanks,
> Stefano

Understand, i'll check it on weekend, anyway I think it is

not critical for implementation.


I have another question: may be it is useful to research for

approach where packets are not queued until whole message

is received, but copied to user's buffer thus freeing memory.

(like previous implementation, of course with solution of problem

where part of message still in queue, while reader was woken

by timeout or signal).

I think it is better, because  in current version, sender may set

'peer_alloc_buf' to  for example 1MB, so at receiver we get

1MB of 'kmalloc()' memory allocated, while having user's buffer

to copy data there or drop it(if user's buffer is full). This way

won't change spec(e.g. no message id or SEQ_BEGIN will be added).


What do You think?

>
>> +				} else {
>> +					user_buf_len -= bytes_to_copy;
>> +				}
>> +
>> +				spin_lock_bh(&vvs->rx_lock);
>> +			}
>> +
>> +			if (dequeued_len >= 0)
>> +				dequeued_len += pkt_len;
>> +		}
>> +
>> +		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR) {
>> +			msg_ready = true;
>> +			vvs->msg_count--;
>> +		}
>> +
>> +		virtio_transport_dec_rx_pkt(vvs, pkt);
>> +		list_del(&pkt->list);
>> +		virtio_transport_free_pkt(pkt);
>> +	}
>> +
>> +	spin_unlock_bh(&vvs->rx_lock);
>> +
>> +	virtio_transport_send_credit_update(vsk);
>> +
>> +	return dequeued_len;
>> +}
>> +
>> ssize_t
>> virtio_transport_stream_dequeue(struct vsock_sock *vsk,
>> 				struct msghdr *msg,
>> @@ -405,6 +477,18 @@ virtio_transport_stream_dequeue(struct vsock_sock *vsk,
>> }
>> EXPORT_SYMBOL_GPL(virtio_transport_stream_dequeue);
>>
>> +ssize_t
>> +virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>> +				   struct msghdr *msg,
>> +				   int flags)
>> +{
>> +	if (flags & MSG_PEEK)
>> +		return -EOPNOTSUPP;
>> +
>> +	return virtio_transport_seqpacket_do_dequeue(vsk, msg, flags);
>> +}
>> +EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
>> +
>> int
>> virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
>> 			       struct msghdr *msg,
>> -- 
>> 2.25.1
>>
>
