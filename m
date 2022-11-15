Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C769629791
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 12:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbiKOLhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 06:37:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiKOLht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 06:37:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F047FC1
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 03:36:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668512214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eoNTQnwQZyPJ5tr68qUnHNCC0pWwTkHqB6A+r52nsuc=;
        b=OD/V+e8SkijB1cLa2rFVeOKEb261zTIvuTED/y9rbX/a6OYVgboYVhRQEiOHII40QoHCfZ
        HTeOipJqvRxtXUmBE7Uzf/50nGBZE3MR4uWDPU5uKqE3NmmuLzK8oz/8o0sfqrc8W8KyHU
        KoG3LqcnZRQJ8XH5GfDeIuiZdAxG7V8=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-107-iLaSJ4fDMlC48yDVhY7HJA-1; Tue, 15 Nov 2022 06:36:53 -0500
X-MC-Unique: iLaSJ4fDMlC48yDVhY7HJA-1
Received: by mail-qt1-f198.google.com with SMTP id c19-20020a05622a059300b003a51d69906eso10003352qtb.1
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 03:36:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eoNTQnwQZyPJ5tr68qUnHNCC0pWwTkHqB6A+r52nsuc=;
        b=HlfLmDsyB6tUSQwRM9kd3WHRMkVjSwx0AUuQz71AVxpVaZ4P5SXAL6CC25y3bE/y7b
         XIcDl1IV5Jc7NFqM2Mi1WwiXPb1n7dEBciJm2mKEp1fDa2sHGMpGgaWIrPDE5jpi+yHe
         zMeJePEauXFkCJPT1vzOi5oi7Pr7qNTUIuSAOMcfCveYeLXStg5LO8zIWHg5NcJeJcmE
         LS+HVdgIbzDSvEie6U8xjU2enknTqxA6dKn8AiyRh8NYhh+o0klJ/N3S5GL/HDXu29v/
         VNXq5YfqWeoEWxSTVsILiDGXxgbFoO/omg0Bc5B4tJfvqhU0y16/UqELGrVLjOWcvYBA
         HcTA==
X-Gm-Message-State: ANoB5pl7lXUAxsosXVE9Ag6JNByLbJNNxTtow0K7dbEYw3IfJ/g0vHSy
        sBHGvUZsitGPKOXUoQhKiv6Ym8Wo2/GjqFNLBQSbj57h/TP79PQ6qVQlFyuOdaBsrjQO1JaiOYO
        afHj6cOpnkUnzQ4BO
X-Received: by 2002:a05:6214:5581:b0:4bb:a1ca:2076 with SMTP id mi1-20020a056214558100b004bba1ca2076mr16013504qvb.121.1668512212676;
        Tue, 15 Nov 2022 03:36:52 -0800 (PST)
X-Google-Smtp-Source: AA0mqf66e8I+WW4mzjjap63kVO4EOYJD4gJqM7n4k0zCHAtqaXWpy/NJCy70eecRYg2KePL7ubiGOA==
X-Received: by 2002:a05:6214:5581:b0:4bb:a1ca:2076 with SMTP id mi1-20020a056214558100b004bba1ca2076mr16013494qvb.121.1668512212437;
        Tue, 15 Nov 2022 03:36:52 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id b13-20020ac86bcd000000b003a57a317c17sm7027844qtt.74.2022.11.15.03.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 03:36:51 -0800 (PST)
Message-ID: <0f385a7bcb8ccf71e39581d4be23b59d3bccc2e7.camel@redhat.com>
Subject: Re: [PATCH v2] net: sched: fix memory leak in tcindex_set_parms
From:   Paolo Abeni <pabeni@redhat.com>
To:     Hawkins Jiawei <yin31149@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     18801353760@163.com,
        syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 15 Nov 2022 12:36:47 +0100
