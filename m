Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC4ADBDA25
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 10:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442906AbfIYIqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 04:46:18 -0400
Received: from mail-qt1-f178.google.com ([209.85.160.178]:45909 "EHLO
        mail-qt1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2442828AbfIYIqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 04:46:16 -0400
Received: by mail-qt1-f178.google.com with SMTP id c21so5573662qtj.12
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 01:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=MbfeX/GMfh5hA7rH8kpzu5Epqbv27eBo89xQdba1k4I=;
        b=xVy0D3aTi6XWzdkR977ldVA2e9uT2CQ21onmz6h1FJFHDptBfAachZZ9gW19BnMeRf
         ITtnS+UFMKGNeE/lryxLLtZwoUYL0roOL/tQZRHNc0q0z4fuIoUePxEM7pIV+5XQnUp0
         8ca2u10tUlaAlv56W4+hVrhZBS/UXT42il+TU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=MbfeX/GMfh5hA7rH8kpzu5Epqbv27eBo89xQdba1k4I=;
        b=T90f8+zqq4sWrQDvMj9wjpLqyHMH0N51xiPcRJaIkq3Hro0gnuW3JTCeUcc0ek3wY8
         R8BMu+LCyacQPZOn48DuFvPVMbmqTbp4i21f6uPYnsk6mAIWGinmL6DUaBScaPVib7o0
         uDJLZqx7K8AuYu5JfW0qbzQLKsEZExIy2lcO0+WSDnHAMtQaK1pgZWut4P4N6EjWtty9
         gYnVkpLHnJg6DUjelC3KCWbMLDwWiNVJJlcGN/hJT+q6aJFSZ8A1vT4QHMaMl2WS0+RO
         byCeDzBbSbaHmZl0GJcj/pB+j0+ta4fJGs+5zeJOuUJZQjXg4kH0X45snQntwMJTyXJw
         ye8Q==
X-Gm-Message-State: APjAAAXFMfDHy6NkPBf0zY53MhZY1ORbXYAQcFlGY53ACfEKU+huu/gS
        TsOp9JIQMX4vIJ/RDV8WKXC4imstrx+QThJto9HWeSBK2wvzocwK
X-Google-Smtp-Source: APXvYqz4EN+9yMEkD+b9dSoRxlY1VyefqfOedjRrILZarwvEs5sJ0AuIuTWcoYAgSxLMH32fJi01knxSHZGohLQnYj4=
X-Received: by 2002:ac8:7646:: with SMTP id i6mr7681296qtr.50.1569401175041;
 Wed, 25 Sep 2019 01:46:15 -0700 (PDT)
MIME-Version: 1.0
From:   Marek Majkowski <marek@cloudflare.com>
Date:   Wed, 25 Sep 2019 10:46:03 +0200
Message-ID: <CAJPywTL0PiesEwiRWHdJr0Te_rqZ62TXbgOtuz7NTYmQksE_7w@mail.gmail.com>
Subject: TCP_USER_TIMEOUT, SYN-SENT and tcp_syn_retries
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello my favorite mailing list!

Recently I've been looking into TCP_USER_TIMEOUT and noticed some
strange behaviour on fresh sockets in SYN-SENT state. Full writeup:
https://blog.cloudflare.com/when-tcp-sockets-refuse-to-die/

Here's a reproducer. It does a simple thing: sets TCP_USER_TIMEOUT and
does connect() to a blackholed IP:

$ wget https://gist.githubusercontent.com/majek/b4ad53c5795b226d62fad1fa4a87151a/raw/cbb928cb99cd6c5aa9f73ba2d3bc0aef22fbc2bf/user-timeout-and-syn.py

$ sudo python3 user-timeout-and-syn.py
00:00.000000 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
00:01.007053 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
00:03.023051 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
00:05.007096 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
00:05.015037 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
00:05.023020 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
00:05.034983 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]

The connect() times out with ETIMEDOUT after 5 seconds - as intended.
But Linux (5.3.0-rc3) does something weird on the network - it sends
remaining tcp_syn_retries packets aligned to the 5s mark.

In other words: with TCP_USER_TIMEOUT we are sending spurious SYN
packets on a timeout.

For the record, the man page doesn't define what TCP_USER_TIMEOUT does
on SYN-SENT state.

Cheers,
Marek
