Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D41B6AE6FD
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 17:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbjCGQoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 11:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbjCGQnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 11:43:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D45096C30
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 08:40:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678207170;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=NwQ3wDlpFiZI+BrzfSgoKWGDASiKEaVASGy92MgjLxs=;
        b=Pb8eROqK1jg4P+6Z1tUS8J0i6ZCfEhQtnRL0XXDVH0oV4jy6AFfUxijJDDIqmAjtvsPtcQ
        qxUFD3MbjhTFRG9bc3ocSlchOoDSSkV0jr/Yv0RNkJEn0DDK7BPGdAbd+DhL5Thvi4J1OG
        ECWCn5110IsL/90XISoAcuLEIiObatQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-149-DyI-u7sfNMyppRNjIEtT9Q-1; Tue, 07 Mar 2023 11:33:17 -0500
X-MC-Unique: DyI-u7sfNMyppRNjIEtT9Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1ECB790F923;
        Tue,  7 Mar 2023 16:27:21 +0000 (UTC)
Received: from calimero.vinschen.de (unknown [10.39.192.200])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2061FC15BAE;
        Tue,  7 Mar 2023 16:27:20 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id BEFC2A80C30; Tue,  7 Mar 2023 17:27:18 +0100 (CET)
Date:   Tue, 7 Mar 2023 17:27:18 +0100
From:   Corinna Vinschen <vinschen@redhat.com>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, richardcochran@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, intel-wired-lan@lists.osuosl.org,
        pmenzel@molgen.mpg.de, regressions@lists.linux.dev,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] igb: revert rtnl_lock() that causes deadlock
Message-ID: <ZAdl5jr3rBoTb7qZ@calimero.vinschen.de>
Reply-To: intel-wired-lan@lists.osuosl.org
Mail-Followup-To: Lin Ma <linma@zju.edu.cn>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        richardcochran@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        intel-wired-lan@lists.osuosl.org, pmenzel@molgen.mpg.de,
        regressions@lists.linux.dev, stable@vger.kernel.org
References: <ZAc/3oVos9DBx3iR@calimero.vinschen.de>
 <20230307152917.32182-1-linma@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230307152917.32182-1-linma@zju.edu.cn>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mar  7 23:29, Lin Ma wrote:
> The commit 6faee3d4ee8b ("igb: Add lock to avoid data race") adds
> rtnl_lock to eliminate a false data race shown below
> 
>  (FREE from device detaching)      |   (USE from netdev core)
> igb_remove                         |  igb_ndo_get_vf_config
>  igb_disable_sriov                 |  vf >= adapter->vfs_allocated_count?
>   kfree(adapter->vf_data)          |
>   adapter->vfs_allocated_count = 0 |
>                                    |    memcpy(... adapter->vf_data[vf]
> 
> The above race will never happen and the extra rtnl_lock causes deadlock
> below
> 
> [  141.420169]  <TASK>
> [  141.420672]  __schedule+0x2dd/0x840
> [  141.421427]  schedule+0x50/0xc0
> [  141.422041]  schedule_preempt_disabled+0x11/0x20
> [  141.422678]  __mutex_lock.isra.13+0x431/0x6b0
> [  141.423324]  unregister_netdev+0xe/0x20
> [  141.423578]  igbvf_remove+0x45/0xe0 [igbvf]
> [  141.423791]  pci_device_remove+0x36/0xb0
> [  141.423990]  device_release_driver_internal+0xc1/0x160
> [  141.424270]  pci_stop_bus_device+0x6d/0x90
> [  141.424507]  pci_stop_and_remove_bus_device+0xe/0x20
> [  141.424789]  pci_iov_remove_virtfn+0xba/0x120
> [  141.425452]  sriov_disable+0x2f/0xf0
> [  141.425679]  igb_disable_sriov+0x4e/0x100 [igb]
> [  141.426353]  igb_remove+0xa0/0x130 [igb]
> [  141.426599]  pci_device_remove+0x36/0xb0
> [  141.426796]  device_release_driver_internal+0xc1/0x160
> [  141.427060]  driver_detach+0x44/0x90
> [  141.427253]  bus_remove_driver+0x55/0xe0
> [  141.427477]  pci_unregister_driver+0x2a/0xa0
> [  141.428296]  __x64_sys_delete_module+0x141/0x2b0
> [  141.429126]  ? mntput_no_expire+0x4a/0x240
> [  141.429363]  ? syscall_trace_enter.isra.19+0x126/0x1a0
> [  141.429653]  do_syscall_64+0x5b/0x80
> [  141.429847]  ? exit_to_user_mode_prepare+0x14d/0x1c0
> [  141.430109]  ? syscall_exit_to_user_mode+0x12/0x30
> [  141.430849]  ? do_syscall_64+0x67/0x80
> [  141.431083]  ? syscall_exit_to_user_mode_prepare+0x183/0x1b0
> [  141.431770]  ? syscall_exit_to_user_mode+0x12/0x30
> [  141.432482]  ? do_syscall_64+0x67/0x80
> [  141.432714]  ? exc_page_fault+0x64/0x140
> [  141.432911]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> 
> Since the igb_disable_sriov() will call pci_disable_sriov() before
> releasing any resources, the netdev core will synchronize the cleanup to
> avoid any races. This patch removes the useless rtnl_(un)lock to guarantee
> correctness.
> 
> CC: stable@vger.kernel.org
> Fixes: 6faee3d4ee8b ("igb: Add lock to avoid data race")
> Reported-by: Corinna Vinschen <vinschen@redhat.com>
> Link: https://lore.kernel.org/intel-wired-lan/ZAcJvkEPqWeJHO2r@calimero.vinschen.de/
> Signed-off-by: Lin Ma <linma@zju.edu.cn>

Tested-by: Corinna Vinschen <vinschen@redhat.com>


Thanks,
Corinna

