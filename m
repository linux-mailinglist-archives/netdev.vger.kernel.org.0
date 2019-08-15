Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A61028F5EB
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 22:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731987AbfHOUqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 16:46:45 -0400
Received: from ajax.cs.uga.edu ([128.192.4.6]:59002 "EHLO ajax.cs.uga.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728728AbfHOUqp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 16:46:45 -0400
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
        (authenticated bits=0)
        by ajax.cs.uga.edu (8.14.4/8.14.4) with ESMTP id x7FKkgUs078312
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Aug 2019 16:46:43 -0400
Received: by mail-lj1-f179.google.com with SMTP id h15so3370707ljg.10;
        Thu, 15 Aug 2019 13:46:43 -0700 (PDT)
X-Gm-Message-State: APjAAAUCnQv/R7mFKHJd8x/tlQ8aT8UhBa5dI4IlDJNLJUOzz2K+s3Sa
        NhaH/+Uj0VJG2YEaES23MNVpa16QJkXbpf1yv94=
X-Google-Smtp-Source: APXvYqz2r7ehE+Kq/uplBHFF/vWrICt2j6gnOl6mxPjSNU6q7kEsP42YzMCcN2+OCFbVGnDfm0trfcsj+mKW3zAb3mg=
X-Received: by 2002:a2e:89da:: with SMTP id c26mr3093675ljk.214.1565902002043;
 Thu, 15 Aug 2019 13:46:42 -0700 (PDT)
MIME-Version: 1.0
References: <1565746427-5366-1-git-send-email-wenwen@cs.uga.edu>
 <20190815.123430.831231953098536795.davem@davemloft.net> <CAAa=b7ft-crBJm+H9U7Bn2dcgfjQsE8o53p2ryBWK3seQoF3Cg@mail.gmail.com>
 <20190815.134230.1028411309377288636.davem@davemloft.net>
In-Reply-To: <20190815.134230.1028411309377288636.davem@davemloft.net>
From:   Wenwen Wang <wenwen@cs.uga.edu>
Date:   Thu, 15 Aug 2019 16:46:05 -0400
X-Gmail-Original-Message-ID: <CAAa=b7duRXsiVBfzbvHhoU000gGh53Mme3ZKCO5SoiTdgRaXtg@mail.gmail.com>
Message-ID: <CAAa=b7duRXsiVBfzbvHhoU000gGh53Mme3ZKCO5SoiTdgRaXtg@mail.gmail.com>
Subject: Re: [PATCH] net: pch_gbe: Fix memory leaks
To:     David Miller <davem@davemloft.net>
Cc:     Richard Fontana <rfontana@redhat.com>,
        Allison Randal <allison@lohutok.net>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Wenwen Wang <wenwen@cs.uga.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 15, 2019 at 4:42 PM David Miller <davem@davemloft.net> wrote:
>
> From: Wenwen Wang <wenwen@cs.uga.edu>
> Date: Thu, 15 Aug 2019 16:03:39 -0400
>
> > On Thu, Aug 15, 2019 at 3:34 PM David Miller <davem@davemloft.net> wrote:
> >>
> >> From: Wenwen Wang <wenwen@cs.uga.edu>
> >> Date: Tue, 13 Aug 2019 20:33:45 -0500
> >>
> >> > In pch_gbe_set_ringparam(), if netif_running() returns false, 'tx_old' and
> >> > 'rx_old' are not deallocated, leading to memory leaks. To fix this issue,
> >> > move the free statements after the if branch.
> >> >
> >> > Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
> >>
> >> Why would they be "deallocated"?  They are still assigned to
> >> adapter->tx_ring and adapter->rx_ring.
> >
> > 'adapter->tx_ring' and 'adapter->rx_ring' has been covered by newly
> > allocated 'txdr' and 'rxdr' respectively before this if statement.
>
> That only happens inside of the if() statement, that's why rx_old and
> tx_old are only freed in that code path.

That happens not only inside of the if statement, but also before the
if statement, just after 'txdr' and 'rxdr' are allocated.

Wenwen
