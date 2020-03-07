Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF49817CE8E
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 14:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgCGN6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 08:58:15 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46935 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbgCGN6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 08:58:15 -0500
Received: by mail-pl1-f194.google.com with SMTP id w12so2055534pll.13;
        Sat, 07 Mar 2020 05:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YttYJY2hEu0o9ieZzIqW+Sf4nL0+gX4KSVXdg9N5DNU=;
        b=Zo5SiZ1APLQC++VQvG/MZYrhXfyqAhqKEHXuVf2gdx4xLkNQGvwi1/UiuiRXzi/RXn
         JXr9fhDCARuBH7pAZycvrKCz+HFxV7CwLiNb1m5d9dXgU90mGSETx2F4Y95QEGS/Wcy4
         XEh5P5KF7phVHqe1YoR+KlvB/ycvu6wD7vqkMhAYxQPPKTi0CfAsvhc0eChBrWVOGAFw
         Pq5D6uc3mncsYQW/tUACTQl5InajSaf0m227B3dZqQHH8VK1t4utEvHeaItIGy/eNepF
         WAtE5r9R8E3ls/Rkfqq9RtdHncM6YOxTawI3ltdG313PJYEPBBnLAB8nEk65+NItn2uU
         QjNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YttYJY2hEu0o9ieZzIqW+Sf4nL0+gX4KSVXdg9N5DNU=;
        b=UP+h9X9hUyVT1gOe5fwD7SFyN6duBR7sAufNORoFEFBUMDQ0cOVsQdBE5P9cuFnzW+
         VgAGtoXAGp/p+hMTy8iDGTkVdxg8cYPPb3d4C0m2gFGNHKkeEOwk835QV+6wcLod2ynf
         1lVl9L1ncPT8NnCsinTN2z6LtQYON4gGFRIMoMd51y7p4RQAZNN4FarHR+X2NV810kmv
         C4rme7CzWsfMo3wN4QmMqoWVVfD82H4Zxjr6LGx123Xtx4fG+x3xxI6BhDQR+D5RmvA7
         n6jJI53T7jaq/ciY4hkq8oOvr2M70BbulS8LQrJAJBjTOSndVj8KH1DMKU0s86TjVqfB
         ELug==
X-Gm-Message-State: ANhLgQ0OmGGqffaaGdlV/4z9iLz1N/+i+FqUvkaklYAjkxQaZg/kII4q
        qta4xbIQNY8G8UekiP6aeEk=
X-Google-Smtp-Source: ADFU+vs4CKXfeoUiFDnFoMUD4Yhp6hvzZsVFA01ru2dnM86QFvbm5rhxncjWPzQFEZPxKZW0qt8guw==
X-Received: by 2002:a17:902:694b:: with SMTP id k11mr7718361plt.334.1583589493848;
        Sat, 07 Mar 2020 05:58:13 -0800 (PST)
Received: from VM_0_35_centos.localdomain ([150.109.62.251])
        by smtp.gmail.com with ESMTPSA id y28sm14694177pgc.69.2020.03.07.05.58.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Mar 2020 05:58:13 -0800 (PST)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     marcel@holtmann.org
Cc:     johan.hedberg@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH] bluetooth/rfcomm: fix ODEBUG bug in rfcomm_dev_ioctl
Date:   Sat,  7 Mar 2020 21:58:08 +0800
Message-Id: <1583589488-22450-1-git-send-email-hqjagain@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Needn't call 'rfcomm_dlc_put' here, because 'rfcomm_dlc_exists' didn't
increase dlc->refcnt.

Reported-by: syzbot+4496e82090657320efc6@syzkaller.appspotmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
 net/bluetooth/rfcomm/tty.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index 0c7d31c..ea2a1df0 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -414,7 +414,6 @@ static int __rfcomm_create_dev(struct sock *sk, void __user *arg)
 		if (IS_ERR(dlc))
 			return PTR_ERR(dlc);
 		else if (dlc) {
-			rfcomm_dlc_put(dlc);
 			return -EBUSY;
 		}
 		dlc = rfcomm_dlc_alloc(GFP_KERNEL);
-- 
1.8.3.1

