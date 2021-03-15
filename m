Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E641F33AC80
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 08:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhCOHt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 03:49:29 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:26155 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbhCOHtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 03:49:14 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 7157676FB3;
        Mon, 15 Mar 2021 10:49:07 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1615794547;
        bh=hdov9mH/I596oKK1FxOv76nGtj8IIX5u5AGdEcbvh/8=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=BSVqNFh/ewQZNZX3jHCi1A0ogqNAde29XimFm4QEPwak+ZzMbfaLyGOtvccnLrOkn
         B9FjiVHssjxBQym5j/CWw6V+AiFpG5rR+mtoResHq7H7L2ss6zVbYXc3JHToicp16+
         21LcUyoubvSCVpBp3m5daXdx0dmyLeskAQov3J19GWRlPgPOGBtfd9kenijoiXznQS
         jHMzJ+6SnEW5PSpf1gL5X65veIFB7znux/dSdYj8ISXwjG9DqwVyZaAj3Lu2ncQ9qZ
         APlzyg8HjSits+AP/0GQt+TLIfzVFUssy+ESnuEsPR8c1kZe+k50tdqqvwAIXbnaQd
         Li///wpNhlrkw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 8562776FCE;
        Mon, 15 Mar 2021 10:49:06 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 15
 Mar 2021 10:49:05 +0300
Subject: Re: [RFC PATCH v6 12/22] virtio/vsock: fetch length for SEQPACKET
 record
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
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
 <20210307180235.3465973-1-arseny.krasnov@kaspersky.com>
 <20210312152049.iiarapjotp6eqho2@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <076cecd8-f0fb-9837-f202-db6db1c836ae@kaspersky.com>
Date:   Mon, 15 Mar 2021 10:49:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210312152049.iiarapjotp6eqho2@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 03/15/2021 07:14:43
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 162370 [Mar 15 2021]
X-KSE-AntiSpam-Info: LuaCore: 436 436 4977b9bfeabc3816a6da3614ba6703afbb88002c
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;kaspersky.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 03/15/2021 07:18:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 15.03.2021 2:57:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/03/15 05:45:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/03/15 06:48:00 #16425473
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12.03.2021 18:20, Stefano Garzarella wrote:
> On Sun, Mar 07, 2021 at 09:02:31PM +0300, Arseny Krasnov wrote:
>> This adds transport callback which tries to fetch record begin marker
> >from socket's rx queue. It is called from af_vsock.c before reading data
>> packets of record.
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> ---
>> include/linux/virtio_vsock.h            |  1 +
>> net/vmw_vsock/virtio_transport_common.c | 53 +++++++++++++++++++++++++
>> 2 files changed, 54 insertions(+)
>>
>> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>> index 466a5832d2f5..d7edcfeb4cd2 100644
>> --- a/include/linux/virtio_vsock.h
>> +++ b/include/linux/virtio_vsock.h
>> @@ -88,6 +88,7 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
>> 			       struct msghdr *msg,
>> 			       size_t len, int flags);
>>
>> +size_t virtio_transport_seqpacket_seq_get_len(struct vsock_sock *vsk);
>> int
>> virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>> 				   struct msghdr *msg,
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index 5f1e283e43f3..6fc78fec41c0 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -399,6 +399,59 @@ static inline void virtio_transport_remove_pkt(struct virtio_vsock_pkt *pkt)
>> 	virtio_transport_free_pkt(pkt);
>> }
>>
>> +static size_t virtio_transport_drop_until_seq_begin(struct virtio_vsock_sock *vvs)
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
>> +size_t virtio_transport_seqpacket_seq_get_len(struct vsock_sock *vsk)
>> +{
>> +	struct virtio_vsock_seq_hdr *seq_hdr;
>> +	struct virtio_vsock_sock *vvs;
>> +	struct virtio_vsock_pkt *pkt;
>> +	size_t bytes_dropped;
>> +
>> +	vvs = vsk->trans;
>> +
>> +	spin_lock_bh(&vvs->rx_lock);
>> +
>> +	/* Fetch all orphaned 'RW' packets and send credit update. */
>> +	bytes_dropped = virtio_transport_drop_until_seq_begin(vvs);
>> +
>> +	if (list_empty(&vvs->rx_queue))
>> +		goto out;
> What do we return to in this case?
>
> IIUC we return the len of the previous packet, should we set 
> vvs->seqpacket_state.user_read_seq_len to 0?
Yes, i think that's true
>
>> +
>> +	pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
>> +
>> +	vvs->seqpacket_state.user_read_copied = 0;
>> +
>> +	seq_hdr = (struct virtio_vsock_seq_hdr *)pkt->buf;
>> +	vvs->seqpacket_state.user_read_seq_len = 
>> le32_to_cpu(seq_hdr->msg_len);
>> +	vvs->seqpacket_state.curr_rx_msg_id = le32_to_cpu(seq_hdr->msg_id);
>> +	virtio_transport_dec_rx_pkt(vvs, pkt);
>> +	virtio_transport_remove_pkt(pkt);
>> +out:
>> +	spin_unlock_bh(&vvs->rx_lock);
>> +
>> +	if (bytes_dropped)
>> +		virtio_transport_send_credit_update(vsk);
>> +
>> +	return vvs->seqpacket_state.user_read_seq_len;
>> +}
>> +EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_seq_get_len);
>> +
>> static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>> 						 struct msghdr *msg,
>> 						 bool *msg_ready)
>> -- 
>> 2.25.1
>>
>
