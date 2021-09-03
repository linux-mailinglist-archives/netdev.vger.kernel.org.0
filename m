Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67193FFFDA
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 14:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349433AbhICMf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 08:35:56 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:44080 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235315AbhICMfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 08:35:55 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id D5DB1521483;
        Fri,  3 Sep 2021 15:34:53 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1630672493;
        bh=AqGvFSe/3ZONPZ9XOKbWfQsg2sv8vpiLlRPPTSvDFNc=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=DOuMGCsu6VuoxTZqQ5lu6KJ7czZz+ke+LfnHYjkj6vh9LQiRmVvPqdk96bYqpRpL1
         xrTH9OjeC1prfZoHJ4TiLeNu/NQRmM+sOCi2jceMQGB+Wfp1urWK3JmYWTP/L1rkvP
         pLKaSVpAstLn4TysHEDFK+mxkQ25ejK1zkRb9X358RnlltCJClQ77JMHYbDu0BoLZS
         mb69T1cxT2UodUY4hbpUUSj+mRCPYCthI5fDhkDv9o0u6vSGiJ+Qn0gWehNLZHAj4P
         Tsu8i+D5EHam3j+j0jO/9AHGCw8a3aobgDEnWZDjNsPC/Ad20CH/ETYI8/okATK134
         C59QrTMvOTqMQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 746205210F3;
        Fri,  3 Sep 2021 15:34:53 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Fri, 3
 Sep 2021 15:34:52 +0300
Subject: Re: [PATCH net-next v4 3/6] vhost/vsock: support MSG_EOR bit
 processing
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210903061353.3187150-1-arseny.krasnov@kaspersky.com>
 <20210903061541.3187840-1-arseny.krasnov@kaspersky.com>
 <20210903065539.nb2hk4sszdtlqfmb@steredhat>
 <20210903121402.vfdaxznxwepezacf@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <87f2f93b-e337-9392-f87d-9a357cd21ce0@kaspersky.com>
Date:   Fri, 3 Sep 2021 15:34:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210903121402.vfdaxznxwepezacf@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 09/03/2021 12:23:31
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165956 [Sep 03 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 461 461 c95454ca24f64484bdf56c7842a96dd24416624e
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 09/03/2021 12:25:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 03.09.2021 6:49:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/09/03 11:02:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/09/03 06:49:00 #17152626
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 03.09.2021 15:14, Stefano Garzarella wrote:
> On Fri, Sep 03, 2021 at 08:55:39AM +0200, Stefano Garzarella wrote:
>> On Fri, Sep 03, 2021 at 09:15:38AM +0300, Arseny Krasnov wrote:
>>> 'MSG_EOR' handling has similar logic as 'MSG_EOM' - if bit present
>>> in packet's header, reset it to 0. Then restore it back if packet
>>> processing wasn't completed. Instead of bool variable for each
>>> flag, bit mask variable was added: it has logical OR of 'MSG_EOR'
>>> and 'MSG_EOM' if needed, to restore flags, this variable is ORed
>>> with flags field of packet.
>>>
>>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>>> ---
>>> drivers/vhost/vsock.c | 22 +++++++++++++---------
>>> 1 file changed, 13 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>>> index feaf650affbe..93e8d635e18f 100644
>>> --- a/drivers/vhost/vsock.c
>>> +++ b/drivers/vhost/vsock.c
>>> @@ -114,7 +114,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>>> 		size_t nbytes;
>>> 		size_t iov_len, payload_len;
>>> 		int head;
>>> -		bool restore_flag = false;
>>> +		u32 flags_to_restore = 0;
>>>
>>> 		spin_lock_bh(&vsock->send_pkt_list_lock);
>>> 		if (list_empty(&vsock->send_pkt_list)) {
>>> @@ -179,15 +179,20 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>>> 			 * created dynamically and are initialized with header
>>> 			 * of current packet(except length). But in case of
>>> 			 * SOCK_SEQPACKET, we also must clear message delimeter
>>> -			 * bit(VIRTIO_VSOCK_SEQ_EOM). Otherwise, instead of one
>>> -			 * packet with delimeter(which marks end of message),
>>> -			 * there will be sequence of packets with delimeter
>>> -			 * bit set. After initialized header will be copied to
>>> -			 * rx buffer, this bit will be restored.
>>> +			 * bit (VIRTIO_VSOCK_SEQ_EOM) and MSG_EOR bit
>>> +			 * (VIRTIO_VSOCK_SEQ_EOR) if set. Otherwise,
>>> +			 * there will be sequence of packets with these
>>> +			 * bits set. After initialized header will be copied to
>>> +			 * rx buffer, these required bits will be restored.
>>> 			 */
>>> 			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM) {
>>> 				pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
>>> -				restore_flag = true;
>>> +				flags_to_restore |= VIRTIO_VSOCK_SEQ_EOM;
>>> +
>>> +				if (le32_to_cpu(pkt->hdr.flags & VIRTIO_VSOCK_SEQ_EOR)) {
>                                                                ^
> Ooops, le32_to_cpu() should close before bitwise and operator.
> I missed this, but kernel test robot discovered :-)
Sorry ><
>
>>> +					pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>>> +					flags_to_restore |= VIRTIO_VSOCK_SEQ_EOR;
>>> +				}
>>> 			}
>>> 		}
>>>
>>> @@ -224,8 +229,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>>> 		 * to send it with the next available buffer.
>>> 		 */
>>> 		if (pkt->off < pkt->len) {
>>> -			if (restore_flag)
>>> -				pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
>>> +			pkt->hdr.flags |= cpu_to_le32(flags_to_restore);
>>>
>>> 			/* We are queueing the same virtio_vsock_pkt to handle
>>> 			 * the remaining bytes, and we want to deliver it
>>> -- 2.25.1
>>>
>> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> NACK
>
> Please resend fixing the issue.
Done, v5 is sent
>
> Stefano
>
>
