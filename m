Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4967FE83D
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 18:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbfD2Q64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 12:58:56 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33438 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728681AbfD2Q64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 12:58:56 -0400
Received: by mail-pf1-f193.google.com with SMTP id z28so308264pfk.0;
        Mon, 29 Apr 2019 09:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mSK82YTG8Gn1sEA2j7QMo/uWbASODJaKRuCPhSuz7Ws=;
        b=bCGeOw1/jXqh9Dd3eBM48IWO8Brb1bqCy1y4jCkDx9R/BnyWtEUmC2MIX7JbYrzLmx
         +aqWmV58/68nUKX7iPezXdRVFtMAHMzmIgQjtMxK+HVNjoK4rfhYvJPj0FdbYQ+lyO85
         hvfzm0sHv78TweD4OFi5lm+HRMpFIg9YDVmxXrdHpql5fDZaXvJIOYLGWViqSloO6Bds
         NUQSkhQD3PZP1Atta5Y/RYwgctXljzM4i6jpkTT5b7TEjkWYAKlTTN7IDI75/zKM7Xqp
         l6RRyhUmtMuax5EW03R9DXz1YjoxjRDXAU8V+L8pmgsp+xkXBPQ9PsHArVEOBGr606nb
         gW4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mSK82YTG8Gn1sEA2j7QMo/uWbASODJaKRuCPhSuz7Ws=;
        b=cXZRHnN8gwZffp0PfTzAFqTcuhPHZRPnvQ26bEjFaSQLgdMI8ozYtXsVU9Ys0P0ub2
         0RCDaqeBzR/rObDy//Zg7TDmhSNJECF+h/4Zpvf7EWWJ/QWSlN7QCEdsGqGp4N4TIV6Q
         +3SbT1ZJI45bNTu6ys/5u3mHm4L3206U0PcKtrLT/Qqo8yTIwWb6B1EKtwUlPow30JQF
         wJQeusEYrpSgTkgs1Tf9JuJA4K8psztMN2GO0vQ0N+AoPU0rtT9rbYnBRKtoQL+WmGKE
         ODwKDrNbVUwpBPHa1hjhocbeIHYdiPK+COkVNQOgy3lQBDeiVg1FY8d9F0wndXjKS843
         wGow==
X-Gm-Message-State: APjAAAU2K/Xe1voz17eCsvvVAzkatFuIzU4M2ZAPBR5Z/UZ9aigEIs8e
        ogGrtdSrOnAOT1DxG/YnAMskKVNwUzQLLkQGpGo=
X-Google-Smtp-Source: APXvYqz+Z6yq8Rw0kP+RFYtzvvjPOq+FDmWYGa9ndRbPF9eI5lCF1laHMqA8bd95a1UuzSOXYj3VZvI63G8LSKuJ6oY=
X-Received: by 2002:a63:6b82:: with SMTP id g124mr57479137pgc.246.1556557135343;
 Mon, 29 Apr 2019 09:58:55 -0700 (PDT)
MIME-Version: 1.0
References: <71250616-36c1-0d96-8fac-4aaaae6a28d4@redhat.com>
 <20190428030539.17776-1-yuehaibing@huawei.com> <20190429105422-mutt-send-email-mst@kernel.org>
In-Reply-To: <20190429105422-mutt-send-email-mst@kernel.org>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 29 Apr 2019 09:58:43 -0700
Message-ID: <CAM_iQpWvp2i6iOZtSPskqU_uXHL2zKfM_cS1rGTh_T0r3BwvnA@mail.gmail.com>
Subject: Re: [PATCH] tun: Fix use-after-free in tun_net_xmit
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Yue Haibing <yuehaibing@huawei.com>,
        David Miller <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "Li,Rongqing" <lirongqing@baidu.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Chas Williams <3chas3@gmail.com>, wangli39@baidu.com,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 7:55 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> The problem seems real enough, but an extra synchronize_net on tun_attach
> might be a problem, slowing guest startup significantly.
> Better ideas?

Yes, I proposed the following patch in the other thread.

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index e9ca1c088d0b..31c3210288cb 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3431,6 +3431,7 @@ static int tun_chr_open(struct inode *inode,
struct file * file)
        file->private_data = tfile;
        INIT_LIST_HEAD(&tfile->next);

+       sock_set_flag(&tfile->sk, SOCK_RCU_FREE);
        sock_set_flag(&tfile->sk, SOCK_ZEROCOPY);

        return 0;
