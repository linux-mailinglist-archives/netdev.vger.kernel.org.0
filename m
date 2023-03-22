Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8DB6C53D1
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 19:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbjCVSho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 14:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjCVShm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 14:37:42 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9F2460BB;
        Wed, 22 Mar 2023 11:37:39 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 362D05FD3E;
        Wed, 22 Mar 2023 21:37:37 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679510257;
        bh=NvKZablmSuUGBnHdnINiyWE+DWIXy85aNC7Cap2SCFg=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=MjqBiz9GzaLNpo7pvI+ugc9lX1qgsxtzdpKsrdzs1O5v49uBroTt4k9yGzdmTUA8L
         L+UCIA6T2VLNLyZs6X+P9tTl0bOyL1VRQVssb9w7kRyT6d7shR9AtOCN9pd//wKNFT
         9lctEB+6rK7JSStCMSTP8KuiLCurOFj/uf+eC16jlv0ay0qYxbw5qU2vPTqAGsvqka
         hyVD2ECcw3LN9kPnzJ/RyX5ZAzx+7MCMSMMpc9NaUeA449uLyFm9i4+ffG5ci21pUB
         bHztYuqZRsGHj4MzZ/3+5PbPskO+U+cUPLU+26GBM2b2aO1QC0uP49wlUQ/Xl+WgdL
         tiwXFf2x5vWeg==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Wed, 22 Mar 2023 21:37:33 +0300 (MSK)
Message-ID: <f0b283a1-cc63-dc3d-cc0c-0da7f684d4d2@sberdevices.ru>
Date:   Wed, 22 Mar 2023 21:34:23 +0300
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
Subject: [RFC PATCH v5 0/2] allocate multiple skbuffs on tx
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/22 14:20:00 #20991698
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
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
