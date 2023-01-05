Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA23F65EA13
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 12:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbjAELm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 06:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjAELmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 06:42:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4CD44C71
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 03:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672918896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D6yFSsu1+uJ+W8DhHQe6JdN2idAkDqdvuQjxWUZWOw0=;
        b=CX4I4piz5arNTsU7v8c9dXkF68LgsrhKnE4YFelr6M31QemcRZMOMXWAbZsgcNXA3WIMye
        Q77/maAA4a68rm4Th1LOne/GA7/iY7J2JfD5LQf916I/HnRbMr57uYK7LOnzszfqbuv99I
        CQsjklIJW54bQwZYAqaxyWIhgp4iXaI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-141-4VeVaU2ROqWDLoRb0NzD8w-1; Thu, 05 Jan 2023 06:41:35 -0500
X-MC-Unique: 4VeVaU2ROqWDLoRb0NzD8w-1
Received: by mail-wm1-f71.google.com with SMTP id m38-20020a05600c3b2600b003d1fc5f1f80so890756wms.1
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 03:41:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D6yFSsu1+uJ+W8DhHQe6JdN2idAkDqdvuQjxWUZWOw0=;
        b=47Rj9kUY5i1/H5UkKCOFkKyoATqNx05MZTcgvdur9E6vFjxIYI8KAxyrApDA4Dx8K6
         rKaID6LqapRodhqMdc5PZdcGLhLzC5VuC76bQfGr+xtCoUe5rXaGiq85m5zExBPTkwFB
         oxbE5K9Wmes+lJv6jCOjQ3NJtifaobOyMfJzQyOpPaS/b3bqU8xguwAEn174cIvmTWlw
         hKpPnWUwf2BnMOvHr9WADtARlKjwvV2lt74IzzxXmRcIuON6PTPNiDddVTZp/097xUa6
         RzdhOWj64gIhZMoEUCy77VsTYtz6sRFF2ZLAhF2fZqCvK8zx9ei430pAojpBLDAi5RS6
         0yJQ==
X-Gm-Message-State: AFqh2kpfakx5kGZN9k8yhURnTnahTfrjmb89kaOkNgKNIPM5uWqc5XMW
        a9VXARjYfaAkJo+VDwHLwPtxIlvTpUBF3g+fIG/uGXe9OzQvejPKfP7bQYrap5RM2hEsL6zm8hr
        bYYNehVz4/WVSHUQT
X-Received: by 2002:a05:600c:3b26:b0:3d7:fa4a:681b with SMTP id m38-20020a05600c3b2600b003d7fa4a681bmr38507683wms.0.1672918893929;
        Thu, 05 Jan 2023 03:41:33 -0800 (PST)
X-Google-Smtp-Source: AMrXdXubjqYBX+KIYBx9px3snM++K14YlGTcGtyBKFq2fkNxXv2vpxHhyUuVs1GsekH/my2lo7mGlg==
X-Received: by 2002:a05:600c:3b26:b0:3d7:fa4a:681b with SMTP id m38-20020a05600c3b2600b003d7fa4a681bmr38507675wms.0.1672918893695;
        Thu, 05 Jan 2023 03:41:33 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-105-31.dyn.eolo.it. [146.241.105.31])
        by smtp.gmail.com with ESMTPSA id fm14-20020a05600c0c0e00b003d208eb17ecsm2150451wmb.26.2023.01.05.03.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 03:41:33 -0800 (PST)
Message-ID: <0a0932848b04b844d94561c3dc4186b6ae9dbe31.camel@redhat.com>
Subject: Re: [PATCH] net: nfc: Fix use-after-free in local_cleanup()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jisoo Jang <jisoo.jang@yonsei.ac.kr>,
        krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org
Cc:     edumazet@google.com, kuba@kernel.org, dokyungs@yonsei.ac.kr,
        linuxlovemin@yonsei.ac.kr
Date:   Thu, 05 Jan 2023 12:41:31 +0100
In-Reply-To: <20230104125738.418427-1-jisoo.jang@yonsei.ac.kr>
References: <20230104125738.418427-1-jisoo.jang@yonsei.ac.kr>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-01-04 at 21:57 +0900, Jisoo Jang wrote:
> Fix a use-after-free that occurs in kfree_skb() called from
> local_cleanup(). When detaching an nfc device, local_cleanup()
> called from nfc_llcp_unregister_device() frees local->rx_pending
> and cancels local->rx_work. So the socket allocated before
> unregister is not set null by nfc_llcp_rx_work().
> local_cleanup() called from local_release() frees local->rx_pending
> again, which leads to the bug.
> 
> Ensure kfree_skb() is called once when unregistering the device.
> 
> Found by a modified version of syzkaller.
> 
> BUG: KASAN: use-after-free in kfree_skb
> Call Trace:
>  kfree_skb
>  local_cleanup
>  nfc_llcp_local_put
>  llcp_sock_destruct
>  __sk_destruct
>  sk_destruct
>  __sk_free
>  sk_free
>  llcp_sock_release
>  __sock_release
>  sock_close
>  __fput
>  task_work_run
>  exit_to_user_mode_prepare
>  syscall_exit_to_user_mode
>  do_syscall_64
>  entry_SYSCALL_64_after_hwframe
> 
> Allocate by:
>  __alloc_skb
>  pn533_recv_response
>  __usb_hcd_giveback_urb
>  usb_hcd_giveback_urb
>  dummy_timer
>  call_timer_fn
>  run_timer_softirq
>  __do_softirq
> 
> Freed by:
>  kfree_skbmem
>  kfree_skb
>  local_cleanup
>  nfc_llcp_unregister_device
>  nfc_unregister_device
>  pn53x_unregister_nfc
>  pn533_usb_disconnect
>  usb_unbind_interface
>  device_release_driver_internal
>  bus_remove_device
>  device_del
>  usb_disable_device
>  usb_disconnect
>  hub_event
>  process_one_work
>  worker_thread
>  kthread
>  ret_from_fork
> 
> Signed-off-by: Jisoo Jang <jisoo.jang@yonsei.ac.kr>
> ---
>  net/nfc/llcp_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
> index 3364caabef8b..cbf2ef0af57b 100644
> --- a/net/nfc/llcp_core.c
> +++ b/net/nfc/llcp_core.c
> @@ -156,7 +156,6 @@ static void local_cleanup(struct nfc_llcp_local *local)
>  	cancel_work_sync(&local->tx_work);
>  	cancel_work_sync(&local->rx_work);
>  	cancel_work_sync(&local->timeout_work);
> -	kfree_skb(local->rx_pending);
>  	del_timer_sync(&local->sdreq_timer);
>  	cancel_work_sync(&local->sdreq_timeout_work);
>  	nfc_llcp_free_sdp_tlv_list(&local->pending_sdreqs);
> @@ -170,6 +169,7 @@ static void local_release(struct kref *ref)
>  
>  	list_del(&local->list);
>  	local_cleanup(local);
> +	kfree_skb(local->rx_pending);
>  	kfree(local);
>  }
> 

With this change, local->tx_work/nfc_llcp_tx_work can be invoked after
nfc_unregister_device(). nfc_llcp_tx_work assumnes the nfc device is
alive, so I guess we need (part of) local_cleanup() being in place at
nfc de-registration time.

What about simply setting local->rx_pending to NULL in local_cleanup()?

Thanks!

Paolo

