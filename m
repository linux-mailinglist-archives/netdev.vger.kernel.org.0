Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB14E521D0
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 06:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfFYEMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 00:12:14 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:33918 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbfFYEMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 00:12:13 -0400
Received: by mail-ed1-f67.google.com with SMTP id s49so25004796edb.1
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 21:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=elAhTItOVPrcxV7GXK2cFhASX/WJaPAKyeNXD7OSPDI=;
        b=LJl6pF3WjLKIXPXbqFsl2Z5P//eRpeYWyFCSFpR6FzkcbIaXqhkv6yNsxoQZ68lbEO
         eTwx8DcsFalQS77Uk74Mi70xmNBDm2yUiBN947MlCvvhKMlkSo/afy0rEQaBTr2qmKsm
         AofSZUFgN/4uifgyj+PmDD7LDNu+/3Ag3p5b4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=elAhTItOVPrcxV7GXK2cFhASX/WJaPAKyeNXD7OSPDI=;
        b=HmoAeScvVye6OwyvR8Lsaj/gf5iuDV7o33vmV5UUQ99F798GUMRegOueq+oaLm2I1k
         IYzCWw40aFeYB0SMsPR49cP1qGhr6JaSnGQ4VPMMjlBaiXd2W51J+FxLuomnVwk/dqLk
         fq9+8tTFQEYn6K1h07qEAMH46nti6VZTPAvrCcOAecGfRpJ/6yNwghFLlfmojtbowDJ4
         hmhrHTCvjSKq8eEzd3TS9ZeGVDx/axuEsUgF/5DlcSaU1hg4m1w2Edf8qE0aIjnQpc7G
         R12xs19UUkUUd+z6kl5f7QF+Qh/rr0WXucQtOGwSZu79jmJDtQnKs4BaVNu4lyEYKAqz
         JqSw==
X-Gm-Message-State: APjAAAWOxzkSUNLWNZAx0OpJHr+BZMZigiD3PpCVmvR2ATJsmcIYvK0Y
        nqw/4UtHZHBCjz6M6HsH7l6VH3otEkDkFCgJwXm1VA==
X-Google-Smtp-Source: APXvYqywkrTmvjqLATJ3LFbvIxksFbhSVCnDVC9/bhSjiyh8qOdbCxA2pa05oU5G2VJdSwwN1LJ52DKeOEILvdT693Y=
X-Received: by 2002:a17:906:5813:: with SMTP id m19mr13035681ejq.6.1561435931927;
 Mon, 24 Jun 2019 21:12:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190620115108.5701-1-ap420073@gmail.com> <20190623.110737.1466794521532071350.davem@davemloft.net>
 <CAMArcTXWNY6WTjuBuUVxeb3c6dTqf8wf6sHFmNL5SvsGBbPqdQ@mail.gmail.com>
In-Reply-To: <CAMArcTXWNY6WTjuBuUVxeb3c6dTqf8wf6sHFmNL5SvsGBbPqdQ@mail.gmail.com>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Mon, 24 Jun 2019 21:12:01 -0700
Message-ID: <CAJieiUjri=-w2PqB9q5fEa=4jqkTWSfK0dUwnT7Cvxdo2sRRzg@mail.gmail.com>
Subject: Re: [PATCH net] vxlan: do not destroy fdb if register_netdevice() is failed
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 23, 2019 at 7:18 PM Taehee Yoo <ap420073@gmail.com> wrote:
>
> On Mon, 24 Jun 2019 at 03:07, David Miller <davem@davemloft.net> wrote:
> >
>
> Hi David,
>
> Thank you for the review!
>
> > From: Taehee Yoo <ap420073@gmail.com>
> > Date: Thu, 20 Jun 2019 20:51:08 +0900
> >
> > > __vxlan_dev_create() destroys FDB using specific pointer which indicates
> > > a fdb when error occurs.
> > > But that pointer should not be used when register_netdevice() fails because
> > > register_netdevice() internally destroys fdb when error occurs.
> > >
> > > In order to avoid un-registered dev's notification, fdb destroying routine
> > > checks dev's register status before notification.
> >
> > Simply pass do_notify as false in this failure code path of __vxlan_dev_create(),
> > thank you.
>
> Failure path of __vxlan_dev_create() can't handle do_notify in that case
> because if register_netdevice() fails it internally calls
> ->ndo_uninit() which is
> vxlan_uninit().
> vxlan_uninit() internally calls vxlan_fdb_delete_default() and it callls
> vxlan_fdb_destroy().
> do_notify of vxlan_fdb_destroy() in vxlan_fdb_delete_default() is always true.
> So, failure path of __vxlan_dev_create() doesn't have any opportunity to
> handle do_notify.


I don't see register_netdevice calling ndo_uninit in case of all
errors. In the case where it does not,
does your patch leak the fdb entry ?.

Wondering if we should just use vxlan_fdb_delete_default with a notify
flag to delete the entry if exists.
Will that help ?

There is another commit that touched this code path:
commit 6db9246871394b3a136cd52001a0763676563840

Author: Petr Machata <petrm@mellanox.com>
Date:   Tue Dec 18 13:16:00 2018 +0000
    vxlan: Fix error path in __vxlan_dev_create()
