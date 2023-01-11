Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF7AE665765
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238535AbjAKJ2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238525AbjAKJ1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:27:12 -0500
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315E36430
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:26:25 -0800 (PST)
Received: by mail-io1-f71.google.com with SMTP id be25-20020a056602379900b006f166af94d6so8607674iob.8
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:26:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G1bwp68gAWsUOZW4RECodPiofiO1XXH/Q4722U5Mfno=;
        b=UI+0I4a5SdSwMfkob0ou63OF6ipVKWmJhZQLIUawuWNBgsjTpGc4FgGt4CgyNe2cMA
         S3hOh6ME/WGAu8fw1QauLoopKx+tEhtDXj7mPZ7u5GWFxgH36K5jJpRDXvV4h97bILfR
         GsaTGMf3EPH2MxDvRwZMEzV3oxlk18Xxg66TW/8UVxzXhMEEJDvelC1GofyTCgCIzFl5
         P72xwNeSMrSfRatnwVeRdxLRVKyfpT/SHK24wt+hBXsMxo9O1gYJNi65eq3YRJIRYz9V
         3yB0qIiFbmPwQWOQ+WR007Y1Zru7A/Z4XIBFjkIMOv/J+RK8Fo82rU9qOBFIX3TMsyQ2
         zayA==
X-Gm-Message-State: AFqh2krYV9bXj/RyJYJ+lFQYLdEVrPfh+7F/C/bP6BBJXpYRd4FGW4eO
        7q06ZxqbnUhI+aEz5cfxz0duev6RdJfgxtarIRll9S9dCpsf
X-Google-Smtp-Source: AMrXdXuddnLe3VxVd5wsclm0js7M5hizTyAyr0FScpDsPnEyue1zmnnsi6cQwd0NWKMW3xemr8q9qKa1g0hxSlUBxAiVn5MJfTa+
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3f18:b0:38d:30a7:2ae0 with SMTP id
 ck24-20020a0566383f1800b0038d30a72ae0mr7083175jab.234.1673429184700; Wed, 11
 Jan 2023 01:26:24 -0800 (PST)
Date:   Wed, 11 Jan 2023 01:26:24 -0800
In-Reply-To: <2263420.1673429178@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001c6a5505f1f99893@google.com>
Subject: Re: [syzbot] kernel BUG in rxrpc_put_call
From:   syzbot <syzbot+4bb6356bb29d6299360e@syzkaller.appspotmail.com>
To:     dhowells@redhat.com
Cc:     davem@davemloft.net, dhowells@redhat.com, edumazet@google.com,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, marc.dionne@auristor.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> #syz test: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git

want 2 args (repo, branch), got 5

>
> diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
> index 3ded5a24627c..f3c9f0201c15 100644
> --- a/net/rxrpc/call_object.c
> +++ b/net/rxrpc/call_object.c
> @@ -294,7 +294,7 @@ static void rxrpc_put_call_slot(struct rxrpc_call *call)
>  static int rxrpc_connect_call(struct rxrpc_call *call, gfp_t gfp)
>  {
>  	struct rxrpc_local *local = call->local;
> -	int ret = 0;
> +	int ret = -ENOMEM;
>  
>  	_enter("{%d,%lx},", call->debug_id, call->user_call_ID);
>  
>
