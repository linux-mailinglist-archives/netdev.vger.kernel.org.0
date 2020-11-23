Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801222C0C07
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 14:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729741AbgKWNkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 08:40:53 -0500
Received: from novek.ru ([213.148.174.62]:54828 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729539AbgKWNkx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 08:40:53 -0500
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 68C3450032C;
        Mon, 23 Nov 2020 16:41:04 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 68C3450032C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1606138865; bh=LXEs/kZPhXIcnj5xcjzLIOOA8NK3CbJKOH5BjpB5xMg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=A8AZQ0u3DaCUd4odtcnCjRiVVKNDYPAM3wVnNSuG0XCyn7TCniJ6vceFRVRKVwtKK
         eab2Y2rcdpLdm0QTvhAS4DRFH7HYiN+zCkYpJgB7Lg1U1j3iTi4akO15WaA3pg/g6l
         D3IQ3SFS59jR9dBbeFtNJiV71Cd+1+orLSirpvXU=
Subject: Re: [net v3] net/tls: missing received data after fast remote close
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>, netdev@vger.kernel.org
References: <1605801588-12236-1-git-send-email-vfedorenko@novek.ru>
 <20201120102637.7d36a9f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <64311360-e363-133c-6862-4de1298942ee@novek.ru>
Date:   Mon, 23 Nov 2020 13:40:46 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201120102637.7d36a9f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.11.2020 18:26, Jakub Kicinski wrote:
> On Thu, 19 Nov 2020 18:59:48 +0300 Vadim Fedorenko wrote:
>> In case when tcp socket received FIN after some data and the
>> parser haven't started before reading data caller will receive
>> an empty buffer. This behavior differs from plain TCP socket and
>> leads to special treating in user-space.
>> The flow that triggers the race is simple. Server sends small
>> amount of data right after the connection is configured to use TLS
>> and closes the connection. In this case receiver sees TLS Handshake
>> data, configures TLS socket right after Change Cipher Spec record.
>> While the configuration is in process, TCP socket receives small
>> Application Data record, Encrypted Alert record and FIN packet. So
>> the TCP socket changes sk_shutdown to RCV_SHUTDOWN and sk_flag with
>> SK_DONE bit set. The received data is not parsed upon arrival and is
>> never sent to user-space.
>>
>> Patch unpauses parser directly if we have unparsed data in tcp
>> receive queue.
>>
>> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
> Applied, thanks!
Looks like I missed fixes tag to queue this patch to -stable.

Fixes: c46234ebb4d1 ("tls: RX path for ktls")

