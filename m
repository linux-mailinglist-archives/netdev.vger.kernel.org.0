Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E514A555136
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 18:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376509AbiFVQVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 12:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357785AbiFVQVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 12:21:43 -0400
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB99D3C720;
        Wed, 22 Jun 2022 09:21:42 -0700 (PDT)
Received: by mail-yb1-f171.google.com with SMTP id l11so31024156ybu.13;
        Wed, 22 Jun 2022 09:21:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J8NTAQ80ksAaXTU0NZQhSXj7741XMCwbMsx5gXXQTtg=;
        b=U8dPlnJnCw3yO8+ggB8bMoWrXINcFidWU8E/In9oXaCFJ3QKnyWCCeKuGzbj98zu9z
         vSwSNeChn06zjiBvzW5M8Ido5kUETGUPXOjRUVcsfOYEnBLHiOItwjDf8oQvmrmyTpQl
         yjEHqfr8IOEWnlnm23zuDyqzMNYiPB/kjIymcDAnSCAoSdoePRMnGb0NmibHs06wxdDI
         /vesRYrSgurTLjTKWTygB5Pnpt0c0ZeZAi1vAkvIvi+kphtq6FB57CZUNGc7P55LCvx9
         ylog53m2yCWdq9PgQUj/8MMmuhwyf88ewCeiwZUSwhAXDguoBwEzyUVqQyhbiaxq4VIE
         sEZA==
X-Gm-Message-State: AJIora+BcJBgJakfmCCA43nr2Kb64/cBYGjrmbYx52i2E7G0I6FlhLAA
        IWNkJd9obyen6xXMPwRpmfdaniaiRbB7lxx4ueTmrtyD2WY=
X-Google-Smtp-Source: AGRyM1s29ZRQGrHG8aK/LQ9rK/TrvkflQzh7hpqVbott/qGX8Pf/fUqVRzomWlpQkonyMAsASrGPYIlXTaoDDL//5Z8=
X-Received: by 2002:a25:d841:0:b0:668:ab2f:7b01 with SMTP id
 p62-20020a25d841000000b00668ab2f7b01mr4581583ybg.482.1655914902208; Wed, 22
 Jun 2022 09:21:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220620150225.1307946-1-mw@semihalf.com> <20220620150225.1307946-9-mw@semihalf.com>
 <YrDFmw4rziGQJCAu@lunn.ch> <CAJZ5v0g4q8N5wMgk7pRYpYoCLPQoH==Z+nrM0JLyFXSgF9y0+Q@mail.gmail.com>
 <54618c2a-e1f3-bbd0-8fb2-1669366a3b59@gmail.com>
In-Reply-To: <54618c2a-e1f3-bbd0-8fb2-1669366a3b59@gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 22 Jun 2022 18:21:31 +0200
Message-ID: <CAJZ5v0j3A-VYFgcnziSqejp-qJVbrbyFP40S-m9eYTv=H9J0ow@mail.gmail.com>
Subject: Re: [net-next: PATCH 08/12] ACPI: scan: prevent double enumeration of
 MDIO bus children
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Marcin Wojtas <mw@semihalf.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Len Brown <lenb@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
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

On Wed, Jun 22, 2022 at 6:12 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 6/22/22 05:05, Rafael J. Wysocki wrote:
> > On Mon, Jun 20, 2022 at 9:08 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >>
> >> On Mon, Jun 20, 2022 at 05:02:21PM +0200, Marcin Wojtas wrote:
> >>> The MDIO bus is responsible for probing and registering its respective
> >>> children, such as PHYs or other kind of devices.
> >>>
> >>> It is required that ACPI scan code should not enumerate such
> >>> devices, leaving this task for the generic MDIO bus routines,
> >>> which are initiated by the controller driver.
> >>
> >> I suppose the question is, should you ignore the ACPI way of doing
> >> things, or embrace the ACPI way?
> >
> > What do you mean by "the ACPI way"?
> >
> >> At least please add a comment why the ACPI way is wrong, despite this
> >> being an ACPI binding.
> >
> > The question really is whether or not it is desirable to create
> > platform devices for all of the objects found in the ACPI tables that
> > correspond to the devices on the MDIO bus.
>
> If we have devices hanging off a MDIO bus then they are mdio_device (and
> possibly a more specialized object with the phy_device which does embedd
> a mdio_device object), not platform devices, since MDIO is a bus in itself.

Well, that's what I'm saying.

And when the ACPI subsystem finds those device objects present in the
ACPI tables, the mdio_device things have not been created yet and it
doesn't know which ACPI device object will correspond to mdio_device
eventually unless it is told about that somehow.  One way of doing
that is to use a list of device IDs in the kernel.  The other is to
have the firmware tell it about that which is what we are discussing.
