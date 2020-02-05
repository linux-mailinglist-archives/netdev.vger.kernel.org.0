Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA4B71531B8
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 14:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgBENZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 08:25:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46940 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbgBENZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 08:25:02 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8037F158E4B9D;
        Wed,  5 Feb 2020 05:25:01 -0800 (PST)
Date:   Wed, 05 Feb 2020 14:25:00 +0100 (CET)
Message-Id: <20200205.142500.1124442901896236230.davem@davemloft.net>
To:     jacob.e.keller@intel.com
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, valex@mellanox.com,
        parav@mellanox.com
Subject: Re: [net] devlink: report 0 after hitting end in region read
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200204235950.2209828-1-jacob.e.keller@intel.com>
References: <20200204235950.2209828-1-jacob.e.keller@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Feb 2020 05:25:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>
Date: Tue,  4 Feb 2020 15:59:50 -0800

> commit fdd41ec21e15 ("devlink: Return right error code in case of errors
> for region read") modified the region read code to report errors
> properly in unexpected cases.
> 
> In the case where the start_offset and ret_offset match, it unilaterally
> converted this into an error. This causes an issue for the "dump"
> version of the command. In this case, the devlink region dump will
> always report an invalid argument:
> 
> 000000000000ffd0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 000000000000ffe0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> devlink answers: Invalid argument
> 000000000000fff0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 
> This occurs because the expected flow for the dump is to return 0 after
> there is no further data.
> 
> The simplest fix would be to stop converting the error code to -EINVAL
> if start_offset == ret_offset. However, avoid unnecessary work by
> checking for when start_offset is larger than the region size and
> returning 0 upfront.
> 
> Fixes: fdd41ec21e15 ("devlink: Return right error code in case of errors for region read")
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Applied and queued up for -stable, thanks.
