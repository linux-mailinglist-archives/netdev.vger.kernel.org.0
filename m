Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83BE3459B4F
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 05:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbhKWExC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 23:53:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbhKWExB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 23:53:01 -0500
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31DEC061574
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 20:49:53 -0800 (PST)
Received: by mail-ua1-x929.google.com with SMTP id ay21so41147822uab.12
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 20:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E3zj0Xvi6nQmtSwV5YbfPL5s5izrK3ijx/jXcnmBti0=;
        b=ETPPaFLhq0ah8PbvC7+vWT1ghUaEwX/usJ3TbOvUiyLE1bX/SXGniut0XDmP9ty2Y4
         UoVQFH8wqWdTmS3A5GrDTJRj/c9oGB4rSzY37Y05Te8i3vrkc4C2Py9/w6p8tgKh259S
         yFL+J+VGtX1C/x18/CZMn+F+gbjIo/TC4FTGM8S+cI0iz/FShjeQ7QXnH45Yq+hb7ZIl
         LYo+qkMqeAQPeuV2ZljDfsWAQ9zpvWFAeebEqQFKlmB+fsoaY0atkq4qo1cAX/M2pg+O
         9Bv1ak0RhLIYVasYtIUoFp79fbEz1flJAR/ywGLM2rdDmLDCBE8gLUCKU86vfq/r4K3E
         0WSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E3zj0Xvi6nQmtSwV5YbfPL5s5izrK3ijx/jXcnmBti0=;
        b=5m5/4Bb8vdXXLID4TsQLvHC+NTXPkCkmt+mEvoS5LhuZDunxoi9QHabMoCGN369/sW
         cSEOxWLudV8iCu6fOCQWrmfTqrQ1JL3ZJZwHQCYYt289r4PMQffuYcxiz2NPyG2rKkbd
         9ZTq9m3nzVOJx8P9xjGZPD5s9fyR/fK5pRxz6NAu7p7kg+sTMJR3LZWA2FktGuqrCLIw
         gEVIUECjESoDFDJzkuDsJaJ+M+bdweK2Zq1+kVXvsLyIfEo/E71c92XU3nLQXjGxyPN6
         qVMvxfKDYRp8M/k+CFO1IwRmuEYTfqjVUI35MzPq17pX6+Iun+ieKJ5Mi9jup3JEoLyH
         ayXA==
X-Gm-Message-State: AOAM5336/6xnDPbXW+iL50bAYR7uBzj0CQF1k7Mw0sD7DLMraQRUsEEL
        WIPLN6pu8XkQ7Jg8tbhZwpf3YxtAtaMWSw==
X-Google-Smtp-Source: ABdhPJzcRNRUmLzbeMhITG2OZJFuKd7FrCKGMFvsnfNEkPJ/jv+5ciuglM3/Jk/28p/dV38zVtnV+g==
X-Received: by 2002:a05:6102:2389:: with SMTP id v9mr4128033vsr.34.1637642993064;
        Mon, 22 Nov 2021 20:49:53 -0800 (PST)
Received: from work ([187.105.166.74])
        by smtp.gmail.com with ESMTPSA id y28sm5664097vkl.22.2021.11.22.20.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 20:49:52 -0800 (PST)
Date:   Tue, 23 Nov 2021 01:49:46 -0300
From:   Alessandro B Maurici <abmaurici@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] phy: fix possible double lock calling link changed
 handler
Message-ID: <20211123014946.1ec2d7ee@work>
In-Reply-To: <YZxrhhm0YdfoJcAu@lunn.ch>
References: <20211122235548.38b3fc7c@work>
        <YZxrhhm0YdfoJcAu@lunn.ch>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Nov 2021 05:18:14 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> On Mon, Nov 22, 2021 at 11:55:48PM -0300, Alessandro B Maurici wrote:
> > From: Alessandro B Maurici <abmaurici@gmail.com>
> > 
> > Releases the phy lock before calling phy_link_change to avoid any worker
> > thread lockup. Some network drivers(eg Microchip's LAN743x), make a call to
> > phy_ethtool_get_link_ksettings inside the link change handler  
> 
> I think we need to take a step back here and answer the question, why
> does it call phy_ethtool_get_link_ksettings in the link change
> handler. I'm not aware of any other MAC driver which does this.
> 
> 	 Andrew

I agree, the use in the lan743x seems related to the PTP, that driver seems
to be the only one using it, at least in the Linus tree. 
I think that driver could be patched as there are other ways to do it,
but my take on the problem itself is that the PHY device interface opens
a way to break the flow and this behavior does not seem to be documented,
so, instead of documenting a possible harmful interface while in the callback,
we should just get rid of the problem itself, and calling a callback without
any locks held seems to be a good alternative.
This is also a non critical performance path and the additional code
would not impact much, of course it makes the stuff less nice to look at.
The patch also has an additional check for the lock, since there is a 
function that is not calling the lock explicitly and has a warn if the lock
is not held at the start, so I put it there to be extra safe.

Alessandro
