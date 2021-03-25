Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2EC634964E
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 17:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhCYQDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 12:03:09 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:36091 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbhCYQC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 12:02:56 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id A6628769B2;
        Thu, 25 Mar 2021 19:02:53 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1616688173;
        bh=RO1t5ueJP/AnptFtk+OAbsY0AzvoZeOtI+4YZ3NubDY=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=HJTOrkYBapAaXySftjIQk1fiLYhzOEJMY/NTIoufvlSrbibuigVvamDmrf7z2pDKu
         E8ka1cu8jZiqr6TarzVgtfYFJ5HHZJ7gSdL3ERjVm9aqAKV3eZ9gvixY75PSCC+oiP
         KVSQzZcjIedcMfkPItV6Sic0nYwZ6FIk9KJk8opFgHakDlNse5DkQS1FPK9QcRWm/x
         YSldbTO+g1fRPGotAmSCU0viwOVv946vsg8hhzLI76JrOn6HLdaV4HwTtc64F9Tpea
         TzhaIRsG3A4rWwa0ldfZBIpS2vkOPXo7VQD1hIxDpjDpAMP3xOY5t6jCvcN3WgsKcM
         hFbDOsi3tgziQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 63990769BB;
        Thu, 25 Mar 2021 19:02:53 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 25
 Mar 2021 19:02:52 +0300
Subject: Re: [RFC PATCH v7 12/22] virtio/vsock: fetch length for SEQPACKET
 record
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
        Alexander Popov <alex.popov@linux.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
 <20210323131258.2461163-1-arseny.krasnov@kaspersky.com>
 <20210325100810.ygmg6vqb2f7rxoyx@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <c854e025-dc10-2549-9485-47992a794552@kaspersky.com>
Date:   Thu, 25 Mar 2021 19:02:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210325100810.ygmg6vqb2f7rxoyx@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
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


On 25.03.2021 13:08, Stefano Garzarella wrote:
> On Tue, Mar 23, 2021 at 04:12:55PM +0300, Arseny Krasnov wrote:
>> This adds transport callback which tries to fetch record begin marker
> >from socket's rx queue. It is called from af_vsock.c before reading data
>> packets of record.
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> ---
>> v6 -> v7:
>> 1) Now 'virtio_transport_seqpacket_seq_get_len()' returns 0, if rx
>>    queue of socket is empty. Else it returns length of current message
>>    to handle.
>> 2) If dequeue callback is called, but there is no detected length of
>>    message to dequeue, EAGAIN is returned, and outer loop restarts
>>    receiving.
>>
>> net/vmw_vsock/virtio_transport_common.c | 61 +++++++++++++++++++++++++
>> 1 file changed, 61 insertions(+)
>>
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index a8f4326e45e8..41f05034593e 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -399,6 +399,62 @@ static inline void virtio_transport_remove_pkt(struct virtio_vsock_pkt *pkt)
>> 	virtio_transport_free_pkt(pkt);
>> }
>>
>> +static size_t virtio_transport_drop_until_seq_begin(struct 
>> virtio_vsock_sock *vvs)
>> +{
>> +	struct virtio_vsock_pkt *pkt, *n;
>> +	size_t bytes_dropped = 0;
>> +
>> +	list_for_each_entry_safe(pkt, n, &vvs->rx_queue, list) {
>> +		if (le16_to_cpu(pkt->hdr.op) == VIRTIO_VSOCK_OP_SEQ_BEGIN)
>> +			break;
>> +
>> +		bytes_dropped += le32_to_cpu(pkt->hdr.len);
>> +		virtio_transport_dec_rx_pkt(vvs, pkt);
>> +		virtio_transport_remove_pkt(pkt);
>> +	}
>> +
>> +	return bytes_dropped;
>> +}
>> +
>> +static size_t virtio_transport_seqpacket_seq_get_len(struct vsock_sock *vsk)
>> +{
>> +	struct virtio_vsock_seq_hdr *seq_hdr;
>> +	struct virtio_vsock_sock *vvs;
>> +	struct virtio_vsock_pkt *pkt;
>> +	size_t bytes_dropped = 0;
>> +
>> +	vvs = vsk->trans;
>> +
>> +	spin_lock_bh(&vvs->rx_lock);
>> +
>> +	/* Have some record to process, return it's length. */
>> +	if (vvs->seq_state.user_read_seq_len)
>> +		goto out;
>> +
>> +	/* Fetch all orphaned 'RW' packets and send credit update. */
>> +	bytes_dropped = virtio_transport_drop_until_seq_begin(vvs);
>> +
>> +	if (list_empty(&vvs->rx_queue))
>> +		goto out;
>> +
>> +	pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
>> +
>> +	vvs->seq_state.user_read_copied = 0;
>> +
>> +	seq_hdr = (struct virtio_vsock_seq_hdr *)pkt->buf;
>> +	vvs->seq_state.user_read_seq_len = le32_to_cpu(seq_hdr->msg_len);
>> +	vvs->seq_state.curr_rx_msg_id = le32_to_cpu(seq_hdr->msg_id);
>> +	virtio_transport_dec_rx_pkt(vvs, pkt);
>> +	virtio_transport_remove_pkt(pkt);
>> +out:
>> +	spin_unlock_bh(&vvs->rx_lock);
>> +
>> +	if (bytes_dropped)
>> +		virtio_transport_send_credit_update(vsk);
>> +
>> +	return vvs->seq_state.user_read_seq_len;
>> +}
>> +
>> static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>> 						 struct msghdr *msg,
>> 						 bool *msg_ready)
>> @@ -522,6 +578,11 @@ virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>> 	if (flags & MSG_PEEK)
>> 		return -EOPNOTSUPP;
>>
>> +	*msg_len = virtio_transport_seqpacket_seq_get_len(vsk);
>> +
>> +	if (*msg_len == 0)
>> +		return -EAGAIN;
>> +
> Okay, I see now, I think you can move this patch before the previous one 
> or merge them in a single patch, it is better to review and to bisect.
>
> As mentioned, I think we can return msg_len if 
> virtio_transport_seqpacket_do_dequeue() does not fail, otherwise the 
> error.
>
> I mean something like this:
>
> static ssize_t virtio_transport_seqpacket_do_dequeue(...)
> {
> 	size_t msg_len;
> 	ssize_t ret;
>
> 	msg_len = virtio_transport_seqpacket_seq_get_len(vsk);
> 	if (msg_len == 0)
> 		return -EAGAIN;
>
> 	ret = virtio_transport_seqpacket_do_dequeue(vsk, msg, msg_ready);
> 	if (ret < 0)
> 		return ret;
>
> 	return msg_len;
> }
Ack
>
>> 	return virtio_transport_seqpacket_do_dequeue(vsk, msg, msg_ready);
>> }
>> EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
>> -- 2.25.1
>>
>
