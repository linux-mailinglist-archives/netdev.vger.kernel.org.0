Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223B839CFB2
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 17:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhFFPMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 11:12:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230088AbhFFPMA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Jun 2021 11:12:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5D2C6142A;
        Sun,  6 Jun 2021 15:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622992211;
        bh=6SAVyd1SzFpYco+54dJsIay9qkBgHR9Q47j6DtBPqvk=;
        h=Date:From:To:Cc:Subject:From;
        b=lKQw6RmlnW8/saMq4ls0pS4VxyyNwAOr+IyTQkXXtLDq55gbCUJLCNiDWL96NVxTp
         RLWegtsAQUQqO3R3z4xhmU0uM6MDPkvcV/D7BIdx7DjPZ4nvg6J9iMevMycuKLJZQI
         SvTRI52hIICbrfUi+u65yosDgFFc63IqtUuaBteBwqIsRJA6O3RfbfHs+cVsUS7vaK
         B0pBMITIal0XHX/zR0So1v8MpqDcycFRWQJ5Ag59af1iwy4cIWV50UVMd2qIyV/Cz6
         9hTJdxTg/rLWjqmqtOVXza3KvUxpWjJTDzWOCfmoo2b5BALYsU7mmanRx7FMcWRN32
         bKw0vSXZTQOJw==
Received: by pali.im (Postfix)
        id 614017B9; Sun,  6 Jun 2021 17:10:08 +0200 (CEST)
Date:   Sun, 6 Jun 2021 17:10:08 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org
Subject: Issues during assigning addresses on point to point interfaces
Message-ID: <20210606151008.7dwx5ukrlvxt4t3k@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

Seems that there is a bug during assigning IP addresses on point to
point interfaces.

Assigning just one local address works fine:

    ip address add fe80::6 dev ppp1 --> inet6 fe80::6/128 scope link

Assigning both local and remote peer address also works fine:

    ip address add fe80::7 peer fe80::8 dev ppp1 ---> inet6 fe80::7 peer fe80::8/128 scope link

But trying to assign just remote peer address does not work. Moreover
"ip address" call does not fail, it returns zero but instead of setting
remote peer address, it sets local address:

    ip address add peer fe80::5 dev ppp1 --> inet6 fe80::5/128 scope link

I suspect that this is a bug either in iproute2 "ip" utility or in
kernel how it parse and process netlink messages.

strace for the last command see this netlink packet:

    sendmsg(3, {
        msg_name={
            sa_family=AF_NETLINK,
            nl_pid=0,
            nl_groups=00000000
        },
        msg_namelen=12,
        msg_iov=[{
            iov_base={
                {
                    len=44,
                    type=RTM_NEWADDR,
                    flags=NLM_F_REQUEST|NLM_F_ACK|NLM_F_EXCL|NLM_F_CREATE,
                    seq=1622990155,
                    pid=0
                },
                {
                    ifa_family=AF_INET6,
                    ifa_prefixlen=128,
                    ifa_flags=0,
                    ifa_scope=RT_SCOPE_UNIVERSE,
                    ifa_index=if_nametoindex("ppp1")
                },
                {
                    {
                        nla_len=20,
                        nla_type=IFA_ADDRESS
                    },
                    inet_pton(AF_INET6, "fe80::5")
                }
            },
            iov_len=44
        }],
        msg_iovlen=1,
        msg_controllen=0,
        msg_flags=0
    }, 0) = 44

On the other hand strace for the first command (which assigns only local
address) see following netlink packet:

    sendmsg(3, {
        msg_name={
            sa_family=AF_NETLINK,
            nl_pid=0,
            nl_groups=00000000
        },
        msg_namelen=12,
        msg_iov=[{
            iov_base={
                {
                    len=64,
                    type=RTM_NEWADDR,
                    flags=NLM_F_REQUEST|NLM_F_ACK|NLM_F_EXCL|NLM_F_CREATE,
                    seq=1622990488,
                    pid=0
                },
                {
                    ifa_family=AF_INET6,
                    ifa_prefixlen=128,
                    ifa_flags=0,
                    ifa_scope=RT_SCOPE_UNIVERSE,
                    ifa_index=if_nametoindex("ppp1")
                },
                [
                    {
                        {
                            nla_len=20,
                            nla_type=IFA_LOCAL
                        },
                        inet_pton(AF_INET6, "fe80::6")
                    },
                    {
                        {
                            nla_len=20,
                            nla_type=IFA_ADDRESS
                        },
                        inet_pton(AF_INET6, "fe80::6")
                    }
                ]
            },
            iov_len=64
        }],
        msg_iovlen=1,
        msg_controllen=0,
        msg_flags=0
    }, 0) = 64

So it sends two addresses, one IFA_LOCAL, one IFA_ADDRESS, but both are
same.

For completeness here is strace output when assigning both local and
remote peer address:

    sendmsg(3, {
        msg_name={
            sa_family=AF_NETLINK,
            nl_pid=0,
            nl_groups=00000000
        },
        msg_namelen=12,
        msg_iov=[{
            iov_base={
                {
                    len=64,
                    type=RTM_NEWADDR,
                    flags=NLM_F_REQUEST|NLM_F_ACK|NLM_F_EXCL|NLM_F_CREATE,
                    seq=1622990883,
                    pid=0
                },
                {
                    ifa_family=AF_INET6,
                    ifa_prefixlen=128,
                    ifa_flags=0,
                    ifa_scope=RT_SCOPE_UNIVERSE,
                    ifa_index=if_nametoindex("ppp1")
                },
                [
                    {
                        {
                            nla_len=20,
                            nla_type=IFA_LOCAL
                        },
                        inet_pton(AF_INET6, "fe80::7")
                    },
                    {
                        {
                            nla_len=20,
                            nla_type=IFA_ADDRESS
                        },
                        inet_pton(AF_INET6, "fe80::8")
                    }
                ]
            },
            iov_len=64
        }],
        msg_iovlen=1,
        msg_controllen=0,
        msg_flags=0
    }, 0) = 64

Which means that IFA_LOCAL sets local address and IFA_ADDRESS sets
remote peer address on point point interface.

Therefore there are two suspicious things about address configuration on
point to point interfaces:

1) "ip address add fe80::6 dev ppp1" is trying to set not only local but
   also remote peer address to fe80::6

2) kernel does not configure remote peer address from IFA_ADDRESS when
   local address via IFA_LOCAL is not specified in netlink packet


For tests I used:

    ip -V --> ip utility, iproute2-ss190107
    uname -r -v -m --> 4.19.0-16-amd64 #1 SMP Debian 4.19.181-1 (2021-03-19) x86_64
