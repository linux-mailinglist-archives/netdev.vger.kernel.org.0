Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED82D39DD7A
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 15:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbhFGNUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 09:20:35 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:37168 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbhFGNUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 09:20:34 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 5450F520D47;
        Mon,  7 Jun 2021 16:18:41 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1623071921;
        bh=Se0a0uUlPD1PKUYObm77dFuPaLpgSvA69dzcoosdhPo=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=u7IvNKFCbAqywtBqaUDFyOOg3avBdVzgxUM5Sbb25sD+ETCPgf+9y/NsftfG1flmV
         s6z58xHyq3fhCjPCSc5CXAtCd1TiaiMd1TyLycpkTgIAgNp/HkQPa3eYoZcxnA2a6J
         ldPhOKCm8pOO82vMFlUGk5C5sOjEc9FUrZFHqKa/Ha4CJLgKCk4+G8Mw4yh4Cn+Xb8
         uQGqE8aL7q3qCzF0CEMRjCuThBKbDQEbyYAJsQjGg5RO1LSjBB1aeMkLVrh0yPARkI
         oIu9tOADiY0OoLuelA9gugBbF4az6ARlIO89EGSs2F7ha3egNjxelaXHaberAci5he
         hMzv53GQzlWrw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 66A9E520D3F;
        Mon,  7 Jun 2021 16:18:40 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Mon, 7
 Jun 2021 16:18:39 +0300
Subject: Re: [PATCH v10 11/18] virtio/vsock: dequeue callback for
 SOCK_SEQPACKET
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
 <20210520191801.1272027-1-arseny.krasnov@kaspersky.com>
 <20210603144513.ryjzauq7abnjogu3@steredhat>
 <6b833ccf-ea93-db6a-4743-463ac1cfe817@kaspersky.com>
 <20210604150324.winiikx5h3p6gsyy@steredhat>
 <a81ae3cb-439f-7621-4ae6-bccd2c25b7e4@kaspersky.com>
 <20210607110421.wkx4dj7wipwsqztj@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <8e2eb802-7c5d-70b0-82b5-ec8de4fdc046@kaspersky.com>
