Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9526F029B
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 10:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243182AbjD0Ibd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 04:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243145AbjD0Ib1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 04:31:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D5DE61
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 01:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682584246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5CIJufairw0HD4aai5j3Qvh/gphMU5uk5qLRY6BSILw=;
        b=NsU/lsuNScQZXylD1rEMJrVDUx+CTnm/Z4EIqSWw/slvMG1plKsCgjuo4bbXjqGUUMYqYu
        U8ds2mO++uIoBegnTzx4x/gLkis7iHfmmk5HeWdiw6oaMyPMAQSLtx6gIHkb72V1aV3+/D
        JI9626Mq9+vX18sGNNE0YFkcJCM0LNA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-asflm2AXOaaCr0gUsbbNbg-1; Thu, 27 Apr 2023 04:30:45 -0400
X-MC-Unique: asflm2AXOaaCr0gUsbbNbg-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f08900caadso11836225e9.0
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 01:30:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682584243; x=1685176243;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5CIJufairw0HD4aai5j3Qvh/gphMU5uk5qLRY6BSILw=;
        b=l+hQDe0txvBquZM6zepHl2B9LC42dA/machA3iM4n65bIpOEBUuO+LKn9U6GQ5vc0M
         ex9uxLcW7QPXZHh4FpUoSSLXop921s0/8ysgR1wULsiIG+KUIcrKHZJWQntLprua2cqh
         ljrJW+Yh7mCQrtZX7Bwr66jvZu49EZnYiEbwei2Xek3Ly4VxDLfd1JugGTDEX6FajvSI
         2/PMbY60s5zBGjFGTbGSXbYry2m9OYSatGKx95G/qzrFXmUvOf9hGlhPHR6v9mGHb1Lt
         JFrJ1+LcsQ5nfDGyRvNx7wreTF2JqgENIzgiaysx821Nik/1UwxFxZO6QOHQLwpKRxBe
         mHsQ==
X-Gm-Message-State: AC+VfDyba3FS5Ak9VQok/RSqj1oI4gTl9Ys76QZAT58mz9RPEEmvoGeq
        FweMELPT9h468tUphRanlko90AilLaSLSKaZ7itoAs3BlGi05NDyzR+lERSheMB4oHuk3ZXfoz7
        3jTaseBEPX19nFUlFQ/TB1VPe
X-Received: by 2002:a05:600c:3d9b:b0:3f1:7a10:f2f2 with SMTP id bi27-20020a05600c3d9b00b003f17a10f2f2mr810192wmb.1.1682584243614;
        Thu, 27 Apr 2023 01:30:43 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6y7U1H6ZxkUoiFwaet5DLhHVA+b4pIhhX2Cdailzf7TM1DGonWx0DFMV10dQLfAMB9d2ZWMA==
X-Received: by 2002:a05:600c:3d9b:b0:3f1:7a10:f2f2 with SMTP id bi27-20020a05600c3d9b00b003f17a10f2f2mr810174wmb.1.1682584243267;
        Thu, 27 Apr 2023 01:30:43 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-243-21.dyn.eolo.it. [146.241.243.21])
        by smtp.gmail.com with ESMTPSA id f17-20020a5d58f1000000b002cea8e3bd54sm17761639wrd.53.2023.04.27.01.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 01:30:42 -0700 (PDT)
Message-ID: <a716f8af6c77fc82f57e7db2c02e73d1d82cf535.camel@redhat.com>
Subject: Re: [PATCH v2 net] qed/qede: Fix scheduling while atomic
From:   Paolo Abeni <pabeni@redhat.com>
To:     Manish Chopra <manishc@marvell.com>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, aelior@marvell.com, palok@marvell.com,
        Sudarsana Kalluru <skalluru@marvell.com>,
        "David S . Miller" <davem@davemloft.net>
