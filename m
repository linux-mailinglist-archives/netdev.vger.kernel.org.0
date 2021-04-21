Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36D4366E76
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 16:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243643AbhDUOuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 10:50:22 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:25938 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238737AbhDUOuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 10:50:21 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 0E9F075F59;
        Wed, 21 Apr 2021 17:49:46 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1619016586;
        bh=uGLbHQ8wicSj1pcDH06ehK7pFuDpyXZSs5atyDJdx+Y=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=O2MM7z6XCp8u92hXxTYLpwYZj6lJuBDwmUYS/ctZ2EU81sZRWhyskGczTegxi+Ywj
         uRmDMSDzxvwpyN2QZ2FJYBBB715d3b0sRRs0InPVrQZ50B+5f5V6buLPQu+6EJEFPJ
         BZuA8CuZC2FHpzU4pneLnUh5KAqWIDpt86VWhXz1lRGJVjLYU2TgQmAbHfkOIw1cZg
         PrnJOO7hgUWKjZywBHCkUrUOdt+I12LioucSTKLwcNhscMGCw3vMjbYa+LXoHZJrBQ
         4mQxPaTXA/mdQxvzqYBwA63kfAcXGIWb6c2Bg1wIH5UCCV8coHHNU39Xslsz0tu3xX
         gPALXIqYo3ukw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 16D3275F35;
        Wed, 21 Apr 2021 17:49:45 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 21
 Apr 2021 17:49:44 +0300
Subject: Re: [RFC PATCH v8 11/19] virtio/vsock: dequeue callback for
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
        Jeff Vander Stoep <jeffv@google.com>,
        Alexander Popov <alex.popov@linux.com>,
        kvm <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        stsp <stsp2@yandex.ru>, Krasnov Arseniy <oxffffaa@gmail.com>
References: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
 <20210413124443.3403382-1-arseny.krasnov@kaspersky.com>
 <CAGxU2F7pCfVow7B5KG4hSYjxyH2LcL3wriRvrgURTxeqzn8M9A@mail.gmail.com>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <51549e2a-f549-e860-67f4-dd06b8922c5c@kaspersky.com>
Date:   Wed, 21 Apr 2021 17:49:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAGxU2F7pCfVow7B5KG4hSYjxyH2LcL3wriRvrgURTxeqzn8M9A@mail.gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/21/2021 14:29:29
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 163270 [Apr 21 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 442 442 b985cb57763b61d2a20abb585d5d4cc10c315b09
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;kaspersky.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/21/2021 14:32:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 21.04.2021 11:31:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/04/21 13:40:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/04/21 11:31:00 #16604789
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 21.04.2021 11:56, Stefano Garzarella wrote:
> On Tue, Apr 13, 2021 at 03:44:40PM +0300, Arseny Krasnov wrote:
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
>> v7 -> v8:
>> - Things like SEQ_BEGIN, SEQ_END, 'msg_len' and 'msg_id' now removed.
>>   This callback fetches and copies RW packets to user's buffer, until
>>   last packet of message found(this packet is marked in 'flags' field
>>   of header).
>>
>> include/linux/virtio_vsock.h            |  5 ++
>> net/vmw_vsock/virtio_transport_common.c | 73 +++++++++++++++++++++++++
>> 2 files changed, 78 insertions(+)
>>
>> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>> index dc636b727179..02acf6e9ae04 100644
>> --- a/include/linux/virtio_vsock.h
>> +++ b/include/linux/virtio_vsock.h
>> @@ -80,6 +80,11 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
>>                              struct msghdr *msg,
>>                              size_t len, int flags);
>>
>> +ssize_t
>> +virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>> +                                 struct msghdr *msg,
>> +                                 int flags,
>> +                                 bool *msg_ready);
>> s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
>> s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
>>
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index 833104b71a1c..8492b8bd5df5 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -393,6 +393,67 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>>       return err;
>> }
>>
>> +static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>> +                                               struct msghdr *msg,
>> +                                               int flags,
>> +                                               bool *msg_ready)
>> +{
>> +      struct virtio_vsock_sock *vvs = vsk->trans;
>> +      struct virtio_vsock_pkt *pkt;
>> +      int err = 0;
>> +      size_t user_buf_len = msg->msg_iter.count;
>> +
>> +      *msg_ready = false;
>> +      spin_lock_bh(&vvs->rx_lock);
>> +
>> +      while (!*msg_ready && !list_empty(&vvs->rx_queue) && err >= 0) {
>> +              pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
>> +
>> +              if (le16_to_cpu(pkt->hdr.op) == VIRTIO_VSOCK_OP_RW) {
> Is this check still necessary, should they all be RW?
Ack
>
>> +                      size_t bytes_to_copy;
>> +                      size_t pkt_len;
>> +
>> +                      pkt_len = (size_t)le32_to_cpu(pkt->hdr.len);
>> +                      bytes_to_copy = min(user_buf_len, pkt_len);
>> +
> If bytes_to_copy == 0, we can avoid the next steps (release the lock try 
> to copy 0 bytes, reacquire the lock)
Ack
>
>> +                      /* sk_lock is held by caller so no one else can dequeue.
>> +                       * Unlock rx_lock since memcpy_to_msg() may sleep.
>> +                       */
>> +                      spin_unlock_bh(&vvs->rx_lock);
>> +
>> +                      if (memcpy_to_msg(msg, pkt->buf, bytes_to_copy)) {
>> +                              err = -EINVAL;
> Here we should reacquire the lock or prevent it from being released out
> of cycle.
Ack
>
>> +                              break;
>> +                      }
>> +
>> +                      spin_lock_bh(&vvs->rx_lock);
>> +
> As mentioned before, I think we could move this part into the core and 
> here always return the real dimension.
Ack
>
>> +                      /* If user sets 'MSG_TRUNC' we return real 
>> length
>> +                       * of message.
>> +                       */
>> +                      if (flags & MSG_TRUNC)
>> +                              err += pkt_len;
>> +                      else
>> +                              err += bytes_to_copy;
>> +
>> +                      user_buf_len -= bytes_to_copy;
>> +
>> +                      if (pkt->hdr.flags & VIRTIO_VSOCK_SEQ_EOR)
>                                      ^
> We should use le32_to_cpu() to read the flags.
>
Ack
>> +                              *msg_ready = true;
>> +              }
>> +
>> +              virtio_transport_dec_rx_pkt(vvs, pkt);
>> +              list_del(&pkt->list);
>> +              virtio_transport_free_pkt(pkt);
>> +      }
>> +
>> +      spin_unlock_bh(&vvs->rx_lock);
>> +
>> +      virtio_transport_send_credit_update(vsk);
>> +
>> +      return err;
>> +}
>> +
>> ssize_t
>> virtio_transport_stream_dequeue(struct vsock_sock *vsk,
>>                               struct msghdr *msg,
>> @@ -405,6 +466,18 @@ virtio_transport_stream_dequeue(struct vsock_sock *vsk,
>> }
>> EXPORT_SYMBOL_GPL(virtio_transport_stream_dequeue);
>>
>> +ssize_t
>> +virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>> +                                 struct msghdr *msg,
>> +                                 int flags, bool *msg_ready)
>> +{
>> +      if (flags & MSG_PEEK)
>> +              return -EOPNOTSUPP;
>> +
>> +      return virtio_transport_seqpacket_do_dequeue(vsk, msg, flags,
>> msg_ready);
>> +}
>> +EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
>> +
>> int
>> virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
>>                              struct msghdr *msg,
>> --
>> 2.25.1
>>
>
