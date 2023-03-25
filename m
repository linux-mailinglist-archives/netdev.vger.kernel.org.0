Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 195D16C9117
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 23:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjCYWGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 18:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCYWGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 18:06:10 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F99555A8;
        Sat, 25 Mar 2023 15:06:07 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 251A85FD02;
        Sun, 26 Mar 2023 01:06:04 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679781964;
        bh=COjmnQ0Wk0XlisNwkVt0MBAIKEpqB54cYItuwSog830=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=XttBPZvUI3OKLhyW5Whx9oC7CJnSp4iGn5v8WzQkII1U6QqxaklfugRIqfcK5qnKU
         BZ0mrm6kcGviWYHpjb0XX45rSlOm8Bq8BzQn+PLVf+K/lEaktq98E5g+yZDJ8mVr2r
         9GcEDNp3GltJqEXHZOLPQs3Z6+IKHZrBVjjoY0pdS1pBAkCJyhCDIfkW5+nOw+Eub3
         ysx+JZTkcNpdjww7MvxpKPn5OwI9swUS9lc/Np7gINSE5p0isBXRAz8/fpQxtqQvX8
         6c6zsb7ND4rF2s8PTNK6T4C3o6qGM6NV22UK7iXNEJk+4d2/Ydz9mVNYZK/FkwepzZ
         7/D3SP9KcroRA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun, 26 Mar 2023 01:05:58 +0300 (MSK)
Message-ID: <b0d15942-65ba-3a32-ba8d-fed64332d8f6@sberdevices.ru>
Date:   Sun, 26 Mar 2023 01:02:43 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>,
        <avkrasnov@sberdevices.ru>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
Subject: [PATCH net-next v5 0/2] allocate multiple skbuffs on tx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/25 18:14:00 #21009230
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds small optimization for tx path: instead of allocating single
skbuff on every call to transport, allocate multiple skbuff's until
credit space allows, thus trying to send as much as possible data without
return to af_vsock.c.

Also this patchset includes second patch which adds check and return from
'virtio_transport_get_credit()' and 'virtio_transport_put_credit()' when
these functions are called with 0 argument. This is needed, because zero
argument makes both functions to behave as no-effect, but both of them
always tries to acquire spinlock. Moreover, first patch always calls
function 'virtio_transport_put_credit()' with zero argument in case of
successful packet transmission.

 Link to v1:
 https://lore.kernel.org/netdev/2c52aa26-8181-d37a-bccd-a86bd3cbc6e1@sberdevices.ru/
 Link to v2:
 https://lore.kernel.org/netdev/ea5725eb-6cb5-cf15-2938-34e335a442fa@sberdevices.ru/
 Link to v3:
 https://lore.kernel.org/netdev/f33ef593-982e-2b3f-0986-6d537a3aaf08@sberdevices.ru/
 Link to v4:
 https://lore.kernel.org/netdev/0e0c1421-7cdc-2582-b120-cad6f42824bb@sberdevices.ru/
 Link to v5:
 https://lore.kernel.org/netdev/f0b283a1-cc63-dc3d-cc0c-0da7f684d4d2@sberdevices.ru/

 Changelog:
 v1 -> v2:
 - If sent something, return number of bytes sent (even in
   case of error). Return error only if failed to sent first
   skbuff.

 v2 -> v3:
 - Handle case when transport callback returns unexpected value which
   is not equal to 'skb->len'. Break loop.
 - Don't check for zero value of 'rest_len' before calling
   'virtio_transport_put_credit()'. Decided to add this check directly
   to 'virtio_transport_put_credit()' in separate patch.

 v3 -> v4:
 - Use WARN_ONCE() to handle case when transport callback returns
   unexpected value.
 - Remove useless 'ret = -EFAULT;' assignment for case above.

 v4 -> v5:
 - Remove extra 'ret' initialization.
 - Remove empty extra line before 'if (ret < 0)'.
 - Add R-b tag for the first patch.
 - Add second patch, thus creating patchset of 2 patches.

Arseniy Krasnov (2):
  virtio/vsock: allocate multiple skbuffs on tx
  virtio/vsock: check argument to avoid no effect call

 net/vmw_vsock/virtio_transport_common.c | 63 +++++++++++++++++++------
 1 file changed, 49 insertions(+), 14 deletions(-)

-- 
2.25.1
