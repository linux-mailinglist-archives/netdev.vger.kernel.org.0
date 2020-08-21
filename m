Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818EC24D80C
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 17:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgHUPLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 11:11:00 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:40782 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727091AbgHUPK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 11:10:58 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07LFAtAs066401;
        Fri, 21 Aug 2020 10:10:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1598022655;
        bh=wyvu2870QWwbV1ZhRAfgPzVWp/hkgCft5WVF2FENe4A=;
        h=Subject:From:To:References:Date:In-Reply-To;
        b=BvUJ7on1AGd4LgweEZA2UVLRhY11Suqj9vIooBrmFySwd2WGGFnLzUWclM78UKdTf
         8a/8wNBnjFAkAfQkWdDTQTpklc7+ult5rfawrp+uwGtolpMPqWvI0um+awyrmxT2HA
         3N6SYVu4lkYrivUvZnLj9jMwq0JgcQXIps43OPmU=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 07LFAt4b063369
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Aug 2020 10:10:55 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 21
 Aug 2020 10:10:55 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 21 Aug 2020 10:10:55 -0500
Received: from [10.250.220.167] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07LFAsdZ090462;
        Fri, 21 Aug 2020 10:10:54 -0500
Subject: Re: VLAN over HSR/PRP - Issue with rx_handler not called for VLAN hw
 acceleration
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        <jpirko@redhat.com>
References: <dcea193d-8143-a664-947c-8a1baea7bc2c@ti.com>
Message-ID: <f20094d8-fd3a-eb1f-8bbf-8d01997ae0e0@ti.com>
Date:   Fri, 21 Aug 2020 11:10:54 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <dcea193d-8143-a664-947c-8a1baea7bc2c@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jiri,

On 8/19/20 12:08 PM, Murali Karicheri wrote:
> All,
> 
> I am working to add VLAN interface creation over HSR/PRP interface.
> It works fine after I fixed the HSR driver to allow creation of
> VLAN over it and with VLAN without hw acceleration. But with hw
> acceleration, the HSR hook is bypassed in net/core/dev.c as
> 
>      if (skb_vlan_tag_present(skb)) {
>          if (pt_prev) {
>              ret = deliver_skb(skb, pt_prev, orig_dev);
>              pt_prev = NULL;
>          }
>          if (vlan_do_receive(&skb))
>              goto another_round;
>          else if (unlikely(!skb))
>              goto out;
>      }
> 
>      rx_handler = rcu_dereference(skb->dev->rx_handler);
>      if (rx_handler) {
>          if (pt_prev) {
>              ret = deliver_skb(skb, pt_prev, orig_dev);
>              pt_prev = NULL;
>          }
>          switch (rx_handler(&skb)) {
>          case RX_HANDLER_CONSUMED:
>              ret = NET_RX_SUCCESS;
>              goto out;
>          case RX_HANDLER_ANOTHER:
>              goto another_round;
>          case RX_HANDLER_EXACT:
>              deliver_exact = true;
>          case RX_HANDLER_PASS:
>              break;
>          default:
>              BUG();
>          }
>      }
> 
> What is the best way to address this issue? With VLAN hw acceleration,
> skb_vlan_tag_present(skb) is true and rx_handler() is not called.
> 
I find that you have modified vlan_do_receive() in the past and
wondering if you have some insight into the issue. I also see the same
issue when I create VLAN interfaces over a linux bridge over TI's cpsw
interfaces. I understand that bridge code also use the same hook
(rx_handler) as HSR to receive the frames. The vlan interface doesn't
get the frames. With VLAN acceleration disabled, VLAN interfaces seems
to work fine. I  have two AM572x IDKs with CPSW port connected back to
back. I setup Linux bridge and run stp to avoid looks. I don't
understand what vlan_do_receive() is doing. Could you explain?
probably it needs to false for Linux bridge and HSR case so that
the rx_handler will receive the frame? As a HACK, I will muck around
with this code to return false and see if that helps.

Setup used for my work.

192.168.100.10  192.168.101.10           192.168.100.20 192.168.101.20
  br0.100        br0.101                     br0.100      br0.101
   |-----------|                                |--------------|
         |                                            |
         br0 (192.168.2.10)                         br0 (192.168.2.20)
DUT-1-----|--eth0 <-------------------------> eth0---|-----DUT-1
           |--eth1 <-------------------------> eth1---|

Now Ping between 192.168.100.10 and 192.168.100.20 or
192.168.101.10 and 192.168.101.20

Commands below.

DUT-1

brctl addbr br0
brctl addif br0 eth0
brctl addif br0 eth1
ifconfig eth0 up
ifconfig eth1 up
brctl stp br0 yes
ifconfig br0 192.168.2.10

ip link add link br0 name br0.100 type vlan id 100
ip link add link br0 name br0.101 type vlan id 101
ifconfig br0.100 192.168.100.10
ifconfig br0.101 192.168.101.10


DUT-2

brctl addbr br0
brctl addif br0 eth0
brctl addif br0 eth1
ifconfig eth0 up
ifconfig eth1 up
brctl stp br0 yes
ifconfig br0 192.168.2.20

ip link add link br0 name br0.100 type vlan id 100
ip link add link br0 name br0.101 type vlan id 101
ifconfig br0.100 192.168.100.20
ifconfig br0.101 192.168.101.20

> Thanks
> 

-- 
Murali Karicheri
Texas Instruments
