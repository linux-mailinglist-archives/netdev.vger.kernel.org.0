Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292DF416E23
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 10:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244771AbhIXIqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 04:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244324AbhIXIqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 04:46:06 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF5CC061574;
        Fri, 24 Sep 2021 01:44:33 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id m70so4197318ybm.5;
        Fri, 24 Sep 2021 01:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=TQ2y+MNEKFl1FfzcJujHyxozgri5qKCx4YByzp7xgiU=;
        b=J7wtD/+k7DAMfaOmbXAuU0BEpoNvqkEm09fpsEVlcFqZi8mmBxiPiYdv0+gV1I8z0O
         I8tb8NTzqQ19LrE2e/YpZaMa4aDUM2YXqGDJXo8bkqcrqitWYu1jdVrHDsZqTW1mUMsY
         wEv3IY31ig22u7K5WvRlQj+cHSbL6kiyzvcQ/kT+DHqJ+3m/3hb6zwGUhdp/Xd/pCAm1
         VwH9ldW5qjtpwTZjOAYsF5KR6JU0EJSJOwfoXxNyqPzSfFGBrZbT2/84w8RgtFy7qz8h
         M1avQb1W7fRSNK0in0adyJzmaGLFcltn6X5w8aLlz3Dz2y8kOg3pPzMJwq8sE9FfYjcA
         qFUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=TQ2y+MNEKFl1FfzcJujHyxozgri5qKCx4YByzp7xgiU=;
        b=m8flpcZQYs7Mj19mogUF3bMjeYTu3WOOvCxc/Ycge1jd9UrqPRRr5IIwO0L/ysAEQv
         n6aA0AKty3yc9kdOhKJjQkSdheeh+mW7nbucE4ZAS3j+yQUcURSqf9l6s7p6qiCDvFgw
         0d8QVmMlwlLo9w6pIjNO9b5k4B6TMwO7eDxBXLoTJ8JCNR2PyOVnVoLbHTh6yGiAxxRW
         vtzoy3PXU+AUdH9X+97UoVqP0ESUrupPDydOzsPCH762H+4B3wq1uNKNm8TK3tOw2S0k
         HOPdEqgOugIl+TzOyYIpfw/Zu1Cwi5y0Pyd5OURc4WVtC8IZu8OKL2nb0r57wcFaepg9
         7ZrQ==
X-Gm-Message-State: AOAM533jiF6BOaNbdi7c2K+sTcsFtE+T5pGA1bMlG2r9OV3VrgGRH6u9
        r1HMBLjE7tqPxwBQVNCIndnUPjQUDd/4i0hZzkUSJmMeY+z0JA==
X-Google-Smtp-Source: ABdhPJxnNobNwdgAEJIIVk25wkubAzkCRAPFhMMbUONe3QvvUv0etUigMY/MQMCZ5wE7Ln/k1ZP67yRD94g7+jf35T0=
X-Received: by 2002:a25:eb0b:: with SMTP id d11mr10315661ybs.101.1632473072846;
 Fri, 24 Sep 2021 01:44:32 -0700 (PDT)
MIME-Version: 1.0
From:   butt3rflyh4ck <butterflyhuangxx@gmail.com>
Date:   Fri, 24 Sep 2021 16:44:21 +0800
Message-ID: <CAFcO6XOvGQrRTaTkaJ0p3zR7y7nrAWD79r48=L_BbOyrK9X-vA@mail.gmail.com>
Subject: There is an array-index-out-bounds bug in detach_capi_ctr in drivers/isdn/capi/kcapi.c
To:     isdn@linux-pingi.de, arnd@arndb.de,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, there is an array-index-out-bounds bug in detach_capi_ctr in
drivers/isdn/capi/kcapi.c and I reproduce it on 5.15.0-rc2+.

###Analyze
 we can call CMTPCONNADD ioctl and it would invoke
do_cmtp_sock_ioctl(), it would call cmtp_add_connection().
the chain of call is as follows.
ioctl(CMTPCONNADD)
   ->cmtp_sock_ioctl()
         -->do_cmtp_sock_ioctl()
            --->cmtp_add_connection()
                ---->kthread_run()
                ---->cmtp_attach_device()
the function would add a cmtp session to a controller. Let us see the code.
```
int cmtp_add_connection(struct cmtp_connadd_req *req, struct socket *sock)
{
u32 valid_flags = BIT(CMTP_LOOPBACK);
struct cmtp_session *session, *s;
int i, err;

BT_DBG("");

if (!l2cap_is_socket(sock))
return -EBADFD;

if (req->flags & ~valid_flags)
return -EINVAL;

session = kzalloc(sizeof(struct cmtp_session), GFP_KERNEL);   ///
alloc and clear struct cmtp_session 'session' by kzalloc().
if (!session)
return -ENOMEM;

[...]

session->task = kthread_run(cmtp_session, session,
"kcmtpd_ctr_%d",session->num); ///  create and run a kernel thread
invoke cmtp_session() and the args is 'session'

[...]

if (!(session->flags & BIT(CMTP_LOOPBACK))) {
err = cmtp_attach_device(session);   ///   invoke cmtp_attach_device()
to attach a session with a controller.
if (err < 0) {
/* Caller will call fput in case of failure, and so
* will cmtp_session kthread.
*/
get_file(session->sock->file);

atomic_inc(&session->terminate);
wake_up_interruptible(sk_sleep(session->sock->sk));
up_write(&cmtp_session_sem);
return err;
}
}
[...]

```
the struct cmtp_session have a member named struct capi_ctr 'ctrl'.
struct capi_ctr have a member named 'cnr', it is controller number.

