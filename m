Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76BE06DC6B4
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 14:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjDJMVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 08:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbjDJMVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 08:21:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FA77DA5
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 05:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681129223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Umt18iB2XKnnFXgbP2L+C/UVDq1nN2Vq/rf6uiVIq0E=;
        b=OleIZ/ADHw91ZQ8QGc+w2lGtsluhKy0aYZIs2OsD7Wf96TlsybiNWa4Yj/EiunV6ikJBam
        QTuJIprVJqR7K7t/L+MAA9g/s3xkGKEXHu8uP4LE/e3sjhP65kvifuRSk+A9Z50MhYHPPl
        2KHy94JtkNUfui26kqe+8JoIYdogilk=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-vhQbB_rEOy-mLaWPBVY4MA-1; Mon, 10 Apr 2023 08:20:22 -0400
X-MC-Unique: vhQbB_rEOy-mLaWPBVY4MA-1
Received: by mail-pg1-f199.google.com with SMTP id l69-20020a638848000000b00519e800366eso917254pgd.19
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 05:20:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681129221;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Umt18iB2XKnnFXgbP2L+C/UVDq1nN2Vq/rf6uiVIq0E=;
        b=Vy6Y4wA6bNKNbltUflyf0bWcv6i1f1l0CZ5IfQyi1G35nGfKM2gKi1896A6AYSFBUP
         d2Lu5dcQqzq+nXElL+DkXGoL/2ZTjK/MBws7pEr6aLzpUSAkdeiJiywOkqpxl0l5vy6f
         weRLcJx/QOinF6D+u+Zs5l2NorXpu87RPCIDS9JETVLMeMo7A2UAwNcXVbLE1Tfq/zo0
         yoEhyMF+i5um7Z/ULCpX12BODJfXrRclGwbBLqiLZ13t0Re1zSSc1hU78SwYwl6Kkkky
         Sa1ZfoeNFFgo6kVfJoCquE8UmaAmAguZhi9qd9lHdSuxf/ommU4SsbNn71uexC7WcWVs
         Y40w==
X-Gm-Message-State: AAQBX9ceM4RGKvUL+x5LV+d9Ve4qgRllI+cxs45gdZZLb24FVFp6fpzN
        EEzom3bnevmlBTQ10qAe2bkwfljSw0TBrekiO7j57tTesgDDO+pwHXclSozof40LUteJc/oSlCQ
        C7QpZPElrevwb+Eum
X-Received: by 2002:a17:902:e5c7:b0:1a0:5349:6606 with SMTP id u7-20020a170902e5c700b001a053496606mr15318179plf.56.1681129220256;
        Mon, 10 Apr 2023 05:20:20 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZvuE3bl+L2rz4IDi5N0aXyNjhq+9SiyIPqNv/I8g2EJHKDSC23QMUTyNL1rfi8fJ9KyfIXIQ==
X-Received: by 2002:a17:902:e5c7:b0:1a0:5349:6606 with SMTP id u7-20020a170902e5c700b001a053496606mr15318127plf.56.1681129219694;
        Mon, 10 Apr 2023 05:20:19 -0700 (PDT)
Received: from [10.72.12.131] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id jk1-20020a170903330100b0019ea9e5815bsm7716848plb.45.2023.04.10.05.20.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Apr 2023 05:20:19 -0700 (PDT)
Message-ID: <2834254a-6527-da20-fa1c-d00225246009@redhat.com>
Date:   Mon, 10 Apr 2023 20:20:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v3 45/55] ceph: Use sendmsg(MSG_SPLICE_PAGES) rather than
 sendpage()
To:     David Howells <dhowells@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20230331160914.1608208-1-dhowells@redhat.com>
 <20230331160914.1608208-46-dhowells@redhat.com>
Content-Language: en-US
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230331160914.1608208-46-dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David,

With these patches I can reproduce the hang every time, and I haven't 
gotten a chance to debug it yet, the logs:


