Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C87F3DEDB5
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 14:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235879AbhHCMQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 08:16:11 -0400
Received: from mailout4.zih.tu-dresden.de ([141.30.67.75]:34596 "EHLO
        mailout4.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235873AbhHCMQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 08:16:10 -0400
X-Greylist: delayed 1595 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Aug 2021 08:16:10 EDT
Received: from [172.26.35.115] (helo=msx.tu-dresden.de)
        by mailout4.zih.tu-dresden.de with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <sebastian.rehms@tu-dresden.de>)
        id 1mAsu8-001Ek9-RP; Tue, 03 Aug 2021 13:49:24 +0200
Received: from [192.168.1.195] (141.30.223.65) by
 MSX-T315.msx.ad.zih.tu-dresden.de (172.26.35.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2242.12; Tue, 3 Aug 2021 13:49:07 +0200
To:     <netdev@vger.kernel.org>
CC:     <scott@scottdial.com>, <davem@davemloft.net>,
        <gregkh@linuxfoundation.org>
From:   Sebastian Rehms <sebastian.rehms@mailbox.tu-dresden.de>
Subject: MACSec performance issues
Message-ID: <d335ddaa-18dc-f9f0-17ee-9783d3b2ca29@mailbox.tu-dresden.de>
Date:   Tue, 3 Aug 2021 13:48:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MSX-L106.msx.ad.zih.tu-dresden.de (172.26.34.106) To
 MSX-T315.msx.ad.zih.tu-dresden.de (172.26.35.115)
X-PMWin-Version: 4.0.4, Antivirus-Engine: 3.82.1, Antivirus-Data: 5.85
X-TUD-Virus-Scanned: mailout4.zih.tu-dresden.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear netdev community,

We did some performance tests on MACSec and observed data rates of about
5-6 GBits/s. (measured with iperf3)
After a kernel update the maximum data rate dropped to about 600 MBit/s.

Due to this huge difference we did some further investigations and found
that the main reason is a change in the file drivers/net/macsec.c in the
function crypto_alloc_aead().

The change was introduced by commit
0899ff04c872463455f2749d13a5d311338021a3 (upstream commit
ab046a5d4be4c90a3952a0eae75617b49c0cb01b)

-       tfm = crypto_alloc_aead("gcm(aes)", 0, 0);
+       /* Pick a sync gcm(aes) cipher to ensure order is preserved. */
+       tfm = crypto_alloc_aead("gcm(aes)", 0, CRYPTO_ALG_ASYNC);


According to the commit description, the  CRYPTO_ALG_ASYNC flag is
required to guarantee correct packet ordering which is indeed an
implicit provision of the MACSec standard.

First, it would be desirable to verify, that the impact of the flag is
large not only on our hardware but that it is a general phenomenon.

Maybe this is of interest for the MACSec maintainers?

Kind regards,
Sebastian Rehms
