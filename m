Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D612F0CFD
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 07:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbhAKGpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 01:45:12 -0500
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:52710 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbhAKGpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 01:45:12 -0500
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 4683575FF8;
        Mon, 11 Jan 2021 09:44:26 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1610347466;
        bh=aApp4LN/QtkPAOSm6mJdV5wecd76/VDE+Frwf2Hzg/U=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=P4h/crwpaYLkch4uHMleAiBG2IJv3G8TGD2wMJ4YIMNA8y6dCrCxHV0+JeUGrklvO
         8+l7vSoCkCyEvfx2B8GNaaAlSDQptsffUkgstb8vzPXxiX+jZiYL19KFkI+21E3y66
         +u7NVvjdcHIBn19C+2LYidS/T3NLeeizf5r8QGH8=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 4FA9875FFB;
        Mon, 11 Jan 2021 09:44:25 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Mon, 11
 Jan 2021 09:44:24 +0300
Subject: Re: [PATCH 3/5] af_vsock: send/receive loops for SOCK_SEQPACKET.
To:     stsp <stsp2@yandex.ru>, Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Arseniy Krasnov <oxffffaa@gmail.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Jeff Vander Stoep <jeffv@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210103195454.1954169-1-arseny.krasnov@kaspersky.com>
 <20210103200347.1956354-1-arseny.krasnov@kaspersky.com>
 <8ffb1753-c95b-c8f3-6ed9-112bf35623be@yandex.ru>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <61ee202f-58bc-0bd2-5aa7-3a84993d055e@kaspersky.com>
Date:   Mon, 11 Jan 2021 09:44:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8ffb1753-c95b-c8f3-6ed9-112bf35623be@yandex.ru>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.16, Database issued on: 01/11/2021 06:22:17
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 161021 [Jan 11 2021]
X-KSE-AntiSpam-Info: LuaCore: 419 419 70b0c720f8ddd656e5f4eb4a4449cf8ce400df94
X-KSE-AntiSpam-Info: Version: 5.9.16.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Tracking_content_type, plain}
X-KSE-AntiSpam-Info: {Tracking_date, moscow}
X-KSE-AntiSpam-Info: {Tracking_c_tr_enc, eight_bit}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 01/11/2021 06:25:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 11.01.2021 5:48:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/01/11 04:28:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/01/11 04:10:00 #16053498
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hmm, are you sure you need to convert
> "err" to the pointer, just to return true/false
> as the return value?
> How about still returning "err" itself?

In this case i need to reserve some value for
"err" as success, because both 0 and negative
values are passed to caller when this function
returns false(check failed). May be i will
inline this function.

> Its not very clear (only for me perhaps) how
> dequeue_total and len correlate. Are they
> equal here? Would you need to check that
> dequeued_total >= record_len?
> I mean, its just a bit strange that you check
> dequeued_total>0 and no longer use that var
> inside the block.

When "dequeued_total > 0" record copy is succeed.
"len" is length of user  buffer. I think i can
replace "dequeued_total" to some flag, like "error",
because in SOCK_SEQPACKET mode record could be
copied whole or error returned.

