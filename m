Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D218F617EF3
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 15:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbiKCOKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 10:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbiKCOKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 10:10:39 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61005101FA
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 07:10:38 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id p8-20020a056830130800b0066bb73cf3bcso1021966otq.11
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 07:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kSrCH0Te60lbObeyJlysAcGRAtRbK8J7JgguatyqHwc=;
        b=fumuVICZFRS+xFIUyKjkj88RoqF2ee/MllqYEj4nzltfVlDwe6hT9/Cpgcudyme6TV
         ws0vJik5LjFez9vkOZV24gGiwC1EwukZpeXL4G5j9jrGj/k4XmrKgIiYDtUgyTo2MB3w
         XRZkrOxFOwqfgHC8howIX86XjTGtACYP4eCn3IlSMW6t67fiPI9uvElAWF0MS6BKHBHp
         oILSWwdyhSgPcwDuRPsEFTMIt0Dd5a2P2812+cUscXJppkG7dwwuJmZp2AaeC5A3Pvfo
         Ufs2MPJhfIcX2oRMLzhYs4YB47Y55BVW+3j03BMBL/mFoah64SqKhSO+MyUXF1ZVcbuB
         5r3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kSrCH0Te60lbObeyJlysAcGRAtRbK8J7JgguatyqHwc=;
        b=1xS874IO3ImtkJH4+bUgj0l+Zy/zvxucBViDlPTVHnC0QWMnrhl/HBOikIcqqA6vrY
         8ElpFzZ2yWzWieYqYTalJAfiv1d8RR9ihCbOxp2941bREGrZqIo1l8oYghkkb3MfAKt0
         lI9fDxe30Gi377/5wqD/G0kLdjjlQDOCVrKIQvYNrsaymLh89ohh21hWQoMlUECG2ygq
         i6kqaZRXi0XMV6OSzNbrs54nBoK4PXXHvelHqn2n0nluyiYGUUeN539tmOmDGo1rD/Q9
         E2M8qSdIqgjTelWETnDIAuTLhuC3eqDHTFqmw3uKPjSkvWuGheXYAxnkuSA9XcAqH+Hs
         nJrA==
X-Gm-Message-State: ACrzQf2gLY5RtCsbKeZbCzi0oJbasmuvFrtjNDeWEG/HD7xtnF43W5G1
        qkIOuuFe+90FMgcWKdU1i97F0hTMDVBubV3PUVPSlg==
X-Google-Smtp-Source: AMsMyM4iKiR+EEIVTpTWD2Pug18C0pxyDTWl0zduTWi3pYu9GBKTYpEPpem+sB/j98H/+CL9YzZZw4MAVLO0xhkgUt8=
X-Received: by 2002:a05:6830:1343:b0:66c:57c4:f4c4 with SMTP id
 r3-20020a056830134300b0066c57c4f4c4mr9929276otq.161.1667484637488; Thu, 03
 Nov 2022 07:10:37 -0700 (PDT)
MIME-Version: 1.0
References: <20221103124652.260085-1-luwei32@huawei.com>
In-Reply-To: <20221103124652.260085-1-luwei32@huawei.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 3 Nov 2022 10:10:20 -0400
Message-ID: <CADVnQyk61VdP24A_kMD1f3euG8mGuem=_MfYoNWBKAAky6cYtw@mail.gmail.com>
Subject: Re: [patch net v4] tcp: prohibit TCP_REPAIR_OPTIONS if data was
 already sent
To:     Lu Wei <luwei32@huawei.com>
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        xemul@parallels.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 3, 2022 at 7:42 AM Lu Wei <luwei32@huawei.com> wrote:
>
> If setsockopt with option name of TCP_REPAIR_OPTIONS and opt_code
> of TCPOPT_SACK_PERM is called to enable sack after data is sent
> and dupacks are received , it will trigger a warning in function
> tcp_verify_left_out() as follows:
>
> ============================================
> WARNING: CPU: 8 PID: 0 at net/ipv4/tcp_input.c:2132
> tcp_timeout_mark_lost+0x154/0x160
> tcp_enter_loss+0x2b/0x290
> tcp_retransmit_timer+0x50b/0x640
> tcp_write_timer_handler+0x1c8/0x340
> tcp_write_timer+0xe5/0x140
> call_timer_fn+0x3a/0x1b0
> __run_timers.part.0+0x1bf/0x2d0
> run_timer_softirq+0x43/0xb0
> __do_softirq+0xfd/0x373
> __irq_exit_rcu+0xf6/0x140
>
> The warning is caused in the following steps:
> 1. a socket named socketA is created
> 2. socketA enters repair mode without build a connection
> 3. socketA calls connect() and its state is changed to TCP_ESTABLISHED
>    directly
> 4. socketA leaves repair mode
> 5. socketA calls sendmsg() to send data, packets_out and sack_outs(dup
>    ack receives) increase
> 6. socketA enters repair mode again
> 7. socketA calls setsockopt with TCPOPT_SACK_PERM to enable sack
> 8. retransmit timer expires, it calls tcp_timeout_mark_lost(), lost_out
>    increases
> 9. sack_outs + lost_out > packets_out triggers since lost_out and
>    sack_outs increase repeatly
>
> In function tcp_timeout_mark_lost(), tp->sacked_out will be cleared if
> Step7 not happen and the warning will not be triggered. As suggested by
> Denis and Eric, TCP_REPAIR_OPTIONS should be prohibited if data was
> already sent. So this patch checks tp->segs_out, only TCP_REPAIR_OPTIONS
> can be set only if tp->segs_out is 0.

This last sentence mentioning tp->segs_out has not been updated to
match the code. :-) You may want to just omit that sentence, since it
is just restating the patch in English prose, and the previous
sentence already conveys the the intent and high-level functionality
("TCP_REPAIR_OPTIONS should be prohibited if data was already sent").

neal
