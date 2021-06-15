Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9813A771B
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 08:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhFOGcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 02:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhFOGcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 02:32:47 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF52C061574
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 23:30:43 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id h22-20020a05600c3516b02901a826f84095so1267870wmq.5
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 23:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=eskcY+HcYiok7CEKwYxbGC1nhb1/en3N+sCtJoAgGN8=;
        b=f/xFaWI7GC8SLOVi7B1yvlHMrqnxOKuvD+ugdNTANfesGcK7Rlc8QSRIh62Uxw5W3d
         MmwEyuYquCrlsaBInphXaZbpnW7z4vIdLFFlxK34Wgj54GZwkft2FUEjCdQgVd7c2I3R
         dQqbzLo+hp9B4+9hF1tNbLiMZotQh4fVa+ssl4ruBnkOl2dmrKC2+m3pmaBfvQmbO8pa
         F61t60bBsOZE6Yc0Ed/DhKHPWVvU0YCLRVLD9gSCYu6jglrBpmXYlXlvFdS22TAaQaC5
         0a24oPePIVkZ/A84Bi+ldFY6MMJSFuXSv2xK2LDeL+op1bklBCFPacTn5cjO4fXDxSZb
         exwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=eskcY+HcYiok7CEKwYxbGC1nhb1/en3N+sCtJoAgGN8=;
        b=aHp/kjv0QDQj9u5ZInh5JSy9BhNwnjDIGGbAA2jzo5WLxuL323vFK+aFxpgjoz7HV2
         PYDKQLqwcSX3ThoVY2ij8+T2NCwX9FE8FcpjFERi2ZcEca75FzRrWPAjLRHcziPRFK8E
         WsBIrauAJ5sMtuvGixvu4ranEpVX/sLybZgQZGHbhkAgfSt9AgF6x8zR3iZi8/OGj3Os
         Daxjx5YVMrACdhZj9eMDPe5ZyuDZGXbc/7CcavdGP8jP+FS8mZVm0abyTCj+W9tTppcq
         iJjn6W1YRsNfRd5wNuxp0I1bd8loxFe1KHlwzYsSgoHDXwSQL3KCoaXecTTHWJeGOHCh
         DPeg==
X-Gm-Message-State: AOAM532kT0LdN3xBk50C8MOCxZj/Q3Spm6P81BuzU37yT4ey9qCJdaF9
        qPHlENngp2M1c3eU9GZ1htaZ5oP1reFP923E
X-Google-Smtp-Source: ABdhPJxiGmVaXZg7hVHpK0C48gCs39DMcqp9yg+mUKCbz//mAxG+ZEOaA6Lgvcr8/HhInLr6Us73iA==
X-Received: by 2002:a05:600c:1c22:: with SMTP id j34mr3383507wms.166.1623738641696;
        Mon, 14 Jun 2021 23:30:41 -0700 (PDT)
Received: from linux-dev (host81-153-178-248.range81-153.btcentralplus.com. [81.153.178.248])
        by smtp.gmail.com with ESMTPSA id r4sm19121641wre.84.2021.06.14.23.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 23:30:41 -0700 (PDT)
Date:   Tue, 15 Jun 2021 07:30:39 +0100
From:   Kev Jackson <foamdino@gmail.com>
To:     mkubecek@suse.cz, netdev@vger.kernel.org
Subject: ethtool discrepancy between observed behaviour and comments
Message-ID: <YMhJDzNrRNNeObly@linux-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I have been working with ethtool, ioctl and Mellanox multi-queue NICs and I think
I have discovered an issue with either the code or the comments that describe
the code or recent changes.

My focus here is simply the ethtool -L command to set the channels for a
multi-queue nic.  Running this command with the following params on a host with
a Mellanox NIC works fine:

ethtool -L eth0 combined 4

The code however seems to check that one of rx or tx must be set as part of the
command (channels.c):

        /* ensure there is at least one RX and one TX channel */
        if (!channels.combined_count && !channels.rx_count)
                err_attr = ETHTOOL_A_CHANNELS_RX_COUNT;
        else if (!channels.combined_count && !channels.tx_count)
                err_attr = ETHTOOL_A_CHANNELS_TX_COUNT;
        else
                err_attr = 0;

and (ioctl.c):

        /* ensure there is at least one RX and one TX channel */
        if (!channels.combined_count &&
            (!channels.rx_count || !channels.tx_count))
                return -EINVAL;

This check was added in commit 7be9251, with the comment:
"Having a channel config with no ability to RX or TX traffic is
clearly wrong. Check for this in the core so the drivers don't
have to."

However this comment and check is contradicted by a (much) older comment from
commit 8b5933c, "Most multiqueue drivers pair up RX and TX
queues so that most channels combine RX and TX work"

After working with ioctl and using a ETHTOOL_SCHANNELS command to try and set
the number of channels (ETHTOOL_GCHANNELS works perfectly fine), I noticed I was
always getting -EINVAL from ethtool_set_channels which led me to uncover these
differences between the behaviour of the ethtool binary and using the
ETHTOOL_SCHANNELS command via code.

After seeing this change I discovered the code in the latest ethtool is using
netlink.c commands and nl_schannels is the command used to set the channels (if
the kernel supports netlink).

nl_schannels was added in this commit: dd3ab09, which doesn't seem to have any
checks for setting rx_count/tx_count/combined_count (although I could have
missed them).

From putting all of this together, I have come to the conclusion that:
* ioctl / ETHTOOL_SCHANNELS is a legacy method of setting channels
* nl_schannels is the new / preferred method of setting channels
* ethtool has fallback code to run ioctl functions for commands which don't yet
* have a netlink equivalent

Our user experience is that ethtool -L currently does support (and should continue to
support) just setting combined_count rather than having to set combined_count +
one of rx_count/tx_count, which would mean removing the check in the ioctl.c,
ethtool_set_channels code to make the netlink.c and ioctl.c commands consistent.

Obviously the other approach is to add the check for setting one of rx_count /
tx_count into the nl_schannels function.

We're happy to provide a patch for either approach, but would like to raise this
as potentially a bug in the current code.

Thanks,
Kev