In-Reply-To: <20221113170507.8205-1-yin31149@gmail.com>
References: <20221113170507.8205-1-yin31149@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-11-14 at 01:05 +0800, Hawkins Jiawei wrote:
> Syzkaller reports a memory leak as follows:
> ====================================
> BUG: memory leak
> unreferenced object 0xffff88810c287f00 (size 256):
>   comm "syz-executor105", pid 3600, jiffies 4294943292 (age 12.990s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff814cf9f0>] kmalloc_trace+0x20/0x90 mm/slab_common.c:1046
>     [<ffffffff839c9e07>] kmalloc include/linux/slab.h:576 [inline]
>     [<ffffffff839c9e07>] kmalloc_array include/linux/slab.h:627 [inline]
>     [<ffffffff839c9e07>] kcalloc include/linux/slab.h:659 [inline]
>     [<ffffffff839c9e07>] tcf_exts_init include/net/pkt_cls.h:250 [inline]
>     [<ffffffff839c9e07>] tcindex_set_parms+0xa7/0xbe0 net/sched/cls_tcindex.c:342
>     [<ffffffff839caa1f>] tcindex_change+0xdf/0x120 net/sched/cls_tcindex.c:553
>     [<ffffffff8394db62>] tc_new_tfilter+0x4f2/0x1100 net/sched/cls_api.c:2147
>     [<ffffffff8389e91c>] rtnetlink_rcv_msg+0x4dc/0x5d0 net/core/rtnetlink.c:6082
>     [<ffffffff839eba67>] netlink_rcv_skb+0x87/0x1d0 net/netlink/af_netlink.c:2540
>     [<ffffffff839eab87>] netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>     [<ffffffff839eab87>] netlink_unicast+0x397/0x4c0 net/netlink/af_netlink.c:1345
>     [<ffffffff839eb046>] netlink_sendmsg+0x396/0x710 net/netlink/af_netlink.c:1921
>     [<ffffffff8383e796>] sock_sendmsg_nosec net/socket.c:714 [inline]
>     [<ffffffff8383e796>] sock_sendmsg+0x56/0x80 net/socket.c:734
>     [<ffffffff8383eb08>] ____sys_sendmsg+0x178/0x410 net/socket.c:2482
>     [<ffffffff83843678>] ___sys_sendmsg+0xa8/0x110 net/socket.c:2536
>     [<ffffffff838439c5>] __sys_sendmmsg+0x105/0x330 net/socket.c:2622
>     [<ffffffff83843c14>] __do_sys_sendmmsg net/socket.c:2651 [inline]
>     [<ffffffff83843c14>] __se_sys_sendmmsg net/socket.c:2648 [inline]
>     [<ffffffff83843c14>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2648
>     [<ffffffff84605fd5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>     [<ffffffff84605fd5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>     [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> ====================================
> 
> Kernel uses tcindex_change() to change an existing
> traffic-control-indices filter properties. During the
> process of changing, kernel clears the old
> traffic-control-indices filter result, and updates it
> by RCU assigning new traffic-control-indices data.
> 
> Yet the problem is that, kernel clears the old
> traffic-control-indices filter result, without destroying
> its tcf_exts structure, which triggers the above
> memory leak.
> 
> This patch solves it by using tcf_exts_destroy() to
> destroy the tcf_exts structure in old
> traffic-control-indices filter result, after the
> RCU grace period.
> 
> [Thanks to the suggestion from Jakub Kicinski and Cong Wang]
> 
> Fixes: b9a24bb76bf6 ("net_sched: properly handle failure case of tcf_exts_init()")
> Link: https://lore.kernel.org/all/0000000000001de5c505ebc9ec59@google.com/
> Reported-by: syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com
> Tested-by: syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com
> Cc: Cong Wang <cong.wang@bytedance.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
> ---
> v2:
>   - remove all 'will' in commit message according to Jakub Kicinski
>   - add Fixes tag according to Jakub Kicinski
>   - remove all ifdefs according to Jakub Kicinski and Cong Wang
>   - add synchronize_rcu() before destorying old_e according to
> Cong Wang
> 
> v1: https://lore.kernel.org/all/20221031060835.11722-1-yin31149@gmail.com/
>  net/sched/cls_tcindex.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
> index 1c9eeb98d826..d2fac9559d3e 100644
> --- a/net/sched/cls_tcindex.c
> +++ b/net/sched/cls_tcindex.c
> @@ -338,6 +338,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
>  	struct tcf_result cr = {};
>  	int err, balloc = 0;
>  	struct tcf_exts e;
> +	struct tcf_exts old_e = {};
>  
>  	err = tcf_exts_init(&e, net, TCA_TCINDEX_ACT, TCA_TCINDEX_POLICE);
>  	if (err < 0)
> @@ -479,6 +480,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
>  	}
>  
>  	if (old_r && old_r != r) {
> +		old_e = old_r->exts;
>  		err = tcindex_filter_result_init(old_r, cp, net);
>  		if (err < 0) {
>  			kfree(f);
> @@ -510,6 +512,12 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
>  		tcf_exts_destroy(&new_filter_result.exts);
>  	}
>  
> +	/* Note: old_e should be destroyed after the RCU grace period,
> +	 * to avoid possible use-after-free by concurrent readers.
> +	 */
> +	synchronize_rcu();

this could make tc reconfiguration potentially very slow. I'm wondering
if we can delegate the tcf_exts_destroy() to some workqueue?

Thanks!

Paolo

