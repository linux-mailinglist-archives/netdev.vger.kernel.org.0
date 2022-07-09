Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F06F56C8F9
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 12:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiGIKZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 06:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGIKZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 06:25:12 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED612558E5
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 03:25:10 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id n74so1525905yba.3
        for <netdev@vger.kernel.org>; Sat, 09 Jul 2022 03:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fvEL9+xL33VHT7DLruKyii9DVnrgLzeWg+KgwCcP7f4=;
        b=kHdHlCNjn4M6EOkhrRYBRylXh4d0l/5CBgzgJ1/67F6gDI4sBPetULs8hKqkgXgioq
         ys281cxIkbqfFgxXqulC7I8HtUuHai4z2UXOwau14NuqtV7XceGu+s142Dl2ZFjPglsI
         8jCzefcqQAv/rB1MB3/iMWvN9QhSX7rcwPRoxfXpAebQVmY98sxCYwfO/8dRAXw6fgkv
         NmJaerY7UhPSni3tz6cSYXfCpa8hDX8IypCE7nSy9QYMTigvsYB+cKs1Ku7k40vcPmQP
         Vm8qqbcbCi2EagEA1r8DtGuDUHCFpM11lOvW5F2mlclNx2IUOMLhv5vwj7Eo205mDoJI
         Xitg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fvEL9+xL33VHT7DLruKyii9DVnrgLzeWg+KgwCcP7f4=;
        b=wOtq4Vl3Mx9FIT8++pEUIYRWbFa/CEciGcC4QAcvOSDm5lhG8JTICqPPlmBjmbc26y
         rAVL4i8paAWwo6UUe7uZlUxaReWSxMbGX/rXL5wt5GKm1Y1CrsbztoKgq1OZRbNm+UpB
         V0QyAQem9FfhZGDp+3/InFpR6cgGg13vApRg6XahgAYyafb1CX/n94XuWVgQ5SPPQCH6
         CGpmIjdZ8Euejo2WQD+0T64T5xAOg1aitwRoyQGRh4AA4SVATGBvThILQp38z0nc9IVi
         /M1xQI0r1za7NW4jvapPTi0GguSCVnDV5ZM+P3EO1ozfJ7eef/QzxyJfq/jME4hUJSiP
         H1vQ==
X-Gm-Message-State: AJIora9UGHmtYCT2ch8r3+25iG4H9MjbF4BDuz1yFREfkO554DA2cFqL
        +PTWkLQlUH0eOW8a7H1qR7j8VB3vIV6pUPXxwzwlPQ==
X-Google-Smtp-Source: AGRyM1tIhsmmIoYfQdjWDOe3fWa8MzrhXv35j/ejAVjp2yVol1MBO1ab5YfcQUjC082rx4NBmSXoJ60j+a7ma5g7LZM=
X-Received: by 2002:a25:e211:0:b0:669:9cf9:bac7 with SMTP id
 h17-20020a25e211000000b006699cf9bac7mr7779510ybe.407.1657362309771; Sat, 09
 Jul 2022 03:25:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220708151153.1813012-1-edumazet@google.com> <CADvbK_d9yd=pNUQ7NQ9xzeCuo6say2BBpYBPzt2GD2Yd2FYMCg@mail.gmail.com>
In-Reply-To: <CADvbK_d9yd=pNUQ7NQ9xzeCuo6say2BBpYBPzt2GD2Yd2FYMCg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 9 Jul 2022 12:24:58 +0200
Message-ID: <CANn89iJRUfUJTA2n7vwPwVY_BOJ1SB9bdKqF4Orid=sNRX8Uig@mail.gmail.com>
Subject: Re: [PATCH net] vlan: fix memory leak in vlan_newlink()
To:     Xin Long <lucien.xin@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        network dev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 9, 2022 at 3:45 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Fri, Jul 8, 2022 at 11:11 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > Blamed commit added back a bug I fixed in commit 9bbd917e0bec
> > ("vlan: fix memory leak in vlan_dev_set_egress_priority")
> >
> > If a memory allocation fails in vlan_changelink() after other allocations
> > succeeded, we need to call vlan_dev_free_egress_priority()
> > to free all allocated memory because after a failed ->newlink()
> > we do not call any methods like ndo_uninit() or dev->priv_destructor().
> >
> > In following example, if the allocation for last element 2000:2001 fails,
> > we need to free eight prior allocations:
> >
> > ip link add link dummy0 dummy0.100 type vlan id 100 \
> >         egress-qos-map 1:2 2:3 3:4 4:5 5:6 6:7 7:8 8:9 2000:2001
> BTW, it seems that:
>
> # ip link change link dummy0 dummy0.100 type vlan id 100
> egress-qos-map 8:9 2003:2004
>
> instead of changing qos-map to {8:1 2003:2004}, this cmd can only be
> able to append the new qos-map "2003:2004".
>
> Is this expected?
>

I think this is expected, kernel only supports additions of new items.
Otherwise a real RCU protection would be needed.

Speaking of (lack of) RCU, it seems we need the following orthogonal fix.

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index e00c4ee81ff7f82e4343fe45c14d8e5d81d80e95..bbe2c73ca74aeaccb91d2bde71c59c60c53ec515
100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -202,8 +202,8 @@ vlan_dev_get_egress_qos_mask(struct net_device
*dev, u32 skprio)
        struct vlan_priority_tci_mapping *mp;

        smp_rmb(); /* coupled with smp_wmb() in
vlan_dev_set_egress_priority() */
-
-       mp = vlan_dev_priv(dev)->egress_priority_map[(skprio & 0xF)];
+       /* Paired with WRITE_ONCE() in vlan_dev_set_egress_priority() */
+       mp = READ_ONCE(vlan_dev_priv(dev)->egress_priority_map[skprio & 0xF]);
        while (mp) {
                if (mp->priority == skprio) {
                        return mp->vlan_qos; /* This should already be shifted
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 035812b0461cc4b403f1a80bfdb9cfd9f44e4b45..5cb4d5121a71b012000de14f4e919cd3bf42a44b
100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -202,7 +202,8 @@ int vlan_dev_set_egress_priority(const struct
net_device *dev,
         * coupled with smp_rmb() in vlan_dev_get_egress_qos_mask()
         */
        smp_wmb();
-       vlan->egress_priority_map[skb_prio & 0xF] = np;
+       /* Paired with READ_ONCE() in vlan_dev_get_egress_qos_mask() */
+       WRITE_ONCE(vlan->egress_priority_map[skb_prio & 0xF], np);
        if (vlan_qos)
                vlan->nr_egress_mappings++;
        return 0;
