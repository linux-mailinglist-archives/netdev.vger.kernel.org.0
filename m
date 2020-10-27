Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD38929A56A
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 08:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507496AbgJ0HWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 03:22:30 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:59594 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2507489AbgJ0HWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 03:22:30 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kXJJ4-00DPbm-JM; Tue, 27 Oct 2020 08:22:10 +0100
Message-ID: <03c5bc171594c884c903994ef82d703776bfcbc0.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 04/11] wimax: fix duplicate initializer warning
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Arnd Bergmann <arnd@kernel.org>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 27 Oct 2020 08:22:09 +0100
In-Reply-To: <20201026213040.3889546-4-arnd@kernel.org>
References: <20201026213040.3889546-1-arnd@kernel.org>
         <20201026213040.3889546-4-arnd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-10-26 at 22:29 +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> gcc -Wextra points out multiple fields that use the same index '1'
> in the wimax_gnl_policy definition:
> 
> net/wimax/stack.c:393:29: warning: initialized field overwritten [-Woverride-init]
> net/wimax/stack.c:397:28: warning: initialized field overwritten [-Woverride-init]
> net/wimax/stack.c:398:26: warning: initialized field overwritten [-Woverride-init]
> 
> This seems to work since all four use the same NLA_U32 value, but it
> still appears to be wrong. In addition, there is no intializer for
> WIMAX_GNL_MSG_PIPE_NAME, which uses the same index '2' as
> WIMAX_GNL_RFKILL_STATE.

That's funny. This means that WIMAX_GNL_MSG_PIPE_NAME was never used,
since it is meant to be a string, and that won't (usually) fit into 4
bytes...

I suppose that's all an artifact of wimax being completely and utterly
dead anyway. We should probably just remove it.

> Johannes already changed this twice to improve it, but I don't think
> there is a good solution, so try to work around it by using a
> numeric index and adding comments.

Yeah, though maybe there's a better solution now.

Given that we (again and properly) have per-ops policy support, which
really was the thing that broke it here (the commit 3b0f31f2b8c9 you
mentioned), we could split this up into per-ops policies and do the
right thing in the separate policies.

OTOH, that really just makes it use more space, for no discernible
effect to userspace.


So as far as the warning fix is concerned:

Acked-by: Johannes Berg <johannes@sipsolutions.net>


Looks like I introduced a bug there with WIMAX_GNL_MSG_PIPE_NAME, but
obviously nobody cared.

johannes

