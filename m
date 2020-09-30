Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A1427E75A
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 13:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbgI3LDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 07:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgI3LDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 07:03:44 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0142CC061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 04:03:43 -0700 (PDT)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1kNZtX-0008Kt-5k; Wed, 30 Sep 2020 13:03:35 +0200
Received: from laforge by localhost.localdomain with local (Exim 4.94)
        (envelope-from <laforge@gnumonks.org>)
        id 1kNZrt-000zE9-VK; Wed, 30 Sep 2020 13:01:53 +0200
Date:   Wed, 30 Sep 2020 13:01:53 +0200
From:   Harald Welte <laforge@gnumonks.org>
To:     Richard Haines <richard_c_haines@btinternet.com>
Cc:     selinux@vger.kernel.org, linux-security-module@vger.kernel.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org,
        stephen.smalley.work@gmail.com, paul@paul-moore.com,
        pablo@netfilter.org, jmorris@namei.org
Subject: Re: [PATCH 3/3] selinux: Add SELinux GTP support
Message-ID: <20200930110153.GT3871@nataraja>
References: <20200930094934.32144-1-richard_c_haines@btinternet.com>
 <20200930094934.32144-4-richard_c_haines@btinternet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930094934.32144-4-richard_c_haines@btinternet.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

I don't fully understand in which context you need / use those SELinux GTP hooks,
however one comment from the point of view of somebody who is working on GGSN/P-GW
software using the GTP kernel module:

On Wed, Sep 30, 2020 at 10:49:34AM +0100, Richard Haines wrote:
> +selinux_gtp_dev_cmd()
> +~~~~~~~~~~~~~~~~~~~~~
> +Validate if the caller (current SID) and the GTP device SID have the required
> +permission to perform the operation. The GTP/SELinux permission map is
> +as follow::
> +
> +    GTP_CMD_NEWPDP = gtp { add }
> +    GTP_CMD_DELPDP = gtp { del }
> +    GTP_CMD_GETPDP = gtp { get }

Wouldn't it make sense to differentiate between:

a) add/del/get on the GTP netdev
b) add/del/get on the indivudual PDP wihin the GTP netdev

'a' is typically only created once at startup of a GGSN/P-GW software, or is
done even at system stat-up time.

'b' is performed frequently during runtime as the GGSN/P-GW function runs, as
subscribers attach to / detach from the cellular network.

By differentiating between those two, one could further constrain the permissions
required at runtime.

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
