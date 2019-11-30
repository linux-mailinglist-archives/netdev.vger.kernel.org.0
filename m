Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7696D10DF54
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 22:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbfK3VES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 16:04:18 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36010 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbfK3VES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 16:04:18 -0500
Received: by mail-pl1-f196.google.com with SMTP id k20so1899536pls.3
        for <netdev@vger.kernel.org>; Sat, 30 Nov 2019 13:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q7CNSVKfYHf9+OSdLNEmF7ICS08y+nP7CNDcprbXNzo=;
        b=tZW7gu5xRldUWPZ3mC53D19hCrr2ORZyORiUq6sOwIzWIprZvwg1PW38181sunXpLf
         7czihvj4Try9Qoq/GYrvRGe1/UsqFM+n7byXOzg3H4NisiZAuHjsbwOdp82SE8/oHT9K
         Mv9dUiD616Qa14zosR71CGx1eze7rE3QwC4SbrHM9RdAa+73wvg97i47O0d5GTKsMIP+
         tZdAiM79e4HceThm3yBpa8HEj59m5OKXvzixKdkj3ns/pTVoMUsGsAz6oNp0SsagXE3c
         6GZm8FLpNnaJjxbTP6gNphzNtlVYaU9OkP4/y3jDQMd6zdOB2pXopM/o25mWydZgmrGK
         YDkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q7CNSVKfYHf9+OSdLNEmF7ICS08y+nP7CNDcprbXNzo=;
        b=sE5h4jSL+05uTqyqVblPEHRVwDpfJB/8zjwZ0vrdUDskYLpHvnu1h1Ryt9kEsT7Y3h
         xEUykDW4Td0gzBUAtCbZ/5iWvpkhGtqVRd2LgpV7qsBsJSLEQyMdxA4lWGJtSQCAC5bJ
         K76JMqWwTitq1EbPYGetoCvADO1A5fV5CVeJfdjT/xDihoDLhz4f0WaHWIL1xEMglsV/
         YI3AFJOAPPOixhZ+vAx+3MFWgyPgHZe+w5PVXFi7LuyNNEl9r8StDIqrcOTR71E6rhor
         qydGYRGRBVk/o7mS0BGowCnUAMFIuNAWtv02gBclB6a3NX8bzFiuNVix9WysbR11d7d7
         UFfA==
X-Gm-Message-State: APjAAAXy/tr3iAlUN8jvG713wSiuWR5JsbtN+r8iZAWL3kzukPtF0tHY
        IbIcrkNcomnoQTo7z21uUsGpDOHVapSpN3JeAc4=
X-Google-Smtp-Source: APXvYqwziRqU2vx/5CWenNVXo/1+xikTb17+n9Cqr6C/ptmpENCI12ALHwjWFICJT65L6tyGv0cum+OYZvUPUQglD7s=
X-Received: by 2002:a17:902:9a03:: with SMTP id v3mr20382318plp.61.1575147857420;
 Sat, 30 Nov 2019 13:04:17 -0800 (PST)
MIME-Version: 1.0
References: <20191130142400.3930-1-ap420073@gmail.com> <CAM_iQpWmwreeCuOVnTTucHcXkmLP-QRtzW22_g6QWM2-QoS5WA@mail.gmail.com>
In-Reply-To: <CAM_iQpWmwreeCuOVnTTucHcXkmLP-QRtzW22_g6QWM2-QoS5WA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 30 Nov 2019 13:04:05 -0800
Message-ID: <CAM_iQpWYrFx-NbnHpHWmVaf7AoF3Zvi1s6i0Egsf7Ct064X0Xw@mail.gmail.com>
Subject: Re: [net PATCH] hsr: fix a NULL pointer dereference in hsr_dev_xmit()
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        treeze.taeung@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 30, 2019 at 10:35 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > Test commands:
> >     ip netns add nst
> >     ip link add v0 type veth peer name v1
> >     ip link add v2 type veth peer name v3
> >     ip link set v1 netns nst
> >     ip link set v3 netns nst
> >     ip link add hsr0 type hsr slave1 v0 slave2 v2
> >     ip a a 192.168.100.1/24 dev hsr0
> >     ip link set v0 up
> >     ip link set v2 up
> >     ip link set hsr0 up
> >     ip netns exec nst ip link add hsr1 type hsr slave1 v1 slave2 v3
> >     ip netns exec nst ip a a 192.168.100.2/24 dev hsr1
> >     ip netns exec nst ip link set v1 up
> >     ip netns exec nst ip link set v3 up
> >     ip netns exec nst ip link set hsr1 up
> >     hping3 192.168.100.2 -2 --flood &
> >     modprobe -rv hsr
>
> Looks like the master port got deleted without respecting RCU
> readers, let me look into it.


It seems hsr_del_port() gets called on module removal path too
and we delete the master port before waiting for RCU readers
there.

Does the following patch help anything? It just moves the list_del_rcu()
after synchronize_rcu() only for master port.

diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
index ee561297d8a7..c9638ee00d20 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -174,9 +174,9 @@ void hsr_del_port(struct hsr_port *port)

        hsr = port->hsr;
        master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
-       list_del_rcu(&port->port_list);

        if (port != master) {
+               list_del_rcu(&port->port_list);
                if (master) {
                        netdev_update_features(master->dev);
                        dev_set_mtu(master->dev, hsr_get_max_mtu(hsr));
@@ -193,5 +193,7 @@ void hsr_del_port(struct hsr_port *port)

        if (port != master)
                dev_put(port->dev);
+       else
+               list_del_rcu(&port->port_list);
        kfree(port);
 }
