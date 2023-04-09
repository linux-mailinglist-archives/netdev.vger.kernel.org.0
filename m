Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8571E6DBF4B
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 11:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjDIJCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 05:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDIJCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 05:02:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74724C1B;
        Sun,  9 Apr 2023 02:02:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F45860B8C;
        Sun,  9 Apr 2023 09:02:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA67C433D2;
        Sun,  9 Apr 2023 09:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681030948;
        bh=LVtFFA0AXEhOsnryskGF2zy05qjqLGb8A6vGLQS1SBs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e890w4A1/yisEf/4re8ZeWrx2Q5nu0WrTNqPYUHGl4NqfUHIBcXlqRqe+zmx0LcTd
         9TcKQj/8Jar7dsYdPKn/SMvC/nTOJ2IM/rDgKd7QqNa1ei0PvQaktdxsDGSIEx/WPJ
         VjbaGJMxzh2nGl3gThPP/WOaWtWhvIfFxITlMvwCI7647jyPnJHiYipso/jcim+top
         FJBTcmpiA4pAaRW2cJjxJ2R9ZIwcPqwb/Ha0QLV5Tw9jeyZOCQb2n4oZYAjB8mxDa3
         ohFV/FAgyLDUKe1DdBJOEqiTrLWKcrJy0QcDK5opzog27IZP4qMpZ4L0iAVxRFwHQi
         M3zQi/nLchIag==
Date:   Sun, 9 Apr 2023 12:02:24 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     netdev@vger.kernel.org, mschmidt@redhat.com,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] bnxt_en: Allow to set switchdev mode without
 existing VFs
Message-ID: <20230409090224.GE14869@unreal>
References: <20230406130455.1155362-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406130455.1155362-1-ivecera@redhat.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 03:04:55PM +0200, Ivan Vecera wrote:
> Remove an inability of bnxt_en driver to set eswitch to switchdev
> mode without existing VFs by:
> 
> 1. Allow to set switchdev mode in bnxt_dl_eswitch_mode_set() so
>    representors are created only when num_vfs > 0 otherwise just
>    set bp->eswitch_mode
> 2. Do not automatically change bp->eswitch_mode during
>    bnxt_vf_reps_create() and bnxt_vf_reps_destroy() calls so
>    the eswitch mode is managed only by an user by devlink.
>    Just set temporarily bp->eswitch_mode to legacy to avoid
>    re-opening of representors during destroy.
> 3. Create representors in bnxt_sriov_enable() if current eswitch
>    mode is switchdev one
> 
> Tested by this sequence:
> 1. Set PF interface up
> 2. Set PF's eswitch mode to switchdev
> 3. Created N VFs
> 4. Checked that N representors were created
> 5. Set eswitch mode to legacy
> 6. Checked that representors were deleted
> 7. Set eswitch mode back to switchdev
> 8. Checked that representros were re-created

Why do you think that this last item is the right behavior?
IMHO all configurations which were done after you switched mode
should be cleared and not recreated while toggling.

Thanks

> 9. Deleted all VFs
> 10. Checked that all representors were deleted as well
> 11. Checked that current eswitch mode is still switchdev
> 
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> ---
