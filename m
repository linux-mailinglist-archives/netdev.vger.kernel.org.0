Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D315A5DBB
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 00:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbfIBWHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 18:07:43 -0400
Received: from mail-io1-f50.google.com ([209.85.166.50]:44739 "EHLO
        mail-io1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727603AbfIBWHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 18:07:43 -0400
Received: by mail-io1-f50.google.com with SMTP id j4so31518013iog.11
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 15:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=oEvieRULttewWyaTSiWpUULjie9Mu4pA0y30GmKhSg4=;
        b=nEf5WglIduL0REvosKWLBe1s7S71pCYjhKHUa19OrDW4NjuUFPCVEi6GD64rax1D/9
         nSKNKrzBe950uoJF3cJBM7XLC6Nqkxwv/aZqTRw1QXXNvptkfsSEwBLW+uGUqjADs3+G
         3dZw1MRS2l1KrxvGkpuFEd6Cu+PjGPfgwslIpzXPk6TK685eYeR40N+4Y5xKbkmuoOtQ
         Sznvi66gb13hrvmTdyAgzrRnGhV6MJ6DsDqolKJ21irVLy1J7wPgai3+MzH0Lrm4xT78
         GtAXTe6pW8b3j0V/5wJzmQ0Bfhi9AQCMnZOR71BKRnTTEfWAosqjRoOr5QvqTIRu8cTI
         T5HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=oEvieRULttewWyaTSiWpUULjie9Mu4pA0y30GmKhSg4=;
        b=Q8dOGT+/xMRMGrPkfCdXvl/H8TXJBGNCzODGVyCzc+18Mv8k6BkZpO7qiqHWqyxImW
         +0m5IvC40SqXtJ7QhlP9GKgjsN+72kO52L/IARDhhSJtDWMuQxJMZYF2fr5mZ3iof2wO
         N1/V4BBvcGNhEA3dbli5bjT28ZhONA4fPEpkK/iKBm9DUvqrl2dvDVJ3j4jwgiwWUzYL
         1neMFJ2O2TZruwKQiIo6gdcRYp7jqL/XHLh6eWmurug/h7ySCIXXwHkQTF0bYq8zZyrr
         ioQbKKQY7/Zgjnox76qW9c01bcdWRWD1xrdg5Q1JAwHaZ9hJuMwrp1nkSA0hQHJpPEbe
         ZsQA==
X-Gm-Message-State: APjAAAU6VxXBSdo8x9R177wVC9H/PXIj0YlPN15oyxJk7Agg1mjBWxcZ
        h5dxtltu1+8aOdCJRGgRgtNjV7byIC3pOugNYbCOT/M8
X-Google-Smtp-Source: APXvYqz27Wv1kFCc/6Gnjf8qo8E9tceeXTJnEC96BkHcRugyiBPnvMbvh2Cdw7+O79z0PEHT77y0pSqgqM1f3j9WOWk=
X-Received: by 2002:a02:716a:: with SMTP id n42mr7997488jaf.38.1567462062520;
 Mon, 02 Sep 2019 15:07:42 -0700 (PDT)
MIME-Version: 1.0
From:   Dave Taht <dave.taht@gmail.com>
Date:   Mon, 2 Sep 2019 15:07:31 -0700
Message-ID: <CAA93jw73AJMwLL+6cNLB2R6oqA2DyMYc1ZUsrFPndESs0ZONng@mail.gmail.com>
Subject: how to search for the best route from userspace in netlink?
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Windows has the "RtmGetMostSpecificDestination" call:
https://docs.microsoft.com/en-us/windows/win32/rras/search-for-the-best-rou=
te

In particular, I wanted to search for the best route, AND pick up the
PMTU from that (if it existed)
for older UDP applications like dnssec[1] and newer ones like QUIC[2].
The alternatives, which
basically include probing perpetually and/or picking really low
values, seem increasingly less than
optimal.

Put in a wrapper around bpf[3]'s lpm calls? Create a new netlink message?

[1] https://github.com/dns-violations/dnsflagday/issues/125
[2] https://tools.ietf.org/html/draft-ietf-quic-transport-22#section-14.1
[3] https://github.com/torvalds/linux/blob/master/kernel/bpf/lpm_trie.c#L16=
4

--=20

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-205-9740
