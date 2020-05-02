Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3FD1C22B4
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 06:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgEBEM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 00:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726435AbgEBEM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 00:12:27 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7501C061A0C
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 21:12:26 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id e17so9564461qtp.7
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 21:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=AzOwTGLCqsoxcos1rC36ROn5pWK/vWwfcPGTzajxF68=;
        b=kf2yU7BsKbHqzFcVVJurq2/7ijIg6XVB+iwt2JTUEy76OXGB4gpE+VVijMuiRfKM7c
         xw9fpS3AerfR9/Z1YpZHd1X3sAbEpO4DlPE2CMHC0ZrkXb/ExGyMcqxK+VC66cx8LFLW
         kRC23+eMoFlPS8/d0Np6dfiuYsQkWrsQfpb1LLVj1o+ZeOZwmryFS3HgAS23YPGv4xAZ
         XCkkGiiep+y/PkA7p2cCbfRfjyXdrXA91XOVDSxw+NOEf1FH9QJU8dTt3IuHcP002Vl6
         kqYxbsPinAZ//7Bd2Z43slseZJ24TpZAFdQQSfWfcuE1JCsBM4ei2I+V8c3/qdnbbYbz
         hhgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=AzOwTGLCqsoxcos1rC36ROn5pWK/vWwfcPGTzajxF68=;
        b=ob7uT/DecbHC1Bxodhr0+e+jkAvyxMmSv/27pH9TSN7+PMC/QoafB6v4x/wzYleaca
         sDZ5Ygtk5FshhHrWWq69WJkPMVssmaSjZj14q3KOt6Kpz0HZxkLz/Fzxq8PT7suiro/U
         UYTXgpw5NPu6wktviCyLxZoPjKZdxDQOcfRzcEyXlRAtIyr5D5uNp3fXoSUei71mxy8y
         bNZ/41UVDJeYfSXvLKQg1w0mqEeAfLLNHXTyvHOQQJQrfJ56Uc9zQ6mNvO2RUHXmjgUe
         3uuX4E8NVrvH0eHQKXouQ9EKyckj8A0fLssAmbE7utWQ/HnsNjimPeZFBJiNsEf78jQ2
         61DQ==
X-Gm-Message-State: AGi0PuaB1wBtAQhtsBhU+cfju2TsuWfw1SXiyP/F7Ls5dDGeCezqQhrW
        SXzxMiWuSFohv/VEq9aMjJOkTw==
X-Google-Smtp-Source: APiQypLPkWWge7EXckbKA9YVakIfE03lfFAsJz99G06idEV0NvoYOvjA5KdUvBzLII+eZqBDJlak7Q==
X-Received: by 2002:aed:34c3:: with SMTP id x61mr6579161qtd.333.1588392746111;
        Fri, 01 May 2020 21:12:26 -0700 (PDT)
Received: from [192.168.1.183] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id y10sm4300219qki.63.2020.05.01.21.12.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2020 21:12:25 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
From:   Qian Cai <cai@lca.pw>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] net: fix memory leaks in flush_backlog() with RPS
Date:   Sat, 2 May 2020 00:12:24 -0400
Message-Id: <C9E5387E-6241-4CB3-B3F2-9CA575920569@lca.pw>
References: <8a012879-825f-596d-9866-0dd3a095dfbb@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <8a012879-825f-596d-9866-0dd3a095dfbb@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
X-Mailer: iPhone Mail (17D50)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 1, 2020, at 11:32 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>=20
> kfree_skb() is supposed to call skb_dst_drop() (look in skb_release_head_s=
tate())
>=20
> If you think about it, we would have hundreds of similar bugs if this was n=
ot the case.

Thanks for quick response. Funny thing is that once I applied this patch, th=
e leaks went away. It could be the fuzzers do not always reproduce the leaks=
 or it could be that call_rcu() in skb_dst_drop() takes a long time waiting f=
or grace periods which may confuse kmemleak because skb has already gone.=
