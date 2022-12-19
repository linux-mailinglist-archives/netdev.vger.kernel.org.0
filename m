Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC3D650EE3
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 16:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbiLSPml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 10:42:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232359AbiLSPmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 10:42:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0DD120B6;
        Mon, 19 Dec 2022 07:42:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5927E6101A;
        Mon, 19 Dec 2022 15:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444B1C433D2;
        Mon, 19 Dec 2022 15:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671464554;
        bh=oiRflUUrN9bOaDwDQpqkHsr1lb3UHJCMBAT9e34G5mE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r5cDx+BtP2K4XWscbCzfdt8AoZagaehZj070cUl5VgcIS1p/YAUbp3ROeQZ192BKX
         q5AWMzNd7sErqwBkcyVIpBNAjtJrfc6dHqCmORCf8hxBGP6yYMXTxNuk0/ZMYeeqts
         mjX0w/5SGEE5rWy4bwI/UfZiC+zYiUW+YWBRPBT0=
Date:   Mon, 19 Dec 2022 16:42:32 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pratyush Yadav <ptyadav@amazon.de>
Cc:     stable@vger.kernel.org, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Marek =?iso-8859-1?Q?Marczykowski-G=F3recki?= 
        <marmarek@invisiblethingslab.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Puranjay Mohan <pjy@amazon.de>,
        Maximilian Heyne <mheyne@amazon.de>,
        Julien Grall <julien@xen.org>, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.4] xen-netback: move removal of "hotplug-status" to the
 right place
Message-ID: <Y6CGaHI554sbb9zt@kroah.com>
References: <20221219153710.23782-1-ptyadav@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219153710.23782-1-ptyadav@amazon.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 19, 2022 at 04:37:10PM +0100, Pratyush Yadav wrote:
> The removal of "hotplug-status" has moved around a bit. First it was
> moved from netback_remove() to hotplug_status_changed() in upstream
> commit 1f2565780e9b ("xen-netback: remove 'hotplug-status' once it has
> served its purpose"). Then the change was reverted in upstream commit
> 0f4558ae9187 ("Revert "xen-netback: remove 'hotplug-status' once it has
> served its purpose""), but it moved the removal to backend_disconnect().
> Then the upstream commit c55f34b6aec2 ("xen-netback: only remove
> 'hotplug-status' when the vif is actually destroyed") moved it finally
> back to netback_remove(). The thing to note being it is removed
> unconditionally this time around.
> 
> The story on v5.4.y adds to this confusion. Commit 60e4e3198ce8 ("Revert
> "xen-netback: remove 'hotplug-status' once it has served its purpose"")
> is backported to v5.4.y but the original commit that it tries to revert
> was never present on 5.4. So the backport incorrectly ends up just
> adding another xenbus_rm() of "hotplug-status" in backend_disconnect().
> 
> Now in v5.4.y it is removed in both backend_disconnect() and
> netback_remove(). But it should only be removed in netback_remove(), as
> the upstream version does.
> 
> Removing "hotplug-status" in backend_disconnect() causes problems when
> the frontend unilaterally disconnects, as explained in
> c55f34b6aec2 ("xen-netback: only remove 'hotplug-status' when the vif is
> actually destroyed").
> 
> Remove "hotplug-status" in the same place as it is done on the upstream
> version to ensure unilateral re-connection of frontend continues to
> work.
> 
> Fixes: 60e4e3198ce8 ("Revert "xen-netback: remove 'hotplug-status' once it has served its purpose"")
> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
> ---
>  drivers/net/xen-netback/xenbus.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Now queued up, thanks.

greg k-h
