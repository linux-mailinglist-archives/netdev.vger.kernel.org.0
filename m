Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F740276452
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 01:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgIWXI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 19:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgIWXI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 19:08:26 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51387C0613CE;
        Wed, 23 Sep 2020 16:08:26 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id r7so1819814ejs.11;
        Wed, 23 Sep 2020 16:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IAy0QwQl6xkzL0NCAdLvGQ/0DcJiv+LYgD+PMok7G3w=;
        b=ZQ+uplBoQxl305aeBTUD8IGI+hN6Bc9bVDM96rZ1Bjoe68dZJO1ooGl66SWwMFq/9o
         yGiTqIMbkgwzckLnZusUqSQT6nEGGENuMHxxbrTQmxXH6EWr1rSGxDG/Uu3F9osqgiFv
         A6F10RE5kIZc6o3S6p3RRoYwVDoGdrOz8wxTCyafoka63WF8xqadyfEAN2M83uQ1uENo
         9Qob35FKMb0xEQ/41nETiTeY7ElLnr+wXsfKh2m4L9TO6lxq1YIzlK9iq2F8UvnCdBMA
         jgFIY0cagg7COszeu94jE41CBnUOdZaFNHaBIjL8R1Anit/GNfA9TI6cbbgfYMKPVwmc
         2pGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IAy0QwQl6xkzL0NCAdLvGQ/0DcJiv+LYgD+PMok7G3w=;
        b=YCFWSsKTLGPeb4ZxfDC3p9EfVSeyE+fUVgX6IoBd19r2eKj/+TNHFRocE/bKIEDSFe
         Q6SdQWyvOV9jdr5gLvHhDnIHONB6zoELjONFY8fG8ceEW7Vwt6bilkwyCywKJflYVMZa
         +Z+L3fx6kP73/ERKgt6ilLxPVxeN1+QxDQGibNXYdPmmWBmlPONKMMni1a31Zff/pQrG
         6L/UFzzFUxgWVHv/VbJg15isAmxhCRD0eP3KI7idIL77cIFTwas4UKfRDNowRygQVZe1
         2jUf7O8+rQLhJHFYYSD7+7cX3JiNpnWh+7ldPiElUcRvUsxxyvjM/aj796KHOvxqXWE5
         Ax2w==
X-Gm-Message-State: AOAM531OeXFIV3FOEyAlOaLl6pfdkneMLpm+J/f/d+ZSdzt4QNPpX0RM
        wsi4Rio9g0imc4e7NPrSPf0=
X-Google-Smtp-Source: ABdhPJzMDjmyGsYwEOBJpivSaYej/nh27es/dShY0pitB73TW9TumKyeYNHrTpPYX1GZQYmWeA9nrw==
X-Received: by 2002:a17:906:ecf1:: with SMTP id qt17mr1941989ejb.158.1600902504785;
        Wed, 23 Sep 2020 16:08:24 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id b6sm1021960eds.46.2020.09.23.16.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 16:08:24 -0700 (PDT)
Date:   Thu, 24 Sep 2020 02:08:21 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>
Subject: Re: [PATCH net-next v3 1/2] net: dsa: untag the bridge pvid from rx
 skbs
Message-ID: <20200923230821.s4v4xda732ah3cxy@skbuf>
References: <20200923214038.3671566-1-f.fainelli@gmail.com>
 <20200923214038.3671566-2-f.fainelli@gmail.com>
 <20200923214852.x2z5gb6pzaphpfvv@skbuf>
 <e5f1d482-1b4f-20da-a55b-a953bf52ce8c@gmail.com>
 <20200923225802.vjwwjmw7mh2ru3so@skbuf>
 <a573b81e-d4cc-98ad-31a8-beb37eade1f3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a573b81e-d4cc-98ad-31a8-beb37eade1f3@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 03:59:46PM -0700, Florian Fainelli wrote:
> On 9/23/20 3:58 PM, Vladimir Oltean wrote:
> > On Wed, Sep 23, 2020 at 03:54:59PM -0700, Florian Fainelli wrote:
> >> Not having much luck with using  __vlan_find_dev_deep_rcu() for a reason
> >> I don't understand we trip over the proto value being neither of the two
> >> support Ethertype and hit the BUG().
> >>
> >> +       upper_dev = __vlan_find_dev_deep_rcu(br, htons(proto), vid);
> >> +       if (upper_dev)
> >> +               return skb;
> >>
> >> Any ideas?
> > 
> > Damn...
> > Yes, of course, the skb->protocol is still ETH_P_XDSA which is where
> > eth_type_trans() on the master left it.
> 
> proto was obtained from br_vlan_get_proto() a few lines above, and
> br_vlan_get_proto() just returns br->vlan_proto which defaults to
> htons(ETH_P_8021Q) from br_vlan_init().
> 
> This is not skb->protocol that we are looking at AFAICT.

Ok, my mistake. So what is the value of proto in vlan_proto_idx when it
fails? To me, the call path looks pretty pass-through for vlan_proto.
