Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8EC62D1D0
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 04:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbiKQDo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 22:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbiKQDoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 22:44:55 -0500
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C4861B84
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 19:44:54 -0800 (PST)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-39115d17f3dso976597b3.1
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 19:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mX/nVVLR77rl9DUJUGIPDy2hSVN2IuYJAyXn0XHxv7c=;
        b=cP7nrbODehEq41oxats2cCXRpCH3pgtt27PbJxs7RbS06z34/NEe4qwUp4RITt1nt1
         D/+HUWdgQAzDfbnGNQt0SNs5qqtb7DwaTu4c/0wDA9k1Mr5ov9IIVAqZj/kXjmCZFWoR
         /9RKa/XwGL88By0mdsQ7RUST7DpM3xlbnGbjQiVnvUZVz+ypi1ljTwI7tQMHNPfptF5a
         0bOC1eb3DC4AqpsSdu1TBTTXy1odyyGyw99u5V9ow9IYRYZz+X66gW39g8t0wfcvT3mw
         mA/jDa11l/7qpNohYGDSOga5+DA8QS9s5UQ0Nc5VfcaEkybbSDsi01PW+1wLp2LblJ52
         Mh4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mX/nVVLR77rl9DUJUGIPDy2hSVN2IuYJAyXn0XHxv7c=;
        b=HddAtHv9Ht6h0zsX5XgG2UIDHHo6YNAhf47PbGomfiyb4f6Js6NAJ+lAe4q3dt+bOM
         zYl2/DuZ/sDh82K9FcOwzR+iBy2MQB6MQa+j7z+2x6a9KWbL37HyKljNZ/gbymNMMDvD
         qyLlrgbMD8zIerx1GhO+dE+gELx+DkWx2+ACe+wPz0Etj0Realvly1dhUyaSnIdH31Yd
         TNUQabh4BNiFuWRnZPWIpK9N/x6LSQxPIA/gBJMg62rD2CbxOIvSUDtVpL+in9rsbYwV
         zxYdIMeamyiufdtJQlq35uj0clNU2Kwy2qApOAjNDG9ZBE4rfl+Eeq/c7l82ieNH1XUn
         do7w==
X-Gm-Message-State: ANoB5pk56riw7xw9fgLZip1NBVVDtk6Me8c0Oox4yIQShKrpQQUbxh2m
        tXFAuJqWYmxbCE/F6kuOfZPfG28VS4a6FeFkD93rQA==
X-Google-Smtp-Source: AA0mqf4ND4dr0qcwB0X64sQlUuAXu8iyuw4JOxhuWSakyAMfQKzY2rMLgSiX+xKDzhLZGfkZfM4rN3c8+1+X8QDR9bU=
X-Received: by 2002:a0d:c103:0:b0:370:7a9a:564 with SMTP id
 c3-20020a0dc103000000b003707a9a0564mr427025ywd.278.1668656693295; Wed, 16 Nov
 2022 19:44:53 -0800 (PST)
MIME-Version: 1.0
References: <20221117031551.1142289-1-joel@joelfernandes.org> <20221117031551.1142289-3-joel@joelfernandes.org>
In-Reply-To: <20221117031551.1142289-3-joel@joelfernandes.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 16 Nov 2022 19:44:41 -0800
Message-ID: <CANn89i+gKVdveEtR9DX15Xr7E9Nn2my6SEEbXTMmxbqtezm2vg@mail.gmail.com>
Subject: Re: [PATCH rcu/dev 3/3] net: Use call_rcu_flush() for dst_destroy_rcu
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, rcu@vger.kernel.org,
        rostedt@goodmis.org, paulmck@kernel.org, fweisbec@gmail.com
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

On Wed, Nov 16, 2022 at 7:16 PM Joel Fernandes (Google)
<joel@joelfernandes.org> wrote:
>
> In a networking test on ChromeOS, we find that using the new CONFIG_RCU_LAZY
> causes a networking test to fail in the teardown phase.
>
> The failure happens during: ip netns del <name>

And ? What happens then next ?

>
> Using ftrace, I found the callbacks it was queuing which this series fixes. Use
> call_rcu_flush() to revert to the old behavior. With that, the test passes.

What is this test about ? What barrier was used to make it not flaky ?

Was it depending on some undocumented RCU behavior ?

Maybe adding a sysctl to force the flush would be better for functional tests ?

I would rather change the test(s), than adding call_rcu_flush(),
adding merge conflicts to future backports.
