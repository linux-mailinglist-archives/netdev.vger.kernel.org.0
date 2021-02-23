Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E510E3228A2
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 11:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhBWKLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 05:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbhBWKKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 05:10:02 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA48C06174A
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 02:09:22 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id v1so21939837wrd.6
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 02:09:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=Zpn4/OL9TJKNrbs4LipiyolOikq4TwW8BK7YEdmgqBA=;
        b=cdwDIVJ0K8KBxIEamn7tW/JSUCBZ5WeWzuAzDZGo9RladhLgXM6rVgIlgHCjMciC5Q
         wNd8u/NPXILt7e3KgTPkzdNuTvUkCmski7Cd/QcoWWjBDMSTvF84immq0Z3AUZeWZ6Rt
         TBx0M6xThcx067kaBNL4NnEG5gZmH0UgQrY9WpDDPq0hwJORSI8oZCo1CIeTnQLgLD7w
         /7dUGNf7y6ANyB+egGEx758l1jJozWauFotcKckc1fIP7bYWtGjFi11xCeV3YRy31YVN
         HJiMLh+hsRPncYye1Rzd+Abmyc8yvrYBlxYOcJ1VdTRSBgJu8bq10taU5Cs9++myvO8D
         C0tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=Zpn4/OL9TJKNrbs4LipiyolOikq4TwW8BK7YEdmgqBA=;
        b=T9u++6J5LDsxYE59Epsx3NAyHj2p92IbBfa+T5bvdjm6hSLyN6B7FChoLKlUNGLd9s
         qTruT/p7PZZT5PT8RNzMdiZz9H01zK9JyDd3FqAeuwZ3a+DuNq3giGIIakV/klbDrXBm
         7923csRrtMGxIveZEFQwYk2f5njZrDNoi4cnDSwMSGTlwK/JiByf2UFurEhgOewnF2XW
         bmP+DfHjkayv3e/dIC6QgauWz057Wur6+Bjw4lcLCMLUbdjZtniDFUUlZnTLLEc+yPiK
         Wzq/GW1z9DtdhrhlhsHYyAh+UVgP9jXh4AaI3YwwfRB/sVeWRATOzWQxYUgLaBhb1Dcu
         KHzw==
X-Gm-Message-State: AOAM533Fdr1k5eWYO0UvIZm2FuXAcC1XoZ9LJS8dzcXKHsJOTuUIQSP3
        bXYzx/9iS2MfqgiME4NC+uw=
X-Google-Smtp-Source: ABdhPJwc2gRe3RK25MbrIaBkZpLUQineOHNFwZfNLYaS7NtB02/dF9lxIYE+KcS6R3Y7Rf7HXNfdrA==
X-Received: by 2002:adf:d850:: with SMTP id k16mr23319093wrl.10.1614074961055;
        Tue, 23 Feb 2021 02:09:21 -0800 (PST)
Received: from silmaril.home ([188.120.85.11])
        by smtp.gmail.com with ESMTPSA id s11sm2176416wme.22.2021.02.23.02.09.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Feb 2021 02:09:20 -0800 (PST)
From:   Gil Pedersen <kanongil@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: TCP stall issue
Message-Id: <35A4DDAA-7E8D-43CB-A1F5-D1E46A4ED42E@gmail.com>
Date:   Tue, 23 Feb 2021 11:09:19 +0100
Cc:     netdev@vger.kernel.org
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I am investigating a TCP stall that can occur when sending to an Android =
device (kernel 4.9.148) from an Ubuntu server running kernel 5.11.0.

The issue seems to be that RACK is not applied when a D-SACK (with SACK) =
is received on the server after an RTO re-transmission (CA_Loss state). =
Here the re-transmitted segment is considered to be already delivered =
and loss undo logic is applied. Then nothing is re-transmitted until the =
next RTO, where the next segment is sent and the same thing happens =
again. The causes the retransmitted segments to be delivered at a rate =
of ~1 per second, so a burst loss of eg. 20 segments cause a 20+ second =
stall. I would expect RACK to kick in long before this happens.

Note the D-SACK should not be considered spurious, as the TSecr value =
matches the re-transmission TSval.

Also, the Android receiver is definitely sending strange D-SACKs that =
does not properly advance the ACK number to include received segments. =
However, I can't control it and need to fix it on the server by quickly =
re-transmitting the segments. The connection itself is functional. If =
the client makes a request to the server in this state, it can respond =
and the client will receive any segments sent in reply.

I can see from counters that TcpExtTCPLossUndo & TcpExtTCPSackFailures =
are incremented on the server when this happens.
The issue appears both with F-RTO enabled and disabled. Also appears =
both with BBR and RENO.

Any idea of why this happens, or suggestions on how to debug the issue =
further?

/Gil=
