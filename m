Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4554E334670
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 19:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbhCJSRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 13:17:02 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:49177 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbhCJSQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 13:16:39 -0500
Received: from maxwell ([93.223.218.186]) by mrelayeu.kundenserver.de
 (mreue109 [213.165.67.113]) with ESMTPSA (Nemesis) id
 1MxUfn-1ldnAI1zzd-00xpS4 for <netdev@vger.kernel.org>; Wed, 10 Mar 2021
 19:16:35 +0100
User-agent: mu4e 1.2.0; emacs 27.1
From:   Henneberg - Systemdesign <lists@henneberg-systemdesign.com>
To:     netdev@vger.kernel.org
Subject: TIOCOUTQ implementation for sockets vs. tty
Date:   Wed, 10 Mar 2021 19:16:34 +0100
Message-ID: <87ft12ri0t.fsf@henneberg-systemdesign.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K1:8S+rHgaJgqUsw0/68YKQ4JAGo9ARiBCDABgPUMGWgr6tgGRZrz0
 uNPew7/lOVSWgWSnJDq7iOACl7i35jLXdnqnzME2kTzDR9GGFhM/wrr3ZCUg7Hh/OXC2Ir7
 4bOEFJRQyN6hZmiaRH+ND9qxhIzUf3mVDYQs+laRGuUOKWcQ3F0JJKk75MaiTIXk1aoCkzU
 PXwntmCS5316mgd80RQXg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:LV9bpZL2T4s=:G5rByNR/Z/tvY+supL0wXZ
 4d4uFBFFHYfw9AWwZuDJiD9p/7aZnwSsoPTugMsUi6tp5z9IM8eohTPz5jgvdVGwwsnGsIw6s
 i0sBfs6F5cZJuTE6SkTAJePXzoLGL5HCJkiESgYQ//ULrOSjIrjy31ogAb1xMeYTo9+r0XN8l
 Zeb6uhsMZI+Wn7LS6Rp784/vW+8XGVlx7nnG9OKSq577Z9MKWUhyMrsqj9RnBOWzf9hM4pTfe
 unKNMopE7GyPgVomM9lfBt8SF10kFE3gPGN/4luNOgOeDAbhh36/LNnkeRysV++eexmVbRqwv
 NAi7eom7gcC4VWJ9LXu4+p/Cgasawz1vMVjM4vXWPXQAnQxp1PErMiklF6gTuBDbO/mUBO47O
 05RTRmmUntfCYPFU8LY/PFIoSVnFcBb1yLHZ5LQnQl6Uv3Bg5roYHQ2tMnF7S1agiav5gMfnc
 frEvsYDD0w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I have a question regarding the implementation of ioctl TIOCOUTQ for
various sockets compared to the tty implementation.

For several sockets, e. g. AF_BLUETOOTH it is done like this

af_bluetooth.c:
case TIOCOUTQ:
	if (sk->sk_state == BT_LISTEN)
		return -EINVAL;

	amount = sk->sk_sndbuf - sk_wmem_alloc_get(sk);
	if (amount < 0)
		amount = 0;
	err = put_user(amount, (int __user *)arg);
	break;

so the ioctl returns the available space in the send queue if I
understand the code correctly (this is also what I observed from tests).

The tty does this:

n_tty.c:
case TIOCOUTQ:
	return put_user(tty_chars_in_buffer(tty), (int __user *) arg);

so it returns the used space in the send queue. This is also what I
would expect from the manpage description.

Is this mismatch intentional?

Regards
-Jochen
