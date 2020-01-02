Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B755E12F1C9
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 00:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgABX2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 18:28:33 -0500
Received: from dpmailmta01-38.doteasy.com ([65.61.219.18]:42595 "EHLO
        dpmailmta01.doteasy.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726039AbgABX2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 18:28:33 -0500
X-Greylist: delayed 962 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jan 2020 18:28:33 EST
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=192.168.101.83;
Received: from dpmailrp03.doteasy.com (unverified [192.168.101.83]) 
        by dpmailmta01.doteasy.com (DEO) with ESMTP id 53015151-1394429 
        for <netdev@vger.kernel.org>; Thu, 02 Jan 2020 15:12:31 -0800
Received: from dpmail22.doteasy.com (dpmail22.doteasy.com [192.168.101.22])
        by dpmailrp03.doteasy.com (8.14.4/8.14.4/Debian-8+deb8u2) with ESMTP id 002NCUE0007942
        for <netdev@vger.kernel.org>; Thu, 2 Jan 2020 15:12:30 -0800
X-SmarterMail-Authenticated-As: trev@larock.ca
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169]) by dpmail22.doteasy.com with SMTP;
   Thu, 2 Jan 2020 15:12:13 -0800
Received: by mail-lj1-f169.google.com with SMTP id j1so34856174lja.2
        for <netdev@vger.kernel.org>; Thu, 02 Jan 2020 15:12:05 -0800 (PST)
X-Gm-Message-State: APjAAAVUWlWrYBN3jhQevWK3n6MPFl7u4ssS7NKCRQMXbAjFBSXP0yZd
        JN88CpIz+TO7oA0G6ydJMf39IdHgbCX1lz09IH0=
X-Google-Smtp-Source: APXvYqx17mEECKr/jUg4IhI5SXcIuRW2S0uWLNnr+lO/++leJ+9cbfG+PdEW53i6Z498V+1aq6FMETZv0G0B3ADbckc=
X-Received: by 2002:a2e:9e43:: with SMTP id g3mr34795643ljk.37.1578006724289;
 Thu, 02 Jan 2020 15:12:04 -0800 (PST)
MIME-Version: 1.0
From:   Trev Larock <trev@larock.ca>
Date:   Thu, 2 Jan 2020 18:11:54 -0500
X-Gmail-Original-Message-ID: <CAHgT=KfpKenfzn3+uiVdF-B3mGv30Ngu70y6Zn+wH0GcGcDFYQ@mail.gmail.com>
Message-ID: <CAHgT=KfpKenfzn3+uiVdF-B3mGv30Ngu70y6Zn+wH0GcGcDFYQ@mail.gmail.com>
Subject: VRF + ip xfrm, egress ESP packet looping when qdisc configured
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Exim-Id: CAHgT=KfpKenfzn3+uiVdF-B3mGv30Ngu70y6Zn+wH0GcGcDFYQ
X-Bayes-Prob: 0.0001 (Score 0, tokens from: base:default, @@RPTN)
X-Spam-Score: 0.00 () [Hold at 5.00] 
X-CanIt-Geo: No geolocation information available for 192.168.101.22
X-CanItPRO-Stream: base:default
X-Canit-Stats-ID: 011Jzcuej - 96a7d9b25fc6 - 20200102
X-Scanned-By: CanIt (www . roaringpenguin . com) on 192.168.101.83
X-Originating-IP: 192.168.101.83
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With a vrf configured and an xfrm policy I see some ESP packet looping,
only with qdisc.  Tried on:
fedora31 kernel 5.3.7-301.fc31.x86_64
fedora26 kernel 4.16.11

1. VRF case, host-host tunnel mode xfrm, no qdisc
          host1                                |  host2
         +---------------+                     |
         |     vrf0      |                     |
         +---------------+                     |
            |                                  |
            |                                  |
         +--------+                            |
         | enp0s8 | 192.168.56.14 --------------- 192.168.56.16
         +--------+                            |
                                               |
vrf config:
 sysctl net.ipv4.tcp_l3mdev_accept=1
 ip link add dev vrf0 type vrf table 300
 ip link set dev vrf0 up
 ip link set dev enp0s8  master vrf0

xfrm config:
 ip xfrm policy add src 192.168.56.114/32 dst 192.168.56.116/32 \
 dir out priority 367231 ptype main tmpl src 192.168.56.114 dst \
 192.168.56.116 proto esp spi 0x1234567 reqid 1 mode tunnel

 ip xfrm state add src 192.168.56.114 dst 192.168.56.116 proto esp \
 spi 0x1234567 reqid 1 mode tunnel aead rfc4106\(gcm\(aes\)\) \
 0x68db8eabd7f61557247f28f95e668f19855e086d02b21488fde4f5fcc9d42fcfbc9a2e35 \
 128 sel src 192.168.56.114/32 dst 192.168.56.116/32

(No namespace or virtual xfrm interface config involved).

ping -c 1 -w 1 -I vrf0 192.168.56.116
tcpdump -n -i enp0s8
05:01:27.085768 IP 192.168.56.114 > 192.168.56.116:
ESP(spi=0x01234567,seq=0x1), length 120
(ESP packet goes out ok)

2.  VRF + qdisc
If activating qdisc, there is increasing sized 'looping' ESP packet:
tc qdisc add dev vrf0 root netem delay 0ms

tcpdump -n -i enp0s8
(shows nothing)

tcpdump -n -i vrf0
05:08:22.583088 IP 192.168.56.114 > 192.168.56.116: ICMP echo request,
id 8873, seq 1, length 64
05:08:22.583155 IP 192.168.56.114 > 192.168.56.116:
ESP(spi=0x01234567,seq=0xe), length 120
05:08:22.583163 IP 192.168.56.114 > 192.168.56.116:
ESP(spi=0x01234567,seq=0xf), length 176
05:08:22.583168 IP 192.168.56.114 > 192.168.56.116:
ESP(spi=0x01234567,seq=0x10), length 232
05:08:22.583172 IP 192.168.56.114 > 192.168.56.116:
ESP(spi=0x01234567,seq=0x11), length 288
05:08:22.583177 IP 192.168.56.114 > 192.168.56.116:
ESP(spi=0x01234567,seq=0x12), length 344
05:08:22.583182 IP 192.168.56.114 > 192.168.56.116:
ESP(spi=0x01234567,seq=0x13), length 400

Transport mode is same behavior.  Anyone have reference config for vrf + xfrm?
Adding "dev vrf0" to the xfrm policy/state yields cleartext pings as the
oif for xfrm_lookup is enp0s8.

Thanks,
Trev

