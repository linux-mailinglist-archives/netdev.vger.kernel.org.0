Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3D9513550
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 15:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347407AbiD1Nkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 09:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235759AbiD1Nk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 09:40:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB9B972C0;
        Thu, 28 Apr 2022 06:37:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72D77B82D13;
        Thu, 28 Apr 2022 13:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD444C385A0;
        Thu, 28 Apr 2022 13:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651153029;
        bh=j8aQI14XIEgswr7w1bn7LZ21u3HZPMe7XhOS1IK4t1E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1Ej7qvEr99F8mKrSJJv3VejrqNgv64Ui+b3yB7Fc+h74A4kvWN14um8eEPoCBjQdp
         oP7Qo9IutHjy23rO6jOMWbc/CubxyxP7IMvUKvtqszfy2b5OCIiyy0rhOKxC+zwe1u
         MK8cDg4o/SP1XkwmLeO3jlLu252ChcIgm07BQYEI=
Date:   Thu, 28 Apr 2022 15:37:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     Duoming Zhou <duoming@zju.edu.cn>, krzysztof.kozlowski@linaro.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        davem@davemloft.net, alexander.deucher@amd.com,
        akpm@linux-foundation.org, broonie@kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net v4] nfc: ... device_is_registered() is data race-able
Message-ID: <YmqYgu++0OuhfFxy@kroah.com>
References: <20220427011438.110582-1-duoming@zju.edu.cn>
 <20220427174548.2ae53b84@kernel.org>
 <38929d91.237b.1806f05f467.Coremail.linma@zju.edu.cn>
 <YmpEZQ7EnOIWlsy8@kroah.com>
 <2d7c9164.2b1f.1806f2a8ed9.Coremail.linma@zju.edu.cn>
 <YmpNZOaJ1+vWdccK@kroah.com>
 <15d09db2.2f76.1806f5c4187.Coremail.linma@zju.edu.cn>
 <YmpcUNf7O+OK6/Ax@kroah.com>
 <20220428060628.713479b2@kernel.org>
 <f51aa1.41ae.180705614b5.Coremail.linma@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f51aa1.41ae.180705614b5.Coremail.linma@zju.edu.cn>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 09:22:11PM +0800, Lin Ma wrote:
> Hello there,
> 
> > 
> > Yes, that looks better, 
> 
> Cool, thanks again for giving comments. :)
> 
> > but what is the root problem here that you are
> > trying to solve?  Why does NFC need this when no other subsystem does?
> > 
> 
> Well, in fact, me and Duoming are keep finding concurrency bugs that happen 
> between the device cleanup/detach routine and other undergoing routines.
> 
> That is to say, when a device, no matter real or virtual, is detached from 
> the machine, the kernel awake cleanup routine to reclaim the resource. 
> In current case, the cleanup routine will call nfc_unregister_device().
> 
> Other routines, mainly from user-space system calls, need to be careful of 
> the cleanup event. In another word, the kernel need to synchronize these 
> routines to avoid race bugs.
> 
> In our practice, we find that many subsystems are prone to this type of bug.
> 
> For example, in bluetooth we fix
> 
> BT subsystem
> * e2cb6b891ad2 ("bluetooth: eliminate the potential race condition when removing
> the HCI controller")
> * fa78d2d1d64f ("Bluetooth: fix data races in smp_unregister(), smp_del_chan()")
> ..
> 
> AX25 subsystem
> * 1ade48d0c27d ("ax25: NPD bug when detaching AX25 device")
> ..
> 
> we currently focus on the net relevant subsystems and we now is auditing the NFC 
> code.
> 
> In another word, all subsystems need to take care of the synchronization issues.
> But seems that the solutions are varied between different subsystem. 
> 
> Empirically speaking, most of them use specific flags + specific locks to prevent
> the race. 
> 
> In such cases, if the cleanup routine first hold the lock, the other routines will
> wait on the locks. Since the cleanup routine write the specific flag, the other
> routine, after check the specific flag, will be aware of the cleanup stuff and just
> abort their tasks.
> If the other routines first hold the lock, the cleanup routine just wait them to 
> finish.
> 
> NFC here is special because it uses device_is_registered. I thought the author may
> believe this macro is race free. However, it is not. So we need to replace this check
> to make sure the netlink functions will 100 percent be aware of the cleanup routine
> and abort the task if they grab the device_lock lately. Otherwise, the nelink routine
> will call sub-layer code and possilby dereference resources that already freed.
> 
> For example, one of my recent fix 3e3b5dfcd16a ("NFC: reorder the logic in 
> nfc_{un,}register_device") takes the suggestion from maintainer as he thought the 
> device_is_registered is enough. And for now we find out this device_is_registered
> is not enough.

How do you physically remove a NFC device from a system?  What types of
busses are they on?  If non-removable one, then odds are there's not
going to be many races so this is a low-priority thing.  If they can be
on removable busses (USB, PCI, etc.), then that's a bigger thing.

But again, the NFC bus code should handle all of this for the drivers,
there's nothing special about NFC that should warrant a special need for
this type of thing.

thanks,

greg k-h
