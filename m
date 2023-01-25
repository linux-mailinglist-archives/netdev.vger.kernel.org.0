Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42AC867B7A2
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 17:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235516AbjAYQ6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 11:58:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235772AbjAYQ6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 11:58:16 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45AC133
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 08:58:06 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id m199so8038117ybm.4
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 08:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G/HaQvIeifLKJJp6JsBUTA/Cu0PG4HCFXOBV2LCBpGc=;
        b=ngnRJahtqVxSN6UIjLqWU+1aTxdIhv7re4hDfLrN8LXncI6BNG1ZwqGy4tzOTLxPiH
         4VWOIuHk0tMtzp4F11bJV5cn9qN75X4TjPW2iyn4nOIj2Y2qsTa18wfmHkOGhLKlmZoS
         vXpRc/g/QGDtReYNnPGF6rlvG7jz8sM8MsRTR7LhXioKCpHgDgO7fKBddw0dzS48JeET
         78piPZYcyZX9vIYyfAzpklatM6XnaaFqr/b+XLZlxI1Y0y+wCHWFOsnbVElEi6T+CQOb
         4zMPa96gAXD4xbmjnQv7nMUvo5bgJJEK/r3Eu0NIV8f4SPGC7eT5IU6zl2RkKdozGWcK
         sknQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G/HaQvIeifLKJJp6JsBUTA/Cu0PG4HCFXOBV2LCBpGc=;
        b=bLGqbrWwmcuw9/LfdeHSDAy6MCAJXJPVfPUe6ny3Ll4aZafPLRdOefjLCbezHKvHPl
         1W4BhsvPof8yfH9shFDSDHc0wV7EpyBRmPZ4/MtclYRd7REy1n98AEIc4phh2jJzW3Fr
         v96RyOg5R0yl6kxwqqHEz+orE/Da1t3cRfU+u7XZX4cbxjx5bWbcGZKg5ppCOpk3ahPe
         FNOmNOek0WY72JgnyP6GAeYFgBYojwPVi+Ud1Z0HY2bJnhXuki9Sdrpl/RqbmbNy48k7
         U13PbTDRHcF4cdkNHdpuxRC8526h6yeODjc8MsPcxG4f7jvPtcUANSa+jTHl95uID+WK
         BJnw==
X-Gm-Message-State: AO0yUKVjQ4S/kDphM8hk7GflRDu10a46EsRl67RN14lSepEi+GE0C8ID
        k1kOxbIAKU69JMR6UsTZH6CbqgL/eWUeclOkRZNJqg==
X-Google-Smtp-Source: AK7set97wrc43TM0/ovVONCfpWDKrtFzkyYmNKL3FW97qdU/yOGMPZssBTWD4MRF2UhZkPfEz4JLEj3/xF1loldnjYM=
X-Received: by 2002:a25:ad02:0:b0:80b:6fd3:84d3 with SMTP id
 y2-20020a25ad02000000b0080b6fd384d3mr714673ybi.316.1674665880846; Wed, 25 Jan
 2023 08:58:00 -0800 (PST)
MIME-Version: 1.0
References: <20230125083851.27759-1-surenb@google.com> <20230125083851.27759-5-surenb@google.com>
 <Y9D4rWEsajV/WfNx@dhcp22.suse.cz>
In-Reply-To: <Y9D4rWEsajV/WfNx@dhcp22.suse.cz>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Wed, 25 Jan 2023 08:57:48 -0800
Message-ID: <CAJuCfpGd2eG0RSMte9OVgsRVWPo+Sj7+t8EOo8o_iKzZoh1MXA@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] mm: replace vma->vm_flags indirect modification in ksm_madvise
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

On Wed, Jan 25, 2023 at 1:38 AM 'Michal Hocko' via kernel-team
<kernel-team@android.com> wrote:
>
> On Wed 25-01-23 00:38:49, Suren Baghdasaryan wrote:
> > Replace indirect modifications to vma->vm_flags with calls to modifier
> > functions to be able to track flag changes and to keep vma locking
> > correctness. Add a BUG_ON check in ksm_madvise() to catch indirect
> > vm_flags modification attempts.
>
> Those BUG_ONs scream to much IMHO. KSM is an MM internal code so I
> gueess we should be willing to trust it.

Yes, but I really want to prevent an indirect misuse since it was not
easy to find these. If you feel strongly about it I will remove them
or if you have a better suggestion I'm all for it.

>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> Acked-by: Michal Hocko <mhocko@suse.com>
> --
> Michal Hocko
> SUSE Labs
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