Date:   Mon, 7 Jun 2021 16:18:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210607110421.wkx4dj7wipwsqztj@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/07/2021 13:00:36
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164158 [Jun 07 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_phishing_log_reg_60_70}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: kaspersky.com:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/07/2021 13:03:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 07.06.2021 12:28:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/06/07 12:02:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/06/07 11:51:00 #16681181
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 07.06.2021 14:04, Stefano Garzarella wrote:
> On Fri, Jun 04, 2021 at 09:03:26PM +0300, Arseny Krasnov wrote:
>> On 04.06.2021 18:03, Stefano Garzarella wrote:
>>> On Fri, Jun 04, 2021 at 04:12:23PM +0300, Arseny Krasnov wrote:
>>>> On 03.06.2021 17:45, Stefano Garzarella wrote:
>>>>> On Thu, May 20, 2021 at 10:17:58PM +0300, Arseny Krasnov wrote:
>>>>>> Callback fetches RW packets from rx queue of socket until whole record
>>>>>> is copied(if user's buffer is full, user is not woken up). This is done
>>>>>> to not stall sender, because if we wake up user and it leaves syscall,
>>>>>> nobody will send credit update for rest of record, and sender will wait
>>>>>> for next enter of read syscall at receiver's side. So if user buffer is
>>>>>> full, we just send credit update and drop data.
>>>>>>
>>>>>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>>>>>> ---
>>>>>> v9 -> v10:
>>>>>> 1) Number of dequeued bytes incremented even in case when
>>>>>>    user's buffer is full.
>>>>>> 2) Use 'msg_data_left()' instead of direct access to 'msg_hdr'.
>>>>>> 3) Rename variable 'err' to 'dequeued_len', in case of error
>>>>>>    it has negative value.
>>>>>>
>>>>>> include/linux/virtio_vsock.h            |  5 ++
>>>>>> net/vmw_vsock/virtio_transport_common.c | 65 +++++++++++++++++++++++++
>>>>>> 2 files changed, 70 insertions(+)
>>>>>>
>>>>>> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>>>>>> index dc636b727179..02acf6e9ae04 100644
>>>>>> --- a/include/linux/virtio_vsock.h
>>>>>> +++ b/include/linux/virtio_vsock.h
>>>>>> @@ -80,6 +80,11 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
>>>>>> 			       struct msghdr *msg,
>>>>>> 			       size_t len, int flags);
>>>>>>
>>>>>> +ssize_t
>>>>>> +virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>>>>>> +				   struct msghdr *msg,
>>>>>> +				   int flags,
>>>>>> +				   bool *msg_ready);
>>>>>> s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
>>>>>> s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
>>>>>>
>>>>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>>>>> index ad0d34d41444..61349b2ea7fe 100644
>>>>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>>>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>>>>> @@ -393,6 +393,59 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>>>>>> 	return err;
>>>>>> }
>>>>>>
>>>>>> +static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>>>>>> +						 struct msghdr *msg,
>>>>>> +						 int flags,
>>>>>> +						 bool *msg_ready)
>>>>>> +{
>>>>>> +	struct virtio_vsock_sock *vvs = vsk->trans;
>>>>>> +	struct virtio_vsock_pkt *pkt;
>>>>>> +	int dequeued_len = 0;
>>>>>> +	size_t user_buf_len = msg_data_left(msg);
>>>>>> +
>>>>>> +	*msg_ready = false;
>>>>>> +	spin_lock_bh(&vvs->rx_lock);
>>>>>> +
>>>>>> +	while (!*msg_ready && !list_empty(&vvs->rx_queue) && dequeued_len >= 0) {
>>>>> I'
>>>>>
>>>>>> +		size_t bytes_to_copy;
>>>>>> +		size_t pkt_len;
>>>>>> +
>>>>>> +		pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
>>>>>> +		pkt_len = (size_t)le32_to_cpu(pkt->hdr.len);
>>>>>> +		bytes_to_copy = min(user_buf_len, pkt_len);
>>>>>> +
>>>>>> +		if (bytes_to_copy) {
>>>>>> +			/* sk_lock is held by caller so no one else can dequeue.
>>>>>> +			 * Unlock rx_lock since memcpy_to_msg() may sleep.
>>>>>> +			 */
>>>>>> +			spin_unlock_bh(&vvs->rx_lock);
>>>>>> +
>>>>>> +			if (memcpy_to_msg(msg, pkt->buf, bytes_to_copy))
>>>>>> +				dequeued_len = -EINVAL;
>>>>> I think here is better to return the error returned by memcpy_to_msg(),
>>>>> as we do in the other place where we use memcpy_to_msg().
>>>>>
>>>>> I mean something like this:
>>>>> 			err = memcpy_to_msgmsg, pkt->buf, bytes_to_copy);
>>>>> 			if (err)
>>>>> 				dequeued_len = err;
>>>> Ack
>>>>>> +			else
>>>>>> +				user_buf_len -= bytes_to_copy;
>>>>>> +
>>>>>> +			spin_lock_bh(&vvs->rx_lock);
>>>>>> +		}
>>>>>> +
>>>>> Maybe here we can simply break the cycle if we have an error:
>>>>> 		if (dequeued_len < 0)
>>>>> 			break;
>>>>>
>>>>> Or we can refactor a bit, simplifying the while() condition and also the
>>>>> code in this way (not tested):
>>>>>
>>>>> 	while (!*msg_ready && !list_empty(&vvs->rx_queue)) {
>>>>> 		...
>>>>>
>>>>> 		if (bytes_to_copy) {
>>>>> 			int err;
>>>>>
>>>>> 			/* ...
>>>>> 			*/
>>>>> 			spin_unlock_bh(&vvs->rx_lock);
>>>>> 			err = memcpy_to_msgmsg, pkt->buf, bytes_to_copy);
>>>>> 			if (err) {
>>>>> 				dequeued_len = err;
>>>>> 				goto out;
>>>>> 			}
>>>>> 			spin_lock_bh(&vvs->rx_lock);
>>>>>
>>>>> 			user_buf_len -= bytes_to_copy;
>>>>> 		}
>>>>>
>>>>> 		dequeued_len += pkt_len;
>>>>>
>>>>> 		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)
>>>>> 			*msg_ready = true;
>>>>>
>>>>> 		virtio_transport_dec_rx_pkt(vvs, pkt);
>>>>> 		list_del(&pkt->list);
>>>>> 		virtio_transport_free_pkt(pkt);
>>>>> 	}
>>>>>
>>>>> out:
>>>>> 	spin_unlock_bh(&vvs->rx_lock);
>>>>>
>>>>> 	virtio_transport_send_credit_update(vsk);
>>>>>
>>>>> 	return dequeued_len;
>>>>> }
>>>> I think we can't do 'goto out' or break, because in case of error, 
>>>> we still need
>>>> to free packet.
>>> Didn't we have code that remove packets from a previous message?
>>> I don't see it anymore.
>>>
>>> For example if we have 10 packets queued for a message (the 10th 
>>> packet
>>> has the EOR flag) and the memcpy_to_msg() fails on the 2nd packet, with
>>> you proposal we are freeing only the first 2 packets, the rest is there
>>> and should be freed when reading the next message, but I don't see that
>>> code.
>>>
>>> The same can happen if the recvmsg syscall is interrupted. In that case
>>> we report that nothing was copied, but we freed the first N packets, so
>>> they are lost but the other packets are still in the queue.
>>>
>>> Please check also the patch where we implemented
>>> __vsock_seqpacket_recvmsg().
>>>
>>> I thinks we should free packets only when we are sure we copied them to
>>> the user space.
>> Hm, yes, this is problem. To solve it i can restore previous approach
>> with seqbegin/seqend. In that case i can detect unfinished record and
>> drop it's packets. Seems seqbegin will be a bit like 
>> VIRTIO_VSOCK_SEQ_EOR in flags
>> field of header(e.g. VIRTIO_VSOCK_SEQ_BEGIN). Message id and length are 
>> unneeded,
>> as channel considedered lossless. What do You think?
>>
> I think VIRTIO_VSOCK_SEQ_BEGIN is redundant, using only EOR should be 
> fine.
>
> When we receive EOR we know that this is the last packet on this message 
> and the next packet will be the first of a new message.
>
> What we should do is check that we have all the fragments of a packet 
> and return them all together, otherwise we have to say we have nothing.
>
> For example as we process packets from the vitqueue and queue them in 
> the rx_queue we could use a counter of how many EORs are in the 
> rx_queue, which we decrease in virtio_transport_seqpacket_do_dequeue() 
> when we copied all the fragments.
>
> If the counter is 0, we don't remove anything from the queue and 
> virtio_transport_seqpacket_do_dequeue() returns 0.
>
> So .seqpacket_dequeue should return 0 if there is not at least one 
> complete message, or return the entire message. A partial message should 
> never return.
>
> What do you think?

I like it, i've implemented this approach in some early pre v1 versions.

But in this case, credit update logic will be changed - in current implementation

(both seqpacket and stream) credit update reply is sent when data is copied

to user's buffer(e.g. we copy data somewhere, free packet and ready to process

new packet). But if we don't touch user's buffer and keeping incoming packet in rx queue

until whole record is ready, when to send credit update?


Thank You

>
>
> Maybe we should start using skbuffs for seqpackets as well, but that 
> might take some time, so that might be okay for now.
>
> Thanks,
> Stefano
>
>
