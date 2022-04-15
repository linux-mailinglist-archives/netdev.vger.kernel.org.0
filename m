Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8266502687
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 10:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244551AbiDOILV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 04:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234920AbiDOILS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 04:11:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A6C9DA207F
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 01:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650010129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=vpehKJ0zTwJUI6+hRmJYUW5SCsbqvW8TRk+pqvNLRAw=;
        b=Smr6uKvGFGI/bZc10o45+xxJKUABQOq2txrY0MPRw9O/hqXeuKZbcxij1svWA5+x7SbMT9
        pKp3XsNqjeBa9breGeV8f6wUgDr76GR1wMJrK6W5vsnZV6SUCIFcZx3IYwz85axHxnkJIQ
        Rv4KqXHDatHGcvEFwJY5EvyLuhNVKXk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-426-0XINriSpNx6lmMwExS7dUQ-1; Fri, 15 Apr 2022 04:08:48 -0400
X-MC-Unique: 0XINriSpNx6lmMwExS7dUQ-1
Received: by mail-wm1-f69.google.com with SMTP id r64-20020a1c2b43000000b0038b59eb1940so3766942wmr.0
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 01:08:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=vpehKJ0zTwJUI6+hRmJYUW5SCsbqvW8TRk+pqvNLRAw=;
        b=nZ43fdqx1n0yeYT0H97j6IpwJ79V7mmmCCGgzvavpyd/rS4bdHvK/x8e6HPwpb+SKc
         5becQsjCoW5M5WYOQwsQ28jSJWt+ER2Pa7iXcFZbwMqEs92vCvvHPxHsmOWu7wgig2Bs
         ETz3R1RWawKnjYVB1v5N5a5/7T45atJxXuFwE+HR6IUSobGV1XUmLEiBeC6QuffTaYog
         sWVilL90hGiQmm9pBtE/tyLlI230QpDd9GG46cLu2gTNhzNTylkMXBwEeFcy3cFJOroj
         YokeJqR7nQIAN5WdIf5FlSXHpqq6hWh3NgXZkE7/275uYRSC8t2gU1OXXJxD51Y/fun3
         OBqQ==
X-Gm-Message-State: AOAM530epvSfpoIEfg8kcRAStZ+W2Lh12P7sP4yRtDk7yyvd8jak36Xb
        T3+eJ+3h0VE80DHiLcinjmGtQsfhP6A7K7GcVCkEy7jAfcjoqxkU3J5RaW7p9XpAfb01cNYidzo
        D15ld0UhYymo5bpXvar2HDvgfqg5b81Oi6omzENSag5qd+xqvkhJOYzcpYHepOk2CojIX
X-Received: by 2002:adf:e3c8:0:b0:207:a128:6205 with SMTP id k8-20020adfe3c8000000b00207a1286205mr4580105wrm.370.1650010127277;
        Fri, 15 Apr 2022 01:08:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyfK3tLgQgE9GRjr8IzikqTBblXrumiDHFMUj55H/EGUOYj4hX0V7PE0ksW+1mqLz16rohDmw==
X-Received: by 2002:adf:e3c8:0:b0:207:a128:6205 with SMTP id k8-20020adfe3c8000000b00207a1286205mr4580078wrm.370.1650010126913;
        Fri, 15 Apr 2022 01:08:46 -0700 (PDT)
Received: from localhost (net-2-39-43-66.cust.vodafonedsl.it. [2.39.43.66])
        by smtp.gmail.com with ESMTPSA id o40-20020a05600c512800b0038ebf2858cbsm8609134wms.16.2022.04.15.01.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 01:08:46 -0700 (PDT)
