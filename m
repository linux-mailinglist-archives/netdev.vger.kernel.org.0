Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB2C3FEFF6
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 17:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345742AbhIBPSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 11:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345637AbhIBPSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 11:18:07 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC414C061575
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 08:17:08 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id j2so1417731pll.1
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 08:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=+SoPq38RLCGbMt9sndf16eFCMPkPreJHT5ujEqH0Fgc=;
        b=ngWbloK15iIqj1Vyf5wJeIPLLSfJMR00dMJXRaFPwA6LKBzLA3RA05Alc4mV/Mry19
         hO9fb2MDtojTLr9molnlD/T26RvVwWEnCDjOegFXrwxwLbo8CSyLeFz1JrzGt7KOl4hr
         OOKpG1UvR3170pXnYvuz1J1Q4fQcBsxYkSS0d3+faz/aMY9Pue/lZB9Ti5jMB0lfxeNn
         PP1Jq+eluqbB3UPGFnCR5OX0fi9QloRjTZrOLLm2SknQ+nQiZHiE4t3mh7RoZrAJs8Vf
         FQ0Q/Q7CfLsIf/DfLIcmi8cOwEfZf3r0TCqqWYaLCp3me183ZC9/KIhOLYPxhUbryAIF
         K6UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=+SoPq38RLCGbMt9sndf16eFCMPkPreJHT5ujEqH0Fgc=;
        b=ryaUz+F5EO1sfI5c95TbplXv2l8e4veMVhPJ+saBwhukY5Lhc2PxBhf5uP55M2xT5g
         AJXWjs2OhTGxv6TIOtrzyGeu6x3bQmoHSx38gJI95gy4F6cIYoRQb8a/3UWqp0wBZRf8
         kwYf0jx50P+TYtgFzdMhYnf9rJsrEbxERdc60JiIfYhmpkeBEKLljGsAYI/4tIGTd3as
         2mpSQy4wRIl6yl8CQW/TxkwdARbYKpEGFWgWGPC8jd/8B24YgR/DpuNGWk/ASSfvtcE5
         Y1OeOWMVZDa6f9XHfB0BOU+U/02EmT3CWMgPs1Ayd4K92zfVZo5DtStJOY9UWr5yC1Gu
         Rl+A==
X-Gm-Message-State: AOAM532T6fAvgeEgyR9yepdFfOURd81QS0mAAVxNjzc0Epy7k5Hye8YG
        Hz8TnXgthcTRqWl75VfirMLGUAQy5az8Lw==
X-Google-Smtp-Source: ABdhPJwMKjzxWJmVtDN7nQw3ZKoVO7RXRu4YMk3gd5vwtdhNawPfceXcgor6ynP2ZyD+XRYOmAg4Kg==
X-Received: by 2002:a17:90a:1904:: with SMTP id 4mr4454407pjg.217.1630595828170;
        Thu, 02 Sep 2021 08:17:08 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id d15sm2765756pfh.34.2021.09.02.08.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 08:17:07 -0700 (PDT)
Date:   Thu, 2 Sep 2021 08:17:04 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jarod Wilson <jarod@redhat.com>
Cc:     netdev@vger.kernel.org
Subject: Fw: [Bug 214277] New: mtu value for geneve interface
Message-ID: <20210902081704.63761e95@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It looks like this code in geneve_setup() causes this bug.

	/* The max_mtu calculation does not take account of GENEVE
	 * options, to avoid excluding potentially valid
	 * configurations. This will be further reduced by IPvX hdr size.
	 */
	dev->max_mtu = IP_MAX_MTU - GENEVE_BASE_HLEN - dev->hard_header_len;


Begin forwarded message:

Date: Thu, 02 Sep 2021 10:30:58 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 214277] New: mtu value for geneve interface


https://bugzilla.kernel.org/show_bug.cgi?id=214277

            Bug ID: 214277
           Summary: mtu value for geneve interface
           Product: Networking
           Version: 2.5
    Kernel Version: 5.14
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: pupilla@hotmail.com
        Regression: No

Hello everyone,

I am implementing a L2 connectivity through an ipv4 network,
via GENEVE protocol.

There are two systems called 'GENgw1' and 'GENgw2' that
implement a GENEVE tunnel to provide L2 connectivity (a
bridge is configured on both) between the 'Ovest' and 'Est'
systems.

This is the diagram:


|Ovest eth0=10.1.1.2/24|-----|eth1 GENgw2 eth0=172.19.1.2/24|---+
                              br0                               |
                                                                |
                                                              geneve
                                                                |
                                                                |
|Est eth0=10.1.1.1/24|-------|eth1 GENgw1 eth0=172.19.1.1/24|---+
                              br0


The value of the mtu assigned by default to the geneve
interface is 1450 bytes, when the mtu of the physical
interface is 1500 bytes.

I am forced to increase it (from 1450 to 1500) to ensure
the correct mtu in the L2 virtual network segment.

This is the output from GENgw1 after forcing the mtu
to 1500 bytes for the geneve device:

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group
default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP
group default qlen 1000
    link/ether fc:4d:d4:2e:cd:81 brd ff:ff:ff:ff:ff:ff
    inet 172.19.1.1/24 brd 172.19.1.255 scope global eth0
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master br0
state UP group default qlen 1000
    link/ether 00:15:17:a6:ee:4c brd ff:ff:ff:ff:ff:ff
8: genevetunnel: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
master br0 state UNKNOWN group default qlen 1000
    link/ether 9e:9a:e7:1a:2d:30 brd ff:ff:ff:ff:ff:ff
9: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group
default qlen 1000
    link/ether 00:15:17:a6:ee:4c brd ff:ff:ff:ff:ff:ff

GENgw2 setup is mirrored as GENgw1.

If I start a ping with a 1460 bytes long packet from the
'Est' system to the 'Ovest' system, the 'GENgw1' gateway
responds with an icmp message that it is necessary to
fragment the packet because it is too large because the
mtu is 1450 bytes.

tcpdump taken on GENgw1/eth1:

11:26:18.189960 IP (tos 0x0, ttl 255, id 17493, offset 0, flags [DF], proto
ICMP (1), length 1488)
    192.168.1.1 > 192.168.1.2: ICMP echo request, id 34081, seq 0, length 1468

11:26:18.189983 IP (tos 0x0, ttl 255, id 0, offset 0, flags [DF], proto ICMP
(1), length 576)
    192.168.1.2 > 192.168.1.1: ICMP 192.168.1.2 unreachable - need to frag (mtu
1450), length 556
        IP (tos 0x0, ttl 255, id 17493, offset 0, flags [DF], proto ICMP (1),
length 1488)
    192.168.1.1 > 192.168.1.2: ICMP echo request, id 34081, seq 0, length 1468

Is this what should be expected?

Thank you all for your attention.

Cheers,
Marco

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
