Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C15722BCC8
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 03:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbfE1BRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 21:17:49 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43707 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727271AbfE1BRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 21:17:48 -0400
Received: by mail-pl1-f195.google.com with SMTP id gn7so7578569plb.10
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 18:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ijI272WZY2aX1w5JkhA+Zc33AK5GeibsSemPmnxCISY=;
        b=JI9vt3oTgSoUPnEAwBWYZ6hBZWg0aJ7cfRqmDJso4DNcjlAHzXN5VN0XzrwQvKy+eE
         jjR6xkiRtiQGygWJMeZJtBAUuQgiSw89sZtcATPviV+PtmCL+FZGVVPnW1cKdUSlE/+G
         SWcxUMFXQIEyKp5aW4Ep452eih+RPACKands5dzbQOJEFD3FzpOpB100oC/QkdAA5p+N
         Ndk4ebBdFpul3kNTYUNae8196HOzbydq+BM4Mq78pinaAHV6/2cF53LnYHG8zlsxXj6Y
         t89uKfZK/p8G+DSPFghVC9S51XEvUYJ/nO8fy6ZpN2j9V4RwC5a7WQs8mXfIGqAPhInH
         Fgmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ijI272WZY2aX1w5JkhA+Zc33AK5GeibsSemPmnxCISY=;
        b=bpIlGf4vwg8Gc295Hgvnqg/04XbpcK4RKEtom9CsjkxMmdFZGMT44nH4Xwv4tjDlY3
         71Ky4FgxUfg/OXfwBLnlvxWbg87SKh2nZ/62mtIr1yaY3v3uKWhp2FXYW9maT5+3DCiT
         0U24DD+EqyAXSQDKgFYh+2WVU9ztiodaLoS20Yu5hfk4ma773OrmEcXg4mLzLfjwI2qS
         8Ap6XmpSjyyR4j0yaFJ7tyEP0yZkbgRmNiICy9Mqvk6H385qGL7ThugysWJCUAoD1jAe
         Cx6vRie/nG6qwKqy96g+JGJhw9akhm/PogUPHM3kl6841pX5bJUAT4ZNf8N0w+j9eyeY
         YyiQ==
X-Gm-Message-State: APjAAAUZXCX3O7ZN+ljEs2SXK2BBKpqz+p8ayIQ2hC3Cb2UnQNyo9kbz
        cI7VZEApk+MTrcTLUL4t98m3Rg==
X-Google-Smtp-Source: APXvYqzcdyp+z4xSQk9fj45gFuSlS7y9Rptx7FxN9qyfQ7XHfrATfNlSn2z6giiv5tYkqyu4mOvGMg==
X-Received: by 2002:a17:902:b606:: with SMTP id b6mr133610170pls.100.1559006268153;
        Mon, 27 May 2019 18:17:48 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id v4sm13854552pff.45.2019.05.27.18.17.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 May 2019 18:17:47 -0700 (PDT)
Date:   Mon, 27 May 2019 18:17:44 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     <davem@davemloft.net>, <hkallweit1@gmail.com>,
        <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>
Subject: Re: [PATCH net-next] net: link_watch: prevent starvation when
 processing linkwatch wq
Message-ID: <20190527181744.289c4b2f@hermes.lan>
In-Reply-To: <a0fe690b-2bfa-7d1a-40c5-5fb95cf57d0b@huawei.com>
References: <1558921674-158349-1-git-send-email-linyunsheng@huawei.com>
        <20190527075838.5a65abf9@hermes.lan>
        <a0fe690b-2bfa-7d1a-40c5-5fb95cf57d0b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 May 2019 09:04:18 +0800
Yunsheng Lin <linyunsheng@huawei.com> wrote:

> On 2019/5/27 22:58, Stephen Hemminger wrote:
> > On Mon, 27 May 2019 09:47:54 +0800
> > Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >   
> >> When user has configured a large number of virtual netdev, such
> >> as 4K vlans, the carrier on/off operation of the real netdev
> >> will also cause it's virtual netdev's link state to be processed
> >> in linkwatch. Currently, the processing is done in a work queue,
> >> which may cause worker starvation problem for other work queue.
> >>
> >> This patch releases the cpu when link watch worker has processed
> >> a fixed number of netdev' link watch event, and schedule the
> >> work queue again when there is still link watch event remaining.
> >>
> >> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>  
> > 
> > Why not put link watch in its own workqueue so it is scheduled
> > separately from the system workqueue?  
> 
> From testing and debuging, the workqueue runs on the cpu where the
> workqueue is schedule when using normal workqueue, even using its
> own workqueue instead of system workqueue. So if the cpu is busy
> processing the linkwatch event, it is not able to process other
> workqueue' work when the workqueue is scheduled on the same cpu.
> 
> Using unbound workqueue may solve the cpu starvation problem.
> But the __linkwatch_run_queue is called with rtnl_lock, so if it
> takes a lot time to process, other need to take the rtnl_lock may
> not be able to move forward.

Agree with the starvation issue. My cocern is that large number of
events that end up being delayed would impact things that are actually
watching for link events (like routing daemons).

It probably would be not accepted to do rtnl_unlock/sched_yield/rtnl_lock
in the loop, but that is another alternative.


