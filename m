Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB312DA64C
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 03:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbgLOCgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 21:36:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:49728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728206AbgLOCfs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 21:35:48 -0500
Date:   Mon, 14 Dec 2020 18:26:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607999211;
        bh=67v8avezuO6PXt9ia096cwPmSQJVbdmQgsBlIUX3wXM=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=FvLjZxCvC0ixzlpWgWcHZwcnUqMZbaLIcftfBh+vcUoXrHExiTUtsKxURDk3u0L6/
         lJPY9Ov6tJmi5owigwMxEPeREhbdTnvoaY5EtnpHpZN+34MGwXaDbOA94PB1nwQMmQ
         eFV5G2ooMbiHlseZoEIWx8fc9qbtKSTYw0ADwbxztr7NwvA0yV91oO97gVGYvmauVI
         wrXOULAwRvCUmVFr8i8o1ByiszhbrDokz/x4LYIt6jPqwppxRlQeEZRBAi0/rXW7LF
         764b8gWPX+4sxnv1ro22iEFVB1qzwa8byD+LDbnLGG9zVMdjk8d827E47hiZ1yG3y5
         x4n1S6ddyf8sw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Louis Peens <louis.peens@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        wenxu <wenxu@ucloud.cn>
Subject: Re: [PATCH net] nfp: do not send control messages during cleanup
Message-ID: <20201214182650.4d03cc7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201211092738.3358-1-simon.horman@netronome.com>
References: <20201211092738.3358-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Dec 2020 10:27:38 +0100 Simon Horman wrote:
> On cleanup the txbufs are freed before app cleanup. But app clean-up may
> result in control messages due to use of common control paths. There is no
> need to clean-up the NIC in such cases so simply discard requests. Without
> such a check a NULL pointer dereference occurs.
> 
> Fixes: a1db217861f3 ("net: flow_offload: fix flow_indr_dev_unregister path")
> Cc: wenxu <wenxu@ucloud.cn>
> Signed-off-by: Simon Horman <simon.horman@netronome.com>
> Signed-off-by: Louis Peens <louis.peens@netronome.com>

Hm. We can apply this as a quick fix, but I'd think that app->stop
(IIRC that's the callback) is responsible for making sure that
everything gets shut down and no more cmsgs can be generated after
ctrl vNIC goes down. Perhaps some code needs to be reshuffled between
init/clean and start/stop for flower? WDYT?
