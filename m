Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60133E264A
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 10:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243391AbhHFImA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 04:42:00 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:60375 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238955AbhHFIl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 04:41:59 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 7FEB6520D86;
        Fri,  6 Aug 2021 11:41:41 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1628239301;
        bh=SZgVqLaFv51M8QFWANWpdQkoc8qpvRTjEVsF2ohDDzw=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=1RFkvqt6OKvTKG1yY1IT48p1ZYTIPFCE7Lb0UCYtevheeQE4MtJ2CNw+kWZ11y1hQ
         bEKEMzrpMq1wfAt0z9x+DRakEJ+FHPVxeVPfNHZ3ZnlMgvvxrKAGQAlyAPr311+9Hp
         L8xUVtJ4iEpqzE9GXneQoLHUw2jJ5vfh+ujpVIuMdZesgE5MV4uSwr8x3vgCmMXB48
         QgNsjCEE3F0Smw/8Iw3L69bg0exlYggpTeFr7xS2mqFTZUbTGuFec+Lg/RNheVRkll
         9k49ChqJ/KG4q7iLm4pcy24shHaf3lGZa2Qhw4N1f+gNARnFU93yj/pU6vE5JLKICl
         aiElx+4gUbnBg==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 9870A520CC3;
        Fri,  6 Aug 2021 11:41:40 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Fri, 6
 Aug 2021 11:40:39 +0300
Subject: Re: [RFC PATCH v1 3/7] vhost/vsock: support MSG_EOR bit processing
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
References: <20210726163137.2589102-1-arseny.krasnov@kaspersky.com>
 <20210726163341.2589759-1-arseny.krasnov@kaspersky.com>
 <20210806072849.4by3wbdkg2bsierm@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <40a1d508-c841-23b7-58d5-f539b2d98ae1@kaspersky.com>
Date:   Fri, 6 Aug 2021 11:40:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210806072849.4by3wbdkg2bsierm@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 08/06/2021 07:22:02
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165435 [Aug 06 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 454 454 39c6e442fd417993330528e7f9d13ac1bf7fdf8c
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 08/06/2021 07:23:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 06.08.2021 4:06:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/08/06 06:19:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/08/06 07:24:00 #16988220
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 06.08.2021 10:28, Stefano Garzarella wrote:
> Caution: This is an external email. Be cautious while opening links or attachments.
>
>
>
> On Mon, Jul 26, 2021 at 07:33:38PM +0300, Arseny Krasnov wrote:
>> It works in the same way as 'end-of-message' bit: if packet has
>> 'EOM' bit, also check for 'EOR' bit.
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> ---
>> drivers/vhost/vsock.c | 12 +++++++++++-
>> 1 file changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>> index 3b55de70ac77..3e2b150f9c6f 100644
>> --- a/drivers/vhost/vsock.c
>> +++ b/drivers/vhost/vsock.c
>> @@ -115,6 +115,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>>               size_t iov_len, payload_len;
>>               int head;
>>               bool restore_msg_eom_flag = false;
>> +              bool restore_msg_eor_flag = false;
> Since we now have 2 flags to potentially restore, we could use a single
> variable (e.g. uint32_t flags_to_restore), initialized to 0.
>
> We can set all the flags we need to restore and then simply put it
> in or with the `pkt->hdr.flags` field.
>
>>               spin_lock_bh(&vsock->send_pkt_list_lock);
>>               if (list_empty(&vsock->send_pkt_list)) {
>> @@ -188,6 +189,11 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>>                       if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM) {
>>                               pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
>>                               restore_msg_eom_flag = true;
>> +
>> +                              if (le32_to_cpu(pkt->hdr.flags & VIRTIO_VSOCK_SEQ_EOR)) {
>                                                                 ^
> Here it should be `le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR`
>
>> +                                      pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>> +                                      restore_msg_eor_flag = true;
>> +                              }
>>                       }
>>               }
>>
>> @@ -224,9 +230,13 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>>                * to send it with the next available buffer.
>>                */
>>               if (pkt->off < pkt->len) {
>> -                      if (restore_msg_eom_flag)
>> +                      if (restore_msg_eom_flag) {
>>                               pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
>>
>> +                              if (restore_msg_eor_flag)
>> +                                      pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>> +                      }
>> +
> If we use a single variable, here we can simply do:
>
>                         pkt->hdr.flags |= cpu_to_le32(flags_to_restore);
>
> Stefano

Thanks, i'll prepare v2 both with spec patch. About spec: i've already sent

patch for SEQPACKET, can i prepare spec patch updating current reviewed

SEQPACKET? E.g. i'll include both EOM and EOR in one patch.


Thank You

>
