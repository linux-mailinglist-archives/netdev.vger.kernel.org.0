Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D90726D7059
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 01:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235802AbjDDXC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 19:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236029AbjDDXC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 19:02:27 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EA41732
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 16:02:25 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id d75a77b69052e-3e392e10cc4so193551cf.0
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 16:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680649344;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PEW//PlRGNKSI9zp0ojfTvCTcs2PPiaNdCkAhCNsk78=;
        b=hu00fpm7vkpMNsHts8+iDRuxhBsuO5NuO/bwGB35mOvoGRXsbz/3psEs+H+4Z/JxyN
         yPaEuy9LMTnSYl8McjdtZjfGBtvifHJ00nlHsH7Occ/QmhAa/e6kn7JtSVB639fI1d3B
         vP6ZZfvLU2NFuoAEugPvaeWLZy6vC6FrmW31v/FMnHO+CnTnSmfl+1um/2aclYNm2Vg2
         gwKIHCPQDDOVIF9Oo+4J58tuMIcz05R23kVJf2a88zzV8gxOwtTdki70iJqrss2qyUGe
         YaopXetEHSf/Stvxfqme+ZFJs4tPZFMThGbaY3pP+JOGeLLlSupujTfMU6Ex14P5Cbnb
         Hl/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680649344;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PEW//PlRGNKSI9zp0ojfTvCTcs2PPiaNdCkAhCNsk78=;
        b=KkFPf0DLCd9VEzUeX3BUK0OM/UnGgth9y1ESJ0PJI6K+BDiuIRAW3WfFOa/bhsyU0L
         YLaqUnbBSbiOijOyuhx/n0P+yWPgqVa4TNbA6CQJbQMRhPdypu3Y7CVEl6UyXihR5fBo
         QtFQR9vU1knZ+O0H+jkA7N2duyp80gQhtWEW5IixHNiMt7Chk9U39iBFQKf/RgKrwbh5
         UGwsLbFLPNWirDv0Gi/Shdz7WAzzhYOJPrN2309sAXlpwphqTm5Wa/lby8OK+ojSCK3f
         mOQ09QCiq0MyiqNtBOAecHagCHfnjIFDZr48RCozCHpjTTpGOoncO/dH80FVFKcpbRYc
         NeGw==
X-Gm-Message-State: AAQBX9d6E2/PTr9MyjSQWEkWc9pGT51Fu6NDOEDDNr8M2aWYwmawvxjm
        EkoK+gh6e2/xTdFtNchhJOHnz+rET69ehHH9qUr2Zw==
X-Google-Smtp-Source: AKy350booJ2nGLKa/KDLNjI3NbBCIh2vuBZGllPM/lH/+h2YITTVMxftvzaPJazfcojDXXk/yZKrj2rNQF49CWVHqlc=
X-Received: by 2002:a05:622a:1994:b0:3d6:b755:31 with SMTP id
 u20-20020a05622a199400b003d6b7550031mr40307qtc.17.1680649344090; Tue, 04 Apr
 2023 16:02:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230404171658.917361-1-edumazet@google.com> <ZCxgqWkicKWYDySr@corigine.com>
In-Reply-To: <ZCxgqWkicKWYDySr@corigine.com>
From:   Jaewan Kim <jaewan@google.com>
Date:   Wed, 5 Apr 2023 08:02:11 +0900
Message-ID: <CABZjns4E6C8iB1+h58bZ_kV=x_3Uh_-KCYRxV2Es-GwseWijLQ@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] mac80211_hwsim: fix potential NULL deref in hwsim_pmsr_report_nl()
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>,
        Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 5, 2023 at 2:39=E2=80=AFAM Simon Horman <simon.horman@corigine.=
com> wrote:
>
> On Tue, Apr 04, 2023 at 05:16:58PM +0000, Eric Dumazet wrote:
> > syzbot reported a NULL dereference caused by a missing check
> > in hwsim_pmsr_report_nl(), and bisected the issue to cited commit.
> >
> > v2: test the nlattr before using nla_data() on it (Simon Horman)
> >
> > general protection fault, probably for non-canonical address 0xdffffc00=
00000001: 0000 [#1] PREEMPT SMP KASAN
> > KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> > CPU: 0 PID: 5084 Comm: syz-executor104 Not tainted 6.3.0-rc4-next-20230=
331-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS=
 Google 03/02/2023
> > RIP: 0010:jhash+0x339/0x610 include/linux/jhash.h:95
> > Code: 83 fd 01 0f 84 5f ff ff ff eb de 83 fd 05 74 3a e8 ac f5 71 fd 48=
 8d 7b 05 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 =
48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 96 02 00 00
> > RSP: 0018:ffffc90003abf298 EFLAGS: 00010202
> > RAX: dffffc0000000000 RBX: 0000000000000004 RCX: 0000000000000000
> > RDX: 0000000000000001 RSI: ffffffff84111ba4 RDI: 0000000000000009
> > RBP: 0000000000000006 R08: 0000000000000005 R09: 000000000000000c
> > R10: 0000000000000006 R11: 0000000000000000 R12: 000000004d2c27cd
> > R13: 000000002bd9e6c2 R14: 000000002bd9e6c2 R15: 000000002bd9e6c2
> > FS: 0000555556847300(0000) GS:ffff8880b9800000(0000) knlGS:000000000000=
0000
> > CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 000000000045ad50 CR3: 0000000078aa6000 CR4: 00000000003506f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> > <TASK>
> > rht_key_hashfn include/linux/rhashtable.h:159 [inline]
> > __rhashtable_lookup include/linux/rhashtable.h:604 [inline]
> > rhashtable_lookup include/linux/rhashtable.h:646 [inline]
> > rhashtable_lookup_fast include/linux/rhashtable.h:672 [inline]
> > get_hwsim_data_ref_from_addr+0xb9/0x600 drivers/net/wireless/virtual/ma=
c80211_hwsim.c:757
> > hwsim_pmsr_report_nl+0xe7/0xd50 drivers/net/wireless/virtual/mac80211_h=
wsim.c:3764
> > genl_family_rcv_msg_doit.isra.0+0x1e6/0x2d0 net/netlink/genetlink.c:968
> > genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
> > genl_rcv_msg+0x4ff/0x7e0 net/netlink/genetlink.c:1065
> > netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2572
> > genl_rcv+0x28/0x40 net/netlink/genetlink.c:1076
> > netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
> > netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
> > netlink_sendmsg+0x925/0xe30 net/netlink/af_netlink.c:1942
> > sock_sendmsg_nosec net/socket.c:724 [inline]
> > sock_sendmsg+0xde/0x190 net/socket.c:747
> > ____sys_sendmsg+0x71c/0x900 net/socket.c:2501
> > ___sys_sendmsg+0x110/0x1b0 net/socket.c:2555
> > __sys_sendmsg+0xf7/0x1c0 net/socket.c:2584
> > do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> > entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> > Fixes: 2af3b2a631b1 ("mac80211_hwsim: add PMSR report support via virti=
o")
> > Reported-by: syzbot <syzkaller@googlegroups.com>
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Jaewan Kim <jaewan@google.com>
> > Cc: Johannes Berg <johannes.berg@intel.com>
>
> Thanks Eric,
>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Reviewed-by: Jaewan Kim <jaewan@google.com>

--=20
Jaewan Kim (=EA=B9=80=EC=9E=AC=EC=99=84) | Software Engineer in Google Kore=
a |
jaewan@google.com | +82-10-2781-5078
