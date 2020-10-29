Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C700D29EB2D
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 13:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbgJ2MCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 08:02:32 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:47057 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbgJ2MCc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 08:02:32 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id dfef3042;
        Thu, 29 Oct 2020 12:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to
        :content-type; s=mail; bh=IKnebaGdC8b0mR1Q29fh+gfHHKY=; b=0AjD+L
        qAaaGb/LT4eA679KOrP/IXYQcl4wa49hRRzOR3k2Qf4MrKVMGSRksJoWpLmot2QD
        8i+tfcG6ZbP2wUWQNvjOCX/+rGPKhQig8LhKVAzZbaboK7hhsPYrNdAThAAMOH2O
        +vj+AIvCZCedHoijgLb+A8kk/BPxJssessPhJUFyPGJJLb7TYPbxjH9r7j9DFN3a
        zD8h5kPKPVjpVujayjlnsdZvPBio0+aS8Me9XJodXiZVDSBykiKU988D5Lrrblyx
        YzbFaPhYmwoL86sJIHsuHc7rz0K9OAHX1eb1B6XAGpOqQ4eIi9hIs1e7gGCX1mhv
        CqI0A4Y8lpSeBGKg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 27a2ba2a (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 29 Oct 2020 12:00:42 +0000 (UTC)
Received: by mail-yb1-f170.google.com with SMTP id h196so1940688ybg.4;
        Thu, 29 Oct 2020 05:02:04 -0700 (PDT)
X-Gm-Message-State: AOAM531TDI9Ohlodc7OKl9A2wAo+IFIsawkDA7WFCaDJzUl+PmUCPWiT
        wdAU3jXRkEmhd6Ts1uHdlnk93NkpFw28nfxTA/A=
X-Google-Smtp-Source: ABdhPJws4sMjJ5gTYRaTuZplBgwYUu2/72U5E+Kxj9cpw3q9A2obBZ/+APgdYoDi4qCVG9iuuU/mnkse+Zyil03bdpA=
X-Received: by 2002:a25:bbc4:: with SMTP id c4mr5432372ybk.178.1603972923657;
 Thu, 29 Oct 2020 05:02:03 -0700 (PDT)
MIME-Version: 1.0
References: <20201029025606.3523771-1-Jason@zx2c4.com> <20201029025606.3523771-3-Jason@zx2c4.com>
In-Reply-To: <20201029025606.3523771-3-Jason@zx2c4.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 29 Oct 2020 13:01:53 +0100
X-Gmail-Original-Message-ID: <CAHmME9ohyPOwQryPMzk7oNGaBeKSJoFmSQkemRoUYKhjqgQ7ag@mail.gmail.com>
Message-ID: <CAHmME9ohyPOwQryPMzk7oNGaBeKSJoFmSQkemRoUYKhjqgQ7ag@mail.gmail.com>
Subject: Re: [PATCH nf 2/2] netfilter: use actual socket sk rather than skb sk
 when routing harder
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a historical note, this code goes all the way back to Rusty in
2.3.14, where it looked like this:

#ifdef CONFIG_NETFILTER
/* To preserve the cute illusion that a locally-generated packet can
  be mangled before routing, we actually reroute if a hook altered
  the packet. -RR */
static int route_me_harder(struct sk_buff *skb)
{
       struct iphdr *iph = skb->nh.iph;
       struct rtable *rt;

       if (ip_route_output(&rt, iph->daddr, iph->saddr,
                           RT_TOS(iph->tos) | RTO_CONN,
                           skb->sk ? skb->sk->bound_dev_if : 0)) {
               printk("route_me_harder: No more route.\n");
               return -EINVAL;
       }

       /* Drop old route. */
       dst_release(skb->dst);

       skb->dst = &rt->u.dst;
       return 0;
}
#endif

And until now, it was never updated to take the separate sock *sk parameter.
