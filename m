Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C604082C3
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 04:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236893AbhIMCN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 22:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbhIMCNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 22:13:53 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E74C061574
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 19:12:38 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id j17-20020a05600c1c1100b002e754875260so5463719wms.4
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 19:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4whU/kXcBmANMuUBMU66BEPkdH+OgPS69+PFNphhg3U=;
        b=DxQioavK5I2dMshjyP8PFEPAk/0TBzwjiCISn+oy9S1TMb95/SRsKFZZrLkp378Y3f
         W8ouTa7XJ6N/lxmnLBPlEOBeUIsR8nkEfqQTXfB8rry35NjeKVZol9QaskVs2p2DWpoM
         BmP+AwsMqksY5ft9UTmGptDpUD9UZofJdcehLYOEz0sVI6lqDTznpjaL5/srGThBKSq9
         TpL2xXbKF7lagHpmGDxXf0Q3N2TJ8J3rs0QmoOt7pGBg9hKd0s8wU1jpfGfYWym6iBGm
         QqiOcO8E7AlJE9Zyehf6PZ127AHOyd4ypKoOCM/yTQ7XAVFu9JbHN6EUPvNGqIcKljrH
         avkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4whU/kXcBmANMuUBMU66BEPkdH+OgPS69+PFNphhg3U=;
        b=XN3rzyz7fqFEPQmfl274T38P2ju67b062wWVtXQTn0HT3g/YF8jvO24DA39167KeHD
         7IihSnWwYxWUN4w0SPhYzBHM3TPQRI7y+hqsOml7VfC9bUX3e0XB2/ruYKhYw+v8GlWm
         EL1acZs5ND24tFvSJtbZoaoNilTA/lRkYb4s8IgNQI5NMEXwbZa5VSdAR5rzZXo3pM+g
         VLAgR4CixvOPQDnusB5DVJHAqUBpX54j/8j58VEdXNp+7xBW5rI0Y47Ynyw8WfFykWJM
         JRgc1nGri1Mvf6ahJgy1zdI49Z22XmVM09lE6+76yZMF9KeohWiEXz11/KEtewvHpoI2
         PJ2Q==
X-Gm-Message-State: AOAM5326o0/jhNCh+QoVwBSCoydQfn7hLUYyXrak49tw7bnUkw3wMW4N
        N3EchdgwKDDxnejtAILbmJE=
X-Google-Smtp-Source: ABdhPJx8tCXku1BmTl8iYiGsyN7mBr+7YZh5lLlEvqO4mlgTfb2HA5Bg+lwzdNu1g6bM5aI7+y+BTQ==
X-Received: by 2002:a7b:c750:: with SMTP id w16mr4194308wmk.128.1631499157182;
        Sun, 12 Sep 2021 19:12:37 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id k18sm1343169wrh.68.2021.09.12.19.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Sep 2021 19:12:36 -0700 (PDT)
Date:   Mon, 13 Sep 2021 05:12:35 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [RFC PATCH net] net: dsa: flush switchdev workqueue before
 tearing down CPU/DSA ports
Message-ID: <20210913021235.hlq2q2tx5iteho3x@skbuf>
References: <20210912160015.1198083-1-vladimir.oltean@nxp.com>
 <5223b1d0-b55b-390c-b3d3-f6e6fa24d6d8@gmail.com>
 <20210912161913.sqfcmff77ldc3m5e@skbuf>
 <6af5c67f-db27-061c-3a33-fbc4cede98d1@gmail.com>
 <20210912163341.zlhsgq3uvkro3bem@skbuf>
 <763e2236-31f9-8947-22d1-cf0b48d8a81a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <763e2236-31f9-8947-22d1-cf0b48d8a81a@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 12, 2021 at 07:06:25PM -0700, Florian Fainelli wrote:
>
>
> On 9/12/2021 9:33 AM, Vladimir Oltean wrote:
> > On Sun, Sep 12, 2021 at 09:24:53AM -0700, Florian Fainelli wrote:
> > >
> > >
> > > On 9/12/2021 9:19 AM, Vladimir Oltean wrote:
> > > > On Sun, Sep 12, 2021 at 09:13:36AM -0700, Florian Fainelli wrote:
> > > > > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> > > > >
> > > > > Did you post this as a RFC for a particular reason, or just to give
> > > > > reviewers some time?
> > > >
> > > > Both.
> > > >
> > > > In principle there's nothing wrong with what this patch does, only
> > > > perhaps maybe something with what it doesn't do.
> > > >
> > > > We keep saying that a network interface should be ready to pass traffic
> > > > as soon as it's registered, but that "walk dst->ports linearly when
> > > > calling dsa_port_setup" might not really live up to that promise.
> > >
> > > That promise most definitively existed back when Lennert wrote this code and
> > > we had an array of ports and the switch drivers brought up their port in
> > > their ->setup() method, nowadays, not so sure anymore because of the
> > > .port_enable() as much as the list.
> > >
> > > This is making me wonder whether the occasional messages I am seeing on
> > > system suspend from __dev_queue_xmit: Virtual device %s asks to queue
> > > packet! might have something to do with that and/or the inappropriate
> > > ordering between suspending the switch and the DSA master.
> >
> > Sorry, I have never tested the suspend/resume code path, mostly because
> > I don't know what would the easiest way be to wake up my systems from
> > suspend. If you could give me some pointers there I would be glad to
> > look into it.
>
> If your systems support suspend/resume just do:
>
> echo mem > /sys/power/state
> or
> echo standby > /sys/power/state
>
> if they don't, then maybe a x86 VM with dsa_loop may precipitate the
> problem, but since it uses DSA_TAG_PROTO_NONE, I doubt it, we would need to
> pass traffic on the DSA devices for this warning to show up.

I figured out a working combination in the meanwhile, I even found a bug
in the process:
https://patchwork.kernel.org/project/netdevbpf/patch/20210912192805.1394305-1-vladimir.oltean@nxp.com/

However I did not see those messages getting printed while pinging after
system resume (note that none of the DSA switch drivers I tested with
did implement .suspend or .resume), with net-next or with linux-stable/linux-5.14.y.

Is there more to your setup to reproduce this issue?
