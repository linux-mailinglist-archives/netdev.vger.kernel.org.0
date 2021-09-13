Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC45408A44
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 13:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239631AbhIMLcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 07:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239416AbhIMLcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 07:32:45 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FD3C061574
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 04:31:29 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id h9so20337729ejs.4
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 04:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3q/Qolc0T+O1pwUJbFNVkBR3teS2P6zbcTF7FIYPAns=;
        b=k1NJn1PWU80SC1C/PWn8Ld9Ore+ZuOz9DMrYvRswVPiOR+ALKW87fL6JKWtd5+lEtO
         ZA9PoAtS6N/eaDAkk1n7eY985b9cCG4fePtAHeWZWpVzMGwUx1xd/srtuBOROBNexube
         wfJskqa43KZiQ7nn8AOsHOg1yxrmgTs6CujkyrU/SVFK1o1d7B0go4fGY6APuYAXl9Nt
         VI4H0ZnURAjDKYo5OfcGe2boVq0zVsxFCHWxwA3jpyjj63pZox+k7NP5WJcsC4AlDUcG
         +saSTfmffkZiO33bpoioMjgR19TvU8rK1HO9c0dgqBxOWFYI9G8GeJrYuciJLvdFGkl5
         c+Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3q/Qolc0T+O1pwUJbFNVkBR3teS2P6zbcTF7FIYPAns=;
        b=fHBKkPLysRj6hd41nHupbxNQquZaViz69Z6z7rE1ZnRJ1cul/zexl6zSzfsZnuU/nu
         E5DW/NkYWmnpV4zj4DJpnVMuj4n4PENhIuM8Kh/17OQc4h/6xLMJ5fYBEi4c7l6Dr003
         lOOBalJ73PkMwHKBKS6Qoe1neTR3kuUYgw+gkMmdcM2RP8/k71S7YzE6enUe+cgaIyOd
         tMjXYDlDFi7KbKIkUYFTid4rJTbNXIYkFO76zbtJz6bHhUeS+2nalFErrGF5ERlvWNaQ
         4c0votJPZACEhkR1dPcO4/1/Nj+wiopxjqG6hSpBqBgIFJ5Zt06nbkq9gD3jFC1Ca/Nd
         ux5A==
X-Gm-Message-State: AOAM532pgAAI7j7ARvBoFLirDZBn6BsrtgJFe/43iw5sH/4KIcXoY3xV
        kJXoXlXUcgxyZIm58aoRWjB6+Mu1ki0=
X-Google-Smtp-Source: ABdhPJzmh6b012v0qJ8TEcMoFs5NIEZwF4FWvFvR0UHYZSExe85VWIab1N04ldEwAJpzDvHexJpq9A==
X-Received: by 2002:a17:906:d20a:: with SMTP id w10mr12552966ejz.426.1631532688106;
        Mon, 13 Sep 2021 04:31:28 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id h10sm3284279ede.28.2021.09.13.04.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 04:31:27 -0700 (PDT)
Date:   Mon, 13 Sep 2021 14:31:26 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [RFC PATCH net] net: dsa: flush switchdev workqueue before
 tearing down CPU/DSA ports
Message-ID: <20210913113126.34th7ubolxwngi3c@skbuf>
References: <20210912160015.1198083-1-vladimir.oltean@nxp.com>
 <5223b1d0-b55b-390c-b3d3-f6e6fa24d6d8@gmail.com>
 <20210912161913.sqfcmff77ldc3m5e@skbuf>
 <6af5c67f-db27-061c-3a33-fbc4cede98d1@gmail.com>
 <20210912163341.zlhsgq3uvkro3bem@skbuf>
 <763e2236-31f9-8947-22d1-cf0b48d8a81a@gmail.com>
 <20210913021235.hlq2q2tx5iteho3x@skbuf>
 <37a4bef7-68de-f618-f741-d0de49c88e82@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37a4bef7-68de-f618-f741-d0de49c88e82@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 12, 2021 at 07:20:23PM -0700, Florian Fainelli wrote:
