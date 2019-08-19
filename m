Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC0A94962
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 18:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbfHSQEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 12:04:43 -0400
Received: from rs07.intra2net.com ([85.214.138.66]:60794 "EHLO
        rs07.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbfHSQEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 12:04:43 -0400
Received: from mail.m.i2n (unknown [172.17.128.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by rs07.intra2net.com (Postfix) with ESMTPS id D1C5D1500140;
        Mon, 19 Aug 2019 18:04:40 +0200 (CEST)
Received: from localhost (mail.m.i2n [127.0.0.1])
        by localhost (Postfix) with ESMTP id 9A0E738C;
        Mon, 19 Aug 2019 18:04:40 +0200 (CEST)
X-Virus-Scanned: by Intra2net Mail Security (AVE=8.3.54.70,VDF=8.16.21.86)
X-Spam-Status: 
X-Spam-Level: 0
Received: from rocinante.m.i2n (rocinante.m.i2n [172.16.1.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: smtp-auth-user)
        by mail.m.i2n (Postfix) with ESMTPSA id E2EAB221;
        Mon, 19 Aug 2019 18:04:38 +0200 (CEST)
Subject: Re: r8169: Performance regression and latency instability
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
References: <72898d5b-9424-0bcd-3d8a-fc2e2dd0dbf1@intra2net.com>
 <217e3fa9-7782-08c7-1f2b-8dabacaa83f9@gmail.com>
 <792d3a56-32aa-afee-f2b4-1f867b9cf75f@applied-asynchrony.com>
 <8fa71d82-d309-df38-5924-2275db188b61@gmail.com>
From:   Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
Message-ID: <a757135b-ec79-0ad5-5886-2989330424ee@intra2net.com>
Date:   Mon, 19 Aug 2019 18:04:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <8fa71d82-d309-df38-5924-2275db188b61@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

First of all: Thank you everyone for the input.

Here is some more info about my NIC. (Using the latest ethtool)

# ethtool -i eth0 ; ifconfig eth0
driver: r8169
version:
firmware-version: rtl8168h-2_0.0.2 02/26/15
expansion-rom-version:
bus-info: 0000:02:00.0
supports-statistics: yes
supports-test: no
supports-eeprom-access: no
supports-register-dump: yes
supports-priv-flags: no
eth0      Link encap:Ethernet  HWaddr <hidden>
           inet addr:<hidden>  Bcast:<hidden>  Mask:255.255.0.0
           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
           RX packets:27392501 errors:0 dropped:0 overruns:0 frame:0
           TX packets:24647212 errors:0 dropped:0 overruns:0 carrier:0
           collisions:0 txqueuelen:1000
           RX bytes:33702173568 (31.3 GiB)  TX bytes:35865124147 (33.4 GiB)


On 8/16/19 9:12 PM, Heiner Kallweit wrote:

> Indeed, here we're talking about changes in linux-next, and Juliana's issue is
> with 4.19. However I'd appreciate if Juliana could test with linux-next and
> different combinations of the NETIF_F_xxx features.

I also tested the latest linux-next (20190819) and the results did not
improved for me, unfortunately. About the same as all the kernel
versions I tested from 4.17 onwards.

# netperf -v 2 -P 0 -H <netserver-ip>,4 -I 99,5 -t omni -l 1 -- -O 
STDDEV_LATENCY -m 64K -d Send
627.99

Running linux-next I have the following defaults (shortened for simplicity):

# ethtool -k eth0
Features for eth0:
rx-checksumming: on
tx-checksumming: on
         tx-checksum-ipv4: on
         tx-checksum-ip-generic: off [fixed]
         tx-checksum-ipv6: on
         tx-checksum-fcoe-crc: off [fixed]
         tx-checksum-sctp: off [fixed]
scatter-gather: on
         tx-scatter-gather: on
         tx-scatter-gather-fraglist: off [fixed]
tcp-segmentation-offload: on
         tx-tcp-segmentation: on
         tx-tcp-ecn-segmentation: off [fixed]
         tx-tcp-mangleid-segmentation: off
         tx-tcp6-segmentation: on
generic-segmentation-offload: on
generic-receive-offload: on
large-receive-offload: off [fixed]
rx-vlan-offload: on
tx-vlan-offload: on
... (all off from here)


There are quite a few possible combinations to go through. I executed my
test with SG, TSO, GSO, RX, TX individually disabled, but the results
were all the same or slightly worse.

Until I find the root cause, we will have to keep the "tcp: switch to
GSO being always on" patch reverted for production, which is not ideal.

Any other ideas how I could debug this issue?


Best regards,
Juliana.

