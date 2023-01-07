Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A44661135
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 20:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbjAGTCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 14:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjAGTCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 14:02:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C552C1C40D
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 11:02:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 620A760B88
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 19:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF919C433D2;
        Sat,  7 Jan 2023 19:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673118123;
        bh=xfd9ZjG1KSObF4xDayWws/DuweLHK4Lw8xgCDqKb5cM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=or4co1xe650shpZBfgAnDxNx4ui/2XRcrtYF3v4LfmoiLqhptEYxd/jwsL8cXiFPD
         m0R3kVj8/z+LO5XST/zzeH7r3A+E0aMIhKfdBE2VPf0uRpvovXuBFG6cZKA6qOTXaq
         LZ/NMbL6f0Jtvm0idKDEkqsfVtG6TkpVLRoaRl4X+r6XwTvY5aZAbxM5U0U3mfwsFU
         H4MSd5IGBRbynntayloI+eKQBb5ng5VPiFKB9E0YYpvjQy59x3vFhCYeZpx604PbMS
         nlCRqbXgdY7lU8FduEySWchWxEvlh53bFqhyLEeNNhergioptiQZNGIpcbltyuwnld
         w62eK2YOUARzw==
Date:   Sat, 7 Jan 2023 11:02:02 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jisoo Jang <jisoo.jang@yonsei.ac.kr>
Cc:     pabeni@redhat.com, krzysztof.kozlowski@linaro.org,
        netdev@vger.kernel.org, edumazet@google.com, kuba@kernel.org,
        dokyungs@yonsei.ac.kr, linuxlovemin@yonsei.ac.kr
Subject: Re: [PATCH v2] net: nfc: Fix use-after-free in local_cleanup()
Message-ID: <Y7nBqiZkBt2P6hyF@x130>
References: <20230106055050.873324-1-jisoo.jang@yonsei.ac.kr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230106055050.873324-1-jisoo.jang@yonsei.ac.kr>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06 Jan 14:50, Jisoo Jang wrote:
>local_cleanup(). When detaching an nfc device, local_cleanup()
>called from nfc_llcp_unregister_device() frees local->rx_pending
>and cancels local->rx_work. So the socket allocated before
>unregister is not set null by nfc_llcp_rx_work().
>local_cleanup() called from local_release() frees local->rx_pending
>again, which leads to the bug.
>
>Set local->rx_pending to NULL in local_cleanup()
>
>Found by a modified version of syzkaller.
>
>BUG: KASAN: use-after-free in kfree_skb
>Call Trace:
> kfree_skb
> local_cleanup
> nfc_llcp_local_put
> llcp_sock_destruct
> __sk_destruct
> sk_destruct
> __sk_free
> sk_free
> llcp_sock_release
> __sock_release
> sock_close
> __fput
> task_work_run
> exit_to_user_mode_prepare
> syscall_exit_to_user_mode
> do_syscall_64
> entry_SYSCALL_64_after_hwframe
>
>Allocate by:
> __alloc_skb
> pn533_recv_response
> __usb_hcd_giveback_urb
> usb_hcd_giveback_urb
> dummy_timer
> call_timer_fn
> run_timer_softirq
> __do_softirq
>
>Freed by:
> kfree_skbmem
> kfree_skb
> local_cleanup

Why local_cleanup is called explicitly here ? 
The next thing nfc_llcp_unregister_device() will call is
nfc_llcp_local_put()->kref_put->local_release()->local_cleanup()


> nfc_llcp_unregister_device
> nfc_unregister_device
> pn53x_unregister_nfc
> pn533_usb_disconnect
> usb_unbind_interface
> device_release_driver_internal
> bus_remove_device
> device_del
> usb_disable_device
> usb_disconnect
> hub_event
> process_one_work
> worker_thread
> kthread
> ret_from_fork
>
>
>Signed-off-by: Jisoo Jang <jisoo.jang@yonsei.ac.kr>
>---
>v1->v2: set local->rx_pending to NULL instead move kfree_skb()
>
> net/nfc/llcp_core.c | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
>index 3364caabef8b..a27e1842b2a0 100644
>--- a/net/nfc/llcp_core.c
>+++ b/net/nfc/llcp_core.c
>@@ -157,6 +157,7 @@ static void local_cleanup(struct nfc_llcp_local *local)
> 	cancel_work_sync(&local->rx_work);
> 	cancel_work_sync(&local->timeout_work);
> 	kfree_skb(local->rx_pending);
>+	local->rx_pending = NULL;
> 	del_timer_sync(&local->sdreq_timer);
> 	cancel_work_sync(&local->sdreq_timeout_work);
> 	nfc_llcp_free_sdp_tlv_list(&local->pending_sdreqs);
>-- 
>2.25.1
>
