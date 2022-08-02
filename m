Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17853588395
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 23:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbiHBV3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 17:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233053AbiHBV3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 17:29:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B081A51A37
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 14:29:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5947DB820FF
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 21:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C734C433B5
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 21:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659475774;
        bh=SGZd11R+IMi10UvAspXhHJm/sz8ulVf0IdRmfkUbaoM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XaKvbothBFggIhXI28kL/x3EirQ4fjLEMykMyvw2b1YJ4pm0LhSydX3OFqj6DB12M
         NIa/HIAGw5Duv1+M9JsF5VKcf9EAlb5fnsujl17cy7bG9MzzKwoOFLDG4Jp6ImZqto
         AGBdf/q/FIaZi8jFrciL5R9mgJS0UQZ4vApdF0mNCXMi0IF8yAO5KsPyO8Qhr9h9f5
         9jwyD8YkWxw+ffoDoe6YVCfS37CyfEAO7p8Dsq7+dPYjRXCRjCXwJvWxWX4LJyhg67
         XRwsXic292ebl7E/0bgnjfJaV1SjpzfKAyzAu4qxYFtpSfSInGcUfFLxChz3OW+Jtu
         hSCen8HnDa99g==
Received: by mail-oo1-f45.google.com with SMTP id v5-20020a4aa505000000b00435b0bb4227so2718291ook.12
        for <netdev@vger.kernel.org>; Tue, 02 Aug 2022 14:29:34 -0700 (PDT)
X-Gm-Message-State: AJIora9c1g11nJZG9y/7uinp5CvKm4IskbeME+BifoFWJL7+Rc8jNnCx
        kXjIdC6mTOiB5GDdXmuV+JBjeSWmTWJ1tbWtGFRvKQ==
X-Google-Smtp-Source: AA6agR4gDjxO8eQIdJP2ak/bQJj6aSqPJNBmfbIMRPjX7q3qBHZva2gJEgK5hCAMdBGldKbha+0RtVlrHChFByEI3nI=
X-Received: by 2002:a05:6902:1541:b0:675:4f34:7315 with SMTP id
 r1-20020a056902154100b006754f347315mr18285149ybu.65.1659475762836; Tue, 02
 Aug 2022 14:29:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220801180146.1157914-1-fred@cloudflare.com> <20220801180146.1157914-3-fred@cloudflare.com>
In-Reply-To: <20220801180146.1157914-3-fred@cloudflare.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Tue, 2 Aug 2022 23:29:12 +0200
X-Gmail-Original-Message-ID: <CACYkzJ7Oxb8dhM6SotKfS30i2_=ONbd=LF2qB6ZCpYqRFtDx+A@mail.gmail.com>
Message-ID: <CACYkzJ7Oxb8dhM6SotKfS30i2_=ONbd=LF2qB6ZCpYqRFtDx+A@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] bpf-lsm: Make bpf_lsm_userns_create() sleepable
To:     Frederick Lawler <fred@cloudflare.com>
Cc:     revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, serge@hallyn.com, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        shuah@kernel.org, brauner@kernel.org, casey@schaufler-ca.com,
        ebiederm@xmission.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@cloudflare.com,
        cgzones@googlemail.com, karl@bigbadwolfsecurity.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 1, 2022 at 8:02 PM Frederick Lawler <fred@cloudflare.com> wrote:
>
> Users may want to audit calls to security_create_user_ns() and access
> user space memory. Also create_user_ns() runs without
> pagefault_disabled(). Therefore, make bpf_lsm_userns_create() sleepable
> for mandatory access control policies.
>
> Signed-off-by: Frederick Lawler <fred@cloudflare.com>
> Acked-by: Christian Brauner (Microsoft) <brauner@kernel.org>

Acked-by: KP Singh <kpsingh@kernel.org>
