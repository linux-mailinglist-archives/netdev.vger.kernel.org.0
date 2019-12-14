Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA7311F35E
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 19:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbfLNSGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 13:06:23 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42207 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfLNSGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 13:06:22 -0500
Received: by mail-pg1-f196.google.com with SMTP id s64so1189199pgb.9
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 10:06:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=0BzzmaRQHk7dY7mKdZbSshYUrQJqQArDrD3+ZPp1uv4=;
        b=zZe0fuPUn1tPKYrXwy4PU2GCcrRgmH7Lx9xVjhdfqJmBXqOkMOsngrxn3ypIGL0nTn
         NIZzg5cPdpHNBtplT3djo+raWZ4qSJAAoa0TDXeW+bkebdz+cq0mrSPuavcK6VH/78y6
         v1CHm9MnAJtH56pHUE2rV1FZ98lfM9ZWbzS4vozJO4VdWnV0KGzrdc3n61HrBTXWlCrI
         iiBTg8qUyZYdND52dj6X59bOzFXZWG7hIheJTUBd3O4qMcC0eIouO4xLUynbwpl8D/qO
         IEo2aQTGquPMRldyxmeLp4h2MzE9HUc6AU4pGcP6JJ1uApIpVB/7HaBSLFt1IEwqClGu
         KAhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=0BzzmaRQHk7dY7mKdZbSshYUrQJqQArDrD3+ZPp1uv4=;
        b=M398A8FDchSh79hbMWHTqd+Z05xjEaj7RtJo7B0NrVfen/4I3SZpoL7t2MDa0vdBPz
         Y5ngUwRmEUQxPbMvFXPIEo+NHFIcfROofrG9Vqg6UzH/452+CGPcmeBOcj3pa2H5s8xP
         VvZJcqpvNOwlzsVVnTxFdCM68weqxz87pCBZ0IBANPctXcP0RLHcL7KfX6qw/ePFXpHE
         IlaYiZ9tHI+KZanRRt1Yuut9P7jBMDYFNKgV1A7JWC0AmlugTW8M496kVt68PzFkd5Lz
         hrZW1jVkUrMJ4//wba9tLWHcNGHBveuaPElHUcENLq26Zrjf6Cj1rwkBXVUtMdDWy1k3
         F1IQ==
X-Gm-Message-State: APjAAAXqUYlLxxEZ7sebgFczF87lJSrAizl6+23N0r6p09cqycKo6z6+
        Tg7Ge6fthJfed6UZfXaMMBoVFA==
X-Google-Smtp-Source: APXvYqwVRVrmYmG2SxV888pFUdDL0+dPTb6SlhwAGaow4seEJy+YEOI96AlmjYoP4qX0cnsBVGA5KA==
X-Received: by 2002:a63:2ad8:: with SMTP id q207mr6816368pgq.45.1576346782062;
        Sat, 14 Dec 2019 10:06:22 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id p16sm15272496pgi.50.2019.12.14.10.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 10:06:21 -0800 (PST)
Date:   Sat, 14 Dec 2019 10:06:18 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Jason Baron <jbaron@akamai.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net 0/3] tcp: take care of empty skbs in write queue
Message-ID: <20191214100618.43e39031@cakuba.netronome.com>
In-Reply-To: <20191212205531.213908-1-edumazet@google.com>
References: <20191212205531.213908-1-edumazet@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Dec 2019 12:55:28 -0800, Eric Dumazet wrote:
> We understood recently that TCP sockets could have an empty
> skb at the tail of the write queue, leading to various problems.
> 
> This patch series :
> 
> 1) Make sure we do not send an empty packet since this
>    was unintended and causing crashes in old kernels.
> 
> 2) Change tcp_write_queue_empty() to not be fooled by
>    the presence of an empty skb.
> 
> 3) Fix a bug that could trigger suboptimal epoll()
>    application behavior under memory pressure.

Applied, thank you!

I've only queued patch 1 for stable/all, please let me know if I should
also queue 2 and/or 3.
