Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F44502846
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 12:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244084AbiDOK21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 06:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352299AbiDOK20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 06:28:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 91CDABBE1F
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 03:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650018357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HVOGcxJlhUaQTDwioEmpkZGtMHyUwP0bW34wHvyVnV8=;
        b=Gzce5AFxopGjgD28CodGf18ies125ieBd0DgNjL5zwIZEQInWBNhNhu+15J6MnkR10gFTy
        K6g40YaW4/iagO0bXZ7w9rMzzcz4c9KOHOj2lL13VuDbZ/Q14gfTcb2AiUxce8iUkTcbmu
        wB0qtDD5XPePWaAB5uuqLTuGjESEMoU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-36-v8zn6BicPCautHzWhyQ-qQ-1; Fri, 15 Apr 2022 06:25:56 -0400
X-MC-Unique: v8zn6BicPCautHzWhyQ-qQ-1
Received: by mail-ed1-f71.google.com with SMTP id t9-20020aa7d4c9000000b0041ff2e578dcso4012412edr.16
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 03:25:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HVOGcxJlhUaQTDwioEmpkZGtMHyUwP0bW34wHvyVnV8=;
        b=iONbcx2+gtbfJCnza3byjqWw8/qd9/ijDwcC3iWrCbcszXfWxXvNR5fUgPkgB8jRzU
         E8vU57ifxNt95yR1NA91VIMOOS8NxrMEbknhRNoR6zou2CP4lWxQs6F1x+tblimarGPM
         /J5EFRYDQOrd6so+NZ0/TqAZBTpuVC1hAhf3Vpflp/ynsAgS6jBYuF9ytY4o8GC0UYYU
         KcodweF1GMxOnXJd7aT97t5gCktrWHrMfUWucQSBtIBkQA/UUug/7KfBXtWxbJuNIHbq
         5neqVRwCeCuT7pBMJ6y/3xufCLIvBhLNhvp54kGMMo1NOoEDLns2za0vBwYc9iNMCdB3
         cGig==
X-Gm-Message-State: AOAM5310tiiPX8DIlRjHZygEFmLY+iDolOekLbgvKz1ycTw1R9v+eI3a
        1wEcuP8ytG8bDWJWMFhKxiEOHgxOqzyyfSMCj8TWcfiAhckIymvI/bw2z+fYvc9Sl6TP3e6hqFY
        H+tnc/C0rALXGiTZu
X-Received: by 2002:a17:907:7e84:b0:6e8:b7ce:22b5 with SMTP id qb4-20020a1709077e8400b006e8b7ce22b5mr5579655ejc.763.1650018355258;
        Fri, 15 Apr 2022 03:25:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyk6M533dhdPB/fMPbiU1LHutkqBWogXhzimlt8N+dBQDbw+WEYcoow0bSsOAmT+adoHVtpUA==
X-Received: by 2002:a17:907:7e84:b0:6e8:b7ce:22b5 with SMTP id qb4-20020a1709077e8400b006e8b7ce22b5mr5579646ejc.763.1650018355054;
        Fri, 15 Apr 2022 03:25:55 -0700 (PDT)
Received: from [10.39.192.127] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id a22-20020a50ff16000000b00410d029ea5csm2379162edu.96.2022.04.15.03.25.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Apr 2022 03:25:54 -0700 (PDT)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     Paolo Valerio <pvalerio@redhat.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org
Subject: Re: [ovs-dev] [PATCH] openvswitch: fix OOB access in
 reserve_sfa_size()
Date:   Fri, 15 Apr 2022 12:25:53 +0200
X-Mailer: MailMate (1.14r5885)
Message-ID: <B291EC2A-DC76-47F3-90E8-885699779FDF@redhat.com>
In-Reply-To: <165001012108.2147631.5880395764325229829.stgit@fed.void>
References: <165001012108.2147631.5880395764325229829.stgit@fed.void>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 15 Apr 2022, at 10:08, Paolo Valerio wrote:

> Given a sufficiently large number of actions, while copying and
> reserving memory for a new action of a new flow, if next_offset is
> greater than MAX_ACTIONS_BUFSIZE, the function reserve_sfa_size() does
> not return -EMSGSIZE as expected, but it allocates MAX_ACTIONS_BUFSIZE
> bytes increasing actions_len by req_size. This can then lead to an OOB
> write access, especially when further actions need to be copied.
>
> Fix it by rearranging the flow action size check.
>
> KASAN splat below:
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in reserve_sfa_size+0x1ba/0x380 [openvsw=
itch]
> Write of size 65360 at addr ffff888147e4001c by task handler15/836
>
> CPU: 1 PID: 836 Comm: handler15 Not tainted 5.18.0-rc1+ #27
> ...
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x45/0x5a
>  print_report.cold+0x5e/0x5db
>  ? __lock_text_start+0x8/0x8
>  ? reserve_sfa_size+0x1ba/0x380 [openvswitch]
>  kasan_report+0xb5/0x130
>  ? reserve_sfa_size+0x1ba/0x380 [openvswitch]
>  kasan_check_range+0xf5/0x1d0
>  memcpy+0x39/0x60
>  reserve_sfa_size+0x1ba/0x380 [openvswitch]
>  __add_action+0x24/0x120 [openvswitch]
>  ovs_nla_add_action+0xe/0x20 [openvswitch]
>  ovs_ct_copy_action+0x29d/0x1130 [openvswitch]
>  ? __kernel_text_address+0xe/0x30
>  ? unwind_get_return_address+0x56/0xa0
>  ? create_prof_cpu_mask+0x20/0x20
>  ? ovs_ct_verify+0xf0/0xf0 [openvswitch]
>  ? prep_compound_page+0x198/0x2a0
>  ? __kasan_check_byte+0x10/0x40
>  ? kasan_unpoison+0x40/0x70
>  ? ksize+0x44/0x60
>  ? reserve_sfa_size+0x75/0x380 [openvswitch]
>  __ovs_nla_copy_actions+0xc26/0x2070 [openvswitch]
>  ? __zone_watermark_ok+0x420/0x420
>  ? validate_set.constprop.0+0xc90/0xc90 [openvswitch]
>  ? __alloc_pages+0x1a9/0x3e0
>  ? __alloc_pages_slowpath.constprop.0+0x1da0/0x1da0
>  ? unwind_next_frame+0x991/0x1e40
>  ? __mod_node_page_state+0x99/0x120
>  ? __mod_lruvec_page_state+0x2e3/0x470
>  ? __kasan_kmalloc_large+0x90/0xe0
>  ovs_nla_copy_actions+0x1b4/0x2c0 [openvswitch]
>  ovs_flow_cmd_new+0x3cd/0xb10 [openvswitch]
>  ...
>
> Cc: stable@vger.kernel.org
> Fixes: f28cd2af22a0 ("openvswitch: fix flow actions reallocation")
> Signed-off-by: Paolo Valerio <pvalerio@redhat.com>

Change looks fine to me.

Acked-by: Eelco Chaudron <echaudro@redhat.com>

> ---
>  net/openvswitch/flow_netlink.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netl=
ink.c
> index 7176156d3844..4c09cf8a0ab2 100644
> --- a/net/openvswitch/flow_netlink.c
> +++ b/net/openvswitch/flow_netlink.c
> @@ -2465,7 +2465,7 @@ static struct nlattr *reserve_sfa_size(struct sw_=
flow_actions **sfa,
>  	new_acts_size =3D max(next_offset + req_size, ksize(*sfa) * 2);
>
>  	if (new_acts_size > MAX_ACTIONS_BUFSIZE) {
> -		if ((MAX_ACTIONS_BUFSIZE - next_offset) < req_size) {
> +		if ((next_offset + req_size) > MAX_ACTIONS_BUFSIZE) {
>  			OVS_NLERR(log, "Flow action size exceeds max %u",
>  				  MAX_ACTIONS_BUFSIZE);
>  			return ERR_PTR(-EMSGSIZE);
>
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev

