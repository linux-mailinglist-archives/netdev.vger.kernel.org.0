Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32ACA19DE2E
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 20:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgDCSov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 14:44:51 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45743 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgDCSov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 14:44:51 -0400
Received: by mail-qt1-f193.google.com with SMTP id 71so521708qtc.12
        for <netdev@vger.kernel.org>; Fri, 03 Apr 2020 11:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=TqHAThx6007dar1GotjNvl0jgie22ofWFMk8sjVFkt0=;
        b=TawJf5ziKXZi80UFdLDpvBrTwXNhgoShUGOkTizAOXGnxnvnmTlMPkNlgkwP9cNAuR
         v5L/KOCdGuFE3ILDt51oaGz5wB+kclxJ3f47CsxI1t8CWptWeRADb/NO7FOemU0RjhKv
         NHwhKt4QvGWgk/Q9EdlsdJh7xb3bwM6eLOmq5K/HGs7v/rDdCM+IkhrliiUcEozhgnhJ
         DR6mPW8/5SMQqyy78XgY1z8SC/QsHK+7gu6qfwyo66hjO2gwmyleOD9MzgTbrZzXsaHd
         7XVlW5ViftpD6nYqDG13X7/syKSacRgirNfdUopqX/QmibINHuiyuCe7bIwAovH6Wrrq
         mYfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=TqHAThx6007dar1GotjNvl0jgie22ofWFMk8sjVFkt0=;
        b=IhXoKQIDGLdOb3JDFnYjC/CPokrR+jX0qh17ubEOGZW8sBDcQ0RAfy34GYoAW2z1oe
         J+bFgLbiuJpfR/etw5ecSKfL21WMuO5MrNaui0tSoBw9SKa4CKKTwes7r8Ux2FkAW+hG
         JAjFxQLyGIMidK2bvxvCmttAnHfbfEZTONRIqt2cdxrv3ZECb7i6GmXHPQtbmi884ANz
         +blFcTyl7fGK72E4UnesR9LXa+dYrh5U6WBsIXWtTzYxzrUa2ft5b1Gtblf/rpsNJNYD
         KfgH7I9uLYS397Cuzp+eRd3I2fCkLFoNyUL4wd3KdSZyrNnlvc3DH1a3BWNb+qdNtxCQ
         MuUQ==
X-Gm-Message-State: AGi0PubHIApbJT25jLPYSylhFB44nhi6BozcJKC4SdgqfxGAywNv452G
        bw2FR0nC3SQD41D4MlbziVNJbiwWXVcsIf4YHTQncUHuqro=
X-Google-Smtp-Source: APiQypJmUGY+r+3bM7bsZjQVLpQVKHH/eZpaMSnhILP/mYVNccs0598yrDdXM0a2eaGilNojTn/XQOZILpAm+O4wrPc=
X-Received: by 2002:ac8:191d:: with SMTP id t29mr9961415qtj.40.1585939489914;
 Fri, 03 Apr 2020 11:44:49 -0700 (PDT)
MIME-Version: 1.0
From:   "Alexander E. Patrakov" <patrakov@gmail.com>
Date:   Fri, 3 Apr 2020 23:44:39 +0500
Message-ID: <CAN_LGv1h8Ut4bGm7ZgYaGV_Tbdy3ABW+epb_p6jeX=TxnAvH1g@mail.gmail.com>
Subject: tc-cake(8) needs to explain a common mistake
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

there is a recurring cargo cult pattern in many forums (e.g. OpenWRT):
people keep suggesting various overhead compensation parameters to
tc-cake without checking what's the bottleneck. They just assume that
it is always related to the link-layer technology of the connection.

This assumption is mostly incorrect, and this needs to be explained in
the manual page to stop the cargo cult. E.g., here in Russia, in the
past year, I had a 1Gbit/s link (1000BASE-X) but they shaped my
connection down to 500 Mbit/s because that's the bandwidth that I paid
for. I.e. the link from my router to the ISP equipment was not the
bottleneck, it was the ISP's shaper.

How about the following addition to the tc-cake(8) manual page, just
before "Manual Overhead Specification"? Feel free to edit.

General considerations
-------------------------------

Do not blindly set the overhead compensation parameters to match the
internet connection link type and protocols running on it. Doing so
makes sense only if that link (and not something further in the path,
like the ISP's shaper) is indeed the bottleneck.

Example 1: the ADSL modem connects at 18 Mbit/s, but the ISP further
throttles the speed to 15 Mbit/s because that's what the user pays
for, and does so with a shaper that has bufferbloat. Then, the "adsl"
keyword is likely not appropriate, because the ISP's shaper operates
on the IP level. The bandwidth needs to be set slightly below 15
Mbit/s.

Example 2: the ADSL modem connects at 18 Mbit/s, and the user pays for
"as fast as the modem can get" connection. Then, the "adsl" keyword is
relevant, and the bandwidth needs to be set to 18 Mbit/s.

Example 3: the user has a 100BASE-TX Ethernet connection, and pays for
the full 100 Mbit/s bandwidth (i.e. there is no shaper further up).
Then, the "ethernet" keyword is relevant, and the bandwidth needs to
be set to 100 Mbit/s.

-- 
Alexander E. Patrakov
CV: http://pc.cd/PLz7
