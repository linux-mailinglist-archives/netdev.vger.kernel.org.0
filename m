Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54163145CEE
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 21:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgAVUOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 15:14:17 -0500
Received: from mail-ot1-f51.google.com ([209.85.210.51]:32973 "EHLO
        mail-ot1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgAVUOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 15:14:16 -0500
Received: by mail-ot1-f51.google.com with SMTP id b18so578569otp.0
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 12:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=6Fe/UapJt08xnr2MrvyzGGuDo7NOhBrUi/u1V6C+m6k=;
        b=V6N82IRav31DWQc2e4M8QMiGRgV4+cFJORfL5oV3TsFWAwgATA4qoOQPuZdywM5KOX
         WEPEydsf2ZJMm9j1v4dqlai+xFTCJ8aqVCz+dJrDTCwmXwz/mMDf09Dk5hayFPILKxI0
         CRU762lc6Y1jm9TxNvAG3DiLbdk0XO9hGIrmKHyMLgla5+2lhnMIJhpyustXArZnYY9X
         +AWba0hEvIHDYy6+8U5ciRGyaBqsIAi4y8vIYeaAkE5l6ejmKdEcEY8GAcvf2HWi7ZGm
         CJSe/UoY74secCjPKG0mFL9DX6wsw4+9FAXWb2XKM56UZ6YA5VmhRqJbDhuAzzBTr5x4
         U1lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=6Fe/UapJt08xnr2MrvyzGGuDo7NOhBrUi/u1V6C+m6k=;
        b=CY5yyzQuIbwlX8j87afqFm2Co7j+gnnCJq5ONHMk2mw6ObKjihAKDWWfSU0Pi37NdM
         rBTNq8rrUqvKwgoYMF2IDLPKUG1uas6jWDYHZAgPtVRzW/XL5dGPHsGzOLggpScvy/Yr
         VxXNBkycCOsD6gZ2bNbTKfjsOgF0klaCKNw9ZLkR4L+3k9m5jkSci3ycpqaV5qv/thmF
         ALYQLq3qDVZzvSf7Cnathk8m37IlupN1PoDXVIFY0p5TwgzknhFQwTYB3FeiDgzyUOsl
         qhKjuxgZxJSy59FFzxEYGvb7Dc+V2EjjReJHkeJaGiiwN00KHsKiLJ3NK4fsZu+CqOdq
         m2DA==
X-Gm-Message-State: APjAAAVbQqtFNDRkkqq6+6bs1CPDYNVAoUhuw+aaSWWZu61cqt5cnipD
        JnuLcobrD4AnFqy0gD5cyoVXQlENbgrKOu2Ak0ZB49FH
X-Google-Smtp-Source: APXvYqxnFGY2t2LX2TuE0l0aHvvDunJEaHlMNNJJjvbXIgJ8pG5VKFurigcqeYMQblp9pyq6ZpFeyxlcLXS2cKTEUzA=
X-Received: by 2002:a05:6830:109a:: with SMTP id y26mr8169444oto.227.1579724055569;
 Wed, 22 Jan 2020 12:14:15 -0800 (PST)
MIME-Version: 1.0
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Wed, 22 Jan 2020 21:14:04 +0100
Message-ID: <CAKfDRXgkU9apv+544cd=u_RWP_3htDSarsv4XqmxW9W0n2KiqQ@mail.gmail.com>
Subject: Overlapping networks can only be added in a certain order
To:     Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I have a machine that is connected to two separate networks (on two
separate interfaces), but the network addresses overlap. The first
network (lets call it N1) gives me an address in 10.5.101.248/29,
while the other (N2) in 10.5.101.248/30. If routing is successfully
configured or not, depends on the order in which the networks are
configured.

If N1 is configured first, then routing is successfully configured for
both networks. If N2 is configured first, then the configuration of N1
fails. The routes for each network are placed in separate tables, and
I know that the configuration of one network is done before the other
is configured.

The machine where I initially observed this behavior runs kernel 4.14,
but I was able to replicate on a machine running 5.0 using the
commands below. Things start going wrong when I configure N2 before
N1, and set the address for N1. The address is set on the device, but
there is no route added to the main routing table. Instrumenting the
kernel shows that the error happens in fib_valid_prefsrc().

I also checked that routing works correctly when N1 is configured
first, and it does. I used ping and bound the process to the interface
I wanted to check, capturing packets showed that the correct interface
was used

Thanks in advance for any help.

BR,
Kristian

Commands for replicating issue:

#Set up networking. test1 matches N1, test2 N2
ip link add test1 type dummy
ip link add test2 type dummy
ip link set dev test1 up
ip link set dev test2 up

#Configure N1 before N2, works fine
ip addr add 10.5.101.251/29 dev test1
ip ro del 10.5.101.248/29 dev test1 src 10.5.101.251
ip ro add 10.5.101.248/29 dev test1 src 10.5.101.251 table 1
ip ro add default via 10.5.101.252 dev test1 src 10.5.101.251 table 1

ip addr add 10.5.101.250/30 dev test2
ip ro del 10.5.101.248/30 dev test2 src 10.5.101.250
ip ro add 10.5.101.248/30 dev test2 src 10.5.101.250 table 4

#Clean up
ip addr flush dev test1
ip addr flush dev test2

#Configure N2 before N1, failes
ip addr add 10.5.101.250/30 dev test2
ip ro del 10.5.101.248/30 dev test2 src 10.5.101.250
ip ro add 10.5.101.248/30 dev test2 src 10.5.101.250 table 4
ip ro add default via 10.5.101.249 dev test2 src 10.5.101.250 table 4

ip addr add 10.5.101.251/29 dev test1
ip ro del 10.5.101.248/29 dev test1 src 10.5.101.251
ip ro add 10.5.101.248/29 dev test1 src 10.5.101.251 table 1
ip ro add default via 10.5.101.252 dev test1 src 10.5.101.251 table 1