the kernel thread would invoke cmtp_session(), it would call
cmtp_detach_device() to detach a session and the registration of a
controller.
cmtp_session()
     ->cmtp_detach_device()
          ->detach_capi_ctr()
let us see detach_capi_ctr() function implement.
```
int detach_capi_ctr(struct capi_ctr *ctr)
{
int err = 0;

mutex_lock(&capi_controller_lock);

ctr_down(ctr, CAPI_CTR_DETACHED);

if (capi_controller[ctr->cnr - 1] != ctr) {   /// use
cmtp_session->capi_ctr->cnr
err = -EINVAL;
goto unlock_out;
}
capi_controller[ctr->cnr - 1] = NULL;
ncontrollers--;

[...]

```
If the cmtp_add_connection() call cmtp_attach_device() not yet, the
cmtp_session->capi_ctr->cnr just is an ZERO.

The capi_controller[-1] make no sense. so should check that the
cmtp_session->capi_ctr->cnr is not an ZERO.


###Crash
root@syzkaller:/home/user# ./detach_capi_ctr
[   41.829295][    C1] random: crng init done
[   41.829769][    C1] random: 7 urandom warning(s) missed due to ratelimiting
[   43.904027][ T2627] Bluetooth: hci0: command 0x0409 tx timeout
[   45.984105][ T2911] Bluetooth: hci0: command 0x041b tx timeout
[   46.863815][ T6447] Bluetooth: Found 0 CAPI controller(s) on device
10:aa:aa:aa:aa:aa
[   46.864775][ T6479]
================================================================================
[   46.866069][ T6479] UBSAN: array-index-out-of-bounds in
drivers/isdn/capi/kcapi.c:483:21
[   46.867196][ T6479] index -1 is out of range for type 'capi_ctr *[32]'
[   46.867982][ T6479] CPU: 1 PID: 6479 Comm: kcmtpd_ctr_0 Not tainted
5.15.0-rc2+ #8
[   46.869002][ T6479] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.14.0-2 04/01/2014
[   46.870107][ T6479] Call Trace:
[   46.870473][ T6479]  dump_stack_lvl+0x57/0x7d
[   46.870974][ T6479]  ubsan_epilogue+0x5/0x40
[   46.871458][ T6479]  __ubsan_handle_out_of_bounds.cold+0x43/0x48
[   46.872135][ T6479]  detach_capi_ctr+0x64/0xc0
[   46.872639][ T6479]  cmtp_session+0x5c8/0x5d0
[   46.873131][ T6479]  ? __init_waitqueue_head+0x60/0x60
[   46.873712][ T6479]  ? cmtp_add_msgpart+0x120/0x120
[   46.874256][ T6479]  kthread+0x147/0x170
[   46.874709][ T6479]  ? set_kthread_struct+0x40/0x40
[   46.875248][ T6479]  ret_from_fork+0x1f/0x30
[   46.875773][ T6479]
================================================================================
[   46.876799][ T6479] Kernel panic - not syncing: panic_on_warn set ...
[   46.877541][ T6479] CPU: 1 PID: 6479 Comm: kcmtpd_ctr_0 Not tainted
5.15.0-rc2+ #8
[   46.878384][ T6479] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.14.0-2 04/01/2014
[   46.879377][ T6479] Call Trace:
[   46.879742][ T6479]  dump_stack_lvl+0x57/0x7d
[   46.880251][ T6479]  panic+0x139/0x302
[   46.880699][ T6479]  ubsan_epilogue+0x3f/0x40
[   46.881199][ T6479]  __ubsan_handle_out_of_bounds.cold+0x43/0x48
[   46.881890][ T6479]  detach_capi_ctr+0x64/0xc0
[   46.882389][ T6479]  cmtp_session+0x5c8/0x5d0
[   46.882881][ T6479]  ? __init_waitqueue_head+0x60/0x60
[   46.883448][ T6479]  ? cmtp_add_msgpart+0x120/0x120
[   46.883989][ T6479]  kthread+0x147/0x170
[   46.884435][ T6479]  ? set_kthread_struct+0x40/0x40
[   46.884989][ T6479]  ret_from_fork+0x1f/0x30
[   46.885561][ T6479] Kernel Offset: disabled
[   46.886043][ T6479] Rebooting in 86400 seconds..

###Patch
Should check the cmtp_session->capi_ctr->cnr is not an ZERO.

```
diff --git a/drivers/isdn/capi/kcapi.c b/drivers/isdn/capi/kcapi.c
index cb0afe897162..38502a955f13 100644
--- a/drivers/isdn/capi/kcapi.c
+++ b/drivers/isdn/capi/kcapi.c
@@ -480,7 +480,7 @@ int detach_capi_ctr(struct capi_ctr *ctr)

        ctr_down(ctr, CAPI_CTR_DETACHED);

-       if (capi_controller[ctr->cnr - 1] != ctr) {
+       if (!ctr->cnr || capi_controller[ctr->cnr - 1] != ctr) {
                err = -EINVAL;
                goto unlock_out;
        }
```


Regards,
  butt3rflyh4ck.

-- 
Active Defense Lab of Venustech
