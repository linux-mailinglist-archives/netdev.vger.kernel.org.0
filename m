Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 706FD11F075
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 06:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbfLNF5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 00:57:01 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35283 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfLNF5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 00:57:00 -0500
Received: by mail-pg1-f194.google.com with SMTP id l24so580200pgk.2
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 21:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=kiSMKrKeewPi6GbxYlODKuuV1hP2vrtZpLFrr6ZudA0=;
        b=0XnTdj0p+CIXW81kzGE0P7jwMZFyMlHSXHdmbc2Y2YUVmuNB9i/JkSNRAhctfVipXx
         hKGU3J9etYtGiUH+gsR+2QbgK1zbaWsDqRPqQJoYbi9ZQ2znmaGq/NyQVQSl+VJfE0VA
         Rf+ZX1uqU6CYt+YdTiBgxiTEmVTMpS3op01LK1KD+Ms5crReU4KXVr5I+hULxfbh5WYV
         tfuoKAKFIAmmcbbqPbG9kq40AU7+LlNNopJAH+wmLByvMKpW1u9gxJ+s+wTusDOddaZu
         rJ9XTGPLY8zulrT8LFv4eVOXVobE22h4jjDSU/JdUOo4afpNSac5smZAE5JOWlchnTU7
         guxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=kiSMKrKeewPi6GbxYlODKuuV1hP2vrtZpLFrr6ZudA0=;
        b=o7zf6QG+JPXOr67BPzDZFMYWA0h6wJbLamZEbygjhZBHKQDXFYKAOUC3i4ONLVa5z0
         KUQKJajDmKoYZbSSexxesl5AKOVNV35AOS2QKss/TMC7c8xwZsa7ZeYj8lATWiUT8kOa
         R0cr/rSSKvE6q5LvSmZh5prMNQmTnr12g00IXTMIaskfnMKq9cT66pg4wQQoTy1xKjJv
         it/HQn8FIXM5vGm0MQ7ZZgiPZ98ipF/0D9hCFnpNXpUcx4IMMeP216ZBhAxLaWaG36TN
         qZJt3P0RK1MsaHIJEGumRa04Kx07zfTTq4DMY34Infm3OTvLiCdPZo/VD8CLX+4yFC0Q
         QfBg==
X-Gm-Message-State: APjAAAXA9pCz/r9JB6nmSqgZB2q2RCRm5mqmzwFxzDh8+z3zfdog+Gg4
        ydxHLtpYHVrxRQno9QJ8vJIG9Q==
X-Google-Smtp-Source: APXvYqxJrx31VkET2IAOEwAACFSLAM8r2qjWJ0ZD3Y6fLvj/owHDqnWNN7wLHBBrR9q1cUHmNHBZgg==
X-Received: by 2002:a63:7045:: with SMTP id a5mr3936579pgn.49.1576303020348;
        Fri, 13 Dec 2019 21:57:00 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id x11sm13688610pfn.53.2019.12.13.21.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 21:57:00 -0800 (PST)
Date:   Fri, 13 Dec 2019 21:56:56 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH net] 6pack,mkiss: fix possible deadlock
Message-ID: <20191213215656.716e38be@cakuba.netronome.com>
In-Reply-To: <20191212183213.11396-1-edumazet@google.com>
References: <20191212183213.11396-1-edumazet@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Dec 2019 10:32:13 -0800, Eric Dumazet wrote:
> We got another syzbot report [1] that tells us we must use
> write_lock_irq()/write_unlock_irq() to avoid possible deadlock.

[...]

> Fixes: 6e4e2f811bad ("6pack,mkiss: fix lock inconsistency")

Looks like the commit in question got backported into same 2.6.x 
era stables so I added this one to stable/all queue.

> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Arnd Bergmann <arnd@arndb.de>

Applied, thank you!
