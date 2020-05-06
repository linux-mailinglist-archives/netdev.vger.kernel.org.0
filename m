Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1BCB1C79A4
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 20:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730505AbgEFSqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 14:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730317AbgEFSqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 14:46:52 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F725C061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 11:46:52 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id k133so2484816oih.12
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 11:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=psm6jQDVPGIqv6WhwYYfrIzlhdm6RfobGbWpw/VDeq4=;
        b=isYggL+a4ZZKEdAYZZPGbAH3GXAPtyqYlGeX2Jui/RPim2UkFzSa77TECsAWXQZ2OT
         Ta6uXYDpkwOkzx+jQf0O/0tB90CNj5PxxRXvRRSYTxOe5r4JoxhdR78T4mRVQaqSf2yZ
         hmg4EzVyMVME+a++6iq0bocvyu7vGFVtrVEtNhgNgDQ5bIUXa2qZcss/0IAeT2nbHloa
         PtlXhiH5Ll7XQ8t3RnnWtTXWZv2yESoYx40mHvFH+x82v9GpbFWZkT48jBevAsCluL7c
         MakA/ZmwvPrvmOzfKH4CO+LQHZ2bZemDx8CGKvHoO+Jo1zHF+AAabfALPNQsK4TLEynB
         WjYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=psm6jQDVPGIqv6WhwYYfrIzlhdm6RfobGbWpw/VDeq4=;
        b=nDFGgZMUfkbw8EhI4eNl+g/DP0ptQLuFSuQB5LPATHpc8BbSDlpnX/L3hfGbkI2qnN
         E+ecMJv176E7FMIuIj8D6fSEJKr7R7A/W1d6X3aoImt2uZhLOcV2n175J1pKPDAdT7Ul
         rxiAKf5nzciiuirYmHt6jQRV86dIHy0AW2efSz/px1f2jKOXVGn4CXhA61JRP7DW/FJ+
         YydeVoBW6aC78Hbefa7+MvtaudelGU3XCgr6rhG5RJTuxW0UwvhnYpgm2+krDTFedcoZ
         KDoDDoCFiRH7yXRPQrqAV0ZRLo7iAxX1yYakrtQFkVIIoQ+t6C2qReAmeO7UxEZ/pWz5
         398A==
X-Gm-Message-State: AGi0Pub5WJiAEvrCBknvUXkGBLnV9TNYk2+Eo0WSZCbWmV4Q2TnxF0uu
        3JCZT0q309n4HQofjFbrDCL+hHQ/QLTiav99mng=
X-Google-Smtp-Source: APiQypKWB3uA84VFWgreHREhOcJxpwyNv2nPSuIMyC55i1ukUrOhQu+WUFIyAsmSWM2IKrebCviYjvHVkwaZNHRn8mI=
X-Received: by 2002:a54:4e84:: with SMTP id c4mr3894914oiy.142.1588790811051;
 Wed, 06 May 2020 11:46:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200505215819.1997-1-xiyou.wangcong@gmail.com> <2833.1588718397@famine>
In-Reply-To: <2833.1588718397@famine>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 6 May 2020 11:46:40 -0700
Message-ID: <CAM_iQpUiKS-dcC11uyb_jK+Uwu+AgGDQw_ytZKP8QxmkcmH4Xw@mail.gmail.com>
Subject: Re: [Patch net] net: fix a potential recursive NETDEV_FEAT_CHANGE
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com>,
        syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com,
        Jarod Wilson <jarod@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 3:42 PM Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
>
> Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> >syzbot managed to trigger a recursive NETDEV_FEAT_CHANGE event
> >between bonding master and slave. I managed to find a reproducer
> >for this:
> >
> >  ip li set bond0 up
> >  ifenslave bond0 eth0
> >  brctl addbr br0
> >  ethtool -K eth0 lro off
> >  brctl addif br0 bond0
> >  ip li set br0 up
>
>         Presumably this is tied to the LRO feature being special in
> netdev_sync_lower_features (via NETIF_F_UPPER_DISABLES), but why doesn't
> LRO become disabled and stop the recursion once the test
>
>                 if (!(features & feature) && (lower->features & feature)) {
>
>         no longer evalutes to true (in theory)?

Good point!

Actually the LRO feature fails to disable:

[   62.559537] netdevice: bond0: failed to disable 0x0000000000008000 on eth0!
...
[   78.312003] netdevice: eth0: failed to disable LRO!

It seems we should only skip netdev_update_features() for such case,
like below. Note __netdev_update_features() intentionally returns -1
for this failure, so I am afraid we just have to live with it.

diff --git a/net/core/dev.c b/net/core/dev.c
index 522288177bbd..8040b07214fa 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8907,11 +8907,13 @@ static void netdev_sync_lower_features(struct
net_device *upper,
                        netdev_dbg(upper, "Disabling feature %pNF on
lower dev %s.\n",
                                   &feature, lower->name);
                        lower->wanted_features &= ~feature;
-                       netdev_update_features(lower);
+                       __netdev_update_features(lower);

                        if (unlikely(lower->features & feature))
                                netdev_WARN(upper, "failed to disable
%pNF on %s!\n",
                                            &feature, lower->name);
+                       else
+                               netdev_update_features(lower);
                }
        }
 }
