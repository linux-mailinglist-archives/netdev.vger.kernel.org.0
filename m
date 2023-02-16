Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D41DB6997E0
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 15:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbjBPOwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 09:52:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjBPOwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 09:52:18 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1029521F5;
        Thu, 16 Feb 2023 06:52:17 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id v6-20020a17090ad58600b00229eec90a7fso6344715pju.0;
        Thu, 16 Feb 2023 06:52:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vwy/nvSACPs3saFn3MC2GpZOqXyVXmgpysdDNeISxL4=;
        b=cwz68VlmDebluJTDd3kSMGJs+22jJVLh0Fv0bcrZcbxWMLknLTS+Tig93Lq9LNTuwY
         V5SiifT7xi1tRId07N0GCnnM4k3LCV4L7xKXbW8uFDrmLNNXcErsIb8FkXig368+U8IB
         gwH2+13ufQE7YAbNisWxG/gB4r1KN0MAw8jCMwuAkmZcpZ5SUmMOhPUUT4OizXTOOKUu
         2c9a4jwgTkeHUBZ73M4rJWvghAt/bBReKj25J4ixRMSVPADaSpbbQL6/CBnR8+fpnv1N
         kk77iJW7wxWjk6/XNHa1gBmb0yXMD6kiD2jinSUPkYeQ6Y2GPG5/5r4thQ7xTjtYro0k
         tQ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vwy/nvSACPs3saFn3MC2GpZOqXyVXmgpysdDNeISxL4=;
        b=PdxDr/xGkZOANSM1jBIjXDBYlPnBc81KQZqMVQZXZzHDEdMElf/Mytiw+sGXkOKAUj
         DHKGN9EO+L5QDLH/QNmVv0yIRGxHgyRxC5POSbJ7SFcREsMG457I890ygUTSTDKPvj+e
         h7WEo6V1csyuaf9Xnc27eMk1/4loHSrgUGrlRfo4m1wuqn+JTHPmKytlsbnqB3NNIAeL
         q2IfAdutoG1LEtVQhgMypt+u5QXNKrggjMuuOorxbK69b1cW3KaY7vAqSzrxrEHXEbCQ
         /vMs9huEeQtjYhgPfWv+ebVpS28e9To4UIjtJLjxdNdXICGpywz7ObGrWmI+fxWP9y9H
         /5BQ==
X-Gm-Message-State: AO0yUKUxuEfW+Sp+XPOwwStvbLUHBuMtUubohpnygRmACgTqeklIzd2W
        FIxKDh44ZMgLU2JNQMTw9x4=
X-Google-Smtp-Source: AK7set+7/LSgLUnPubFXxsFw4TXLoT5TlodOzauYcx+mvORzOE91ehJg5BdcehvsXAQ3G3HCcHMguA==
X-Received: by 2002:a17:90a:c782:b0:233:ab9b:f86a with SMTP id gn2-20020a17090ac78200b00233ab9bf86amr7033557pjb.8.1676559137218;
        Thu, 16 Feb 2023 06:52:17 -0800 (PST)
Received: from awkrail.localdomain.jp (p182177-ipngn200503kyoto.kyoto.ocn.ne.jp. [58.90.106.177])
        by smtp.gmail.com with ESMTPSA id y23-20020a17090abd1700b00233db0db3dfsm3388472pjr.7.2023.02.16.06.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 06:52:16 -0800 (PST)
From:   Taichi Nishimura <awkrail01@gmail.com>
To:     rdunlap@infradead.org
Cc:     andrii@kernel.org, ast@kernel.org, awkrail01@gmail.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        deso@posteo.net, haoluo@google.com, hawk@kernel.org,
        iii@linux.ibm.com, joannelkoong@gmail.com,
        john.fastabend@gmail.com, jolsa@kernel.org, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, llvm@lists.linux.dev,
        martin.lau@linux.dev, memxor@gmail.com, mykolal@fb.com,
        nathan@kernel.org, ndesaulniers@google.com, netdev@vger.kernel.org,
        sdf@google.com, shuah@kernel.org, song@kernel.org, trix@redhat.com,
        yhs@fb.com, ytcoode@gmail.com, gregkh@linuxfoundation.org
Subject: [Re: PATCH bpf-next] Fix typos in selftest/bpf files
Date:   Thu, 16 Feb 2023 23:51:45 +0900
Message-Id: <20230216145145.548183-1-awkrail01@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <4753a724-2fd4-3672-c7ce-0164fe759eea@infradead.org>
References: <4753a724-2fd4-3672-c7ce-0164fe759eea@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This text is not needed in the changelog for a patch, please read the
> section entitled "The canonical patch format" in the kernel file,
> Documentation/process/submitting-patches.rst for what is needed in order
> to properly describe the change.

> thanks,

> greg k-h

> Hi,
> The corrections all look good.
> Of course, you need to fix what Greg mentioned, then you can resubmit
> the patch with this added:

> Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

> Thanks.

Thank you for your reviewing and advices.
I am a beginner so they are helpful.

I read the docs and re-sent a patch.
After sending it, I found forgetting to reply to this thread...
Sorry in advance.
