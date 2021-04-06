Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0CB1355C0E
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 21:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239750AbhDFTOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 15:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbhDFTOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 15:14:04 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20208C06174A
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 12:13:56 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id v24-20020a9d69d80000b02901b9aec33371so15724984oto.2
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 12:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=1hVk2sl4TaItmGTJsMW8mVKUsfwm7LgBMu0kzq6GV3o=;
        b=iw0BOla+AaXeIGqcxR0wdAuzV1yuPYBlqZ5IVyivcFvgt+gxvUdNYBPgEz/idp9xf0
         zzOnNyHajpsXIhCGRefvOwCFZdeUUCC7ZQLWS7Tbu9TTALgj06Qy7YKZLkHC79YoXJv6
         WL6wCaUfrwx5/HWF+vwymakH0b/D7VYP2IYG0ksiOVOikhZJ3P6r7WwcjXTNyUwGBOSm
         Jfytvd6x6jMnW2T+acHwEBN8kc1d61jB9GnTpfIE3CvpvQ8OwcrcHdB8vo6WkUNNmEEx
         X0bj6HZuKhrDSr8ye6ZCW0YEWit0/qMeOgWIq5hLEapWQPrz1kZqopa4emI+CZIO3rwL
         9v3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=1hVk2sl4TaItmGTJsMW8mVKUsfwm7LgBMu0kzq6GV3o=;
        b=cKWIgRtM25CgEZFMxWN/ldTnLv0fV/atfE+Z8kxxGad1Qlb1RWuqsTgvb+dVp6HrJT
         8bjnGHvKRH255dEmY9PyWV9OK6New80gbmfolk2NWHEtDE7YNw2DemI0GwdcLOdHgyD6
         6qI2nk7+w1Md25hP8LDjfSkBO5noWy3ypJ9D2Y1emeJH7hp2RnjsWHHS+lCDuk/mWJUi
         TZMiuon2oSO/iPjDhyIsbtds1sshuTEDgiz/sByDD+h8JHTZKLcQhQ8ghw/VI40tmJBf
         VVmsgQzytFbrLPVCK1PAypNE2BLLfySURJQYCR/lSEuhhVGoRMEx6tyV+w9wkYIFy1cx
         d74A==
X-Gm-Message-State: AOAM530hXyfB0rwRDuvV7BevojTMFNqkobZbdOQHE+sspMJuCBoYGgQC
        0Vh+dwjTrIWw/vsx2awRQgSpSmwRTVwVIBecbgzAnItS1SsQ2g==
X-Google-Smtp-Source: ABdhPJzDzNBhVR5T6iD24Vn2o4tpMFbZk25jBzlp6jQXUq+H51G0T91vmwCMzZXSYevtLRSimDfY4HBR1fP7+L+aLP0=
X-Received: by 2002:a9d:3437:: with SMTP id v52mr27796848otb.55.1617736435200;
 Tue, 06 Apr 2021 12:13:55 -0700 (PDT)
MIME-Version: 1.0
From:   Tom Cook <tom.k.cook@gmail.com>
Date:   Tue, 6 Apr 2021 20:13:44 +0100
Message-ID: <CAFSh4UxWxtedFuyDK41+98o8A_p-cvcCGW9kobNwUfJPg_8dHg@mail.gmail.com>
Subject: bind() and PACKET_MULTICAST
To:     Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Can someone please suggest why the code below doesn't do as expected?
I expect it to bind an AF_PACKET socket to an interface and receive
packets with ethertype 0x5eeb that arrive at multicast MAC address
77:68:76:68:76:69 on that interface.  In practice, nothing arrives.

If I comment out the call to bind(), it receives packets with
ethertype 0x5eeb that are addressed to 77:68:76:68:76:69 and are
received on any interface on the system, not just eth0.  (There are no
packets with ethertype 0x5eeb sent to any other address, so this may
be coincidence.)

If I change either use of ether_type to be ETH_P_ALL instead (and
re-instate the bind() call), then it receives all ethernet frames
received on eth0.

Is this a bug?  Or is it as expected and I have to use some other
mechanism (BPF?) to filter the frames?

Thanks for any assistance,
Tom

Code:

#include <arpa/inet.h>
#include <linux/if_packet.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <net/if.h>
#include <net/ethernet.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

const unsigned short eth_type = 0x5eeb;

int main() {
    int fd = socket(AF_PACKET, SOCK_RAW, htons(eth_type));
    if (fd < 0) {
        perror("socket");
        exit(1);
    }

    struct ifreq ifr;
    const char * if_name = "eth0";
    size_t if_name_len = strlen (if_name);
    memcpy(ifr.ifr_name, if_name, if_name_len);
    ioctl(fd, SIOCGIFINDEX, &ifr);
    printf("Interface has index %d\n", ifr.ifr_ifindex);

    struct sockaddr_ll addr = {0};
    addr.sll_family = AF_PACKET;
    addr.sll_ifindex = ifr.ifr_ifindex;
    addr.sll_protocol = htons(eth_type);
    addr.sll_pkttype = PACKET_MULTICAST;
    if (bind(fd, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
        perror("bind");
        exit(1);
    }

    unsigned char mcast[ETH_ALEN] = {0x77, 0x68, 0x76, 0x68, 0x76, 0x69};
    struct packet_mreq mreq = {0};
    mreq.mr_ifindex = ifr.ifr_ifindex;
    mreq.mr_type = PACKET_MR_MULTICAST;
    memcpy(mreq.mr_address, mcast, ETH_ALEN);
    mreq.mr_alen = ETH_ALEN;
    if(setsockopt(fd, SOL_SOCKET, PACKET_ADD_MEMBERSHIP, &mreq,
sizeof(mreq)) < 0) {
        perror("setsockopt");
        exit(1);
    }

    char buf [2048];
    struct sockaddr_ll src_addr;
    socklen_t src_addr_len = sizeof(src_addr);
    ssize_t count = recvfrom(fd, buf, sizeof(buf), 0, (struct
sockaddr*)&src_addr, &src_addr_len);
    if (count == -1) {
        perror("recvfrom");
        exit(1);
    } else {
        printf("Received frame.\n");
        printf("Dest MAC: ");
        for (int ii = 0; ii < 5; ii++) {
            printf("%02hhx:", buf[ii]);
        }
        printf("%02hhx\n", buf[5]);
        printf("Src MAC: ");
        for (int ii = 6; ii < 11; ii++) {
            printf("%02hhx:", buf[ii]);
        }
        printf("%02hhx\n", buf[11]);
    }
}

And here is a short Python3 programme to generate such frames (install
pyroute2 package and run as `sudo python3 test.py eth0`):

import socket
from pyroute2 import IPDB
import sys
import struct
import binascii
import time

ip = IPDB()

SMAC=bytes.fromhex(ip.interfaces[sys.argv[1]]['address'].replace(':', ''))
DMAC=bytes.fromhex('776876687669')

s = socket.socket(socket.AF_PACKET, socket.SOCK_RAW)
s.bind((sys.argv[1], 0x5eeb))
#s.bind((sys.argv[1], 0))

dgram = struct.pack("!6s6sHH", DMAC, SMAC, 0x5eeb, 0x7668)
print(' '.join('{:02x}'.format(x) for x in dgram))

while True:
    s.send(dgram)
    time.sleep(0.1)
