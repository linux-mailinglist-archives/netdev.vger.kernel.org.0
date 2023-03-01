Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B426A648F
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 02:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjCABHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 20:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjCABHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 20:07:34 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE1A2FCD8
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 17:07:31 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id o12so47537207edb.9
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 17:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1677632850;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GA/g+K3G8Gm+uzhNLjPprz2bSCPjjGvaQ1drgLyoaRU=;
        b=LWD1p8mh7yZwlcEm5G+HkZ/9fYNdzlueMz7KUl72WwvJ8bPw6w23ruCtZHOEwrEEMY
         Sw3zxKz/YzgnJ9pwj0rGrnrMB5YXWUyMSu8bpCslnrZG119Q3qtAWz2E/HBmNd1fbMKi
         K0jyUnUp7jn0WnmMbjkDcUO+2OPKQjvakoIT4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677632850;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GA/g+K3G8Gm+uzhNLjPprz2bSCPjjGvaQ1drgLyoaRU=;
        b=W9lcM6yC9dVU3IZ4fn5PimFd7hYUc3oqNIKTLDqPIKEl0sJyLNcn6t2rya1/7O2Rl4
         FwkOnELnybI+5L3i9nyAXLkfcLItNgb9lVIe0s4/OopOOS1lgli0Zvn4SMNznTjqiwbM
         KvrMoMYIimXbYny78lcwAGn3TmVb0+WzQaoFJR39Tj+KWWZCdzzlldVl9Jn+cetld0oc
         icY536G82deYQ9OJfbMmtPE2dWadyo0CACp9QAfjzCApuFvZtLT83yJDqdXsPjYYoKCU
         kJ+1bXh3nG4+dbCaKFf/X9bhipwKSnZ2of+bAELyt/7UcKSLuXhgvp515NhoqLzft/tR
         v48Q==
X-Gm-Message-State: AO0yUKXNFTNrwi61POwfAmpxDBSZyJamIRhTBorqfhc+Ba/4voB2fqva
        pSTyAVRrZakDYmp5+qBrGsTohxVi+8YIuPdm2Wk=
X-Google-Smtp-Source: AK7set8iETK9tVhd6dn6EGYGTEJK4zmXJy9RtrdoYs3S/Eh2udLuF3X1MlZ9/zbsNJG4Qr2jqlS9DQ==
X-Received: by 2002:a17:906:aaca:b0:878:6477:d7 with SMTP id kt10-20020a170906aaca00b00878647700d7mr4372725ejb.72.1677632849840;
        Tue, 28 Feb 2023 17:07:29 -0800 (PST)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id r22-20020a50aad6000000b004af6a7e9131sm4914529edc.64.2023.02.28.17.07.28
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Feb 2023 17:07:28 -0800 (PST)
Received: by mail-ed1-f53.google.com with SMTP id cq23so47723585edb.1
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 17:07:28 -0800 (PST)
X-Received: by 2002:a17:906:c08c:b0:8f1:4cc5:f14c with SMTP id
 f12-20020a170906c08c00b008f14cc5f14cmr2345984ejz.0.1677632847945; Tue, 28 Feb
 2023 17:07:27 -0800 (PST)
MIME-Version: 1.0
References: <20230228132118.978145284@linutronix.de> <20230228132910.991359171@linutronix.de>
 <CAHk-=wjeMbHK61Ee+Ug4w8AGHCSDx94GuLs5bPXhHNhA_+RjzA@mail.gmail.com>
In-Reply-To: <CAHk-=wjeMbHK61Ee+Ug4w8AGHCSDx94GuLs5bPXhHNhA_+RjzA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linuxfoundation.org>
Date:   Tue, 28 Feb 2023 17:07:11 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiGA91ca02-J0ebAnCE1wA_=Q35MiFz4ONo3Zw76uFxNQ@mail.gmail.com>
Message-ID: <CAHk-=wiGA91ca02-J0ebAnCE1wA_=Q35MiFz4ONo3Zw76uFxNQ@mail.gmail.com>
Subject: Re: [patch 2/3] atomics: Provide rcuref - scalable reference counting
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Wangyang Guo <wangyang.guo@intel.com>,
        Arjan Van De Ven <arjan.van.de.ven@intel.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 4:42=E2=80=AFPM Linus Torvalds
<torvalds@linuxfoundation.org> wrote:
>
> And yes, that may mean that it should have some architecture-specific
> code (with fallback defaults for the generic case).

Another reason for architecture-specific code is that anybody who
doesn't have atomics and just relies on an LL/SC model is actually
better of *not* having any of this complexity.

In fact, the Intel RAO instruction set would likely do that on x86
too. With that alleged future "CMPccXADD", there likely is no longer
any advantage to this model of rcuref.

Now, I don't know when - if ever - said RAO instruction set extension
comes, but I'd hope that the new scalable reference counting would be
ready for it.

             Linus