<3>[  727.042312] INFO: task kworker/u20:4:78 blocked for more than 245 
seconds.
<3>[  727.042381]       Tainted: G        W 6.3.0-rc3+ #9
<3>[  727.042417] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
<6>[  727.042449] task:kworker/u20:4   state:D stack:0 pid:78    
ppid:2      flags:0x00004000
<6>[  727.042496] Workqueue: writeback wb_workfn (flush-ceph-1)
<6>[  727.042558] Call Trace:
<6>[  727.042576]  <TASK>
<6>[  727.042630]  __schedule+0x4a8/0xa80
<6>[  727.042942]  ? __pfx___schedule+0x10/0x10
<6>[  727.042997]  ? __pfx___lock_release+0x10/0x10
<6>[  727.043118]  ? check_chain_key+0x205/0x2b0
<6>[  727.043299]  schedule+0x8e/0x120
<6>[  727.043372]  schedule_preempt_disabled+0x11/0x20
<6>[  727.043420]  __mutex_lock+0x97b/0x1270
<6>[  727.043532]  ? ceph_con_send+0xa4/0x310 [libceph]
<6>[  727.044348]  ? __pfx___mutex_lock+0x10/0x10
<6>[  727.044410]  ? encode_oloc+0x16e/0x1b0 [libceph]
<6>[  727.045473]  ? ceph_con_send+0xa4/0x310 [libceph]
<6>[  727.046298]  ceph_con_send+0xa4/0x310 [libceph]
<6>[  727.047200]  send_request+0x2b1/0x760 [libceph]
<6>[  727.048122]  ? __pfx___lock_release+0x10/0x10
<6>[  727.048186]  ? __lock_acquired+0x1ef/0x3d0
<6>[  727.048264]  ? __pfx_send_request+0x10/0x10 [libceph]
<6>[  727.049104]  ? check_chain_key+0x205/0x2b0
<6>[  727.049215]  ? link_request+0xcd/0x1a0 [libceph]
<6>[  727.050047]  ? do_raw_spin_unlock+0x99/0x100
<6>[  727.050159]  ? _raw_spin_unlock+0x1f/0x40
<6>[  727.050279]  __submit_request+0x2b7/0x4e0 [libceph]
<6>[  727.051259]  ceph_osdc_start_request+0x31/0x40 [libceph]
<6>[  727.052141]  ceph_writepages_start+0x1d13/0x2490 [ceph]
<6>[  727.053258]  ? __pfx_ceph_writepages_start+0x10/0x10 [ceph]
<6>[  727.053872]  ? validate_chain+0xa1/0x760
<6>[  727.054023]  ? __pfx_validate_chain+0x10/0x10
<6>[  727.054171]  ? check_chain_key+0x205/0x2b0
<6>[  727.054308]  ? __lock_acquire+0x7b3/0xfc0
<6>[  727.054726]  ? reacquire_held_locks+0x18b/0x290
<6>[  727.054790]  ? writeback_sb_inodes+0x263/0x7c0
<6>[  727.054990]  do_writepages+0x106/0x320
<6>[  727.055068]  ? __pfx_do_writepages+0x10/0x10
<6>[  727.055152]  ? __pfx___lock_release+0x10/0x10
<6>[  727.055205]  ? __lock_acquired+0x1ef/0x3d0
<6>[  727.055314]  ? check_chain_key+0x205/0x2b0
<6>[  727.055594]  __writeback_single_inode+0x95/0x450
<6>[  727.055725]  writeback_sb_inodes+0x392/0x7c0
<6>[  727.055912]  ? __pfx_writeback_sb_inodes+0x10/0x10
<6>[  727.055994]  ? __pfx_lock_acquire+0x10/0x10
<6>[  727.056045]  ? do_raw_spin_unlock+0x99/0x100
<6>[  727.056221]  ? __pfx_move_expired_inodes+0x10/0x10
<6>[  727.056541]  __writeback_inodes_wb+0x6a/0x130
<6>[  727.056674]  wb_writeback+0x45b/0x530
<6>[  727.056780]  ? __pfx_wb_writeback+0x10/0x10
<6>[  727.056910]  ? _find_next_bit+0x37/0xc0
<6>[  727.057102]  wb_do_writeback+0x434/0x4f0
<6>[  727.057216]  ? __pfx_wb_do_writeback+0x10/0x10
<6>[  727.057445]  ? __lock_acquire+0x7b3/0xfc0
<6>[  727.057614]  wb_workfn+0xe0/0x400
<6>[  727.057692]  ? __pfx_wb_workfn+0x10/0x10
<6>[  727.057752]  ? lock_acquire+0x15c/0x3e0
<6>[  727.057802]  ? process_one_work+0x436/0x990
<6>[  727.057903]  ? __pfx_lock_acquire+0x10/0x10
<6>[  727.058039]  ? check_chain_key+0x205/0x2b0
<6>[  727.058086]  ? __pfx_try_to_wake_up+0x10/0x10
<6>[  727.058138]  ? mark_held_locks+0x23/0x90
<6>[  727.058306]  process_one_work+0x505/0x990
<6>[  727.058610]  ? __pfx_process_one_work+0x10/0x10
<6>[  727.058731]  ? mark_held_locks+0x23/0x90
<6>[  727.058827]  ? worker_thread+0xce/0x670
<6>[  727.058958]  worker_thread+0x2dd/0x670
<6>[  727.059145]  ? __pfx_worker_thread+0x10/0x10
<6>[  727.059201]  kthread+0x16f/0x1a0
<6>[  727.059252]  ? __pfx_kthread+0x10/0x10
<6>[  727.059341]  ret_from_fork+0x2c/0x50
<6>[  727.059683]  </TASK>
<3>[  727.059964] INFO: task kworker/9:6:8586 blocked for more than 245 
seconds.
<3>[  727.060031]       Tainted: G        W 6.3.0-rc3+ #9
<3>[  727.060086] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
<6>[  727.060140] task:kworker/9:6     state:D stack:0 pid:8586  
ppid:2      flags:0x00004000
<6>[  727.060211] Workqueue: events handle_osds_timeout [libceph]
<6>[  727.060836] Call Trace:
<6>[  727.060892]  <TASK>
<6>[  727.061089]  __schedule+0x4a8/0xa80
<6>[  727.061243]  ? __pfx___schedule+0x10/0x10
<6>[  727.061488]  ? mark_held_locks+0x6b/0x90
<6>[  727.061581]  ? lockdep_hardirqs_on_prepare.part.0+0xea/0x1b0
<6>[  727.061696]  schedule+0x8e/0x120
<6>[  727.061767]  schedule_preempt_disabled+0x11/0x20
<6>[  727.061812]  rwsem_down_write_slowpath+0x2d6/0x840
<6>[  727.061944]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
<6>[  727.062240]  down_write+0x1bf/0x1d0
<6>[  727.062307]  ? __pfx_down_write+0x10/0x10
<6>[  727.062517]  ? check_chain_key+0x205/0x2b0
<6>[  727.062635]  handle_osds_timeout+0x6f/0x1b0 [libceph]
<6>[  727.063487]  process_one_work+0x505/0x990
<6>[  727.063657]  ? __pfx_process_one_work+0x10/0x10
<6>[  727.063789]  ? mark_held_locks+0x23/0x90
<6>[  727.063913]  ? worker_thread+0xce/0x670
<6>[  727.064024]  worker_thread+0x2dd/0x670
<6>[  727.064161]  ? __kthread_parkme+0xc9/0xe0
<6>[  727.064353]  ? __pfx_worker_thread+0x10/0x10
<6>[  727.064411]  kthread+0x16f/0x1a0
<6>[  727.064462]  ? __pfx_kthread+0x10/0x10
<6>[  727.064556]  ret_from_fork+0x2c/0x50
<6>[  727.064816]  </TASK>
<3>[  727.064853] INFO: task kworker/6:6:8587 blocked for more than 245 
seconds.
<3>[  727.064917]       Tainted: G        W 6.3.0-rc3+ #9
<3>[  727.064970] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
<6>[  727.065022] task:kworker/6:6     state:D stack:0 pid:8587  
ppid:2      flags:0x00004000
<6>[  727.065081] Workqueue: events delayed_work [ceph]
<6>[  727.065693] Call Trace:
<6>[  727.065724]  <TASK>
<6>[  727.065833]  __schedule+0x4a8/0xa80
<6>[  727.065932]  ? __pfx___schedule+0x10/0x10
<6>[  727.065983]  ? rwsem_down_read_slowpath+0x294/0x940
<6>[  727.066112]  ? mark_lock.part.0+0xd7/0x6c0
<6>[  727.066292]  ? _raw_spin_unlock_irq+0x24/0x40
<6>[  727.066404]  ? rwsem_down_read_slowpath+0x294/0x940
<6>[  727.066460]  schedule+0x8e/0x120
<6>[  727.066529]  schedule_preempt_disabled+0x11/0x20
<6>[  727.066574]  rwsem_down_read_slowpath+0x486/0x940
<6>[  727.066686]  ? __pfx_rwsem_down_read_slowpath+0x10/0x10
<6>[  727.066885]  ? lock_acquire+0x15c/0x3e0
<6>[  727.066949]  ? find_held_lock+0x8c/0xa0
<6>[  727.066994]  ? kvm_clock_read+0x14/0x30
<6>[  727.067036]  ? kvm_sched_clock_read+0x5/0x20
<6>[  727.067269]  __down_read_common+0xad/0x310
<6>[  727.067344]  ? __pfx___down_read_common+0x10/0x10
<6>[  727.067450]  ? ceph_send_cap_releases+0xbe/0x6a0 [ceph]
<6>[  727.068071]  down_read+0x7a/0x90
<6>[  727.068140]  ceph_send_cap_releases+0xbe/0x6a0 [ceph]
<6>[  727.068869]  ? mark_held_locks+0x6b/0x90
<6>[  727.068990]  ? __pfx_ceph_send_cap_releases+0x10/0x10 [ceph]
<6>[  727.069733]  delayed_work+0x30b/0x310 [ceph]
<6>[  727.070445]  process_one_work+0x505/0x990
<6>[  727.070625]  ? __pfx_process_one_work+0x10/0x10
<6>[  727.070769]  ? mark_held_locks+0x23/0x90
<6>[  727.070838]  ? worker_thread+0xce/0x670
<6>[  727.070916]  worker_thread+0x2dd/0x670
<6>[  727.071016]  ? __kthread_parkme+0xc9/0xe0
<6>[  727.071076]  ? __pfx_worker_thread+0x10/0x10
<6>[  727.071115]  kthread+0x16f/0x1a0
<6>[  727.071150]  ? __pfx_kthread+0x10/0x10
<6>[  727.071368]  ret_from_fork+0x2c/0x50
<6>[  727.071532]  </TASK>
<3>[  727.071593] INFO: task kworker/9:18:9987 blocked for more than 245 
seconds.
<3>[  727.071642]       Tainted: G        W 6.3.0-rc3+ #9
<3>[  727.071711] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
<6>[  727.071750] task:kworker/9:18    state:D stack:0 pid:9987  
ppid:2      flags:0x00004000
<6>[  727.071797] Workqueue: events handle_timeout [libceph]
<6>[  727.072375] Call Trace:
<6>[  727.072397]  <TASK>
<6>[  727.072457]  __schedule+0x4a8/0xa80
<6>[  727.072536]  ? __pfx___schedule+0x10/0x10
<6>[  727.072659]  ? mark_lock.part.0+0xd7/0x6c0
<6>[  727.072711]  ? _raw_spin_unlock_irq+0x24/0x40
<6>[  727.072790]  schedule+0x8e/0x120
<6>[  727.072839]  schedule_preempt_disabled+0x11/0x20
<6>[  727.072871]  rwsem_down_write_slowpath+0x2d6/0x840
<6>[  727.072945]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
<6>[  727.073161]  down_write+0x1bf/0x1d0
<6>[  727.073424]  ? __pfx_down_write+0x10/0x10
<6>[  727.073551]  handle_timeout+0x12a/0x6f0 [libceph]
<6>[  727.074072]  ? __pfx_lock_acquire+0x10/0x10
<6>[  727.074188]  ? __pfx_handle_timeout+0x10/0x10 [libceph]
<6>[  727.075342]  process_one_work+0x505/0x990
<6>[  727.075473]  ? __pfx_process_one_work+0x10/0x10
<6>[  727.075558]  ? mark_held_locks+0x23/0x90
<6>[  727.075655]  ? worker_thread+0xce/0x670
<6>[  727.075716]  worker_thread+0x2dd/0x670
<6>[  727.075820]  ? __kthread_parkme+0xc9/0xe0
<6>[  727.075865]  ? __pfx_worker_thread+0x10/0x10
<6>[  727.075895]  kthread+0x16f/0x1a0
<6>[  727.075923]  ? __pfx_kthread+0x10/0x10
<6>[  727.076036]  ret_from_fork+0x2c/0x50
<6>[  727.076169]  </TASK>
<3>[  727.076201] INFO: task ffsb:13945 blocked for more than 245 seconds.
<3>[  727.076239]       Tainted: G        W 6.3.0-rc3+ #9
<3>[  727.076272] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
<6>[  727.076302] task:ffsb            state:D stack:0 pid:13945 
ppid:10657  flags:0x00000002
<6>[  727.076340] Call Trace:
<6>[  727.076357]  <TASK>
<6>[  727.076400]  __schedule+0x4a8/0xa80
<6>[  727.076459]  ? __pfx___schedule+0x10/0x10
<6>[  727.076489]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
<6>[  727.076629]  ? rwsem_down_read_slowpath+0x294/0x940
<6>[  727.076663]  schedule+0x8e/0x120
<6>[  727.076701]  schedule_preempt_disabled+0x11/0x20
<6>[  727.076726]  rwsem_down_read_slowpath+0x486/0x940
<6>[  727.076789]  ? __pfx_rwsem_down_read_slowpath+0x10/0x10
<6>[  727.076887]  ? lock_acquire+0x15c/0x3e0
<6>[  727.076921]  ? find_held_lock+0x8c/0xa0
<6>[  727.077014]  ? kvm_clock_read+0x14/0x30
<6>[  727.077047]  ? kvm_sched_clock_read+0x5/0x20
<6>[  727.077110]  __down_read_common+0xad/0x310
<6>[  727.077147]  ? __pfx___down_read_common+0x10/0x10
<6>[  727.077182]  ? __pfx_generic_write_checks+0x10/0x10
<6>[  727.077231]  ? ceph_write_iter+0x33c/0xad0 [ceph]
<6>[  727.077557]  down_read+0x7a/0x90
<6>[  727.077596]  ceph_write_iter+0x33c/0xad0 [ceph]
<6>[  727.078041]  ? __pfx_ceph_write_iter+0x10/0x10 [ceph]
<6>[  727.078324]  ? __pfx_lock_acquire+0x10/0x10
<6>[  727.078358]  ? __might_resched+0x213/0x300
<6>[  727.078413]  ? inode_security+0x6d/0x90
<6>[  727.078454]  ? selinux_file_permission+0x1d5/0x210
<6>[  727.078558]  vfs_write+0x567/0x750
<6>[  727.078608]  ? __pfx_vfs_write+0x10/0x10
<6>[  727.078786]  ksys_write+0xc9/0x170
<6>[  727.078824]  ? __pfx_ksys_write+0x10/0x10
<6>[  727.078857]  ? ktime_get_coarse_real_ts64+0x100/0x110
<6>[  727.078883]  ? ktime_get_coarse_real_ts64+0xa4/0x110
<6>[  727.079029]  do_syscall_64+0x5c/0x90
<6>[  727.079071]  ? do_syscall_64+0x69/0x90
<6>[  727.079105]  ? lockdep_hardirqs_on_prepare.part.0+0xea/0x1b0
<6>[  727.079151]  ? do_syscall_64+0x69/0x90
<6>[  727.079184]  ? lockdep_hardirqs_on_prepare.part.0+0xea/0x1b0
<6>[  727.079234]  ? do_syscall_64+0x69/0x90
<6>[  727.079257]  ? lockdep_hardirqs_on_prepare.part.0+0xea/0x1b0
<6>[  727.079303]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
<6>[  727.079336] RIP: 0033:0x7fa52913ebcf
<6>[  727.079361] RSP: 002b:00007fa522dfba30 EFLAGS: 00000293 ORIG_RAX: 
0000000000000001
<6>[  727.079396] RAX: ffffffffffffffda RBX: 0000000000001000 RCX: 
00007fa52913ebcf
<6>[  727.079418] RDX: 0000000000001000 RSI: 00007fa51c001450 RDI: 
0000000000000004
<6>[  727.079438] RBP: 0000000000000004 R08: 0000000000000000 R09: 
0000000001cc3580
<6>[  727.079456] R10: 00000000000001c0 R11: 0000000000000293 R12: 
0000000000000000
<6>[  727.079474] R13: 0000000001cc3580 R14: 0000000000001000 R15: 
00007fa51c001450
<6>[  727.079614]  </TASK>
<6>[  727.079633] Future hung task reports are suppressed, see sysctl 
kernel.hung_task_warnings
<4>[  727.079652]
<4>[  727.079652] Showing all locks held in the system:
<4>[  727.079671] 1 lock held by rcu_tasks_kthre/12:
<4>[  727.079691]  #0: ffffffff8bf1fc80 
(rcu_tasks.tasks_gp_mutex){+.+.}-{4:4}, at: rcu_tasks_one_gp+0x32/0x280
<4>[  727.079788] 1 lock held by rcu_tasks_rude_/13:
<4>[  727.079805]  #0: ffffffff8bf1f9a0 
(rcu_tasks_rude.tasks_gp_mutex){+.+.}-{4:4}, at: rcu_tasks_one_gp+0x32/0x280
<4>[  727.079896] 1 lock held by rcu_tasks_trace/14:
<4>[  727.079976]  #0: ffffffff8bf1f660 
(rcu_tasks_trace.tasks_gp_mutex){+.+.}-{4:4}, at: 
rcu_tasks_one_gp+0x32/0x280
<4>[  727.080085] 6 locks held by kworker/u20:4/78:
<4>[  727.080105]  #0: ffff8884644d3148 
((wq_completion)writeback){+.+.}-{0:0}, at: process_one_work+0x436/0x990
<4>[  727.080192]  #1: ffff888101027de8 
((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: 
process_one_work+0x436/0x990
<4>[  727.080282]  #2: ffff8881022740e8 
(&type->s_umount_key#62){.+.+}-{4:4}, at: trylock_super+0x16/0x70
<4>[  727.080385]  #3: ffff88811e378d70 (&osdc->lock){++++}-{4:4}, at: 
ceph_osdc_start_request+0x17/0x40 [libceph]
<4>[  727.080760]  #4: ffff88810c116980 (&osd->lock){+.+.}-{4:4}, at: 
__submit_request+0xfa/0x4e0 [libceph]
<4>[  727.081139]  #5: ffff88810c116178 (&con->mutex){+.+.}-{4:4}, at: 
ceph_con_send+0xa4/0x310 [libceph]
<4>[  727.081458] 3 locks held by kworker/3:1/90:
<4>[  727.081517]  #0: ffff888130cced48 
((wq_completion)ceph-msgr){+.+.}-{0:0}, at: process_one_work+0x436/0x990
<4>[  727.081593]  #1: ffff888101117de8 
((work_completion)(&(&con->work)->work)){+.+.}-{0:0}, at: 
process_one_work+0x436/0x990
<4>[  727.081668]  #2: ffff88810c116178 (&con->mutex){+.+.}-{4:4}, at: 
ceph_con_workfn+0x3c/0x5c0 [libceph]
<4>[  727.082041] 1 lock held by khungtaskd/96:
<4>[  727.082057]  #0: ffffffff8bf20840 (rcu_read_lock){....}-{1:3}, at: 
debug_show_all_locks+0x29/0x230
<4>[  727.082149] 1 lock held by systemd-journal/687:
<4>[  727.082179] 5 locks held by in:imjournal/882:
<4>[  727.082270] 1 lock held by sshd/3493:
<4>[  727.082320] 3 locks held by kworker/3:6/8369:
<4>[  727.082337]  #0: ffff888130cced48 
((wq_completion)ceph-msgr){+.+.}-{0:0}, at: process_one_work+0x436/0x990
<4>[  727.082413]  #1: ffff8881105cfde8 
((work_completion)(&(&con->work)->work)){+.+.}-{0:0}, at: 
process_one_work+0x436/0x990
<4>[  727.082502]  #2: ffff8881803ce098 (&s->s_mutex){+.+.}-{4:4}, at: 
send_mds_reconnect+0x13e/0x7c0 [ceph]
<4>[  727.082791] 3 locks held by kworker/9:6/8586:
<4>[  727.082807]  #0: ffff888100063548 
((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x436/0x990
<4>[  727.082927]  #1: ffff88812a767de8 
((work_completion)(&(&osdc->osds_timeout_work)->work)){+.+.}-{0:0}, at: 
process_one_work+0x436/0x990
<4>[  727.083002]  #2: ffff88811e378d70 (&osdc->lock){++++}-{4:4}, at: 
handle_osds_timeout+0x6f/0x1b0 [libceph]
<4>[  727.083336] 4 locks held by kworker/6:6/8587:
<4>[  727.083352]  #0: ffff888100063548 
((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x436/0x990
<4>[  727.083424]  #1: ffff8881248a7de8 
((work_completion)(&(&mdsc->delayed_work)->work)){+.+.}-{0:0}, at: 
process_one_work+0x436/0x990
<4>[  727.083509]  #2: ffff8881803ce098 (&s->s_mutex){+.+.}-{4:4}, at: 
delayed_work+0x1d8/0x310 [ceph]
<4>[  727.083794]  #3: ffff88811e378d70 (&osdc->lock){++++}-{4:4}, at: 
ceph_send_cap_releases+0xbe/0x6a0 [ceph]
<4>[  727.084151] 3 locks held by kworker/8:16/8663:
<4>[  727.084170]  #0: ffff888130cced48 
((wq_completion)ceph-msgr){+.+.}-{0:0}, at: process_one_work+0x436/0x990
<4>[  727.084245]  #1: ffff88810aac7de8 
((work_completion)(&(&con->work)->work)){+.+.}-{0:0}, at: 
process_one_work+0x436/0x990
<4>[  727.084316]  #2: ffff888464998178 (&con->mutex){+.+.}-{4:4}, at: 
ceph_con_workfn+0x3c/0x5c0 [libceph]
<4>[  727.084684] 3 locks held by kworker/9:18/9987:
<4>[  727.084701]  #0: ffff888100063548 
((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x436/0x990
<4>[  727.084776]  #1: ffff888112b17de8 
((work_completion)(&(&osdc->timeout_work)->work)){+.+.}-{0:0}, at: 
process_one_work+0x436/0x990
<4>[  727.084938]  #2: ffff88811e378d70 (&osdc->lock){++++}-{4:4}, at: 
handle_timeout+0x12a/0x6f0 [libceph]
<4>[  727.085274] 2 locks held by less/11897:
<4>[  727.085291]  #0: ffff8881138800a0 (&tty->ldisc_sem){++++}-{0:0}, 
at: tty_ldisc_ref_wait+0x24/0x70
<4>[  727.085370]  #1: ffffc900019122f8 
(&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x849/0xa70
<4>[  727.085469] 3 locks held by cat/13283:
<4>[  727.085484] 4 locks held by ffsb/13945:
<4>[  727.085497]  #0: ffff88812b95ba78 (&f->f_pos_lock){+.+.}-{4:4}, 
at: __fdget_pos+0x75/0x80
<4>[  727.085558]  #1: ffff888102274480 (sb_writers#12){.+.+}-{0:0}, at: 
ksys_write+0xc9/0x170
<4>[  727.085654]  #2: ffff88812aeca1b8 
(&sb->s_type->i_mutex_key#15){++++}-{4:4}, at: 
ceph_start_io_write+0x15/0x30 [ceph]
<4>[  727.085963]  #3: ffff88811e378d70 (&osdc->lock){++++}-{4:4}, at: 
ceph_write_iter+0x33c/0xad0 [ceph]
<4>[  727.086198] 5 locks held by kworker/3:0/13962:
<4>[  727.086213]

Thanks

- Xiubo


On 4/1/23 00:09, David Howells wrote:
> Use sendmsg() and MSG_SPLICE_PAGES rather than sendpage in ceph when
> transmitting data.  For the moment, this can only transmit one page at a
> time because of the architecture of net/ceph/, but if
> write_partial_message_data() can be given a bvec[] at a time by the
> iteration code, this would allow pages to be sent in a batch.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Ilya Dryomov <idryomov@gmail.com>
> cc: Xiubo Li <xiubli@redhat.com>
> cc: Jeff Layton <jlayton@kernel.org>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Eric Dumazet <edumazet@google.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: ceph-devel@vger.kernel.org
> cc: netdev@vger.kernel.org
> ---
>   net/ceph/messenger_v2.c | 89 +++++++++--------------------------------
>   1 file changed, 18 insertions(+), 71 deletions(-)
>
> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> index 301a991dc6a6..1637a0c21126 100644
> --- a/net/ceph/messenger_v2.c
> +++ b/net/ceph/messenger_v2.c
> @@ -117,91 +117,38 @@ static int ceph_tcp_recv(struct ceph_connection *con)
>   	return ret;
>   }
>   
> -static int do_sendmsg(struct socket *sock, struct iov_iter *it)
> -{
> -	struct msghdr msg = { .msg_flags = CEPH_MSG_FLAGS };
> -	int ret;
> -
> -	msg.msg_iter = *it;
> -	while (iov_iter_count(it)) {
> -		ret = sock_sendmsg(sock, &msg);
> -		if (ret <= 0) {
> -			if (ret == -EAGAIN)
> -				ret = 0;
> -			return ret;
> -		}
> -
> -		iov_iter_advance(it, ret);
> -	}
> -
> -	WARN_ON(msg_data_left(&msg));
> -	return 1;
> -}
> -
> -static int do_try_sendpage(struct socket *sock, struct iov_iter *it)
> -{
> -	struct msghdr msg = { .msg_flags = CEPH_MSG_FLAGS };
> -	struct bio_vec bv;
> -	int ret;
> -
> -	if (WARN_ON(!iov_iter_is_bvec(it)))
> -		return -EINVAL;
> -
> -	while (iov_iter_count(it)) {
> -		/* iov_iter_iovec() for ITER_BVEC */
> -		bvec_set_page(&bv, it->bvec->bv_page,
> -			      min(iov_iter_count(it),
> -				  it->bvec->bv_len - it->iov_offset),
> -			      it->bvec->bv_offset + it->iov_offset);
> -
> -		/*
> -		 * sendpage cannot properly handle pages with
> -		 * page_count == 0, we need to fall back to sendmsg if
> -		 * that's the case.
> -		 *
> -		 * Same goes for slab pages: skb_can_coalesce() allows
> -		 * coalescing neighboring slab objects into a single frag
> -		 * which triggers one of hardened usercopy checks.
> -		 */
> -		if (sendpage_ok(bv.bv_page)) {
> -			ret = sock->ops->sendpage(sock, bv.bv_page,
> -						  bv.bv_offset, bv.bv_len,
> -						  CEPH_MSG_FLAGS);
> -		} else {
> -			iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bv, 1, bv.bv_len);
> -			ret = sock_sendmsg(sock, &msg);
> -		}
> -		if (ret <= 0) {
> -			if (ret == -EAGAIN)
> -				ret = 0;
> -			return ret;
> -		}
> -
> -		iov_iter_advance(it, ret);
> -	}
> -
> -	return 1;
> -}
> -
>   /*
>    * Write as much as possible.  The socket is expected to be corked,
>    * so we don't bother with MSG_MORE/MSG_SENDPAGE_NOTLAST here.
>    *
>    * Return:
> - *   1 - done, nothing (else) to write
> + *  >0 - done, nothing (else) to write
>    *   0 - socket is full, need to wait
>    *  <0 - error
>    */
>   static int ceph_tcp_send(struct ceph_connection *con)
>   {
> +	struct msghdr msg = {
> +		.msg_iter	= con->v2.out_iter,
> +		.msg_flags	= CEPH_MSG_FLAGS,
> +	};
>   	int ret;
>   
> +	if (WARN_ON(!iov_iter_is_bvec(&con->v2.out_iter)))
> +		return -EINVAL;
> +
> +	if (con->v2.out_iter_sendpage)
> +		msg.msg_flags |= MSG_SPLICE_PAGES;
> +
>   	dout("%s con %p have %zu try_sendpage %d\n", __func__, con,
>   	     iov_iter_count(&con->v2.out_iter), con->v2.out_iter_sendpage);
> -	if (con->v2.out_iter_sendpage)
> -		ret = do_try_sendpage(con->sock, &con->v2.out_iter);
> -	else
> -		ret = do_sendmsg(con->sock, &con->v2.out_iter);
> +
> +	ret = sock_sendmsg(con->sock, &msg);
> +	if (ret > 0)
> +		iov_iter_advance(&con->v2.out_iter, ret);
> +	else if (ret == -EAGAIN)
> +		ret = 0;
> +
>   	dout("%s con %p ret %d left %zu\n", __func__, con, ret,
>   	     iov_iter_count(&con->v2.out_iter));
>   	return ret;
>

