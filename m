Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 906CC51A1EF
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 16:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351157AbiEDOQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 10:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239972AbiEDOQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 10:16:04 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5733A419B9;
        Wed,  4 May 2022 07:12:28 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id j6so993128qkp.9;
        Wed, 04 May 2022 07:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Psvejb3DIehY3FGS9OyKG4+k8ZBKjnluQzek7tyYtG0=;
        b=NVB19D360rzy8jza0DSZqGtGiZmC/x80ZU3H7ffmisxM/CTB+/votosoMhNguUMfTY
         WlYYS0N8ZD8z/v9Lg3OXnVYB5t6J29WqUnzVXKmr5OxRvWHyWn1SZnpD0pMSlmNXJttS
         W1W58AUFxiFeOe/JfNiK/O8waBaVshPzEL9nY5R0LOIjfQBy2Xq1PzgmWtJg0yN37azB
         0UkhuWM0/abUZ/KYz1gW/I9BREH4B4jb3Gbn0nm3yK3GIsepCC4RLdYjYcWaRQSs4RPN
         CELV+afKwSipQ1Bn0Hnzz27TM4DPrOhMvBdRhtH3Wn7VCl7j+DJptSiEJuumZoYgZ40z
         QEWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Psvejb3DIehY3FGS9OyKG4+k8ZBKjnluQzek7tyYtG0=;
        b=sBwWG877Vp2X7EyDElftfF2L54YIbwCvDliV+but8xND9RACDMBydL7guhj1ebb868
         Um1p6jJhxO8mS9TgUVZl/ihod7dRbkI//nXfYPxfPBIfb5t4pIuNy4DCJRm+Txt5ntGn
         EdYcqMIRhggf9f/6XGSnEwY9iUR1TlGF0Fg3Xtt+7bNOGATwFYL223b2XhWZE+cIPF4z
         b4tgaAy9WrOM4SV2h/40URGat9bJCAxndSOHCAnZJCUd1Ep8oXwEFdcDWKwlOBJlU1Pe
         5JAis5//s4chjE6rz76xyjrSLkaJF+1orLLbsIbd7PWk435vSRbZL3Vao/0KqxP4r1Un
         7Tuw==
X-Gm-Message-State: AOAM531m11k6IdR2AgIVMToozTNeyoYt/6JVLuRXN8n/KcAw0b1MTk9P
        VgXtkIX0Dl8ydb6ezeTaKOT43yjh/jhkD6ae89s=
X-Google-Smtp-Source: ABdhPJzz5bsZ8/aL9Y1deFid+bYg1ncUA1yDgx1BsSvWd8Twv3mzJ31ZoSG7kzsDEfKgcKrQ0EbXFGJdCiFmfS36M2U=
X-Received: by 2002:a37:9381:0:b0:69f:62c6:56a7 with SMTP id
 v123-20020a379381000000b0069f62c656a7mr16131554qkd.643.1651673547434; Wed, 04
 May 2022 07:12:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220503183750.1977-1-duguoweisz@gmail.com> <20220503194943.6bcmsxjvinfjrqxa@quack3.lan>
In-Reply-To: <20220503194943.6bcmsxjvinfjrqxa@quack3.lan>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 4 May 2022 17:12:16 +0300
Message-ID: <CAOQ4uxguXW05_YSpgT=kGgxztQYqhJ3x4MFsz9ZTO0crc9=4tA@mail.gmail.com>
Subject: Re: [PATCH] fsnotify: add generic perm check for unlink/rmdir
To:     Jan Kara <jack@suse.cz>
Cc:     Guowei Du <duguoweisz@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org,
        LSM List <linux-security-module@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>,
        Kees Cook <keescook@chromium.org>, anton@enomsg.org,
        ccross@android.com, tony.luck@intel.com, selinux@vger.kernel.org,
        duguowei <duguowei@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 3, 2022 at 10:49 PM Jan Kara <jack@suse.cz> wrote:
>
> On Wed 04-05-22 02:37:50, Guowei Du wrote:
> > From: duguowei <duguowei@xiaomi.com>
> >
> > For now, there have been open/access/open_exec perms for file operation,
> > so we add new perms check with unlink/rmdir syscall. if one app deletes
> > any file/dir within pubic area, fsnotify can sends fsnotify_event to
> > listener to deny that, even if the app have right dac/mac permissions.
> >
> > Signed-off-by: duguowei <duguowei@xiaomi.com>
>
> Before we go into technical details of implementation can you tell me more
> details about the usecase? Why do you need to check specifically for unlink
> / delete?
>
> Also on the design side of things: Do you realize these permission events
> will not be usable together with other permission events like
> FAN_OPEN_PERM? Because these require notification group returning file
> descriptors while your events will return file handles... I guess we should
> somehow fix that.
>

IMO, regardless of file descriptions vs. file handles, blocking events have
no business with async events in the same group at all.
What is the use case for that?
Sure, we have the legacy permission event, but if we do add new blocking
events to UAPI, IMO they should be added to a group that was initialized with a
different class to indicate "blocking events only".

And if we do that, we will not need to pollute the event mask namespace
for every permission event.
When users request to get FAN_UNLINK/FAN_RMDIR events in a
FAN_CLASS_PERMISSION group, internally, that only captures
events reported from fsnotify_perm()/fsnotify_path_perm().

FYI, I do intend to try and upload "pre-modify events" [1].
I had no intention to expose those in fanotify and my implementation
does not have the granularity of UNLINK/RMDIR, but we do need
to think about not duplicating too much code with those overlapping
features.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/fsnotify_pre_modify
