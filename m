Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5DE66CF0C3
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 19:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbjC2RLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 13:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbjC2RLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 13:11:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA99729A
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 10:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680109806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sm8uA8G582IjwCJO3aOm/Kk3OQ+yP/i24Xan1y7i8U8=;
        b=VQEJRmrPInTW3gmF5gulPrWOwkrooy0iiab8v7ypGIYqA/0JgnNxyMZbRFaLcoZAyanDH6
        HTWi1H2nxjBQ+x3f8OEnNirO8A6+o5TKBgkYzZgmdIE0g9Jgg7xJx8f+HW6zQtCO9iLdzL
        llRszp3xwYDY5Eth5GAO1Lo/CZGFWWQ=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-12nbd1l_PV28JKLSrIjZtA-1; Wed, 29 Mar 2023 13:10:05 -0400
X-MC-Unique: 12nbd1l_PV28JKLSrIjZtA-1
Received: by mail-il1-f198.google.com with SMTP id z7-20020a921a47000000b0032600db79f7so7064395ill.18
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 10:10:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680109804;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sm8uA8G582IjwCJO3aOm/Kk3OQ+yP/i24Xan1y7i8U8=;
        b=bmEPw8qUa0CrtvkN8oFqTwkQFa6826900fOaXqkBYMr3wA9QOp22N5kRpc6FKTGlWJ
         fDmntcRr+aQ6vYx7saeVS7lo5JOIAL3y4b+XGY3pQgTQ1/jHNa9ZvS+RAbbw6kFTod9R
         k7WMpYL+7nRUUbLXImi6+hU9pSfXv1evqFBCtIaZ5okMq5mXgjXslnUBeQlpJmN2Go45
         Y9OVVP+6QJa7YcGiOoy3KcJbGPKbVHtcnjA1iwU+0BLcKM1pPvFngAAFlKlKTWafry81
         u2L12UM6AkVa3PMNh8ps9cRVYmQy/ts2izzOuWugs5VMVdZaaZN+En9MJF50t/wfSRsz
         BHEA==
X-Gm-Message-State: AAQBX9fb80IMFWXz8cpuOMcy+1y/GS8y/kvzxkBzzGnhB70/QMsUYSAK
        Act+ewL6RY4enjvYn4gG/+unJE3leVIvNLu2+M2Yv1ucAJuIorDoGc3Npj2pvtEcE3cTchrv8iH
        1ElmVTfAf76GFchgo
X-Received: by 2002:a5e:880c:0:b0:74d:1ccb:e5a5 with SMTP id l12-20020a5e880c000000b0074d1ccbe5a5mr2472549ioj.6.1680109803952;
        Wed, 29 Mar 2023 10:10:03 -0700 (PDT)
X-Google-Smtp-Source: AKy350aBf8PtoDf19Dap6GtipX8y7v1yqM3xfe+1J+j5ciRQDju/dl+9/wT+b9ln8HsMW6oQVwUxKA==
X-Received: by 2002:a5e:880c:0:b0:74d:1ccb:e5a5 with SMTP id l12-20020a5e880c000000b0074d1ccbe5a5mr2472525ioj.6.1680109803603;
        Wed, 29 Mar 2023 10:10:03 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g4-20020a6be604000000b007592d781128sm4400887ioh.30.2023.03.29.10.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 10:10:03 -0700 (PDT)
Date:   Wed, 29 Mar 2023 11:10:01 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Amit Cohen <amcohen@nvidia.com>, mlxsw@nvidia.com,
        linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH net-next 6/6] mlxsw: pci: Add support for new reset flow
Message-ID: <20230329111001.44a8c8e0.alex.williamson@redhat.com>
In-Reply-To: <20230329160144.GA2967030@bhelgaas>
References: <ZCBOdunTNYsufhcn@shredder>
        <20230329160144.GA2967030@bhelgaas>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 11:01:44 -0500
Bjorn Helgaas <helgaas@kernel.org> wrote:

