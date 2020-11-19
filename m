Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3372B9735
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 17:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgKSP6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 10:58:10 -0500
Received: from novek.ru ([213.148.174.62]:49756 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727428AbgKSP6J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 10:58:09 -0500
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 03BB5501633;
        Thu, 19 Nov 2020 18:58:16 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 03BB5501633
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1605801498; bh=Btq/SYSPYdnoH9mtGUUv11TeJ7lrQNl6LIW882wHG9U=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=XJLkowHxUp81u2dArf7YXodRieodS+/bdluCC4rDnZRRq//JtOesxIz3n0MPIyfst
         gJAsDrpZOcA3pUfBwiZ0EA1jgvHobwYma6xRVrjIuoHOkOUIiAbEHOmQHmKR/vFQCL
         +dswZVWFc2TthDnhV4bb97TUagkNC3Ay+YrAQi6A=
Subject: Re: [net v2] net/tls: missing received data after fast remote close
To:     Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>
Cc:     netdev@vger.kernel.org
References: <1605748432-19416-1-git-send-email-vfedorenko@novek.ru>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <c7300af8-7776-5f7a-9241-499865b24e47@novek.ru>
Date:   Thu, 19 Nov 2020 15:58:02 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1605748432-19416-1-git-send-email-vfedorenko@novek.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.11.2020 01:13, Vadim Fedorenko wrote:
> In case when tcp socket received FIN after some data and the
> parser haven't started before reading data caller will receive
> an empty buffer. This behavior differs from plain TCP socket and
> leads to special treating in user-space.
> The flow that triggers the race is simple. Server sends small
> amount of data right after the connection is configured to use TLS
> and closes the connection. In this case receiver sees TLS Handshake
> data, configures TLS socket right after Change Cipher Spec record.
> While the configuration is in process, TCP socket receives small
> Application Data record, Encrypted Alert record and FIN packet. So
> the TCP socket changes sk_shutdown to RCV_SHUTDOWN and sk_flag with
> SK_DONE bit set. The received data is not parsed upon arrival and is
> never sent to user-space.
>
> Patch unpauses parser directly if we have unparsed data in tcp
> receive queue.
>
>
Please ignore this one, it hase typo mistake.
