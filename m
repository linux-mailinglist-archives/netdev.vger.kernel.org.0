Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C863CAF79
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 00:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbhGOXAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 19:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbhGOXAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 19:00:42 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51519C06175F
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 15:57:48 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id c9so5749584qte.6
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 15:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xtvLFaRY2ZvWKML6aNMHSYSTqE3uAj0SwHg7o999Zp8=;
        b=SZS/ZgExQtXnucME5nKL/y/bQY0uXM4lPzKIS8oeQnNf//t9bAepebihAlCVlW+0bS
         oqASzFFhaP/ILq/nfNxMIBjxLxNbSfAuNoPkwgjZ4xwVikhpJsh3RPKwdi02/BAClmN+
         Iyfh5ekYWNbg+QHBGsC51WzB6GNkzrLg9dFZ/MtIT+cTX5Wzr7n8s8YvMwBIWYXzS1Tq
         p9zNhFBCuI8yZcFh5IAeGJrY/nUxO/7lQovjJwZ5IIQmOxw1k+XU5RDtwY17t3xfN7jK
         10I6kyk41oHLW1Sgt2hR0VD1HQspdU2Xhz/J2ZYBYXJWBWJavWUZA8fkRSpuzOF6QH3U
         hFHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xtvLFaRY2ZvWKML6aNMHSYSTqE3uAj0SwHg7o999Zp8=;
        b=sEIAB8tihkU6o33EQkezfmN5Xb8qYyiqmKYPCQLEvnT1R7d8poMSLEUaYUo31YRsuX
         oStdGuf1wYqofbpdpa+i2Tl6GV0pRsk1URl7krpz6kLRRFdFHFovpKoWWEcOKGh9Q/AE
         efT+o1kHku7uvOPHQR15yR5j+0JUjFTkMUik9XNeowy3+rYkXEY7Ta+RzXKA78OVTw9Q
         sGZ8KUmFXVBQUZHowJ67rfQb82IO/jWEjKd81DqI9+LdpEp2fmZK/vFiuUrS8sxOlDV9
         viSX1TPKthzG2h2I3bIUVfguHZyEz2+yRL84JLNrAbTuxaXBAlt3vi74CA/nBeDgpG+Z
         TmLw==
X-Gm-Message-State: AOAM533hIXj3/NIRcAnfGwJrQ4JJYzGgFjyF15qQVUG5w86W/hXuDNwm
        fcI+Cgr9xbWMNKY2CTTDUx1LqyggUp7LmC2Kzac=
X-Google-Smtp-Source: ABdhPJz8Evddu7rb5sBV3w2k5axNUIJ1Pk7RWzp+MpIblFZaclOHWrHKeHtrOOW0dwN0Ld+6IsWdVEG4Jam5YseIGA0=
X-Received: by 2002:ac8:4a8c:: with SMTP id l12mr6261370qtq.68.1626389867392;
 Thu, 15 Jul 2021 15:57:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210715122754.1240288-1-mark.d.gray@redhat.com>
In-Reply-To: <20210715122754.1240288-1-mark.d.gray@redhat.com>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Thu, 15 Jul 2021 15:57:36 -0700
Message-ID: <CAOrHB_CUyqp-hmamZzkyEea8nOZvGpk57DRQ2EReCKzbtJ4yww@mail.gmail.com>
Subject: Re: [PATCH net-next v2] openvswitch: Introduce per-cpu upcall dispatch
To:     Mark Gray <mark.d.gray@redhat.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>, dan.carpenter@oracle.com,
        Flavio Leitner <fbl@sysclose.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 15, 2021 at 5:28 AM Mark Gray <mark.d.gray@redhat.com> wrote:
>
> The Open vSwitch kernel module uses the upcall mechanism to send
> packets from kernel space to user space when it misses in the kernel
> space flow table. The upcall sends packets via a Netlink socket.
> Currently, a Netlink socket is created for every vport. In this way,
> there is a 1:1 mapping between a vport and a Netlink socket.
> When a packet is received by a vport, if it needs to be sent to
> user space, it is sent via the corresponding Netlink socket.
>
> This mechanism, with various iterations of the corresponding user
> space code, has seen some limitations and issues:
>
> * On systems with a large number of vports, there is a correspondingly
> large number of Netlink sockets which can limit scaling.
> (https://bugzilla.redhat.com/show_bug.cgi?id=1526306)
> * Packet reordering on upcalls.
> (https://bugzilla.redhat.com/show_bug.cgi?id=1844576)
> * A thundering herd issue.
> (https://bugzilla.redhat.com/show_bug.cgi?id=1834444)
>
> This patch introduces an alternative, feature-negotiated, upcall
> mode using a per-cpu dispatch rather than a per-vport dispatch.
>
> In this mode, the Netlink socket to be used for the upcall is
> selected based on the CPU of the thread that is executing the upcall.
> In this way, it resolves the issues above as:
>
> a) The number of Netlink sockets scales with the number of CPUs
> rather than the number of vports.
> b) Ordering per-flow is maintained as packets are distributed to
> CPUs based on mechanisms such as RSS and flows are distributed
> to a single user space thread.
> c) Packets from a flow can only wake up one user space thread.
>
> The corresponding user space code can be found at:
> https://mail.openvswitch.org/pipermail/ovs-dev/2021-July/385139.html
>
> Bugzilla: https://bugzilla.redhat.com/1844576
> Signed-off-by: Mark Gray <mark.d.gray@redhat.com>
> Acked-by: Flavio Leitner <fbl@sysclose.org>

Acked-by: Pravin B Shelar <pshelar@ovn.org>

Thanks,
