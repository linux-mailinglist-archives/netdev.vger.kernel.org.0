Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6FDF752D
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 14:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfKKNix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 08:38:53 -0500
Received: from mail-qt1-f173.google.com ([209.85.160.173]:33427 "EHLO
        mail-qt1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfKKNix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 08:38:53 -0500
Received: by mail-qt1-f173.google.com with SMTP id y39so15720945qty.0
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 05:38:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=9gVkEC4Vh14UpD5HeOkrK5zoMkOeXjP7j0E0JMbqfXM=;
        b=szyZzMg1YZ1U2Z5eY4WAs5muhSvK7k2LAYx79bNELC8coS/A7OjSi0GcKPU69jut8y
         V6xvluvYY+Hebk37SXbjCd1Ow4xkyn5UzJRuNGYG2hAM1IlkrYSLPnoZJoa4xRQzdo9I
         1/fSwuVJWVKK0cSNW8BI4EqnBT31RIlvbRA8CYBE4nB22QrDNbY8j+QNWErY9fQANzVG
         w5cmMzZuQI2Zy7ibdJNlc8Tdb6zHiSns0bBPWhG+Z/mHtu9uVmqXJt7GWDGrKjvTtHjq
         bmzHtFRabWtFeXHuBM1AH9VBuYpmXIGo0BgSWPtMjnq9fifdIwu0EY0xCs8VeLnDQFxn
         gA+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=9gVkEC4Vh14UpD5HeOkrK5zoMkOeXjP7j0E0JMbqfXM=;
        b=Z217CfP+1BNSzxRTtVqwTogPTL2SOTpw+GBHUE6M76kZLK2xMH6ATZkRsRpakLdI+a
         7dLGq6qmALoYZFqXP76ZWlk43CVsm2t+419hBU6drUTXaFf7vf/eDRF6D5cj2wgx2fPe
         CVDBolIrCmq5VhG95E6IAd7T1Bx7Fr1n/CBJjv5itswIMqr5vsUcQzkoQmMLVwft1oX2
         wnK3WN5u5bTfqQoSWlwJqv8MWoOZAIt8tckvfNLYWZNN9m4ICYW6LblUjyBehuwV+K2Y
         C95AQ9hGYSqLtlN3YBOkSeKLG4msVivxL5sRYKPpEc32exKNoAIMgeP0R/u+Qql+a+bS
         zjeg==
X-Gm-Message-State: APjAAAXfZnLFuhbxQsYgWSByPQ3nbQ1eBNvVnDczyCDB7l6NKgF5DQjL
        dK4RZ5VuSahZR1iQHjKY0nwVUU199N2X1yMRcp0UcL3nb7E=
X-Google-Smtp-Source: APXvYqzmxwRD2WtsDL5Pt3yaqF3mFSpxvD1dZrBCNs0CX3e1LqIONti/6EwUxiUT3/tDdK25BHiR2pEUH1Jby42qm74=
X-Received: by 2002:ac8:1b85:: with SMTP id z5mr25890219qtj.308.1573479531963;
 Mon, 11 Nov 2019 05:38:51 -0800 (PST)
MIME-Version: 1.0
From:   Adeel Sharif <madeel.sharif@googlemail.com>
Date:   Mon, 11 Nov 2019 14:38:42 +0100
Message-ID: <CABT=TjGqD3wRBBJycSdWubYROtHRPCBNq1zCdOHNFcxPzLRyWw@mail.gmail.com>
Subject: Unix domain socket missing error code
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

We are a group of people working on making Linux safe for everyone. In
hope of doing that I started testing the System Calls. The one I am
currently working on is send/write.

If send() is used to send datagrams on unix socket and the receiver
has stopped receiving, but still connected, there is a high
possibility that Linux kernel could eat up the whole system memory.
Although there is a system wide limit on write memory from wmem_max
parameter but this is sometimes also increased to system momory size
in order to avoid packet drops.

After having a look in the kernel implementation of
unix_dgram_sendmsg() it is obvious that user buffers are copied into
kernel socket buffers and they are queued to a linked list. This list
is growing without any limits. Although there is a qlen parameter but
it is never used to impose a limit on it. Could we perhaps impose a
limit on it and return an error with errcode Queue_Full or something
instead?

I don't know who is the maintainer of unix sockets. If someone knows
please let me know and I will discuss with him further.

Thank You.
