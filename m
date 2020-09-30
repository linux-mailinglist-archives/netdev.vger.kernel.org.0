Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30F727E63D
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 12:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgI3KJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 06:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbgI3KJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 06:09:15 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D65C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 03:09:15 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id f15so1054209ilj.2
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 03:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=6zOSxzLoBiu5XpwsWWEYRJcrZYnoVHWJjj/2em9kwUY=;
        b=Sq6DjmnjVzo7DfYVu/+b0075/noILu5bDuC58ruhMHSlel+k4ov9svLugLEIBKxIzq
         t1YyYOzY5JeRQEY7pnanuZm6G6/G51Covkx6MoNJKtBEpOzpi5hD9a9KurEbXcJ9AWPp
         rAO18fmH5AZHqkFUaxv+dR32lM6vCc4wMGULnSIAwRev5pCEbBj8ycGGkukElqYNNjw4
         kspg+AFQM2ve9a2mnUGjkwIxNHkdmQ+qrmVCs7t7RR60E8aGKsFR4lhmsPDahWkTCVpe
         3lHqzOZZ+/7XVLwsydXJExfUyJEhitC9ZKeBmXmGujxmgEC1mCuwgPI8kXTncRUunXZQ
         uI7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=6zOSxzLoBiu5XpwsWWEYRJcrZYnoVHWJjj/2em9kwUY=;
        b=Gv+cLf+AqTk2zuqha3IM+syVARsAVD/waYgKdf3d0+bwwx+5LwCs91OcUyOcGOaBHT
         s09mbEnIb6c5dlPcpBpKwuxPe82QpVY0bRMzYbqJHHTWY7Ody8sZ6iF/AVxPZHEOZwwB
         cvQqRWiKjVafdhpaFt4+05wjaUAohRc7o5VceKkI0cwVnrw9LEsqck33Cj6WjStnMI9/
         Pwc/+aRqsYEb/SEyFjz19EGCimRnwY2OjdhSrE2tQJm3hF4h8Ple6QS1oEg0fx9w/wrt
         hKJ0ZHFHWaQSO7ufBPIgAnIuMA6e6PguGk3EbgcqBymPGXTMMcin6PC8QK+QLlXgsHoI
         iLpA==
X-Gm-Message-State: AOAM5312QEyWjsXdNRVxUP87ZsapRmQSiGPchP9kVjyLunWwDWTdhdza
        P2yETM7ZLXJ+76JmTkaaU5OpQWJZmGL2WXnZ/hczIgiRIwE=
X-Google-Smtp-Source: ABdhPJyr8Vm/KTTCsmRzdPjKK+IkbBeTIUTpDrBrxJXAtmsYeHzE5yf7BtiUNCUgCZsawMkezIRYASm3i1A6hF4J/Z8=
X-Received: by 2002:a92:cc0f:: with SMTP id s15mr1362460ilp.254.1601460554767;
 Wed, 30 Sep 2020 03:09:14 -0700 (PDT)
MIME-Version: 1.0
From:   Peter Vollmer <peter.vollmer@gmail.com>
Date:   Wed, 30 Sep 2020 12:09:03 +0200
Message-ID: <CAGwvh_MAQWuKuhu5VuYjibmyN-FRxCXXhrQBRm34GShZPSN6Aw@mail.gmail.com>
Subject: dsa/mv88e6xxx: leaking packets on MV88E6341 switch
To:     Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,
I am currently investigating a leaking packets problem on a
armada-37xx + MV88E6341 switch (via SGMII)  + MV88E1512 Phy (via
RGMII)  platform. We are using the mainline 5.4.y kernel.

The switch and phy setup is defined in the flat device tree as follows:

&eth0 {
        phy-mode = "rgmii-id";
        phy = <&ethphy0>;
        status = "okay";
};

&eth1 {
        phy-mode = "sgmii";
        status = "okay";

        fixed-link {
                speed = <2500>;
                full-duplex;
        };
};

&mdio {
        reset-gpios = <&gpiosb 0 GPIO_ACTIVE_LOW>;
        reset-delay-us = <2>;

        ethphy0: ethernet-phy@0 {
                reg = <0x0>;
                status = "okay";
        };

        switch0: switch0@1 {
                compatible = "marvell,mv88e6085";
                #address-cells = <1>;
                #size-cells = <0>;
                reg = <1>;
                cpu-port = <5>;
                dsa,member = <0 0>;
                status = "okay";

                ports {
                        #address-cells = <0x1>;
                        #size-cells = <0x0>;

                        port@1 {
                                reg = <1>;
                                label = "lan0";
                                phy-handle = <&switch0phy1>;
                        };
                        port@2 {
                                reg = <2>;
                                label = "lan1";
                                phy-handle = <&switch0phy2>;
                        };

                        port@3 {
                                reg = <3>;
                                label = "lan2";
                                phy-handle = <&switch0phy3>;
                        };

                        port@4 {
                                reg = <4>;
                                label = "lan3";
                                phy-handle = <&switch0phy4>;
                        };

                        port@5 {
                                reg = <5>;
                                label = "cpu";
                                ethernet = <&eth1>;
                        };
                };


                mdio {
                        #address-cells = <1>;
                        #size-cells = <0>;

                        switch0phy1: switch0phy0@11 {
                                reg = <0x11>;
                        };
                        switch0phy2: switch0phy1@12 {
                                reg = <0x12>;
                        };
                        switch0phy3: switch0phy2@13 {
                                reg = <0x13>;
                        };
                        switch0phy4: switch0phy2@14 {
                                reg = <0x14>;
                        };
                };
        };
};

lan0..lan3 are members of the br0 bridge interface.

The problem is that for ICMP ping lan0-> eth0, ICMP ping request
packets are leaking (i.e. flooded)  to all other ports lan1..lan3,
while the ping reply eth0->lan0 arrives correctly at lan0 without any
leaked packets on lan1..lan3.
The problem temporarily goes away for ~280 seconds after I toggle the
multicast flag of the bridge interface ( ifconfig br0 [-]multicast )
We also noticed an asymmetric maximum network throughput, UDP traffic
lan0->eth0 is much slower than in the direction eth0->lan0.

My assumption is that in our case the SRC MAC address of the bridge
(or eth1) interface is not correctly learned by the switch, so it
floods the packets in reverse direction to all ports (CPU port 5 and
the other lan ports). As it seems the DSA packets ingressing on CPU
port5 (eth0->lan0) are sent as DSA MGMT frames, but those seem not to
be used for address learning.

Is this a known effect for this kind of setup, and is there something
we can do about it ?

What would be the best way to debug this ? Is there a way to dump the
ATU MAC tables to see what's going on with the address learning ?

Many thanks and best regards

Peter
