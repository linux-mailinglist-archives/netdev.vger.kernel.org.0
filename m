Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A2F4A4F99
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 20:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377281AbiAaTmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 14:42:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377301AbiAaTmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 14:42:45 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8660FC061714;
        Mon, 31 Jan 2022 11:42:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ABE54CE13BD;
        Mon, 31 Jan 2022 19:42:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB57C340E8;
        Mon, 31 Jan 2022 19:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643658160;
        bh=PTE3tEGFjabPKu8ZwTE6QJsZ8RZHV8CADoQIm4rGnOs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pwaq+lv422vYhBRoVfKBndRiB2RqqzRRwtKmx8iGzGCmQe7LolPzimyW1VfrZJWqv
         Nt0EAs53n018y46m0SA2i/5TplEiB87CVAzfISMU0RF3/tpVo/JdYkjK2EGdhksLXJ
         0nkaieswgPKm0iMghkUffJ4BdSBnm8GlKYlV9SJIqH26lYOcBo6HsFYvvcdEIwmu4c
         MY51GkOHhEjdg1I3vhheMq5NRlC1SZYBxGrOhsGGvsGnIq35bWiSfl480emivJ/FX3
         +jLVXOKsr4cMB6GEWuxm0nyT43sX+rHzqyiIufaPhcTaPwhQ7/WI2J9ZXKPIiu8jaw
         yLfIgIxvOHo6Q==
Date:   Mon, 31 Jan 2022 11:42:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] net/smc: Improvements for TCP_CORK and
 sendfile()
Message-ID: <20220131114239.66bbf16e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220130180256.28303-1-tonylu@linux.alibaba.com>
References: <20220130180256.28303-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Jan 2022 02:02:54 +0800 Tony Lu wrote:
> Currently, SMC use default implement for syscall sendfile() [1], which
> is wildly used in nginx and big data sences. Usually, applications use
> sendfile() with TCP_CORK:
> 
> fstat(20, {st_mode=S_IFREG|0644, st_size=4096, ...}) = 0
> setsockopt(19, SOL_TCP, TCP_CORK, [1], 4) = 0
> writev(19, [{iov_base="HTTP/1.1 200 OK\r\nServer: nginx/1"..., iov_len=240}], 1) = 240
> sendfile(19, 20, [0] => [4096], 4096)   = 4096
> close(20)                               = 0
> setsockopt(19, SOL_TCP, TCP_CORK, [0], 4) = 0
> 
> The above is an example of Nginx, when sendfile() on, Nginx first
> enables TCP_CORK, write headers, the data will not be sent. Then call
> sendfile(), it reads file and write to sndbuf. When TCP_CORK is cleared,
> all pending data is sent out.
> 
> The performance of the default implement of sendfile is lower than when
> it is off. After investigation, it shows two parts to improve:
> - unnecessary lock contention of delayed work
> - less data per send than when sendfile off
> 
> Patch #1 tries to reduce lock_sock() contention in smc_tx_work().
> Patch #2 removes timed work for corking, and let applications control
> it. See TCP_CORK [2] MSG_MORE [3].
> Patch #3 adds MSG_SENDPAGE_NOTLAST for corking more data when
> sendfile().
> 
> Test environments:
> - CPU Intel Xeon Platinum 8 core, mem 32 GiB, nic Mellanox CX4
> - socket sndbuf / rcvbuf: 16384 / 131072 bytes
> - server: smc_run nginx
> - client: smc_run ./wrk -c 100 -t 2 -d 30 http://192.168.100.1:8080/4k.html
> - payload: 4KB local disk file
> 
> Items                     QPS
> sendfile off        272477.10
> sendfile on (orig)  223622.79
> sendfile on (this)  395847.21
> 
> This benchmark shows +45.28% improvement compared with sendfile off, and
> +77.02% compared with original sendfile implement.
> 
> [1] https://man7.org/linux/man-pages/man2/sendfile.2.html
> [2] https://linux.die.net/man/7/tcp
> [3] https://man7.org/linux/man-pages/man2/send.2.html

I believe this is now commit 780bf05f44c2 ("Merge branch
'smc-improvements'") in net-next. Thanks!
