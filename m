Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7160B6C9132
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 23:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbjCYWPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 18:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjCYWP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 18:15:28 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A3DCDC1;
        Sat, 25 Mar 2023 15:15:27 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id C40E85FD02;
        Sun, 26 Mar 2023 01:15:25 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679782525;
        bh=blzS4++pYQHNhtF7NyjyEqKRhpH86CYY7XtCWadbAsw=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=r/Nol64Cw5hi1wTIoMUJklQnY+1478LXOuWhXWFTkVg956xDytgMpetXUX3n7keAP
         sVOGX4u35yO92jJKmCwDWaEgtmpDJiFCJTHNDE7lrkKyGsZFgo5I0KJZaNnkAmapFB
         ae1a5HaSA1PSGIq6vqIWMlbpholD/h02zQdC7aXXyA6DfplrJkEGW59utosRwaEhVG
         5DjKII5VYukK+Fkthojd1iTK/oN1xaRjBncLWgTTHrHJihBfkslALsxCbrd+o2F2MH
         BJdWsU78rmK6J911pNtd9TI9n/4Ppoy9ZDN7hgVFi9cV/05yamhkSS3KgCq099cxu2
         SuUGkUmjMVoFQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun, 26 Mar 2023 01:15:25 +0300 (MSK)
Message-ID: <97f19214-ba04-c47e-7486-72e8aa16c690@sberdevices.ru>
Date:   Sun, 26 Mar 2023 01:12:09 +0300
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
Subject: [RFC PATCH v1 0/2] return errors other than -ENOMEM to socket
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/25 20:38:00 #21009968
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this patchset removes behaviour, where error code returned from any
transport was always switched to ENOMEM. This works in the same way as
patch from Bobby Eshleman:
commit c43170b7e157 ("vsock: return errors other than -ENOMEM to socket"),
but for receive calls.

vsock_test suite is also updated.

Arseniy Krasnov (2):
  vsock: return errors other than -ENOMEM to socket
  vsock/test: update expected return values

 net/vmw_vsock/af_vsock.c         | 4 ++--
 tools/testing/vsock/vsock_test.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.25.1
