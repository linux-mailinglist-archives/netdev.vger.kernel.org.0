Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B856C308B82
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 18:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbhA2R1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 12:27:00 -0500
Received: from novek.ru ([213.148.174.62]:49912 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232486AbhA2RZy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 12:25:54 -0500
Received: from [172.23.108.4] (unknown [88.151.187.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 60E8B50336D;
        Fri, 29 Jan 2021 20:26:26 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 60E8B50336D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1611941187; bh=fwnyLE7ASwVlxR/MmPjHje2DH5f32eT4ddU0KN7gHbM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=WW5eBMgpeCJ08lpbot+274Z31qrO2r+KATEZwdsPhNYtxXS9JGKzuX6cWc5hcQv8I
         6e0wRBXoEEhdl2JLA3u4W0dzrXosetRNfXFtmOS3DBB3TxUEdMPibIiKxF9reL8WYO
         JaJGEOFoThWgMp5Nb76BfzlZ7zuv3BFkmUoAmwxU=
Subject: Re: [net] udp: exclude UDP_ENCAP_RXRPC packets from early demux
To:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@kernel.org>,
        David Howells <dhowells@redhat.com>
Cc:     linux-afs@lists.infradead.org, netdev@vger.kernel.org
References: <1611930303-15972-1-git-send-email-vfedorenko@novek.ru>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <1ae64181-bd97-4975-c534-c19e62e04324@novek.ru>
Date:   Fri, 29 Jan 2021 17:25:04 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1611930303-15972-1-git-send-email-vfedorenko@novek.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.01.2021 14:25, Vadim Fedorenko wrote:
> While adding the early demux for udp sockets rxrpc were not
> changed to deal with sk_rx_dst cache. That leads to leaking early
> demux cache dst reference. But adding dst_release to destructor of
> rxrpc doesn't help in situation of destroying namespace. This is
> because rxrpc does not register any netdevices per namespace.
> Assigned sk->sk_rx_dst holds the reference to netdevice preventing
> successful freeing of netdevices in namespace and moving forward to
> subsystem freeing. This is dead lock situation.
> 
> Removing rxrpc sockets from early demux util the solution in rxrpc
> subsystem is made.

Skip this please, as David Howells sent corrections to rxrpc
