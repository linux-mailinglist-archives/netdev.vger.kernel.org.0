Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDF164FF35
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 04:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfFXCSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 22:18:20 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:42288 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfFXCSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 22:18:20 -0400
Received: by mail-oi1-f196.google.com with SMTP id s184so8591540oie.9
        for <netdev@vger.kernel.org>; Sun, 23 Jun 2019 19:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0b1vq1pumP9pUJ4RUDDgQ3X9m3+/fvdzdiDL4I2kAH4=;
        b=Ip38n5URWujbgpJRwy0vq8CJa70vU7fuwsYoBhWmBl3VvncQUXz/QCVDQMlMYdRBR5
         9ddYmowbYskINg3/NUhqM0D0hNQyUprTSw8eodjls02KCYlXzz/Pl9+StoX8QAdHTQkn
         buuCsGQvwshjvCGPrjlFdbCZWF/tjoaKry55fYea3LogWk2SZM/YcLbJC0WqFVDiKYFd
         1tPzzXuMZ8H+JE7R9ZwcDjKpMHngqISJITh7PjlUwzFeD+5RQkEk9diYY9gmZThcLBS2
         7lPAM1qtGDrtVYSFrh4uDsR5rXApLWXz+KrPxUFsWh867LooQpnP/Aj8INDqHqGj9XyI
         /7Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0b1vq1pumP9pUJ4RUDDgQ3X9m3+/fvdzdiDL4I2kAH4=;
        b=YAZ34fly3BEiSQJjrwACH7GRRqK4ixkWk3TSbT1B2Sxo9mpM5WaOcsQC3JidFUw3Df
         0Tx3cpH2N3n8bsnYOzab6mUeBamFhPqLxzm8U0zNvmF9wnUGD4orS6dfjn5QD+FHeHAG
         Oycx3c2CTEr5qVeqd/1/mBrqzvAXrng78s3WPOzgFkb4gdjDb/w2AW7H1dn5kS9OnMYK
         4V3mUetnbSKl/SygSqXMg66KAXaf0Apo4F4KsguMBUEgHXJ/E6AoS0TQWLFyVaBYpP3P
         Hvo/O46x+7yVmf5e0liqYWMLLb7a+SYbnVu1Wh7j+/kP9phYRZqu2fOrRgBoXy9LccKH
         ovMg==
X-Gm-Message-State: APjAAAU5DsSdruOg3YBnK8CnBop0GhvthPg/jhF3ZeYDMrGVNfyy57I9
        B9SdQ483yLaDOifexnbhWZOJOP55k48f2k3rRiuohpiC
X-Google-Smtp-Source: APXvYqyby3zHHYA+GWYBxQUUyxg4KVxZD0tehGYRnsr9JPmGsEsKc60X0ZDUF+dk9P1lcTMpdOkFjrgIFdc283RDxxo=
X-Received: by 2002:a05:6808:6c5:: with SMTP id m5mr7759289oih.89.1561342699678;
 Sun, 23 Jun 2019 19:18:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190620115108.5701-1-ap420073@gmail.com> <20190623.110737.1466794521532071350.davem@davemloft.net>
In-Reply-To: <20190623.110737.1466794521532071350.davem@davemloft.net>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Mon, 24 Jun 2019 11:18:08 +0900
Message-ID: <CAMArcTXWNY6WTjuBuUVxeb3c6dTqf8wf6sHFmNL5SvsGBbPqdQ@mail.gmail.com>
Subject: Re: [PATCH net] vxlan: do not destroy fdb if register_netdevice() is failed
To:     David Miller <davem@davemloft.net>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jun 2019 at 03:07, David Miller <davem@davemloft.net> wrote:
>

Hi David,

Thank you for the review!

> From: Taehee Yoo <ap420073@gmail.com>
> Date: Thu, 20 Jun 2019 20:51:08 +0900
>
> > __vxlan_dev_create() destroys FDB using specific pointer which indicates
> > a fdb when error occurs.
> > But that pointer should not be used when register_netdevice() fails because
> > register_netdevice() internally destroys fdb when error occurs.
> >
> > In order to avoid un-registered dev's notification, fdb destroying routine
> > checks dev's register status before notification.
>
> Simply pass do_notify as false in this failure code path of __vxlan_dev_create(),
> thank you.

Failure path of __vxlan_dev_create() can't handle do_notify in that case
because if register_netdevice() fails it internally calls
->ndo_uninit() which is
vxlan_uninit().
vxlan_uninit() internally calls vxlan_fdb_delete_default() and it callls
vxlan_fdb_destroy().
do_notify of vxlan_fdb_destroy() in vxlan_fdb_delete_default() is always true.
So, failure path of __vxlan_dev_create() doesn't have any opportunity to
handle do_notify.

Thank you!
