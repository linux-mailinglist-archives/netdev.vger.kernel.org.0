Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BABB9303D80
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 13:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403775AbhAZMp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 07:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391647AbhAZKDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 05:03:40 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14372C06174A
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 02:03:00 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id c2so18727568edr.11
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 02:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r0PEk1uUKM5Q9q/+MGqHGgCH1yxOpiIv91u8qq+76tw=;
        b=Nx5rzbRRJmiojIU5lVxNWI69CKbFX2mVcLTlMH5MAJetlFeEHzpbTtVmkDUNhT06Pm
         o5xMpAy24oHNFS6kgdrRKDehMcNLir3XYyoeTSnY6NvjIh4/+NZGYfED1eIBEC4St8C8
         SndGD3Suj+1BvWGTpjBHG+IY9TtzTrJAvAeCjErfYhDExG2iVX6sP7gqpNVxiOBEKZI2
         zi11aLgNSYep2Qz8v9wNrn8X6gqc0bMLDds38yzuJPrHBZYZ3Q94rA2+sVRHWOamIiWh
         QHp2+HZku5KfsOu5osLckvKXPnitWVLE02vzXWJb9jtxwT71FIOxcTHGUhaUr+KvE5Cm
         VyiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r0PEk1uUKM5Q9q/+MGqHGgCH1yxOpiIv91u8qq+76tw=;
        b=PD3R9W8GpTVgB/lLE2jr+hHe/MtOOr90OQPVGJxQ8r9QKNe9GsSXzz2gSRI2QYt6wG
         6W+wWA48c9N90XsfDvTFgW9RzrDb68YxRpI+bnRshcpztzUAFOevHafThBkSKM34a2by
         NaNqeT3t8A2YN8DEGBE5t9a9t4A3PsDLADAV2VRBnEwNMMlFTRP+9G/NAuyZsteTa4LS
         E4zdBuuCgX9scaLKQ74qUaas9kbu1WZcMltND/1pFyOx7AeVDKyVXsHD1M+A1TBrTmAI
         SRzeWDyuLyMOfJRDqw+AaGbJbXQW1TXyTRe7M/owKsJ3KpOv83UFHZRrslhVJGRILZNh
         QcUA==
X-Gm-Message-State: AOAM533nbNivNN6+jJ0wVDP5Y+GQgd0U2AgP99hei/JOldfA1SqaqQmB
        0yLBtf8vUXZ4Xn5Ak+QOyj68hA==
X-Google-Smtp-Source: ABdhPJwvMoBWgevYlTDP7GMOl+FiuvLn3103n++BnlpWARsldzAvMdl331aoaTpkyTm9/yF54NB+AQ==
X-Received: by 2002:a05:6402:306a:: with SMTP id bs10mr3950881edb.209.1611655378812;
        Tue, 26 Jan 2021 02:02:58 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id v25sm9596974ejw.21.2021.01.26.02.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 02:02:58 -0800 (PST)
Date:   Tue, 26 Jan 2021 11:02:57 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>
Subject: Re: [PATCH net] team: protect features update by RCU to avoid
 deadlock
Message-ID: <20210126100257.GN3565223@nanopsycho.orion>
References: <20210125074416.4056484-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125074416.4056484-1-ivecera@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jan 25, 2021 at 08:44:16AM CET, ivecera@redhat.com wrote:
>Function __team_compute_features() is protected by team->lock
>mutex when it is called from team_compute_features() used when
>features of an underlying device is changed. This causes
>a deadlock when NETDEV_FEAT_CHANGE notifier for underlying device
>is fired due to change propagated from team driver (e.g. MTU
>change). It's because callbacks like team_change_mtu() or
>team_vlan_rx_{add,del}_vid() protect their port list traversal
>by team->lock mutex.
>
>Example (r8169 case where this driver disables TSO for certain MTU
>values):
>...
>[ 6391.348202]  __mutex_lock.isra.6+0x2d0/0x4a0
>[ 6391.358602]  team_device_event+0x9d/0x160 [team]
>[ 6391.363756]  notifier_call_chain+0x47/0x70
>[ 6391.368329]  netdev_update_features+0x56/0x60
>[ 6391.373207]  rtl8169_change_mtu+0x14/0x50 [r8169]
>[ 6391.378457]  dev_set_mtu_ext+0xe1/0x1d0
>[ 6391.387022]  dev_set_mtu+0x52/0x90
>[ 6391.390820]  team_change_mtu+0x64/0xf0 [team]
>[ 6391.395683]  dev_set_mtu_ext+0xe1/0x1d0
>[ 6391.399963]  do_setlink+0x231/0xf50
>...
>
>In fact team_compute_features() called from team_device_event()
>does not need to be protected by team->lock mutex and rcu_read_lock()
>is sufficient there for port list traversal.
>
>Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
>Cc: Jiri Pirko <jiri@resnulli.us>
>Cc: David S. Miller <davem@davemloft.net>
>Cc: Cong Wang <xiyou.wangcong@gmail.com>
>Cc: Jakub Kicinski <kuba@kernel.org>
>Cc: Saeed Mahameed <saeed@kernel.org>
>Signed-off-by: Ivan Vecera <ivecera@redhat.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
