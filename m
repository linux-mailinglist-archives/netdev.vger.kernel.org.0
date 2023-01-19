Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1FB4673032
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 05:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjASE2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 23:28:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbjASEO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 23:14:57 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E8C6E802
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 20:07:23 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-4a2f8ad29d5so10062667b3.8
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 20:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BCYkKeaP0jpVwQ8PgtIJinHX+eSBvpLg3ojcQ1oF/Ro=;
        b=DQ8xsFbg40VQSpUYSCp3M7adIOAQ/xloUcFt0bsMI4sigJnhUI34j3uZjCctS+O+pS
         /25Kd93wd1zBhM6Sb9A5K3zpHQGuuXV69FQuQLzqc4yXBG2mTQ+FNA1NN/KYQu0us0TE
         RZc/BqjEWINAffVNeikD6R226jU14gi2YJnvah5ATZYA4Izi7GdzHYx/A/bbcv9f0oDO
         ZU5IyZ43EGV/LOYGJuzGmrp4TUKertL4ooY0Uj1m1758hJF1Bf7hhGBLkcsHirH6FbEC
         lMdkxcadtf0Xuy2QJda88eSIpj9UjCIffmc2YT7wZWIebCYL244IwHJYkdWraxVRIrPV
         XcDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BCYkKeaP0jpVwQ8PgtIJinHX+eSBvpLg3ojcQ1oF/Ro=;
        b=XgXOkXxUy+XY6n7UnY7u5mVHrWa3cHqbzo4fotJvjgDQ8gtDoZOVq1vqJK3rxKk2la
         lXRa6onneh5BxKpGKIEchi+KFRVlXXeK2WeH8WQa0B+cI7WMBJJMZTHabQa9Kif1Ed5p
         aKhPUz3P2uoOHWEng2bfNqx+w7xIskl1ZRf0nkFk6+7gUfpKxA0N/B/bQjBautk4Xppg
         byiQfR3NhD/9vpBuDYTC2jeNIOSFSbZcGeRLdjS6/vfnvqaO/8xrJtzyJ0qJipkNakJE
         vwJ4JlDuyGi6dWsPEnQLTAvhlefgkGtdxbZTcRRxW6N9JlgMPO/iR+js7iBYZiOdsFcA
         nZ9Q==
X-Gm-Message-State: AFqh2krTcQahgD7bBU0/4y2GnCpL3Dmw2bTtOHvTUvxpmjesycCEki3t
        fIMC2lRdu3RFwLZTSI4p+doqSt1A9IAFamDLghu9YejM6nwdlt20
X-Google-Smtp-Source: AMrXdXtlMAARAjdaTqQdrEJ4TL1oLq95aXetHxyR87JDNVY7nrguLBt5bMBZAAFS1Ql9Bk4lod6pv+ESowetYzAU5o4=
X-Received: by 2002:a0d:f446:0:b0:4fb:4e3e:e01a with SMTP id
 d67-20020a0df446000000b004fb4e3ee01amr665ywf.55.1674100685096; Wed, 18 Jan
 2023 19:58:05 -0800 (PST)
MIME-Version: 1.0
References: <20230119013405.3870506-1-iam@sung-woo.kim> <20230119014057.3879476-1-iam@sung-woo.kim>
In-Reply-To: <20230119014057.3879476-1-iam@sung-woo.kim>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 19 Jan 2023 04:57:54 +0100
Message-ID: <CANn89iLoaar8Oo8QzmHban=5ju46Q4HqMqAs4WhcW1PZxKRqEg@mail.gmail.com>
Subject: Re: BUG: KASAN: null-ptr-deref in _raw_spin_lock_bh+0x4c/0xc0
To:     Sungwoo Kim <iam@sung-woo.kim>
Cc:     benquike@gmail.com, davem@davemloft.net, daveti@purdue.edu,
        johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        pabeni@redhat.com, wuruoyu@me.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 2:41 AM Sungwoo Kim <iam@sung-woo.kim> wrote:
>
> Write of size 4 at addr 0000000000000098 by task kworker/u3:0/76
>
> CPU: 0 PID: 76 Comm: kworker/u3:0 Not tainted 6.1.0-rc2 #129
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> Workqueue: hci0 hci_rx_work
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x7b/0xb3
>  print_report+0xed/0x200
>  ? __virt_addr_valid+0x5c/0x240
>  ? kasan_addr_to_slab+0xd/0xa0
>  ? _raw_spin_lock_bh+0x4c/0xc0
>  kasan_report+0xd3/0x100
>  ? _raw_spin_lock_bh+0x4c/0xc0
>  kasan_check_range+0x2d3/0x310
>  __kasan_check_write+0x14/0x20
>  _raw_spin_lock_bh+0x4c/0xc0
>  lock_sock_nested+0x3f/0x160
>  ? queue_work_on+0x90/0xd0
>  l2cap_sock_set_shutdown_cb+0x3d/0x60
>  l2cap_disconnect_req+0x1e3/0x2e0
>  l2cap_bredr_sig_cmd+0x3d2/0x5ec0
>  ? vprintk_emit+0x29b/0x4d0
>  ? vprintk_default+0x2b/0x30
>  ? vprintk+0xdc/0x100
>  ? _printk+0x67/0x85
>  ? bt_err+0x7f/0xc0
>  ? bt_err+0x9a/0xc0
>  l2cap_recv_frame+0x7bc/0x4e10
>  ? _printk+0x67/0x85
>  ? bt_err+0x7f/0xc0
>  ? __wake_up_klogd+0xc4/0xf0
>  l2cap_recv_acldata+0x327/0x650
>  ? hci_conn_enter_active_mode+0x1b7/0x1f0
>  hci_rx_work+0x6b7/0x7c0
>  process_one_work+0x461/0xaf0
>  worker_thread+0x5f8/0xba0
>  kthread+0x1c5/0x200
>  ? process_one_work+0xaf0/0xaf0
>  ? kthread_blkcg+0x90/0x90
>  ret_from_fork+0x1f/0x30
>  </TASK>

If you plan sending more stack traces like that in the future, always
run scripts/decode_stacktrace.sh
so that the public report includes symbols.

Thanks.