> [+cc Alex, Lukas for link-disable reset thoughts, beginning of thread:
> https://lore.kernel.org/all/cover.1679502371.git.petrm@nvidia.com/]
> 
> On Sun, Mar 26, 2023 at 04:53:58PM +0300, Ido Schimmel wrote:
> > On Thu, Mar 23, 2023 at 11:51:15AM -0500, Bjorn Helgaas wrote:  
> > > On Wed, Mar 22, 2023 at 05:49:35PM +0100, Petr Machata wrote:  
> > > > From: Amit Cohen <amcohen@nvidia.com>
> > > > 
> > > > The driver resets the device during probe and during a devlink reload.
> > > > The current reset method reloads the current firmware version or a pending
> > > > one, if one was previously flashed using devlink. However, the reset does
> > > > not take down the PCI link, preventing the PCI firmware from being
> > > > upgraded, unless the system is rebooted.  
> > > 
> > > Just to make sure I understand this correctly, the above sounds like
> > > "firmware" includes two parts that have different rules for loading:
> > > 
> > >   - Current reset method is completely mlxsw-specific and resets the
> > >     mlxsw core but not the PCIe interface; this loads only firmware
> > >     part A
> > > 
> > >   - A PCIe reset resets both the mlxsw core and the PCIe interface;
> > >     this loads both firmware part A and part B  
> > 
> > Yes. A few years ago I had to flash a new firmware in order to test a
> > fix in the PCIe firmware and the bug still reproduced after a devlink
> > reload. Only after a reboot the new PCIe firmware was loaded and the bug
> > was fixed. Bugs in PCIe firmware are not common, but we would like to
> > avoid the scenario where users must reboot the machine in order to load
> > the new firmware.
> >   
> > > > To solve this problem, a new reset command (6) was implemented in the
> > > > firmware. Unlike the current command (1), after issuing the new command
> > > > the device will not start the reset immediately, but only after the PCI
> > > > link was disabled. The driver is expected to wait for 500ms before
> > > > re-enabling the link to give the firmware enough time to start the reset.  
> > > 
> > > I guess the idea here is that the mlxsw driver:
> > > 
> > >   - Tells the firmware we're going to reset
> > >     (MLXSW_REG_MRSR_COMMAND_RESET_AT_PCI_DISABLE)
> > > 
> > >   - Saves PCI config state
> > > 
> > >   - Disables the link (mlxsw_pci_link_toggle()), which causes a PCIe
> > >     hot reset
> > > 
> > >   - The firmware notices the link disable and starts its own internal
> > >     reset
> > > 
> > >   - The mlxsw driver waits 500ms
> > >     (MLXSW_PCI_TOGGLE_WAIT_BEFORE_EN_MSECS)
> > > 
> > >   - Enables link and waits for it to be active
> > >     (mlxsw_pci_link_active_check()
> > > 
> > >   - Waits for device to be ready again (mlxsw_pci_device_id_read())  
> > 
> > Correct.
> >   
> > > So the first question is why you don't simply use
> > > pci_reset_function(), since it is supposed to cause a reset and do all
> > > the necessary waiting for the device to be ready.  This is quite
> > > complicated to do correctly; in fact, we still discover issues there
> > > regularly.  There are many special cases in PCIe r6.0, sec 6.6.1, and
> > > it would be much better if we can avoid trying to handle them all in
> > > individual drivers.  
> > 
> > I see that this function takes the device lock and I think (didn't try)
> > it will deadlock if we were to replace the current code with it since we
> > also perform a reset during probe where I believe the device lock is
> > already taken.
> > 
> > __pci_reset_function_locked() is another option, but it assumes the
> > device lock was already taken, which is correct during probe, but not
> > when reset is performed as part of devlink reload.
> > 
> > Let's put the locking issues aside and assume we can use
> > __pci_reset_function_locked(). I'm trying to figure out what it can
> > allow us to remove from the driver in favor of common PCI code. It
> > essentially invokes one of the supported reset methods. Looking at my
> > device, I see the following:
> > 
> >  # cat /sys/class/pci_bus/0000\:01/device/0000\:01\:00.0/reset_method 
> >  pm bus
> > 
> > So I assume it will invoke pci_pm_reset(). I'm not sure it can work for
> > us as our reset procedure requires us to disable the link on the
> > downstream port as a way of notifying the device that it should start
> > the reset procedure.  
> 
> Hmmm, pci_pm_reset() puts the device in D3hot, then back to D0.  Spec
> says that results in "undefined internal Function state," which
> doesn't even sound like a guaranteed reset, but it's what we have, and
> in any case, it does not disable the link.
> 
> > We might be able to use the "device_specific" method and add quirks in
> > "pci_dev_reset_methods". However, I'm not sure what would be the
> > benefit, as it basically means moving the code in
> > mlxsw_pci_link_toggle() to drivers/pci/quirks.c. Also, when the "probe"
> > argument is "true" we can't actually determine if this reset method is
> > supported or not, as we can't query that from the configuration space of
> > the device in the current implementation. It's queried using a command
> > interface that is specific to mlxsw and resides in the driver itself.
> > Not usable from drivers/pci/quirks.c.  
> 
> Spec (PCIe r6.0, sec 6.6.1) says "Disabling a Link causes Downstream
> components to undergo a hot reset."  That seems like it *could* be a
> general-purpose method of doing a reset, and I don't know why the PCI
> core doesn't support it.  Added Alex and Lukas in case they know.

I think we don't have it because it's unclear how it's actually
different from a secondary bus reset from the bridge control register,
which is what "bus" would do when selected for the example above.  Per
the spec, both must cause a hot reset.  It seems this device needs a
significantly longer delay though.

Note that hot resets can be generated by a userspace driver with
ownership of the device and will make use of the pci-core reset
mechanisms.  Therefore if there is not a device specific reset, we'll
use the standard delays and the device ought not to get itself wedged
if the link becomes active at an unexpected point relative to a
firmware update.  This might be a point in favor of a device specific
reset solution in pci-core.  Thanks,

Alex
 
> But it sounds like there's some wrinkle with your device?  I suppose a
> link disable actually causes a reset, but that reset may not trigger
> the firmware reload you need?  If we had a generic "disable link"
> reset method, maybe a device quirk could disable it if necessary?
> 
> > > Of course, pci_reset_function() does *not* include details like
> > > MLXSW_PCI_TOGGLE_WAIT_BEFORE_EN_MSECS.
> > > 
> > > I assume that flashing the firmware to the device followed by a power
> > > cycle (without ever doing MLXSW_REG_MRSR_COMMAND_RESET_AT_PCI_DISABLE)
> > > would load the new firmware everywhere.  Can we not do the same with a
> > > PCIe reset?  
> > 
> > Yes, that's what we would like to achieve.
> > 
> > Thanks for the feedback!  
> 

