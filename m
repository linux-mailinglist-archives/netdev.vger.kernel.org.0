Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1302C30C7
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 20:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgKXTg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 14:36:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:42004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbgKXTg6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 14:36:58 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEEB0208DB;
        Tue, 24 Nov 2020 19:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606246617;
        bh=QSe64z1gvy811zJ9kF1vWtawDd2hiNcQcnaqmprcizc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RA+sP4tgOSi2pI24SxmO+lUzuNq5R7ZQ+LsBIBgzc/dqQkS067J9qN9qQLqPNtcHf
         jEzwiYuU2R8Us19Ed1mpmtqnmZIe/Xw89Q+8XnKMNLCowJFnYK+Cz0d6FkoKG5Olfi
         b7ecTs3BWLKC7/LNz1RN7R91gukmVh/pfm+ZsUrc=
Date:   Tue, 24 Nov 2020 11:36:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH net-next 1/3] net: remove napi_hash_del() from
 driver-facing API
Message-ID: <20201124113655.77b44aad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a9ab432f-6d3c-aa8e-66bd-a82fac5d1098@gmail.com>
References: <20200909173753.229124-1-kuba@kernel.org>
        <20200909173753.229124-2-kuba@kernel.org>
        <8735d11e-e734-2ba9-7ced-d047682f9f3e@gmail.com>
        <20201124105413.0406e879@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a9ab432f-6d3c-aa8e-66bd-a82fac5d1098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 20:11:42 +0100 Eric Dumazet wrote:
> >> gro_cells_init() is setting NAPI_STATE_NO_BUSY_POLL, and this was enough
> >> to not have one synchronize_net() call per netif_napi_del()
> >>
> >> I will test something like :
> >> I am not yet convinced the synchronize_net() is needed, since these
> >> NAPI structs are not involved in busy polling.  
> > 
> > IDK how this squares against netpoll, though?
> >   
> 
> Can we actually attach netpoll to a virtual device using gro_cells ?

Not 100% sure but I grabbed a machine running 5.2 and it appears to
work:

# ip tunnel add gre1 mode gre local 192.168.123.1 remote 192.168.123.2 ttl 255
# ip link set gre1 up
# ip addr add 10.12.34.56/30 dev gre1

# cd /sys/kernel/config/netconsole/
# cat enabled 
0
# echo gre1 > dev_name 
# echo 10.12.34.57 > remote_ip 
# echo cb:a9:87:65:43:21 > remote_mac 
# echo 1 > enabled
# dmesg | tail
[16859.016632] gre: GRE over IPv4 demultiplexor driver
[16859.019831] ip_gre: GRE over IPv4 tunneling driver
[16945.776625] netpoll: netconsole: local port 6665
[16945.776627] netpoll: netconsole: local IPv4 address 0.0.0.0
[16945.776628] netpoll: netconsole: interface 'gre1'
[16945.776629] netpoll: netconsole: remote port 6666
[16945.776630] netpoll: netconsole: remote IPv4 address 10.12.34.57
[16945.776631] netpoll: netconsole: remote ethernet address cb:a9:87:65:43:21
[16945.776633] netpoll: netconsole: local IP 10.12.34.56
[16945.776635] netconsole: network logging started
# ip li show dev gre1
6: gre1@NONE: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1476 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/gre 192.168.123.1 peer 192.168.123.2


Not sure anything actually comes out on the other end of the pipe :)
