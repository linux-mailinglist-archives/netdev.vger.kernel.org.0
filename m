Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1066A4587
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 19:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbfHaRPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 13:15:01 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43529 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727816AbfHaRPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 13:15:01 -0400
Received: by mail-qk1-f193.google.com with SMTP id m2so8963779qkd.10
        for <netdev@vger.kernel.org>; Sat, 31 Aug 2019 10:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=spfNmcaTkZj2m9TBGfZNN3mafpqS7GE57bV0OYUDtc8=;
        b=MxwWuCr1CcSKvCyFeC/f1fw0ibK5jAxPcXyt567uu5kJ6bHdEbpgZH6GmAMKk54TOv
         aLaQQqn0jHacNt3RHweg02RMZ8cBqPFlR5uqYBEtGlAIV5FUvHRdGYajGv/Ww6QgbZuj
         CU/nBhfpMXQ9fiHfhwpXUSQ2vLRgk1ecECTfJxmRklZUhakwrk+DC6z01wbkeNnJLemt
         8pDJwNNzWYI0Z6rIKHQA4/AA6werTPMnPnJ0FbEiJd8pv+41qDs4qB+B2HRyyAgzS6tM
         EolZw37SkRcjeaWJqcK1nMlI+CsjBpg4bdhRbkHenAasXZMW5t5a2rwD10nni/fwFsqQ
         xnvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=spfNmcaTkZj2m9TBGfZNN3mafpqS7GE57bV0OYUDtc8=;
        b=nRx0NB2zXKKSMXuvM5Uji+VNgrNEy9Y3dbfbkzyzeJlIxpuHIwln4LjjuwJpdEIFMg
         cjohniWVGqzKuVExACVdnKHtNpZdHDGVaVa+5Qa8yEJMOl/ESyFB3SxnWZa97WR9xaZE
         XndnxPoJIl9r+3l/ZDqt14+WwJ9BJb9r+SK5yi6+2Veurf+tvWfQtBxO9ILg5Pt2GS66
         G4j4TLFKFG4toSZ7WU0FeaJyIhyTgsa5BWSdtlyxsBF24Ai+o/JaZTPlDqEo1ED7yAXx
         hx7sIkMiGx758KwRERp2zvtbus3iOltpHPwISqs9zXNeyetfs6A2+Iv43lCmTi83/ItE
         yBag==
X-Gm-Message-State: APjAAAWh9SaeK0VCuVCZciTNlVIcL8TS+a3EkzYYWe2OIZjYxpZtig1a
        BZ7p7IFOGgo+jbBh2M/iwdtA/upT
X-Google-Smtp-Source: APXvYqx/HDvxoyyvRCIZOa+mOu5iLiz8XDLHNRN3m4mKPqfE29xfq0mPHe9PzivYcIH5E36mNpJ6Pw==
X-Received: by 2002:a37:e31a:: with SMTP id y26mr21249851qki.51.1567271699909;
        Sat, 31 Aug 2019 10:14:59 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id g4sm4227617qki.47.2019.08.31.10.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2019 10:14:59 -0700 (PDT)
Date:   Sat, 31 Aug 2019 13:14:58 -0400
Message-ID: <20190831131458.GB5642@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: dsa: Fix off-by-one number of calls to
 devlink_port_unregister
In-Reply-To: <CA+h21hoKcg3UUNkYRyEw8FS0q_vxdmoQL90BaOuKoW074DYYow@mail.gmail.com>
References: <20190831124619.460-1-olteanv@gmail.com>
 <20190831121958.GC12031@t480s.localdomain>
 <CA+h21hoKcg3UUNkYRyEw8FS0q_vxdmoQL90BaOuKoW074DYYow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Sat, 31 Aug 2019 19:54:40 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> Fine, I had not noticed the "registered" field from devlink_port.
> But I fail to see how dsa_port_teardown can be entered in the generic
> case from whatever failure state dsa_port_setup left it in. What if
> it's a DSA_PORT_TYPE_CPU whose devlink_port_register failed. What will
> happen to the PHYLINK instance behind dsa_port_link_register_of (not
> to mention about data that the driver might be allocating in
> dsa_port_enable and expecting a matching disable so it won't leak)?
> And that doesn't mean the fix isn't "proper". It may be "supposed" to
> be called unconditionally on error, but right now it isn't, so I doubt
> anybody has tested that, and that there aren't corner cases. Just
> playing the safe side.

You are correct, while I think PHYLINK handles disconnecting properly,
I'm not sure dsa_port_disable is ready yet. Your proposed fix is a
safer solution in the meantime.

> > BTW that is the subtlety between "unregister" which considers that the object
> > _may_ have been registered, and "deregister" which assumes the object _was_
> 
> That concept is not familiar to me. Actually I grepped the DSA API for
> "unregister" and found:

That is not a kernel concept, I was simply pointing out the definitions
from the English language, as I found this interesting. Unfortunately
this isn't honored everywhere in the code, as you've noticed ;-)

> > registered. Would you like to go ahead and propose the devlink patch?
> 
> Nope, I don't really know what I'm getting myself into :) If you want
> to send it, I will consider it during v2.

Sure, I'll propose it myself.


Thanks,

	Vivien
