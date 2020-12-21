Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23E12E02E1
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 00:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgLUXWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 18:22:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgLUXWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 18:22:49 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427C9C0613D3
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 15:22:09 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id q1so10408405ilt.6
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 15:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nKBSHG6KDmtV3l2AhApkAlTc7JRuGFd2X8Ov/hLUXsk=;
        b=rnVEzSgiIWyLER4vtLzDABVc02/ghcO/TUN5ofdq28J/jKFOVUrFvFjK5r3scrDIuk
         htR8iVZFxjY4vwYlqZyruzV2CzThg6cK4ry83cOLF9wIhYIBkjTmmo6yTCH/9KNoNdbO
         MjUtvYit1q3AqrsxCqrp+788CBBrbOftJTfA1FiWnXNXMjB2GJDP4AJ8xpXpya8iR7Rk
         VV2thuGBaVD6OB0gPWNELbyU2hgVw8qw8w0eqwH25mRxiWanH9zi1cTkOa8P3S3Kephy
         WdlPPjnBUWxn7gknrGFI+8riWM1Rs6P+gabKWOHJWOLkKDJh/ggjogau6B+eHN+KUKIA
         RwGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nKBSHG6KDmtV3l2AhApkAlTc7JRuGFd2X8Ov/hLUXsk=;
        b=f7iKbE1b4/5yW2hI7vQ7h9oMadDWOVZIKrBTqx89+Ie1n/dtCck7dvN1kfQr6e1YCM
         UnpTKlLP9erVNoaCwuQUCLupkavLTHgCeESiSIp7lNnYrVNBpUQd1iofWtblPV1JqHfh
         zNWyOHbZYnlljFOxhQWWggujgS/Hfx9bBJpIi8bJ3/ta9XL01v5w21cT/V8YZYwHlzz7
         XPvqzyVk0trg862wsPSX8EIsr/3EoaH+67RrfrK3ndVxn0rONCmnEX3L2FmUGhzYXUhE
         TqaGA0DnwV9FXs8LYMKLYO28yuRJeTN6TGJr5ycIiwlQJC9v6pGrbjgGQbbQzvHIzZk5
         2W8Q==
X-Gm-Message-State: AOAM5309penm1omgZ58zWYB3d8s8yxb0N21QDG/2Cp1Bme3ms+sn8gfD
        uRNFON0TKUXRG9mQckoZjTpsZexxQFibO8W3SHAX2/vDA28=
X-Google-Smtp-Source: ABdhPJyfvljHaxzRwORw2gxANI8H4t6KJrIBnEwdC7roJsMk8dpsqw/atPAl7Lk1qFgHu4eQggxyL6DD9BR5I7GMQIs=
X-Received: by 2002:a05:6e02:929:: with SMTP id o9mr17970250ilt.42.1608592928569;
 Mon, 21 Dec 2020 15:22:08 -0800 (PST)
MIME-Version: 1.0
References: <20201221193644.1296933-1-atenart@kernel.org> <20201221193644.1296933-2-atenart@kernel.org>
In-Reply-To: <20201221193644.1296933-2-atenart@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 21 Dec 2020 15:21:57 -0800
Message-ID: <CAKgT0UfTgYhED1f6vdsoT72A3=D2Grh4U-A6pp43FLZoCs30Gw@mail.gmail.com>
Subject: Re: [PATCH net v2 1/3] net: fix race conditions in xps by locking the
 maps and dev->tc_num
To:     Antoine Tenart <atenart@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 21, 2020 at 11:36 AM Antoine Tenart <atenart@kernel.org> wrote:
>
> Two race conditions can be triggered in xps, resulting in various oops
> and invalid memory accesses:
>
> 1. Calling netdev_set_num_tc while netif_set_xps_queue:
>
>    - netdev_set_num_tc sets dev->tc_num.
>
>    - netif_set_xps_queue uses dev->tc_num as one of the parameters to
>      compute the size of new_dev_maps when allocating it. dev->tc_num is
>      also used to access the map, and the compiler may generate code to
>      retrieve this field multiple times in the function.
>
>    If new_dev_maps is allocated using dev->tc_num and then dev->tc_num
>    is set to a higher value through netdev_set_num_tc, later accesses to
>    new_dev_maps in netif_set_xps_queue could lead to accessing memory
>    outside of new_dev_maps; triggering an oops.
>
>    One way of triggering this is to set an iface up (for which the
>    driver uses netdev_set_num_tc in the open path, such as bnx2x) and
>    writing to xps_cpus or xps_rxqs in a concurrent thread. With the
>    right timing an oops is triggered.
>
> 2. Calling netif_set_xps_queue while netdev_set_num_tc is running:
>
>    2.1. netdev_set_num_tc starts by resetting the xps queues,
>         dev->tc_num isn't updated yet.
>
>    2.2. netif_set_xps_queue is called, setting up the maps with the
>         *old* dev->num_tc.
>
>    2.3. dev->tc_num is updated.
>
>    2.3. Later accesses to the map leads to out of bound accesses and
>         oops.
>
>    A similar issue can be found with netdev_reset_tc.
>
>    The fix can't be to only link the size of the maps to them, as
>    invalid configuration could still occur. The reset then set logic in
>    both netdev_set_num_tc and netdev_reset_tc must be protected by a
>    lock.
>
> Both issues have the same fix: netif_set_xps_queue, netdev_set_num_tc
> and netdev_reset_tc should be mutually exclusive.
>
> This patch fixes those races by:
>
> - Reworking netif_set_xps_queue by moving the xps_map_mutex up so the
>   access of dev->num_tc is done under the lock.
>
> - Using xps_map_mutex in both netdev_set_num_tc and netdev_reset_tc for
>   the reset and set logic:
>
>   + As xps_map_mutex was taken in the reset path, netif_reset_xps_queues
>     had to be reworked to offer an unlocked version (as well as
>     netdev_unbind_all_sb_channels which calls it).
>
>   + cpus_read_lock was taken in the reset path as well, and is always
>     taken before xps_map_mutex. It had to be moved out of the unlocked
>     version as well.
>
>   This is why the patch is a little bit longer, and moves
>   netdev_unbind_sb_channel up in the file.
>
> Fixes: 184c449f91fe ("net: Add support for XPS with QoS via traffic classes")
> Signed-off-by: Antoine Tenart <atenart@kernel.org>

Looking over this patch it seems kind of obvious that extending the
xps_map_mutex is making things far more complex then they need to be.

Applying the rtnl_mutex would probably be much simpler. Although as I
think you have already discovered we need to apply it to the store,
and show for this interface. In addition we probably need to perform
similar locking around traffic_class_show in order to prevent it from
generating a similar error.