Date:   Thu, 27 Apr 2023 10:30:41 +0200
In-Reply-To: <20230425135035.2078-1-manishc@marvell.com>
References: <20230425135035.2078-1-manishc@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-04-25 at 06:50 -0700, Manish Chopra wrote:
> Bonding module collects the statistics while holding
> the spinlock, beneath that qede->qed driver statistics
> flow gets scheduled out due to usleep_range() used in PTT
> acquire logic which results into below bug and traces -
>=20
> [ 3673.988874] Hardware name: HPE ProLiant DL365 Gen10 Plus/ProLiant DL36=
5 Gen10 Plus, BIOS A42 10/29/2021
> [ 3673.988878] Call Trace:
> [ 3673.988891]  dump_stack_lvl+0x34/0x44
> [ 3673.988908]  __schedule_bug.cold+0x47/0x53
> [ 3673.988918]  __schedule+0x3fb/0x560
> [ 3673.988929]  schedule+0x43/0xb0
> [ 3673.988932]  schedule_hrtimeout_range_clock+0xbf/0x1b0
> [ 3673.988937]  ? __hrtimer_init+0xc0/0xc0
> [ 3673.988950]  usleep_range+0x5e/0x80
> [ 3673.988955]  qed_ptt_acquire+0x2b/0xd0 [qed]
> [ 3673.988981]  _qed_get_vport_stats+0x141/0x240 [qed]
> [ 3673.989001]  qed_get_vport_stats+0x18/0x80 [qed]
> [ 3673.989016]  qede_fill_by_demand_stats+0x37/0x400 [qede]
> [ 3673.989028]  qede_get_stats64+0x19/0xe0 [qede]
> [ 3673.989034]  dev_get_stats+0x5c/0xc0
> [ 3673.989045]  netstat_show.constprop.0+0x52/0xb0
> [ 3673.989055]  dev_attr_show+0x19/0x40
> [ 3673.989065]  sysfs_kf_seq_show+0x9b/0xf0
> [ 3673.989076]  seq_read_iter+0x120/0x4b0
> [ 3673.989087]  new_sync_read+0x118/0x1a0
> [ 3673.989095]  vfs_read+0xf3/0x180
> [ 3673.989099]  ksys_read+0x5f/0xe0
> [ 3673.989102]  do_syscall_64+0x3b/0x90
> [ 3673.989109]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [ 3673.989115] RIP: 0033:0x7f8467d0b082
> [ 3673.989119] Code: c0 e9 b2 fe ff ff 50 48 8d 3d ca 05 08 00 e8 35 e7 0=
1 00 0f 1f 44 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 0f 05 <=
48> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 00 48 83 ec 28 48 89 54 24
> [ 3673.989121] RSP: 002b:00007ffffb21fd08 EFLAGS: 00000246 ORIG_RAX: 0000=
000000000000
> [ 3673.989127] RAX: ffffffffffffffda RBX: 000000000100eca0 RCX: 00007f846=
7d0b082
> [ 3673.989128] RDX: 00000000000003ff RSI: 00007ffffb21fdc0 RDI: 000000000=
0000003
> [ 3673.989130] RBP: 00007f8467b96028 R08: 0000000000000010 R09: 00007ffff=
b21ec00
> [ 3673.989132] R10: 00007ffffb27b170 R11: 0000000000000246 R12: 000000000=
00000f0
> [ 3673.989134] R13: 0000000000000003 R14: 00007f8467b92000 R15: 000000000=
0045a05
> [ 3673.989139] CPU: 30 PID: 285188 Comm: read_all Kdump: loaded Tainted: =
G        W  OE
>=20
> Fix this by having caller (QEDE driver flows) to provide the context
> whether it could be in atomic context flow or not when getting the
> vport stats from QED driver. QED driver based on the context provided
> decide to schedule out or not when acquiring the PTT BAR window.
>=20
> v1->v2:
> =3D=3D=3D=3D=3D=3D=3D
> Fixed checkpatch and kdoc warnings.

The changelog should be placed after the tags section and a '---'
separator, thanks!

Paolo

>=20
> Fixes: 133fac0eedc3 ("qede: Add basic ethtool support")
> Cc: Sudarsana Kalluru <skalluru@marvell.com>
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Manish Chopra <manishc@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Alok Prasad <palok@marvell.com>

