Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A8A3DD472
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 13:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233382AbhHBLCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 07:02:44 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:57764 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233317AbhHBLCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 07:02:41 -0400
Received: from fsav414.sakura.ne.jp (fsav414.sakura.ne.jp [133.242.250.113])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 172B2TPU024015;
        Mon, 2 Aug 2021 20:02:29 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav414.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav414.sakura.ne.jp);
 Mon, 02 Aug 2021 20:02:29 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav414.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 172B2SKW024012
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 2 Aug 2021 20:02:28 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [syzbot] general protection fault in hci_release_dev
To:     Hillf Danton <hdanton@sina.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     johan.hedberg@gmail.com, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.von.dentz@intel.com,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+47c6d0efbb7fe2f7a5b8@syzkaller.appspotmail.com>
References: <00000000000084201105c88bb48a@google.com>
 <20210802095403.2100-1-hdanton@sina.com>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <92ae9eb0-0a9c-f73a-57f3-20059d9e4c21@i-love.sakura.ne.jp>
Date:   Mon, 2 Aug 2021 20:02:24 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210802095403.2100-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 2021/08/02 18:54, Hillf Danton wrote:
> To fix what was addressed in e305509e678b3a4a, defer putting hdev until
> sock is released with sock locked.
> 
> Now only for thoughts.

Thanks for your analysis.

hci_alloc_dev() is called from hci_uart_register_dev() from  hci_uart_set_proto()
 from hci_uart_tty_ioctl(HCIUARTSETPROTO) via ld->ops->ioctl() from tty_ioctl(),
and bt_host_release() is called from device_release() from kobject_put() from
hci_uart_tty_close() from tty_ldisc_kill() from tty_ldisc_release() from
tty_release_struct() from tty_release() from __fput().

The problem is that bt_host_release() is expecting that hci_register_dev()
was called if "struct hci_dev" was allocated by hci_alloc_dev(). In other
words, hci_register_dev() might not be called before bt_host_release().

Then, the fix I think is not to call hci_release_dev() when hci_unregister_dev()
was not called. That is,

 static void bt_host_release(struct device *dev)
 {
        struct hci_dev *hdev = to_hci_dev(dev);
+
+       if (hci_dev_test_flag(hdev, HCI_UNREGISTER))
+               hci_release_dev(hdev);
        kfree(hdev);
        module_put(THIS_MODULE);
 }

and remove kfree(hdev) from hci_release_dev(), for HCI_UNREGISTER flag is
set if hci_unregister_dev() was called before bt_host_release() is called.
