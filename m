Return-Path: <netdev+bounces-8619-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D4E5724E4F
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 22:51:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4B201C20BE3
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 20:51:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9D4421CD0;
	Tue,  6 Jun 2023 20:51:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FAE74C7A
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 20:51:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BFF10D5
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 13:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686084714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7v0vDzUIBFUEr0PK6Q7pg1h8LYOgL4fQYHbyUtz5jkA=;
	b=T7EL3IE1JGp4LrFhV0spGGYdDSuimNw/J1uMjIIYqO0U0d+ijsXvGQMYjlmpeBk0hCXj5l
	PK7419kjrMqDy/02tOem/gXt3zHO+cXzKTp9hBkVJQrIzAJ36gC04l1UD+G6NOTypoJKg6
	3weQMwYw5MeH97tP1gDcyhbhmpUKsno=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-57-3j47bd0sMJacQ-rPleouGQ-1; Tue, 06 Jun 2023 16:51:51 -0400
X-MC-Unique: 3j47bd0sMJacQ-rPleouGQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4CFAB801585;
	Tue,  6 Jun 2023 20:51:51 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.17.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DF8491121314;
	Tue,  6 Jun 2023 20:51:50 +0000 (UTC)
From: Aaron Conole <aconole@redhat.com>
To: Eelco Chaudron <echaudro@redhat.com>
Cc: netdev@vger.kernel.org,  pshelar@ovn.org,  davem@davemloft.net,
  edumazet@google.com,  kuba@kernel.org,  pabeni@redhat.com,
  dev@openvswitch.org
Subject: Re: [PATCH net] net: openvswitch: fix upcall counter access before
 allocation
References: <168595558535.1618839.4634246126873842766.stgit@ebuild>
Date: Tue, 06 Jun 2023 16:51:50 -0400
In-Reply-To: <168595558535.1618839.4634246126873842766.stgit@ebuild> (Eelco
	Chaudron's message of "Mon, 5 Jun 2023 10:59:50 +0200")
Message-ID: <f7tfs745n6h.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Eelco Chaudron <echaudro@redhat.com> writes:

> Currently, the per cpu upcall counters are allocated after the vport is
> created and inserted into the system. This could lead to the datapath
> accessing the counters before they are allocated resulting in a kernel
> Oops.
>
> Here is an example:
>
>   PID: 59693    TASK: ffff0005f4f51500  CPU: 0    COMMAND: "ovs-vswitchd"
>    #0 [ffff80000a39b5b0] __switch_to at ffffb70f0629f2f4
>    #1 [ffff80000a39b5d0] __schedule at ffffb70f0629f5cc
>    #2 [ffff80000a39b650] preempt_schedule_common at ffffb70f0629fa60
>    #3 [ffff80000a39b670] dynamic_might_resched at ffffb70f0629fb58
>    #4 [ffff80000a39b680] mutex_lock_killable at ffffb70f062a1388
>    #5 [ffff80000a39b6a0] pcpu_alloc at ffffb70f0594460c
>    #6 [ffff80000a39b750] __alloc_percpu_gfp at ffffb70f05944e68
>    #7 [ffff80000a39b760] ovs_vport_cmd_new at ffffb70ee6961b90 [openvswitch]
>    ...
>
>   PID: 58682    TASK: ffff0005b2f0bf00  CPU: 0    COMMAND: "kworker/0:3"
>    #0 [ffff80000a5d2f40] machine_kexec at ffffb70f056a0758
>    #1 [ffff80000a5d2f70] __crash_kexec at ffffb70f057e2994
>    #2 [ffff80000a5d3100] crash_kexec at ffffb70f057e2ad8
>    #3 [ffff80000a5d3120] die at ffffb70f0628234c
>    #4 [ffff80000a5d31e0] die_kernel_fault at ffffb70f062828a8
>    #5 [ffff80000a5d3210] __do_kernel_fault at ffffb70f056a31f4
>    #6 [ffff80000a5d3240] do_bad_area at ffffb70f056a32a4
>    #7 [ffff80000a5d3260] do_translation_fault at ffffb70f062a9710
>    #8 [ffff80000a5d3270] do_mem_abort at ffffb70f056a2f74
>    #9 [ffff80000a5d32a0] el1_abort at ffffb70f06297dac
>   #10 [ffff80000a5d32d0] el1h_64_sync_handler at ffffb70f06299b24
>   #11 [ffff80000a5d3410] el1h_64_sync at ffffb70f056812dc
>   #12 [ffff80000a5d3430] ovs_dp_upcall at ffffb70ee6963c84 [openvswitch]
>   #13 [ffff80000a5d3470] ovs_dp_process_packet at ffffb70ee6963fdc [openvswitch]
>   #14 [ffff80000a5d34f0] ovs_vport_receive at ffffb70ee6972c78 [openvswitch]
>   #15 [ffff80000a5d36f0] netdev_port_receive at ffffb70ee6973948 [openvswitch]
>   #16 [ffff80000a5d3720] netdev_frame_hook at ffffb70ee6973a28 [openvswitch]
>   #17 [ffff80000a5d3730] __netif_receive_skb_core.constprop.0 at ffffb70f06079f90
>
> We moved the per cpu upcall counter allocation to the existing vport
> alloc and free functions to solve this.
>
> Fixes: 95637d91fefd ("net: openvswitch: release vport resources on failure")
> Fixes: 1933ea365aa7 ("net: openvswitch: Add support to count upcall packets")
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---

Acked-by: Aaron Conole <aconole@redhat.com>

This is a particularly difficult one to reproduce.  Thanks for posting
the fix.


