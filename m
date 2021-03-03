Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE6B932C411
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382110AbhCDAKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:10:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40328 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240221AbhCCK22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 05:28:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614767221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=77uf6dC0svUNR9tlB1KVBLE1LZZ5lgDE+cme98poYho=;
        b=R6YK6fSfVFWj+WQ7ZFZ8B9IfUAgG+LLAKsKW6pg8UalKDAJwIpKOhC1w/weHKYjaZ9A5V9
        O0puhaNz3WUpRW3U0GW3EJ7WwJOJWxGozWxFGF7OjI/5uQdg4u7xkYNX3SKwR2ytbzHsUD
        HVthSxpXJXNn1tqXwAz/7mZD9aRxmuI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-tGVb2QpTNpOIC5Di3rK86A-1; Wed, 03 Mar 2021 05:11:43 -0500
X-MC-Unique: tGVb2QpTNpOIC5Di3rK86A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E4E7107ACE3;
        Wed,  3 Mar 2021 10:11:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 426715B4A7;
        Wed,  3 Mar 2021 10:11:41 +0000 (UTC)
Received: from zmail20.collab.prod.int.phx2.redhat.com (zmail20.collab.prod.int.phx2.redhat.com [10.5.83.23])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id CD7324EEEC;
        Wed,  3 Mar 2021 10:11:40 +0000 (UTC)
Date:   Wed, 3 Mar 2021 05:11:40 -0500 (EST)
From:   Gopal Tiwari <gtiwari@redhat.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzbot+f4fb0eaafdb51c32a153@syzkaller.appspotmail.com
Message-ID: <1576870386.32806253.1614766300531.JavaMail.zimbra@redhat.com>
In-Reply-To: <CACT4Y+b6m7kRS82iRNcmaEPKN8fbvOUmztuGJSw6OketyxM8Kw@mail.gmail.com>
References: <20200808040440.255578-1-yepeilin.cs@gmail.com> <CACT4Y+b6m7kRS82iRNcmaEPKN8fbvOUmztuGJSw6OketyxM8Kw@mail.gmail.com>
Subject: Re: [Linux-kernel-mentees] [PATCH net] Bluetooth: Fix NULL pointer
 dereference in amp_read_loc_assoc_final_data()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.242.156, 10.4.195.27]
Thread-Topic: Bluetooth: Fix NULL pointer dereference in amp_read_loc_assoc_final_data()
Thread-Index: VtEcXu3teRJFxIx5tcgeemHuREdD3g==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, 

I tried to search the patch for one of the bugzilla reported (Internal) https://bugzilla.redhat.com/show_bug.cgi?id=1916057 with the traces 

[  405.938525] Workqueue: hci0 hci_rx_work [bluetooth]
[  405.941360] RIP: 0010:amp_read_loc_assoc_final_data+0xfc/0x1c0 [bluetooth]
[  405.944740] Code: 89 44 24 29 48 b8 00 00 00 00 00 fc ff df 0f b6 04 02 84 c0 74 08 3c 01 0f 8e 9d 00 00 00 0f b7 85 c0 03 00 00 66 89 44 24 2b <f0> 41 80 4c 24 30 04 4c 8d 64 24 68 48 89 ee 4c 89 e7 e8 3d 48 fe
[  405.952396] RSP: 0018:ffff88802ea0f838 EFLAGS: 00010246
[  405.955368] RAX: 0000000000000000 RBX: 1ffff11005d41f08 RCX: dffffc0000000000
[  405.958669] RDX: 1ffff110254cc878 RSI: ffff88802eeee000 RDI: ffff88812a6643c0
[  405.961980] RBP: ffff88812a664000 R08: 0000000000000000 R09: 0000000000000000
[  405.965319] R10: ffff88802ea0fd00 R11: 0000000000000000 R12: 0000000000000000
[  405.968624] R13: 0000000000000041 R14: ffff88802b836800 R15: ffff8881250570c0
[  405.971989] FS:  0000000000000000(0000) GS:ffff888055a00000(0000) knlGS:0000000000000000
[  405.975645] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  405.978755] CR2: 0000000000000030 CR3: 000000002d200000 CR4: 0000000000340ee0
[  405.982150] Call Trace:
[  405.984768]  ? amp_read_loc_assoc+0x170/0x170 [bluetooth]
[  405.987875]  ? rcu_read_unlock+0x50/0x50
[  405.990663]  ? deref_stack_reg+0xf0/0xf0
[  405.993403]  ? __module_address+0x3f/0x370
[  405.996184]  ? hci_cmd_work+0x180/0x330 [bluetooth]
[  405.999170]  ? hci_conn_hash_lookup_handle+0x1a1/0x270 [bluetooth]
[  406.002354]  hci_event_packet+0x1476/0x7e00 [bluetooth]
[  406.005407]  ? arch_stack_walk+0x8f/0xf0
[  406.008206]  ? ret_from_fork+0x27/0x50
[  406.010887]  ? hci_cmd_complete_evt+0xbf70/0xbf70 [bluetooth]
[  406.013933]  ? stack_trace_save+0x8a/0xb0
[  406.016618]  ? do_profile_hits.isra.4.cold.9+0x2d/0x2d
[  406.019483]  ? lock_acquire+0x1a3/0x970
[  406.022092]  ? __wake_up_common_lock+0xaf/0x130


