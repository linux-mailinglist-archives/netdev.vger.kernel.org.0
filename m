Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD4D137935
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 18:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729538AbfFFQKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 12:10:35 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:32893 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729191AbfFFQKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 12:10:35 -0400
Received: by mail-wr1-f68.google.com with SMTP id n9so3065127wru.0
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 09:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oH0h4LJeIwDnZcCTssLM4u43hwOl8qWKbu9I7fMV5q4=;
        b=bdBhDh6qDq4ef9MsgHvn8CtGN8A3B5f/7jimJaU/RvlkH/FE+zXuwjeJLPcwdzbIqc
         +7dfkuV74P1QYipiO6Oif3OV4tjEYm8jlyOukiDSvQPW1eDZG22pidr5zm9SAHet+e3+
         NrPIMqmAwU27gUqeyfnLOaZPSioX5ArGquUfMbGg72IEtF28uQXbpPbVGa5/sPNRWzFP
         SkVaVVXUBuDr4XrzbVe/Usmu2QHmEdCZxCwNO349enPp9s8hXKwKicEQe1tNmsH9+OV5
         UanGrSPBgi4diCYVKBmz4F5iZLv2qpNGuwk/vssZt8IGhe5mFcLswNFcUIX68PpEHfDg
         V/fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oH0h4LJeIwDnZcCTssLM4u43hwOl8qWKbu9I7fMV5q4=;
        b=XA28QbLc3jGFAn+OSIVxvyQ7iu3g/IPi3ZcX2OZM6ilD7hjJNUPOMS8vWYd8yEhSvZ
         CTkiddEPTSTTg2qVC3C8sMl6ZOEa9+LBKdV5xFm5fVijOlgY5BwGs5WGWdERPZ+ick6X
         RVjLqOMV0vUATrvALPf3nRixvHv195WlD+qck+wnsKD/ww4G1UFQFv4wGp2ZY40KFsHt
         eqZ3LTumvE8j3/baJWT1ruIovPZytFrZBqf4udUKLGiFV9b71LRuqTblHAgJreuEhYEi
         l1/oXT7yBjQgKKwfXV2Fs/CyWRm3+pIRnSTS40rnjZgI/2cWOn2W7W0C5SX1MmnZ20oA
         ZU0Q==
X-Gm-Message-State: APjAAAVNg7Ils0bZhPnJZJYpRCbEWbAv88VPcrU6mzkwrSPsdcfmsWNz
        R6op8jDDjbHTkAbVLN6JseZffEpBlsTbyALBGqM=
X-Google-Smtp-Source: APXvYqz52VP6VRiotGe29V7jTcMncj6wBFIes7alGc7806HlL6ysKXVIPiIqMV/G9RmUKFDr2FZq4MLHp0OgGTuaarw=
X-Received: by 2002:a5d:494d:: with SMTP id r13mr3409509wrs.152.1559837433548;
 Thu, 06 Jun 2019 09:10:33 -0700 (PDT)
MIME-Version: 1.0
References: <49388c263f652f91bad8a0d3687df7bb4a18f0da.1559473846.git.lucien.xin@gmail.com>
 <ea598247-5f96-2455-063a-dc23d7313f85@gmail.com>
In-Reply-To: <ea598247-5f96-2455-063a-dc23d7313f85@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 7 Jun 2019 00:10:21 +0800
Message-ID: <CADvbK_e4szaBKY6bJ3d-aE9XvSvCqtAJftCa=g0HpRpB6a9hqA@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: fix the check before getting the cookie in rt6_get_cookie
To:     David Ahern <dsahern@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 6, 2019 at 11:35 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 6/2/19 5:10 AM, Xin Long wrote:
> > In Jianlin's testing, netperf was broken with 'Connection reset by peer',
> > as the cookie check failed in rt6_check() and ip6_dst_check() always
> > returned NULL.
>
> Any particular test or setup that is causing the reset? I do not see
> that problem in general.
>
by running the script below, netperf ends up with:

Connection reset by peer
netperf: remote error 104


--------------------------

#!/bin/bash

ip netns add client
ip netns add server
ip netns add route

ip link add veth0_c type veth peer name veth0_cr
ip link add veth0_s type veth peer name veth0_sr
ip link set veth0_c netns client
ip link set veth0_s netns server
ip link set veth0_cr netns route
ip link set veth0_sr netns route

ip netns exec client ip link set lo up
ip netns exec client ip link set veth0_c up

ip netns exec server ip link set lo up
ip netns exec server ip link set veth0_s up

ip netns exec route ip link set lo up
ip netns exec route ip link set veth0_cr up
ip netns exec route ip link set veth0_sr up

ip netns exec client ip addr add 2000::1/64 dev veth0_c
ip netns exec client ip addr add 10.10.0.1/24 dev veth0_c
ip netns exec route ip addr add 2000::a/64 dev veth0_cr
ip netns exec route ip addr add 10.10.0.254/24 dev veth0_cr

ip netns exec server ip addr add 2001::1/64 dev veth0_s
ip netns exec server ip addr add 10.10.1.1/24 dev veth0_s
ip netns exec route ip addr add 2001::a/64 dev veth0_sr
ip netns exec route ip addr add 10.10.1.254/24 dev veth0_sr

ip netns exec client ip route add default via 10.10.0.254
ip netns exec client ip -6 route add default via 2000::a

ip netns exec server ip route add default via 10.10.1.254
ip netns exec server ip -6 route add default via 2001::a

ip netns exec route sysctl -w net.ipv4.conf.all.forwarding=1
ip netns exec route sysctl -w net.ipv6.conf.all.forwarding=1

ip netns exec client ping 10.10.1.1 -c 2
ip netns exec client ping6 2001::1 -c 2

ip netns exec route ip link set veth0_sr mtu 1400
ip netns exec server ip link set veth0_s mtu 1400

ip netns exec server netserver -d

ip netns exec client ping6 2001::1 -c 1 -s 1400 -M do
ip netns exec client ip route get 2001::1

ip netns exec client ip link set veth0_c mtu 1300
ip netns exec client ip route get 2001::1

ip netns exec client ip link set veth0_c mtu 1600
ip netns exec client ip route get 2001::1

ip netns exec client ping6 2001::1 -c 1 -s 1400 -M do
ip netns exec client ip route get 2001::1

ip netns exec client netperf -6 -H 2001::1 -t SCTP_STREAM -l 30 -- -m 16k &
#ip netns exec client netperf -6 -H 2001::1 -t TCP_STREAM -l 30 -- -m 16k &
#ip netns exec client netperf -6 -H 2001::1 -t UDP_STREAM -l 30 -- -R 1 &
pid=$!

for i in `seq 1 5`
do
ip netns exec client ip link set veth0_c mtu 1300
sleep 1
ip netns exec client ip link set veth0_c mtu 1600
sleep 1
done

wait $pid
