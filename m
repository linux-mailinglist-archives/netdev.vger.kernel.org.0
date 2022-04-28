Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64115512D29
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 09:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245587AbiD1Hlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 03:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245380AbiD1Hld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 03:41:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136679D053;
        Thu, 28 Apr 2022 00:38:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DB0761F0E;
        Thu, 28 Apr 2022 07:38:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA67FC385A9;
        Thu, 28 Apr 2022 07:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651131497;
        bh=HBavIu4za5pQy6Uyy5w7OIPHjiIyH/SYuPHJyzAYvLY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F8vQK1kjB/QmpADb/h80QR+4V8/SMOWEHptv5pgrh/Qoj8PkCVi2emP4WETnj9W9r
         HmwDh3Rl7oLCeb6Yfm9NLCcObfwVoMtM7U0N3XKUS5l+VQvbDkvnHeJ5YGs9rXwp1s
         50DwWTTiDOIc2TqP74plQ0s101iklf+6n43u9Jyg=
Date:   Thu, 28 Apr 2022 09:38:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Duoming Zhou <duoming@zju.edu.cn>,
        krzysztof.kozlowski@linaro.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        alexander.deucher@amd.com, akpm@linux-foundation.org,
        broonie@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v4] nfc: ... device_is_registered() is data race-able
Message-ID: <YmpEZQ7EnOIWlsy8@kroah.com>
References: <20220427011438.110582-1-duoming@zju.edu.cn>
 <20220427174548.2ae53b84@kernel.org>
 <38929d91.237b.1806f05f467.Coremail.linma@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <38929d91.237b.1806f05f467.Coremail.linma@zju.edu.cn>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 03:15:02PM +0800, Lin Ma wrote:
> Hello Jakub,
> 
> and hello there maintainers, when we tried to fix this race problem, we found another very weird issue as below
> 
> > 
> > You can't use a single global variable, there can be many devices 
> > each with their own lock.
> > 
> > Paolo suggested adding a lock, if spin lock doesn't fit the bill
> > why not add a mutex?
> 
> The lock patch can be added to nfcmrvl code but we prefer to fix this in the NFC core layer hence every other driver that supports the firmware downloading task will be free of such a problem.
> 
> But when we analyze the race between the netlink tasks and the cleanup routine, we find some *condition checks* fail to fulfill their responsibility.
> 
> For example, we once though that the device_lock + device_is_registered check can help to fix the race as below.
> 
>   netlink task              |  cleanup routine
>                             |
> nfc_genl_fw_download        | nfc_unregister_device 
>   nfc_fw_download           |   device_del 
>     device_lock             |     device_lock
>     // wait lock            |       kobject_del
>     // ...                  |         ...
>     device_is_registered    |     device_unlock    
>       rc = -ENODEV          |
> 
> However, by dynamic debugging this issue, we find out that **even after the device_del**, the device_is_registered check still returns TRUE!

You should not be making these types of checks outside of the driver
core.

> This is by no means matching our expectations as one of our previous patch relies on the device_is_registered code.

Please do not do that.

> 
> -> the patch: 3e3b5dfcd16a ("NFC: reorder the logic in nfc_{un,}register_device")
> 
> To find out why, we find out the device_is_registered is implemented like below:
> 
> static inline int device_is_registered(struct device *dev)
> {
> 	return dev->kobj.state_in_sysfs;
> }
> 
> By debugging, we find out in normal case, this kobj.state_in_sysfs will be clear out like below
> 
> [#0] 0xffffffff81f0743a → __kobject_del(kobj=0xffff888009ca7018)
> [#1] 0xffffffff81f07882 → kobject_del(kobj=0xffff888009ca7018)
> [#2] 0xffffffff81f07882 → kobject_del(kobj=0xffff888009ca7018)
> [#3] 0xffffffff827708db → device_del(dev=0xffff888009ca7018)
> [#4] 0xffffffff8396496f → nfc_unregister_device(dev=0xffff888009ca7000)
> [#5] 0xffffffff839850a9 → nci_unregister_device(ndev=0xffff888009ca3000)
> [#6] 0xffffffff82811308 → nfcmrvl_nci_unregister_dev(priv=0xffff88800c805c00)
> [#7] 0xffffffff83990c4f → nci_uart_tty_close(tty=0xffff88800b450000)
> [#8] 0xffffffff820f6bd3 → tty_ldisc_kill(tty=0xffff88800b450000)
> [#9] 0xffffffff820f7fb1 → tty_ldisc_hangup(tty=0xffff88800b450000, reinit=0x0)
> 
> The clear out is in function __kobject_del
> 
> static void __kobject_del(struct kobject *kobj)
> {
>    // ...
> 
> 	kobj->state_in_sysfs = 0;
> 	kobj_kset_leave(kobj);
> 	kobj->parent = NULL;
> }
> 
> The structure of device_del is like below
> 
> void device_del(struct device *dev)
> {
> 	struct device *parent = dev->parent;
> 	struct kobject *glue_dir = NULL;
> 	struct class_interface *class_intf;
> 	unsigned int noio_flag;
> 
> 	device_lock(dev);
> 	kill_device(dev);
> 	device_unlock(dev);
>         
>         // ...
>         kobject_del(&dev->kobj);
> 	cleanup_glue_dir(dev, glue_dir);
> 	memalloc_noio_restore(noio_flag);
> 	put_device(parent);
> }
> 
> In another word, the device_del -> kobject_del -> __kobject_del is not protected by the device_lock.

Nor should it be.

> This means the device_lock + device_is_registered is still prone to the data race. And this is not just the problem with firmware downloading. The all relevant netlink tasks that use the device_lock + device_is_registered is possible to be raced.
> 
> To this end, we will come out with two patches, one for fixing this device_is_registered by using another status variable instead. The other is the patch that reorders the code in nci_unregister_device.

Why is this somehow unique to these devices?  Why do no other buses have
this issue?  Are you somehow allowing a code path that should not be
happening?

thanks,

greg k-h
