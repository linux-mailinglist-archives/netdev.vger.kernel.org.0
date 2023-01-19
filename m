Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF1B672E69
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 02:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjASBsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 20:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbjASBps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 20:45:48 -0500
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644716CCE5;
        Wed, 18 Jan 2023 17:41:12 -0800 (PST)
Received: by mail-il1-f179.google.com with SMTP id o15so487727ill.11;
        Wed, 18 Jan 2023 17:41:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NWx1ifZUs9l9sboCMEKp9kjSayYw0rzPlsqI93NKq28=;
        b=T9QNXRcX4kmOjXHjg9TVOWUAUBw5ZXElRNTf1NepTjWHUV5/+XVcaBLadrIF2Bd35P
         z0vFYQJ80Y3ZmuBvENh72cCzoFbD1TbPeooq4HD2qniBJ7cVFes/Ux/+lp22NjHSbt4I
         edESdwIwDIyS2anq5bkUqzdFhmAoppG93BU+10uq1+nvoTBO0y6NzeL1JVSMB2TsDc7S
         KAsllVvXyiuFmZJNrC8AKCpRqtVCiwKQK9w0T2LxaTpAYzYlRf47o4avj7e/wLdyzenF
         fr29AWO0w/8zDiT5K6SGDaGcsFsODCPjSFvtsbXPuLMbdrLCQwHxHs6JG5m5QTgNN1pD
         SBLQ==
X-Gm-Message-State: AFqh2koTgqWfyjmju+0HLw6GPHpEgXj4RD2bg7lxJ4DcL6M86QmogdZy
        Oncrlmbh1prFgB2hyvuEozM=
X-Google-Smtp-Source: AMrXdXsJZ4ypc59+TTWzAf3aEnIx45RJ3OtVIK6QHrw6Knoq/hHcJIkl3VlsVqm4XiUC2vhhf+GLlw==
X-Received: by 2002:a92:c54b:0:b0:308:cdc3:9370 with SMTP id a11-20020a92c54b000000b00308cdc39370mr9612880ilj.15.1674092471685;
        Wed, 18 Jan 2023 17:41:11 -0800 (PST)
Received: from noodle.cs.purdue.edu (switch-lwsn2133-z1r11.cs.purdue.edu. [128.10.127.250])
        by smtp.googlemail.com with ESMTPSA id d27-20020a02605b000000b00374fbd37c72sm10974050jaf.147.2023.01.18.17.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 17:41:11 -0800 (PST)
From:   Sungwoo Kim <iam@sung-woo.kim>
To:     iam@sung-woo.kim
Cc:     benquike@gmail.com, davem@davemloft.net, daveti@purdue.edu,
        edumazet@google.com, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        pabeni@redhat.com, wuruoyu@me.com
Subject: BUG: KASAN: null-ptr-deref in _raw_spin_lock_bh+0x4c/0xc0
Date:   Wed, 18 Jan 2023 20:40:57 -0500
Message-Id: <20230119014057.3879476-1-iam@sung-woo.kim>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230119013405.3870506-1-iam@sung-woo.kim>
References: <20230119013405.3870506-1-iam@sung-woo.kim>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Write of size 4 at addr 0000000000000098 by task kworker/u3:0/76

CPU: 0 PID: 76 Comm: kworker/u3:0 Not tainted 6.1.0-rc2 #129
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
Workqueue: hci0 hci_rx_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x7b/0xb3
 print_report+0xed/0x200
 ? __virt_addr_valid+0x5c/0x240
 ? kasan_addr_to_slab+0xd/0xa0
 ? _raw_spin_lock_bh+0x4c/0xc0
 kasan_report+0xd3/0x100
 ? _raw_spin_lock_bh+0x4c/0xc0
 kasan_check_range+0x2d3/0x310
 __kasan_check_write+0x14/0x20
 _raw_spin_lock_bh+0x4c/0xc0
 lock_sock_nested+0x3f/0x160
 ? queue_work_on+0x90/0xd0
 l2cap_sock_set_shutdown_cb+0x3d/0x60
 l2cap_disconnect_req+0x1e3/0x2e0
 l2cap_bredr_sig_cmd+0x3d2/0x5ec0
 ? vprintk_emit+0x29b/0x4d0
 ? vprintk_default+0x2b/0x30
 ? vprintk+0xdc/0x100
 ? _printk+0x67/0x85
 ? bt_err+0x7f/0xc0
 ? bt_err+0x9a/0xc0
 l2cap_recv_frame+0x7bc/0x4e10
 ? _printk+0x67/0x85
 ? bt_err+0x7f/0xc0
 ? __wake_up_klogd+0xc4/0xf0
 l2cap_recv_acldata+0x327/0x650
 ? hci_conn_enter_active_mode+0x1b7/0x1f0
 hci_rx_work+0x6b7/0x7c0
 process_one_work+0x461/0xaf0
 worker_thread+0x5f8/0xba0
 kthread+0x1c5/0x200
 ? process_one_work+0xaf0/0xaf0
 ? kthread_blkcg+0x90/0x90
 ret_from_fork+0x1f/0x30
 </TASK>
