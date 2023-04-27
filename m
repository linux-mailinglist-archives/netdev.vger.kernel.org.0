Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7066F0D99
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 23:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344037AbjD0VIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 17:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343660AbjD0VIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 17:08:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3522D7C
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 14:08:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3C0F611CF
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 21:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E0EC433EF;
        Thu, 27 Apr 2023 21:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682629700;
        bh=63XhmOsW2QfIsLVT1ouilgAbm+6brsp10Pal1crvqVI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rCTK8ANKKyI98uXI0BtgIKd/daBRyf3a95eEuJ8r50SO3MgHC0RtaHrr5xZxdPdRp
         LStjLtNbhtsA17NPWJdiC7s0lqFmeMJUkJAgWSz1I2xpI0Ogo20RIgrZ1VxfBYguOH
         M6ovVfYUhir5LwIChI3Ro8yT62kbNLSoQRbtmKh9Eqbyn6waf77lpgL1bCcAMooL8G
         UtCirX6PlkcnjQ3Tu9Qhhk2rw/xVKKwjr1LEG+Ic9bzpN+sG/nUggllBdHgmGPltNG
         dgOEAu0A7i+9nMHJ5DuTB3ZGCRBMRJ5g/1UQX9MdJgdoyf+9FMqSkZovLGANIXZOFK
         oPLXlT0i4PUIg==
Date:   Thu, 27 Apr 2023 14:08:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     M Chetan Kumar <m.chetan.kumar@intel.com>
Cc:     Samuel Wein PhD <sam@samwein.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Intel Corporation <linuxwwan@intel.com>
Subject: Re: NULL pointer dereference when removing xmm7360 PCI device
Message-ID: <20230427140819.1310f4bd@kernel.org>
In-Reply-To: <Yhw4a065te-PH2rfqCYhLt4RZwLJLek2VsfLDrc8TLjfPqxbw6QKbd7L2PwjA81XlBhUr04Nm8-FjfdSsTlkKnIJCcjqHenPx4cbpRLym-U=@samwein.com>
References: <Yhw4a065te-PH2rfqCYhLt4RZwLJLek2VsfLDrc8TLjfPqxbw6QKbd7L2PwjA81XlBhUr04Nm8-FjfdSsTlkKnIJCcjqHenPx4cbpRLym-U=@samwein.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Apr 2023 10:31:29 +0000 Samuel Wein PhD wrote:
> Hi Folks,
> I've been trying to get the xmm7360 working with IOSM and the ModemManager. This has been what my highschool advisor would call a "learning process".
> When trying `echo 1 > /sys/devices/pci0000:00/0000:00:1c.0/0000:02:00.0/remove` I get a variety of errors. One of these is a kernel error
> `2023-04-27T12:23:38.937223+02:00 Nase kernel: [  587.997430] BUG: kernel NULL pointer dereference, address: 0000000000000048
> 2023-04-27T12:23:38.937237+02:00 Nase kernel: [  587.997447] #PF: supervisor read access in kernel mode
> 2023-04-27T12:23:38.937238+02:00 Nase kernel: [  587.997455] #PF: error_code(0x0000) - not-present page
> 2023-04-27T12:23:38.937241+02:00 Nase kernel: [  587.997463] PGD 0 P4D 0 
> 2023-04-27T12:23:38.937242+02:00 Nase kernel: [  587.997476] Oops: 0000 [#1] PREEMPT SMP NOPTI
> 2023-04-27T12:23:38.937242+02:00 Nase kernel: [  587.997489] CPU: 1 PID: 4767 Comm: bash Not tainted 6.3.0-060300-generic #202304232030
> ...
> `
> the full log is available at https://gist.github.com/poshul/0c5ffbde6106a71adcbc132d828dbcd7
> 
> Steps to reproduce: Boot device with xmm7360 installed and in PCI mode, place into suspend. Resume, and start issuing reset/remove commands to the PCI interface (without properly unloading the IOSM module first).
> 
> I'm not sure how widely applicable this is but wanted to at least report it.

Intel folks, PTAL.
