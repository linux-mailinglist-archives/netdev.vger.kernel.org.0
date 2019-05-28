Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1445B2BF18
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 08:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbfE1GL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 02:11:29 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:37295 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbfE1GL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 02:11:29 -0400
Received: by mail-wm1-f54.google.com with SMTP id 7so1376750wmo.2;
        Mon, 27 May 2019 23:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=V2ShQKVShCk9ba4wvUF+geCbfjkCHod2XBaE58B3jlc=;
        b=DUFWmJQwcWXoX80krafWSvUkS3Js19khPoqh6UZckm6oUBy+UUecV5XuYzWlpcDTBF
         ayult0TTlD0qx6ZFKu6njaPloew+1sGITUtcn/cPoNQhyQrn3729nNsRFrZmDEB4KWzS
         zFea91982ma3rC0ilRlfsrMvlK+SXcONazOqP52O71aECK9geUsRu1zNCl+ecaBdGzbQ
         uy9muDBvOqV1TKgpDmQdB4eGfq5YcxepRMS0fHOGowqFPHKU9tAnMs9s7aLqRL6TCZZu
         Ki2W5hMNe0F9fy5yDts0qA4JGgyq1GggoWiooQI1+L8Xt7KnTgm1eB75nErdjRHkevmV
         5g/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=V2ShQKVShCk9ba4wvUF+geCbfjkCHod2XBaE58B3jlc=;
        b=K7Mgi+v2ZaWTpZwZFBuAXllyIj3i24kEXP1/JBHX0hrlMCIAAP4O1HrdB8z2Z/Hthw
         2rRYppjoKXdpiIXrsgTr9g34/m7k76BxKn6aPitiL7ZG8HFtQFyNM7M5lXbvRQIQXBTi
         r986vsVxikZX35uU8HHM0OJ8nNhHT3X6YsYg1EIO/Kpoi06khLwSNLthO6Ru/kc+RTRv
         TG09cu60Xw4ICdIAQ6i9ApKAn6LmJF04nUwIfUcHE3356D8GMVH9WoyVRhp9aEe7oJaV
         yTfwnFEuEPKtmDgGiLtAlQGlQIG9CEFobTACvqAAQjFaZgNbDiBPk0tguCVtNuZ5X7P1
         DPOQ==
X-Gm-Message-State: APjAAAVjtktk4O4qHrauff0hAKc7CLL4Z/9uK66C4dpK3LjVFhATYNtH
        pJpYs0s/+DewQA8tAiQxWMYuNp4ErWcdPk4uHa+UG+ZWIGw=
X-Google-Smtp-Source: APXvYqyHZMybVKz0kPdzmEu45CjadqSgdKu6QuxJV1v+IU/m6opmxFTHtMnZ/KA078Mt6GgzwveKJoA4SbD9cuWp1H0=
X-Received: by 2002:a1c:7e10:: with SMTP id z16mr1817345wmc.98.1559023887261;
 Mon, 27 May 2019 23:11:27 -0700 (PDT)
MIME-Version: 1.0
From:   Akshat Kakkar <akshat.1984@gmail.com>
Date:   Tue, 28 May 2019 11:41:14 +0530
Message-ID: <CAA5aLPgz2Pzi5qNZkHwtN=fEXEwRpCQYFUkEzRWkdT39+YNWFA@mail.gmail.com>
Subject: Cake not doing rate limiting in a way it is expected to do
To:     netdev <netdev@vger.kernel.org>, lartc <lartc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cake is expected to handle traffic in 2 steps :
First is on the basis of host
Second is within every host, on the basis of flow

So, if I limit traffic to 20Mbps shared across 2 host A & B,
Following are various scenarios, expectation and observations
1. If either A or B is downloading, they will be getting speed of 20Mbps
Observation: Meeting with expectation

2. If both A & B downloads (single download each), each will be
getting speed of 20Mbps
Observation: Meeting with expecation but its very jittery (around
20%), i.e. speed varies from 8Mbps to 12 Mbps. If I use fq_codel speed
is same BUT jitter is very less (around 1%).

3. Now if A starts 3 downloads, and B is still having single download,
A each download should be around 3.3 Mbps and B should be around
10Mbps
Observation: Around 5 Mbps for each download with lot of jitter, i.e.
no advantage of having CAKE!!!

Linux Kernel 4.20
For case 3, output of command : tc -s class show dev eno2

class htb 1:1 root leaf 8003: prio 1 rate 20000Kbit ceil 20000Kbit
burst 200Kb cburst 1600b
 Sent 688474645 bytes 455058 pkt (dropped 0, overlimits 381196 requeues 0)
 rate 19874Kbit 1641pps backlog 21196b 14p requeues 0
 lended: 382532 borrowed: 0 giants: 0
 tokens: 1260573 ctokens: -9427

class cake 8003:44f parent 8003:
 (dropped 3404, overlimits 0 requeues 0)
 backlog 9084b 6p requeues 0
class cake 8003:516 parent 8003:
 (dropped 3565, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
class cake 8003:590 parent 8003:
 (dropped 3023, overlimits 0 requeues 0)
 backlog 4542b 3p requeues 0
class cake 8003:605 parent 8003:
 (dropped 1772, overlimits 0 requeues 0)
 backlog 7570b 5p requeues 0
