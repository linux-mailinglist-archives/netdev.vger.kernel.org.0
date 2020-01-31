Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70D9314F1CA
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbgAaSHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:07:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:59400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726712AbgAaSHI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 13:07:08 -0500
Received: from cakuba.hsd1.ca.comcast.net (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B92A320663;
        Fri, 31 Jan 2020 18:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580494028;
        bh=mNhBHwh7/sbcu8F+2HAdjn4r7FE6MDpmO6dgSRi1EYQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eCWJgbk8Oa3fFh32Q9gIoicPJIBajhYaPQWh3yfmv5eg4oK2x8wlfofuyIr5s3KlB
         kIsSYtwYeIcznqiQBwXbm9JPOi6j2KcoAIX71k1d2+C6liiBQzEHahmpfNVT5NbHuq
         c5maUOfttGjeFNQZng03Tym9KONbTED/qvYL2PYA=
Date:   Fri, 31 Jan 2020 10:07:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com
Subject: Re: [PATCH 02/15] devlink: add functions to take snapshot while
 locked
Message-ID: <20200131100706.5c98981e@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200130225913.1671982-3-jacob.e.keller@intel.com>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
        <20200130225913.1671982-3-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jan 2020 14:58:57 -0800, Jacob Keller wrote:
> +static int
> +devlink_region_snapshot_create_locked(struct devlink_region *region,
> +				      u8 *data, u32 snapshot_id,
> +				      devlink_snapshot_data_dest_t *destructor)

-1 on the _locked suffix. Please follow the time-honored tradition of
using double underscore for internal helpers which make assumption
about calling context.

> +{
> +	struct devlink_snapshot *snapshot;

lockdep_assert_held() is much better than just a kdoc comment.

> +	/* check if region can hold one more snapshot */
> +	if (region->cur_snapshots == region->max_snapshots)
> +		return -ENOMEM;
