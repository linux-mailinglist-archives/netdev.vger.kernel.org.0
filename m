Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF94C67B778
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 17:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235772AbjAYQzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 11:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235401AbjAYQz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 11:55:29 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C070298E9
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 08:55:25 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-4ff1fa82bbbso225687847b3.10
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 08:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=49H+5dcfdqsESvQ4qNxkOgTxyGkRYtaMvRra0jMgwoI=;
        b=S433Z2p/j0oEnqzhdMbCoBVS6yLsoVuhPxi7PQkxnyRK8RoE5tlGqQCWFiSx/y2EvP
         VAUU6f5te6yd0FF3QKoXQk59fXSc40Ni99FjmOhoS8uoMeuhfG+AT8hg6vTHrAcNtls7
         iMIrnMdjSfEnhMBuERTLvpM6IdVwE9wobd2Cb3XY0VBKEUGGTBatMri522T6kyoxGdRv
         R/YHI2CzXA+66ssNNRD0kBHVPl8TI5ear6XOrgI2lTdtmT0YpMoSddNSDob6lG0ADoLk
         +xTQAwFZ3i/oeH+aroOYDwlOGwYRh8N7mvnq0HFpqRIYUl+jcTUyG7X+0g74P9WaFx1x
         4nDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=49H+5dcfdqsESvQ4qNxkOgTxyGkRYtaMvRra0jMgwoI=;
        b=aZpoyTHxaz6CxpK76ss+jBi24GHxElONp0xK9RDLmgxpyiv4LFmkclBxrtAtt2AAxs
         Ev92+hZUYyij1VOUUMlcIkFSC4roKVzZUWJPc2oEUkqj+OV9S05a6urWzilikRIUIKAV
         o3wAzq4q1AfEF+wWq4IjtUVl1Nt/5OZa+MU/F2nOxPM38k4ld/jXmfMzCRQSYGjaoIbc
         CSifFtcU3Lse6t2U+3ZbfZ2lMfuNUoZXDyfxjGTbvNPwxou/RKWL1I2CbHPCDbhjavz8
         L8fqKLjN53VWzEbSTRzk6e/x5LCyCqUXLVT4vXcanGoc0U7Z3Mdn7+UYtIids516T6bM
         Z7FQ==
X-Gm-Message-State: AO0yUKXwQWSNsMpczeuUcZQmbxDK5WtQo8ia/BxwqF3qddHafyiLlm/A
        o4/MxaI47v7KG1FevFDFyzcLsviWi9e82cale2sEHg==
X-Google-Smtp-Source: AK7set/FwLbWx6yiqkzvjcGbe3t+VxnD8xj+/iXHUbjRIwB0jRkvrcCR+VhH4DhOMzxTzJJlzd0h1TxaYfABci/YfRk=
X-Received: by 2002:a0d:d456:0:b0:507:26dc:ebd with SMTP id
 w83-20020a0dd456000000b0050726dc0ebdmr239978ywd.455.1674665724181; Wed, 25
 Jan 2023 08:55:24 -0800 (PST)
MIME-Version: 1.0
References: <20230125083851.27759-1-surenb@google.com> <20230125083851.27759-4-surenb@google.com>
 <Y9D2zXpy+9iyZNun@dhcp22.suse.cz>
In-Reply-To: <Y9D2zXpy+9iyZNun@dhcp22.suse.cz>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Wed, 25 Jan 2023 08:55:12 -0800
Message-ID: <CAJuCfpG7KWnj3J_t4nN1R4gfiM5jgjsiTfL55hNa=Uvz4E835g@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] mm: replace vma->vm_flags direct modifications
 with modifier calls
