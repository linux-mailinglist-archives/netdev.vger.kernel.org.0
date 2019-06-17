Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED37489CF
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 19:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfFQRPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 13:15:05 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42216 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfFQRPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 13:15:05 -0400
Received: by mail-pg1-f194.google.com with SMTP id l19so6158175pgh.9
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 10:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=u3DYi4uMVuOh5kCk1w5xLbtHzFmVEUXY2eL3dhMZabE=;
        b=ponQyp9Zcpbgy5Yc0Y0QMdiH5bC4U/Dmp6aY1jM9kWqyRYa5ukPyHLFh0WIKu4Ihmn
         5/HxxeMi37zUYGLbMlZFMsCg3gdljYXe7g7z8g4X5Ho3NDIeLdz7GaK9B+yDhOB2IzWH
         7GKwmbDKuwDAmT9nI/j6nWSw3HGMXgdFUOqtqxR8DoO25N+AFuUvMolI4wMgHWUqZfBf
         iMx4rvCm2X6D4Z9+y2QLxMOfvLP+CViJvMZn5Ql3canSJzzRkpRshuoen0mLyorn3VpS
         YtwQgbJKL3kz4M96mbcPBX3mhGqcTI1jL4LFdjVXVO1ghG2AkypotYuVyuG4181+sOHd
         gD/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=u3DYi4uMVuOh5kCk1w5xLbtHzFmVEUXY2eL3dhMZabE=;
        b=aUcYCLrwqEtu9y9j2tehws/UkSOSIbyPzBSzctAuBzAHMFmXELe5e/UNXYKeU+q8Tz
         muOn28Ts8cVE3lDVzs+A6X6cGJ038sYZsDabdZXgo5t644sxqDDfVlSA/LIJ64LtDcEt
         2jSniTAnBbBEFMxc/2A02+8VXF9L3UE7+iby8y2gpaU6vXIryQP1qnuNAmBwdVzZVMYU
         HG+raKeGRenXd+0Qikcokmspz9eox5kuH5KN6ZEYSaM85pbB30MG4CHLGogGG7qyy0HK
         3l8TqtdyjPPWJOJPT9x1qyMk3TQJkM+6SJKLYTUroERQMbUWh/T6dlZb6Mcwmy7GFaB3
         rZvA==
X-Gm-Message-State: APjAAAWg/uVLo3SN50tZJ1QnGyT1q6CTaEpphOrPkCm0HhJlukVgwCol
        ZhQWu2FEbj2/kDLzkGKIwc0=
X-Google-Smtp-Source: APXvYqxkbZmlVTgqCwr2OygWSXSXmiJEnD5s51tfA3xSL/5WZfwXu8tekx/3lG5+zE32Qh0vBmNzfQ==
X-Received: by 2002:aa7:9190:: with SMTP id x16mr101823698pfa.86.1560791696732;
        Mon, 17 Jun 2019 10:14:56 -0700 (PDT)
Received: from [172.26.125.68] ([2620:10d:c090:180::1:e1dd])
        by smtp.gmail.com with ESMTPSA id 132sm12523758pfw.124.2019.06.17.10.14.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 10:14:56 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Eric Dumazet" <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Jonathan Looney" <jtl@netflix.com>,
        "Neal Cardwell" <ncardwell@google.com>,
        "Tyler Hicks" <tyhicks@canonical.com>,
        "Yuchung Cheng" <ycheng@google.com>,
        "Bruce Curtis" <brucec@netflix.com>
Subject: Re: [PATCH net 2/4] tcp: tcp_fragment() should apply sane memory
 limits
Date:   Mon, 17 Jun 2019 10:14:55 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <22211F2C-7381-4548-A3C6-E3AA097C9011@gmail.com>
In-Reply-To: <20190617170354.37770-3-edumazet@google.com>
References: <20190617170354.37770-1-edumazet@google.com>
 <20190617170354.37770-3-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17 Jun 2019, at 10:03, Eric Dumazet wrote:

> Jonathan Looney reported that a malicious peer can force a sender
> to fragment its retransmit queue into tiny skbs, inflating memory
> usage and/or overflow 32bit counters.
>
> TCP allows an application to queue up to sk_sndbuf bytes,
> so we need to give some allowance for non malicious splitting
> of retransmit queue.
>
> A new SNMP counter is added to monitor how many times TCP
> did not allow to split an skb if the allowance was exceeded.
>
> Note that this counter might increase in the case applications
> use SO_SNDBUF socket option to lower sk_sndbuf.
>
> CVE-2019-11478 : tcp_fragment, prevent fragmenting a packet when the
> 	socket is already using more than half the allowed space
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Jonathan Looney <jtl@netflix.com>
> Acked-by: Neal Cardwell <ncardwell@google.com>
> Acked-by: Yuchung Cheng <ycheng@google.com>
> Reviewed-by: Tyler Hicks <tyhicks@canonical.com>
> Cc: Bruce Curtis <brucec@netflix.com>
> Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