> On 9/12/2021 7:12 PM, Vladimir Oltean wrote:
> > On Sun, Sep 12, 2021 at 07:06:25PM -0700, Florian Fainelli wrote:
> > > On 9/12/2021 9:33 AM, Vladimir Oltean wrote:
> > > > On Sun, Sep 12, 2021 at 09:24:53AM -0700, Florian Fainelli wrote:
> > > > > On 9/12/2021 9:19 AM, Vladimir Oltean wrote:
> > > > > > On Sun, Sep 12, 2021 at 09:13:36AM -0700, Florian Fainelli wrote:
> > > > > > > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> > > > > > >
> > > > > > > Did you post this as a RFC for a particular reason, or just to give
> > > > > > > reviewers some time?
> > > > > >
> > > > > > Both.
> > > > > >
> > > > > > In principle there's nothing wrong with what this patch does, only
> > > > > > perhaps maybe something with what it doesn't do.
> > > > > >
> > > > > > We keep saying that a network interface should be ready to pass traffic
> > > > > > as soon as it's registered, but that "walk dst->ports linearly when
> > > > > > calling dsa_port_setup" might not really live up to that promise.
> > > > >
> > > > > That promise most definitively existed back when Lennert wrote this code and
> > > > > we had an array of ports and the switch drivers brought up their port in
> > > > > their ->setup() method, nowadays, not so sure anymore because of the
> > > > > .port_enable() as much as the list.
> > > > >
> > > > > This is making me wonder whether the occasional messages I am seeing on
> > > > > system suspend from __dev_queue_xmit: Virtual device %s asks to queue
> > > > > packet! might have something to do with that and/or the inappropriate
> > > > > ordering between suspending the switch and the DSA master.
> > > >
> > > > Sorry, I have never tested the suspend/resume code path, mostly because
> > > > I don't know what would the easiest way be to wake up my systems from
> > > > suspend. If you could give me some pointers there I would be glad to
> > > > look into it.
> > >
> > > If your systems support suspend/resume just do:
> > >
> > > echo mem > /sys/power/state
> > > or
> > > echo standby > /sys/power/state
> > >
> > > if they don't, then maybe a x86 VM with dsa_loop may precipitate the
> > > problem, but since it uses DSA_TAG_PROTO_NONE, I doubt it, we would need to
> > > pass traffic on the DSA devices for this warning to show up.
> >
> > I figured out a working combination in the meanwhile, I even found a bug
> > in the process:
> > https://patchwork.kernel.org/project/netdevbpf/patch/20210912192805.1394305-1-vladimir.oltean@nxp.com/
> >
> > However I did not see those messages getting printed while pinging after
> > system resume (note that none of the DSA switch drivers I tested with
> > did implement .suspend or .resume), with net-next or with linux-stable/linux-5.14.y.
> >
> > Is there more to your setup to reproduce this issue?
>
> All switch ports are brought up with a DHCP client, the issue is
> definitively intermittent and not frequent, I don't have suspend/resume
> working on 5.14.y yet, but going as far back as 5.10.y should let you see
> the same kind of messages.

Nope, I don't see the message on linux-5.10.y either, but even if I look
at the code I don't understand what goes on.

Here are some facts:

- __dev_queue_xmit only prints "Virtual device %s asks to queue packet!"
  for devices which have a NULL dev->qdisc->enqueue, but return
  NETDEV_TX_BUSY in dev_hard_start_xmit

- only the noqueue qdisc manages that performance, normally register_qdisc
  sets up a default of ->enqueue pointer of noop_qdisc_ops.enqueue, but
  there is a hack in noqueue_init which subverts that.

- The default qdiscs are assigned by attach_default_qdiscs(). There are
  two ways in which an interface can get the noqueue_qdisc_ops by default:
  (a) it declares the IFF_NO_QUEUE feature
  (b) the init of its other default qdisc (for example mq) failed for
      some reason, the kernel prints a warning and falls back to noqueue.

- DSA declares IFF_NO_QUEUE, so it uses the noqueue qdisc by default

- DSA never returns anything other than NETDEV_TX_OK in ndo_start_xmit.

So my conclusion is:
you have the noqueue qdisc on the DSA master, which got there either by
accident due to a failure of the mq qdisc initialization, or
intentionally by:

tc qdisc add dev eth0 root noqueue

When you use the noqueue qdisc and your DSA master device driver returns
NETDEV_TX_BUSY, the packet won't get queued => the system pretty much is
in its own right to complain.
