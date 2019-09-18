Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91AF8B6F75
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 00:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731903AbfIRWuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 18:50:22 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40164 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727231AbfIRWuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 18:50:22 -0400
Received: by mail-pg1-f193.google.com with SMTP id w10so690261pgj.7
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 15:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xYPg8sgD1/nhd+0McGhuQVxOX0ZGdJ7nAqpNcljwLLw=;
        b=DdDCpzo6cnPp8BOrcUO7348AjMVB6gJNWuUw/UMUizwiDRLM8mQm9tOHJXwW4F8OP+
         uCfsmgwBsNHmqL3nX+mwHOMLNEpzgrI6SoMmP0f039fl8dExBVgSDc2HNXE4YpfyDxkO
         utIx4NfLQGU4wNNqvRI0AY2kY5NzStn/WOYrFGwO7FgdBbmTulNRxfNwxFm4NkMXsxVQ
         pYLyoAoKBAhMPHKRfZT8XDxfmPbt8JjUlGgUvShI1dEm3QgEwROJjLUoJA/qw5PZ3sfg
         zYwBtrJ+sjQB9Ut8exTR/cyJ7/b6cQ6cwb3zD+ojyk1VYwZsVUu7NOBeOs28ys/34uaD
         KM7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xYPg8sgD1/nhd+0McGhuQVxOX0ZGdJ7nAqpNcljwLLw=;
        b=djrarGGShlp1PZMrH6wYpBFiDY2CnCMBa3wd9/gu40IomeMkEMKy3b8IJoJBJr9WCd
         6q7WC+/ybsSEwXD6jxfcxvaREGzxtUeNOqMl37O7K70l+7AEuHfMwAvU+ZvXu4ESUUvr
         hNwdJ2n91LppJX4AADtzcq5jAs+l3PxfwjsBprnxjXS2VtCKQ8eAqz9KAQevqEQZKw/X
         JHXBsLWGMRNQD3wX5prTTb2Bnfd8qY/wXbsfbOQnkLopA+DpI9j+peFDvh5hn+69HGnU
         dcx1fEBjzdZi185hYaFnxJaSu+/NeluTGizv5DRB/JSMRO/JiiqRsQgFPtnrf6OV8ze6
         TyzQ==
X-Gm-Message-State: APjAAAUtcIsp9VMZrqSzpsZxNAOXH+wHvHgwWnEoBjyF7nIMrIJPQ3Ji
        902MyTHuqQtTA+2IytR75/AOKspWHUfOtYIIbPM=
X-Google-Smtp-Source: APXvYqzyIxu+c++/5iqk07ONdGCrz8H4bNbVVO7Hr+KvT+YL8Qdbr+W+Drhc2Kpi3eZ8H/SXixKCoHqOKZEdM2oKjc8=
X-Received: by 2002:a17:90a:ad8f:: with SMTP id s15mr342164pjq.50.1568847021379;
 Wed, 18 Sep 2019 15:50:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190918073201.2320-1-vladbu@mellanox.com>
In-Reply-To: <20190918073201.2320-1-vladbu@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 18 Sep 2019 15:50:10 -0700
Message-ID: <CAM_iQpX6RAmf4oXLLJnhYpaXX4g7MUmZ33GZgwrYaiPLBGxmYw@mail.gmail.com>
Subject: Re: [PATCH net 0/3] Fix Qdisc destroy issues caused by adding
 fine-grained locking to filter API
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 12:32 AM Vlad Buslov <vladbu@mellanox.com> wrote:
>
> TC filter API unlocking introduced several new fine-grained locks. The
> change caused sleeping-while-atomic BUGs in several Qdiscs that call cls
> APIs which need to obtain new mutex while holding sch tree spinlock. This
> series fixes affected Qdiscs by ensuring that cls API that became sleeping
> is only called outside of sch tree lock critical section.

Sorry I just took a deeper look. It seems harder than just moving it
out of the critical section.

qdisc_destroy() calls ops->reset() which usually purges queues,
I don't see how it is safe to move it out of tree spinlock without
respecting fast path.

What do you think?
