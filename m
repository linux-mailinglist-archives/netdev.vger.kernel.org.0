Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 415285142D6
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 09:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354910AbiD2HGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 03:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236404AbiD2HGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 03:06:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE34B822F;
        Fri, 29 Apr 2022 00:03:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F4FEB832FA;
        Fri, 29 Apr 2022 07:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420D1C385B2;
        Fri, 29 Apr 2022 07:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651215785;
        bh=YUw9DM7maXM+o6uWOkN5EuzAhffbboxatFY6O6BcD0o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vlYY8/5Pkh1SmvFF0bj6hu1AXEiof4+7RywXfpihw3yR1UjFhi3rlkjdpLtdbQ2OO
         Yhm1ZRFJGqDdWJCHRcD5bvrTa5pK4gE+wK8VBEmIRz1uV7+mUMD0Gv5Zk0+mxmZa87
         DXdG8VAfhSWTolssUQu9l7w4g4tnvEn+/KfKhUzo=
Date:   Fri, 29 Apr 2022 09:03:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-kernel@vger.kernel.org, kuba@kernel.org,
        krzysztof.kozlowski@linaro.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, alexander.deucher@amd.com,
        akpm@linux-foundation.org, broonie@kernel.org,
        netdev@vger.kernel.org, linma@zju.edu.cn
Subject: Re: [PATCH net v5 1/2] nfc: replace improper check
 device_is_registered() in netlink related functions
Message-ID: <YmuNpbnXoOJbh07G@kroah.com>
References: <cover.1651194245.git.duoming@zju.edu.cn>
 <33a282a82c18f942f1f5f9ee0ffcb16c2c7b0ece.1651194245.git.duoming@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33a282a82c18f942f1f5f9ee0ffcb16c2c7b0ece.1651194245.git.duoming@zju.edu.cn>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 29, 2022 at 09:14:32AM +0800, Duoming Zhou wrote:
> The device_is_registered() in nfc core is used to check whether
> nfc device is registered in netlink related functions such as
> nfc_fw_download(), nfc_dev_up() and so on. Although device_is_registered()
> is protected by device_lock, there is still a race condition between
> device_del() and device_is_registered(). The root cause is that
> kobject_del() in device_del() is not protected by device_lock.
> 
>    (cleanup task)         |     (netlink task)
>                           |
> nfc_unregister_device     | nfc_fw_download
>  device_del               |  device_lock
>   ...                     |   if (!device_is_registered)//(1)
>   kobject_del//(2)        |   ...
>  ...                      |  device_unlock
> 
> The device_is_registered() returns the value of state_in_sysfs and
> the state_in_sysfs is set to zero in kobject_del(). If we pass check in
> position (1), then set zero in position (2). As a result, the check
> in position (1) is useless.
> 
> This patch uses bool variable instead of device_is_registered() to judge
> whether the nfc device is registered, which is well synchronized.
> 
> Fixes: 3e256b8f8dfa ("NFC: add nfc subsystem core")
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> ---
> Changes in v5:
>   - Replace device_is_registered() to bool variable.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