I didn't found any solution upstream. After the vmcore analysis I found what is wrong. And took reference from the following patch, which seems to be on the similar line 

commit 6dfccd13db2ff2b709ef60a50163925d477549aa
    Author: Anmol Karn <anmol.karan123@gmail.com>
    Date:   Wed Sep 30 19:48:13 2020 +0530
    
        Bluetooth: Fix null pointer dereference in hci_event_packet()
    
        AMP_MGR is getting derefernced in hci_phy_link_complete_evt(), when called
        from hci_event_packet() and there is a possibility, that hcon->amp_mgr may
        not be found when accessing after initialization of hcon.
    
        - net/bluetooth/hci_event.c:4945

How we can avoid this scenario. So I made the chages and tested. It worked or avoided the kernel panic. But I really don't know that some one has already posted the patch. I would have love to backport the patch, I was more of looking for the fix. That's where I didn't applied the reported-by tag as I thought it reported internal only. 

Thanks & regards, 
Gopal Tiwari 



----- Original Message -----
From: "Dmitry Vyukov" <dvyukov@google.com>
To: "Peilin Ye" <yepeilin.cs@gmail.com>
Cc: "Marcel Holtmann" <marcel@holtmann.org>, "Johan Hedberg" <johan.hedberg@gmail.com>, "Andrei Emeltchenko" <andrei.emeltchenko@intel.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, "Jakub Kicinski" <kuba@kernel.org>, linux-kernel-mentees@lists.linuxfoundation.org, "syzkaller-bugs" <syzkaller-bugs@googlegroups.com>, "linux-bluetooth" <linux-bluetooth@vger.kernel.org>, "netdev" <netdev@vger.kernel.org>, "LKML" <linux-kernel@vger.kernel.org>, gtiwari@redhat.com, syzbot+f4fb0eaafdb51c32a153@syzkaller.appspotmail.com
Sent: Wednesday, March 3, 2021 1:51:41 PM
Subject: Re: [Linux-kernel-mentees] [PATCH net] Bluetooth: Fix NULL pointer dereference in amp_read_loc_assoc_final_data()

On Sat, Aug 8, 2020 at 6:06 AM Peilin Ye <yepeilin.cs@gmail.com> wrote:
>
> Prevent amp_read_loc_assoc_final_data() from dereferencing `mgr` as NULL.
>
> Reported-and-tested-by: syzbot+f4fb0eaafdb51c32a153@syzkaller.appspotmail.com
> Fixes: 9495b2ee757f ("Bluetooth: AMP: Process Chan Selected event")
> Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> ---
>  net/bluetooth/amp.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/bluetooth/amp.c b/net/bluetooth/amp.c
> index 9c711f0dfae3..be2d469d6369 100644
> --- a/net/bluetooth/amp.c
> +++ b/net/bluetooth/amp.c
> @@ -297,6 +297,9 @@ void amp_read_loc_assoc_final_data(struct hci_dev *hdev,
>         struct hci_request req;
>         int err;
>
> +       if (!mgr)
> +               return;
> +
>         cp.phy_handle = hcon->handle;
>         cp.len_so_far = cpu_to_le16(0);
>         cp.max_len = cpu_to_le16(hdev->amp_assoc_size);

Not sure what happened here, but the merged patch somehow has a
different author and no Reported-by tag:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e8bd76ede155fd54d8c41d045dda43cd3174d506
so let's tell syzbot what fixed it manually:
#syz fix:
Bluetooth: Fix null pointer dereference in amp_read_loc_assoc_final_data

