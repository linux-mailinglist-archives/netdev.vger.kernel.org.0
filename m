Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EADF246F0B
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 19:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731447AbgHQRlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 13:41:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731101AbgHQQQj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 12:16:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 554E720658;
        Mon, 17 Aug 2020 16:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680977;
        bh=qmXn2ePcxDGgDoZI/rAKqc3zaoL0TNCzGzLKaOLK0fM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aRwgKhUWjrCwd9uDv+ANJAH6gUxStlMD4owM5J9/JPiol4eK+RhA/NJs9yjLlH1dp
         VL4xjbKcKHexzaohKJnatJcHKzuB9VdmwpwYw941s7tmsprSnIwZffmUt9g0k8Pff7
         NwNK0j0seE62MAOq3/lU3Q0T/EbSRcR+GHGSIJL4=
Date:   Mon, 17 Aug 2020 09:16:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v2 01/13] devlink: Add reload action option
 to devlink reload command
Message-ID: <20200817091615.37e76ca3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1597657072-3130-2-git-send-email-moshe@mellanox.com>
References: <1597657072-3130-1-git-send-email-moshe@mellanox.com>
        <1597657072-3130-2-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Aug 2020 12:37:40 +0300 Moshe Shemesh wrote:
> Add devlink reload action to allow the user to request a specific reload
> action. The action parameter is optional, if not specified then devlink
> driver re-init action is used (backward compatible).
> Note that when required to do firmware activation some drivers may need
> to reload the driver. On the other hand some drivers may need to reset
> the firmware to reinitialize the driver entities.

See, this is why I wanted to keep --live as a separate option. 
Normally the driver is okay to satisfy more actions than requested, 
e.g. activate FW even if only driver_reinit was requested.

fw_live_patch does not have this semantics, it explicitly requires
driver to not impact connectivity much. No "can do more resets than
requested" here. Hence the --live part would be better off as a
separate argument (at least in uAPI, the in-kernel interface we can
change later if needed).

> Reload actions supported are:
> driver_reinit: driver entities re-initialization, applying devlink-param
>                and devlink-resource values.
> fw_activate: firmware activate.
> fw_live_patch: firmware live patching.
