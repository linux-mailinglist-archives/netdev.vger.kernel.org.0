Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0613DD4C6
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 13:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbhHBLjL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 2 Aug 2021 07:39:11 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:53380 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbhHBLjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 07:39:10 -0400
Received: from smtpclient.apple (p5b3d23f8.dip0.t-ipconnect.de [91.61.35.248])
        by mail.holtmann.org (Postfix) with ESMTPSA id 74827CED09;
        Mon,  2 Aug 2021 13:38:58 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [syzbot] general protection fault in hci_release_dev
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <92ae9eb0-0a9c-f73a-57f3-20059d9e4c21@i-love.sakura.ne.jp>
Date:   Mon, 2 Aug 2021 13:38:58 +0200
Cc:     Hillf Danton <hdanton@sina.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        BlueZ <linux-bluetooth@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+47c6d0efbb7fe2f7a5b8@syzkaller.appspotmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <F5A39008-A2F6-4DE6-A23F-92ACA1E6CE9C@holtmann.org>
References: <00000000000084201105c88bb48a@google.com>
 <20210802095403.2100-1-hdanton@sina.com>
 <92ae9eb0-0a9c-f73a-57f3-20059d9e4c21@i-love.sakura.ne.jp>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tetsuo,

>> To fix what was addressed in e305509e678b3a4a, defer putting hdev until
>> sock is released with sock locked.
>> 
>> Now only for thoughts.
> 
> Thanks for your analysis.
> 
> hci_alloc_dev() is called from hci_uart_register_dev() from  hci_uart_set_proto()
> from hci_uart_tty_ioctl(HCIUARTSETPROTO) via ld->ops->ioctl() from tty_ioctl(),
> and bt_host_release() is called from device_release() from kobject_put() from
> hci_uart_tty_close() from tty_ldisc_kill() from tty_ldisc_release() from
> tty_release_struct() from tty_release() from __fput().
> 
> The problem is that bt_host_release() is expecting that hci_register_dev()
> was called if "struct hci_dev" was allocated by hci_alloc_dev(). In other
> words, hci_register_dev() might not be called before bt_host_release().
> 
> Then, the fix I think is not to call hci_release_dev() when hci_unregister_dev()
> was not called. That is,
> 
> static void bt_host_release(struct device *dev)
> {
>        struct hci_dev *hdev = to_hci_dev(dev);
> +
> +       if (hci_dev_test_flag(hdev, HCI_UNREGISTER))
> +               hci_release_dev(hdev);
>        kfree(hdev);
>        module_put(THIS_MODULE);
> }
> 
> and remove kfree(hdev) from hci_release_dev(), for HCI_UNREGISTER flag is
> set if hci_unregister_dev() was called before bt_host_release() is called.

actually I am wondering if we should just remove the HCI LDISC support. All the tests
are focusing around the fact that you can create a line discipline as unprivileged
user.

To be honest the HCI LDISC support is not in use anymore for anything deployed after
we got around to establish TTY serdev support.

I am worried that we are trying hard to fix something in the Bluetooth core that
is actually a bug in the hci_uart driver and should be fixed solely there. Or that
driver needs to be deprecated. Are other drivers and their lifetime rules also
exhibiting these issues?

Regards

Marcel

