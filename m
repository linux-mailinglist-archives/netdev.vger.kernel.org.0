Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34FE414F1D1
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbgAaSHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:07:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:59570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726712AbgAaSHY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 13:07:24 -0500
Received: from cakuba.hsd1.ca.comcast.net (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 042EF20663;
        Fri, 31 Jan 2020 18:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580494044;
        bh=nOVDYQjNjuvbf1Tubb+KPDDDk28bUGenhjO8JBJWkW4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=y0JWVWthsGggyskDi83k1xir/4PjD26GZ86B9r9YgOIMOBDtPpNdzUXvTKBApMyy/
         llN72LEbvP1Iv6ygfYqiuUpjsqx/JPtI3f/OVGQQsR5pxDKjDO5eqBPhzCNj4E6fjM
         Syu20CG4eUpD3elVO3ap0gkXX3l3CVvkOSuqAD0Q=
Date:   Fri, 31 Jan 2020 10:07:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com
Subject: Re: [PATCH 08/15] devlink: add devres managed devlinkm_alloc and
 devlinkm_free
Message-ID: <20200131100723.0d6893fa@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200130225913.1671982-9-jacob.e.keller@intel.com>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
        <20200130225913.1671982-9-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jan 2020 14:59:03 -0800, Jacob Keller wrote:
> Add devres managed allocation functions for allocating a devlink
> instance. These can be used by device drivers based on the devres
> framework which want to allocate a devlink instance.
> 
> For simplicity and to reduce churn in the devlink core code, the devres
> management works by creating a node with a double-pointer. The devlink
> instance is allocated using the normal devlink_alloc and released using
> the normal devlink_free.
> 
> An alternative solution where the raw memory for devlink is allocated
> directly via devres_alloc could be done. Such an implementation would
> either significantly increase code duplication or code churn in order to
> refactor the setup from the allocation.
> 
> The new devres managed allocation function will be used by the ice
> driver in a following change to implement initial devlink support.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Ugh. The devlink instance sharing/aliasing is something that needs to
be solved at some point. But the problem likely exists elsewhere
already. Do you have global ASIC resources?