Subject: [PATCH] openvswitch: fix OOB access in reserve_sfa_size()
From:   Paolo Valerio <pvalerio@redhat.com>
To:     netdev@vger.kernel.org, dev@openvswitch.org
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, stable@vger.kernel.org
Date:   Fri, 15 Apr 2022 10:08:41 +0200
Message-ID: <165001012108.2147631.5880395764325229829.stgit@fed.void>
User-Agent: StGit/1.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given a sufficiently large number of actions, while copying and
reserving memory for a new action of a new flow, if next_offset is
greater than MAX_ACTIONS_BUFSIZE, the function reserve_sfa_size() does
not return -EMSGSIZE as expected, but it allocates MAX_ACTIONS_BUFSIZE
bytes increasing actions_len by req_size. This can then lead to an OOB
write access, especially when further actions need to be copied.

Fix it by rearranging the flow action size check.

KASAN splat below:

==================================================================
BUG: KASAN: slab-out-of-bounds in reserve_sfa_size+0x1ba/0x380 [openvswitch]
Write of size 65360 at addr ffff888147e4001c by task handler15/836

CPU: 1 PID: 836 Comm: handler15 Not tainted 5.18.0-rc1+ #27
...
Call Trace:
 <TASK>
 dump_stack_lvl+0x45/0x5a
 print_report.cold+0x5e/0x5db
 ? __lock_text_start+0x8/0x8
 ? reserve_sfa_size+0x1ba/0x380 [openvswitch]
 kasan_report+0xb5/0x130
 ? reserve_sfa_size+0x1ba/0x380 [openvswitch]
 kasan_check_range+0xf5/0x1d0
 memcpy+0x39/0x60
 reserve_sfa_size+0x1ba/0x380 [openvswitch]
 __add_action+0x24/0x120 [openvswitch]
 ovs_nla_add_action+0xe/0x20 [openvswitch]
 ovs_ct_copy_action+0x29d/0x1130 [openvswitch]
 ? __kernel_text_address+0xe/0x30
 ? unwind_get_return_address+0x56/0xa0
 ? create_prof_cpu_mask+0x20/0x20
 ? ovs_ct_verify+0xf0/0xf0 [openvswitch]
 ? prep_compound_page+0x198/0x2a0
 ? __kasan_check_byte+0x10/0x40
 ? kasan_unpoison+0x40/0x70
 ? ksize+0x44/0x60
 ? reserve_sfa_size+0x75/0x380 [openvswitch]
 __ovs_nla_copy_actions+0xc26/0x2070 [openvswitch]
 ? __zone_watermark_ok+0x420/0x420
 ? validate_set.constprop.0+0xc90/0xc90 [openvswitch]
 ? __alloc_pages+0x1a9/0x3e0
 ? __alloc_pages_slowpath.constprop.0+0x1da0/0x1da0
 ? unwind_next_frame+0x991/0x1e40
 ? __mod_node_page_state+0x99/0x120
 ? __mod_lruvec_page_state+0x2e3/0x470
 ? __kasan_kmalloc_large+0x90/0xe0
 ovs_nla_copy_actions+0x1b4/0x2c0 [openvswitch]
 ovs_flow_cmd_new+0x3cd/0xb10 [openvswitch]
 ...

Cc: stable@vger.kernel.org
Fixes: f28cd2af22a0 ("openvswitch: fix flow actions reallocation")
Signed-off-by: Paolo Valerio <pvalerio@redhat.com>
---
 net/openvswitch/flow_netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 7176156d3844..4c09cf8a0ab2 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -2465,7 +2465,7 @@ static struct nlattr *reserve_sfa_size(struct sw_flow_actions **sfa,
 	new_acts_size = max(next_offset + req_size, ksize(*sfa) * 2);
 
 	if (new_acts_size > MAX_ACTIONS_BUFSIZE) {
-		if ((MAX_ACTIONS_BUFSIZE - next_offset) < req_size) {
+		if ((next_offset + req_size) > MAX_ACTIONS_BUFSIZE) {
 			OVS_NLERR(log, "Flow action size exceeds max %u",
 				  MAX_ACTIONS_BUFSIZE);
 			return ERR_PTR(-EMSGSIZE);

