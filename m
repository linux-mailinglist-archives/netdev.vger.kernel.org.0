Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249A24F1ACE
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 23:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379233AbiDDVTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 17:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379044AbiDDQYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 12:24:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E642FDE9B
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 09:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649089328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jTrna+AUD+Mp9w9UI2+BksL4+LW35vlrQTcZ+Xfs0Xs=;
        b=NXy7WsBUo8n3YIlq67SOtcsWKFST5BBl9DpkyIDVxrXpk0eNNg2uIk/7J5+MaEybTPwbj/
        lNfvX9xY5jEPBbxRp0bScuaFuGVkWgSXey0o/Xzg4pyMmP5rjDyt3G/O5fInPro+lu95IH
        vevG93wpAbf9eRlFzwbC48FYGo7yPnQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-231-D6kGYG4rNjyVEaFY-MFM_A-1; Mon, 04 Apr 2022 12:22:03 -0400
X-MC-Unique: D6kGYG4rNjyVEaFY-MFM_A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E45B93C01B80;
        Mon,  4 Apr 2022 16:22:02 +0000 (UTC)
Received: from ceranb (unknown [10.40.193.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DCA8D536B9D;
        Mon,  4 Apr 2022 16:22:00 +0000 (UTC)
Date:   Mon, 4 Apr 2022 18:21:59 +0200
From:   Ivan Vecera <ivecera@redhat.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Brett Creeley <brett@pensando.io>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net] ice: arfs: fix use-after-free when freeing
 @rx_cpu_rmap
Message-ID: <20220404182159.108d4d4b@ceranb>
In-Reply-To: <20220404161509.3489310-1-alexandr.lobakin@intel.com>
References: <20220404161509.3489310-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  4 Apr 2022 18:15:09 +0200
Alexander Lobakin <alexandr.lobakin@intel.com> wrote:

> The CI testing bots triggered the following splat:
> 
> [  718.203054] BUG: KASAN: use-after-free in free_irq_cpu_rmap+0x53/0x80
> [  718.206349] Read of size 4 at addr ffff8881bd127e00 by task sh/20834
> [  718.212852] CPU: 28 PID: 20834 Comm: sh Kdump: loaded Tainted: G S      W IOE     5.17.0-rc8_nextqueue-devqueue-02643-g23f3121aca93 #1
> [  718.219695] Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS SE5C620.86B.02.01.0012.070720200218 07/07/2020
> [  718.223418] Call Trace:
> [  718.227139]
> [  718.230783]  dump_stack_lvl+0x33/0x42
> [  718.234431]  print_address_description.constprop.9+0x21/0x170
> [  718.238177]  ? free_irq_cpu_rmap+0x53/0x80
> [  718.241885]  ? free_irq_cpu_rmap+0x53/0x80
> [  718.245539]  kasan_report.cold.18+0x7f/0x11b
> [  718.249197]  ? free_irq_cpu_rmap+0x53/0x80
> [  718.252852]  free_irq_cpu_rmap+0x53/0x80
> [  718.256471]  ice_free_cpu_rx_rmap.part.11+0x37/0x50 [ice]
> [  718.260174]  ice_remove_arfs+0x5f/0x70 [ice]
> [  718.263810]  ice_rebuild_arfs+0x3b/0x70 [ice]
> [  718.267419]  ice_rebuild+0x39c/0xb60 [ice]
> [  718.270974]  ? asm_sysvec_apic_timer_interrupt+0x12/0x20
> [  718.274472]  ? ice_init_phy_user_cfg+0x360/0x360 [ice]
> [  718.278033]  ? delay_tsc+0x4a/0xb0
> [  718.281513]  ? preempt_count_sub+0x14/0xc0
> [  718.284984]  ? delay_tsc+0x8f/0xb0
> [  718.288463]  ice_do_reset+0x92/0xf0 [ice]
> [  718.292014]  ice_pci_err_resume+0x91/0xf0 [ice]
> [  718.295561]  pci_reset_function+0x53/0x80
> <...>
> [  718.393035] Allocated by task 690:
> [  718.433497] Freed by task 20834:
> [  718.495688] Last potentially related work creation:
> [  718.568966] The buggy address belongs to the object at ffff8881bd127e00
>                 which belongs to the cache kmalloc-96 of size 96
> [  718.574085] The buggy address is located 0 bytes inside of
>                 96-byte region [ffff8881bd127e00, ffff8881bd127e60)
> [  718.579265] The buggy address belongs to the page:
> [  718.598905] Memory state around the buggy address:
> [  718.601809]  ffff8881bd127d00: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
> [  718.604796]  ffff8881bd127d80: 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc
> [  718.607794] >ffff8881bd127e00: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
> [  718.610811]                    ^
> [  718.613819]  ffff8881bd127e80: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
> [  718.617107]  ffff8881bd127f00: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
> 
> This is due to that free_irq_cpu_rmap() is always being called
> *after* (devm_)free_irq() and thus it tries to work with IRQ descs
> already freed. For example, on device reset the driver frees the
> rmap right before allocating a new one (the splat above).
> Make rmap creation and freeing function symmetrical with
> {request,free}_irq() calls i.e. do that on ifup/ifdown instead
> of device probe/remove/resume. These operations can be performed
> independently from the actual device aRFS configuration.
> Also, make sure ice_vsi_free_irq() clears IRQ affinity notifiers
> only when aRFS is disabled -- otherwise, CPU rmap sets and clears
> its own and they must not be touched manually.
> 
> Fixes: 28bf26724fdb0 ("ice: Implement aRFS")
> Co-developed-by: Ivan Vecera <ivecera@redhat.com>
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> ---
> From v1[0]:
>  - remove the obsolete `!vsi->arfs_fltr_list` check from
>    ice_free_cpu_rx_rmap() leading to a leak and trace (Ivan).
> 
> [0] https://lore.kernel.org/netdev/20220404132832.1936529-1-alexandr.lobakin@intel.com

Now perfect. Thanks, Alex.

Tested-by: Ivan Vecera <ivecera@redhat.com>

