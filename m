Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53C95547F1
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357235AbiFVMFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 08:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234389AbiFVMFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 08:05:23 -0400
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3265D3DA7B;
        Wed, 22 Jun 2022 05:05:21 -0700 (PDT)
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-317710edb9dso160620597b3.0;
        Wed, 22 Jun 2022 05:05:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yI4NkJ9tQG3vou1hx4UHFZoM6ZFYXNs0D2EVG0DuBZk=;
        b=UM+X2l6xFPOy6XVwl53mVLkPeB7e/5m7gIfFRrWNnaF4HJqSwB3eZzZnTE91VODvpu
         9r+3bYgZxuDvDFEWdkdpeUloUPu3wT5wK5r93zG9PKRkgeMf3Dw2ObGffXJE+Ye0kdjm
         QYpU+FoBBwC2+MPI7IRpHJTmEzn5B2GH4Ldte/3m9KDgzfPy+W5hD6Im1LXQoSh+UOIq
         DIg8D3v2TAug9qbvXA5zkbILL39U+otZ13WmFlxRGb1J965hms3Ga3O2y1JIpAUQqF1J
         VPBDzeXuy5M27r/oqKpUQkX6XgbVQndVDwPPtdJQiWgq1ha24X+8Cd3xIQQWMJwF9QhZ
         g9Mg==
X-Gm-Message-State: AJIora97M1Fky5dHha4vNq3FFxx9Kryi5L+7urL2sgajBCZuqvy6ULpR
        6AVMBu63Zo+Qb+HHXsMYW+KU7tgH6c6Y1DkCo30=
X-Google-Smtp-Source: AGRyM1urPoZoQ3xrgU5g4oEtCQQYk48bScWTjyrE2eQR6nE0SK2a5mzoe+H9CGXazISsucOjFSDQJfs814O9L34ywCk=
X-Received: by 2002:a81:24c7:0:b0:314:1e60:a885 with SMTP id
 k190-20020a8124c7000000b003141e60a885mr3881609ywk.301.1655899520432; Wed, 22
 Jun 2022 05:05:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220620150225.1307946-1-mw@semihalf.com> <20220620150225.1307946-9-mw@semihalf.com>
 <YrDFmw4rziGQJCAu@lunn.ch>
In-Reply-To: <YrDFmw4rziGQJCAu@lunn.ch>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 22 Jun 2022 14:05:09 +0200
Message-ID: <CAJZ5v0g4q8N5wMgk7pRYpYoCLPQoH==Z+nrM0JLyFXSgF9y0+Q@mail.gmail.com>
Subject: Re: [net-next: PATCH 08/12] ACPI: scan: prevent double enumeration of
 MDIO bus children
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Len Brown <lenb@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        upstream@semihalf.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 9:08 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Mon, Jun 20, 2022 at 05:02:21PM +0200, Marcin Wojtas wrote:
> > The MDIO bus is responsible for probing and registering its respective
> > children, such as PHYs or other kind of devices.
> >
> > It is required that ACPI scan code should not enumerate such
> > devices, leaving this task for the generic MDIO bus routines,
> > which are initiated by the controller driver.
>
> I suppose the question is, should you ignore the ACPI way of doing
> things, or embrace the ACPI way?

What do you mean by "the ACPI way"?

> At least please add a comment why the ACPI way is wrong, despite this
> being an ACPI binding.

The question really is whether or not it is desirable to create
platform devices for all of the objects found in the ACPI tables that
correspond to the devices on the MDIO bus.

I don't think it is, so it should be avoided.
