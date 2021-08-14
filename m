Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94BF63EBF28
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 03:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236149AbhHNBCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 21:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235870AbhHNBCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 21:02:10 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF01C061756;
        Fri, 13 Aug 2021 18:01:42 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id cn28so6068067edb.6;
        Fri, 13 Aug 2021 18:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=b/BAppsRBqmgyavAEAzIPlCSKhLp58aHdhcqLbgbh0A=;
        b=R6wsenaGFKbhHdCfuWgFgYzG+3O+JeyD1xHV4+EC1VmfgWcxFp30v8OB+RaTSGdFiw
         MVXOfNgHHfftDhaEHOCP+wsH6sV/PllgEGvYuR6BRKGlIWyHulHcf4Ztz/0qArt2Db7S
         KOLXgBdUUv+6iI8HZfXygnwLORLB2TnMvFRtQnmSMx/OPXRqaXbA31J+vqbpM/GY1QmW
         uotd7mCXz90DtoEf1gwZqMkUOna7o+MBF1JO6Eb0Jn7bK86XAePJVfPWKcyTFTVb+q8R
         qICV909W/vLwtWRQKg3EzRSsV2w9bJwS4FlMpxkUE+yNnBpJHjiWMpDIYQaTYor9/07t
         rVIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=b/BAppsRBqmgyavAEAzIPlCSKhLp58aHdhcqLbgbh0A=;
        b=Rl/YWnFTmjvj6QX2kGGjVhE7jHvdTOC138HEddVpTYMXLY7d0kOrUS5fLuhR7mDxb3
         S+imsmosmB1eFWkASTe2P+U5L+ClUFRZKYpOyzPHKdOqzawIGPUL+V/9ZN/GqdaQhXMw
         C1u/iX4CVvg8td6FVlSZx7Hthdkq+FM7Xu0Vjfq/eSWKfezEqun5NXkoQt+3J5CpI18B
         s6z+SyAKBGocq+FMT3+UOf4G95ZurnbMdxsPyulc2NUyrV3AYzQmXSbyPi74mJdSZfl+
         zer0oXLyNdZpkciTsI1P5VxWeoULcJ36tApagrDROQr5kDEou7Mqr3AX0Pw/RtXsbRh0
         uwAg==
X-Gm-Message-State: AOAM531U3ffpFWIfKMdllBAlbPHeB6Z1fDPeJkCfOtDYhLFTb+fuczCR
        LCltHoG3TDL8zJGZ16KaQqY=
X-Google-Smtp-Source: ABdhPJzMsX8eMmrCUWSIzY+daPTkI/yZMoBWwNpo658rCHzvz+DFrT98xWvELDgbn6/PlB8kLU+nMw==
X-Received: by 2002:aa7:c3d0:: with SMTP id l16mr6459339edr.122.1628902901439;
        Fri, 13 Aug 2021 18:01:41 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id gu2sm1185310ejb.96.2021.08.13.18.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 18:01:40 -0700 (PDT)
Date:   Sat, 14 Aug 2021 04:01:39 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: of_node_put() usage is buggy all over drivers/of/base.c?!
Message-ID: <20210814010139.kzryimmp4rizlznt@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I was debugging an RCU stall which happened during the probing of a
driver. Activating lock debugging, I see:

[  101.710694] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:938
[  101.719119] in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 1534, name: sh
[  101.726763] INFO: lockdep is turned off.
[  101.730674] irq event stamp: 0
[  101.733716] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[  101.739973] hardirqs last disabled at (0): [<ffffd3ebecb10120>] copy_process+0xa78/0x1a98
[  101.748146] softirqs last  enabled at (0): [<ffffd3ebecb10120>] copy_process+0xa78/0x1a98
[  101.756313] softirqs last disabled at (0): [<0000000000000000>] 0x0
[  101.762569] CPU: 4 PID: 1534 Comm: sh Not tainted 5.14.0-rc5+ #272
[  101.774558] Call trace:
[  101.794734]  __might_sleep+0x50/0x88
[  101.798297]  __mutex_lock+0x60/0x938
[  101.801863]  mutex_lock_nested+0x38/0x50
[  101.805775]  kernfs_remove+0x2c/0x50             <---- this takes mutex_lock(&kernfs_mutex);
[  101.809341]  sysfs_remove_dir+0x54/0x70
[  101.813166]  __kobject_del+0x3c/0x80
[  101.816733]  kobject_put+0xf8/0x108
[  101.820211]  of_node_put+0x18/0x28
[  101.823602]  of_find_compatible_node+0xa8/0xf8    <--- this takes raw_spin_lock_irqsave(&devtree_lock)
[  101.828036]  sja1105_mdiobus_register+0x264/0x7a8

The pattern of calling of_node_put from under the atomic devtree_lock
context is pretty widespread in drivers/of/base.c.

Just by inspecting the code, this seems to be an issue since commit:

commit 75b57ecf9d1d1e17d099ab13b8f48e6e038676be
Author: Grant Likely <grant.likely@linaro.org>
Date:   Thu Feb 20 18:02:11 2014 +0000

    of: Make device nodes kobjects so they show up in sysfs

    Device tree nodes are already treated as objects, and we already want to
    expose them to userspace which is done using the /proc filesystem today.
    Right now the kernel has to do a lot of work to keep the /proc view in
    sync with the in-kernel representation. If device_nodes are switched to
    be kobjects then the device tree code can be a whole lot simpler. It
    also turns out that switching to using /sysfs from /proc results in
    smaller code and data size, and the userspace ABI won't change if
    /proc/device-tree symlinks to /sys/firmware/devicetree/base.

    v7: Add missing sysfs_bin_attr_init()
    v6: Add __of_add_property() early init fixes from Pantelis
    v5: Rename firmware/ofw to firmware/devicetree
        Fix updating property values in sysfs
    v4: Fixed build error on Powerpc
        Fixed handling of dynamic nodes on powerpc
    v3: Fixed handling of duplicate attribute and child node names
    v2: switch to using sysfs bin_attributes which solve the problem of
        reporting incorrect property size.

    Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
    Tested-by: Sascha Hauer <s.hauer@pengutronix.de>
    Cc: Rob Herring <rob.herring@calxeda.com>
    Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Cc: David S. Miller <davem@davemloft.net>
    Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
    Cc: Pantelis Antoniou <panto@antoniou-consulting.com>

because up until that point, of_node_put() was:

void of_node_put(struct device_node *node)
{
	if (node)
		kref_put(&node->kref, of_node_release);
}

and not:

void of_node_put(struct device_node *node)
{
	if (node)
		kobject_put(&node->kobj);
}

Either I'm holding it very, very wrong, or this is a very severe
oversight that just happened somehow to go unnoticed for 7 years.

Please tell me it's me.
