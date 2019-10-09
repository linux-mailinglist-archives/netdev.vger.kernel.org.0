Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92E08D1365
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 18:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731478AbfJIQAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 12:00:22 -0400
Received: from mail-qt1-f176.google.com ([209.85.160.176]:46759 "EHLO
        mail-qt1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729644AbfJIQAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 12:00:21 -0400
Received: by mail-qt1-f176.google.com with SMTP id u22so4087213qtq.13
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 09:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mbuki-mvuki-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=szXbMfsBdR2LAogQ8vebdSF7PxK4Sa+S3XEKazagktE=;
        b=am467+9AhbM4qy6HhUmH9pSVOg9QIb+TlVQZ2KAf90oHK5NlejRGxtMu0S8JHsUbrt
         wOSTKJnFt5n3V8m34njyc0bY1oBENTPR2fpbSRZb7de0rhoYBHNP2Yp/xoKAdXWODF+V
         U6THR6zvuDI4wacwKBY0uCmBGBXrdisAQ/mEbalMc7ph6LMTfB6xLyqAWgrXWLqR+vE6
         tdz5YX+uwnc+rVBwn8UpkXYbX0/9cyqj2xqQOtIgABv5Hs+XtCJPul9zpuVNmXATb+Oq
         XYHG/Fb2n8Ym1bpnAmyfkpXliH7HdMOw5UU0FH1cRxHDrKbTxeoWPEaH5vW9eElje6+s
         gbUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=szXbMfsBdR2LAogQ8vebdSF7PxK4Sa+S3XEKazagktE=;
        b=Q9VEnEx/4YkWmxd0kWfN/WQ3jZxdqC1QxfrCR8mVYGwd0lY+S0vMsHcPS9KI53+9nd
         hbcaYE/RRTAfyuSjPMgiMEU7h6GWIM8lpCzDcZ4/Yokho3jRlTenRnlvSouYu29cSYsM
         iv1NhUbzAx3OVc9QZHuoYHn0NQFAYsssFq0zxF5zsG+3gv32+oLTJJGWbVktZFnDiAd2
         IQGX4W7e5IqlaX6R7NLWRQ9XyxE5B44N6g3/Ap1I8ivz2NOlsQCkfWs/ffGk6Kcny/II
         2T7qy5KVW07+WRul8fsVWLIzlJWFrWdzOTQUYr7Lf/XYSZ3JBhvJ3ep3OMt2HglE1wWd
         WWwg==
X-Gm-Message-State: APjAAAULTtl04egtYdyDAIKubhXgOzJpri29aJMKoRAyLWMOPvKkGVUG
        f6JmnvX2eUH0ZBuhusMnH0cIn2ELokNiJJbAXFBm+bo5+FSKlw==
X-Google-Smtp-Source: APXvYqwI2vmqI9SbIiHLzs+EhBC+5A2+IEb+f/6P75hHytcWAuicMP0Lr2+MvHQmBBWMWb7RO6L1BJki8wGdayw13KA=
X-Received: by 2002:aed:3e87:: with SMTP id n7mr4646575qtf.48.1570636818447;
 Wed, 09 Oct 2019 09:00:18 -0700 (PDT)
MIME-Version: 1.0
From:   Jesse Hathaway <jesse@mbuki-mvuki.org>
Date:   Wed, 9 Oct 2019 11:00:07 -0500
Message-ID: <CANSNSoV1M9stB7CnUcEhsz3FHi4NV_yrBtpYsZ205+rqnvMbvA@mail.gmail.com>
Subject: Race condition in route lookup
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have been experiencing a route lookup race condition on our internet facing
Linux routers. I have been able to reproduce the issue, but would love more
help in isolating the cause.

Looking up a route found in the main table returns `*` rather than the directly
connected interface about once for every 10-20 million requests. From my
reading of the iproute2 source code an asterisk is indicative of the kernel
returning and interface index of 0 rather than the correct directly connected
interface.

This is reproducible with the following bash snippet on 5.4-rc2:

  $ cat route-race
  #!/bin/bash

  # Generate 50 million individual route gets to feed as batch input to `ip`
  function ip-cmds() {
          route_get='route get 192.168.11.142 from 192.168.180.10 iif vlan180'
          for ((i = 0; i < 50000000; i++)); do
                  printf '%s\n' "${route_get}"
          done

  }

  ip-cmds | ip -d -o -batch - | grep -E 'dev \*' | uniq -c

Example output:

  $ ./route-race
        6 unicast 192.168.11.142 from 192.168.180.10 dev * table main
\    cache iif vlan180

These routers have multiple routing tables and are ingesting full BGP routing
tables from multiple ISPs:

  $ ip route show table all | wc -l
  3105543

  $ ip route show table main | wc -l
  54

Please let me know what other information I can provide, thanks in advance,
Jesse Hathaway
