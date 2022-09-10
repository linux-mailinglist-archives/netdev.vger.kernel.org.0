Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D20595B4608
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 13:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiIJLSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 07:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiIJLSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 07:18:37 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49E718364;
        Sat, 10 Sep 2022 04:18:35 -0700 (PDT)
Received: from fsav115.sakura.ne.jp (fsav115.sakura.ne.jp [27.133.134.242])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 28ABINqv016377;
        Sat, 10 Sep 2022 20:18:23 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav115.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav115.sakura.ne.jp);
 Sat, 10 Sep 2022 20:18:23 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav115.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 28ABIM1R016371
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 10 Sep 2022 20:18:23 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <d2d763e3-0dc8-03df-45ba-8d5c4a25acda@I-love.SAKURA.ne.jp>
Date:   Sat, 10 Sep 2022 20:18:22 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [syzbot] WARNING: ODEBUG bug in mgmt_index_removed
Content-Language: en-US
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
References: <000000000000532e0e05e826413c@google.com>
Cc:     syzbot <syzbot+844c7bf1b1aa4119c5de@syzkaller.appspotmail.com>,
        linux-bluetooth@vger.kernel.org, syzkaller-bugs@googlegroups.com
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <000000000000532e0e05e826413c@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I guess that, since hci_pi(sk)->hdev = hdev in hci_sock_bind() does not check whether a hdev
is already associated with some sk, it is possible that multiple sk are bound to the same hdev.
As a result, lock_sock(sk) is not sufficient for serializing access to hdev, and
hci_dev_lock(hdev) is needed when calling mgmt_index_*(hdev) functions.

If my guess above is correct, I think that what syzbot is telling us is that, due to lack of
serialization via hci_dev_lock(hdev), setting of HCI_MGMT flag from mgmt_init_hdev() from
hci_mgmt_cmd() from hci_sock_sendmsg() is racing with testing of HCI_MGMT flag from
mgmt_index_removed() from hci_sock_bind().

I suggest you to explicitly use lockdep_assert_held() in Bluethooth code for clarifying what
locks need to be held, instead of continue using racy operations like hci_dev_test_and_set_flag()
without holding appropriate locks.



hci_unregister_dev() {
  if (!test_bit(HCI_INIT, &hdev->flags) &&
      !hci_dev_test_flag(hdev, HCI_SETUP) &&
      !hci_dev_test_flag(hdev, HCI_CONFIG)) {
    hci_dev_lock(hdev);
    mgmt_index_removed(hdev) {
      if (!hci_dev_test_flag(hdev, HCI_MGMT))
        return;
      cancel_delayed_work_sync(&hdev->discov_off);
    }
    hci_dev_unlock(hdev);
  }
}

hci_sock_sendmsg() {
  lock_sock(sk);
  mutex_lock(&mgmt_chan_list_lock);
  chan = __hci_mgmt_chan_find(hci_pi(sk)->channel);
  if (chan)
    err = hci_mgmt_cmd(chan, sk, skb) {
      if (hdev && chan->hdev_init) // chan->hdev_init == mgmt_init_hdev
        chan->hdev_init(sk, hdev) {
          if (hci_dev_test_and_set_flag(hdev, HCI_MGMT)) // Missing hci_dev_lock(hdev)
            return;
          INIT_DELAYED_WORK(&hdev->discov_off, discov_off);
        }
      err = handler->func(sk, hdev, cp, len) { // handler->func() == set_external_config or set_public_address
        hci_dev_lock(hdev);
        mgmt_index_removed(hdev) {
          if (!hci_dev_test_flag(hdev, HCI_MGMT))
            return;
          cancel_delayed_work_sync(&hdev->discov_off);
        }
        hci_dev_unlock(hdev);
      }
    }
  else
    err = -EINVAL;
  mutex_unlock(&mgmt_chan_list_lock);
  release_sock(sk);
}

hci_sock_bind() {
  lock_sock(sk);
  mgmt_index_removed(hdev) {
    if (!hci_dev_test_flag(hdev, HCI_MGMT)) // Missing hci_dev_lock(hdev)
      return;
    cancel_delayed_work_sync(&hdev->discov_off); // ODEBUG complains missing INIT_DELAYED_WORK()
  }
  release_sock(sk);
}


