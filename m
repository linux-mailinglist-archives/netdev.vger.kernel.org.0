Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 097F459BFCD
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 14:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbiHVMyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 08:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234770AbiHVMxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 08:53:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FED26D2
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 05:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661172830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gcf1IpYpYYzfy/anHM3Sv882PaXLPIFpTjVixxvf9n8=;
        b=GZWJYvyOvOfrEBbfUmmMiA5ClAxooFe+YphPvbolIUoZBjA2idKwB1oVMzlcWAAnIEWe85
        6rP8e6Mqm8xOwhQaVcuepl976Z8+R3QbkU8b/GBb6rYKmOMwMGNjVGVE5m28dB6jJlBgoe
        YCcNEoDXsVuiTouCxG9pKk6GB7mfqew=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-b1qo-fDcO4ikHIyaqMRd0Q-1; Mon, 22 Aug 2022 08:53:46 -0400
X-MC-Unique: b1qo-fDcO4ikHIyaqMRd0Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B167811E75;
        Mon, 22 Aug 2022 12:53:46 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.33.87])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 49A76492C3B;
        Mon, 22 Aug 2022 12:53:45 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, pshelar@ovn.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ptikhomirov@virtuozzo.com,
        alexander.mikhalitsyn@virtuozzo.com, avagin@google.com,
        brauner@kernel.org, mark.d.gray@redhat.com, i.maximets@ovn.org
Subject: Re: [PATCH net-next v2 2/3] openvswitch: fix memory leak at failed
 datapath creation
References: <20220819153044.423233-1-andrey.zhadchenko@virtuozzo.com>
        <20220819153044.423233-3-andrey.zhadchenko@virtuozzo.com>
Date:   Mon, 22 Aug 2022 08:53:44 -0400
In-Reply-To: <20220819153044.423233-3-andrey.zhadchenko@virtuozzo.com> (Andrey
        Zhadchenko's message of "Fri, 19 Aug 2022 18:30:43 +0300")
Message-ID: <f7tzgfwmobr.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com> writes:

> ovs_dp_cmd_new()->ovs_dp_change()->ovs_dp_set_upcall_portids()
> allocates array via kmalloc.
> If for some reason new_vport() fails during ovs_dp_cmd_new()
> dp->upcall_portids must be freed.
> Add missing kfree.
>
> Kmemleak example:
> unreferenced object 0xffff88800c382500 (size 64):
>   comm "dump_state", pid 323, jiffies 4294955418 (age 104.347s)
>   hex dump (first 32 bytes):
>     5e c2 79 e4 1f 7a 38 c7 09 21 38 0c 80 88 ff ff  ^.y..z8..!8.....
>     03 00 00 00 0a 00 00 00 14 00 00 00 28 00 00 00  ............(...
>   backtrace:
>     [<0000000071bebc9f>] ovs_dp_set_upcall_portids+0x38/0xa0
>     [<000000000187d8bd>] ovs_dp_change+0x63/0xe0
>     [<000000002397e446>] ovs_dp_cmd_new+0x1f0/0x380
>     [<00000000aa06f36e>] genl_family_rcv_msg_doit+0xea/0x150
>     [<000000008f583bc4>] genl_rcv_msg+0xdc/0x1e0
>     [<00000000fa10e377>] netlink_rcv_skb+0x50/0x100
>     [<000000004959cece>] genl_rcv+0x24/0x40
>     [<000000004699ac7f>] netlink_unicast+0x23e/0x360
>     [<00000000c153573e>] netlink_sendmsg+0x24e/0x4b0
>     [<000000006f4aa380>] sock_sendmsg+0x62/0x70
>     [<00000000d0068654>] ____sys_sendmsg+0x230/0x270
>     [<0000000012dacf7d>] ___sys_sendmsg+0x88/0xd0
>     [<0000000011776020>] __sys_sendmsg+0x59/0xa0
>     [<000000002e8f2dc1>] do_syscall_64+0x3b/0x90
>     [<000000003243e7cb>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> Fixes: b83d23a2a38b ("openvswitch: Introduce per-cpu upcall dispatch")
> Signed-off-by: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
> ---

Thanks for this patch.  I guess independent of this series, this patch
should be applied to the net tree as well - it fixes an existing issue.

Acked-by: Aaron Conole <aconole@redhat.com>

I will try as well the other patches in the series.