To:     Michal Hocko <mhocko@suse.com>
Cc:     akpm@linux-foundation.org, michel@lespinasse.org,
        jglisse@google.com, vbabka@suse.cz, hannes@cmpxchg.org,
        mgorman@techsingularity.net, dave@stgolabs.net,
        willy@infradead.org, liam.howlett@oracle.com, peterz@infradead.org,
        ldufour@linux.ibm.com, paulmck@kernel.org, luto@kernel.org,
        songliubraving@fb.com, peterx@redhat.com, david@redhat.com,
        dhowells@redhat.com, hughd@google.com, bigeasy@linutronix.de,
        kent.overstreet@linux.dev, punit.agrawal@bytedance.com,
        lstoakes@gmail.com, peterjung1337@gmail.com, rientjes@google.com,
        axelrasmussen@google.com, joelaf@google.com, minchan@google.com,
        jannh@google.com, shakeelb@google.com, tatashin@google.com,
        edumazet@google.com, gthelen@google.com, gurua@google.com,
        arjunroy@google.com, soheil@google.com, hughlynch@google.com,
        leewalsh@google.com, posk@google.com, will@kernel.org,
        aneesh.kumar@linux.ibm.com, npiggin@gmail.com,
        chenhuacai@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, richard@nod.at,
        anton.ivanov@cambridgegreys.com, johannes@sipsolutions.net,
        qianweili@huawei.com, wangzhou1@hisilicon.com,
        herbert@gondor.apana.org.au, davem@davemloft.net, vkoul@kernel.org,
        airlied@gmail.com, daniel@ffwll.ch,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, l.stach@pengutronix.de,
        krzysztof.kozlowski@linaro.org, patrik.r.jakobsson@gmail.com,
        matthias.bgg@gmail.com, robdclark@gmail.com,
        quic_abhinavk@quicinc.com, dmitry.baryshkov@linaro.org,
        tomba@kernel.org, hjc@rock-chips.com, heiko@sntech.de,
        ray.huang@amd.com, kraxel@redhat.com, sre@kernel.org,
        mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
        tfiga@chromium.org, m.szyprowski@samsung.com, mchehab@kernel.org,
        dimitri.sivanich@hpe.com, zhangfei.gao@linaro.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        dgilbert@interlog.com, hdegoede@redhat.com, mst@redhat.com,
        jasowang@redhat.com, alex.williamson@redhat.com, deller@gmx.de,
        jayalk@intworks.biz, viro@zeniv.linux.org.uk, nico@fluxnic.net,
        xiang@kernel.org, chao@kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, miklos@szeredi.hu,
        mike.kravetz@oracle.com, muchun.song@linux.dev, bhe@redhat.com,
        andrii@kernel.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, perex@perex.cz, tiwai@suse.com,
        haojian.zhuang@gmail.com, robert.jarzmik@free.fr,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-graphics-maintainer@vmware.com,
        linux-ia64@vger.kernel.org, linux-arch@vger.kernel.org,
        loongarch@lists.linux.dev, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org,
        linux-um@lists.infradead.org, linux-acpi@vger.kernel.org,
        linux-crypto@vger.kernel.org, nvdimm@lists.linux.dev,
        dmaengine@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, etnaviv@lists.freedesktop.org,
        linux-samsung-soc@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-mediatek@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        freedreno@lists.freedesktop.org,
        linux-rockchip@lists.infradead.org, linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org, sparclinux@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-staging@lists.linux.dev,
        target-devel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
        devel@lists.orangefs.org, kexec@lists.infradead.org,
        linux-xfs@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, kasan-dev@googlegroups.com,
        selinux@vger.kernel.org, alsa-devel@alsa-project.org,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 1:30 AM 'Michal Hocko' via kernel-team
<kernel-team@android.com> wrote:
>
> On Wed 25-01-23 00:38:48, Suren Baghdasaryan wrote:
> > Replace direct modifications to vma->vm_flags with calls to modifier
> > functions to be able to track flag changes and to keep vma locking
> > correctness.
>
> Is this a manual (git grep) based work or have you used Coccinele for
> the patch generation?

It was a manual "search and replace" and in the process I temporarily
renamed vm_flags to ensure I did not miss any usage.

>
> My potentially incomplete check
> $ git grep ">[[:space:]]*vm_flags[[:space:]]*[&|^]="
>
> shows that nothing should be left after this. There is still quite a lot
> of direct checks of the flags (more than 600). Maybe it would be good to
> make flags accessible only via accessors which would also prevent any
> future direct setting of those flags in uncontrolled way as well.

Yes, I think Peter's suggestion in the first patch would also require
that. Much more churn but probably worth it for the future
maintenance. I'll add a patch which converts all readers as well.

>
> Anyway
> Acked-by: Michal Hocko <mhocko@suse.com>

Thanks for all the reviews!

> --
> Michal Hocko
> SUSE Labs
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
