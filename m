Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5863184DB
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 07:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfEIFev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 01:34:51 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36975 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbfEIFev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 01:34:51 -0400
Received: by mail-pl1-f193.google.com with SMTP id p15so555553pll.4
        for <netdev@vger.kernel.org>; Wed, 08 May 2019 22:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RXCY1+XqtHbOLJq8E56hPM3pFj2+cid6MOn/d5tHqoA=;
        b=T2Pu50P1yBDzJGjNWYRUHXwf+kttCGOq6Lp+gHJVDNrANal/TkFSqQW9qek8I8zN6e
         koHA1RY4q6xw1bjZYaaxxwsjticO9i8Ya2zebYNpeJkIAjrqa2UUUCH+S7rSBUg6uvrn
         2KdIpp64tfHzUP5h9GaBTGRcDS8buAt5VUeUrCd69wILIBLdZXnR9Ui8PUznrAZTURxp
         Ce+A4CG/xBMGXsckRkVAP/wGpJ1UGkZtViBeqfQALwQHt6kCPyuJMk3d8U/bexzT/PNW
         Zj/jzvdFSkEuI1bgNZd+kUNcRK4LL21zPQSp9Lces1HAs7UiJqXYIa4Jd8IqClLNet2t
         U8Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RXCY1+XqtHbOLJq8E56hPM3pFj2+cid6MOn/d5tHqoA=;
        b=IyLbB1niipaXI+PxYprMaSy1jeRW0h0kjwLxqjUkQq83fyCw4ZBf/iZSD8Lrk68XhY
         rdTI19rU7yzh+N5pwua75magGho7/kaE+F470habF0imoqPN8QM3BkNbwY37rWwRy72Z
         Mj3f2DNxi84mTgX165lWxH07+EVav5Khs3zbBj39g9XhIhkseQU34Mq+qv4UPgnRH0hw
         V00FgCC9A5CZj/L/PR91Je08d3e8MSOSXFXaCYDGfzx/4RH0XdvEBw+IsD7Ur6p/jpXg
         IOpEzuV6R1bzjP/Phqu+/4I+9pYGHlZVfK8xw2VUsRgvVLjO1NDkUfGvwFHJQ/2n56O7
         P27g==
X-Gm-Message-State: APjAAAV8xDSqxYm7QuLYKoE0kLi7S2NQZeEkPhvf64ZsEbL68m8gaetD
        T1QyaG8B1iVOzOJzTR9DfSB144n0r2VakAW8jc8=
X-Google-Smtp-Source: APXvYqz1BsT3M86QZI932eV7YgfUzFtdnTDO2CxvuhgEthHj6hHQsEj2p0oSEQ8PPsbybGhCD0UU7vk3wg8Nl9lXi30=
X-Received: by 2002:a17:902:5983:: with SMTP id p3mr2563963pli.224.1557380091042;
 Wed, 08 May 2019 22:34:51 -0700 (PDT)
MIME-Version: 1.0
References: <1557201816-19945-1-git-send-email-jasowang@redhat.com>
 <CAM_iQpURdiJv9GqkEyk=MPokacvtJVfHUpBb3=6EWA0e1yiTZQ@mail.gmail.com>
 <a1ef0c0d-d67c-8888-91e6-2819e8c45489@redhat.com> <CAM_iQpVGdduQGdkBn2a+8=VTuZcoTxBdve6+uDHACcDrdtL=Og@mail.gmail.com>
 <e2c79625-7541-cf58-5729-a5519f36b248@redhat.com>
In-Reply-To: <e2c79625-7541-cf58-5729-a5519f36b248@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 8 May 2019 22:34:39 -0700
Message-ID: <CAM_iQpV+FMvXQDO8o9=x90ybT87OWrSthaxt6soJ_Mhug=vSzA@mail.gmail.com>
Subject: Re: [PATCH net V2] tuntap: synchronize through tfiles array instead
 of tun->numqueues
To:     Jason Wang <jasowang@redhat.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "weiyongjun (A)" <weiyongjun1@huawei.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 7, 2019 at 7:54 PM Jason Wang <jasowang@redhat.com> wrote:
> This is only true if you can make sure tfile[tun->numqueues] is not
> freed. Either my patch or SOCK_RCU_FREE can solve this, but for
> SOCK_RCU_FREE we need do extra careful audit to make sure it doesn't
> break someting. So synchronize through pointers in tfiles[] which is
> already protected by RCU is much more easier. It can make sure no
> dereference from xmit path after synchornize_net(). And this matches the
> assumptions of the codes after synchronize_net().
>

It is hard to tell which sock_put() matches with this synchronize_net()
given the call path is complicated.

With SOCK_RCU_FREE, no such a problem, all sock_put() will be safe.
So to me SOCK_RCU_FREE is much easier to understand and audit.

Thanks.
