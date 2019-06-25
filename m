Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAFF155960
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfFYUtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:49:42 -0400
Received: from mail-ed1-f54.google.com ([209.85.208.54]:34922 "EHLO
        mail-ed1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfFYUtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 16:49:42 -0400
Received: by mail-ed1-f54.google.com with SMTP id w20so21537243edd.2
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 13:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=JSzn3SdY+c9FwrzFdHORzDlBziEq4MVpCIVH0nrbICE=;
        b=q9jGfAoEdGc4I4x9WO5OpFVANRAuBVodTKYKodt3BpARviSQN73Odxk/bGxIyQCuQ6
         OpWRkC61j9+CedKmG8EDi/o+R5Wp5Knnikk1pdUiBw5YVeZOl/gLnHZA6GAStiRsub58
         bBhEq8oh75mYCyPKM0FlWpAW8ENMJpNnUZThNZUHmKUBzWf/R6mu49fqy7LtDUmvQDh/
         Ci5HDRGaHVVlJvurrumoM7L0Ad3LReHTGMvutY9Q69mOEyW5QvqwYuzaiYEZJBmA/SAK
         TpCCG9+yoO0EcMvjWtZvsCgjqg1FdGvO/ghIl/XIdMPsUbyKkXdYaNJXdKdaXdJeA8jw
         O9qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=JSzn3SdY+c9FwrzFdHORzDlBziEq4MVpCIVH0nrbICE=;
        b=gplPvufabpqAF4AL3Qe+plYHahwOYM1YuIzoDpeCfrVGgPppY9LCR88Ay2u7ZHtPmU
         N4eLJEjRMf4SthccHktLUL1g2TBd3x4HxkE4LoW6bhZRVJhvtWovTP+V6KyDqKn9FS2h
         7WGaVV3o7dQPL5hRhRL7p0kkeik3WmkwqvX9ww0X2M80QxKPrKytezbHyJroCievMMBg
         AcU+rP9T8kztex6r/vCREOjkLxg9eWYD4G23WDgxw/zFBTr6fHgqo03Qgt/7XvkJni+J
         PETIBLUGLKTm0LtEINl/CCGcAcDHKYUc36xgmmnefd4OQ5RTIkH5lHuzVhUH2N3mgJit
         u4Pw==
X-Gm-Message-State: APjAAAU6CF6L3F+WVa0SgbQ7G46/fXHwOlUKV28/MyFrrBSmRWQcpizi
        fXgWUb9Bh/KRtouOjS/iQraIogaHsGmokSw0VAE6CQGRCeWUIw==
X-Google-Smtp-Source: APXvYqyWBIltQVAVsB6dkLqGGuZLru6yByrtZIdK7u6RavNtvG427qsLH4SGYePcGrFDrDnNVpTXkeT7qeMwPtxkTrg=
X-Received: by 2002:a50:aa14:: with SMTP id o20mr532948edc.165.1561495780667;
 Tue, 25 Jun 2019 13:49:40 -0700 (PDT)
MIME-Version: 1.0
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 25 Jun 2019 23:49:29 +0300
Message-ID: <CA+h21hrRMrLH-RjBGhEJSTZd6_QPRSd3RkVRQF-wNKkrgKcRSA@mail.gmail.com>
Subject: What to do when a bridge port gets its pvid deleted?
To:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        stephen@networkplumber.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

A number of DSA drivers (BCM53XX, Microchip KSZ94XX, Mediatek MT7530
at the very least), as well as Mellanox Spectrum (I didn't look at all
the pure switchdev drivers) try to restore the pvid to a default value
on .port_vlan_del.
Sure, the port stops receiving traffic when its pvid is a VLAN ID that
is not installed in its hw filter, but as far as the bridge core is
concerned, this is to be expected:

# bridge vlan add dev swp2 vid 100 pvid untagged
# bridge vlan
port    vlan ids
swp5     1 PVID Egress Untagged

swp2     1 Egress Untagged
         100 PVID Egress Untagged

swp3     1 PVID Egress Untagged

swp4     1 PVID Egress Untagged

br0      1 PVID Egress Untagged
# ping 10.0.0.1
PING 10.0.0.1 (10.0.0.1) 56(84) bytes of data.
64 bytes from 10.0.0.1: icmp_seq=1 ttl=64 time=0.682 ms
64 bytes from 10.0.0.1: icmp_seq=2 ttl=64 time=0.299 ms
64 bytes from 10.0.0.1: icmp_seq=3 ttl=64 time=0.251 ms
64 bytes from 10.0.0.1: icmp_seq=4 ttl=64 time=0.324 ms
64 bytes from 10.0.0.1: icmp_seq=5 ttl=64 time=0.257 ms
^C
--- 10.0.0.1 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4188ms
rtt min/avg/max/mdev = 0.251/0.362/0.682/0.163 ms
# bridge vlan del dev swp2 vid 100
# bridge vlan
port    vlan ids
swp5     1 PVID Egress Untagged

swp2     1 Egress Untagged

swp3     1 PVID Egress Untagged

swp4     1 PVID Egress Untagged

br0      1 PVID Egress Untagged

# ping 10.0.0.1
PING 10.0.0.1 (10.0.0.1) 56(84) bytes of data.
^C
--- 10.0.0.1 ping statistics ---
8 packets transmitted, 0 received, 100% packet loss, time 7267ms

What is the consensus here? Is there a reason why the bridge driver
doesn't take care of this? Do switchdev drivers have to restore the
pvid to always be operational, even if their state becomes
inconsistent with the upper dev? Is it just 'nice to have'? What if
VID 1 isn't in the hw filter either (perfectly legal)?

Thanks!
-Vladimir
